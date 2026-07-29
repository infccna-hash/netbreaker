package progress

import (
	"net/http"
	"strconv"

	"github.com/go-chi/chi/v5"
	"github.com/google/uuid"

	"netbreaker.io/api/internal/auth"
	"netbreaker.io/api/pkg/response"
	"netbreaker.io/api/pkg/types"
)

var validPhases = map[string]bool{
	types.PhaseBuild: true, types.PhaseAttack: true, types.PhaseHarden: true,
}

type Handler struct {
	repo *Repository
}

func NewHandler(repo *Repository) *Handler {
	return &Handler{repo: repo}
}

// GET /api/v1/progress
func (h *Handler) Get(w http.ResponseWriter, r *http.Request) {
	userID := mustUserID(r)

	items, err := h.repo.GetAll(r.Context(), userID)
	if err != nil {
		response.InternalError(w)
		return
	}

	// Build summary. Total phases is computed live — the lab catalog grows
	// over time, so this is never a fixed constant.
	totalPhases, err := h.repo.TotalPhases(r.Context())
	if err != nil || totalPhases == 0 {
		totalPhases = 1 // avoid div-by-zero; a real catalog is never actually empty
	}
	completed := len(items)
	pct := (completed * 100) / totalPhases

	response.JSON(w, http.StatusOK, types.ProgressSummary{
		TotalPhases:     totalPhases,
		CompletedPhases: completed,
		ReadinessPct:    pct,
		Items:           items,
	})
}

// PUT /api/v1/progress/:labID/:phase
func (h *Handler) Mark(w http.ResponseWriter, r *http.Request) {
	userID := mustUserID(r)
	labID, phase, ok := parseParams(w, r)
	if !ok {
		return
	}

	// Confirm this (labID, phase) is real before writing — checked live
	// against lab_phases, not a hardcoded lab-count constant. This replaces
	// a "labID must be 1-14" check that silently rejected every lab added
	// after #14 (found 2026-07-28: labs 15-46 could never be marked
	// complete through this endpoint at all).
	exists, err := h.repo.PhaseExists(r.Context(), labID, phase)
	if err != nil {
		response.InternalError(w)
		return
	}
	if !exists {
		response.Error(w, http.StatusBadRequest, "no such lab or phase")
		return
	}

	if err := h.repo.Mark(r.Context(), userID, labID, phase); err != nil {
		response.InternalError(w)
		return
	}
	response.JSON(w, http.StatusOK, map[string]string{"status": "marked"})
}

// DELETE /api/v1/progress/:labID/:phase
//
// Deliberately does NOT call PhaseExists (unlike Mark). DELETE is
// idempotent: unmarking a (labID, phase) that was never real is a no-op
// either way, since there's nothing to delete — it returns 204 the same
// as unmarking a real-but-not-completed phase. This is intentional
// asymmetry with Mark, not an oversight: Mark needs the check because it
// WRITES a row for whatever's requested (that's how labID>14 silently
// broke — bogus IDs succeeded at insert time), Unmark doesn't create
// anything so there's nothing bogus to prevent. Concretely:
// DELETE /progress/99999/build returns 204, not 400. If a future change
// wants Unmark to 400 on a nonexistent lab too, that's a real behavior
// change to decide on deliberately — not a bug to silently fix.
func (h *Handler) Unmark(w http.ResponseWriter, r *http.Request) {
	userID := mustUserID(r)
	labID, phase, ok := parseParams(w, r)
	if !ok {
		return
	}

	if err := h.repo.Unmark(r.Context(), userID, labID, phase); err != nil {
		response.InternalError(w)
		return
	}
	response.NoContent(w)
}

// parseParams does shape-only validation (positive integer, known phase
// name). It deliberately does NOT check the lab count — see Mark's live
// PhaseExists check for that. Unmark doesn't need the live check: deleting
// a row that was never a valid (labID, phase) is a harmless no-op.
func parseParams(w http.ResponseWriter, r *http.Request) (int, string, bool) {
	labID, err := strconv.Atoi(chi.URLParam(r, "labID"))
	if err != nil || labID < 1 {
		response.Error(w, http.StatusBadRequest, "invalid lab id")
		return 0, "", false
	}
	phase := chi.URLParam(r, "phase")
	if !validPhases[phase] {
		response.Error(w, http.StatusBadRequest, "invalid phase (must be build, attack, or harden)")
		return 0, "", false
	}
	return labID, phase, true
}

func mustUserID(r *http.Request) uuid.UUID {
	claims := auth.ClaimsFromCtx(r.Context())
	id, _ := uuid.Parse(claims.Subject)
	return id
}
