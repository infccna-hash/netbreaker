package labsession

// Lab 06 — ACL Bypass Mission
// Topology: KALI (outside) → SW1 → R1 (ACL on f0/0 inbound) → SERVER (inside)
// R1 f0/0 = 203.0.113.1/30 (outside), R1 f0/1 = 10.0.20.1/24 (inside)
// KALI at 203.0.113.66; SERVER at 10.0.20.10; SW1 needed because GNS3 can't share
// one port across KALI + R1 — the outside segment uses a switch.
var Lab06Topology = TopologyTemplate{
	ComputeID: "local",
	Nodes: []NodeTemplate{
		{
			Name:     "R1",
			NodeType: "dynamips",
			Properties: map[string]any{
				"platform": "c3725",
				"image":    "/home/kobayashi/GNS3/images/IOS/c3725-adventerprisek9-mz.124-15.T14.image",
				"ram":      256,
				"slot0":    "GT96100-FE",
				"slot2":    "NM-1FE-TX",
			},
		},
		{
			Name:     "SW1",
			NodeType: "iou",
			Properties: map[string]any{
				"path": "i86bi-linux-l2-adventerprisek9-15.1a.bin",
			},
		},
		{
			Name:     "SERVER",
			NodeType: "vpcs",
		},
		{
			Name:       "KALI",
			NodeType:   "docker",
			TemplateID: "efcdd6aa-8a18-4028-ae77-331d9e6d921b",
			Properties: map[string]any{"adapters": 2},
		},
	},
	Links: []LinkTemplate{
		{NodeA: "R1", IfaceA: "Fa0/0", NodeB: "SW1", IfaceB: "Et0/0"},
		{NodeA: "KALI", IfaceA: "eth0", NodeB: "SW1", IfaceB: "Et0/1"},
		{NodeA: "R1", IfaceA: "Fa0/1", NodeB: "SERVER", IfaceB: "eth0"},
	},
}
