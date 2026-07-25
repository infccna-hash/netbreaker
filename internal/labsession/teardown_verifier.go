package labsession

import (
	"context"
	"fmt"
	"time"
)

// teardownSettleDelay provides headroom for asynchronous emulator shutdown
// after GNS3 reports teardown complete. This is a safety margin, not a
// correctness requirement: GNS3 can report a node "stopped" and a project
// "gone" before the underlying QEMU process has fully exited and KVM has
// released its RAM. The delay is a crude operational cushion for that window
// and may be tuned or removed if a stronger completion signal becomes
// available (see WaitTeardownComplete's doc).
const teardownSettleDelay = 2 * time.Second

// teardownPollInterval is how often the verifier re-checks a not-yet-satisfied
// condition. Kept short so convergence is quick within the caller's deadline.
const teardownPollInterval = 500 * time.Millisecond

// TeardownVerifier is the single fact the reaper depends on before it will
// release a session's capacity slot: that the session no longer consumes
// compute resources on the host. The reaper does not know HOW that is verified
// — only that the invariant is satisfied when WaitTeardownComplete returns nil.
//
// This is deliberately a narrow interface so the verification strategy can
// change (node-status + 404 today; async task polling or host-memory metrics
// tomorrow) without touching the reaper.
type TeardownVerifier interface {
	// WaitTeardownComplete blocks until teardown is confirmed complete, the
	// context deadline is reached, or a hard error occurs. It returns nil ONLY
	// on positive evidence of completion. Any uncertainty — timeout, transport
	// error, GNS3 unreachable, unexpected status — returns a non-nil error, so
	// the caller keeps the slot counted and retries. Success is never inferred
	// from the absence of evidence.
	WaitTeardownComplete(ctx context.Context, projectID string) error
}

// GNS3TeardownVerifier verifies teardown using the strongest signals the GNS3
// REST API exposes.
//
// Current implementation:
//
//  1. Wait for all nodes to report stopped, or the node list to disappear.
//  2. Delete the project (idempotent; 404 = already gone = ok).
//  3. Wait for the project to become unreachable (404).
//  4. Wait a short settle interval.
//
// This confirms GNS3 *bookkeeping* has converged. It does NOT prove the host
// kernel has reclaimed every byte of RAM or that every emulator process has
// exited — the REST API has no view of Falcon's process table or KVM's
// allocator. The settle delay is a cushion for that residual window, not a
// guarantee. If a future GNS3 release exposes an async-teardown task handle or
// a host-memory signal, replace the checks here; the reaper is unaffected.
type GNS3TeardownVerifier struct {
	gns3         GNS3Client
	settleDelay  time.Duration
	pollInterval time.Duration
}

func NewGNS3TeardownVerifier(gns3 GNS3Client) *GNS3TeardownVerifier {
	return &GNS3TeardownVerifier{
		gns3:         gns3,
		settleDelay:  teardownSettleDelay,
		pollInterval: teardownPollInterval,
	}
}

func (v *GNS3TeardownVerifier) WaitTeardownComplete(ctx context.Context, projectID string) error {
	// 1. All nodes stopped (or gone). Should already hold by Tier 2, but the
	//    invariant is re-established rather than assumed.
	if err := v.waitUntil(ctx, func(c context.Context) (bool, error) {
		return v.gns3.NodesStopped(c, projectID)
	}); err != nil {
		return fmt.Errorf("nodes not confirmed stopped: %w", err)
	}

	// 2. Delete (idempotent — a repeat on an already-deleted project is ok).
	if err := v.gns3.DeleteProject(ctx, projectID); err != nil {
		return fmt.Errorf("delete project: %w", err)
	}

	// 3. Confirm the project is actually gone from GNS3's model.
	if err := v.waitUntil(ctx, func(c context.Context) (bool, error) {
		exists, err := v.gns3.ProjectExists(c, projectID)
		return !exists, err
	}); err != nil {
		return fmt.Errorf("project not confirmed gone: %w", err)
	}

	// 4. Settle cushion for asynchronous emulator/KVM shutdown.
	select {
	case <-time.After(v.settleDelay):
		return nil
	case <-ctx.Done():
		return ctx.Err()
	}
}

// waitUntil polls cond until it reports true, the context expires, or cond
// returns an error. Fail-closed: an error from cond (transport failure, GNS3
// unreachable, unexpected status) propagates immediately — it is never treated
// as "condition satisfied". A ctx timeout likewise returns an error, so an
// unconfirmed teardown never advances.
func (v *GNS3TeardownVerifier) waitUntil(ctx context.Context, cond func(context.Context) (bool, error)) error {
	for {
		ok, err := cond(ctx)
		if err != nil {
			return err
		}
		if ok {
			return nil
		}
		select {
		case <-time.After(v.pollInterval):
			// re-check
		case <-ctx.Done():
			return ctx.Err()
		}
	}
}
