package auth

import (
	"context"

	jwtutil "netbreaker.io/api/pkg/jwt"
)

type contextKey string

const claimsKey contextKey = "claims"

// ClaimsFromCtx extracts the JWT claims from the request context.
// Only call this inside a route that uses JWTMiddleware.
func ClaimsFromCtx(ctx context.Context) *jwtutil.Claims {
	v := ctx.Value(claimsKey)
	if v == nil {
		return nil
	}
	return v.(*jwtutil.Claims)
}
