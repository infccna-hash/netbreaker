package labsession

import (
	"testing"

	"github.com/google/uuid"
)

func TestConsoleLock_TryLock(t *testing.T) {
	lock := NewConsoleLock()
	sessID := uuid.New()
	node := "SW1"

	// First acquire should succeed.
	unlock1, ok := lock.TryLock(sessID, node)
	if !ok {
		t.Fatal("first TryLock should succeed")
	}

	// Second acquire on same (session, node) should fail.
	unlock2, ok := lock.TryLock(sessID, node)
	if ok {
		unlock2()
		t.Fatal("second TryLock on same key should fail")
	}

	// Different node in same session should succeed.
	unlock3, ok := lock.TryLock(sessID, "SW2")
	if !ok {
		t.Fatal("TryLock on different node should succeed")
	}
	unlock3()

	// Different session, same node should succeed.
	unlock4, ok := lock.TryLock(uuid.New(), node)
	if !ok {
		t.Fatal("TryLock on different session should succeed")
	}
	unlock4()

	// After unlock, should succeed again.
	unlock1()
	unlock5, ok := lock.TryLock(sessID, node)
	if !ok {
		t.Fatal("TryLock after unlock should succeed")
	}
	unlock5()
}

func TestConsoleLock_DoubleUnlockSafe(t *testing.T) {
	lock := NewConsoleLock()
	sessID := uuid.New()
	node := "SW1"

	unlock, ok := lock.TryLock(sessID, node)
	if !ok {
		t.Fatal("TryLock should succeed")
	}

	// First unlock — releases.
	unlock()

	// Second unlock — safe, no-op.
	unlock()

	// Should be re-acquirable.
	unlock2, ok := lock.TryLock(sessID, node)
	if !ok {
		t.Fatal("TryLock after double-unlock should succeed")
	}
	unlock2()
}

func TestErrNodeLocked_Error(t *testing.T) {
	err := &ErrNodeLocked{SessionID: uuid.Nil, NodeName: "SW1"}
	if err.Error() == "" {
		t.Fatal("ErrNodeLocked.Error() should not be empty")
	}
}
