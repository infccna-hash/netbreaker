package labsession

// Lab 09 — NAT Gateway / PAT
// Topology: R1 (NAT gw, inside/outside), R2 (ISP), SW1 (inside), SW2 (outside), PC1, PC2, KALI
// Inside: PC1 → SW1 Et0/1 → R1 Fa0/0 (inside, 192.168.1.1/24)
// Outside: R1 Fa0/1 (10.0.0.1) → SW2 Et0/0, R2 Fa0/0 (10.0.0.2) → SW2 Et0/1, KALI → SW2 Et0/2
// PC2 → R2 Fa0/1 (203.0.113.x) — direct link
//
// R1 = c3725 (Fa0/0 inside, Fa0/1 outside)
// R2 = c3725 (Fa0/0 = 10.0.0.2, Fa0/1 = 203.0.113.1)
// NOTE: Lab text says Gi0/0 for R1 — should be Fa0/0 (c3725). TEXT FIX PENDING.
var Lab09Topology = TopologyTemplate{
	ComputeID: "local",
	Nodes: []NodeTemplate{
		{
			Name:     "R1",
			NodeType: "dynamips",
			Properties: map[string]any{"adapters": 2},
},
		{
			Name:     "R2",
			NodeType: "dynamips",
			Properties: map[string]any{"adapters": 2},
},
		{
			Name:     "SW1",
			NodeType: "iou",
			Properties: map[string]any{"adapters": 2},
},
		{
			Name:     "SW2",
			NodeType: "iou",
			Properties: map[string]any{"adapters": 2},
},
		{
			Name:     "PC1",
			NodeType: "vpcs",
		},
		{
			Name:     "PC2",
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
		{NodeA: "PC1", IfaceA: "eth0", NodeB: "SW1", IfaceB: "Et0/1"},
		{NodeA: "R1", IfaceA: "Fa0/1", NodeB: "SW2", IfaceB: "Et0/0"},
		{NodeA: "R2", IfaceA: "Fa0/0", NodeB: "SW2", IfaceB: "Et0/1"},
		{NodeA: "KALI", IfaceA: "eth0", NodeB: "SW2", IfaceB: "Et0/2"},
		{NodeA: "R2", IfaceA: "Fa0/1", NodeB: "PC2", IfaceB: "eth0"},
	},
}
