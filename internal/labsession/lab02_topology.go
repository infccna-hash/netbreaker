package labsession

// Lab02Topology is the concrete topology template for Lab 02 "STP Sabotage".
//
// Topology (verified against live build-phase content, 2026-07-29 — see
// fix note below):
//
//   SW1 (root) ──Et0/0── SW2 (secondary) ──Et0/3── PC1
//     │                                              │
//   Et0/2          Et0/2 (BLK)                      Et0/1
//     │                                              │
//   SW3 ──Et0/2── KALI (attacker)                     │
//
// Port notes:
//   - SW3 Et0/2 is labeled "Fa0/2 → BPDU Guard ⚠" in the SVG — that's the
//     access port Kali connects through, where BPDU Guard gets configured
//     during the harden phase.
//   - SW2 Et0/2 ↔ SW3 Et0/3 is the loop-prevention link STP blocks.
//   - PC1 connects to SW1 Et0/1 — confirmed against live build-phase
//     content ("PC1→SW1 Et0/1"), not a guess. The old comment here
//     speculated PC1 might belong on SW2 based on the SVG; that was
//     never actually applied to the Links list below, which still had
//     PC1 on SW1 Et0/1 the whole time.
//
// FIX (2026-07-29): SW1's Et0/1 was double-booked — both the SW1↔SW2
// trunk AND PC1 were wired to the same port. This isn't a documentation
// mismatch, it's a topology bug that would fail at GNS3 provisioning
// (a real interface can't carry two links). Confirmed neither the
// build, attack, nor harden phase content names a specific port number
// for the SW1↔SW2 trunk (only PC1's Et0/1 and KALI's Et0/2 are named),
// so the trunk was moved to Et0/0 — content-safe, since nothing
// instructs a student to type a port number that would now be wrong.
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
		// Triangle inter-switch links.
		{NodeA: "SW1", IfaceA: "Et0/0", NodeB: "SW2", IfaceB: "Et0/1"},
		{NodeA: "SW1", IfaceA: "Et0/2", NodeB: "SW3", IfaceB: "Et0/1"},
		// The link STP blocks for loop prevention (SW2 Et0/2 → SW3 Et0/3)
		{NodeA: "SW2", IfaceA: "Et0/2", NodeB: "SW3", IfaceB: "Et0/3"},
		// Host connections — port numbers here are load-bearing (named
		// explicitly in build-phase content), do not move these two.
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
