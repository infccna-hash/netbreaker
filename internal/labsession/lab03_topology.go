package labsession

// Lab 03 — MAC Flood Chaos
// Topology: SW1 (IOU L2) + PC1/PC2 (VPCS) + KALI (QEMU) — simple star.
// Text: "Cable it: PC1→Gi0/1, PC2→Gi0/2, KALI→Gi0/3"
var Lab03Topology = TopologyTemplate{
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
			Name:     "PC1",
			NodeType: "vpcs",
		},
		{
			Name:     "PC2",
			NodeType: "vpcs",
		},
		{
			Name:       "KALI",
			NodeType:   "qemu",
			TemplateID: "6f7a251b-65ec-4de2-9fb7-7bf9b63dd473",
			Properties: map[string]any{
				"qemu_path":           "/usr/bin/qemu-system-x86_64",
				"ram": 1024,
				"adapters":            2,
				"adapter_type":        "e1000",
				"console_type":        "telnet",
				"kernel_command_line": "console=ttyS0",
				"hda_disk_image":      "kali-linux-2026.1.qcow2",
				"linked_clone":        true,
				"boot_priority":       "c",
				"console_auto_start":  false,
			},
		},
	},
	Links: []LinkTemplate{
		{NodeA: "PC1", IfaceA: "eth0", NodeB: "SW1", IfaceB: "Et0/1"},
		{NodeA: "PC2", IfaceA: "eth0", NodeB: "SW1", IfaceB: "Et0/2"},
		{NodeA: "KALI", IfaceA: "eth0", NodeB: "SW1", IfaceB: "Et0/3"},
	},
}
