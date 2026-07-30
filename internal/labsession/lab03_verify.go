package labsession

import "netbreaker.io/api/internal/verify"

// Lab03BuildVerifier checks the Lab 3 Build phase (MAC Flood Chaos).
//
// Students cable PC1→Et0/1, PC2→Et0/2, KALI→Et0/3 and generate
// traffic. SW1's CAM table should show at least 2 learned MACs
// (PC1 + PC2) before the attack.
func Lab03BuildVerifier(sess *verify.LabSession) *verify.Verifier {
	return verify.New().
		// At least 2 MACs learned: PC1 on Et0/1 + PC2 on Et0/2
		ExpectMACCount(2)
}

// Lab03AttackVerifier checks the Lab 3 Attack phase.
//
// After macof floods the CAM table, SW1 should be in hub mode —
// the table is at or near capacity. We verify the flood ran by
// checking the CAM table is full (high entry count).
//
// TODO(real capture): the exact threshold depends on the IOU
// switch's CAM capacity. Adjust n once we see real output.
func Lab03AttackVerifier(sess *verify.LabSession) *verify.Verifier {
	return verify.New().
		// CAM should be heavily populated after macof
		ExpectMACCount(100)
}

// Lab03HardenVerifier checks the Lab 3 Harden phase.
//
// After port-security is configured on Et0/3 with violation shutdown,
// re-running macof should trigger at least 1 violation and err-disable
// the port. We check both the violation count and that the port is
// err-disabled.
//
// TODO(real capture): stub — ParsePortSecurity is not yet implemented.
func Lab03HardenVerifier(sess *verify.LabSession) *verify.Verifier {
	return verify.New().
		// At least 1 violation recorded on KALI's port
		ExpectPortSecurityViolations("Et0/3", 1).
		// The port should be err-disabled after violation
		ExpectInterfaceDown("Et0/3")
}

// RegisterLab03Verifiers wires Lab 3 verifiers into the global registry.
func RegisterLab03Verifiers(reg *verify.VerifierRegistry) {
	// All three phases target SW1 — it's the only switch in Lab 3
	reg.Register(3, "build", "SW1", func(sess *verify.LabSession) *verify.Verifier {
		return Lab03BuildVerifier(sess)
	})
	reg.Register(3, "attack", "SW1", func(sess *verify.LabSession) *verify.Verifier {
		return Lab03AttackVerifier(sess)
	})
	reg.Register(3, "harden", "SW1", func(sess *verify.LabSession) *verify.Verifier {
		return Lab03HardenVerifier(sess)
	})
}
