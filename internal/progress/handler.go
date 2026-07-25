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

	if err := h.repo.Mark(r.Context(), userID, labID, phase); err != nil {
		response.InternalError(w)
		return
	}
	response.JSON(w, http.StatusOK, map[string]string{"status": "marked"})
}

// DELETE /api/v1/progress/:labID/:phase
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

func parseParams(w http.ResponseWriter, r *http.Request) (int, string, bool) {
	labID, err := strconv.Atoi(chi.URLParam(r, "labID"))
	if err != nil || labID < 1 || labID > 14 {
		response.Error(w, http.StatusBadRequest, "invalid lab id (must be 1-14)")
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
