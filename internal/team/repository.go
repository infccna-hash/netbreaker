package team

import (
	"context"
	"errors"
	"fmt"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgxpool"

	"netbreaker.io/api/pkg/types"
)

var (
	ErrNotFound  = errors.New("team not found")
	ErrSeatLimit = errors.New("seat limit reached")
)

type Repository struct {
	pool *pgxpool.Pool
}

func NewRepository(pool *pgxpool.Pool) *Repository {
	return &Repository{pool: pool}
}

func (r *Repository) GetByOwnerID(ctx context.Context, ownerID uuid.UUID) (*types.Team, error) {
	var t types.Team
	err := r.pool.QueryRow(ctx,
		`SELECT id, name, owner_id, seat_count, created_at FROM teams WHERE owner_id = $1`, ownerID,
	).Scan(&t.ID, &t.Name, &t.OwnerID, &t.SeatCount, &t.CreatedAt)
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return nil, ErrNotFound
		}
		return nil, fmt.Errorf("GetByOwnerID: %w", err)
	}
	return &t, nil
}

// GetOrCreateForOwner returns the owner's team, creating it (and adding the
// owner as the first member) on first access. Bootcamp plan = one team.
func (r *Repository) GetOrCreateForOwner(ctx context.Context, ownerID uuid.UUID, teamName string) (*types.Team, error) {
	if t, err := r.GetByOwnerID(ctx, ownerID); err == nil {
		return t, nil
	} else if !errors.Is(err, ErrNotFound) {
		return nil, err
	}

	tx, err := r.pool.Begin(ctx)
	if err != nil {
		return nil, err
	}
	defer tx.Rollback(ctx)

	var t types.Team
	err = tx.QueryRow(ctx,
		`INSERT INTO teams (name, owner_id, seat_count) VALUES ($1, $2, 5)
		 RETURNING id, name, owner_id, seat_count, created_at`,
		teamName, ownerID,
	).Scan(&t.ID, &t.Name, &t.OwnerID, &t.SeatCount, &t.CreatedAt)
	if err != nil {
		return nil, fmt.Errorf("create team: %w", err)
	}

	_, err = tx.Exec(ctx,
		`INSERT INTO team_members (team_id, user_id, role) VALUES ($1, $2, 'owner')
		 ON CONFLICT DO NOTHING`, t.ID, ownerID)
	if err != nil {
		return nil, fmt.Errorf("add owner as member: %w", err)
	}

	if err := tx.Commit(ctx); err != nil {
		return nil, err
	}
	return &t, nil
}

func (r *Repository) GetMembersByTeamID(ctx context.Context, teamID uuid.UUID) ([]types.TeamMember, error) {
	rows, err := r.pool.Query(ctx,
		`SELECT tm.team_id, tm.user_id, tm.role, tm.joined_at,
		        u.id, u.email, u.name, u.plan, u.is_admin, u.created_at, u.updated_at
		 FROM team_members tm JOIN users u ON u.id = tm.user_id
		 WHERE tm.team_id = $1 ORDER BY tm.joined_at`, teamID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var members []types.TeamMember
	for rows.Next() {
		var m types.TeamMember
		m.User = &types.User{}
		err := rows.Scan(&m.TeamID, &m.UserID, &m.Role, &m.JoinedAt,
			&m.User.ID, &m.User.Email, &m.User.Name, &m.User.Plan,
			&m.User.IsAdmin, &m.User.CreatedAt, &m.User.UpdatedAt)
		if err != nil {
			return nil, err
		}
		members = append(members, m)
	}
	return members, rows.Err()
}

// MemberProgress returns each member's completed-phase count (out of 42).
func (r *Repository) MemberProgress(ctx context.Context, teamID uuid.UUID) ([]types.TeamMemberProgress, error) {
	rows, err := r.pool.Query(ctx,
		`SELECT u.id, u.email, u.name, COUNT(up.id) AS completed
		 FROM team_members tm
		 JOIN users u ON u.id = tm.user_id
		 LEFT JOIN user_progress up ON up.user_id = u.id
		 WHERE tm.team_id = $1
		 GROUP BY u.id, u.email, u.name
		 ORDER BY u.name`, teamID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var out []types.TeamMemberProgress
	for rows.Next() {
		var p types.TeamMemberProgress
		if err := rows.Scan(&p.UserID, &p.Email, &p.Name, &p.CompletedPhases); err != nil {
			return nil, err
		}
		p.TotalPhases = 42
		out = append(out, p)
	}
	return out, rows.Err()
}

// AddMember adds a user to a team, enforcing the seat limit.
func (r *Repository) AddMember(ctx context.Context, teamID, userID uuid.UUID, role string) error {
	var count, limit int
	err := r.pool.QueryRow(ctx,
		`SELECT (SELECT COUNT(*) FROM team_members WHERE team_id = $1), seat_count FROM teams WHERE id = $1`,
		teamID,
	).Scan(&count, &limit)
	if err != nil {
		return err
	}
	if count >= limit {
		return ErrSeatLimit
	}

	_, err = r.pool.Exec(ctx,
		`INSERT INTO team_members (team_id, user_id, role) VALUES ($1, $2, $3)
		 ON CONFLICT DO NOTHING`, teamID, userID, role)
	return err
}

func (r *Repository) RemoveMember(ctx context.Context, teamID, userID uuid.UUID) error {
	_, err := r.pool.Exec(ctx,
		`DELETE FROM team_members WHERE team_id = $1 AND user_id = $2 AND role <> 'owner'`,
		teamID, userID)
	return err
}
