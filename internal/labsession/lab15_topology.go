package labsession

// Lab 15 — Network Devices & Anatomy (Vol 1 · Ch 2)
// Path A design: KALI2 permanently wired on the hub segment alongside PC1+PC2.
// Side-by-side comparison — no rewiring needed.
// 9 nodes: H1 (ethernet_hub), SW1 (IOU L2), R1 (c3725), FW1 (ASAv QEMU),
//          PC1/PC2/PC3 (VPCS), KALI (Docker, switch-side), KALI2 (Docker, hub-side)
var Lab15Topology = TopologyTemplate{
	ComputeID: "local",
	Nodes: []NodeTemplate{
		{
			Name:     "H1",
			NodeType: "ethernet_hub",
		},
		{
			Name:     "SW1",
			NodeType: "iou",
			Properties: map[string]any{
				"path": "i86bi-linux-l2-adventerprisek9-15.1a.bin",
			},
		},
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
			Name:       "FW1",
			NodeType:   "qemu",
			TemplateID: "bea8738c-f896-4bd8-9f28-fe4643ad0882",
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
			Properties: map[string]any{"adapters": 1},
		},
		{
			Name:       "KALI2",
			NodeType:   "docker",
			TemplateID: "efcdd6aa-8a18-4028-ae77-331d9e6d921b",
			Properties: map[string]any{"adapters": 1},
		},
	},
	Links: []LinkTemplate{
		{NodeA: "PC1", IfaceA: "eth0", NodeB: "H1", IfaceB: "e0"},
		{NodeA: "PC2", IfaceA: "eth0", NodeB: "H1", IfaceB: "e1"},
		{NodeA: "KALI2", IfaceA: "eth0", NodeB: "H1", IfaceB: "e3"},
		{NodeA: "H1", IfaceA: "e2", NodeB: "SW1", IfaceB: "Et0/0"},
		{NodeA: "PC3", IfaceA: "eth0", NodeB: "SW1", IfaceB: "Et0/1"},
		{NodeA: "KALI", IfaceA: "eth0", NodeB: "SW1", IfaceB: "Et0/2"},
		{NodeA: "SW1", IfaceA: "Et0/3", NodeB: "R1", IfaceB: "Fa0/0"},
		{NodeA: "R1", IfaceA: "Fa0/1", NodeB: "FW1", IfaceB: "Ethernet0"},
	},
}
