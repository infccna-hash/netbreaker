package labsession

// Lab 32 — SNMP (Simple Network Management Protocol)
// Text: "R1 SNMP agent, Kali performs SNMP walk, PC monitoring station"
// R1: Fa0/0→SW1
// SW1: Et0/0=R1, Et0/1=KALI, Et0/2=PC1
var Lab32Topology = TopologyTemplate{
	ComputeID: "local",
	Nodes: []NodeTemplate{
		{Name:"R1",NodeType:"dynamips",Properties: map[string]any{"adapters": 2},
},
		{Name:"SW1",NodeType:"iou",Properties: map[string]any{"adapters": 2},
},
		{Name:"PC1",NodeType:"vpcs"},
		{Name:"KALI",NodeType:"docker",TemplateID:"efcdd6aa-8a18-4028-ae77-331d9e6d921b",Properties: map[string]any{"adapters": 2},
},
	},
	Links: []LinkTemplate{
		{NodeA:"R1",IfaceA:"Fa0/0",NodeB:"SW1",IfaceB:"Et0/0"},
		{NodeA:"KALI",IfaceA:"eth0",NodeB:"SW1",IfaceB:"Et0/1"},
		{NodeA:"PC1",IfaceA:"eth0",NodeB:"SW1",IfaceB:"Et0/2"},
	},
}
