package labsession

// Lab 31 — NTP (Network Time Protocol)
// Text: "R1 NTP server, R2 NTP client, Kali observes NTP traffic"
// R1: Fa0/0→SW1, Fa0/1→R2
// R2: Fa0/0→R1
// SW1: Et0/0=R1, Et0/1=KALI, Et0/2=PC1
var Lab31Topology = TopologyTemplate{
	ComputeID: "local",
	Nodes: []NodeTemplate{
		{Name:"R1",NodeType:"dynamips",Properties:map[string]any{"platform":"c3725","image":"/home/kobayashi/GNS3/images/IOS/c3725-adventerprisek9-mz.124-15.T14.image","ram":256,"slot0":"GT96100-FE"}},
		{Name:"R2",NodeType:"dynamips",Properties:map[string]any{"platform":"c3725","image":"/home/kobayashi/GNS3/images/IOS/c3725-adventerprisek9-mz.124-15.T14.image","ram":256,"slot0":"GT96100-FE"}},
		{Name:"SW1",NodeType:"iou",Properties:map[string]any{"path":"i86bi-linux-l2-adventerprisek9-15.1a.bin"}},
		{Name:"PC1",NodeType:"vpcs"},
		{Name:"KALI",NodeType:"qemu",TemplateID:"6f7a251b-65ec-4de2-9fb7-7bf9b63dd473",Properties:map[string]any{"qemu_path":"/usr/bin/qemu-system-x86_64","ram":1024,"adapters":2,"adapter_type":"e1000","console_type":"telnet","kernel_command_line":"console=ttyS0","hda_disk_image":"kali-linux-2026.1.qcow2","linked_clone":true,"boot_priority":"c","console_auto_start":false}},
	},
	Links: []LinkTemplate{
		{NodeA:"R1",IfaceA:"Fa0/0",NodeB:"SW1",IfaceB:"Et0/0"},
		{NodeA:"R1",IfaceA:"Fa0/1",NodeB:"R2",IfaceB:"Fa0/0"},
		{NodeA:"KALI",IfaceA:"eth0",NodeB:"SW1",IfaceB:"Et0/1"},
		{NodeA:"PC1",IfaceA:"eth0",NodeB:"SW1",IfaceB:"Et0/2"},
	},
}
