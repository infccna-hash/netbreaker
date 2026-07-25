package verification

import (
	"encoding/json"
	"net/http"
	"strconv"

	"github.com/go-chi/chi/v5"
	"github.com/google/uuid"

	"netbreaker.io/api/internal/auth"
	"netbreaker.io/api/internal/progress"
	"netbreaker.io/api/pkg/response"
)

type Handler struct {
	progressRepo *progress.Repository
}

func NewHandler(progressRepo *progress.Repository) *Handler {
	return &Handler{progressRepo: progressRepo}
}

// POST /api/v1/labs/{id}/verify
//
// The playground POSTs the full device config state here. The backend runs
// the lab-specific verifier and, if all objectives pass, automatically marks
// the phase as complete in user_progress. Returns the full VerifyResult so
// the frontend can show specific failure messages and hints.
func (h *Handler) Verify(w http.ResponseWriter, r *http.Request) {
	ctx := r.Context()

	labID, err := strconv.Atoi(chi.URLParam(r, "id"))
	if err != nil || labID < 1 || labID > 14 {
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
	if req.Config == nil {
		response.Error(w, http.StatusBadRequest, "config is required")
		return
	}

	verifier, err := Get(labID)
	if err != nil {
		response.Error(w, http.StatusNotFound, "verification not available for this lab yet")
		return
	}

	res := verifier.Verify(req.Phase, req.Config)

	// If passed, persist progress automatically — the backend is the source of truth
	if res.Passed {
		claims := auth.ClaimsFromCtx(ctx)
		userID, parseErr := uuid.Parse(claims.Subject)
		if parseErr != nil {
			response.InternalError(w)
			return
		}
		if err := h.progressRepo.Mark(ctx, userID, labID, req.Phase); err != nil {
			// Log but don't fail the request — verification was correct
			// progress.Mark uses ON CONFLICT DO NOTHING so it's idempotent
			_ = err
		}
	}

	response.JSON(w, http.StatusOK, res)
}
