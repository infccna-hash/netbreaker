package labsession

import (
	"testing"

	"netbreaker.io/api/internal/verify"
)

func TestResolveVerifySession(t *testing.T) {
	sess := &Session{
		NodeMap: NodeMap{
			"SW1":  {ConsolePort: 5000, NodeType: "iou", GNS3NodeID: "abc123"},
			"R1":   {ConsolePort: 5001, NodeType: "dynamips", GNS3NodeID: "def456"},
			"KALI": {ConsolePort: 5002, NodeType: "docker", ConsoleType: "telnet", MAC: "02:42:ac:11:00:02"},
		},
	}

	vs := ResolveVerifySession(sess, "10.0.0.1")

	if vs == nil {
		t.Fatal("ResolveVerifySession returned nil")
	}

	// ConsoleNodes should have all 3 entries
	if len(vs.ConsoleNodes) != 3 {
		t.Errorf("expected 3 ConsoleNodes, got %d", len(vs.ConsoleNodes))
	}

	// SW1
	sw1, ok := vs.ConsoleNodes["SW1"]
	if !ok {
		t.Error("SW1 missing from ConsoleNodes")
	} else {
		if sw1.Host != "10.0.0.1" {
			t.Errorf("SW1 host = %q, want 10.0.0.1", sw1.Host)
		}
		if sw1.Port != 5000 {
			t.Errorf("SW1 port = %d, want 5000", sw1.Port)
		}
	}

	// R1
	r1, ok := vs.ConsoleNodes["R1"]
	if !ok {
		t.Error("R1 missing from ConsoleNodes")
	} else if r1.Port != 5001 {
		t.Errorf("R1 port = %d, want 5001", r1.Port)
	}

	// KALI MAC should be populated from NodeInfo.MAC
	kaliMac := vs.MACs["KALI"]
	if kaliMac != "02:42:ac:11:00:02" {
		t.Errorf("KALI MAC = %q, want 02:42:ac:11:00:02", kaliMac)
	}

	// SW1 has no MAC (switch) — sess.MAC("SW1") should return sentinel
	sw1Mac := vs.MAC("SW1")
	if sw1Mac != "<unresolved:SW1>" {
		t.Errorf("SW1 MAC = %q, want sentinel '<unresolved:SW1>'", sw1Mac)
	}

	// IPs should be empty (not nil)
	if vs.IPs == nil {
		t.Error("IPs map is nil, should be empty")
	}
	if len(vs.IPs) != 0 {
		t.Error("IPs should be empty")
	}

	// Empty session
	emptySess := &Session{NodeMap: NodeMap{}}
	emptyVs := ResolveVerifySession(emptySess, "10.0.0.1")
	if len(emptyVs.ConsoleNodes) != 0 {
		t.Errorf("empty session should have 0 ConsoleNodes, got %d", len(emptyVs.ConsoleNodes))
	}
}

func TestResolveVerifySession_IntegrationPoint(t *testing.T) {
	// Verify that the function signature is usable as intended:
	//   vs := ResolveVerifySession(sess, s.computeHost)
	//   runner := verify.NewTelnetConsoleRunner(s.computeHost, vs.ConsoleNodes)
	//   collector := verify.NewIOSCollector(runner, "SW1", devicePromptRe("Switch#"))
	//
	// This test just confirms the types line up.

	sess := &Session{
		NodeMap: NodeMap{
			"SW1": {ConsolePort: 5000},
		},
	}
	computeHost := "100.124.157.39"

	vs := ResolveVerifySession(sess, computeHost)

	// These should compile and produce no nil panics
	_ = verify.NewTelnetConsoleRunner(computeHost, vs.ConsoleNodes)
	_ = vs.MAC("SW1") // returns MAC("") — empty string, not panic
	_ = vs.IP("SW1")  // returns "" — not panic
}
