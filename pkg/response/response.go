package response

import (
	"encoding/json"
	"net/http"
)

type ErrorBody struct {
	Error string `json:"error"`
	Code  string `json:"code,omitempty"`
}

// JSON writes a JSON response with the given status code.
func JSON(w http.ResponseWriter, status int, data any) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(status)
	if data != nil {
		_ = json.NewEncoder(w).Encode(data)
	}
}

// NoContent writes a 204 No Content response.
func NoContent(w http.ResponseWriter) {
	w.WriteHeader(http.StatusNoContent)
}

// Error writes a JSON error response.
func Error(w http.ResponseWriter, status int, message string) {
	JSON(w, status, ErrorBody{Error: message})
}

// ErrorCode writes a JSON error response with a machine-readable code.
func ErrorCode(w http.ResponseWriter, status int, message, code string) {
	JSON(w, status, ErrorBody{Error: message, Code: code})
}

// Unauthorized writes a 401 response.
func Unauthorized(w http.ResponseWriter) {
	Error(w, http.StatusUnauthorized, "authentication required")
}

// Forbidden writes a 403 response.
func Forbidden(w http.ResponseWriter, msg string) {
	if msg == "" {
		msg = "insufficient permissions"
	}
	Error(w, http.StatusForbidden, msg)
}

// NotFound writes a 404 response.
func NotFound(w http.ResponseWriter) {
	Error(w, http.StatusNotFound, "not found")
}

// InternalError writes a 500 and logs the real error (call this, not expose the real error).
func InternalError(w http.ResponseWriter) {
	Error(w, http.StatusInternalServerError, "an unexpected error occurred")
}
