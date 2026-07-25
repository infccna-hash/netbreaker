package labsession

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgxpool"
)

var ErrNotFound = errors.New("lab session not found")

type Repository struct {
	db *pgxpool.Pool
}

func NewRepository(db *pgxpool.Pool) *Repository {
	return &Repository{db: db}
}

// ActiveCount returns the number of sessions currently occupying compute
// (provisioning, running, or idle_stopped — idle still holds the GNS3 project
// even though nodes are stopped, so it still counts against the cap until reaped).
func (r *Repository) ActiveCount(ctx context.Context) (int, error) {
	var n int
	err := r.db.QueryRow(ctx, `
		SELECT COUNT(*) FROM lab_sessions
		WHERE status IN ('provisioning','running','idle_stopped')
	`).Scan(&n)
	return n, err
}

// FindActiveForUserLab returns the existing session for this user+lab, if any
// (provisioning/running/idle_stopped). Used for the resume path.
func (r *Repository) FindActiveForUserLab(ctx context.Context, userID uuid.UUID, labID int) (*Session, error) {
	row := r.db.QueryRow(ctx, `
		SELECT id, user_id, lab_id, compute_id, gns3_project_id, status,
		       node_map, started_at, last_active_at, ended_at
		FROM lab_sessions
		WHERE user_id=$1 AND lab_id=$2
		  AND status IN ('provisioning','running','idle_stopped')
	`, userID, labID)
	return scanSession(row)
}

func (r *Repository) GetByID(ctx context.Context, id uuid.UUID) (*Session, error) {
	row := r.db.QueryRow(ctx, `
		SELECT id, user_id, lab_id, compute_id, gns3_project_id, status,
		       node_map, started_at, last_active_at, ended_at
		FROM lab_sessions WHERE id=$1
	`, id)
	return scanSession(row)
}

// Create inserts a new provisioning-status row. Relies on the EXCLUDE
// constraint as the final guard against a race with FindActiveForUserLab;
// callers should treat a unique_violation here as ErrSlotConflict.
func (r *Repository) Create(ctx context.Context, userID uuid.UUID, labID int, computeID string) (*Session, error) {
	row := r.db.QueryRow(ctx, `
		INSERT INTO lab_sessions (user_id, lab_id, compute_id, status)
		VALUES ($1, $2, $3, 'provisioning')
		RETURNING id, user_id, lab_id, compute_id, gns3_project_id, status,
		          node_map, started_at, last_active_at, ended_at
	`, userID, labID, computeID)
	return scanSession(row)
}

func (r *Repository) SetProvisioned(ctx context.Context, id uuid.UUID, gns3ProjectID string, nodes NodeMap) error {
	nodeJSON, err := json.Marshal(nodes)
	if err != nil {
		return fmt.Errorf("marshal node_map: %w", err)
	}
	_, err = r.db.Exec(ctx, `
		UPDATE lab_sessions
		SET gns3_project_id=$2, node_map=$3, status='running', last_active_at=now()
		WHERE id=$1
	`, id, gns3ProjectID, nodeJSON)
	return err
}

func (r *Repository) SetStatus(ctx context.Context, id uuid.UUID, status Status) error {
	_, err := r.db.Exec(ctx, `UPDATE lab_sessions SET status=$2 WHERE id=$1`, id, status)
	return err
}

func (r *Repository) Touch(ctx context.Context, id uuid.UUID) error {
	_, err := r.db.Exec(ctx, `UPDATE lab_sessions SET last_active_at=now() WHERE id=$1`, id)
	return err
}

func (r *Repository) End(ctx context.Context, id uuid.UUID) error {
	_, err := r.db.Exec(ctx, `
		UPDATE lab_sessions SET status='ended', ended_at=now() WHERE id=$1
	`, id)
	return err
}

// StaleRunning returns sessions past the idle threshold, for the reaper.
func (r *Repository) StaleRunning(ctx context.Context, idleMinutes int) ([]*Session, error) {
	rows, err := r.db.Query(ctx, `
		SELECT id, user_id, lab_id, compute_id, gns3_project_id, status,
		       node_map, started_at, last_active_at, ended_at
		FROM lab_sessions
		WHERE status='running'
		  AND last_active_at < now() - make_interval(mins => $1)
	`, idleMinutes)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var out []*Session
	for rows.Next() {
		s, err := scanSession(rows)
		if err != nil {
			return nil, err
		}
		out = append(out, s)
	}
	return out, rows.Err()
}

// StaleIdle returns idle_stopped sessions past the TTL, for full teardown.
func (r *Repository) StaleIdle(ctx context.Context, ttlHours int) ([]*Session, error) {
	rows, err := r.db.Query(ctx, `
		SELECT id, user_id, lab_id, compute_id, gns3_project_id, status,
		       node_map, started_at, last_active_at, ended_at
		FROM lab_sessions
		WHERE status='idle_stopped'
		  AND last_active_at < now() - make_interval(hours => $1)
	`, ttlHours)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var out []*Session
	for rows.Next() {
		s, err := scanSession(rows)
		if err != nil {
			return nil, err
		}
		out = append(out, s)
	}
	return out, rows.Err()
}

type rowScanner interface {
	Scan(dest ...any) error
}

func scanSession(row rowScanner) (*Session, error) {
	var s Session
	var nodeJSON []byte
	err := row.Scan(&s.ID, &s.UserID, &s.LabID, &s.ComputeID, &s.GNS3ProjectID,
		&s.Status, &nodeJSON, &s.StartedAt, &s.LastActiveAt, &s.EndedAt)
	if errors.Is(err, pgx.ErrNoRows) {
		return nil, ErrNotFound
	}
	if err != nil {
		return nil, err
	}
	if len(nodeJSON) > 0 {
		if err := json.Unmarshal(nodeJSON, &s.NodeMap); err != nil {
			return nil, fmt.Errorf("unmarshal node_map: %w", err)
		}
	}
	return &s, nil
}
