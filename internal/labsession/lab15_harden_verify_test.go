package labsession

import (
	"context"
	"testing"

	"netbreaker.io/api/internal/verify"
)

// hardenCollector returns exactly the state a student gets from
// correctly following the Harden phase content as authored in
// migration 044 (LINK-TO-HUB-PC1-PC2, no KALI2 suffix; errdisable
// interval 300, not 180).
func correctlyHardenedCollector() *mockCollector {
	return &mockCollector{
		interfaces: map[verify.Port]verify.InterfaceStatus{
			"Et0/0": {AdminUp: true, LinkUp: true, Description: "LINK-TO-HUB-PC1-PC2"},
			"Et0/1": {AdminUp: true, LinkUp: true, Description: "LINK-TO-PC3"},
			"Et0/2": {AdminUp: true, LinkUp: true, Description: "LINK-TO-KALI"},
			"Et0/3": {AdminUp: true, LinkUp: true, Description: "UPLINK-TO-R1"},
			"Et0/4": {AdminUp: true, LinkUp: true, Description: "SPARE-UNUSED"},
		},
		errdisable: verify.ErrdisableConfig{Enabled: true, IntervalSec: 300},
	}
}

// TestLab15HardenVerifier_CorrectlyConfigured_Passes is the positive
// case: a student who followed the (now-corrected) content exactly
// should pass every assertion.
func TestLab15HardenVerifier_CorrectlyConfigured_Passes(t *testing.T) {
	sess := &verify.LabSession{MACs: map[string]string{}, IPs: map[string]string{}}
	v := Lab15HardenVerifier(sess)
	result := v.Run(context.Background(), correctlyHardenedCollector())

	if !result.Passed {
		for _, c := range result.Checks {
			if !c.Passed {
				t.Logf("FAILED: %s: %s", c.Name, c.Detail)
			}
		}
		t.Fatal("a student who followed the corrected Harden content exactly should pass, but did not")
	}
}

// TestLab15HardenVerifier_StaleExpectations_WouldHaveFailedCorrectWork
// is the negative control for the 2026-07-28 fix. It reproduces the
// exact two stale assertions the verifier used to make (Et0/0
// description including a "-KALI2" suffix left over from the
// pre-single-Kali topology, and an errdisable interval of 180
// instead of the content-taught 300) against the SAME
// correctly-hardened collector above. Before the fix, this
// reproduction would fail even though the student did everything
// the lab asked. This test exists to prove the old assertions really
// were the bug — it is not exercising current production code, only
// documenting what the pre-fix expectations would have done to
// correct student work.
func TestLab15HardenVerifier_StaleExpectations_WouldHaveFailedCorrectWork(t *testing.T) {
	staleVerifier := verify.New().
		ExpectDescription("Et0/0", "LINK-TO-HUB-PC1-PC2-KALI2"). // pre-fix stale string
		ExpectErrdisableRecovery(180)                            // pre-fix stale interval

	result := staleVerifier.Run(context.Background(), correctlyHardenedCollector())

	if result.Passed {
		t.Fatal("expected the pre-fix stale assertions to fail against correctly-hardened student work — " +
			"if this now passes, something else changed and this test's premise needs re-checking")
	}
}
