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

// Lab15AttackVerifier checks all four deliberate faults are fixed.
//
// IOU L2 note: speed/duplex checks were removed after real captures
// confirmed the platform can't surface them (`speed 1000` rejected
// outright, `duplex full` accepted but never reported as anything
// but Auto-duplex — see parse.go). Faults 2 and 3 were replaced:
//   - Fault 2 (was: duplex mismatch)  -> now: wrong VLAN on Et0/1
//   - Fault 3 (was: speed mismatch)   -> now: port-security violation
//     err-disabling Et0/2 — caught by ExpectInterfaceUp's existing
//     ErrDisabled check, no new assertion needed.
func Lab15AttackVerifier(sess *verify.LabSession) *verify.Verifier {
	v := verify.New().
		ExpectInterfaceUp("Et0/0").
		ExpectInterfaceUp("Et0/1").
		ExpectInterfaceUp("Et0/2").
		ExpectInterfaceUp("Et0/3").
		ExpectPortVLAN("Et0/1", 1) // PC3 back in the default VLAN

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
//     timed out). Note: the CCNA curriculum teaches per-cause
//     recovery (errdisable recovery cause psecure-violation), not
//     cause all. Switching the lab and verifier to the per-cause
//     form (a) aligns with the exam, (b) shrinks the open question
//     from "does cause all work on IOU" to "does one specific
//     cause keyword work," and (c) makes the per-cause table
//     (show errdisable recovery) the primary assertion rather
//     than the 180s timer alone.
//   - That errdisable recovery actually functions end-to-end
//     (requires a BPDU guard violation + 180s wait, not yet tested).
//     Intermediate signal: once recovery is enabled for a cause,
//     an err-disabled port appears under "Interfaces that will be
//     enabled at the next timeout" — verifiable without waiting.
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
