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
