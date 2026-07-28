package verify_test

import (
	"context"
	"testing"

	"netbreaker.io/api/internal/verify"
)

// mockCollector implements verify.Collector entirely in memory and
// counts calls per method — this is what makes 45 labs' worth of
// verifiers testable in milliseconds with no GNS3, no telnet, no
// booted Cisco image.
type mockCollector struct {
	macTable     verify.MACTable
	interfaces   map[verify.Port]verify.InterfaceStatus
	errdisable   verify.ErrdisableConfig
	reachability map[string]bool
	vlans        map[verify.Port]int

	macTableCalls   int
	interfaceCalls  map[verify.Port]int
	errdisableCalls int
	vlanCalls       int
}

func newMockCollector() *mockCollector {
	return &mockCollector{
		interfaces:     map[verify.Port]verify.InterfaceStatus{},
		reachability:   map[string]bool{},
		vlans:          map[verify.Port]int{},
		interfaceCalls: map[verify.Port]int{},
	}
}

func (m *mockCollector) CollectVLANs(ctx context.Context) (map[verify.Port]int, error) {
	m.vlanCalls++
	return m.vlans, nil
}

func (m *mockCollector) CollectMACTable(ctx context.Context) (verify.MACTable, error) {
	m.macTableCalls++
	return m.macTable, nil
}

func (m *mockCollector) CollectInterfaces(ctx context.Context, ports ...verify.Port) (map[verify.Port]verify.InterfaceStatus, error) {
	result := map[verify.Port]verify.InterfaceStatus{}
	for _, p := range ports {
		m.interfaceCalls[p]++
		result[p] = m.interfaces[p]
	}
	return result, nil
}

func (m *mockCollector) CollectRunningConfig(ctx context.Context) (string, error) {
	return "", nil
}

func (m *mockCollector) CollectErrdisableRecovery(ctx context.Context) (verify.ErrdisableConfig, error) {
	m.errdisableCalls++
	return m.errdisable, nil
}

func (m *mockCollector) CollectReachability(ctx context.Context, targets ...string) (map[string]bool, error) {
	result := map[string]bool{}
	for _, t := range targets {
		result[t] = m.reachability[t]
	}
	return result, nil
}

// --- individual assertion behavior ---

func TestExpectMACOnPort_Pass(t *testing.T) {
	m := newMockCollector()
	m.macTable = verify.MACTable{{MAC: "aa:bb:cc:00:10:10", Port: "Et0/1"}}

	res := verify.New().
		ExpectMACOnPort("PC3 on its own port", "aa:bb:cc:00:10:10", "Et0/1").
		Run(context.Background(), m)

	if !res.Passed {
		t.Fatalf("expected pass, got checks: %+v", res.Checks)
	}
}

func TestExpectMACOnPort_WrongPort(t *testing.T) {
	m := newMockCollector()
	m.macTable = verify.MACTable{{MAC: "aa:bb:cc:00:10:10", Port: "Et0/4"}}

	res := verify.New().
		ExpectMACOnPort("PC3 on its own port", "aa:bb:cc:00:10:10", "Et0/1").
		Run(context.Background(), m)

	if res.Passed {
		t.Fatal("expected failure when MAC is on the wrong port")
	}
	if res.Checks[0].Detail != "expected Et0/1, found on Et0/4" {
		t.Errorf("unexpected detail message: %q", res.Checks[0].Detail)
	}
}

func TestExpectMACOnPort_NotLearned(t *testing.T) {
	m := newMockCollector()
	res := verify.New().
		ExpectMACOnPort("unlearned host", "aa:bb:cc:99:99:99", "Et0/1").
		Run(context.Background(), m)

	if res.Passed {
		t.Fatal("expected failure when MAC was never learned")
	}
}

func TestExpectMACsShareOnePort_Pass(t *testing.T) {
	m := newMockCollector()
	m.macTable = verify.MACTable{
		{MAC: "aa:00", Port: "Et0/0"},
		{MAC: "bb:00", Port: "Et0/0"},
		{MAC: "cc:00", Port: "Et0/0"},
	}
	res := verify.New().
		ExpectMACsShareOnePort("hub collapses to one port",
			[]verify.MAC{"aa:00", "bb:00", "cc:00"}, "Et0/0").
		Run(context.Background(), m)

	if !res.Passed {
		t.Fatalf("expected pass, got: %+v", res.Checks)
	}
}

func TestExpectMACsShareOnePort_OneOnDifferentPort(t *testing.T) {
	m := newMockCollector()
	m.macTable = verify.MACTable{
		{MAC: "aa:00", Port: "Et0/0"},
		{MAC: "bb:00", Port: "Et0/0"},
		{MAC: "cc:00", Port: "Et0/4"}, // e.g. student wired KALI2 to the wrong port
	}
	res := verify.New().
		ExpectMACsShareOnePort("hub collapses to one port",
			[]verify.MAC{"aa:00", "bb:00", "cc:00"}, "Et0/0").
		Run(context.Background(), m)

	if res.Passed {
		t.Fatal("expected failure when one MAC is on a different port")
	}
}

func TestExpectInterfaceUp_FailsOnErrDisabled(t *testing.T) {
	m := newMockCollector()
	m.interfaces["Et0/2"] = verify.InterfaceStatus{AdminUp: true, LinkUp: false, ErrDisabled: true}

	res := verify.New().ExpectInterfaceUp("Et0/2").Run(context.Background(), m)
	if res.Passed {
		t.Fatal("expected failure for err-disabled port")
	}
	if res.Checks[0].Detail != "port is err-disabled" {
		t.Errorf("unexpected detail: %q", res.Checks[0].Detail)
	}
}

func TestExpectInterfaceUp_FailsOnAdminDown(t *testing.T) {
	m := newMockCollector()
	m.interfaces["Et0/1"] = verify.InterfaceStatus{AdminUp: false}

	res := verify.New().ExpectInterfaceUp("Et0/1").Run(context.Background(), m)
	if res.Passed {
		t.Fatal("expected failure for admin-down port")
	}
}

func TestExpectInterfaceSpeedAndDuplex(t *testing.T) {
	m := newMockCollector()
	m.interfaces["Et0/3"] = verify.InterfaceStatus{
		AdminUp: true, LinkUp: true, SpeedMbps: 1000, Duplex: verify.DuplexFull,
	}

	res := verify.New().
		ExpectInterfaceSpeed("Et0/3", 1000).
		ExpectInterfaceDuplex("Et0/3", verify.DuplexFull).
		Run(context.Background(), m)

	if !res.Passed {
		t.Fatalf("expected pass, got: %+v", res.Checks)
	}
}

func TestExpectInterfaceSpeed_Mismatch(t *testing.T) {
	m := newMockCollector()
	m.interfaces["Et0/3"] = verify.InterfaceStatus{SpeedMbps: 10}

	res := verify.New().ExpectInterfaceSpeed("Et0/3", 1000).Run(context.Background(), m)
	if res.Passed {
		t.Fatal("expected failure on speed mismatch")
	}
}

func TestExpectDescription(t *testing.T) {
	m := newMockCollector()
	m.interfaces["Et0/1"] = verify.InterfaceStatus{Description: "LINK-TO-PC3"}

	pass := verify.New().ExpectDescription("Et0/1", "LINK-TO-PC3").Run(context.Background(), m)
	if !pass.Passed {
		t.Fatalf("expected pass, got: %+v", pass.Checks)
	}

	fail := verify.New().ExpectDescription("Et0/1", "WRONG-LABEL").Run(context.Background(), m)
	if fail.Passed {
		t.Fatal("expected failure on description mismatch")
	}
}

func TestExpectErrdisableRecovery(t *testing.T) {
	m := newMockCollector()
	m.errdisable = verify.ErrdisableConfig{Enabled: true, IntervalSec: 300}

	pass := verify.New().ExpectErrdisableRecovery(300).Run(context.Background(), m)
	if !pass.Passed {
		t.Fatalf("expected pass, got: %+v", pass.Checks)
	}

	fail := verify.New().ExpectErrdisableRecovery(600).Run(context.Background(), m)
	if fail.Passed {
		t.Fatal("expected failure on interval mismatch")
	}
}

func TestExpectPortVLAN_Pass(t *testing.T) {
	m := newMockCollector()
	m.vlans["Et0/1"] = 1

	res := verify.New().ExpectPortVLAN("Et0/1", 1).Run(context.Background(), m)
	if !res.Passed {
		t.Fatalf("expected pass, got: %+v", res.Checks)
	}
}

func TestExpectPortVLAN_WrongVLAN(t *testing.T) {
	// Fault 2, replaced: PC3's port accidentally moved to VLAN 99.
	m := newMockCollector()
	m.vlans["Et0/1"] = 99

	res := verify.New().ExpectPortVLAN("Et0/1", 1).Run(context.Background(), m)
	if res.Passed {
		t.Fatal("expected failure when port is in the wrong VLAN")
	}
	if res.Checks[0].Detail != "expected VLAN 1, found VLAN 99" {
		t.Errorf("unexpected detail: %q", res.Checks[0].Detail)
	}
}

func TestExpectPortVLAN_NoAssignmentFound(t *testing.T) {
	m := newMockCollector()
	res := verify.New().ExpectPortVLAN("Et0/9", 1).Run(context.Background(), m)
	if res.Passed {
		t.Fatal("expected failure when port has no VLAN entry at all")
	}
}

func TestEvidenceStore_VLANsFetchedOnce(t *testing.T) {
	m := newMockCollector()
	m.vlans["Et0/1"] = 1
	m.vlans["Et0/2"] = 1

	verify.New().
		ExpectPortVLAN("Et0/1", 1).
		ExpectPortVLAN("Et0/2", 1).
		Run(context.Background(), m)

	if m.vlanCalls != 1 {
		t.Errorf("expected exactly 1 VLAN collection for 2 port checks, got %d", m.vlanCalls)
	}
}

func TestExpectReachable(t *testing.T) {
	m := newMockCollector()
	m.reachability["192.168.1.10"] = true
	m.reachability["192.168.1.99"] = false

	pass := verify.New().ExpectReachable("PC1", "192.168.1.10").Run(context.Background(), m)
	if !pass.Passed {
		t.Fatalf("expected pass, got: %+v", pass.Checks)
	}

	fail := verify.New().ExpectReachable("ghost", "192.168.1.99").Run(context.Background(), m)
	if fail.Passed {
		t.Fatal("expected failure for unreachable host")
	}

	// Negative control: IP valid but host not configured to respond.
	// Proves the check is live (real ping) — not a placebo that passes
	// whenever the IP string is non-empty.
	noResponse := verify.New().ExpectReachable("dead-host", "192.168.1.55").Run(context.Background(), m)
	if noResponse.Passed {
		t.Fatal("negative control: expected failure for IP with no responder")
	}
}

func TestExpectReachable_EmptyIP(t *testing.T) {
	// Guard: empty IP fails immediately (no ping command built).
	m := newMockCollector()
	result := verify.New().ExpectReachable("R1", "").Run(context.Background(), m)
	if result.Passed {
		t.Fatal("expected failure for empty IP target")
	}
	c := result.Checks[0]
	if c.Detail != "IP not configured for host R1" {
		t.Fatalf("expected guard message, got: %s", c.Detail)
	}
}

// --- the actual point of the EvidenceStore: caching ---

func TestEvidenceStore_MACTableFetchedOnce(t *testing.T) {
	m := newMockCollector()
	m.macTable = verify.MACTable{{MAC: "aa:00", Port: "Et0/0"}}

	// Three assertions all need the MAC table — should be one collector call.
	verify.New().
		ExpectMACOnPort("check 1", "aa:00", "Et0/0").
		ExpectMACOnPort("check 2", "aa:00", "Et0/0").
		ExpectMACsShareOnePort("check 3", []verify.MAC{"aa:00"}, "Et0/0").
		Run(context.Background(), m)

	if m.macTableCalls != 1 {
		t.Errorf("expected exactly 1 MAC table collection, got %d", m.macTableCalls)
	}
}

func TestEvidenceStore_InterfaceFetchedOncePerPort(t *testing.T) {
	m := newMockCollector()
	m.interfaces["Et0/3"] = verify.InterfaceStatus{
		AdminUp: true, LinkUp: true, SpeedMbps: 1000, Duplex: verify.DuplexFull,
		Description: "UPLINK-TO-R1",
	}

	// Four checks against the same port — should be one console round-trip.
	verify.New().
		ExpectInterfaceUp("Et0/3").
		ExpectInterfaceSpeed("Et0/3", 1000).
		ExpectInterfaceDuplex("Et0/3", verify.DuplexFull).
		ExpectDescription("Et0/3", "UPLINK-TO-R1").
		Run(context.Background(), m)

	if m.interfaceCalls["Et0/3"] != 1 {
		t.Errorf("expected exactly 1 collection for Et0/3, got %d", m.interfaceCalls["Et0/3"])
	}
}

func TestEvidenceStore_DoesNotCacheAcrossSeparateRuns(t *testing.T) {
	m := newMockCollector()
	m.macTable = verify.MACTable{{MAC: "aa:00", Port: "Et0/0"}}

	v := verify.New().ExpectMACOnPort("check", "aa:00", "Et0/0")
	v.Run(context.Background(), m)
	v.Run(context.Background(), m) // re-verify attempt, e.g. student retries

	if m.macTableCalls != 2 {
		t.Errorf("expected fresh collection per Run() call, got %d total calls", m.macTableCalls)
	}
}

// --- full Lab 15 scenario, no GNS3 required ---

func TestLab15Build_FullPassScenario(t *testing.T) {
	m := newMockCollector()
	m.macTable = verify.MACTable{
		{MAC: "pc1", Port: "Et0/0"},
		{MAC: "pc2", Port: "Et0/0"},
		{MAC: "kali2", Port: "Et0/0"},
		{MAC: "pc3", Port: "Et0/1"},
		{MAC: "kali", Port: "Et0/2"},
	}

	res := verify.New().
		ExpectMACsShareOnePort("hub segment collapses to one port",
			[]verify.MAC{"pc1", "pc2", "kali2"}, "Et0/0").
		ExpectMACOnPort("PC3 has its own dedicated port", "pc3", "Et0/1").
		ExpectMACOnPort("KALI has its own dedicated port", "kali", "Et0/2").
		Run(context.Background(), m)

	if !res.Passed {
		t.Fatalf("expected full pass, got: %+v", res.Checks)
	}
	if len(res.Checks) != 3 {
		t.Errorf("expected 3 checks, got %d", len(res.Checks))
	}
}

func TestLab15Build_StudentMiscabledKALI2(t *testing.T) {
	// KALI2 accidentally wired to SW1 directly instead of H1 —
	// verify should fail with a specific, actionable detail.
	m := newMockCollector()
	m.macTable = verify.MACTable{
		{MAC: "pc1", Port: "Et0/0"},
		{MAC: "pc2", Port: "Et0/0"},
		{MAC: "kali2", Port: "Et0/4"}, // wrong
		{MAC: "pc3", Port: "Et0/1"},
		{MAC: "kali", Port: "Et0/2"},
	}

	res := verify.New().
		ExpectMACsShareOnePort("hub segment collapses to one port",
			[]verify.MAC{"pc1", "pc2", "kali2"}, "Et0/0").
		ExpectMACOnPort("PC3 has its own dedicated port", "pc3", "Et0/1").
		ExpectMACOnPort("KALI has its own dedicated port", "kali", "Et0/2").
		Run(context.Background(), m)

	if res.Passed {
		t.Fatal("expected failure when KALI2 is miscabled")
	}
	if res.Checks[0].Passed {
		t.Error("expected the hub-segment check specifically to fail")
	}
	if res.Checks[1].Passed == false || res.Checks[2].Passed == false {
		t.Error("PC3 and KALI checks should still pass independently")
	}
}
