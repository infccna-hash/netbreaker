package labsession

import "netbreaker.io/api/internal/verify"

// Lab15BuildVerifier checks the exact lesson Step 3 teaches: hosts
// behind the hub (PC1, PC2, KALI2) all resolve to one switch port,
// while PC3 and KALI — each on their own dedicated port — resolve
// separately. This is the entire "collision domain" concept made
// machine-checkable.
func Lab15BuildVerifier(sess *verify.LabSession) *verify.Verifier {
	return verify.New().
		ExpectMACsShareOnePort(
			"hub segment collapses to one port",
			[]verify.MAC{sess.MAC("PC1"), sess.MAC("PC2"), sess.MAC("KALI2")},
			"Et0/0",
		).
		ExpectMACOnPort("PC3 has its own dedicated port", sess.MAC("PC3"), "Et0/1").
		ExpectMACOnPort("KALI has its own dedicated port", sess.MAC("KALI"), "Et0/2")
}

// Lab15AttackVerifier checks that all active ports are up and every
// host is reachable end-to-end after fixing the four deliberate faults.
//
// IOU L2 note: ExpectInterfaceSpeed / ExpectInterfaceDuplex are NOT
// included here. IOU L2 Ethernet interfaces don't support the `speed`
// command (rejected with % Invalid input) and always report
// `Auto-duplex, Auto-speed` in show interfaces regardless of
// configuration — there is no PHY to negotiate. These checks are valid
// on dynamips/IOSvL2 but fundamentally unverifiable on IOU L2.
func Lab15AttackVerifier(sess *verify.LabSession) *verify.Verifier {
	v := verify.New().
		ExpectInterfaceUp("Et0/0").
		ExpectInterfaceUp("Et0/1").
		ExpectInterfaceUp("Et0/2").
		ExpectInterfaceUp("Et0/3")

	for _, host := range []string{"PC1", "PC2", "PC3", "KALI", "KALI2"} {
		v.ExpectReachable(host, sess.IP(host))
	}
	return v
}

// Lab15HardenVerifier checks all five ports are documented and
// errdisable auto-recovery interval is configured.
//
// SCOPE: This verifier confirms the student typed `errdisable
// recovery interval 180` (a non-default value that persists in
// running-config). It does NOT verify:
//   - That `errdisable recovery cause all` was accepted (IOU L2
//     acceptance unconfirmed as of 2026-07-27 — live-node tests
//     timed out; the binary does contain errdisable strings, so
//     rejection isn't guaranteed, but per-cause table flipping to
//     "Enabled" has not been observed)
//   - That errdisable recovery actually functions end-to-end
//     (requires a BPDU guard violation + 180s wait, not yet tested)
//
// If cause all turns out to be silently rejected or inert on IOU L2,
// the student can pass all six assertions with a switch that will
// never actually recover an err-disabled port — same failure shape
// as speed/duplex, just contained to one assertion. Until that's
// resolved, the per-cause table in `show errdisable recovery` is
// the more honest signal to key on than the timer alone.
func Lab15HardenVerifier(sess *verify.LabSession) *verify.Verifier {
	return verify.New().
		ExpectDescription("Et0/0", "LINK-TO-HUB-PC1-PC2-KALI2").
		ExpectDescription("Et0/1", "LINK-TO-PC3").
		ExpectDescription("Et0/2", "LINK-TO-KALI").
		ExpectDescription("Et0/3", "UPLINK-TO-R1").
		ExpectDescription("Et0/4", "SPARE-UNUSED").
		ExpectErrdisableRecovery(180)
}

// RegisterLab15Verifiers wires these into the global registry.
func RegisterLab15Verifiers(reg *verify.VerifierRegistry) {
	reg.Register(15, "build", func(sess *verify.LabSession) *verify.Verifier {
		return Lab15BuildVerifier(sess)
	})
	reg.Register(15, "attack", func(sess *verify.LabSession) *verify.Verifier {
		return Lab15AttackVerifier(sess)
	})
	reg.Register(15, "harden", func(sess *verify.LabSession) *verify.Verifier {
		return Lab15HardenVerifier(sess)
	})
}
