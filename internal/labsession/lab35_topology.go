package labsession

// Lab 35 — QoS (Quality of Service)
// Text: "3-router chain with traffic shaping, queuing, policing"
// R1↔R2↔R3 chain, PC generates traffic, Kali analyzes
// R1: Fa0/0→SW1, Fa0/1→R2
// R2: Fa0/0→R1, Fa0/1→R3
// R3: Fa0/0→R2, Fa0/1→PC2
// SW1: Et0/0=R1, Et0/1=PC1, Et0/2=KALI
var Lab35Topology = TopologyTemplate{
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
		{Name:"PC1",NodeType:"vpcs"},
		{Name:"PC2",NodeType:"vpcs"},
		{Name:"KALI",NodeType:"docker",TemplateID:"efcdd6aa-8a18-4028-ae77-331d9e6d921b",Properties: map[string]any{"adapters": 2},
},
	},
	Links: []LinkTemplate{
		{NodeA:"R1",IfaceA:"Fa0/0",NodeB:"SW1",IfaceB:"Et0/0"},
		{NodeA:"R1",IfaceA:"Fa0/1",NodeB:"R2",IfaceB:"Fa0/0"},
		{NodeA:"R2",IfaceA:"Fa0/1",NodeB:"R3",IfaceB:"Fa0/0"},
		{NodeA:"R3",IfaceA:"Fa0/1",NodeB:"PC2",IfaceB:"eth0"},
		{NodeA:"PC1",IfaceA:"eth0",NodeB:"SW1",IfaceB:"Et0/1"},
		{NodeA:"KALI",IfaceA:"eth0",NodeB:"SW1",IfaceB:"Et0/2"},
	},
}
