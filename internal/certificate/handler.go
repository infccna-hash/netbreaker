package certificate

import (
	"errors"
	"net/http"

	"github.com/go-chi/chi/v5"
	"github.com/google/uuid"

	"netbreaker.io/api/internal/auth"
	"netbreaker.io/api/internal/users"
	"netbreaker.io/api/pkg/response"
)

type Handler struct {
	svc      *Service
	userRepo *users.Repository
}

func NewHandler(svc *Service, userRepo *users.Repository) *Handler {
	return &Handler{svc: svc, userRepo: userRepo}
}

// GET /api/v1/certificate  [Pro only — enforced by middleware]
func (h *Handler) Get(w http.ResponseWriter, r *http.Request) {
	claims := auth.ClaimsFromCtx(r.Context())
	userID, _ := uuid.Parse(claims.Subject)

	user, err := h.userRepo.GetByID(r.Context(), userID)
	if err != nil {
		response.InternalError(w)
		return
	}

	cert, err := h.svc.GetOrCreate(r.Context(), userID, user.Name, user.Email)
	if err != nil {
		if errors.Is(err, ErrNotEligible) {
			response.ErrorCode(w, http.StatusConflict, err.Error(), "NOT_ELIGIBLE")
			return
		}
		response.InternalError(w)
		return
	}
	response.JSON(w, http.StatusOK, cert)
}

// GET /api/v1/certificate/verify/:code  [Public]
func (h *Handler) Verify(w http.ResponseWriter, r *http.Request) {
	code := chi.URLParam(r, "code")

	result, err := h.svc.VerifyByCode(r.Context(), code)
	if err != nil {
		if errors.Is(err, ErrNotFound) {
			response.JSON(w, http.StatusNotFound, map[string]bool{"valid": false})
			return
		}
		response.InternalError(w)
		return
	}
	response.JSON(w, http.StatusOK, result)
}
