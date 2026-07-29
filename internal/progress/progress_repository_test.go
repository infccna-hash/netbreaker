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

// TestPhaseExists_Lab15AndBeyond_True is the regression guard for the
// "labID must be 1-14" bug (found 2026-07-28): a hardcoded range check in
// the Mark handler rejected every lab added after #14, silently breaking
// progress-marking for labs 15 through the current catalog max. This
// confirms the live PhaseExists check (which replaced it) correctly
// recognizes labs beyond 14.
func TestPhaseExists_Lab15AndBeyond_True(t *testing.T) {
	pool := testPool(t)
	defer pool.Close()
	repo := NewRepository(pool)

	for _, labID := range []int{15, 30, 45} {
		ok, err := repo.PhaseExists(context.Background(), labID, "build")
		if err != nil {
			t.Fatalf("PhaseExists(%d, build): %v", labID, err)
		}
		if !ok {
			t.Errorf("lab %d build phase should exist in the catalog — if this fails, "+
				"either the catalog doesn't go up to 46 anymore, or PhaseExists itself is broken", labID)
		}
	}
}

// TestPhaseExists_NonexistentLab_False confirms a truly bogus lab ID is
// still correctly rejected — the fix removes the hardcoded upper bound,
// not validation entirely.
func TestPhaseExists_NonexistentLab_False(t *testing.T) {
	pool := testPool(t)
	defer pool.Close()
	repo := NewRepository(pool)

	ok, err := repo.PhaseExists(context.Background(), 99999, "build")
	if err != nil {
		t.Fatalf("PhaseExists(99999, build): %v", err)
	}
	if ok {
		t.Error("lab 99999 does not exist — PhaseExists should return false")
	}
}

// TestPhaseExists_Lab46_CurrentlyHasNoContent documents a real, separate
// gap found alongside this fix (2026-07-28): migration 038 inserted Lab
// 46's `labs` row ("CAM Overflow") but never inserted its `lab_phases`
// rows — the lab exists in the catalog listing but has zero actual
// content. PhaseExists correctly returns false here today, which is the
// right behavior for a lab with no phases yet. This test is written to
// FAIL, not silently pass, once someone adds Lab 46's content — that's
// deliberate: the point is to force a visible decision (update this test
// to expect true) rather than let the catalog change unnoticed. Do not
// "fix" this by changing the assertion without first confirming
// migration 038 (or a follow-up) actually adds Lab 46's lab_phases rows.
func TestPhaseExists_Lab46_CurrentlyHasNoContent(t *testing.T) {
	pool := testPool(t)
	defer pool.Close()
	repo := NewRepository(pool)

	ok, err := repo.PhaseExists(context.Background(), 46, "build")
	if err != nil {
		t.Fatalf("PhaseExists(46, build): %v", err)
	}
	if ok {
		t.Error("Lab 46 has no lab_phases content as of 2026-07-28 — if this now passes, " +
			"migration 038 (or a follow-up) was updated to add it; update this test to assert " +
			"true and remove this comment rather than deleting the test")
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
