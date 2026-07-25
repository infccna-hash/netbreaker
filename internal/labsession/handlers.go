package labsession

import (
	"context"
	"encoding/json"
	"errors"
	"net/http"
	"strconv"

	"github.com/go-chi/chi/v5"
	"github.com/google/uuid"

	"netbreaker.io/api/internal/auth"
)

type Handler struct {
	svc *Service
}

func NewHandler(svc *Service) *Handler {
	return &Handler{svc: svc}
}

func (h *Handler) Routes(r chi.Router) {
	r.Post("/labs/{labID}/session", h.launch)
	r.Get("/labsessions/{id}", h.get)
	r.Post("/labsessions/{id}/heartbeat", h.heartbeat)
	r.Delete("/labsessions/{id}", h.end)
	r.Get("/labsessions/{id}/console/{node}", h.console)
}

func (h *Handler) launch(w http.ResponseWriter, r *http.Request) {
	userID, isPro := authFromContext(r.Context())

	labID, err := strconv.Atoi(chi.URLParam(r, "labID"))
	if err != nil {
		http.Error(w, "invalid lab id", http.StatusBadRequest)
		return
	}

	sess, err := h.svc.Launch(r.Context(), userID, labID, isPro)
	switch {
	case errors.Is(err, ErrPlanGate):
		http.Error(w, err.Error(), http.StatusForbidden)
		return
	case errors.Is(err, ErrSlotConflict):
		http.Error(w, "max concurrent sessions reached", http.StatusConflict)
		return
	case errors.Is(err, ErrConceptualLab):
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	case err != nil:
		http.Error(w, "internal error", http.StatusInternalServerError)
		return
	}

	writeJSON(w, http.StatusOK, sess)
}

func (h *Handler) get(w http.ResponseWriter, r *http.Request) {
	id, err := uuid.Parse(chi.URLParam(r, "id"))
	if err != nil {
		http.Error(w, "invalid session id", http.StatusBadRequest)
		return
	}
	sess, err := h.svc.Get(r.Context(), id)
	if errors.Is(err, ErrNotFound) {
		http.Error(w, "not found", http.StatusNotFound)
		return
	}
	if err != nil {
		http.Error(w, "internal error", http.StatusInternalServerError)
		return
	}
	writeJSON(w, http.StatusOK, sess)
}

func (h *Handler) heartbeat(w http.ResponseWriter, r *http.Request) {
	id, err := uuid.Parse(chi.URLParam(r, "id"))
	if err != nil {
		http.Error(w, "invalid session id", http.StatusBadRequest)
		return
	}
	if err := h.svc.Heartbeat(r.Context(), id); err != nil {
		http.Error(w, "internal error", http.StatusInternalServerError)
		return
	}
	w.WriteHeader(http.StatusNoContent)
}

func (h *Handler) end(w http.ResponseWriter, r *http.Request) {
	id, err := uuid.Parse(chi.URLParam(r, "id"))
	if err != nil {
		http.Error(w, "invalid session id", http.StatusBadRequest)
		return
	}
	if err := h.svc.EndLab(r.Context(), id); err != nil {
		http.Error(w, "internal error", http.StatusInternalServerError)
		return
	}
	w.WriteHeader(http.StatusNoContent)
}

func writeJSON(w http.ResponseWriter, status int, v any) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(status)
	json.NewEncoder(w).Encode(v)
}

// authFromContext extracts the user ID and pro status from the JWT claims
// that the auth middleware injected into the request context.
func authFromContext(ctx context.Context) (userID uuid.UUID, isPro bool) {
	claims := auth.ClaimsFromCtx(ctx)
	if claims == nil {
		return uuid.Nil, false
	}
	uid, err := uuid.Parse(claims.Subject)
	if err != nil {
		return uuid.Nil, false
	}
	return uid, auth.IsProOrAbove(claims)
}
