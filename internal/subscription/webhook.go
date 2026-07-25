package subscription

import (
	"context"
	"encoding/json"
	"fmt"
	"io"
	"log"
	"net/http"
	"time"

	stripe "github.com/stripe/stripe-go/v76"
	"github.com/stripe/stripe-go/v76/webhook"

	"netbreaker.io/api/pkg/response"
	"netbreaker.io/api/pkg/types"
)

// StripeWebhook — ALWAYS verifies the Stripe signature before processing anything.
func (h *Handler) StripeWebhook(w http.ResponseWriter, r *http.Request) {
	body, err := io.ReadAll(io.LimitReader(r.Body, 1<<20)) // 1 MiB — Stripe events can exceed 64 KiB
	if err != nil {
		response.Error(w, http.StatusBadRequest, "failed to read body")
		return
	}

	sig := r.Header.Get("Stripe-Signature")
	event, err := webhook.ConstructEvent(body, sig, h.svc.cfg.StripeWebhookSecret)
	if err != nil {
		// Bad signature — reject. Do not log the body to avoid leaking data.
		w.WriteHeader(http.StatusBadRequest)
		return
	}

	if err := h.handleEvent(r.Context(), event); err != nil {
		log.Printf("webhook handler error [%s]: %v", event.Type, err)
		// Return 200 to Stripe regardless — retrying won't help a permanent error.
	}
	w.WriteHeader(http.StatusOK)
}

func (h *Handler) handleEvent(ctx context.Context, event stripe.Event) error {
	switch event.Type {
	case "checkout.session.completed":
		var sess stripe.CheckoutSession
		if err := json.Unmarshal(event.Data.Raw, &sess); err != nil {
			return fmt.Errorf("unmarshal checkout.session: %w", err)
		}
		return h.onCheckoutCompleted(ctx, &sess)

	case "customer.subscription.updated":
		var sub stripe.Subscription
		if err := json.Unmarshal(event.Data.Raw, &sub); err != nil {
			return fmt.Errorf("unmarshal subscription.updated: %w", err)
		}
		return h.onSubscriptionUpdated(ctx, &sub)

	case "customer.subscription.deleted":
		var sub stripe.Subscription
		if err := json.Unmarshal(event.Data.Raw, &sub); err != nil {
			return fmt.Errorf("unmarshal subscription.deleted: %w", err)
		}
		return h.onSubscriptionDeleted(ctx, &sub)
	}
	return nil
}

// planFromSubscription maps the subscription's active price ID back to a plan
// name. This is the source of truth for renewals/updates — never assume "pro".
func (h *Handler) planFromSubscription(sub *stripe.Subscription) string {
	if sub.Items != nil {
		for _, item := range sub.Items.Data {
			if item == nil || item.Price == nil {
				continue
			}
			switch item.Price.ID {
			case h.svc.cfg.StripeBootcampPriceID:
				return types.PlanBootcamp
			case h.svc.cfg.StripeProPriceID:
				return types.PlanPro
			}
		}
	}
	return types.PlanPro // safe fallback for a paid, active subscription
}

func (h *Handler) onCheckoutCompleted(ctx context.Context, sess *stripe.CheckoutSession) error {
	planName, ok := sess.Metadata["plan"]
	if !ok || planName == "" {
		planName = types.PlanPro
	}
	userIDStr, ok := sess.Metadata["user_id"]
	if !ok || userIDStr == "" {
		return fmt.Errorf("checkout.session.completed: missing user_id in metadata")
	}

	// Store Stripe customer ID on the user — needed for portal + subscription events.
	if sess.Customer != nil {
		if _, err := h.svc.pool.Exec(ctx,
			`UPDATE users SET stripe_customer_id = $1, updated_at = NOW() WHERE id::text = $2`,
			sess.Customer.ID, userIDStr,
		); err != nil {
			log.Printf("webhook: failed to store stripe_customer_id for user %s: %v", userIDStr, err)
		}
	}

	// Activate plan. 1-month fallback expiry; onSubscriptionUpdated corrects it
	// to Stripe's real period end once that event fires.
	exp := time.Now().AddDate(0, 1, 0)
	_, err := h.svc.pool.Exec(ctx,
		`UPDATE users SET plan = $1, plan_expires_at = $2, updated_at = NOW() WHERE id::text = $3`,
		planName, exp, userIDStr,
	)
	if err != nil {
		return fmt.Errorf("activate plan for user %s: %w", userIDStr, err)
	}
	return nil
}

func (h *Handler) onSubscriptionUpdated(ctx context.Context, sub *stripe.Subscription) error {
	if sub.Status != "active" && sub.Status != "trialing" {
		return h.onSubscriptionDeleted(ctx, sub)
	}
	if sub.Customer == nil {
		return fmt.Errorf("subscription.updated: missing customer")
	}

	plan := h.planFromSubscription(sub)
	exp := time.Unix(sub.CurrentPeriodEnd, 0)
	_, err := h.svc.pool.Exec(ctx,
		`UPDATE users SET plan = $1, plan_expires_at = $2, updated_at = NOW()
		 WHERE stripe_customer_id = $3`,
		plan, exp, sub.Customer.ID,
	)
	return err
}

func (h *Handler) onSubscriptionDeleted(ctx context.Context, sub *stripe.Subscription) error {
	if sub.Customer == nil {
		return fmt.Errorf("subscription.deleted: missing customer")
	}
	_, err := h.svc.pool.Exec(ctx,
		`UPDATE users SET plan = $1, plan_expires_at = NULL, updated_at = NOW()
		 WHERE stripe_customer_id = $2`,
		types.PlanFree, sub.Customer.ID,
	)
	return err
}
