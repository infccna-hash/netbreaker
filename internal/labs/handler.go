package labs

import (
	"errors"
	"net/http"
	"strconv"

	"github.com/go-chi/chi/v5"

	"netbreaker.io/api/internal/auth"
	"netbreaker.io/api/pkg/response"
)

type Handler struct {
	svc  *Service
	repo *Repository
}

func NewHandler(svc *Service, repo *Repository) *Handler {
	return &Handler{svc: svc, repo: repo}
}

// GET /api/v1/labs
func (h *Handler) List(w http.ResponseWriter, r *http.Request) {
	topic := r.URL.Query().Get("topic")
	difficulty := r.URL.Query().Get("difficulty")

	labs, err := h.repo.List(r.Context(), topic, difficulty)
	if err != nil {
		response.InternalError(w)
		return
	}
	response.JSON(w, http.StatusOK, labs)
}

// GET /api/v1/labs/:id
func (h *Handler) Get(w http.ResponseWriter, r *http.Request) {
	labID, err := strconv.Atoi(chi.URLParam(r, "id"))
	if err != nil {
		response.Error(w, http.StatusBadRequest, "invalid lab id")
		return
	}

	// Check if user is pro (optional auth — token may or may not be present)
	isPro := false
	if claims := auth.ClaimsFromCtx(r.Context()); claims != nil {
		isPro = auth.IsProOrAbove(claims)
	}

	lab, err := h.svc.GetLabForUser(r.Context(), labID, isPro)
	if err != nil {
		if errors.Is(err, ErrNotFound) {
			response.NotFound(w)
			return
		}
		response.InternalError(w)
		return
	}
	response.JSON(w, http.StatusOK, lab)
}

// GET /api/v1/labs/:id/topology
func (h *Handler) GetTopology(w http.ResponseWriter, r *http.Request) {
	labID, err := strconv.Atoi(chi.URLParam(r, "id"))
	if err != nil {
		response.Error(w, http.StatusBadRequest, "invalid lab id")
		return
	}

	topo, err := h.repo.GetTopology(r.Context(), labID)
	if err != nil {
		if errors.Is(err, ErrNotFound) {
			response.NotFound(w)
			return
		}
		response.InternalError(w)
		return
	}
	response.JSON(w, http.StatusOK, topo)
}

// GET /api/v1/labs/:id/config  [Pro only — enforced by middleware]
func (h *Handler) GetConfig(w http.ResponseWriter, r *http.Request) {
	labID, err := strconv.Atoi(chi.URLParam(r, "id"))
	if err != nil {
		response.Error(w, http.StatusBadRequest, "invalid lab id")
		return
	}

	url, err := h.svc.GetPresignedURL(r.Context(), labID)
	if err != nil {
		if errors.Is(err, ErrNotFound) {
			response.Error(w, http.StatusNotFound, "config file not yet available for this lab")
			return
		}
		response.InternalError(w)
		return
	}
	response.JSON(w, http.StatusOK, map[string]string{"download_url": url})
}
