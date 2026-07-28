package certificate

import (
	"context"
	"crypto/rand"
	"errors"
	"fmt"
	"math/big"
	"strings"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgxpool"

	"netbreaker.io/api/internal/progress"
	"netbreaker.io/api/pkg/email"
	"netbreaker.io/api/pkg/types"
)

var (
	ErrNotEligible = errors.New("not eligible: complete every lab in the catalog first")
	ErrNotFound    = errors.New("certificate not found")
)

type Service struct {
	pool         *pgxpool.Pool
	progressRepo *progress.Repository
	emailClient  *email.Client
}

func NewService(pool *pgxpool.Pool, progressRepo *progress.Repository, emailClient *email.Client) *Service {
	return &Service{pool: pool, progressRepo: progressRepo, emailClient: emailClient}
}

// GetOrCreate returns existing certificate or creates one if user is eligible.
func (s *Service) GetOrCreate(ctx context.Context, userID uuid.UUID, userName, userEmail string) (*types.Certificate, error) {
	// Check if already issued
	existing, err := s.getByUserID(ctx, userID)
	if err == nil {
		return existing, nil
	}
	if !errors.Is(err, ErrNotFound) {
		return nil, err
	}

	// Check eligibility: the user's completed (lab_id, phase) set must be a
	// superset of the catalog's (lab_id, phase) set.  Set membership, not just
	// count equality, so a user who completed 5 build phases across different
	// labs cannot earn a certificate for a catalog that requires attack/harden.
	// Replaces the COUNT-vs-COUNT check that was the "eligibility by
	// coincidence" bug (2026-07-28).
	ok, err := s.progressRepo.AllPhasesCompleted(ctx, userID)
	if err != nil {
		return nil, err
	}
	if !ok {
		count, _ := s.progressRepo.CountCompleted(ctx, userID)
		total, _ := s.progressRepo.TotalPhases(ctx)
		return nil, fmt.Errorf("%w: %d/%d phases completed", ErrNotEligible, count, total)
	}

	// Issue certificate
	code, err := generateVerifyCode()
	if err != nil {
		return nil, fmt.Errorf("generate code: %w", err)
	}

	var cert types.Certificate
	err = s.pool.QueryRow(ctx,
		`INSERT INTO certificates (user_id, verify_code) VALUES ($1, $2)
		 RETURNING id, user_id, issued_at, verify_code`,
		userID, code,
	).Scan(&cert.ID, &cert.UserID, &cert.IssuedAt, &cert.VerifyCode)
	if err != nil {
		return nil, fmt.Errorf("insert certificate: %w", err)
	}

	// Send email in background — don't fail the request if email fails
	go func() {
		_ = s.emailClient.SendCertificate(userEmail, userName, cert.VerifyCode)
	}()

	return &cert, nil
}

// VerifyByCode looks up a certificate by its public verify code (no auth required).
func (s *Service) VerifyByCode(ctx context.Context, code string) (map[string]any, error) {
	var cert types.Certificate
	var userName string
	err := s.pool.QueryRow(ctx,
		`SELECT c.id, c.user_id, c.issued_at, c.verify_code, u.name
		 FROM certificates c JOIN users u ON u.id = c.user_id
		 WHERE c.verify_code = $1`, code,
	).Scan(&cert.ID, &cert.UserID, &cert.IssuedAt, &cert.VerifyCode, &userName)
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return nil, ErrNotFound
		}
		return nil, err
	}

	return map[string]any{
		"valid":       true,
		"name":        userName,
		"issued_at":   cert.IssuedAt,
		"verify_code": cert.VerifyCode,
	}, nil
}

func (s *Service) getByUserID(ctx context.Context, userID uuid.UUID) (*types.Certificate, error) {
	var cert types.Certificate
	err := s.pool.QueryRow(ctx,
		`SELECT id, user_id, issued_at, verify_code FROM certificates WHERE user_id = $1`, userID,
	).Scan(&cert.ID, &cert.UserID, &cert.IssuedAt, &cert.VerifyCode)
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return nil, ErrNotFound
		}
		return nil, err
	}
	return &cert, nil
}

func generateVerifyCode() (string, error) {
	const chars = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789"
	var sb strings.Builder
	sb.WriteString("NB-")
	for i := 0; i < 6; i++ {
		n, err := rand.Int(rand.Reader, big.NewInt(int64(len(chars))))
		if err != nil {
			return "", err
		}
		sb.WriteByte(chars[n.Int64()])
	}
	return sb.String(), nil
}
