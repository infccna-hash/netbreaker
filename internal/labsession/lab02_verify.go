package labsession

import "netbreaker.io/api/internal/verify"

// Lab02BuildVerifier checks the Lab 2 Build phase (STP Sabotage).
//
// Console-truth (2026-08-04): after trunking + root-primary the
// default election leaves SW1 as root (lowest MAC, all switches at
// 32768) — the verifier confirms SW1 holds the root role.
func Lab02BuildVerifier(sess *verify.LabSession) *verify.Verifier {
	return verify.New().
		// SW1 must be the root bridge after priority is set
		ExpectRootBridge("SW1")
}

// Lab02AttackVerifier checks the Lab 2 Attack phase.
//
// Kali floods BPDUs to take over the root role. After the attack,
// SW3's Et0/2 (Kali's access port) should show a root role — Kali
// convinced the switch it's the best path to root.
func Lab02AttackVerifier(sess *verify.LabSession) *verify.Verifier {
	return verify.New().
		// SW3's Et0/2 should NOT be blocking — Kali is the fake root
		ExpectPortRole("SW3", "Et0/2", "Root")
}

// Lab02HardenVerifier checks the Lab 2 Harden phase.
//
// Console-truth (walkthrough 2026-08-04): in the healthy hardened
// triangle the loop is broken on SW3's Et0/3 (the SW2↔SW3 link) —
// SW3's other uplink Et0/1 faces the root (SW1) and stays FWD, while
// SW2's Et0/2 is Desg FWD. Only SW3 Et0/3 is Altn/BLK.
func Lab02HardenVerifier(sess *verify.LabSession) *verify.Verifier {
	return verify.New().
		// SW3's Et0/3 (loop-prevention link to SW2) should be blocking (Altn)
		ExpectPortRole("SW3", "Et0/3", "Altn")
}

// RegisterLab02Verifiers wires Lab 2 verifiers into the global registry.
//
// Target device per phase is load-bearing: the registry's third
// argument selects WHICH node's console the collector drives, while
// the assertion inside picks the port. On 2026-08-04 the harden phase
// asserted SW3:Et0/3 but was still registered against SW2 — the
// collector read SW2's STP table (Et0/3 Desg) and the check failed
// forever despite the lab being correct. Keep both in sync.
func RegisterLab02Verifiers(reg *verify.VerifierRegistry) {
	reg.Register(2, "build", "SW1", func(sess *verify.LabSession) *verify.Verifier {
		return Lab02BuildVerifier(sess)
	})
	reg.Register(2, "attack", "SW3", func(sess *verify.LabSession) *verify.Verifier {
		return Lab02AttackVerifier(sess)
	})
	reg.Register(2, "harden", "SW3", func(sess *verify.LabSession) *verify.Verifier {
		return Lab02HardenVerifier(sess)
	})
}
