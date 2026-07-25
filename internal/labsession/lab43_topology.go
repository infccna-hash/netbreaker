package labsession
var Lab43Topology = TopologyTemplate{
	ComputeID: "local",
	Nodes: []NodeTemplate{
		{Name:"R1",NodeType:"dynamips",Properties: map[string]any{"adapters": 2},
},
		{Name:"SW1",NodeType:"iou",Properties: map[string]any{"adapters": 2},
},
		{Name:"KALI",NodeType:"docker",TemplateID:"efcdd6aa-8a18-4028-ae77-331d9e6d921b",Properties: map[string]any{"adapters": 2},
},
	},
	Links: []LinkTemplate{
		{NodeA:"R1",IfaceA:"Fa0/0",NodeB:"SW1",IfaceB:"Et0/0"},
		{NodeA:"KALI",IfaceA:"eth0",NodeB:"SW1",IfaceB:"Et0/1"},
	},
}
