package labsession

// Lab 15 — Network Devices & Anatomy (Vol 1 · Ch 2)
// Single-Kali design: KALI on switch port Et0/2 as observer/sniffer.
// Hub segment (PC1+PC2→H1→SW1 Et0/0) vs switch segment (PC3→SW1 Et0/1, KALI→SW1 Et0/2)
// shows collision-domain boundaries without rewiring.
// 8 nodes: H1 (ethernet_hub), SW1 (IOU L2, 5 ports), R1 (IOU L3), FW1 (ASAv QEMU),
//          PC1/PC2/PC3 (VPCS), KALI (Docker)
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
				"path":              "i86bi-linux-l2-adventerprisek9-15.1a.bin",
				"ethernet_adapters": 5,
			},
		},
		{
			Name:     "R1",
			NodeType: "iou",
			Properties: map[string]any{
				"path":              "/home/kobayashi/GNS3/images/IOU/i86bi-linux-l3-jk9s-15.0.1.bin",
				"ethernet_adapters": 6,
				"ram":               256,
			},
		},
		{
			Name:       "FW1",
			NodeType:   "qemu",
			TemplateID: "bea8738c-f896-4bd8-9f28-fe4643ad0882",
			Properties: map[string]any{
				"hda_disk_image":     "asa-915-k8.qcow2",
				"hda_disk_interface": "ide",
				"ram":                2048,
				"qemu_path":          "/usr/bin/qemu-system-x86_64",
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
			Name:     "PC3",
			NodeType: "vpcs",
		},
		{
			Name:       "KALI",
			NodeType:   "docker",
			TemplateID: "efcdd6aa-8a18-4028-ae77-331d9e6d921b",
			Properties: map[string]any{"adapters": 1},
		},
	},
	Links: []LinkTemplate{
		{NodeA: "PC1", IfaceA: "eth0", NodeB: "H1", IfaceB: "e0"},
		{NodeA: "PC2", IfaceA: "eth0", NodeB: "H1", IfaceB: "e1"},
		{NodeA: "H1", IfaceA: "e2", NodeB: "SW1", IfaceB: "Et0/0"},
		{NodeA: "PC3", IfaceA: "eth0", NodeB: "SW1", IfaceB: "Et0/1"},
		{NodeA: "KALI", IfaceA: "eth0", NodeB: "SW1", IfaceB: "Et0/2"},
		{NodeA: "SW1", IfaceA: "Et0/3", NodeB: "R1", IfaceB: "Et0/0"},
		{NodeA: "R1", IfaceA: "Et0/1", NodeB: "FW1", IfaceB: "Ethernet0"},
	},
}
