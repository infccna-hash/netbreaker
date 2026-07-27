package verification

import "testing"

// TestGenericVerifierNeverAutoPasses is a regression guard: the
// GenericVerifier must never return Passed: true. Auto-passing was
// the root cause of a credential-issuance vulnerability (any account
// could earn a verifiable CCNA certificate with zero work by
// clicking "verify" on 11 auto-pass labs).
//
// If this test fails, someone changed GenericVerifier back to
// auto-pass — revert immediately.
func TestGenericVerifierNeverAutoPasses(t *testing.T) {
	phases := []string{"build", "attack", "harden"}

	for _, lab := range []int{4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14} {
		gv := &GenericVerifier{LabID: lab, Title: "test"}
		for _, phase := range phases {
			res := gv.Verify(phase, nil)
			if res.Passed {
				t.Errorf("GenericVerifier lab=%d phase=%s returned Passed=true — must be false", lab, phase)
			}
			if res.Score != 0 {
				t.Errorf("GenericVerifier lab=%d phase=%s returned Score=%d — must be 0", lab, phase, res.Score)
			}
		}
	}
}

// TestSuspendedVerifierNeverAutoPasses ensures the suspendedVerifier
// wrapper forces Passed: false even when the inner verifier would pass.
func TestSuspendedVerifierNeverAutoPasses(t *testing.T) {
	// alwaysPassVerifier always returns Passed: true — used to
	// confirm the suspended wrapper overrides it.
	alwaysPass := alwaysPassVerifier{}
	sv := suspendedVerifier{inner: alwaysPass, labID: 1, title: "Test"}

	for _, phase := range []string{"build", "attack", "harden"} {
		res := sv.Verify(phase, nil)
		if res.Passed {
			t.Errorf("suspendedVerifier phase=%s returned Passed=true — must be false regardless of inner verifier", phase)
		}
	}
}

type alwaysPassVerifier struct{}

func (alwaysPassVerifier) Verify(_ string, _ map[string]DeviceConfig) VerifyResult {
	return VerifyResult{Passed: true, Score: 100, Message: "pass"}
}

// TestRegistryAllSuspended ensures every registered verifier (labs
// 1-14) returns Passed: false across all phases. This prevents
// partial-fix regressions where one lab is accidentally left
// un-suspended.
func TestRegistryAllSuspended(t *testing.T) {
	for labID := 1; labID <= 14; labID++ {
		v, err := Get(labID)
		if err != nil {
			t.Fatalf("lab %d: Get returned error: %v", labID, err)
		}
		for _, phase := range []string{"build", "attack", "harden"} {
			res := v.Verify(phase, nil)
			if res.Passed {
				t.Errorf("Registry lab=%d phase=%s returned Passed=true — all verifiers must be suspended", labID, phase)
			}
		}
	}
}
