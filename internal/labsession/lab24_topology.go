package labsession

// Lab 24 — DTP/VTP (Dynamic Trunking Protocol / VTP Domain Attacks)
// Text: "SW1↔SW2 trunks, DTP negotiation, VTP domain propagation"
// IOU 4-port limit:
//   SW1: Et0/0=trunk→SW2, Et0/1=KALI, Et0/2=PC1
//   SW2: Et0/0=trunk→SW1
var Lab24Topology = TopologyTemplate{
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
		{NodeA: "SW1", IfaceA: "Et0/0", NodeB: "SW2", IfaceB: "Et0/0"},
		{NodeA: "KALI", IfaceA: "eth0", NodeB: "SW1", IfaceB: "Et0/1"},
		{NodeA: "PC1", IfaceA: "eth0", NodeB: "SW1", IfaceB: "Et0/2"},
	},
}
