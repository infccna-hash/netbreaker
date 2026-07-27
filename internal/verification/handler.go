package verification

import (
	"context"
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"regexp"
	"strconv"
	"time"

	"github.com/go-chi/chi/v5"
	"github.com/google/uuid"

	"netbreaker.io/api/internal/auth"
	"netbreaker.io/api/internal/labsession"
	"netbreaker.io/api/internal/progress"
	"netbreaker.io/api/internal/verify"
	"netbreaker.io/api/pkg/config"
	"netbreaker.io/api/pkg/response"
)

type Handler struct {
	progressRepo *progress.Repository
	sessionRepo  *labsession.Repository
	verifyReg    *verify.VerifierRegistry
	cfg          *config.Config
}

func NewHandler(progressRepo *progress.Repository, sessionRepo *labsession.Repository, verifyReg *verify.VerifierRegistry, cfg *config.Config) *Handler {
	return &Handler{
		progressRepo: progressRepo,
		sessionRepo:  sessionRepo,
		verifyReg:    verifyReg,
		cfg:          cfg,
	}
}

// POST /api/v1/labs/{id}/verify
//
// Two paths:
//  1. Feature flag OFF (default) → uses the suspended legacy verifier
//     (always Passed: false). Same behavior as before the migration.
//  2. Feature flag ON + session_id provided → resolves the live lab
//     session, wires the console-truth verifier if one is registered
//     for (labID, phase), and runs real device checks. Falls back to
//     the suspended legacy verifier if no console-truth verifier is
//     registered (never auto-passes).
func (h *Handler) Verify(w http.ResponseWriter, r *http.Request) {
	ctx := r.Context()

	labID, err := strconv.Atoi(chi.URLParam(r, "id"))
	if err != nil || labID < 1 {
		response.Error(w, http.StatusBadRequest, "invalid lab id")
		return
	}

	var req VerifyRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		response.Error(w, http.StatusBadRequest, "invalid request body")
		return
	}
	if req.Phase != "build" && req.Phase != "attack" && req.Phase != "harden" {
		response.Error(w, http.StatusBadRequest, "phase must be build, attack, or harden")
		return
	}

	// ── Path 1: feature flag OFF → suspended legacy verifier ──────────
	if !h.cfg.VerifyConsoleTruthEnabled {
		res := h.legacyVerify(labID, req.Phase, req.Config)
		h.maybeMarkProgress(ctx, res, labID, req.Phase)
		response.JSON(w, http.StatusOK, res)
		return
	}

	// ── Path 2: feature flag ON → console-truth ──────────────────────
	if req.SessionID == "" {
		response.Error(w, http.StatusBadRequest, "session_id is required")
		return
	}

	sessionID, err := uuid.Parse(req.SessionID)
	if err != nil {
		response.Error(w, http.StatusBadRequest, "invalid session_id")
		return
	}

	res := h.consoleTruthVerify(ctx, sessionID, labID, req.Phase)
	h.maybeMarkProgress(ctx, res, labID, req.Phase)
	response.JSON(w, http.StatusOK, res)
}

// legacyVerify runs the old verifier path (suspended or generic), which
// always returns Passed: false. The inner verifier logic is preserved
// inside suspendedVerifier for hints, but Passed is forced to false.
func (h *Handler) legacyVerify(labID int, phase string, cfg map[string]DeviceConfig) VerifyResult {
	verifier, err := Get(labID)
	if err != nil {
		return VerifyResult{
			Passed:  false,
			Score:   0,
			Message: "verification not available for this lab yet",
		}
	}
	return verifier.Verify(phase, cfg)
}

// consoleTruthVerify resolves the live session and dispatches to the
// console-truth verifier registered for (labID, phase). If no console-
// truth verifier is registered, falls back to the legacy (suspended)
// path — never auto-passes.
func (h *Handler) consoleTruthVerify(ctx context.Context, sessionID uuid.UUID, labID int, phase string) VerifyResult {
	claims := auth.ClaimsFromCtx(ctx)
	userID, err := uuid.Parse(claims.Subject)
	if err != nil {
		return VerifyResult{Passed: false, Score: 0, Message: "invalid authentication"}
	}

	// ── Look up session ──────────────────────────────────────────────
	sess, err := h.sessionRepo.GetByID(ctx, sessionID)
	if err != nil {
		return VerifyResult{Passed: false, Score: 0, Message: "session not found"}
	}
	if sess.UserID != userID {
		return VerifyResult{Passed: false, Score: 0, Message: "session does not belong to this user"}
	}
	if sess.Status != labsession.StatusRunning {
		return VerifyResult{Passed: false, Score: 0, Message: fmt.Sprintf("session is not running (status=%s)", sess.Status)}
	}

	// ── Check if a console-truth verifier is registered ──────────────
	fn := h.verifyReg.Lookup(labID, phase)
	if fn == nil {
		log.Printf("verify: no console-truth verifier registered for lab %d / %s — falling back to legacy", labID, phase)
		return h.legacyVerify(labID, phase, nil)
	}

	// ── Resolve session → verify.LabSession ──────────────────────────
	vs := labsession.ResolveVerifySession(sess, h.cfg.GNS3ComputeHost)

	// ── Find the IOU switch node (all verify assertions target one switch) ──
	switchNode := findSwitchNode(sess.NodeMap)
	if switchNode == "" {
		return VerifyResult{Passed: false, Score: 0, Message: "no IOU switch found in lab topology"}
	}

	// ── Build collector for the switch ─────────────────────────────────
	runner := verify.NewTelnetConsoleRunner(h.cfg.GNS3ComputeHost, vs.ConsoleNodes)
	collector := &verify.IOSCollector{
		Console:  runner,
		NodeID:   switchNode,
		PromptRe: iosPromptRe,
	}

	// ── Run the verifier with a hard deadline ────────────────────────
	// Use a background context so chi's Timeout(30s) middleware doesn't
	// cancel the request before the verify completes. The 30s deadline
	// on verifyCtx is the one that matters — if the console hangs, we
	// record a failed attempt instead of returning a hung HTTP request.
	verifyCtx, cancel := context.WithTimeout(context.Background(), 30*time.Second)
	defer cancel()

	result := fn(vs).Run(verifyCtx, collector)
	if verifyCtx.Err() != nil {
		return VerifyResult{
			Passed:  false,
			Score:   0,
			Failures: checkFailures(result.Checks),
			Hints:    checkHints(result.Checks),
			Message:  "verification timed out — console may be unresponsive. Try again.",
		}
	}

	return VerifyResult{
		Passed:   result.Passed,
		Score:    computeScore(result.Checks),
		Failures: checkFailures(result.Checks),
		Hints:    checkHints(result.Checks),
		Message:  verifyMessage(result),
	}
}

// iosPromptRe matches IOS-like prompts (Router#, Switch#, etc.).
var iosPromptRe = regexp.MustCompile(`\S+[#>]\s*$`)

// findSwitchNode returns the name of the first IOU switch in the node map,
// or "" if none exists. The console-truth verifier probes this switch.
func findSwitchNode(nm labsession.NodeMap) string {
	for name, info := range nm {
		if info.NodeType == "iou" {
			return name
		}
	}
	return ""
}

// checkFailures extracts failure messages from verify checks.
func checkFailures(checks []verify.Check) []string {
	var out []string
	for _, c := range checks {
		if !c.Passed {
			out = append(out, c.Name)
		}
	}
	return out
}

// checkHints extracts hints from verify checks.
func checkHints(checks []verify.Check) []string {
	var out []string
	for _, c := range checks {
		if !c.Passed && c.Detail != "" {
			out = append(out, c.Detail)
		}
	}
	return out
}

// computeScore derives a 0-100 score from the check results.
func computeScore(checks []verify.Check) int {
	if len(checks) == 0 {
		return 100
	}
	passed := 0
	for _, c := range checks {
		if c.Passed {
			passed++
		}
	}
	return (passed * 100) / len(checks)
}

// verifyMessage builds a human-readable summary.
func verifyMessage(r verify.VerifyResult) string {
	if r.Passed {
		return "All objectives met — phase complete!"
	}
	failed := 0
	for _, c := range r.Checks {
		if !c.Passed {
			failed++
		}
	}
	return fmt.Sprintf("%d objective(s) not yet complete.", failed)
}

// maybeMarkProgress persists progress when verification passes.
// Idempotent — Mark uses ON CONFLICT DO NOTHING.
func (h *Handler) maybeMarkProgress(ctx context.Context, res VerifyResult, labID int, phase string) {
	if !res.Passed {
		return
	}
	claims := auth.ClaimsFromCtx(ctx)
	userID, err := uuid.Parse(claims.Subject)
	if err != nil {
		return
	}
	_ = h.progressRepo.Mark(ctx, userID, labID, phase)
}
