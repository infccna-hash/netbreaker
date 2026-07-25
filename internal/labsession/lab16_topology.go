package labsession

// Lab 16 — Crossover Cables / MDIX
// Text: "Cable SW1↔SW2 with a straight-through cable (the wrong type)"
// Topology: SW1↔SW2 (direct IOU-IOU), PC1→SW1, PC2→SW2, R1→SW1, KALI→SW2
// Port mapping (IOU 4-port):
//   SW1: Et0/0=PC1, Et0/1=R1, Et0/2=SW2
//   SW2: Et0/0=KALI, Et0/1=SW1, Et0/2=PC2
var Lab16Topology = TopologyTemplate{
	ComputeID: "local",
	Nodes: []NodeTemplate{
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
			Name:     "R1",
			NodeType: "dynamips",
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
		{NodeA: "PC1", IfaceA: "eth0", NodeB: "SW1", IfaceB: "Et0/0"},
		{NodeA: "R1", IfaceA: "Fa0/0", NodeB: "SW1", IfaceB: "Et0/1"},
		{NodeA: "SW1", IfaceA: "Et0/2", NodeB: "SW2", IfaceB: "Et0/1"},
		{NodeA: "KALI", IfaceA: "eth0", NodeB: "SW2", IfaceB: "Et0/0"},
		{NodeA: "PC2", IfaceA: "eth0", NodeB: "SW2", IfaceB: "Et0/2"},
	},
}
