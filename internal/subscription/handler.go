package subscription

import (
	"encoding/json"
	"net/http"

	"github.com/google/uuid"

	"netbreaker.io/api/internal/auth"
	"netbreaker.io/api/pkg/response"
)

type Handler struct {
	svc *Service
}

func NewHandler(svc *Service) *Handler {
	return &Handler{svc: svc}
}

// GET /api/v1/subscription
func (h *Handler) Get(w http.ResponseWriter, r *http.Request) {
	userID := mustUserID(r)
	plan, err := h.svc.GetPlan(r.Context(), userID)
	if err != nil {
		response.InternalError(w)
		return
	}
	response.JSON(w, http.StatusOK, plan)
}

type checkoutRequest struct {
	Plan string `json:"plan"` // "pro" or "bootcamp"
}

// POST /api/v1/subscription/checkout
func (h *Handler) Checkout(w http.ResponseWriter, r *http.Request) {
	userID := mustUserID(r)

	var req checkoutRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		response.Error(w, http.StatusBadRequest, "invalid request body")
		return
	}
	if req.Plan != "pro" && req.Plan != "bootcamp" {
		response.Error(w, http.StatusBadRequest, "plan must be pro or bootcamp")
		return
	}

	url, err := h.svc.CreateCheckoutSession(r.Context(), userID, req.Plan)
	if err != nil {
		response.InternalError(w)
		return
	}
	response.JSON(w, http.StatusOK, map[string]string{"url": url})
}

// POST /api/v1/subscription/portal  [Pro only]
func (h *Handler) Portal(w http.ResponseWriter, r *http.Request) {
	userID := mustUserID(r)

	url, err := h.svc.CreatePortalSession(r.Context(), userID)
	if err != nil {
		response.InternalError(w)
		return
	}
	response.JSON(w, http.StatusOK, map[string]string{"url": url})
}

func mustUserID(r *http.Request) uuid.UUID {
	claims := auth.ClaimsFromCtx(r.Context())
	id, _ := uuid.Parse(claims.Subject)
	return id
}
