package labsession

// Lab 26 — EtherChannel (Port-Channel / Link Aggregation)
// Text: "2 links between SW1↔SW2 bundled into one logical port-channel"
// IOU 4-port limit:
//   SW1: Et0/0=etherchannel→SW2, Et0/1=etherchannel→SW2, Et0/2=KALI, Et0/3=PC1
//   SW2: Et0/0=etherchannel→SW1, Et0/1=etherchannel→SW1
var Lab26Topology = TopologyTemplate{
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
			Name:     "PC1",
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
		{NodeA: "SW1", IfaceA: "Et0/0", NodeB: "SW2", IfaceB: "Et0/0"},
		{NodeA: "SW1", IfaceA: "Et0/1", NodeB: "SW2", IfaceB: "Et0/1"},
		{NodeA: "KALI", IfaceA: "eth0", NodeB: "SW1", IfaceB: "Et0/2"},
		{NodeA: "PC1", IfaceA: "eth0", NodeB: "SW1", IfaceB: "Et0/3"},
	},
}
