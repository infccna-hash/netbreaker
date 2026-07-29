package labsession

import (
	"context"
	"testing"

	"netbreaker.io/api/internal/verify"
)

// mockCollector satisfies verify.Collector with canned data.
type mockCollector struct {
	vlans      map[verify.Port]int
	interfaces map[verify.Port]verify.InterfaceStatus
	errdisable verify.ErrdisableConfig
}

func (m *mockCollector) CollectVLANs(_ context.Context) (map[verify.Port]int, error) {
	return m.vlans, nil
}

func (m *mockCollector) CollectInterfaces(_ context.Context, ports ...verify.Port) (map[verify.Port]verify.InterfaceStatus, error) {
	result := make(map[verify.Port]verify.InterfaceStatus, len(ports))
	for _, p := range ports {
		if iface, ok := m.interfaces[p]; ok {
			result[p] = iface
		}
	}
	return result, nil
}

func (m *mockCollector) CollectMACTable(_ context.Context) (verify.MACTable, error) {
	return nil, nil
}

func (m *mockCollector) CollectRunningConfig(_ context.Context) (string, error) {
	return "", nil
}

func (m *mockCollector) CollectErrdisableRecovery(_ context.Context) (verify.ErrdisableConfig, error) {
	return m.errdisable, nil
}

func (m *mockCollector) CollectReachability(_ context.Context, targets ...string) (map[string]bool, error) {
	return nil, nil
}

func TestLab1BuildVerifier_Passes(t *testing.T) {
	sess := &verify.LabSession{MACs: map[string]string{}, IPs: map[string]string{}}
	v := Lab1BuildVerifier(sess)

	collector := &mockCollector{
		vlans: map[verify.Port]int{
			"Et0/1": 10,
			"Et0/3": 10,
		},
		interfaces: map[verify.Port]verify.InterfaceStatus{
			"Et0/2": {AdminUp: true, LinkUp: true},
		},
	}

	result := v.Run(context.Background(), collector)

	if !result.Passed {
		t.Errorf("expected all checks to pass, got failures:")
		for _, c := range result.Checks {
			if !c.Passed {
				t.Logf("  [FAIL] %s: %s", c.Name, c.Detail)
			}
		}
	}
}

func TestLab1BuildVerifier_VLANWrong(t *testing.T) {
	sess := &verify.LabSession{MACs: map[string]string{}, IPs: map[string]string{}}
	v := Lab1BuildVerifier(sess)

	collector := &mockCollector{
		vlans: map[verify.Port]int{
			"Et0/1": 20, // Wrong VLAN — should be 10
			"Et0/3": 10,
		},
		interfaces: map[verify.Port]verify.InterfaceStatus{
			"Et0/2": {AdminUp: true, LinkUp: true},
		},
	}

	result := v.Run(context.Background(), collector)

	if result.Passed {
		t.Error("expected failure when Et0/1 is on wrong VLAN")
	}
}

func TestLab1BuildVerifier_InterfaceDown(t *testing.T) {
	sess := &verify.LabSession{MACs: map[string]string{}, IPs: map[string]string{}}
	v := Lab1BuildVerifier(sess)

	collector := &mockCollector{
		vlans: map[verify.Port]int{
			"Et0/1": 10,
			"Et0/3": 10,
		},
		interfaces: map[verify.Port]verify.InterfaceStatus{
			"Et0/2": {AdminUp: true, LinkUp: false}, // Link down
		},
	}

	result := v.Run(context.Background(), collector)

	if result.Passed {
		t.Error("expected failure when Et0/2 link is down")
	}
}
