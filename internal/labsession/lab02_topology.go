package labsession

// Lab02Topology is the concrete topology template for Lab 02 "STP Sabotage".
//
// Topology from SVG + build phase content:
//
//   SW1 (root) ──Fa0/1── SW2 (secondary) ──Fa0/3── PC1
//     │                                              │
//    Fa0/2          Fa0/2 (BLK)                      │
//     │                                              │
//   SW3 ──Fa0/2── KALI (attacker)                    │
//     │                                              │
//    Fa0/3────────────────────────────────────────────┘
//
// Port notes:
//   - SW3 Fa0/2 is labeled "Fa0/2 → BPDU Guard ⚠" in the SVG — that's the
//     access port Kali connects through, where BPDU Guard gets configured
//     during the harden phase.
//   - SW2 Fa0/2 ↔ SW3 Fa0/3 is the loop-prevention link STP blocks.
//   - PC1 connects to SW2 per the SVG layout (the build phase text says
//     "SW1" but the SVG geometry places PC1 under SW2 — using SVG as
//     source of truth, flagged for review).
var Lab02Topology = TopologyTemplate{
	LabID:     2,
	ComputeID: "local",
	Nodes: []NodeTemplate{
		{
			Name:     "SW1",
			NodeType: "iou",
			Properties: map[string]any{
				"path": "i86bi-linux-l2-adventerprisek9-15.1a.bin",
			},
			StartupConfig: sw1Startup,
		},
		{
			Name:     "SW2",
			NodeType: "iou",
			Properties: map[string]any{
				"path": "i86bi-linux-l2-adventerprisek9-15.1a.bin",
			},
			StartupConfig: sw2Startup,
		},
		{
			Name:     "SW3",
			NodeType: "iou",
			Properties: map[string]any{
				"path": "i86bi-linux-l2-adventerprisek9-15.1a.bin",
			},
			StartupConfig: sw3Startup,
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
				"qemu_path":             "/usr/bin/qemu-system-x86_64",
				"ram": 1024,
				"adapters":              2,
				"adapter_type":          "e1000",
				"console_type":          "telnet",
				"kernel_command_line":   "console=ttyS0",
				"hda_disk_image":        "kali-linux-2026.1.qcow2",
				"linked_clone":          true,
				"boot_priority":         "c",
				"console_auto_start":    false,
			},
		},
	},
	Links: []LinkTemplate{
		// Triangle inter-switch links — adapter 0 port 1 (Ethernet0/1)
		{NodeA: "SW1", IfaceA: "Et0/1", NodeB: "SW2", IfaceB: "Et0/1"},
		{NodeA: "SW1", IfaceA: "Et0/2", NodeB: "SW3", IfaceB: "Et0/1"},
		// The link STP blocks for loop prevention (SW2 Et0/2 → SW3 Et0/3)
		{NodeA: "SW2", IfaceA: "Et0/2", NodeB: "SW3", IfaceB: "Et0/3"},
		// Host connections
		{NodeA: "SW1", IfaceA: "Et0/1", NodeB: "PC1", IfaceB: "eth0"},
		{NodeA: "SW3", IfaceA: "Et0/2", NodeB: "KALI", IfaceB: "eth0"},
	},
}

// Startup configs for the three IOU switches.
// These are minimal — just hostname and VLAN 1 SVI for management reachability.
// Full lab-specific configs (trunking, STP priority, BPDU Guard, Root Guard)
// are applied by the student during the lab phases.

const sw1Startup = `hostname SW1
!
interface Vlan1
 ip address 192.168.1.11 255.255.255.0
 no shutdown
!
ip default-gateway 192.168.1.1
!
end`

const sw2Startup = `hostname SW2
!
interface Vlan1
 ip address 192.168.1.12 255.255.255.0
 no shutdown
!
ip default-gateway 192.168.1.1
!
end`

const sw3Startup = `hostname SW3
!
interface Vlan1
 ip address 192.168.1.13 255.255.255.0
 no shutdown
!
ip default-gateway 192.168.1.1
!
end`
