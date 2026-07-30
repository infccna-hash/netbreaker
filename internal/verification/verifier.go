package verification

import "fmt"

// LabVerifier knows how to verify all three phases of one lab.
type LabVerifier interface {
	Verify(phase string, config map[string]DeviceConfig) VerifyResult
}

// Registry maps lab IDs to their verifiers.
//
// NOTE: All verifiers are currently suspended (return Passed: false)
// while the platform migrates from client-trust to console-truth
// verification. Remove the suspendedVerifier wrapper per lab as each
// one is migrated — do NOT remove the wrapper from the whole registry
// at once.
var Registry = map[int]LabVerifier{
	1:  suspendedVerifier{&Lab1Verifier{}, 1, "VLAN Warfare"}, // console-truth verifier ready (lab01_verify.go) — remove wrapper when handler migration is wired
	2:  suspendedVerifier{&Lab2Verifier{}, 2, "STP Sabotage"},
	3:  suspendedVerifier{&Lab3Verifier{}, 3, "MAC Flood Chaos"},
	4:  &GenericVerifier{LabID: 4, Title: "OSPF Infiltration"},
	5:  &GenericVerifier{LabID: 5, Title: "HSRP Takeover"},
	6:  &GenericVerifier{LabID: 6, Title: "ACL Bypass Mission"},
	7:  &GenericVerifier{LabID: 7, Title: "CDP/LLDP Espionage"},
	8:  &GenericVerifier{LabID: 8, Title: "DHCP Starvation"},
	9:  &GenericVerifier{LabID: 9, Title: "NAT Unmasked"},
	10: &GenericVerifier{LabID: 10, Title: "DNS Poisoning"},
	11: &GenericVerifier{LabID: 11, Title: "SSH vs Telnet Autopsy"},
	12: &GenericVerifier{LabID: 12, Title: "802.1X Port Lockdown"},
	13: &GenericVerifier{LabID: 13, Title: "Wireless Evil Twin"},
	14: &GenericVerifier{LabID: 14, Title: "IPv6 Neighbor Spoof"},
}

// suspendedVerifier wraps a real LabVerifier and always returns
// Passed: false. Remove this wrapper when the verifier is migrated
// to console-truth — the inner verifier's logic is preserved intact.
type suspendedVerifier struct {
	inner LabVerifier
	labID int
	title string
}

func (s suspendedVerifier) Verify(phase string, cfg map[string]DeviceConfig) VerifyResult {
	// Run the real verifier so we can still return specific hints
	// in the Failures/Hints fields — but force Passed: false regardless.
	res := s.inner.Verify(phase, cfg)
	res.Passed = false
	res.Score = 0
	res.Message = fmt.Sprintf("Lab %d (%s) — %s phase: verification is temporarily suspended while the platform migrates to a new grading engine. Your existing work is preserved but new progress will not be recorded yet.", s.labID, s.title, phase)
	return res
}

// Get returns the verifier for a lab, or an error if not found.
func Get(labID int) (LabVerifier, error) {
	v, ok := Registry[labID]
	if !ok {
		return nil, fmt.Errorf("no verifier registered for lab %d", labID)
	}
	return v, nil
}

// GenericVerifier is a placeholder for labs whose full verification isn't
// implemented yet. It MUST return Passed: false — auto-passing is a
// credential-issuance vulnerability, not a convenience feature.
//
// REGRESSION GUARD: TestGenericVerifierNeverAutoPasses enforces this.
type GenericVerifier struct {
	LabID int
	Title string
}

func (g *GenericVerifier) Verify(phase string, _ map[string]DeviceConfig) VerifyResult {
	return VerifyResult{
		Passed:  false,
		Score:   0,
		Message: fmt.Sprintf("Lab %d (%s) — %s phase: verification is temporarily suspended. Your progress will not be recorded. Full verification is being migrated to a new engine — check back soon.", g.LabID, g.Title, phase),
	}
}

// helper: build a VerifyResult from a list of (failure, hint) pairs.
func result(failures, hints []string) VerifyResult {
	total := len(failures) + 1 // +1 so 0 failures = 100%
	score := ((total - len(failures)) * 100) / total
	if len(failures) == 0 {
		return VerifyResult{Passed: true, Score: 100, Message: "All objectives met — phase complete!"}
	}
	return VerifyResult{
		Passed:   false,
		Score:    score,
		Failures: failures,
		Hints:    hints,
		Message:  fmt.Sprintf("%d objective(s) not yet complete.", len(failures)),
	}
}
