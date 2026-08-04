package labsession

// Lab02Topology is the concrete topology template for Lab 02 "STP Sabotage".
//
// Verified port mapping (console-truth, 2026-08-03):
//
//   SW1 (root) ──Et0/0── SW2 (secondary)
//     │  Et0/2                │  Et0/2 (BLK by STP)
//     │                       │
//   SW3 ──Et0/2── KALI        │
//     │                       │
//    Et0/3 ────────────────────┘
//   SW1 Et0/1 ── PC1
//
// Port notes:
//   - SW3 Et0/2 is the access port Kali connects through, where BPDU Guard
//     gets configured during the harden phase.
//   - SW2 Et0/2 ↔ SW3 Et0/3 is the loop-prevention link STP blocks.
//   - PC1 connects to SW1 Et0/1 (matches build phase text "PC1→SW1 Fa0/1").
//   - SW1↔SW2 trunk uses Et0/0 (moved from Et0/1 to resolve port conflict —
//     Et0/1 was double-booked for both SW2 trunk and PC1).
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
			NodeType:   "docker",
			TemplateID: "efcdd6aa-8a18-4028-ae77-331d9e6d921b",
			Properties: map[string]any{"adapters": 2},
		},
	},
	Links: []LinkTemplate{
		// Triangle inter-switch links
		{NodeA: "SW1", IfaceA: "Et0/0", NodeB: "SW2", IfaceB: "Et0/1"},   // Et0/0 — moved from Et0/1 to resolve conflict with PC1
		{NodeA: "SW1", IfaceA: "Et0/2", NodeB: "SW3", IfaceB: "Et0/1"},
		// The link STP blocks for loop prevention (SW2 Et0/2 → SW3 Et0/3)
		{NodeA: "SW2", IfaceA: "Et0/2", NodeB: "SW3", IfaceB: "Et0/3"},
		// Host connections
		{NodeA: "SW1", IfaceA: "Et0/1", NodeB: "PC1", IfaceB: "eth0"},     // matches build text "PC1→SW1 Fa0/1"
		{NodeA: "SW3", IfaceA: "Et0/2", NodeB: "KALI", IfaceB: "eth0"},    // matches build text "KALI→SW3 Fa0/2"
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
