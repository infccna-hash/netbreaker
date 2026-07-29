package labsession

import (
	"context"

	"netbreaker.io/api/internal/verify"
)

// Lab15AttackScenario injects the four faults Lab 15's Attack phase asks
// students to diagnose: Et0/0 and Et0/3 shut down, Et0/1 dropped into
// the wrong VLAN, and Et0/2 configured with a port-security policy that
// will genuinely err-disable the moment KALI's real MAC touches the
// wire (not simulated — a real violation against a real allow-list).
//
// COMMANDS MUST STAY IN SYNC with migration 048's Step 0 (the current
// manual-workaround content) — that migration has the student type this
// exact sequence by hand today. If this scenario is ever wired to a
// real trigger (see scenario.go's TODO list) and Step 0's content isn't
// removed at the same time, students would end up applying the same
// faults twice — harmless for shutdown/VLAN (idempotent), but the
// port-security commands would error on the second run since the port
// is already secured. Whoever wires the trigger needs to also strip
// migration 048's Step 0 in the same change.
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
			"switchport port-security",
			"switchport port-security maximum 1",
			"switchport port-security violation shutdown",
			"switchport port-security mac-address 0000.0000.0001",
			"interface Et0/3",
			"shutdown",
			"end",
		})
	})
}
