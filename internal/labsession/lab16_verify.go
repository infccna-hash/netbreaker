package labsession

import "netbreaker.io/api/internal/verify"

// Lab16BuildVerifier checks the Lab 16 Build phase via console-truth.
//
// Lab 16 — Cabling & Connectors (redesigned for IOU): students create
// a "physical layer fault" by shutting down the SW1↔SW2 trunk, then
// bring it back up. This replaces the original cable-type/mdix content
// which doesn't work on IOU (no PHY simulation).
func Lab16BuildVerifier(sess *verify.LabSession) *verify.Verifier {
	return verify.New().
		// Et0/2 (SW1↔SW2 trunk) must be up after the shutdown/no shutdown exercise
		ExpectInterfaceUp("Et0/2")
}

// Lab16AttackVerifier checks the Lab 16 Attack phase via console-truth.
//
// Attack 3 (cable DoS → shutdown): student shuts down Et0/0 (PC1's port)
// to simulate pulling the cable — the simplest DoS in the book.
func Lab16AttackVerifier(sess *verify.LabSession) *verify.Verifier {
	return verify.New().
		// Et0/0 (→ PC1) must be administratively shut down
		ExpectInterfaceDown("Et0/0")
}

// Lab16HardenVerifier checks the Lab 16 Harden phase via console-truth.
//
// After recovery: all ports back up, console password set, unused ports shut.
func Lab16HardenVerifier(sess *verify.LabSession) *verify.Verifier {
	return verify.New().
		// The trunk to SW2 must be back up
		ExpectInterfaceUp("Et0/2").
		// PC1's port must be back up (recovered from Attack)
		ExpectInterfaceUp("Et0/0")
}

// RegisterLab16Verifiers wires Lab 16 verifiers into the global registry.
func RegisterLab16Verifiers(reg *verify.VerifierRegistry) {
	reg.Register(16, "build", "SW1", func(sess *verify.LabSession) *verify.Verifier {
		return Lab16BuildVerifier(sess)
	})
	reg.Register(16, "attack", "SW1", func(sess *verify.LabSession) *verify.Verifier {
		return Lab16AttackVerifier(sess)
	})
	reg.Register(16, "harden", "SW1", func(sess *verify.LabSession) *verify.Verifier {
		return Lab16HardenVerifier(sess)
	})
}
