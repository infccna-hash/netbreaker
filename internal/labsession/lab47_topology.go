package labsession

// Lab 47 — Firewall Fortress (FortiGate segmentation)
// Topology: KALI (attacker, outside) → R1 (c2691 edge router) → FW (FortiGate)
// → R2 (c7200-15.2 internal router, inter-VLAN) → SW1 (IOU 15.1g L2 switch)
// → PC1 (VLAN 10) / PC2 (VLAN 20).
//
// Port mapping:
//
//	R1 (c2691):    Fa0/0 = KALI, Fa0/1 = FW (port1/outside)
//	FW (FortiGate): Ethernet0 = R1, Ethernet1 = R2
//	R2 (c7200):    Fa0/0 = FW, Fa0/1 = SW1 (trunk, subinterfaces)
//	SW1 (IOU):     Et0/0 = R2, Et0/1 = PC1, Et0/2 = PC2
//	PC1: eth0 = SW1 Et0/1 — VLAN 10 (10.0.10.10/24)
//	PC2: eth0 = SW1 Et0/2 — VLAN 20 (10.0.20.20/24)
//	KALI: eth0 = R1 Fa0/0 — 203.0.113.100/24
var Lab47Topology = TopologyTemplate{
	ComputeID: "local",
	Nodes: []NodeTemplate{
		{
			Name:     "R1",
			NodeType: "dynamips",
			Properties: map[string]any{
				"platform": "c2691",
				"image":    "/home/kobayashi/GNS3/images/IOS/c2691-entservicesk9-mz.124-13b_2.bin",
				"ram":      256,
				"slot0":    "GT96100-FE",
			},
		},
		{
			Name:       "FW",
			NodeType:   "qemu",
			TemplateID: "b5de120f-0889-4945-bd05-942a3aae6455",
			Properties: map[string]any{
				"hda_disk_image":     "fortios.qcow2",
				"hda_disk_interface": "ide",
				"ram":                2048,
				"cpus":               1,
				"qemu_path":          "/usr/bin/qemu-system-x86_64",
				"adapter_type":       "e1000",
				"adapters":           4,
				"console_type":       "vnc",
			},
		},
		{
			Name:     "R2",
			NodeType: "dynamips",
			Properties: map[string]any{
				"platform": "c7200",
				"image":    "/home/kobayashi/GNS3/images/IOS/c7200-advipservicesk9-mz.152-4.S5.bin",
				"ram":      512,
				"npe":      "npe-400",
				"midplane": "vxr",
				"slot0":    "C7200-IO-FE",
				"slot1":    "PA-FE-TX",
				"slot2":    "PA-2FE-TX",
			},
		},
		{
			Name:     "SW1",
			NodeType: "iou",
			Properties: map[string]any{
				"path":              "i86bi-linux-l2-ipbasek9-15.1g.bin",
				"ethernet_adapters": 4,
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
		{NodeA: "KALI", IfaceA: "eth0", NodeB: "R1", IfaceB: "Fa0/0"},
		{NodeA: "R1", IfaceA: "Fa0/1", NodeB: "FW", IfaceB: "Ethernet0"},
		{NodeA: "FW", IfaceA: "Ethernet1", NodeB: "R2", IfaceB: "Fa0/0"},
		{NodeA: "R2", IfaceA: "Fa1/0", NodeB: "SW1", IfaceB: "Et0/0"},
		{NodeA: "PC1", IfaceA: "eth0", NodeB: "SW1", IfaceB: "Et0/1"},
		{NodeA: "PC2", IfaceA: "eth0", NodeB: "SW1", IfaceB: "Et0/2"},
	},
}
