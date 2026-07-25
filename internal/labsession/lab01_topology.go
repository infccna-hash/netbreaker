package labsession

// Lab 01 — VLAN Warfare / DTP Hijack
// Text: "PC1→SW1 Fa0/1, KALI→SW1 Fa0/3, SW1↔SW2 Fa0/2, R1→SW1 Fa0/24, SRV1→SW2 Fa0/1"
// IOU 4-port limit: "Fa0/24" is conceptual — use Et0/0 for R1 trunk.
// Port allocation:
//   SW1: Et0/0=R1, Et0/1=PC1, Et0/2=trunk→SW2, Et0/3=KALI
//   SW2: Et0/1=trunk→SW1, Et0/2=SRV1
var Lab01Topology = TopologyTemplate{
	ComputeID: "local",
	Nodes: []NodeTemplate{
		{
			Name:     "R1",
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
			Name:       "KALI",
			NodeType:   "docker",
			TemplateID: "efcdd6aa-8a18-4028-ae77-331d9e6d921b",
			Properties: map[string]any{"adapters": 2},
},
		{
			Name:     "SRV1",
			NodeType: "vpcs",
		},
	},
	Links: []LinkTemplate{
		{NodeA: "R1", IfaceA: "Fa0/0", NodeB: "SW1", IfaceB: "Et0/0"},
		{NodeA: "PC1", IfaceA: "eth0", NodeB: "SW1", IfaceB: "Et0/1"},
		{NodeA: "SW1", IfaceA: "Et0/2", NodeB: "SW2", IfaceB: "Et0/1"},
		{NodeA: "KALI", IfaceA: "eth0", NodeB: "SW1", IfaceB: "Et0/3"},
		{NodeA: "SRV1", IfaceA: "eth0", NodeB: "SW2", IfaceB: "Et0/2"},
	},
}
