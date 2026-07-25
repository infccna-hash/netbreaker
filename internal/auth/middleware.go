package auth

import (
	"context"
	"net/http"
	"strings"

	jwtutil "netbreaker.io/api/pkg/jwt"
	"netbreaker.io/api/pkg/response"
	"netbreaker.io/api/pkg/types"
)

// JWTMiddleware validates the Bearer token and injects claims into context.
// Requests without a valid token are rejected with 401.
func JWTMiddleware(keys *jwtutil.KeyPair) func(http.Handler) http.Handler {
	return func(next http.Handler) http.Handler {
		return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
			claims, ok := parseBearer(keys, r)
			if !ok {
				response.Unauthorized(w)
				return
			}
			ctx := context.WithValue(r.Context(), claimsKey, claims)
			next.ServeHTTP(w, r.WithContext(ctx))
		})
	}
}

// OptionalJWTMiddleware injects claims into context IF a valid token is present,
// but never rejects the request. Used on public routes that show richer content
// to authenticated users (e.g. lab detail: pro users see all phases).
func OptionalJWTMiddleware(keys *jwtutil.KeyPair) func(http.Handler) http.Handler {
	return func(next http.Handler) http.Handler {
		return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
			if claims, ok := parseBearer(keys, r); ok {
				r = r.WithContext(context.WithValue(r.Context(), claimsKey, claims))
			}
			next.ServeHTTP(w, r)
		})
	}
}

func parseBearer(keys *jwtutil.KeyPair, r *http.Request) (*jwtutil.Claims, bool) {
	tokenStr := ""

	// 1. Authorization: Bearer header (standard for REST calls)
	authHeader := r.Header.Get("Authorization")
	if strings.HasPrefix(authHeader, "Bearer ") {
		tokenStr = strings.TrimPrefix(authHeader, "Bearer ")
	}

	// 2. ?token= query parameter (WebSocket connections — browser WS API
	//    can't set custom headers, so the frontend passes it as a param).
	if tokenStr == "" {
		tokenStr = r.URL.Query().Get("token")
	}

	if tokenStr == "" {
		return nil, false
	}

	claims, err := keys.ParseAccessToken(tokenStr)
	if err != nil {
		return nil, false
	}
	return claims, true
}

// RequirePlan allows only users whose plan is in the given list.
// Must be used AFTER JWTMiddleware.
func RequirePlan(plans ...string) func(http.Handler) http.Handler {
	return func(next http.Handler) http.Handler {
		return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
			claims := ClaimsFromCtx(r.Context())
			if claims == nil {
				response.Unauthorized(w)
				return
			}
			for _, p := range plans {
				if claims.Plan == p {
					next.ServeHTTP(w, r)
					return
				}
			}
			response.Forbidden(w, "upgrade your plan to access this feature")
		})
	}
}

// RequireAdmin allows only users with is_admin = true.
// Must be used AFTER JWTMiddleware.
func RequireAdmin() func(http.Handler) http.Handler {
	return func(next http.Handler) http.Handler {
		return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
			claims := ClaimsFromCtx(r.Context())
			if claims == nil || !claims.IsAdmin {
				response.Forbidden(w, "admin access required")
				return
			}
			next.ServeHTTP(w, r)
		})
	}
}

// HasPlan returns whether the claims allow any of the given plans.
func HasPlan(claims *jwtutil.Claims, plans ...string) bool {
	if claims == nil {
		return false
	}
	for _, p := range plans {
		if claims.Plan == p {
			return true
		}
	}
	return false
}

// IsProOrAbove returns true for pro and bootcamp users.
func IsProOrAbove(claims *jwtutil.Claims) bool {
	return HasPlan(claims, types.PlanPro, types.PlanBootcamp)
}
