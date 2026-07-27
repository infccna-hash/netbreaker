package verification

import (
	"context"
	"net/http"
	"net/http/httptest"
	"strings"
	"testing"

	"github.com/go-chi/chi/v5"
	"github.com/google/uuid"

	"netbreaker.io/api/internal/auth"
	"netbreaker.io/api/internal/labsession"
	"netbreaker.io/api/internal/verify"
	"netbreaker.io/api/pkg/config"
	jwtutil "netbreaker.io/api/pkg/jwt"
)

// ── Regression tests for session ownership authorization (handoff #5) ──
//
// The vulnerability this guards against: a student with a valid JWT
// sends another student's session_id to the verify endpoint. Without
// the sess.UserID != userID check, verification would run against a
// session the attacker doesn't own — potentially advancing progress
// on someone else's lab.
//
// These tests confirm that the authorization check in
// consoleTruthVerify (handler.go:127) rejects cross-user session IDs
// with an explicit message, not a generic "session not found" or a
// nil-pointer panic.

// ── fake session repository ───────────────────────────────────────

type fakeSessionRepo struct {
	sessions map[uuid.UUID]*labsession.Session
	err      error // if set, GetByID returns this error
}

func (f *fakeSessionRepo) GetByID(_ context.Context, id uuid.UUID) (*labsession.Session, error) {
	if f.err != nil {
		return nil, f.err
	}
	s, ok := f.sessions[id]
	if !ok {
		return nil, labsession.ErrNotFound
	}
	return s, nil
}

// ── helpers ────────────────────────────────────────────────────────

func makeTestHandler(repo *fakeSessionRepo, reg *verify.VerifierRegistry) *Handler {
	if reg == nil {
		reg = verify.NewVerifierRegistry()
	}
	return &Handler{
		sessionRepo: repo,
		sessionSvc:  nil, // safe: never reached in rejection paths
		verifyReg:   reg,
		cfg:         &config.Config{VerifyConsoleTruthEnabled: true},
	}
}

func ctxWithUser(userID uuid.UUID) context.Context {
	claims := &jwtutil.Claims{}
	claims.Subject = userID.String()
	return auth.CtxWithClaims(context.Background(), claims)
}

func sessionWithOwner(id, ownerID uuid.UUID) *labsession.Session {
	return &labsession.Session{
		ID:      id,
		UserID:  ownerID,
		Status:  labsession.StatusRunning,
		NodeMap: map[string]labsession.NodeInfo{"SW1": {ConsolePort: 5000}},
	}
}

// chiRouterWithUser builds a minimal chi router with the verify handler
// mounted, and a middleware that injects the given user's claims into
// the request context — simulating what JWTMiddleware does in production.
func chiRouterWithUser(h *Handler, userID uuid.UUID) chi.Router {
	r := chi.NewRouter()
	r.Use(func(next http.Handler) http.Handler {
		return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
			claims := &jwtutil.Claims{}
			claims.Subject = userID.String()
			ctx := auth.CtxWithClaims(r.Context(), claims)
			next.ServeHTTP(w, r.WithContext(ctx))
		})
	})
	r.Post("/api/v1/labs/{id}/verify", h.Verify)
	return r
}

// ── Tests ──────────────────────────────────────────────────────────

// TestCrossUserSessionRejectedAtVerify verifies that sending another
// student's session_id to the verify endpoint is caught by the
// sess.UserID != userID check and returns an explicit "does not
// belong" message — not a panic, not "session not found", not a
// successful verify. This regression test exists because the original
// credential-issuance vulnerability started with a missing ownership
// check; a future refactor that removes the check must fail here.
func TestCrossUserSessionRejectedAtVerify(t *testing.T) {
	userA := uuid.New()
	userB := uuid.New()
	sessionFromA := uuid.New()

	repo := &fakeSessionRepo{
		sessions: map[uuid.UUID]*labsession.Session{
			sessionFromA: sessionWithOwner(sessionFromA, userA),
		},
	}

	h := makeTestHandler(repo, nil)

	// User B tries to verify session owned by user A.
	ctx := ctxWithUser(userB)
	res := h.consoleTruthVerify(ctx, sessionFromA, 1, "build")

	if res.Passed {
		t.Fatal("cross-user verify must not pass")
	}
	if !strings.Contains(strings.ToLower(res.Message), "does not belong") {
		t.Fatalf("expected 'does not belong' message for cross-user verify, got: %q", res.Message)
	}
}

// TestOwnSessionVerifyNotRejected confirms the authorization check
// does NOT reject when the owner verifies their own session. Verifies
// that the check is an ownership gate, not a broad rejection.
func TestOwnSessionVerifyNotRejected(t *testing.T) {
	user := uuid.New()
	sessionID := uuid.New()

	repo := &fakeSessionRepo{
		sessions: map[uuid.UUID]*labsession.Session{
			sessionID: sessionWithOwner(sessionID, user),
		},
	}

	h := makeTestHandler(repo, nil)

	// Owner verifies their own session — should NOT fail at
	// authorization (will fail later at TryLock since sessionSvc
	// is nil, but must not fail with cross-user rejection).
	ctx := ctxWithUser(user)
	res := h.consoleTruthVerify(ctx, sessionID, 1, "build")

	if strings.Contains(strings.ToLower(res.Message), "does not belong") {
		t.Fatalf("owner verify must not be rejected as cross-user: %q", res.Message)
	}
	// Expected failure: nil sessionSvc → likely panic or "internal
	// error" — either is fine; what matters is that "does not
	// belong" was NOT the rejection reason.
}

// TestCrossUserSessionRejectedInHTTP confirms the full HTTP path
// also rejects cross-user sessions. The authorization check is in
// consoleTruthVerify, which is called by Verify() — this test
// confirms the chain from chi → Verify → consoleTruthVerify is intact.
func TestCrossUserSessionRejectedInHTTP(t *testing.T) {
	userA := uuid.New()
	userB := uuid.New()
	sessionFromA := uuid.New()

	repo := &fakeSessionRepo{
		sessions: map[uuid.UUID]*labsession.Session{
			sessionFromA: sessionWithOwner(sessionFromA, userA),
		},
	}

	h := makeTestHandler(repo, nil)

	// Build a chi router with User B's claims injected.
	r := chiRouterWithUser(h, userB)

	body := `{"phase":"build","session_id":"` + sessionFromA.String() + `"}`
	req := httptest.NewRequest(http.MethodPost, "/api/v1/labs/1/verify", strings.NewReader(body))
	req.Header.Set("Content-Type", "application/json")
	w := httptest.NewRecorder()

	r.ServeHTTP(w, req)

	if w.Code != http.StatusOK {
		t.Fatalf("expected 200 OK (verify always returns 200 with result), got %d: %s", w.Code, w.Body.String())
	}
	// Response body contains the verify result. Cross-user should
	// produce "does not belong" message.
	if !strings.Contains(strings.ToLower(w.Body.String()), "does not belong") {
		t.Fatalf("expected 'does not belong' in response body, got: %s", w.Body.String())
	}
}

// TestNonexistentSessionReturnsNotFound confirms that a non-existent
// session_id gets "session not found" — NOT a nil-dereference panic
// or a generic error.
func TestNonexistentSessionReturnsNotFound(t *testing.T) {
	repo := &fakeSessionRepo{sessions: map[uuid.UUID]*labsession.Session{}}
	h := makeTestHandler(repo, nil)

	ctx := ctxWithUser(uuid.New())
	res := h.consoleTruthVerify(ctx, uuid.New(), 1, "build")

	if res.Passed {
		t.Fatal("verify with nonexistent session must not pass")
	}
	if !strings.Contains(strings.ToLower(res.Message), "not found") {
		t.Fatalf("expected 'not found' for nonexistent session, got: %q", res.Message)
	}
}

// TestDBErrorDoesNotRevealSessionExistence confirms that a database
// error (not ErrNotFound) returns the generic "session not found"
// message, not a raw error string. Consistent with security rule:
// never reveal internal state in error messages.
func TestDBErrorDoesNotRevealSessionExistence(t *testing.T) {
	repo := &fakeSessionRepo{
		sessions: map[uuid.UUID]*labsession.Session{},
		err:      context.DeadlineExceeded,
	}
	h := makeTestHandler(repo, nil)

	ctx := ctxWithUser(uuid.New())
	res := h.consoleTruthVerify(ctx, uuid.New(), 1, "build")

	if res.Passed {
		t.Fatal("verify with DB error must not pass")
	}
	if !strings.Contains(strings.ToLower(res.Message), "not found") {
		t.Fatalf("expected generic 'not found' for DB error, got: %q", res.Message)
	}
}
