package labsession

import (
	"fmt"
	"sync"

	"github.com/google/uuid"
)

// ConsoleLock serializes access to GNS3 console ports across the
// interactive WebSocket console and the headless verify path.
//
// GNS3 IOU/Dynamips consoles are single-connection: two simultaneous
// TCP connections to the same (host, port) produce undefined behavior.
// This lock prevents verify from sending show commands while a student
// has the interactive console open, and vice versa.
//
// Both paths use TryLock (non-blocking). When the lock is already held,
// the caller receives the holder type so it can tailor the user-facing
// message ("close the console" vs "another verification is already
// running").
//
// The lock is scoped to (session, node) so two students in different
// sessions never contend, and one student can verify one node while
// another node in the same session has an interactive console open.
//
// ── SINGLE-PROCESS CONSTRAINT ──────────────────────────────────────
//
// This lock is in-memory and scoped to a single OS process. It assumes
// every WebSocket console and every verify request for a given session
// lands in the SAME process. Two failure modes if that stops being true:
//
//  1. Horizontal scaling / load balancer: if console and verify route
//     to different replicas, the lock is silently void — both paths
//     will acquire "the lock" independently and race on the console.
//  2. Rolling deploys: the old process holds a console lock; the new
//     process sees no lock and lets verify through — same race.
//
// As long as the deployment is a single-instance Docker container with
// no horizontal scaling (current architecture), these constraints hold.
// If multi-instance is ever introduced, this lock MUST move to shared
// state (PostgreSQL advisory lock or Redis with TTL) before the feature
// flag is enabled — do not just deploy a second replica.
//
// ── PREEMPTION ─────────────────────────────────────────────────────
//
// When a student clicks Verify with the interactive console open (the
// normal workflow, not a race), the verify handler can forcibly close
// the console WebSocket via ForceRelease, acquire the lock, run the
// verifier, and let the frontend reconnect naturally. This removes the
// cross-team dependency on frontend behavior and avoids a confusing
// "close the console" rejection during ordinary use.
//
// The console path calls SetPreempt to register a callback that closes
// its WebSocket. ForceRelease calls that callback, then releases the
// lock atomically.
type ConsoleLock struct {
	mu       sync.Mutex
	locks    map[consoleLockKey]*lockEntry
}

type consoleLockKey struct {
	sessionID uuid.UUID
	nodeName  string
}

type lockEntry struct {
	holder   string   // "console" or "verify"
	preempt  func()   // called by ForceRelease to close the console WebSocket
}

// Holder constants for readability at call sites.
const (
	HolderConsole = "console"
	HolderVerify  = "verify"
)

// NewConsoleLock creates an empty ConsoleLock.
func NewConsoleLock() *ConsoleLock {
	return &ConsoleLock{
		locks: make(map[consoleLockKey]*lockEntry),
	}
}

// TryLock attempts to acquire the lock for (sessionID, nodeName) on
// behalf of holder. Returns:
//
//   - unlock func + "" + true on success. unlock is safe to call
//     multiple times; only the first call releases the lock.
//   - nil + heldBy + false if already held. heldBy is the holder
//     string ("console" or "verify") so the caller can tailor the
//     error message to the actual conflict.
func (l *ConsoleLock) TryLock(sessionID uuid.UUID, nodeName, holder string) (unlock func(), heldBy string, ok bool) {
	l.mu.Lock()
	defer l.mu.Unlock()

	key := consoleLockKey{sessionID, nodeName}
	if entry, held := l.locks[key]; held {
		return nil, entry.holder, false
	}
	entry := &lockEntry{holder: holder}
	l.locks[key] = entry

	released := false
	unlock = func() {
		l.mu.Lock()
		defer l.mu.Unlock()
		if !released {
			delete(l.locks, key)
			released = true
		}
	}
	return unlock, "", true
}

// SetPreempt registers a callback that ForceRelease will invoke to
// close the console's WebSocket before releasing the lock. This is
// called by the console path after successfully acquiring the lock.
// Only one callback may be registered per key; subsequent calls
// replace the previous callback.
func (l *ConsoleLock) SetPreempt(sessionID uuid.UUID, nodeName string, fn func()) {
	l.mu.Lock()
	defer l.mu.Unlock()

	key := consoleLockKey{sessionID, nodeName}
	if entry, ok := l.locks[key]; ok {
		entry.preempt = fn
	}
}

// ForceRelease forcibly releases the lock for (sessionID, nodeName)
// if it is held by expectedHolder. If a preempt callback was
// registered (by the console path), it is called first to close the
// WebSocket. Returns true if the lock was released.
//
// This enables the server-side preemption flow: when verify
// encounters a console-vs-own-console contention, it calls
// ForceRelease to close the console, then acquires the lock for
// itself.
func (l *ConsoleLock) ForceRelease(sessionID uuid.UUID, nodeName, expectedHolder string) bool {
	l.mu.Lock()
	key := consoleLockKey{sessionID, nodeName}
	entry, ok := l.locks[key]
	if !ok || entry.holder != expectedHolder {
		l.mu.Unlock()
		return false
	}
	preempt := entry.preempt
	delete(l.locks, key)
	l.mu.Unlock()

	// Call preempt outside the lock to avoid deadlocks — the
	// callback may itself try to interact with the lock (unlock).
	if preempt != nil {
		preempt()
	}
	return true
}

// ErrNodeLocked is returned when a console/node lock is held by
// another operation (verify running while console tries to open,
// or console open while verify tries to run).
type ErrNodeLocked struct {
	SessionID uuid.UUID
	NodeName  string
}

func (e *ErrNodeLocked) Error() string {
	return fmt.Sprintf("node %q in session %s is locked by another operation", e.NodeName, e.SessionID)
}
