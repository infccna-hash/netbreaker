package labsession

import "netbreaker.io/api/internal/verify"

// Lab47 addressing plan (declared here, used by all three verifiers).
var lab47IPs = map[string]string{
	"R1":   "198.51.100.1", // FW link (203.0.113.0/24 is Kali's segment)
	"R2":   "10.0.0.2",
	"PC1":  "10.0.10.10",
	"PC2":  "10.0.20.20",
	"KALI": "203.0.113.100",
}

// Lab47BuildVerifier checks the Lab 47 Build phase via console-truth.
//
// Build: SW1 carries two VLANs — PC1 in VLAN 10 (Et0/1), PC2 in
// VLAN 20 (Et0/2) — with the uplink to R2 (Et0/0) up. The switch is
// the honest record of segmentation; the firewall is not checked here
// (VNC-only console, and Build doesn't require traffic through it yet).
func Lab47BuildVerifier(sess *verify.LabSession) *verify.Verifier {
	return verify.New().
		ExpectInterfaceUp("Et0/0").  // uplink to R2
		ExpectPortVLAN("Et0/1", 10). // PC1
		ExpectPortVLAN("Et0/2", 20)  // PC2
}

// Lab47AttackVerifier checks the Lab 47 Attack phase via console-truth.
//
// Attack: the firewall is left wide open (permissive any→any policy),
// so KALI on the outside (203.0.113.100) can reach the inside hosts
// through R1 → FW → R2. The verifier runs on R1 (the edge router,
// telnet console) and pings through the chain. R2's inside interface
// (10.0.0.2) must answer from R1's perspective — proving the path
// across the firewall is open end-to-end.
func Lab47AttackVerifier(sess *verify.LabSession) *verify.Verifier {
	return verify.New().
		ExpectInterfaceUp("Fa0/0"). // KALI side
		ExpectInterfaceUp("Fa0/1"). // FW side
		ExpectReachable("R2", lab47IPs["R2"]).
		ExpectReachable("PC1", lab47IPs["PC1"]).
		ExpectReachable("PC2", lab47IPs["PC2"])
}

// Lab47HardenVerifier checks the Lab 47 Harden phase via console-truth.
//
// Harden: FortiGate policies tightened — outside→inside denied,
// inside→outside still allowed. From R1's vantage (the outside edge):
//   - PC1/PC2 must NO LONGER respond (ExpectNotReachable) — the
//     firewall now blocks the attack path.
//   - R2's outside-facing interface must still be reachable only if
//     policy permits; for this lab the hardened policy denies the
//     outside from initiating ANY traffic into the inside, so R2 is
//     also not reachable from R1. The positive control is that R1
//     itself stays up with both interfaces, i.e. the router wasn't
//     broken while fixing the firewall.
func Lab47HardenVerifier(sess *verify.LabSession) *verify.Verifier {
	return verify.New().
		ExpectInterfaceUp("Fa0/0").
		ExpectInterfaceUp("Fa0/1").
		ExpectNotReachable("PC1", lab47IPs["PC1"]).
		ExpectNotReachable("PC2", lab47IPs["PC2"])
}

// RegisterLab47Verifiers wires Lab 47 verifiers into the global registry.
func RegisterLab47Verifiers(reg *verify.VerifierRegistry) {
	reg.Register(47, "build", "SW1", func(sess *verify.LabSession) *verify.Verifier {
		return Lab47BuildVerifier(sess)
	})
	reg.Register(47, "attack", "R1", func(sess *verify.LabSession) *verify.Verifier {
		return Lab47AttackVerifier(sess)
	})
	reg.Register(47, "harden", "R1", func(sess *verify.LabSession) *verify.Verifier {
		return Lab47HardenVerifier(sess)
	})
}
