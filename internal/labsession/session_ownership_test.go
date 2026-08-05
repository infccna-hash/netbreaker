package labsession

import (
	"context"
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/golang-jwt/jwt/v5"
	"github.com/go-chi/chi/v5"
	"github.com/google/uuid"

	"netbreaker.io/api/internal/auth"
	jwtutil "netbreaker.io/api/pkg/jwt"
)

// Regression test for the cross-user session authorization gap found 2026-08-05:
// get/heartbeat/end previously had NO ownership check (only console did).
// An authenticated user could read/keep-alive/delete ANY session by UUID —
// e.g. end another student's lab in a bootcamp classroom and kill their GNS3
// project. This mirrors the console handler's verified Layer-3 pattern.
//
// Run: TEST_DATABASE_URL=postgres://... go test ./internal/labsession/ -run TestSessionOwnership -v

func TestSessionOwnership_CrossUserForbidden(t *testing.T) {
	pool := testPool(t)
	repo := NewRepository(pool)
	svc := NewService(repo, &fakeGNS3{stopped: true, exists: true}, 4, "local", "127.0.0.1")
	h := NewHandler(svc)

	ownerID := uuid.New()
	attackerID := uuid.New()

	// Satisfy FK: lab_sessions.user_id → users.id. Seed minimal user rows.
	ctx := context.Background()
	for _, uid := range []uuid.UUID{ownerID, attackerID} {
		if _, err := pool.Exec(ctx,
			`INSERT INTO users (id, email, password_hash, plan) VALUES ($1,$2,'x','pro')`,
			uid, uid.String()+"@t.test"); err != nil {
			t.Fatalf("seed user: %v", err)
		}
	}

	// Seed a session owned by ownerID with a GNS3 project (so EndLab would
	// actually delete something if the ownership check were missing).
	sess, err := repo.Create(ctx, ownerID, 34, "local")
	if err != nil {
		t.Fatalf("seed session: %v", err)
	}
	projID := "proj-owner-34"
	if err := repo.SetProvisioned(ctx, sess.ID, projID, NodeMap{
		"R1":   {ConsolePort: 5001},
		"SW1":  {ConsolePort: 5002},
		"KALI": {ConsolePort: 5003},
	}); err != nil {
		t.Fatalf("seed provisioned: %v", err)
	}

	ownerClaims := &jwtutil.Claims{RegisteredClaims: jwt.RegisteredClaims{Subject: ownerID.String()}, Plan: "pro"}
	attackerClaims := &jwtutil.Claims{RegisteredClaims: jwt.RegisteredClaims{Subject: attackerID.String()}, Plan: "pro"}

	// chi.URLParam reads the route context — inject it since we call handlers
	// directly instead of going through the router.
	withRoute := func(req *http.Request, params map[string]string) *http.Request {
		rctx := chi.NewRouteContext()
		for k, v := range params {
			rctx.URLParams.Add(k, v)
		}
		return req.WithContext(context.WithValue(req.Context(), chi.RouteCtxKey, rctx))
	}

	// ── GET /labsessions/{id} ───────────────────────────────────────────
	t.Run("get_foreign_session_403", func(t *testing.T) {
		req := httptest.NewRequest(http.MethodGet, "/api/v1/labsessions/"+sess.ID.String(), nil)
		req = withRoute(req, map[string]string{"id": sess.ID.String()})
		req = req.WithContext(auth.CtxWithClaims(req.Context(), attackerClaims))
		rr := httptest.NewRecorder()
		h.get(rr, req)
		if rr.Code != http.StatusForbidden {
			t.Fatalf("attacker GET own-session: got %d, want 403", rr.Code)
		}
	})

	t.Run("get_owner_200", func(t *testing.T) {
		req := httptest.NewRequest(http.MethodGet, "/api/v1/labsessions/"+sess.ID.String(), nil)
		req = withRoute(req, map[string]string{"id": sess.ID.String()})
		req = req.WithContext(auth.CtxWithClaims(req.Context(), ownerClaims))
		rr := httptest.NewRecorder()
		h.get(rr, req)
		if rr.Code != http.StatusOK {
			t.Fatalf("owner GET: got %d, want 200", rr.Code)
		}
	})

	// ── POST /labsessions/{id}/heartbeat ────────────────────────────────
	t.Run("heartbeat_foreign_403", func(t *testing.T) {
		req := httptest.NewRequest(http.MethodPost, "/api/v1/labsessions/"+sess.ID.String()+"/heartbeat", nil)
		req = withRoute(req, map[string]string{"id": sess.ID.String()})
		req = req.WithContext(auth.CtxWithClaims(req.Context(), attackerClaims))
		rr := httptest.NewRecorder()
		h.heartbeat(rr, req)
		if rr.Code != http.StatusForbidden {
			t.Fatalf("attacker heartbeat: got %d, want 403", rr.Code)
		}
	})

	t.Run("heartbeat_owner_204", func(t *testing.T) {
		req := httptest.NewRequest(http.MethodPost, "/api/v1/labsessions/"+sess.ID.String()+"/heartbeat", nil)
		req = withRoute(req, map[string]string{"id": sess.ID.String()})
		req = req.WithContext(auth.CtxWithClaims(req.Context(), ownerClaims))
		rr := httptest.NewRecorder()
		h.heartbeat(rr, req)
		if rr.Code != http.StatusNoContent {
			t.Fatalf("owner heartbeat: got %d, want 204", rr.Code)
		}
	})

	// ── DELETE /labsessions/{id} ────────────────────────────────────────
	t.Run("end_foreign_403_session_survives", func(t *testing.T) {
		req := httptest.NewRequest(http.MethodDelete, "/api/v1/labsessions/"+sess.ID.String(), nil)
		req = withRoute(req, map[string]string{"id": sess.ID.String()})
		req = req.WithContext(auth.CtxWithClaims(req.Context(), attackerClaims))
		rr := httptest.NewRecorder()
		h.end(rr, req)
		if rr.Code != http.StatusForbidden {
			t.Fatalf("attacker DELETE: got %d, want 403", rr.Code)
		}
		// Negative control: the session must still be running afterwards —
		// the attacker must not have been able to end it or delete the project.
		after, err := repo.GetByID(context.Background(), sess.ID)
		if err != nil {
			t.Fatalf("fetch after forbidden delete: %v", err)
		}
		if after.Status != StatusRunning {
			t.Fatalf("session status after attacker DELETE: got %q, want %q — ownership check failed to protect the session", after.Status, StatusRunning)
		}
		if after.GNS3ProjectID == nil || *after.GNS3ProjectID != projID {
			t.Fatalf("GNS3 project after attacker DELETE: got %v, want %q — project must survive", after.GNS3ProjectID, projID)
		}
	})

	t.Run("end_owner_204", func(t *testing.T) {
		req := httptest.NewRequest(http.MethodDelete, "/api/v1/labsessions/"+sess.ID.String(), nil)
		req = withRoute(req, map[string]string{"id": sess.ID.String()})
		req = req.WithContext(auth.CtxWithClaims(req.Context(), ownerClaims))
		rr := httptest.NewRecorder()
		h.end(rr, req)
		if rr.Code != http.StatusNoContent {
			t.Fatalf("owner DELETE: got %d, want 204", rr.Code)
		}
		after, err := repo.GetByID(context.Background(), sess.ID)
		if err != nil {
			t.Fatalf("fetch after owner delete: %v", err)
		}
		if after.Status != StatusEnded {
			t.Fatalf("session status after owner DELETE: got %q, want %q", after.Status, StatusEnded)
		}
	})
}
