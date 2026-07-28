package labsession

import "netbreaker.io/api/internal/verify"

// Lab8BuildVerifier checks the Lab 8 Build phase: R1 has DHCP pool
// configured and responds on its Fa0/0 interface (10.0.10.1).
//
// The console-truth engine probes SW1. For SW1 to source pings,
// it needs an SVI (interface vlan 1) with an IP in 10.0.10.0/24.
// The build phase content must include this SVI step.
func Lab8BuildVerifier(sess *verify.LabSession) *verify.Verifier {
	return verify.New().
		// R1 must be reachable — proves Fa0/0 is configured and up.
		ExpectReachable("R1", "10.0.10.1")
}

// Lab8AttackVerifier checks the Attack phase: R1's pool is exhausted,
// Kali's rogue DHCP is serving, and port-security is configured.
func Lab8AttackVerifier(sess *verify.LabSession) *verify.Verifier {
	return verify.New().
		ExpectInterfaceUp("Et0/0"). // R1 uplink
		ExpectInterfaceUp("Et0/1"). // PC-A
		ExpectInterfaceUp("Et0/3")  // KALI (rogue DHCP)
}

// Lab8HardenVerifier checks port-security is active on access ports
// after the student applies the harden configuration.
func Lab8HardenVerifier(sess *verify.LabSession) *verify.Verifier {
	return verify.New().
		ExpectInterfaceUp("Et0/1"). // PC-A (port-security active)
		ExpectInterfaceUp("Et0/3")  // KALI (port-security active)
}

// RegisterLab8Verifiers wires these into the global registry.
func RegisterLab8Verifiers(reg *verify.VerifierRegistry) {
	reg.Register(8, "build", "SW1", func(sess *verify.LabSession) *verify.Verifier {
		return Lab8BuildVerifier(sess)
	})
	reg.Register(8, "attack", "SW1", func(sess *verify.LabSession) *verify.Verifier {
		return Lab8AttackVerifier(sess)
	})
	reg.Register(8, "harden", "SW1", func(sess *verify.LabSession) *verify.Verifier {
		return Lab8HardenVerifier(sess)
	})
}
