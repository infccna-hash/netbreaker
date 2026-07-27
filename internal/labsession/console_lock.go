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
type ConsoleLock struct {
	mu    sync.Mutex
	locks map[consoleLockKey]string // key → holder ("console" or "verify")
}

type consoleLockKey struct {
	sessionID uuid.UUID
	nodeName  string
}

// Holder constants for readability at call sites.
const (
	HolderConsole = "console"
	HolderVerify  = "verify"
)

// NewConsoleLock creates an empty ConsoleLock.
func NewConsoleLock() *ConsoleLock {
	return &ConsoleLock{
		locks: make(map[consoleLockKey]string),
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
	if existing, held := l.locks[key]; held {
		return nil, existing, false
	}
	l.locks[key] = holder

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
