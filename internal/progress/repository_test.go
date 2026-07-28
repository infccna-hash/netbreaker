package progress

import (
	"context"
	"os"
	"testing"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5/pgxpool"
)

func testPool(t *testing.T) *pgxpool.Pool {
	t.Helper()
	dsn := os.Getenv("TEST_DATABASE_URL")
	if dsn == "" {
		t.Skip("TEST_DATABASE_URL not set; skipping progress integration test")
	}
	pool, err := pgxpool.New(context.Background(), dsn)
	if err != nil {
		t.Fatalf("connect: %v", err)
	}
	return pool
}

// TestAllPhasesCompleted_FullSet_Passes validates the happy path:
// a user who completed every (lab_id, phase) in lab_phases is eligible.
func TestAllPhasesCompleted_FullSet_Passes(t *testing.T) {
	pool := testPool(t)
	defer pool.Close()
	repo := NewRepository(pool)

	userID := uuid.MustParse("00000000-0000-0000-0000-00000000e001")
	cleanup := seedAllPhases(t, pool, userID)
	defer cleanup()

	ok, err := repo.AllPhasesCompleted(context.Background(), userID)
	if err != nil {
		t.Fatalf("AllPhasesCompleted: %v", err)
	}
	if !ok {
		t.Error("user with every phase completed should be eligible")
	}
}

// TestAllPhasesCompleted_CountMatchButPhaseMismatch_Fails is the primary
// regression guard for the "eligibility by coincidence" bug (2026-07-28).
// It seeds only build phases for every lab — the COUNT matches the catalog
// (45 labs * 1 phase = 45, but catalog has 45 * 3 = 135 phases) — and
// verifies the set-membership check CORRECTLY rejects this user.
//
// Under the old COUNT-vs-COUNT check this user would have passed.
func TestAllPhasesCompleted_CountMatchButPhaseMismatch_Fails(t *testing.T) {
	pool := testPool(t)
	defer pool.Close()
	repo := NewRepository(pool)

	userID := uuid.MustParse("00000000-0000-0000-0000-00000000e002")
	cleanup := seedOnlyBuildPhases(t, pool, userID)
	defer cleanup()

	ok, err := repo.AllPhasesCompleted(context.Background(), userID)
	if err != nil {
		t.Fatalf("AllPhasesCompleted: %v", err)
	}
	if ok {
		t.Error("user with build-only phases (matching count but wrong set) must NOT be eligible — this was the eligibility-by-coincidence bug")
	}
}

// TestAllPhasesCompleted_NoProgress_Fails is the obvious baseline:
// a user with zero completed phases is not eligible.
func TestAllPhasesCompleted_NoProgress_Fails(t *testing.T) {
	pool := testPool(t)
	defer pool.Close()
	repo := NewRepository(pool)

	userID := uuid.MustParse("00000000-0000-0000-0000-00000000e003")

	ok, err := repo.AllPhasesCompleted(context.Background(), userID)
	if err != nil {
		t.Fatalf("AllPhasesCompleted: %v", err)
	}
	if ok {
		t.Error("user with zero progress should not be eligible")
	}
}

// ── helpers ──────────────────────────────────────────────────────────

// seedAllPhases inserts a user_progress row for every (lab_id, phase)
// in lab_phases. Returns a cleanup function.
func seedAllPhases(t *testing.T, pool *pgxpool.Pool, userID uuid.UUID) func() {
	t.Helper()
	ctx := context.Background()

	// Seed a test user row (needed for FK).
	pool.Exec(ctx, `INSERT INTO users (id, email, name, password_hash, plan) VALUES ($1, $2, $3, $4, 'pro') ON CONFLICT DO NOTHING`,
		userID, userID.String()+"@test.local", "Test User", "$2a$12$dummy")
	pool.Exec(ctx, `DELETE FROM user_progress WHERE user_id = $1`, userID)

	_, err := pool.Exec(ctx, `
		INSERT INTO user_progress (user_id, lab_id, phase)
		SELECT $1, lp.lab_id, lp.phase FROM lab_phases lp
		ON CONFLICT DO NOTHING
	`, userID)
	if err != nil {
		t.Fatalf("seed full set: %v", err)
	}

	return func() {
		pool.Exec(ctx, `DELETE FROM user_progress WHERE user_id = $1`, userID)
		pool.Exec(ctx, `DELETE FROM users WHERE id = $1`, userID)
	}
}

// seedOnlyBuildPhases inserts ONLY build phases for every lab.
// The COUNT of user_progress rows equals the number of labs, but
// the set is incomplete (missing attack/harden for each lab).
func seedOnlyBuildPhases(t *testing.T, pool *pgxpool.Pool, userID uuid.UUID) func() {
	t.Helper()
	ctx := context.Background()

	pool.Exec(ctx, `INSERT INTO users (id, email, name, password_hash, plan) VALUES ($1, $2, $3, $4, 'pro') ON CONFLICT DO NOTHING`,
		userID, userID.String()+"@test.local", "Test User", "$2a$12$dummy")
	pool.Exec(ctx, `DELETE FROM user_progress WHERE user_id = $1`, userID)

	_, err := pool.Exec(ctx, `
		INSERT INTO user_progress (user_id, lab_id, phase)
		SELECT $1, id, 'build' FROM labs
		ON CONFLICT DO NOTHING
	`, userID)
	if err != nil {
		t.Fatalf("seed build-only: %v", err)
	}

	return func() {
		pool.Exec(ctx, `DELETE FROM user_progress WHERE user_id = $1`, userID)
		pool.Exec(ctx, `DELETE FROM users WHERE id = $1`, userID)
	}
}
