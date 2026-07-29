package verify

import (
	"context"
	"fmt"
	"regexp"
)

// Scenario is the write-side counterpart to Verifier: instead of reading
// device state (Collector), it pushes configuration commands onto a live
// device via the same console transport (ConsoleRunner) the verifier
// already uses. This is the abstraction behind "phase-transition fault
// injection" — see the platform-wide finding this addresses (2026-07-28):
// no lab has ever had a mechanism to pre-break a device before a student
// arrives at the Attack phase; every "find the faults" mission has
// actually started from a clean, fully-working device.
//
// Verifier and Scenario deliberately share ConsoleRunner rather than each
// growing their own transport — a verify check and an injected fault are
// the same kind of operation (send a command, read until prompt), just
// with different commands and different purposes.
type Scenario interface {
	Apply(ctx context.Context, r *ScenarioRunner) error
}

// ScenarioFunc adapts a plain function to the Scenario interface, the
// same way http.HandlerFunc adapts a function to http.Handler. Most
// per-lab scenarios are a short fixed command sequence and don't need a
// dedicated named type.
type ScenarioFunc func(ctx context.Context, r *ScenarioRunner) error

func (f ScenarioFunc) Apply(ctx context.Context, r *ScenarioRunner) error {
	return f(ctx, r)
}

// ScenarioRunner sends a sequence of configuration commands to one
// device over an existing ConsoleRunner, stopping at the first error.
// This is deliberately the thinnest possible wrapper — it does not
// retry, does not validate command syntax, and does not roll back a
// partially-applied scenario on failure. Those are real gaps a
// production version needs to close (see TODO below); this scaffold
// exists to prove the abstraction, not to be launch-ready.
type ScenarioRunner struct {
	Console  ConsoleRunner
	NodeID   string
	PromptRe *regexp.Regexp
}

// RunCommands sends each command in order, waiting for the device
// prompt between each one. Stops and returns the first error — a
// scenario that fails partway through leaves the device in a
// partially-configured state, which the caller must treat as a failed
// injection, not a partial success.
func (r *ScenarioRunner) RunCommands(ctx context.Context, cmds []string) error {
	for _, cmd := range cmds {
		if _, err := r.Console.RunCommand(ctx, r.NodeID, cmd, r.PromptRe); err != nil {
			return fmt.Errorf("scenario command %q on %s: %w", cmd, r.NodeID, err)
		}
	}
	return nil
}

// ScenarioFactory produces a Scenario for a specific lab session,
// mirroring VerifierFactory.
type ScenarioFactory func(sess *LabSession) Scenario

// ScenarioRegistry maps (labID, phase) -> ScenarioFactory, mirroring
// VerifierRegistry exactly. Labs that don't register a scenario for a
// phase get nil from Lookup — meaning "nothing to inject for this
// phase", not an error (Build and Harden phases have no scenario;
// only some Attack phases will).
type ScenarioRegistry struct {
	entries map[labPhaseKey]ScenarioFactory
}

func NewScenarioRegistry() *ScenarioRegistry {
	return &ScenarioRegistry{entries: map[labPhaseKey]ScenarioFactory{}}
}

// Register wires a scenario factory for a specific lab+phase.
func (r *ScenarioRegistry) Register(labID int, phase string, fn ScenarioFactory) {
	r.entries[labPhaseKey{labID, phase}] = fn
}

// Lookup returns the scenario factory for a lab+phase, or nil if none
// is registered.
func (r *ScenarioRegistry) Lookup(labID int, phase string) ScenarioFactory {
	return r.entries[labPhaseKey{labID, phase}]
}

// ── What's NOT here yet (deliberately out of scope for this scaffold) ──
//
// This file proves the Scenario/Verifier shared-transport abstraction
// and gives Lab 15's Attack phase a concrete, testable implementation
// (see internal/labsession/lab15_scenario.go). It does NOT include:
//
//  1. A trigger. Nothing calls ScenarioRegistry.Lookup or .Apply()
//     anywhere in the running system. The open design question is
//     WHEN this fires — options include: automatically the first time
//     a student's Verify call targets the Attack phase and no prior
//     injection is recorded for this session; an explicit "Start
//     Attack Phase" button the student clicks once; or a session-level
//     flag set at Attack-phase page load. Each has different UX and
//     idempotency implications (what happens if the trigger fires
//     twice — does RunCommands re-apply cleanly, or does e.g. running
//     "shutdown" twice matter? For this lab it's harmless, but a
//     general mechanism can't assume that for every future scenario).
//  2. Idempotency / already-applied tracking. A session table column
//     or similar recording "scenario applied at Attack-phase entry"
//     would prevent re-running RunCommands on every page reload.
//  3. Failure handling beyond "return the error". If RunCommands fails
//     partway through (e.g. console unreachable mid-sequence), the
//     device is left half-broken, half-clean — worse than not
//     injecting at all. A real version needs either transactional
//     apply (verify full success before considering it "applied") or
//     an idempotent design where re-running the same commands from any
//     partial state converges to the same end state.
//  4. Per-lab authoring ergonomics beyond a single Go file per
//     scenario. That's fine at 1 lab; at 46 it may want a declarative
//     format instead of hand-written command slices.
//
// Migration 048 (content-only workaround, same date) is what's actually
// live for Lab 15 today. This file is scaffolding for the real fix, not
// a replacement for it yet.
