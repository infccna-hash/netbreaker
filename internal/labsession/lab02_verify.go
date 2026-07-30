package labsession

import "netbreaker.io/api/internal/verify"

// Lab02BuildVerifier checks the Lab 2 Build phase (STP Sabotage).
//
// Students build a 3-switch triangle with VLAN 1 trunking. After the
// build, SW1 should be the STP root bridge by priority manipulation.
//
// TODO(real capture): all assertions are stubs until ParseSTP is
// implemented with real `show spanning-tree vlan 1` captures from
// SW1, SW2, and SW3.
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
//
// TODO(real capture): stub.
func Lab02AttackVerifier(sess *verify.LabSession) *verify.Verifier {
	return verify.New().
		// SW3's Et0/2 should NOT be blocking — Kali is the fake root
		ExpectPortRole("SW3", "Et0/2", "Root")
}

// Lab02HardenVerifier checks the Lab 2 Harden phase.
//
// After BPDU Guard and Root Guard are configured, SW2's Et0/2 (the
// loop-prevention link) should be in Altn/blocking state — STP's
// normal loop-free topology is restored.
//
// TODO(real capture): stub.
func Lab02HardenVerifier(sess *verify.LabSession) *verify.Verifier {
	return verify.New().
		// SW2's Et0/2 should be blocking (Altn) — loop prevention
		ExpectPortRole("SW2", "Et0/2", "Altn")
}

// RegisterLab02Verifiers wires Lab 2 verifiers into the global registry.
func RegisterLab02Verifiers(reg *verify.VerifierRegistry) {
	reg.Register(2, "build", "SW1", func(sess *verify.LabSession) *verify.Verifier {
		return Lab02BuildVerifier(sess)
	})
	reg.Register(2, "attack", "SW3", func(sess *verify.LabSession) *verify.Verifier {
		return Lab02AttackVerifier(sess)
	})
	reg.Register(2, "harden", "SW2", func(sess *verify.LabSession) *verify.Verifier {
		return Lab02HardenVerifier(sess)
	})
}
