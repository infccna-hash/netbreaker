package labsession

// Lab 29 — TCP/UDP (Port Scanning / Service Discovery)
// Text: "TCP/UDP fundamentals, port scanning from Kali" — single-segment:
//
//	PC1 (client), PC2 (server), KALI (sniffer) all on SW1; R1 is the gateway.
//	R1: Fa0/0→SW1
//	SW1: Et0/0=R1, Et0/1=PC1, Et0/2=KALI, Et0/3=PC2
//
// 2026-08-05 surgery: R2 dropped — it was a 2-router remnant the text never
// references (unplayable as written: PC2 sat on an isolated R2 segment with
// no routing configured anywhere). PC2 moved to SW1.Et0/3 so the web-server
// scenario (wget 192.168.1.200 from PC1) works on one segment.
var Lab29Topology = TopologyTemplate{
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
		{NodeA: "R1", IfaceA: "Fa0/0", NodeB: "SW1", IfaceB: "Et0/0"},
		{NodeA: "PC1", IfaceA: "eth0", NodeB: "SW1", IfaceB: "Et0/1"},
		{NodeA: "KALI", IfaceA: "eth0", NodeB: "SW1", IfaceB: "Et0/2"},
		{NodeA: "PC2", IfaceA: "eth0", NodeB: "SW1", IfaceB: "Et0/3"},
	},
}
