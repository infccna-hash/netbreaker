package labsession

import (
	"context"
	"testing"

	"netbreaker.io/api/internal/verify"
)

// TestLab15BuildVerifier_EmptyMACs_Fails demonstrates the MAC resolution
// blocker. LabSession.MACs is empty after ResolveVerifySession, so
// sess.MAC("PC3") returns "<unresolved:PC3>" — a sentinel value that
// will never match any real MAC in the switch's table.
//
// This test EXISTS to prove the gap and will FAIL (in the opposite
// direction — unexpected Pass) when MAC resolution is implemented.
// At that point, update this test to verify correct MAC-based checks
// instead.
func TestLab15BuildVerifier_EmptyMACs_Fails(t *testing.T) {
	sess := &verify.LabSession{
		MACs: make(map[string]string), // empty — current state after ResolveVerifySession
		IPs:  make(map[string]string),
	}

	v := Lab15BuildVerifier(sess)

	collector := &mockCollector{
		interfaces: map[verify.Port]verify.InterfaceStatus{
			"Et0/0": {AdminUp: true, LinkUp: true},
			"Et0/1": {AdminUp: true, LinkUp: true},
			"Et0/2": {AdminUp: true, LinkUp: true},
		},
	}

	result := v.Run(context.Background(), collector)

	if result.Passed {
		t.Fatal("BUG: Lab 15 Build passed with empty MACs. MAC resolution must be fixed — if this fails unexpectedly, the sentinel '<unresolved:...>' may have been removed.")
	}

	// All three MAC-based checks should fail because the sentinel
	// "<unresolved:PC1>" etc. won't match any real MAC.
	failCount := 0
	for _, c := range result.Checks {
		if !c.Passed {
			t.Logf("[EXPECTED] %s: %s", c.Name, c.Detail)
			failCount++
		}
	}
	if failCount == 0 {
		t.Fatal("no checks failed — expected all MAC checks to fail on unresolved MACs")
	}
}
