package labsession

// Lab 12 — 802.1X / Port Authentication
// Topology: R1 (RADIUS server), SW1 (authenticator), PC1, PC2, KALI
// All devices share the same VLAN/segment through SW1.
// R1 AAA server at 192.168.1.1/24 does not route — management IP only.
//
// Port mapping (IOU 4-port limit):
//   SW1: Et0/0=R1, Et0/1=PC1, Et0/2=KALI, Et0/3=PC2
// NOTE: Lab text references Gi0/0 on R1 — TEXT FIX PENDING (→ Fa0/0).
var Lab12Topology = TopologyTemplate{
	ComputeID: "local",
	Nodes: []NodeTemplate{
		{
			Name:     "R1",
			NodeType: "dynamips",
			Properties: map[string]any{
				"platform": "c3725",
				"image":    "/home/kobayashi/GNS3/images/IOS/c3725-adventerprisek9-mz.124-15.T14.image",
				"ram":      256,
				"slot0":    "GT96100-FE",
			},
		},
		{
			Name:     "SW1",
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
		{NodeA: "R1", IfaceA: "Fa0/0", NodeB: "SW1", IfaceB: "Et0/0"},
		{NodeA: "PC1", IfaceA: "eth0", NodeB: "SW1", IfaceB: "Et0/1"},
		{NodeA: "KALI", IfaceA: "eth0", NodeB: "SW1", IfaceB: "Et0/2"},
		{NodeA: "PC2", IfaceA: "eth0", NodeB: "SW1", IfaceB: "Et0/3"},
	},
}
