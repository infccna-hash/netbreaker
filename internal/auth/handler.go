package auth

import (
	"encoding/json"
	"errors"
	"net/http"
	"time"

	"netbreaker.io/api/pkg/email"
	"netbreaker.io/api/pkg/response"
)

const refreshCookieName = "refresh_token"

// refreshCookiePath covers BOTH /auth/refresh and /auth/logout so the browser
// actually sends the cookie to logout (a stricter /auth/refresh path would not
// match /auth/logout, leaving the server-side revoke a no-op).
const refreshCookiePath = "/api/v1/auth"

type Handler struct {
	svc        *Service
	email      *email.Client
	refreshTTL time.Duration
	isProd     bool
}

func NewHandler(svc *Service, emailClient *email.Client, refreshTTL time.Duration, isProd bool) *Handler {
	return &Handler{svc: svc, email: emailClient, refreshTTL: refreshTTL, isProd: isProd}
}

type registerRequest struct {
	Email    string `json:"email"`
	Password string `json:"password"`
	Name     string `json:"name"`
}

func (h *Handler) Register(w http.ResponseWriter, r *http.Request) {
	var req registerRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		response.Error(w, http.StatusBadRequest, "invalid request body")
		return
	}
	if req.Email == "" || req.Password == "" {
		response.Error(w, http.StatusBadRequest, "email and password are required")
		return
	}
	if len(req.Password) < 8 {
		response.Error(w, http.StatusBadRequest, "password must be at least 8 characters")
		return
	}

	user, tokens, err := h.svc.Register(r.Context(), req.Email, req.Password, req.Name)
	if err != nil {
		if errors.Is(err, ErrEmailTaken) {
			response.Error(w, http.StatusConflict, "an account with this email already exists")
			return
		}
		response.InternalError(w)
		return
	}

	if h.email != nil {
		go func() { _ = h.email.SendWelcome(user.Email, user.Name) }()
	}

	h.setRefreshCookie(w, r, tokens.RefreshToken)
	response.JSON(w, http.StatusCreated, map[string]any{
		"access_token": tokens.AccessToken,
		"user":         user,
	})
}

type loginRequest struct {
	Email    string `json:"email"`
	Password string `json:"password"`
}

func (h *Handler) Login(w http.ResponseWriter, r *http.Request) {
	var req loginRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		response.Error(w, http.StatusBadRequest, "invalid request body")
		return
	}

	user, tokens, err := h.svc.Login(r.Context(), req.Email, req.Password)
	if err != nil {
		if errors.Is(err, ErrInvalidCredentials) {
			response.Error(w, http.StatusUnauthorized, "invalid email or password")
			return
		}
		response.InternalError(w)
		return
	}

	h.setRefreshCookie(w, r, tokens.RefreshToken)
	response.JSON(w, http.StatusOK, map[string]any{
		"access_token": tokens.AccessToken,
		"user":         user,
	})
}

func (h *Handler) Refresh(w http.ResponseWriter, r *http.Request) {
	cookie, err := r.Cookie(refreshCookieName)
	if err != nil {
		response.Unauthorized(w)
		return
	}

	accessToken, newRefresh, err := h.svc.Refresh(r.Context(), cookie.Value)
	if err != nil {
		h.clearRefreshCookie(w, r)
		response.Unauthorized(w)
		return
	}

	h.setRefreshCookie(w, r, newRefresh)
	response.JSON(w, http.StatusOK, map[string]string{"access_token": accessToken})
}

func (h *Handler) Logout(w http.ResponseWriter, r *http.Request) {
	cookie, err := r.Cookie(refreshCookieName)
	if err == nil {
		_ = h.svc.Logout(r.Context(), cookie.Value)
	}
	h.clearRefreshCookie(w, r)
	response.NoContent(w)
}

// isSecure reports whether the request arrived over a TLS-terminated
// connection.  When Caddy sits in front (reaching us over plain HTTP),
// we trust the X-Forwarded-Proto header; when Caddy itself is on plain
// HTTP the header is absent and Secure stays false so the browser will
// actually store the cookie.
func (h *Handler) isSecure(r *http.Request) bool {
	if r.TLS != nil {
		return true
	}
	return r.Header.Get("X-Forwarded-Proto") == "https"
}

func (h *Handler) setRefreshCookie(w http.ResponseWriter, r *http.Request, token string) {
	http.SetCookie(w, &http.Cookie{
		Name:     refreshCookieName,
		Value:    token,
		Path:     refreshCookiePath,
		Expires:  time.Now().Add(h.refreshTTL),
		HttpOnly: true,
		Secure:   h.isSecure(r),
		SameSite: http.SameSiteStrictMode,
	})
}

func (h *Handler) clearRefreshCookie(w http.ResponseWriter, r *http.Request) {
	http.SetCookie(w, &http.Cookie{
		Name:     refreshCookieName,
		Value:    "",
		Path:     refreshCookiePath,
		MaxAge:   -1,
		HttpOnly: true,
		Secure:   h.isSecure(r),
		SameSite: http.SameSiteStrictMode,
	})
}
