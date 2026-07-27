package labsession

import (
	"sync"
	"testing"

	"github.com/google/uuid"
)

func TestConsoleLock_TryLock(t *testing.T) {
	lock := NewConsoleLock()
	sessID := uuid.New()
	node := "SW1"

	// First acquire should succeed.
	unlock1, heldBy, ok := lock.TryLock(sessID, node, HolderVerify)
	if !ok || heldBy != "" {
		t.Fatalf("first TryLock should succeed, got heldBy=%q ok=%v", heldBy, ok)
	}

	// Second acquire on same (session, node) should fail and say who holds it.
	_, heldBy, ok = lock.TryLock(sessID, node, HolderConsole)
	if ok {
		t.Fatal("second TryLock on same key should fail")
	}
	if heldBy != HolderVerify {
		t.Fatalf("heldBy should be %q, got %q", HolderVerify, heldBy)
	}

	// Different node in same session should succeed.
	unlock3, _, ok := lock.TryLock(sessID, "SW2", HolderConsole)
	if !ok {
		t.Fatal("TryLock on different node should succeed")
	}
	unlock3()

	// Different session, same node should succeed.
	unlock4, _, ok := lock.TryLock(uuid.New(), node, HolderConsole)
	if !ok {
		t.Fatal("TryLock on different session should succeed")
	}
	unlock4()

	// After unlock, should succeed again.
	unlock1()
	unlock5, heldBy, ok := lock.TryLock(sessID, node, HolderConsole)
	if !ok || heldBy != "" {
		t.Fatalf("TryLock after unlock should succeed, got heldBy=%q ok=%v", heldBy, ok)
	}
	unlock5()
}

func TestConsoleLock_DoubleUnlockSafe(t *testing.T) {
	lock := NewConsoleLock()
	sessID := uuid.New()
	node := "SW1"

	unlock, _, ok := lock.TryLock(sessID, node, HolderVerify)
	if !ok {
		t.Fatal("TryLock should succeed")
	}

	// First unlock — releases.
	unlock()

	// Second unlock — safe, no-op.
	unlock()

	// Should be re-acquirable.
	unlock2, _, ok := lock.TryLock(sessID, node, HolderConsole)
	if !ok {
		t.Fatal("TryLock after double-unlock should succeed")
	}
	unlock2()
}

func TestConsoleLock_HeldByReflectsHolder(t *testing.T) {
	lock := NewConsoleLock()
	sessID := uuid.New()
	node := "SW1"

	// Verify holds first.
	unlock, heldBy, ok := lock.TryLock(sessID, node, HolderVerify)
	if !ok || heldBy != "" {
		t.Fatalf("acquire should succeed, got heldBy=%q ok=%v", heldBy, ok)
	}

	// Console tries — should see HolderVerify.
	_, heldBy, ok = lock.TryLock(sessID, node, HolderConsole)
	if ok {
		t.Fatal("should fail")
	}
	if heldBy != HolderVerify {
		t.Fatalf("heldBy should be verify, got %q", heldBy)
	}

	// Another verify tries — should also see HolderVerify.
	_, heldBy, ok = lock.TryLock(sessID, node, HolderVerify)
	if ok {
		t.Fatal("should fail")
	}
	if heldBy != HolderVerify {
		t.Fatalf("heldBy should be verify, got %q", heldBy)
	}

	unlock()

	// Now console holds first.
	unlock2, heldBy, ok := lock.TryLock(sessID, node, HolderConsole)
	if !ok || heldBy != "" {
		t.Fatalf("acquire should succeed, got heldBy=%q ok=%v", heldBy, ok)
	}

	// Verify tries — should see HolderConsole.
	_, heldBy, ok = lock.TryLock(sessID, node, HolderVerify)
	if ok {
		t.Fatal("should fail")
	}
	if heldBy != HolderConsole {
		t.Fatalf("heldBy should be console, got %q", heldBy)
	}

	unlock2()
}

func TestConsoleLock_ForceRelease(t *testing.T) {
	lock := NewConsoleLock()
	sessID := uuid.New()
	node := "SW1"

	// Console acquires the lock.
	unlock, _, ok := lock.TryLock(sessID, node, HolderConsole)
	if !ok {
		t.Fatal("TryLock should succeed")
	}

	// Register a preempt callback that records it was called.
	var called bool
	var mu sync.Mutex
	lock.SetPreempt(sessID, node, func() {
		mu.Lock()
		called = true
		mu.Unlock()
	})

	// ForceRelease with wrong holder should fail.
	if lock.ForceRelease(sessID, node, HolderVerify) {
		t.Fatal("ForceRelease with wrong holder should return false")
	}
	mu.Lock()
	if called {
		t.Fatal("preempt should NOT be called for wrong holder")
	}
	mu.Unlock()

	// ForceRelease with correct holder should succeed and call preempt.
	if !lock.ForceRelease(sessID, node, HolderConsole) {
		t.Fatal("ForceRelease with correct holder should return true")
	}
	mu.Lock()
	if !called {
		t.Fatal("preempt callback should have been called")
	}
	mu.Unlock()

	// Original unlock should be safe (no-op).
	unlock()

	// Lock should be re-acquirable after ForceRelease.
	unlock2, _, ok := lock.TryLock(sessID, node, HolderVerify)
	if !ok {
		t.Fatal("TryLock after ForceRelease should succeed")
	}
	unlock2()
}

func TestConsoleLock_ForceReleaseWithoutPreempt(t *testing.T) {
	lock := NewConsoleLock()
	sessID := uuid.New()
	node := "SW1"

	// Verify acquires — no preempt registered (verify doesn't need it).
	unlock, _, ok := lock.TryLock(sessID, node, HolderVerify)
	if !ok {
		t.Fatal("TryLock should succeed")
	}

	// ForceRelease should work even without preempt.
	if !lock.ForceRelease(sessID, node, HolderVerify) {
		t.Fatal("ForceRelease should return true even without preempt")
	}

	unlock()

	// Re-acquirable.
	unlock2, _, ok := lock.TryLock(sessID, node, HolderConsole)
	if !ok {
		t.Fatal("TryLock after ForceRelease without preempt should succeed")
	}
	unlock2()
}

func TestErrNodeLocked_Error(t *testing.T) {
	err := &ErrNodeLocked{SessionID: uuid.Nil, NodeName: "SW1"}
	if err.Error() == "" {
		t.Fatal("ErrNodeLocked.Error() should not be empty")
	}
}

// TestStaleUnlockAfterPreemption verifies the stale-release guard: when
// ForceRelease preempts the console's lock and a verify re-acquires it,
// the killed console's deferred unlock() must NOT release the verify's
// lock. Without the generation counter, the stale defer would free the
// lock mid-verification and let a third party (console reopen, second
// verify) in — a guaranteed defect after any preemption.
func TestStaleUnlockAfterPreemption(t *testing.T) {
	lock := NewConsoleLock()
	sessID := uuid.New()
	node := "SW1"

	// Console acquires lock (token = 1).
	consoleUnlock, _, ok := lock.TryLock(sessID, node, HolderConsole)
	if !ok {
		t.Fatal("console TryLock should succeed")
	}
	lock.SetPreempt(sessID, node, func() {}) // no-op preempt (no real WebSocket)

	// ForceRelease preempts the console. Token 1 is invalidated.
	if !lock.ForceRelease(sessID, node, HolderConsole) {
		t.Fatal("ForceRelease should succeed")
	}

	// Verify acquires (token = 2).
	verifyUnlock, _, ok := lock.TryLock(sessID, node, HolderVerify)
	if !ok {
		t.Fatal("verify TryLock should succeed after preemption")
	}

	// The console's deferred unlock fires — must be a no-op.
	// Token 1 ≠ token 2, so it must NOT delete the verify's lock.
	consoleUnlock()

	// After stale unlock, the verify should STILL hold the lock.
	_, heldBy, ok := lock.TryLock(sessID, node, HolderConsole)
	if ok {
		t.Fatal("stale console unlock must not release verify lock — third party acquired")
	}
	if heldBy != HolderVerify {
		t.Fatalf("lock should still be held by verify after stale unlock, got %q", heldBy)
	}

	// Verify releases normally.
	verifyUnlock()

	// Now the lock is actually free.
	thirdUnlock, _, ok := lock.TryLock(sessID, node, HolderConsole)
	if !ok {
		t.Fatal("lock should be free after verify releases")
	}
	thirdUnlock()
}

// TestDoubleUnlockAfterForceRelease verifies that a double-unlock from
// the original holder after ForceRelease does not corrupt state — both
// calls should be no-ops.
func TestDoubleUnlockAfterForceRelease(t *testing.T) {
	lock := NewConsoleLock()
	sessID := uuid.New()
	node := "SW1"

	unlock, _, ok := lock.TryLock(sessID, node, HolderConsole)
	if !ok {
		t.Fatal("TryLock should succeed")
	}
	lock.SetPreempt(sessID, node, func() {})

	lock.ForceRelease(sessID, node, HolderConsole)

	// Two stale unlocks — neither should panic or affect state.
	unlock()
	unlock()

	// Lock should still be free.
	_, _, ok = lock.TryLock(sessID, node, HolderVerify)
	if !ok {
		t.Fatal("lock should be free after stale double-unlock")
	}
}
