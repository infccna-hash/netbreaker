package labsession

// Lab 17 — TCP/IP Encapsulation / Multi-Layer Attack
// Text: All on 10.0.0.0/24 — PC1 (.10), PC2 (.20), R1 (.1 gw), KALI (.100)
// Simple flat topology: PC1, PC2, R1, KALI all share SW1 on same VLAN.
// ARP spoof (L2), fragmentation (L3), SYN flood (L4) all visible on shared segment.
var Lab17Topology = TopologyTemplate{
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
		{NodeA: "PC2", IfaceA: "eth0", NodeB: "SW1", IfaceB: "Et0/2"},
		{NodeA: "KALI", IfaceA: "eth0", NodeB: "SW1", IfaceB: "Et0/3"},
	},
}
