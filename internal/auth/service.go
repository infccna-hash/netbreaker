package auth

import (
	"context"
	"crypto/rand"
	"crypto/sha256"
	"encoding/hex"
	"errors"
	"fmt"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgxpool"
	"golang.org/x/crypto/bcrypt"

	jwtutil "netbreaker.io/api/pkg/jwt"
	"netbreaker.io/api/pkg/types"
)

var (
	ErrInvalidCredentials = errors.New("invalid email or password")
	ErrEmailTaken         = errors.New("email already registered")
	ErrNotFound           = errors.New("not found")
	ErrTokenInvalid       = errors.New("refresh token invalid")
)

const bcryptCost = 12

type Service struct {
	pool       *pgxpool.Pool
	keys       *jwtutil.KeyPair
	accessTTL  time.Duration
	refreshTTL time.Duration
}

func NewService(pool *pgxpool.Pool, keys *jwtutil.KeyPair, accessTTL, refreshTTL time.Duration) *Service {
	return &Service{pool: pool, keys: keys, accessTTL: accessTTL, refreshTTL: refreshTTL}
}

type TokenPair struct {
	AccessToken  string
	RefreshToken string // raw (sent to client), NOT the hash
}

// Register creates a new user and returns a token pair.
func (s *Service) Register(ctx context.Context, email, password, name string) (*types.User, *TokenPair, error) {
	// Check if email is taken
	var exists bool
	err := s.pool.QueryRow(ctx,
		`SELECT EXISTS(SELECT 1 FROM users WHERE lower(email) = lower($1))`, email,
	).Scan(&exists)
	if err != nil {
		return nil, nil, fmt.Errorf("check email: %w", err)
	}
	if exists {
		return nil, nil, ErrEmailTaken
	}

	hash, err := bcrypt.GenerateFromPassword([]byte(password), bcryptCost)
	if err != nil {
		return nil, nil, fmt.Errorf("hash password: %w", err)
	}

	var user types.User
	err = s.pool.QueryRow(ctx,
		`INSERT INTO users (email, password_hash, name)
		 VALUES ($1, $2, $3)
		 RETURNING id, email, name, plan, plan_expires_at, stripe_customer_id, is_admin, created_at, updated_at`,
		email, string(hash), name,
	).Scan(&user.ID, &user.Email, &user.Name, &user.Plan, &user.PlanExpiresAt,
		&user.StripeCustomerID, &user.IsAdmin, &user.CreatedAt, &user.UpdatedAt)
	if err != nil {
		return nil, nil, fmt.Errorf("insert user: %w", err)
	}

	tokens, err := s.issueTokenPair(ctx, &user)
	if err != nil {
		return nil, nil, err
	}
	return &user, tokens, nil
}

// Login verifies credentials and returns a token pair.
func (s *Service) Login(ctx context.Context, email, password string) (*types.User, *TokenPair, error) {
	var user types.User
	var hash string
	err := s.pool.QueryRow(ctx,
		`SELECT id, email, name, plan, plan_expires_at, stripe_customer_id, is_admin, created_at, updated_at, password_hash
		 FROM users WHERE lower(email) = lower($1)`, email,
	).Scan(&user.ID, &user.Email, &user.Name, &user.Plan, &user.PlanExpiresAt,
		&user.StripeCustomerID, &user.IsAdmin, &user.CreatedAt, &user.UpdatedAt, &hash)
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return nil, nil, ErrInvalidCredentials
		}
		return nil, nil, fmt.Errorf("get user: %w", err)
	}

	if err := bcrypt.CompareHashAndPassword([]byte(hash), []byte(password)); err != nil {
		return nil, nil, ErrInvalidCredentials
	}

	// Downgrade plan if expired
	if user.PlanExpiresAt != nil && user.PlanExpiresAt.Before(time.Now()) {
		_, _ = s.pool.Exec(ctx,
			`UPDATE users SET plan = $1, plan_expires_at = NULL, updated_at = NOW() WHERE id = $2`,
			types.PlanFree, user.ID)
		user.Plan = types.PlanFree
		user.PlanExpiresAt = nil
	}

	// Revoke all existing refresh tokens for this user
	_, _ = s.pool.Exec(ctx,
		`UPDATE refresh_tokens SET revoked_at = NOW() WHERE user_id = $1 AND revoked_at IS NULL`, user.ID)

	tokens, err := s.issueTokenPair(ctx, &user)
	if err != nil {
		return nil, nil, err
	}
	return &user, tokens, nil
}

// Refresh rotates the refresh token and returns a new access token.
func (s *Service) Refresh(ctx context.Context, rawToken string) (string, string, error) {
	hash := hashToken(rawToken)

	var userID uuid.UUID
	var expiresAt time.Time
	var revokedAt *time.Time

	err := s.pool.QueryRow(ctx,
		`SELECT user_id, expires_at, revoked_at FROM refresh_tokens WHERE token_hash = $1`, hash,
	).Scan(&userID, &expiresAt, &revokedAt)
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return "", "", ErrTokenInvalid
		}
		return "", "", fmt.Errorf("lookup refresh token: %w", err)
	}

	// Token theft detection: if already revoked, revoke ALL tokens for this user
	if revokedAt != nil {
		_, _ = s.pool.Exec(ctx,
			`UPDATE refresh_tokens SET revoked_at = NOW() WHERE user_id = $1`, userID)
		return "", "", ErrTokenInvalid
	}

	if time.Now().After(expiresAt) {
		return "", "", ErrTokenInvalid
	}

	// Revoke the used token immediately (rotation)
	_, err = s.pool.Exec(ctx,
		`UPDATE refresh_tokens SET revoked_at = NOW() WHERE token_hash = $1`, hash)
	if err != nil {
		return "", "", fmt.Errorf("revoke old token: %w", err)
	}

	// Get current user for fresh claims
	var user types.User
	err = s.pool.QueryRow(ctx,
		`SELECT id, email, name, plan, plan_expires_at, is_admin FROM users WHERE id = $1`, userID,
	).Scan(&user.ID, &user.Email, &user.Name, &user.Plan, &user.PlanExpiresAt, &user.IsAdmin)
	if err != nil {
		return "", "", fmt.Errorf("get user: %w", err)
	}

	tokens, err := s.issueTokenPair(ctx, &user)
	if err != nil {
		return "", "", err
	}
	return tokens.AccessToken, tokens.RefreshToken, nil
}

// Logout revokes the given refresh token.
func (s *Service) Logout(ctx context.Context, rawToken string) error {
	hash := hashToken(rawToken)
	_, err := s.pool.Exec(ctx,
		`UPDATE refresh_tokens SET revoked_at = NOW() WHERE token_hash = $1 AND revoked_at IS NULL`, hash)
	return err
}

// issueTokenPair creates a new access + refresh token pair and stores the refresh token hash.
func (s *Service) issueTokenPair(ctx context.Context, user *types.User) (*TokenPair, error) {
	accessToken, err := s.keys.GenerateAccessToken(user.ID, user.Plan, user.IsAdmin, s.accessTTL)
	if err != nil {
		return nil, fmt.Errorf("sign access token: %w", err)
	}

	rawRefresh, err := generateRandom32()
	if err != nil {
		return nil, fmt.Errorf("generate refresh token: %w", err)
	}
	refreshHash := hashToken(rawRefresh)

	_, err = s.pool.Exec(ctx,
		`INSERT INTO refresh_tokens (user_id, token_hash, expires_at) VALUES ($1, $2, $3)`,
		user.ID, refreshHash, time.Now().Add(s.refreshTTL),
	)
	if err != nil {
		return nil, fmt.Errorf("store refresh token: %w", err)
	}

	return &TokenPair{AccessToken: accessToken, RefreshToken: rawRefresh}, nil
}

func hashToken(raw string) string {
	sum := sha256.Sum256([]byte(raw))
	return hex.EncodeToString(sum[:])
}

func generateRandom32() (string, error) {
	b := make([]byte, 32)
	if _, err := rand.Read(b); err != nil {
		return "", err
	}
	return hex.EncodeToString(b), nil
}
