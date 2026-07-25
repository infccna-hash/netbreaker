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
			Properties: map[string]any{"adapters": 2},
},
		{
			Name:     "SW2",
			NodeType: "iou",
			Properties: map[string]any{"adapters": 2},
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
		{NodeA: "SW1", IfaceA: "Et0/1", NodeB: "SW2", IfaceB: "Et0/1"},
		{NodeA: "KALI", IfaceA: "eth0", NodeB: "SW1", IfaceB: "Et0/2"},
		{NodeA: "PC1", IfaceA: "eth0", NodeB: "SW1", IfaceB: "Et0/3"},
	},
}
