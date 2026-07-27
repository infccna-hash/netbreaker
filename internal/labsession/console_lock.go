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
// Both paths use TryLock (non-blocking):
//   - Interactive console: if already locked, returns "verification in
//     progress — please wait" to the WebSocket client.
//   - Verify handler: if already locked, returns "please close the
//     console before verifying" as a VerifyResult.
//
// The lock is scoped to (session, node) so two students in different
// sessions never contend, and one student can verify one node while
// another node in the same session has an interactive console open.
type ConsoleLock struct {
	mu    sync.Mutex
	locks map[consoleLockKey]struct{}
}

type consoleLockKey struct {
	sessionID uuid.UUID
	nodeName  string
}

// NewConsoleLock creates an empty ConsoleLock.
func NewConsoleLock() *ConsoleLock {
	return &ConsoleLock{
		locks: make(map[consoleLockKey]struct{}),
	}
}

// TryLock attempts to acquire the lock for (sessionID, nodeName).
// Returns an unlock function and true on success, or nil and false
// if already held.
//
// The unlock function is safe to call multiple times; only the
// first call releases the lock.
func (l *ConsoleLock) TryLock(sessionID uuid.UUID, nodeName string) (unlock func(), ok bool) {
	l.mu.Lock()
	defer l.mu.Unlock()

	key := consoleLockKey{sessionID, nodeName}
	if _, held := l.locks[key]; held {
		return nil, false
	}
	l.locks[key] = struct{}{}

	released := false
	unlock = func() {
		l.mu.Lock()
		defer l.mu.Unlock()
		if !released {
			delete(l.locks, key)
			released = true
		}
	}
	return unlock, true
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
