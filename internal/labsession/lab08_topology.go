package labsession

// Lab 08 — DHCP Starvation
// Text: "Cable: R1→SW1 Gi0/24 (trunk), PC1→SW1 Gi0/1 (access), KALI→SW1 Gi0/3 (access)"
// IOU 4-port limit: "Gi0/24" is conceptual — use Et0/0 for R1 trunk.
// Port mapping:
//   SW1: Et0/0=R1 Fa0/0 (trunk), Et0/1=PC1 (access), Et0/2=unused, Et0/3=KALI (access)
// NOTE: Text says Gi0/24 — IOU has 4 ports only. TEXT FIX PENDING.
var Lab08Topology = TopologyTemplate{
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
		{NodeA: "PC1", IfaceA: "eth0", NodeB: "SW1", IfaceB: "Et0/1"},
		{NodeA: "KALI", IfaceA: "eth0", NodeB: "SW1", IfaceB: "Et0/3"},
	},
}
