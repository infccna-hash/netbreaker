package verification

import "fmt"

// LabVerifier knows how to verify all three phases of one lab.
type LabVerifier interface {
	Verify(phase string, config map[string]DeviceConfig) VerifyResult
}

// Registry maps lab IDs to their verifiers.
var Registry = map[int]LabVerifier{
	1:  &Lab1Verifier{},
	2:  &Lab2Verifier{},
	3:  &Lab3Verifier{},
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

// Get returns the verifier for a lab, or an error if not found.
func Get(labID int) (LabVerifier, error) {
	v, ok := Registry[labID]
	if !ok {
		return nil, fmt.Errorf("no verifier registered for lab %d", labID)
	}
	return v, nil
}

// GenericVerifier is a placeholder for labs whose full verification isn't
// implemented yet. It auto-passes so the API doesn't block progress while
// content is still being written.
type GenericVerifier struct {
	LabID int
	Title string
}

func (g *GenericVerifier) Verify(phase string, _ map[string]DeviceConfig) VerifyResult {
	return VerifyResult{
		Passed:  true,
		Score:   100,
		Message: fmt.Sprintf("Lab %d (%s) — %s phase accepted. Full verification coming soon.", g.LabID, g.Title, phase),
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
