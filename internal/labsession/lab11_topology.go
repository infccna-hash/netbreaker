package labsession

// Lab 11 — SSH vs Telnet Autopsy
// Topology: R1 (c3725) + SW1 (IOU) + KALI (QEMU)
// Text: "Cable: R1 Gi0/0 → SW1 Gi0/1, KALI → SW1 Gi0/2. Both in VLAN 1."
// R1 Gi0/0 → c3725 Fa0/0, SW1 Gi0/1 → Et0/1, SW1 Gi0/2 → Et0/2
var Lab11Topology = TopologyTemplate{
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
			Name:       "KALI",
			NodeType:   "docker",
			TemplateID: "efcdd6aa-8a18-4028-ae77-331d9e6d921b",
			Properties: map[string]any{"adapters": 2},
},
	},
	Links: []LinkTemplate{
		{NodeA: "R1", IfaceA: "Fa0/0", NodeB: "SW1", IfaceB: "Et0/1"},
		{NodeA: "KALI", IfaceA: "eth0", NodeB: "SW1", IfaceB: "Et0/2"},
	},
}
