package labsession

import (
	"context"
	"errors"
	"os"
	"testing"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5/pgxpool"
)

// fakeGNS3 is a controllable GNS3Client. Set stopErr / deleteErr to simulate an
// unresponsive/starved GNS3 host. Counters record how often each op was called.
type fakeGNS3 struct {
	stopErr, deleteErr error
	stops, deletes     int
}

func (f *fakeGNS3) CreateProject(context.Context, string, int, int) (string, error) {
	return "proj", nil
}
func (f *fakeGNS3) ProvisionTopology(context.Context, string, TopologyTemplate) (NodeMap, error) {
	return NodeMap{}, nil
}
func (f *fakeGNS3) StartNodes(context.Context, string) error { return nil }
func (f *fakeGNS3) StopNodes(context.Context, string) error  { f.stops++; return f.stopErr }
func (f *fakeGNS3) DeleteProject(context.Context, string) error {
	f.deletes++
	return f.deleteErr
}

// statusOf reads a session's current status directly.
func statusOf(t *testing.T, pool *pgxpool.Pool, id uuid.UUID) string {
	t.Helper()
	var s string
	if err := pool.QueryRow(context.Background(),
		`SELECT status FROM lab_sessions WHERE id=$1`, id).Scan(&s); err != nil {
		t.Fatalf("status query: %v", err)
	}
	return s
}

// seedSession inserts a user, a lab, and a session in the given status with an
// old last_active_at so the reaper always considers it stale. Returns the id.
func seedSession(t *testing.T, pool *pgxpool.Pool, status string) uuid.UUID {
	t.Helper()
	ctx := context.Background()
	uid := uuid.New()
	// minimal user + lab to satisfy FKs; ignore column specifics beyond NOT NULLs
	_, err := pool.Exec(ctx,
		`INSERT INTO users (id, email, password_hash, plan) VALUES ($1,$2,'x','free')`,
		uid, uid.String()+"@t.test")
	if err != nil {
		t.Fatalf("seed user: %v", err)
	}
	var labID int
	if err := pool.QueryRow(ctx, `SELECT id FROM labs ORDER BY id LIMIT 1`).Scan(&labID); err != nil {
		t.Fatalf("pick lab: %v", err)
	}
	sid := uuid.New()
	_, err = pool.Exec(ctx, `
		INSERT INTO lab_sessions (id, user_id, lab_id, compute_id, gns3_project_id, status, last_active_at)
		VALUES ($1,$2,$3,'local','proj',$4, now() - interval '10 days')`,
		sid, uid, labID, status)
	if err != nil {
		t.Fatalf("seed session: %v", err)
	}
	return sid
}

func testPool(t *testing.T) *pgxpool.Pool {
	t.Helper()
	dsn := os.Getenv("TEST_DATABASE_URL")
	if dsn == "" {
		t.Skip("TEST_DATABASE_URL not set; skipping reaper integration test")
	}
	pool, err := pgxpool.New(context.Background(), dsn)
	if err != nil {
		t.Fatalf("connect: %v", err)
	}
	return pool
}

// Tier 1: a failed graceful StopNodes must NOT advance the session to
// idle_stopped on the strength of a failed stop. The slot stays counted.
func TestSuspend_FailedStop_KeepsRunning(t *testing.T) {
	pool := testPool(t)
	defer pool.Close()
	repo := NewRepository(pool)
	g := &fakeGNS3{stopErr: errors.New("gns3 timeout")}
	r := NewReaper(repo, g, time.Minute, time.Hour, 30*time.Second, 5*time.Second)

	sid := seedSession(t, pool, "running")
	defer pool.Exec(context.Background(), `DELETE FROM lab_sessions WHERE id=$1`, sid)

	// One sweep: stop fails once -> still running (not idle_stopped, not ended).
	r.sweep(context.Background())
	if got := statusOf(t, pool, sid); got != "running" {
		t.Fatalf("after 1 failed stop: status=%q, want running (slot must stay counted)", got)
	}
}

// Tier 1 escalation: after maxStopAttempts failed stops, the reaper force-deletes.
// If the forced delete also fails, the slot is STILL not freed (stays running).
// Once the forced delete succeeds, the session is ended.
func TestSuspend_Escalation(t *testing.T) {
	pool := testPool(t)
	defer pool.Close()
	repo := NewRepository(pool)
	g := &fakeGNS3{stopErr: errors.New("stop timeout"), deleteErr: errors.New("delete timeout")}
	r := NewReaper(repo, g, time.Minute, time.Hour, 30*time.Second, 5*time.Second)

	sid := seedSession(t, pool, "running")
	defer pool.Exec(context.Background(), `DELETE FROM lab_sessions WHERE id=$1`, sid)

	// Drive maxStopAttempts sweeps; force-delete is attempted and fails each time.
	for i := 0; i < maxStopAttempts; i++ {
		r.sweep(context.Background())
	}
	if got := statusOf(t, pool, sid); got != "running" {
		t.Fatalf("escalation with failing delete: status=%q, want running (slot kept)", got)
	}
	if g.deletes == 0 {
		t.Fatalf("expected a forced DeleteProject escalation, got none")
	}

	// Now let the forced delete succeed; next sweep should free the slot.
	g.deleteErr = nil
	r.sweep(context.Background())
	if got := statusOf(t, pool, sid); got != "ended" {
		t.Fatalf("after successful force-delete: status=%q, want ended", got)
	}
}

// Tier 2: a failed DeleteProject must NOT End() the session. Ending would free a
// capacity slot while the GNS3 project still exists on the host (orphan + cap
// fiction). The session must remain idle_stopped and be retried.
func TestTeardown_FailedDelete_KeepsCounted(t *testing.T) {
	pool := testPool(t)
	defer pool.Close()
	repo := NewRepository(pool)
	g := &fakeGNS3{deleteErr: errors.New("gns3 timeout")}
	r := NewReaper(repo, g, time.Minute, time.Hour, 30*time.Second, 5*time.Second)

	sid := seedSession(t, pool, "idle_stopped")
	defer pool.Exec(context.Background(), `DELETE FROM lab_sessions WHERE id=$1`, sid)

	r.sweep(context.Background())
	if got := statusOf(t, pool, sid); got != "idle_stopped" {
		t.Fatalf("after failed delete: status=%q, want idle_stopped (slot must stay counted)", got)
	}

	// Recovery: delete succeeds -> session ends.
	g.deleteErr = nil
	r.sweep(context.Background())
	if got := statusOf(t, pool, sid); got != "ended" {
		t.Fatalf("after successful delete: status=%q, want ended", got)
	}
}
