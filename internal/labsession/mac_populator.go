package labsession

import (
	"context"
	"fmt"
	"net"
	"regexp"
	"strings"
	"time"
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
	// Console is the telnet console port for this node (VPCS, IOU, etc.).
	Console int `json:"console"`
	// ConsoleHost is the telnet console host. May be "0.0.0.0" — callers
	// MUST normalize this to the actual compute host before passing it
	// to a strategy that dials the console.
	ConsoleHost string `json:"console_host"`
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
// console, sending the "show" command, and parsing the MAC from the
// output.
//
// VPCS is stateless and simple: connect, receive a banner and prompt
// ("PC1> "), send "show", receive a table (or verbose listing) with
// the MAC address, then disconnect. No pagination, no terminal
// negotiation, no login.
func resolveVPCS(ctx context.Context, n gns3NodeProperties) (string, error) {
	if n.Console == 0 {
		return "", fmt.Errorf("VPCS node has no console port allocated")
	}
	if n.ConsoleHost == "" {
		return "", fmt.Errorf("VPCS node has no console host")
	}

	var dialer net.Dialer
	conn, err := dialer.DialContext(ctx, "tcp", fmt.Sprintf("%s:%d", n.ConsoleHost, n.Console))
	if err != nil {
		return "", fmt.Errorf("VPCS console dial %s:%d: %w", n.ConsoleHost, n.Console, err)
	}
	defer conn.Close()

	// VPCS sends a welcome banner and prompt immediately on connect.
	// Read until we see the ">" prompt to confirm the session is ready.
	if err := readVPCSBanner(ctx, conn); err != nil {
		return "", fmt.Errorf("VPCS banner: %w", err)
	}

	// Send the "show" command
	if _, err := fmt.Fprintf(conn, "show\r\n"); err != nil {
		return "", fmt.Errorf("VPCS write show: %w", err)
	}

	// Read the output until the next prompt
	output, err := readVPCSOutput(ctx, conn)
	if err != nil {
		return "", fmt.Errorf("VPCS show output: %w", err)
	}

	mac := parseVPCSMAC(output)
	if mac == "" {
		return "", fmt.Errorf("VPCS show output contained no MAC address:\n%s", output)
	}
	return mac, nil
}

// readVPCSBanner consumes the welcome banner and first prompt from a VPCS
// console connection. VPCS sends output immediately on connect — no login.
func readVPCSBanner(ctx context.Context, conn net.Conn) error {
	_, err := readUntilVPCSDone(ctx, conn, nil)
	return err
}

// readVPCSOutput reads everything up to and including the next VPCS prompt.
// The returned string includes the prompt; callers should strip it or parse
// through it.
func readVPCSOutput(ctx context.Context, conn net.Conn) (string, error) {
	return readUntilVPCSDone(ctx, conn, nil)
}

// readUntilVPCSDone reads from conn until either (a) the accumulated buffer
// contains a VPCS prompt ("PC1> " style — word followed by ">"), or (b) the
// context expires, or (c) a read timeout with accumulated data (device
// finished sending).
//
// If prev is non-empty, those bytes are prepended to the accumulation —
// useful when a prior read already consumed some output.
func readUntilVPCSDone(ctx context.Context, conn net.Conn, prev []byte) (string, error) {
	const readTimeout = 5 * time.Second

	var buf strings.Builder
	if len(prev) > 0 {
		buf.Write(prev)
	}

	raw := make([]byte, 2048)
	for {
		// Calculate deadline from context
		deadline := readTimeout
		if ctxDeadline, ok := ctx.Deadline(); ok {
			remaining := time.Until(ctxDeadline)
			if remaining <= 0 {
				return buf.String(), ctx.Err()
			}
			if remaining < deadline {
				deadline = remaining
			}
		}
		conn.SetReadDeadline(time.Now().Add(deadline))

		n, err := conn.Read(raw)
		if n > 0 {
			buf.Write(raw[:n])
			// VPCS prompt: a word followed by ">" — e.g. "PC1> " or "PC12>"
			s := buf.String()
			if vpcsPromptRe.MatchString(s) {
				return s, nil
			}
		}
		if err != nil {
			if netErr, ok := err.(net.Error); ok && netErr.Timeout() {
				if buf.Len() > 0 {
					return buf.String(), nil
				}
			}
			if ctx.Err() != nil && buf.Len() == 0 {
				return buf.String(), ctx.Err()
			}
			return buf.String(), err
		}
	}
}

// vpcsPromptRe matches a VPCS console prompt (e.g. "PC1> ", "R1> ").
// VPCS uses the node name followed by "> ".
var vpcsPromptRe = regexp.MustCompile(`\S+>\s*$`)

// parseVPCSMAC extracts a MAC address from VPCS "show" command output.
//
// VPCS supports two output formats:
//
//	Verbose (older):
//	  MAC : 00:50:79:66:68:00
//
//	Tabular (current):
//	  NAME   IP/MASK              GATEWAY           MAC                LPORT  RHOST:PORT
//	  PC1    10.0.0.1/24          10.0.0.254        00:50:79:66:68:00  20001  127.0.0.1:20002
//
// Tries the verbose format first, then falls back to the tabular
// (any MAC address pattern in the output).
func parseVPCSMAC(output string) string {
	// Verbose format: "MAC : 00:50:79:66:68:00"
	if m := vpcsMACVerboseRe.FindStringSubmatch(output); len(m) > 1 {
		return m[1]
	}
	// Tabular format: any colon-separated MAC in the output.
	// The first match after the header line is the node's MAC.
	if m := vpcsMACTabularRe.FindStringSubmatch(output); len(m) > 1 {
		return m[1]
	}
	return ""
}

// VPCS show output contains a line like:
//
//	MAC: 00:50:79:66:68:00
var vpcsMACVerboseRe = regexp.MustCompile(`(?i)MAC\s*:\s*([0-9a-f]{2}:[0-9a-f]{2}:[0-9a-f]{2}:[0-9a-f]{2}:[0-9a-f]{2}:[0-9a-f]{2})`)

// Tabular format: any MAC address in the output.
// In a VPCS "show" there's only one MAC (the node's own), so
// the first match is always correct.
var vpcsMACTabularRe = regexp.MustCompile(`(?i)([0-9a-f]{2}:[0-9a-f]{2}:[0-9a-f]{2}:[0-9a-f]{2}:[0-9a-f]{2}:[0-9a-f]{2})`)

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
