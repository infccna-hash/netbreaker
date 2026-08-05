package labsession

// Lab 20 — Interfaces & Autonegotiation
// Topology: SW1 (IOU) + PC1 (VPCS) + R1 (c3725) + KALI (QEMU)
// Text: "Gi0/1–3 (access), Gi0/24 (trunk)" — IOU L2 image has 4 ports (Et0/0–3)
// Uses upk9-12.2 image: supports yersinia DTP spoofing (verified trunk),
// unlike 15.1a which does not process DTP from yersinia.
// Port mapping (0-indexed to fit IOU's 4-port limit):
//   Et0/1 ← PC1 (access, VLAN 10)
//   Et0/2 ← KALI (access)
//   Et0/3 ← R1 Fa0/0 (trunk — "Gi0/24" in conceptual 24-port switch)
var Lab20Topology = TopologyTemplate{
	ComputeID: "local",
	Nodes: []NodeTemplate{
		{
			Name:       "SW1",
			NodeType:   "iou",
			TemplateID: "26f0cc8d-debb-4897-b042-cd55978710cd", // i86bi-linux-l2-upk9-12.2 (switch, DTP-capable)
			Properties: map[string]any{
				"path": "i86bi-linux-l2-upk9-12.2.bin",
			},
			StartupConfig: lab20SW1Startup,
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
			NodeType:   "docker",
			TemplateID: "efcdd6aa-8a18-4028-ae77-331d9e6d921b",
			Properties: map[string]any{"adapters": 2},
		},
	},
	Links: []LinkTemplate{
		{NodeA: "PC1", IfaceA: "eth0", NodeB: "SW1", IfaceB: "Et0/1"},
		{NodeA: "KALI", IfaceA: "eth0", NodeB: "SW1", IfaceB: "Et0/2"},
		{NodeA: "R1", IfaceA: "Fa0/0", NodeB: "SW1", IfaceB: "Et0/3"},
	},
}

// Startup config for Lab 20 — hostname so the student sees SW1#
// (not the 12.2 default Router#). NOTE: 12.2 ignores interface blocks
// (no shutdown) in startup config content — ports boot down; the lab
// build phase configures them.
const lab20SW1Startup = `hostname SW1
!
end`
