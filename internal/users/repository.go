package users

import (
	"context"
	"errors"
	"fmt"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgxpool"

	"netbreaker.io/api/pkg/types"
)

var ErrNotFound = errors.New("user not found")

type Repository struct {
	pool *pgxpool.Pool
}

func NewRepository(pool *pgxpool.Pool) *Repository {
	return &Repository{pool: pool}
}

func (r *Repository) GetByID(ctx context.Context, id uuid.UUID) (*types.User, error) {
	var u types.User
	err := r.pool.QueryRow(ctx,
		`SELECT id, email, name, plan, plan_expires_at, stripe_customer_id, is_admin, created_at, updated_at
		 FROM users WHERE id = $1`, id,
	).Scan(&u.ID, &u.Email, &u.Name, &u.Plan, &u.PlanExpiresAt,
		&u.StripeCustomerID, &u.IsAdmin, &u.CreatedAt, &u.UpdatedAt)
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return nil, ErrNotFound
		}
		return nil, fmt.Errorf("GetByID: %w", err)
	}
	return &u, nil
}

func (r *Repository) GetByEmail(ctx context.Context, email string) (*types.User, error) {
	var u types.User
	err := r.pool.QueryRow(ctx,
		`SELECT id, email, name, plan, plan_expires_at, stripe_customer_id, is_admin, created_at, updated_at
		 FROM users WHERE lower(email) = lower($1)`, email,
	).Scan(&u.ID, &u.Email, &u.Name, &u.Plan, &u.PlanExpiresAt,
		&u.StripeCustomerID, &u.IsAdmin, &u.CreatedAt, &u.UpdatedAt)
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return nil, ErrNotFound
		}
		return nil, fmt.Errorf("GetByEmail: %w", err)
	}
	return &u, nil
}

func (r *Repository) UpdateName(ctx context.Context, id uuid.UUID, name string) (*types.User, error) {
	var u types.User
	err := r.pool.QueryRow(ctx,
		`UPDATE users SET name = $1, updated_at = NOW() WHERE id = $2
		 RETURNING id, email, name, plan, plan_expires_at, stripe_customer_id, is_admin, created_at, updated_at`,
		name, id,
	).Scan(&u.ID, &u.Email, &u.Name, &u.Plan, &u.PlanExpiresAt,
		&u.StripeCustomerID, &u.IsAdmin, &u.CreatedAt, &u.UpdatedAt)
	if err != nil {
		return nil, fmt.Errorf("UpdateName: %w", err)
	}
	return &u, nil
}

func (r *Repository) Delete(ctx context.Context, id uuid.UUID) error {
	_, err := r.pool.Exec(ctx, `DELETE FROM users WHERE id = $1`, id)
	return err
}

// SetPlan updates the user's plan. Pass nil expiresAt for free plan.
func (r *Repository) SetPlan(ctx context.Context, id uuid.UUID, plan string, expiresAt *time.Time) error {
	_, err := r.pool.Exec(ctx,
		`UPDATE users SET plan = $1, plan_expires_at = $2, updated_at = NOW() WHERE id = $3`,
		plan, expiresAt, id)
	return err
}

func (r *Repository) SetStripeCustomerID(ctx context.Context, id uuid.UUID, customerID string) error {
	_, err := r.pool.Exec(ctx,
		`UPDATE users SET stripe_customer_id = $1, updated_at = NOW() WHERE id = $2`,
		customerID, id)
	return err
}

func (r *Repository) GetByStripeCustomerID(ctx context.Context, customerID string) (*types.User, error) {
	var u types.User
	err := r.pool.QueryRow(ctx,
		`SELECT id, email, name, plan, plan_expires_at, stripe_customer_id, is_admin, created_at, updated_at
		 FROM users WHERE stripe_customer_id = $1`, customerID,
	).Scan(&u.ID, &u.Email, &u.Name, &u.Plan, &u.PlanExpiresAt,
		&u.StripeCustomerID, &u.IsAdmin, &u.CreatedAt, &u.UpdatedAt)
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return nil, ErrNotFound
		}
		return nil, fmt.Errorf("GetByStripeCustomerID: %w", err)
	}
	return &u, nil
}
