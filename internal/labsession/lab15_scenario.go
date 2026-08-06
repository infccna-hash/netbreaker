package labsession

import (
	"context"

	"netbreaker.io/api/internal/verify"
)

// Lab15AttackScenario injects the four faults Lab 15's Attack phase asks
// students to diagnose: Et0/0 and Et0/3 shut down, Et0/1 dropped into
// the wrong VLAN, and Et0/2 configured with portfast + bpduguard so a
// BPDU from KALI (via yersinia) genuinely err-disables the port — not
// simulated; verified on IOU 15.1a (SPANTREE-2-BLOCK_BPDUGUARD fires).
//
// COMMANDS MUST STAY IN SYNC with the attack phase Step 0 text (the
// current manual-workaround content) — migration 092 updated both sides
// together. If this scenario is ever wired to a real trigger (see
// scenario.go's TODO list) and Step 0's content isn't removed at the
// same time, students would end up applying the same faults twice —
// harmless for shutdown/VLAN (idempotent), but the bpduguard commands
// would error on the second run since the port is already guarded.
// Whoever wires the trigger needs to also strip Step 0 in the same
// change.
//
// NOT YET CALLED BY ANYTHING — see verify/scenario.go's TODO for the
// missing trigger. This function is tested in isolation
// (lab15_scenario_test.go) against a mock console, proving the command
// sequence is correct, independent of when/whether it's ever invoked.
func Lab15AttackScenario(sess *verify.LabSession) verify.Scenario {
	return verify.ScenarioFunc(func(ctx context.Context, r *verify.ScenarioRunner) error {
		return r.RunCommands(ctx, []string{
			"configure terminal",
			"interface Et0/0",
			"shutdown",
			"interface Et0/1",
			"switchport access vlan 99",
			"interface Et0/2",
			"spanning-tree portfast",
			"spanning-tree bpduguard enable",
			"interface Et0/3",
			"shutdown",
			"end",
		})
	})
}
