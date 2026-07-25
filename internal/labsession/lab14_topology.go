package labsession

// Lab 14 — IPv6 RA Guard / Router Advertisement Spoofing
// Topology: R1 (IPv6 gw), SW1 (RA Guard), PC1, PC2, KALI
// All on 2001:db8:1::/64 — shared segment through SW1.
// R1 sends RAs every 200s; SW1 drops rogue RAs on untrusted port (SW1 Gi0/3 = KALI).
//
// Port mapping (IOU 4-port limit):
//   SW1: Et0/0=R1 (trusted RA), Et0/1=PC1, Et0/2=PC2, Et0/3=KALI (untrusted RA)
var Lab14Topology = TopologyTemplate{
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
		{NodeA: "PC2", IfaceA: "eth0", NodeB: "SW1", IfaceB: "Et0/2"},
		{NodeA: "KALI", IfaceA: "eth0", NodeB: "SW1", IfaceB: "Et0/3"},
	},
}
