package labsession
var Lab39Topology = TopologyTemplate{
	ComputeID: "local",
	Nodes: []NodeTemplate{
		{Name:"R1",NodeType:"dynamips",Properties: map[string]any{"adapters": 2},
},
		{Name:"R2",NodeType:"dynamips",Properties: map[string]any{"adapters": 2},
},
		{Name:"R3",NodeType:"dynamips",Properties: map[string]any{"adapters": 2},
},
		{Name:"SW1",NodeType:"iou",Properties: map[string]any{"adapters": 2},
},
		{Name:"SW2",NodeType:"iou",Properties: map[string]any{"adapters": 2},
},
		{Name:"PC1",NodeType:"vpcs"},{Name:"PC2",NodeType:"vpcs"},{Name:"PC3",NodeType:"vpcs"},
		{Name:"KALI",NodeType:"docker",TemplateID:"efcdd6aa-8a18-4028-ae77-331d9e6d921b",Properties: map[string]any{"adapters": 2},
},
	},
	Links: []LinkTemplate{
		{NodeA:"R1",IfaceA:"Fa0/0",NodeB:"SW1",IfaceB:"Et0/0"},
		{NodeA:"R1",IfaceA:"Fa0/1",NodeB:"R2",IfaceB:"Fa0/0"},
		{NodeA:"R2",IfaceA:"Fa0/1",NodeB:"R3",IfaceB:"Fa0/0"},
		{NodeA:"R3",IfaceA:"Fa0/1",NodeB:"SW2",IfaceB:"Et0/0"},
		{NodeA:"PC1",IfaceA:"eth0",NodeB:"SW1",IfaceB:"Et0/1"},
		{NodeA:"PC2",IfaceA:"eth0",NodeB:"SW1",IfaceB:"Et0/2"},
		{NodeA:"PC3",IfaceA:"eth0",NodeB:"SW2",IfaceB:"Et0/1"},
		{NodeA:"KALI",IfaceA:"eth0",NodeB:"SW1",IfaceB:"Et0/3"},
	},
}
