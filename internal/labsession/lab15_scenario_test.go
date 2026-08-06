package labsession

import (
	"context"
	"errors"
	"regexp"
	"testing"

	"netbreaker.io/api/internal/verify"
)

// mockConsoleRunner records every command it's asked to run, in order,
// and can be told to fail on a specific command (by index) to test
// partial-failure behavior.
type mockConsoleRunner struct {
	sent      []string
	failAtIdx int // -1 means never fail
}

func (m *mockConsoleRunner) RunCommand(_ context.Context, nodeID, cmd string, _ *regexp.Regexp) (string, error) {
	m.sent = append(m.sent, cmd)
	if m.failAtIdx >= 0 && len(m.sent)-1 == m.failAtIdx {
		return "", errors.New("simulated console failure")
	}
	return nodeID + "# ", nil
}

// TestLab15AttackScenario_SendsExactFaultSequence locks in the exact
// command sequence — this is the parity guard mentioned in
// lab15_scenario.go's doc comment: if migration 048's manual Step 0
// content ever changes, this test (and the scenario code) needs to
// change with it, not drift silently.
func TestLab15AttackScenario_SendsExactFaultSequence(t *testing.T) {
	mock := &mockConsoleRunner{failAtIdx: -1}
	runner := &verify.ScenarioRunner{
		Console:  mock,
		NodeID:   "SW1",
		PromptRe: regexp.MustCompile(`\S+[#>]\s*$`),
	}

	sess := &verify.LabSession{}
	scenario := Lab15AttackScenario(sess)

	if err := scenario.Apply(context.Background(), runner); err != nil {
		t.Fatalf("Apply: %v", err)
	}

	want := []string{
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
	}

	if len(mock.sent) != len(want) {
		t.Fatalf("sent %d commands, want %d\ngot:  %v\nwant: %v", len(mock.sent), len(want), mock.sent, want)
	}
	for i, cmd := range want {
		if mock.sent[i] != cmd {
			t.Errorf("command %d: got %q, want %q", i, mock.sent[i], cmd)
		}
	}
}

// TestLab15AttackScenario_StopsOnFirstFailure documents (not fixes) the
// no-rollback behavior noted in scenario.go's TODO list: if a command
// mid-sequence fails, RunCommands stops immediately and returns the
// error — it does not retry, skip, or roll back the commands already
// sent. A device that fails here is left half-configured. This is a
// real gap in the scaffold, called out deliberately rather than
// silently accepted.
func TestLab15AttackScenario_StopsOnFirstFailure(t *testing.T) {
	mock := &mockConsoleRunner{failAtIdx: 5} // fails on "spanning-tree portfast"
	runner := &verify.ScenarioRunner{
		Console:  mock,
		NodeID:   "SW1",
		PromptRe: regexp.MustCompile(`\S+[#>]\s*$`),
	}

	sess := &verify.LabSession{}
	scenario := Lab15AttackScenario(sess)

	err := scenario.Apply(context.Background(), runner)
	if err == nil {
		t.Fatal("expected an error from the simulated mid-sequence failure, got nil")
	}
	if len(mock.sent) != 6 {
		t.Errorf("expected exactly 6 commands sent before stopping (5 successful + 1 failed attempt), got %d: %v",
			len(mock.sent), mock.sent)
	}
}
