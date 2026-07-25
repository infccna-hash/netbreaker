package labsession

// Lab 19 — Routing Between LANs
// R1: 3-interface router (Fa0/0=LAN A, Fa0/1=LAN B, Fa2/0=WAN via NM-1FE-TX)
// Topology:
//   LAN A: R1 Fa0/0 (192.168.10.1) → SW1, with PC1(.10), PC2(.20), KALI
//   LAN B: R1 Fa0/1 (172.16.20.1) → PC3(.20) direct
//   WAN:   R1 Fa2/0 (10.0.0.1/30) → R2 Fa0/0 (10.0.0.2/30)
//
// R1 needs NM-1FE-TX (slot2) for Fa2/0 WAN interface.
// NOTE: Text says gi0/0, gi0/1, gi0/2 for R1 — TEXT FIX PENDING.
var Lab19Topology = TopologyTemplate{
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
			Name:     "PC1",
			NodeType: "vpcs",
		},
		{
			Name:     "PC2",
			NodeType: "vpcs",
		},
		{
			Name:     "PC3",
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
		{NodeA: "PC2", IfaceA: "eth0", NodeB: "SW1", IfaceB: "Et0/2"},
		{NodeA: "KALI", IfaceA: "eth0", NodeB: "SW1", IfaceB: "Et0/3"},
		{NodeA: "R1", IfaceA: "Fa0/1", NodeB: "PC3", IfaceB: "eth0"},
		{NodeA: "R1", IfaceA: "Fa2/0", NodeB: "R2", IfaceB: "Fa0/0"},
	},
}
