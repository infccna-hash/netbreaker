package labsession

var Lab04Topology = TopologyTemplate{
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
			Name:     "R1",
			NodeType: "dynamips",
			Properties: map[string]any{
				"platform": "c3725",
				"image":    "/home/kobayashi/GNS3/images/IOS/c3725-adventerprisek9-mz.124-15.T14.image",
				"ram":      256,
				"slot0":    "GT96100-FE",
				"slot1":    "NM-16ESW",
				"slot2":    "NM-1FE-TX",
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
				"slot2":    "NM-1FE-TX",
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
				"slot2":    "NM-1FE-TX",
			},
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
		{NodeA: "R1", IfaceA: "Fa0/0", NodeB: "SW1", IfaceB: "Et0/0"},
		{NodeA: "R2", IfaceA: "Fa0/0", NodeB: "SW1", IfaceB: "Et0/1"},
		{NodeA: "R2", IfaceA: "Fa0/1", NodeB: "R3", IfaceB: "Fa0/0"},
		{NodeA: "R3", IfaceA: "Fa0/1", NodeB: "PC1", IfaceB: "eth0"},
		{NodeA: "KALI", IfaceA: "eth0", NodeB: "SW1", IfaceB: "Et0/2"},
	},
}
