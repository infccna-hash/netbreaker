package labsession

// Lab 25 — RSTP (Rapid Spanning Tree Protocol)
// Text: "3-switch triangle with redundant links, STA convergence"
// IOU 4-port limit:
//   SW1: Et0/0=trunk→SW2, Et0/1=trunk→SW3, Et0/2=KALI, Et0/3=PC1
//   SW2: Et0/0=trunk→SW1, Et0/1=trunk→SW3
//   SW3: Et0/0=trunk→SW1, Et0/1=trunk→SW2, Et0/2=PC2
var Lab25Topology = TopologyTemplate{
	ComputeID: "local",
	Nodes: []NodeTemplate{
		{
			Name:     "SW1",
			NodeType: "iou",
			Properties: map[string]any{
				"path": "i86bi-linux-l2-adventerprisek9-15.1a.bin",
			},
		},
		{
			Name:     "SW2",
			NodeType: "iou",
			Properties: map[string]any{
				"path": "i86bi-linux-l2-adventerprisek9-15.1a.bin",
			},
		},
		{
			Name:     "SW3",
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
		{NodeA: "SW1", IfaceA: "Et0/0", NodeB: "SW2", IfaceB: "Et0/0"},
		{NodeA: "SW1", IfaceA: "Et0/1", NodeB: "SW3", IfaceB: "Et0/0"},
		{NodeA: "SW2", IfaceA: "Et0/1", NodeB: "SW3", IfaceB: "Et0/1"},
		{NodeA: "KALI", IfaceA: "eth0", NodeB: "SW1", IfaceB: "Et0/2"},
		{NodeA: "PC1", IfaceA: "eth0", NodeB: "SW1", IfaceB: "Et0/3"},
		{NodeA: "PC2", IfaceA: "eth0", NodeB: "SW3", IfaceB: "Et0/2"},
	},
}
