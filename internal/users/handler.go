package users

import (
	"encoding/json"
	"net/http"

	"github.com/google/uuid"

	"netbreaker.io/api/internal/auth"
	"netbreaker.io/api/pkg/response"
)

type Handler struct {
	repo *Repository
}

func NewHandler(repo *Repository) *Handler {
	return &Handler{repo: repo}
}

// GET /api/v1/me
func (h *Handler) Get(w http.ResponseWriter, r *http.Request) {
	claims := auth.ClaimsFromCtx(r.Context())
	userID, err := uuid.Parse(claims.Subject)
	if err != nil {
		response.Unauthorized(w)
		return
	}

	user, err := h.repo.GetByID(r.Context(), userID)
	if err != nil {
		response.NotFound(w)
		return
	}

	response.JSON(w, http.StatusOK, user)
}

type updateRequest struct {
	Name string `json:"name"`
}

// PATCH /api/v1/me
func (h *Handler) Update(w http.ResponseWriter, r *http.Request) {
	claims := auth.ClaimsFromCtx(r.Context())
	userID, _ := uuid.Parse(claims.Subject)

	var req updateRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		response.Error(w, http.StatusBadRequest, "invalid request body")
		return
	}
	if req.Name == "" {
		response.Error(w, http.StatusBadRequest, "name is required")
		return
	}

	user, err := h.repo.UpdateName(r.Context(), userID, req.Name)
	if err != nil {
		response.InternalError(w)
		return
	}
	response.JSON(w, http.StatusOK, user)
}

// DELETE /api/v1/me
func (h *Handler) Delete(w http.ResponseWriter, r *http.Request) {
	claims := auth.ClaimsFromCtx(r.Context())
	userID, _ := uuid.Parse(claims.Subject)

	if err := h.repo.Delete(r.Context(), userID); err != nil {
		response.InternalError(w)
		return
	}
	response.NoContent(w)
}
