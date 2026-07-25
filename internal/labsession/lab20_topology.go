package labsession

// Lab 20 — Interfaces & Autonegotiation
// Topology: SW1 (IOU) + PC1 (VPCS) + R1 (c3725) + KALI (QEMU)
// Text: "Gi0/1–3 (access), Gi0/24 (trunk)" — IOU L2 image has 4 ports (Et0/0–3)
// Port mapping (0-indexed to fit IOU's 4-port limit):
//   Et0/1 ← PC1 (access, VLAN 10)
//   Et0/2 ← KALI (access)
//   Et0/3 ← R1 Fa0/0 (trunk — "Gi0/24" in conceptual 24-port switch)
var Lab20Topology = TopologyTemplate{
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
			Name:     "R1",
			NodeType: "dynamips",
			Properties: map[string]any{
				"platform": "c3725",
				"image":    "/home/kobayashi/GNS3/images/IOS/c3725-adventerprisek9-mz.124-15.T14.image",
				"ram":      256,
				"slot0":    "GT96100-FE",
				"slot1":    "NM-16ESW",
			},
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
		{NodeA: "KALI", IfaceA: "eth0", NodeB: "SW1", IfaceB: "Et0/2"},
		{NodeA: "R1", IfaceA: "Fa0/0", NodeB: "SW1", IfaceB: "Et0/3"},
	},
}
