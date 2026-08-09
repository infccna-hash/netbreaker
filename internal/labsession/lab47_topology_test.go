package labsession

import "testing"

// TestLab47Topology validates the Lab 47 template: every node type is
// supported, every link interface maps to a real GNS3 adapter/port,
// and the topology resolves via the registry.
func TestLab47Topology(t *testing.T) {
	topo := Lab47Topology

	// Node names expected in the FortiGate fortress.
	wantNodes := map[string]string{
		"R1":   "dynamips",
		"FW":   "qemu",
		"R2":   "dynamips",
		"SW1":  "iou",
		"PC1":  "vpcs",
		"PC2":  "vpcs",
		"KALI": "docker",
	}
	if len(topo.Nodes) != len(wantNodes) {
		t.Fatalf("expected %d nodes, got %d", len(wantNodes), len(topo.Nodes))
	}
	for _, n := range topo.Nodes {
		want, ok := wantNodes[n.Name]
		if !ok {
			t.Errorf("unexpected node %q", n.Name)
			continue
		}
		if n.NodeType != want {
			t.Errorf("node %s: type %q, want %q", n.Name, n.NodeType, want)
		}
	}

	// QEMU (FortiGate) requires the VNC-capable template; the platform
	// treats qemu nodes as VNC console regardless of console_type.
	if topo.Nodes[1].Name != "FW" || topo.Nodes[1].TemplateID == "" {
		t.Errorf("FW node missing TemplateID")
	}

	// Every link must translate to valid adapter/port numbers.
	for _, l := range topo.Links {
		if _, _, err := interfaceToPort(nodeTypeOf(topo, l.NodeA), l.IfaceA); err != nil {
			t.Errorf("link %s:%s → %s:%s: %v", l.NodeA, l.IfaceA, l.NodeB, l.IfaceB, err)
		}
		if _, _, err := interfaceToPort(nodeTypeOf(topo, l.NodeB), l.IfaceB); err != nil {
			t.Errorf("link %s:%s → %s:%s: %v", l.NodeA, l.IfaceA, l.NodeB, l.IfaceB, err)
		}
	}

	// Registry lookup resolves Lab 47.
	if got := lookupTopologyTemplate(47); len(got.Nodes) == 0 {
		t.Fatal("lookupTopologyTemplate(47) returned empty template")
	}
}
