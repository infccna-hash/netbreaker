package labsession

// Lab 05 — HSRP Takeover
// Topology: R1 (c3725 Active), R2 (c3725 Standby), SW1 (IOU), PC1 (VPCS), KALI (QEMU)
// Both routers + hosts share VLAN 1 through SW1. HSRP hellos via multicast.
// Text: R1(Active prio150) + R2(Standby prio100) → SW1, PC1→SW1, KALI→SW1
// SVG red line KALI→R1 is conceptual (attack vector), not a physical cable.
var Lab05Topology = TopologyTemplate{
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
			},
		},
		{
			Name:     "R2",
			NodeType: "dynamips",
			Properties: map[string]any{
				"platform": "c3725",
				"image":    "/home/kobayashi/GNS3/images/IOS/c3725-adventerprisek9-mz.124-15.T14.image",
				"ram":      256,
				"slot0":    "GT96100-FE",
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
			Name:     "PC1",
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
		{NodeA: "R2", IfaceA: "Fa0/0", NodeB: "SW1", IfaceB: "Et0/1"},
		{NodeA: "PC1", IfaceA: "eth0", NodeB: "SW1", IfaceB: "Et0/2"},
		{NodeA: "KALI", IfaceA: "eth0", NodeB: "SW1", IfaceB: "Et0/3"},
	},
}
