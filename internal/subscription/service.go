package subscription

import (
	"context"
	"fmt"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5/pgxpool"
	stripe "github.com/stripe/stripe-go/v76"
	"github.com/stripe/stripe-go/v76/billingportal/session"
	checkoutsession "github.com/stripe/stripe-go/v76/checkout/session"

	"netbreaker.io/api/internal/users"
	"netbreaker.io/api/pkg/config"
	"netbreaker.io/api/pkg/types"
)

type Service struct {
	cfg      *config.Config
	pool     *pgxpool.Pool
	userRepo *users.Repository
}

func NewService(cfg *config.Config, pool *pgxpool.Pool, userRepo *users.Repository) *Service {
	stripe.Key = cfg.StripeSecretKey
	return &Service{cfg: cfg, pool: pool, userRepo: userRepo}
}

func (s *Service) GetPlan(ctx context.Context, userID uuid.UUID) (map[string]any, error) {
	user, err := s.userRepo.GetByID(ctx, userID)
	if err != nil {
		return nil, err
	}
	return map[string]any{
		"plan":            user.Plan,
		"plan_expires_at": user.PlanExpiresAt,
	}, nil
}

func (s *Service) CreateCheckoutSession(ctx context.Context, userID uuid.UUID, planName string) (string, error) {
	user, err := s.userRepo.GetByID(ctx, userID)
	if err != nil {
		return "", err
	}

	priceID := s.cfg.StripeProPriceID
	if planName == types.PlanBootcamp {
		priceID = s.cfg.StripeBootcampPriceID
	}

	params := &stripe.CheckoutSessionParams{
		Mode: stripe.String(string(stripe.CheckoutSessionModeSubscription)),
		LineItems: []*stripe.CheckoutSessionLineItemParams{
			{Price: stripe.String(priceID), Quantity: stripe.Int64(1)},
		},
		SuccessURL:    stripe.String(s.cfg.FrontendURL + "/dashboard?upgraded=true"),
		CancelURL:     stripe.String(s.cfg.FrontendURL + "/pricing"),
		CustomerEmail: stripe.String(user.Email),
		Metadata:      map[string]string{"user_id": userID.String(), "plan": planName},
	}

	sess, err := checkoutsession.New(params)
	if err != nil {
		return "", fmt.Errorf("create checkout session: %w", err)
	}
	return sess.URL, nil
}

func (s *Service) CreatePortalSession(ctx context.Context, userID uuid.UUID) (string, error) {
	user, err := s.userRepo.GetByID(ctx, userID)
	if err != nil {
		return "", err
	}
	if user.StripeCustomerID == nil {
		return "", fmt.Errorf("user has no Stripe customer")
	}

	params := &stripe.BillingPortalSessionParams{
		Customer:  stripe.String(*user.StripeCustomerID),
		ReturnURL: stripe.String(s.cfg.FrontendURL + "/dashboard"),
	}
	sess, err := session.New(params)
	if err != nil {
		return "", fmt.Errorf("create portal session: %w", err)
	}
	return sess.URL, nil
}
