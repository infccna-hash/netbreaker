package labsession

// Lab 20 — Interfaces & Autonegotiation
// Topology: SW1 (IOU) + PC1 (VPCS) + R1 (c3725) + KALI (QEMU)
// Text: "Gi0/1–3 (access), Gi0/24 (trunk)" — IOU L2 image has 4 ports (Et0/0–3)
// Port mapping (0-indexed to fit IOU's 4-port limit):
//   Et0/1 ← PC1 (access, VLAN 10)
//   Et0/2 ← KALI (access)
//   Et0/3 ← R1 Fa0/0 (trunk — "Gi0/24" in conceptual 24-port switch)
var Lab20Topology = TopologyTemplate{
	ComputeID: "local",
	Nodes: []NodeTemplate{
		{
			Name:     "SW1",
			NodeType: "iou",
			Properties: map[string]any{"adapters": 2},
},
		{
			Name:     "PC1",
			NodeType: "vpcs",
		},
		{
			Name:     "R1",
			NodeType: "dynamips",
			Properties: map[string]any{"adapters": 2},
},
		{
			Name:       "KALI",
			NodeType:   "docker",
			TemplateID: "efcdd6aa-8a18-4028-ae77-331d9e6d921b",
			Properties: map[string]any{"adapters": 2},
},
	},
	Links: []LinkTemplate{
		{NodeA: "PC1", IfaceA: "eth0", NodeB: "SW1", IfaceB: "Et0/1"},
		{NodeA: "KALI", IfaceA: "eth0", NodeB: "SW1", IfaceB: "Et0/2"},
		{NodeA: "R1", IfaceA: "Fa0/0", NodeB: "SW1", IfaceB: "Et0/3"},
	},
}
