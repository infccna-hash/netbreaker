package labsession

// Lab 36 — Port Security (MAC flooding / sticky MAC)
// Text: "Switch port-security on SW1, Kali MAC flood, PC1 legitimate"
// SW1: Et0/0=PC1, Et0/1=KALI
var Lab36Topology = TopologyTemplate{
	ComputeID: "local",
	Nodes: []NodeTemplate{
		{Name:"SW1",NodeType:"iou",Properties:map[string]any{"path":"i86bi-linux-l2-adventerprisek9-15.1a.bin"}},
		{Name:"PC1",NodeType:"vpcs"},
		{Name:"PC2",NodeType:"vpcs"},
		{Name:"KALI",NodeType:"docker",TemplateID:"efcdd6aa-8a18-4028-ae77-331d9e6d921b",Properties: map[string]any{"adapters": 2}},
	},
	Links: []LinkTemplate{
		{NodeA:"PC1",IfaceA:"eth0",NodeB:"SW1",IfaceB:"Et0/0"},
		{NodeA:"PC2",IfaceA:"eth0",NodeB:"SW1",IfaceB:"Et0/2"},
		{NodeA:"KALI",IfaceA:"eth0",NodeB:"SW1",IfaceB:"Et0/1"},
	},
}
