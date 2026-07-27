package labsession

import "netbreaker.io/api/internal/verify"

// Lab1BuildVerifier checks the Lab 1 Build phase via console-truth.
//
// Lab 1 — VLAN Warfare: students configure VLANs 10, 20, 99 on SW1
// and SW2, set up a trunk between them with native VLAN 999, and
// configure R1 subinterfaces for inter-VLAN routing.
//
// This verifier targets SW1 only (the device with the most interesting
// Build-phase state). SW2 and R1 checks will be added as the collector
// infrastructure expands to multi-device runs.
func Lab1BuildVerifier(sess *verify.LabSession) *verify.Verifier {
	return verify.New().
		// PC1 should be on VLAN 10 access port
		ExpectPortVLAN("Et0/1", 10).
		// KALI should be on unused VLAN 99 for the attack lab
		ExpectPortVLAN("Et0/3", 99).
		// Trunk to SW2 must be up
		ExpectInterfaceUp("Et0/2")
}

// RegisterLab1Verifiers wires Lab 1 verifiers into the global registry.
//
// Currently only Build is console-truth ready. Attack and Harden will
// be added when the IOSCollector supports running-config and
// errdisable checks on the Lab 1 topology devices.
func RegisterLab1Verifiers(reg *verify.VerifierRegistry) {
	reg.Register(1, "build", func(sess *verify.LabSession) *verify.Verifier {
		return Lab1BuildVerifier(sess)
	})
}
