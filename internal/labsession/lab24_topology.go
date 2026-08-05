package labsession

// Lab 24 — DTP/VTP (Dynamic Trunking Protocol / VTP Domain Attacks)
// Text: "SW1↔SW2 trunks, DTP negotiation, VTP domain propagation"
// Uses upk9-12.2 image: supports yersinia DTP spoofing (verified trunk),
// unlike 15.1a which does not process DTP from yersinia.
// IOU 4-port limit:
//   SW1: Et0/0=trunk→SW2, Et0/1=KALI, Et0/2=PC1
//   SW2: Et0/0=trunk→SW1
var Lab24Topology = TopologyTemplate{
	ComputeID: "local",
	Nodes: []NodeTemplate{
		{
			Name:       "SW1",
			NodeType:   "iou",
			TemplateID: "26f0cc8d-debb-4897-b042-cd55978710cd", // i86bi-linux-l2-upk9-12.2 (switch, DTP-capable)
			Properties: map[string]any{
				"path": "i86bi-linux-l2-upk9-12.2.bin",
			},
			StartupConfig: lab24SW1Startup,
		},
		{
			Name:       "SW2",
			NodeType:   "iou",
			TemplateID: "26f0cc8d-debb-4897-b042-cd55978710cd", // i86bi-linux-l2-upk9-12.2 (switch, DTP-capable)
			Properties: map[string]any{
				"path": "i86bi-linux-l2-upk9-12.2.bin",
			},
			StartupConfig: lab24SW2Startup,
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
		{NodeA: "SW1", IfaceA: "Et0/0", NodeB: "SW2", IfaceB: "Et0/0"},
		{NodeA: "KALI", IfaceA: "eth0", NodeB: "SW1", IfaceB: "Et0/1"},
		{NodeA: "PC1", IfaceA: "eth0", NodeB: "SW1", IfaceB: "Et0/2"},
	},
}

// Startup configs for Lab 24 — hostnames so students see SW1#/SW2#
// (not the 12.2 default Router#). NOTE: 12.2 ignores interface blocks
// (no shutdown) in startup config content — ports boot down; the lab
// build phase configures them.
const lab24SW1Startup = `hostname SW1
!
end`

const lab24SW2Startup = `hostname SW2
!
end`
