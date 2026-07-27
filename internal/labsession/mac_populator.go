package labsession

import (
	"context"
	"fmt"
	"regexp"
)

// macResolveStrategy resolves the MAC address for a single GNS3 node.
// The context is for cancellation; the GNS3 node properties come from
// the GNS3 REST API (GET /v2/projects/{id}/nodes/{node_id}).
//
// A strategy MUST return ("", nil) when the node type doesn't need a
// MAC (e.g. switches, routers). It returns an error only for genuine
// failures (API down, console timeout, etc.).
type macResolveStrategy func(ctx context.Context, node gns3NodeProperties) (string, error)

// gns3NodeProperties is a subset of the GNS3 node object that the
// MAC strategies need. Callers populate it from the GNS3 API.
type gns3NodeProperties struct {
	NodeType string
	// mac_address is present on docker and qemu nodes.
	MACAddress string `json:"mac_address"`
	// mac_addr is present on dynamips (router) nodes — the router's
	// own interface MAC, NOT a host MAC. Not used for host resolution.
	MACAddr string `json:"mac_addr"`
}

// macResolvers maps GNS3 node_type → MAC resolution strategy.
// Unknown node types get macNotSupportedError.
var macResolvers = map[string]macResolveStrategy{
	"docker":  resolveFromAPI,
	"qemu":    resolveFromAPI,
	"vpcs":    resolveVPCS, // console-dependent, implemented when VPCS console bridge is ready
	"iou":     resolveNoMAC, // switches — their own MACs aren't relevant to host checks
	"dynamips": resolveNoMAC, // routers — same
	"ethernet_hub": resolveNoMAC,
	"ethernet_switch": resolveNoMAC,
}

// ErrMACNotSupported is returned when a node type has no registered
// MAC resolution strategy and is not in the "no MAC needed" set.
type ErrMACNotSupported struct{ NodeType string }

func (e ErrMACNotSupported) Error() string {
	return fmt.Sprintf("MAC resolution not supported for node type %q", e.NodeType)
}

// resolveFromAPI reads mac_address directly from the GNS3 node
// properties. Docker and QEMU nodes include this field.
func resolveFromAPI(_ context.Context, n gns3NodeProperties) (string, error) {
	if n.MACAddress != "" {
		return n.MACAddress, nil
	}
	return "", fmt.Errorf("mac_address not found in GNS3 node properties for %s node", n.NodeType)
}

// resolveVPCS resolves the MAC for a VPCS node by connecting to its
// console and running the "show" command.
//
// BLOCKED: requires a VPCS console bridge. The ConsoleRunner today
// only handles IOS-like prompts (Router#/Switch#). VPCS uses "PC1> "
// — a different prompt format. This strategy will be implemented when
// the ConsoleRunner gains VPCS support or a dedicated VPCS client is
// added.
func resolveVPCS(ctx context.Context, n gns3NodeProperties) (string, error) {
	return "", fmt.Errorf("VPCS MAC resolution not yet implemented — requires VPCS console client")
}

// resolveNoMAC returns ("", nil) for node types that don't represent
// hosts whose MAC matters for verification (switches, routers, hubs).
func resolveNoMAC(_ context.Context, _ gns3NodeProperties) (string, error) {
	return "", nil
}

// ResolveMAC dispatches to the appropriate strategy for the given
// node type. Returns ("", nil) for node types that don't need MACs.
// Returns an error for unsupported types or resolution failures.
func ResolveMAC(ctx context.Context, node gns3NodeProperties) (string, error) {
	strategy, ok := macResolvers[node.NodeType]
	if !ok {
		return "", ErrMACNotSupported{NodeType: node.NodeType}
	}
	return strategy(ctx, node)
}

// VPCS show output contains a line like:
//   MAC: 00:50:79:66:68:00
var vpcsMACRe = regexp.MustCompile(`(?i)MAC\s*:\s*([0-9a-f]{2}:[0-9a-f]{2}:[0-9a-f]{2}:[0-9a-f]{2}:[0-9a-f]{2}:[0-9a-f]{2})`)
