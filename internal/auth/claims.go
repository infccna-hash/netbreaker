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

// CtxWithClaims returns a child context with the given claims embedded.
// Exported for test helpers only — tests that call handlers directly
// (bypassing HTTP middleware) can inject claims into the context so
// handler code that calls ClaimsFromCtx still works.
func CtxWithClaims(parent context.Context, claims *jwtutil.Claims) context.Context {
	return context.WithValue(parent, claimsKey, claims)
}
