package labsession

import "context"

// GNS3Client is the contract the real orchestration client will satisfy.
// Defined here first so Service can be written and tested against a fake
// before gns3client.go has a single line of HTTP/telnet code in it.
type GNS3Client interface {
	CreateProject(ctx context.Context, computeID string, userID, labID int) (projectID string, err error)
	ProvisionTopology(ctx context.Context, projectID string, template TopologyTemplate) (NodeMap, error)
	StartNodes(ctx context.Context, projectID string) error
	StopNodes(ctx context.Context, projectID string) error
	DeleteProject(ctx context.Context, projectID string) error

	// Read-only teardown-verification probes. Both fail closed: any transport
	// or unexpected-status error must surface, never be read as "gone/stopped".
	ProjectExists(ctx context.Context, projectID string) (bool, error)
	NodesStopped(ctx context.Context, projectID string) (bool, error)
}

// TopologyTemplate describes the full network topology for a single lab —
// nodes (their IOS startup configs) and links (which port on which node
// connects to which). Created at template-authoring time when only node
// names and interface labels are known; the GNS3 client translates names
// → actual GNS3 node IDs and interface labels → adapter/port numbers.
type TopologyTemplate struct {
	LabID     int
	ComputeID string // which GNS3 compute node this topology's nodes run on
	Nodes     []NodeTemplate
	Links     []LinkTemplate
}

// NodeTemplate describes a single GNS3 device in a topology.
type NodeTemplate struct {
	Name          string
	NodeType      string // "iou", "dynamips", "qemu"
	TemplateID    string // GNS3 template UUID (required for dynamips/qemu nodes)
	StartupConfig string
	Properties    map[string]any // additional GNS3 properties (image path, platform, etc.)
}

// LinkTemplate connects one interface on one node to one interface on
// another, using the same interface names the lab content already uses
// (e.g. "Fa0/1", "Et0/2"), not raw GNS3 adapter/port integers.
// A small per-node-type parser (interfaceToPort) does that translation.
type LinkTemplate struct {
	NodeA  string // node name (must match a NodeTemplate.Name)
	IfaceA string // e.g. "Fa0/1", "Et0/2"
	NodeB  string
	IfaceB string
}
