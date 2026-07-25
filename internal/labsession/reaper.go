package labsession

import (
	"context"
	"log"
	"time"

	"github.com/google/uuid"
)

// maxStopAttempts is how many consecutive sweeps may fail to gracefully stop a
// running session's nodes before the reaper escalates to a forced teardown
// (DeleteProject). This bounds how long leaked-but-DB-counted nodes can hold
// RAM on the compute host when GNS3 is unresponsive.
const maxStopAttempts = 3

// Reaper is a background goroutine that reclaims stale lab sessions.
//
// Two tiers:
//   - Running sessions idle past GNS3IdleTimeout → StopNodes + status=idle_stopped
//   - Idle_stopped sessions past GNS3SessionTTL → DeleteProject + status=ended
//
// The reaper is what makes the global concurrency cap (GNS3MaxSessions)
// meaningful in practice — without it every "close tab" is a permanently
// occupied slot for the next GNS3IdleTimeout window.
//
// Invariant it must preserve: a session's DB status is only advanced to a
// state that frees a capacity slot (ended) once the underlying GNS3 resources
// are actually gone. Advancing status on a *failed* teardown is what makes the
// cap fiction — the DB frees the slot, new launches pile onto the still-running
// nodes, and the host melts. So on teardown failure we keep the slot counted
// and retry, escalating to a forced delete rather than optimistically ending.
type Reaper struct {
	repo         *Repository
	gns3         GNS3Client
	idleTimeout  time.Duration
	sessionTTL   time.Duration
	tickInterval time.Duration
	opTimeout    time.Duration // per-call deadline for each GNS3 REST op

	// verifier confirms a session's compute resources are actually gone before
	// the reaper frees its capacity slot. Defaulted from the GNS3 client in
	// NewReaper; overridable in tests.
	verifier TeardownVerifier

	// stopAttempts tracks consecutive failed graceful-stop attempts per session.
	// Single-goroutine access (only touched inside sweep), so no lock needed.
	stopAttempts map[uuid.UUID]int
}

func NewReaper(repo *Repository, gns3 GNS3Client, idleTimeout, sessionTTL, tickInterval, opTimeout time.Duration) *Reaper {
	if opTimeout <= 0 || opTimeout >= tickInterval {
		// A per-op timeout that is unset or >= the tick would let a single
		// stuck call stall the whole sweep. Clamp to half the tick.
		opTimeout = tickInterval / 2
	}
	return &Reaper{
		repo:         repo,
		gns3:         gns3,
		idleTimeout:  idleTimeout,
		sessionTTL:   sessionTTL,
		tickInterval: tickInterval,
		opTimeout:    opTimeout,
		verifier:     NewGNS3TeardownVerifier(gns3),
		stopAttempts: make(map[uuid.UUID]int),
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

	log.Printf("reaper: started (idle_timeout=%v, session_ttl=%v, tick=%v, op_timeout=%v)",
		r.idleTimeout, r.sessionTTL, r.tickInterval, r.opTimeout)

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

// op runs a single GNS3 REST call under a bounded, per-operation deadline so a
// starved/unresponsive GNS3 cannot stall the whole sweep. It does NOT inherit
// the server-lifetime ctx's (absent) deadline.
func (r *Reaper) op(parent context.Context, fn func(context.Context) error) error {
	octx, cancel := context.WithTimeout(parent, r.opTimeout)
	defer cancel()
	return fn(octx)
}

func (r *Reaper) sweep(ctx context.Context) {
	// ── Tier 1: idle-running sessions → suspend ────────────────────────
	staleRunning, err := r.repo.StaleRunning(ctx, int(r.idleTimeout.Minutes()))
	if err != nil {
		log.Printf("reaper: StaleRunning query: %v", err)
	} else {
		for _, sess := range staleRunning {
			r.suspend(ctx, sess)
		}
	}

	// ── Tier 2: long-idle sessions → full teardown ────────────────────
	staleIdle, err := r.repo.StaleIdle(ctx, int(r.sessionTTL.Hours()))
	if err != nil {
		log.Printf("reaper: StaleIdle query: %v", err)
	} else {
		for _, sess := range staleIdle {
			r.teardown(ctx, sess)
		}
	}
}

// suspend handles a single idle-running session (Tier 1).
func (r *Reaper) suspend(ctx context.Context, sess *Session) {
	if sess.GNS3ProjectID == nil {
		// No GNS3 project yet — nothing running to leak; mark failed.
		_ = r.repo.SetStatus(ctx, sess.ID, StatusFailed)
		delete(r.stopAttempts, sess.ID)
		return
	}

	err := r.op(ctx, func(c context.Context) error {
		return r.gns3.StopNodes(c, *sess.GNS3ProjectID)
	})
	if err == nil {
		// Nodes are stopped. Slot stays counted (idle_stopped still counts
		// toward the cap) until Tier 2 tears it down.
		_ = r.repo.SetStatus(ctx, sess.ID, StatusIdleStopped)
		delete(r.stopAttempts, sess.ID)
		log.Printf("reaper: suspended session=%s user=%s lab=%d",
			sess.ID, sess.UserID, sess.LabID)
		return
	}

	// Graceful stop failed — the emulated nodes may still be running and
	// consuming RAM. Do NOT advance to idle_stopped on the strength of a failed
	// stop; keep the session 'running' so it stays in the Tier-1 queue and the
	// slot stays honestly counted. Retry, then escalate to a forced teardown.
	r.stopAttempts[sess.ID]++
	attempts := r.stopAttempts[sess.ID]
	log.Printf("reaper: stop nodes session=%s FAILED (attempt %d/%d): %v",
		sess.ID, attempts, maxStopAttempts, err)

	if attempts >= maxStopAttempts {
		// Escalation: force the whole project down to guarantee the host gets
		// its RAM back. This destroys a resumable session, which is the right
		// trade on a small compute host — a wedged session is worse than a lost
		// one. Only free the slot (End) if the forced delete actually succeeds.
		derr := r.op(ctx, func(c context.Context) error {
			return r.gns3.DeleteProject(c, *sess.GNS3ProjectID)
		})
		if derr != nil {
			log.Printf("reaper: FORCE delete session=%s FAILED after %d stop attempts: %v "+
				"(slot kept counted; GNS3 host may need manual attention)",
				sess.ID, attempts, derr)
			return // keep 'running', keep slot, try again next sweep
		}
		_ = r.repo.End(ctx, sess.ID)
		delete(r.stopAttempts, sess.ID)
		log.Printf("reaper: force-ended wedged session=%s user=%s lab=%d after %d failed stops",
			sess.ID, sess.UserID, sess.LabID, attempts)
	}
}

// teardown handles a single long-idle session (Tier 2).
func (r *Reaper) teardown(ctx context.Context, sess *Session) {
	if sess.GNS3ProjectID == nil {
		// Nothing to delete on the compute host — safe to end.
		_ = r.repo.End(ctx, sess.ID)
		delete(r.stopAttempts, sess.ID)
		return
	}

	// Gate the slot release on VERIFIED teardown, not on a delete response.
	// The verifier deletes the project and confirms — via node status + project
	// 404 + a settle cushion — that GNS3 no longer accounts for this session's
	// resources. Only positive confirmation frees the slot; any uncertainty
	// (failed delete, unconfirmed disappearance, GNS3 unreachable, timeout)
	// returns an error and the session stays idle_stopped (still counted) to be
	// retried next sweep. This makes teardown a convergence loop: every pass
	// re-establishes the same fact rather than advancing a fragile state
	// sequence, so a crash or partial teardown mid-way is harmless — the next
	// pass simply re-checks and converges.
	err := r.op(ctx, func(c context.Context) error {
		return r.verifier.WaitTeardownComplete(c, *sess.GNS3ProjectID)
	})
	if err != nil {
		log.Printf("reaper: teardown session=%s NOT confirmed (slot kept counted, will retry): %v",
			sess.ID, err)
		return
	}
	_ = r.repo.End(ctx, sess.ID)
	delete(r.stopAttempts, sess.ID)
	log.Printf("reaper: ended session=%s user=%s lab=%d (teardown verified)", sess.ID, sess.UserID, sess.LabID)
}
