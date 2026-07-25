package labsession

import (
	"context"
	"log"
	"time"
)

// Reaper is a background goroutine that reclaims stale lab sessions.
//
// Two tiers:
//   - Running sessions idle past GNS3IdleTimeout → StopNodes + status=idle_stopped
//   - Idle_stopped sessions past GNS3SessionTTL → DeleteProject + status=ended
//
// The reaper is what makes the global concurrency cap (GNS3MaxSessions)
// meaningful in practice — without it every "close tab" is a permanently
// occupied slot for the next GNS3IdleTimeout window.
type Reaper struct {
	repo         *Repository
	gns3         GNS3Client
	idleTimeout  time.Duration
	sessionTTL   time.Duration
	tickInterval time.Duration
}

func NewReaper(repo *Repository, gns3 GNS3Client, idleTimeout, sessionTTL, tickInterval time.Duration) *Reaper {
	return &Reaper{
		repo:         repo,
		gns3:         gns3,
		idleTimeout:  idleTimeout,
		sessionTTL:   sessionTTL,
		tickInterval: tickInterval,
	}
}

// Start launches the reaper loop in a background goroutine.
// Call once from main.go after the Service is created.
// The loop runs until ctx is cancelled (server shutdown).
func (r *Reaper) Start(ctx context.Context) {
	go r.loop(ctx)
}

func (r *Reaper) loop(ctx context.Context) {
	ticker := time.NewTicker(r.tickInterval)
	defer ticker.Stop()

	log.Printf("reaper: started (idle_timeout=%v, session_ttl=%v, tick=%v)",
		r.idleTimeout, r.sessionTTL, r.tickInterval)

	for {
		select {
		case <-ctx.Done():
			log.Printf("reaper: shutting down")
			return
		case <-ticker.C:
			r.sweep(ctx)
		}
	}
}

func (r *Reaper) sweep(ctx context.Context) {
	// ── Tier 1: idle-running sessions → suspend ────────────────────────
	staleRunning, err := r.repo.StaleRunning(ctx, int(r.idleTimeout.Minutes()))
	if err != nil {
		log.Printf("reaper: StaleRunning query: %v", err)
	} else {
		for _, sess := range staleRunning {
			if sess.GNS3ProjectID == nil {
				// Safety: no GNS3 project yet, just mark failed.
				_ = r.repo.SetStatus(ctx, sess.ID, StatusFailed)
				continue
			}
			if err := r.gns3.StopNodes(ctx, *sess.GNS3ProjectID); err != nil {
				// GNS3 project may have been deleted (404) — treat as suspended anyway.
				log.Printf("reaper: stop nodes session=%s (will force idle): %v", sess.ID, err)
			}
			_ = r.repo.SetStatus(ctx, sess.ID, StatusIdleStopped)
			log.Printf("reaper: suspended session=%s user=%s lab=%d",
				sess.ID, sess.UserID, sess.LabID)
		}
	}

	// ── Tier 2: long-idle sessions → full teardown ────────────────────
	staleIdle, err := r.repo.StaleIdle(ctx, int(r.sessionTTL.Hours()))
	if err != nil {
		log.Printf("reaper: StaleIdle query: %v", err)
	} else {
		for _, sess := range staleIdle {
			if sess.GNS3ProjectID != nil {
				if err := r.gns3.DeleteProject(ctx, *sess.GNS3ProjectID); err != nil {
					log.Printf("reaper: delete project session=%s: %v", sess.ID, err)
				}
			}
			_ = r.repo.End(ctx, sess.ID)
			log.Printf("reaper: ended session=%s user=%s lab=%d",
				sess.ID, sess.UserID, sess.LabID)
		}
	}
}
