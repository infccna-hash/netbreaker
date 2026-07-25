package labsession

// Lab 21 — Static Routing / Route Hijack (3-router triangle)
// R1, R2, R3 = c3725 with GT96100-FE (WAN) + NM-16ESW (LAN)
// Triangle topology:
//   R1 Fa0/0 (10.0.0.1/30) ↔ R2 Fa0/0 (10.0.0.2/30)
//   R2 Fa0/1 (10.0.0.5/30) ↔ R3 Fa0/0 (10.0.0.6/30)
//   R3 Fa0/1 (10.0.0.10/30) ↔ R1 Fa0/1 (10.0.0.9/30)
// LAN via NM-16ESW (Gi1/1 = first switchport):
//   R1: 192.168.1.1/24 → PC1 (Gi1/1), KALI (Gi1/2)
//   R2: 192.168.2.1/24 → PC2 (Gi1/1)
//   R3: 192.168.3.1/24 → PC3 (Gi1/1)
// NOTE: Gi1/N maps to adapter=1, port=N-1 via interfaceToPort.
// NOTE: Text says Gi0/0 for WAN — TEXT FIX PENDING (→ Fa0/0 on c3725).
var Lab21Topology = TopologyTemplate{
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
				"slot1":    "NM-16ESW",
			},
		},
		{
			Name:     "R2",
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
			Name:     "R3",
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
			NodeType:   "qemu",
			TemplateID: "6f7a251b-65ec-4de2-9fb7-7bf9b63dd473",
			Properties: map[string]any{
				"qemu_path":           "/usr/bin/qemu-system-x86_64",
				"ram":                 1024,
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
		// WAN triangle
		{NodeA: "R1", IfaceA: "Fa0/0", NodeB: "R2", IfaceB: "Fa0/0"},
		{NodeA: "R2", IfaceA: "Fa0/1", NodeB: "R3", IfaceB: "Fa0/0"},
		{NodeA: "R3", IfaceA: "Fa0/1", NodeB: "R1", IfaceB: "Fa0/1"},
		// LAN segments via NM-16ESW
		{NodeA: "R1", IfaceA: "Gi1/1", NodeB: "PC1", IfaceB: "eth0"},
		{NodeA: "R1", IfaceA: "Gi1/2", NodeB: "KALI", IfaceB: "eth0"},
		{NodeA: "R2", IfaceA: "Gi1/1", NodeB: "PC2", IfaceB: "eth0"},
		{NodeA: "R3", IfaceA: "Gi1/1", NodeB: "PC3", IfaceB: "eth0"},
	},
}
