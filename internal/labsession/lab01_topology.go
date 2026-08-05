package labsession

// Lab 01 — VLAN Warfare / DTP Hijack
// L2 IOU image (i86bi-linux-l2-upk9-12.2) — must remain L2:
// the L3 IOU image (i86bi-linux-l3-jk9s-15.0.1) boots as a ROUTER (no
// switchport/VLAN support) and would break the lab. The 12.2 image supports
// DTP negotiation (verified: yersinia DTP attack → Operational Mode: trunk),
// unlike the newer 15.1a images which do not process DTP from yersinia.
// Port allocation:
//   SW1: Et0/0=R1, Et0/1=PC1, Et0/2=trunk→SW2, Et0/3=KALI
//   SW2: Et0/1=trunk→SW1, Et0/2=SRV1
var Lab01Topology = TopologyTemplate{
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
			},
		},
		{
			Name:       "SW1",
			NodeType:   "iou",
			TemplateID: "26f0cc8d-debb-4897-b042-cd55978710cd", // i86bi-linux-l2-upk9-12.2 (switch, DTP-capable)
			Properties: map[string]any{
				"path": "i86bi-linux-l2-upk9-12.2.bin",
			},
			StartupConfig: lab01SW1Startup,
		},
		{
			Name:       "SW2",
			NodeType:   "iou",
			TemplateID: "26f0cc8d-debb-4897-b042-cd55978710cd", // i86bi-linux-l2-upk9-12.2 (switch, DTP-capable)
			Properties: map[string]any{
				"path": "i86bi-linux-l2-upk9-12.2.bin",
			},
			StartupConfig: lab01SW2Startup,
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
		{
			Name:     "SRV1",
			NodeType: "vpcs",
		},
	},
	Links: []LinkTemplate{
		{NodeA: "R1", IfaceA: "Fa0/0", NodeB: "SW1", IfaceB: "Et0/0"},
		{NodeA: "PC1", IfaceA: "eth0", NodeB: "SW1", IfaceB: "Et0/1"},
		{NodeA: "SW1", IfaceA: "Et0/2", NodeB: "SW2", IfaceB: "Et0/1"},
		{NodeA: "KALI", IfaceA: "eth0", NodeB: "SW1", IfaceB: "Et0/3"},
		{NodeA: "SRV1", IfaceA: "eth0", NodeB: "SW2", IfaceB: "Et0/2"},
	},
}

// Startup configs for Lab 01 IOU switches — hostname so the student sees
// SW1#/SW2# prompts (not the 12.2 default Router#). NOTE: the 12.2 image
// ignores interface blocks (no shutdown) in startup config content — ports
// boot administratively down; the lab build phase configures them anyway.
const lab01SW1Startup = `hostname SW1
!
end`

const lab01SW2Startup = `hostname SW2
!
end`
