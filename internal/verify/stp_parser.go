package verify

import (
	"regexp"
	"strings"
)

// STPInfo is the typed representation of `show spanning-tree vlan 1`.
//
// Parsed from real IOU L2 output (Lab 2 captures, 2026-07-30).
type STPInfo struct {
	// IsRoot is true when the output contains "This bridge is the root".
	IsRoot bool

	// RootMAC is the root bridge's MAC (from the Root ID section).
	RootMAC string

	// BridgeMAC is this bridge's MAC (from the Bridge ID section).
	BridgeMAC string

	// PortRoles maps interface name → STP role: Root, Desg, Altn, Backup.
	PortRoles map[string]string
}

// PortSecurityInfo holds the result of parsing `show port-security interface`.
//
// TODO(real capture): this struct and ParsePortSecurity are stubs.
type PortSecurityInfo struct {
	Enabled        bool
	MaxMACs        int
	ViolationCount int
	ViolationMode  string
	StickyMACs     []string
}

// ── STP parser (from real IOU captures) ────────────────────────────

var (
	// Root bridge MAC line: "Address     aabb.cc00.0c00"
	rootAddrRe = regexp.MustCompile(`(?m)^\s*Root ID.*?\n(?:\s+\S.*\n)*?\s+Address\s+([0-9a-f]{4}\.[0-9a-f]{4}\.[0-9a-f]{4})`)

	// "This bridge is the root" — only present when the switch IS root
	isRootRe = regexp.MustCompile(`This bridge is the root`)

	// Bridge MAC line, same format as root
	bridgeAddrRe = regexp.MustCompile(`(?m)^\s*Bridge ID.*?\n(?:\s+\S.*\n)*?\s+Address\s+([0-9a-f]{4}\.[0-9a-f]{4}\.[0-9a-f]{4})`)

	// Interface table row: "Et0/0               Desg FWD ..."
	// The table header is "Interface           Role Sts Cost      Prio.Nbr Type"
	// Data rows: "Et0/0               Desg FWD 100       128.1    Shr"
	stpRowRe = regexp.MustCompile(`(?m)^(\S+)\s+(\S+)\s+(\S+)\s+\d+\s+[\d.]+\s+\S+`)
)

// ParseSTP parses `show spanning-tree vlan 1` output from IOU L2.
func ParseSTP(output string) (*STPInfo, error) {
	info := &STPInfo{
		PortRoles: map[string]string{},
	}

	// Root MAC
	if m := rootAddrRe.FindStringSubmatch(output); m != nil {
		info.RootMAC = normalizeSTPMAC(m[1])
	}

	// Is root?
	info.IsRoot = isRootRe.MatchString(output)

	// Bridge MAC
	if m := bridgeAddrRe.FindStringSubmatch(output); m != nil {
		info.BridgeMAC = normalizeSTPMAC(m[1])
	}

	// Port roles — skip header line, parse data rows
	for _, match := range stpRowRe.FindAllStringSubmatch(output, -1) {
		iface := match[1]
		role := match[2]
		// Skip lines that aren't real interfaces (e.g. header "Interface")
		if !strings.HasPrefix(strings.ToLower(iface), "et") &&
			!strings.HasPrefix(strings.ToLower(iface), "gi") &&
			!strings.HasPrefix(strings.ToLower(iface), "fa") {
			continue
		}
		info.PortRoles[iface] = role
	}

	return info, nil
}

// normalizeSTPMAC converts Cisco's xxxx.xxxx.xxxx to xx:xx:xx:xx:xx:xx
func normalizeSTPMAC(cisco string) string {
	hex := strings.ReplaceAll(cisco, ".", "")
	var parts []string
	for i := 0; i < len(hex); i += 2 {
		if i+2 > len(hex) {
			break
		}
		parts = append(parts, hex[i:i+2])
	}
	return strings.ToLower(strings.Join(parts, ":"))
}

// ── Port-security stub ─────────────────────────────────────────────

// ParsePortSecurity parses `show port-security interface <iface>` output.
//
// TODO(real capture): stub — real implementation pending capture.
func ParsePortSecurity(output string) (*PortSecurityInfo, error) {
	return nil, errNotImplemented("ParsePortSecurity", "show port-security interface")
}

// ── Sentinel ───────────────────────────────────────────────────────

var ErrNotImplemented = notImplErr{}

type notImplErr struct {
	parser  string
	command string
}

func (e notImplErr) Error() string {
	return "parser not implemented — pending real capture of " + e.command
}

func errNotImplemented(parser, command string) error {
	return notImplErr{parser: parser, command: command}
}
