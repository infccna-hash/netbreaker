package labsession

// Lab 06 — ACL Bypass
// Topology: R1 (c3725) with Gi0/0(10.0.0.1/24)→SW1 and Gi0/1(192.168.2.1/24)→PC2
// Text: "Gi0/0: 10.0.0.1/24 · Gi0/1: 192.168.2.1/24" — c3725 = Fa0/0, Fa0/1
// SW1 needed on R1 Fa0/0 side: GNS3 can't share one port across PC1+KALI directly.
// Port mapping (IOU 4-port limit):
//   SW1: Et0/0=R1 Fa0/0, Et0/1=PC1, Et0/2=KALI, Et0/3=unused
//   R1 Fa0/1 → PC2 (direct, no switch needed)
// NOTE: Lab text says Gi0/0/Gi0/1 — c3725 has Fa only. TEXT FIX PENDING:
//   build/attack/harden phases reference Gi0/0 → should be Fa0/0 for c3725.
var Lab06Topology = TopologyTemplate{
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
		{NodeA: "R1", IfaceA: "Fa0/1", NodeB: "PC2", IfaceB: "eth0"},
	},
}
