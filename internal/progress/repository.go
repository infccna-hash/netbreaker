package progress

import (
	"context"
	"fmt"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5/pgxpool"

	"netbreaker.io/api/pkg/types"
)

type Repository struct {
	pool *pgxpool.Pool
}

func NewRepository(pool *pgxpool.Pool) *Repository {
	return &Repository{pool: pool}
}

func (r *Repository) GetAll(ctx context.Context, userID uuid.UUID) ([]types.UserProgress, error) {
	rows, err := r.pool.Query(ctx,
		`SELECT id, user_id, lab_id, phase, completed_at
		 FROM user_progress WHERE user_id = $1 ORDER BY lab_id, phase`, userID)
	if err != nil {
		return nil, fmt.Errorf("GetAll: %w", err)
	}
	defer rows.Close()

	var items []types.UserProgress
	for rows.Next() {
		var p types.UserProgress
		if err := rows.Scan(&p.ID, &p.UserID, &p.LabID, &p.Phase, &p.CompletedAt); err != nil {
			return nil, err
		}
		items = append(items, p)
	}
	return items, rows.Err()
}

func (r *Repository) Mark(ctx context.Context, userID uuid.UUID, labID int, phase string) error {
	_, err := r.pool.Exec(ctx,
		`INSERT INTO user_progress (user_id, lab_id, phase)
		 VALUES ($1, $2, $3)
		 ON CONFLICT (user_id, lab_id, phase) DO NOTHING`,
		userID, labID, phase)
	return err
}

func (r *Repository) Unmark(ctx context.Context, userID uuid.UUID, labID int, phase string) error {
	_, err := r.pool.Exec(ctx,
		`DELETE FROM user_progress WHERE user_id = $1 AND lab_id = $2 AND phase = $3`,
		userID, labID, phase)
	return err
}

// CountCompleted returns how many phases across all labs the user has completed.
// Prefer AllPhasesCompleted for certificate eligibility; this count-only check
// was the source of the "eligibility by coincidence" bug (2026-07-28).
func (r *Repository) CountCompleted(ctx context.Context, userID uuid.UUID) (int, error) {
	var count int
	err := r.pool.QueryRow(ctx,
		`SELECT COUNT(*) FROM user_progress WHERE user_id = $1`, userID,
	).Scan(&count)
	return count, err
}

// TotalPhases returns the current total number of phases across every lab in
// the catalog. Computed live rather than hardcoded, since the lab count grows
// over time (this is a curriculum, not a fixed set of 14).
func (r *Repository) TotalPhases(ctx context.Context) (int, error) {
	var total int
	err := r.pool.QueryRow(ctx, `SELECT COUNT(*) FROM lab_phases`).Scan(&total)
	return total, err
}

// AllPhasesCompleted returns true when the user has completed every phase
// defined in lab_phases (set membership — the user's (lab_id, phase) pairs
// must be a superset of the catalog's).  This replaces the COUNT-vs-COUNT
// check that could pass by coincidence (e.g. user completed 5 build phases
// while the catalog requires build+attack across 3 labs — same count,
// different set).
//
// Catalog-change behaviour (intentional): if a phase is added to lab_phases
// after the user has already been issued a certificate, AllPhasesCompleted
// returns false for that user until they complete the new phase.  This is
// correct — certificates are point-in-time assertions.  Already-issued
// certificates (rows in the certificates table) are unaffected.
func (r *Repository) AllPhasesCompleted(ctx context.Context, userID uuid.UUID) (bool, error) {
	var allDone bool
	err := r.pool.QueryRow(ctx, `
		SELECT NOT EXISTS (
			SELECT 1 FROM lab_phases lp
			WHERE NOT EXISTS (
				SELECT 1 FROM user_progress up
				WHERE up.lab_id  = lp.lab_id
				  AND up.phase   = lp.phase
				  AND up.user_id = $1
			)
		)
	`, userID).Scan(&allDone)
	return allDone, err
}
