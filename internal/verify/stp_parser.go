package verify

import (
	"regexp"
	"strconv"
	"strings"
)

// STPInfo is the typed representation of `show spanning-tree vlan 1`.
//
// Parsed from real IOU L2 output (Lab 2 captures, 2026-07-30).
type STPInfo struct {
	IsRoot    bool
	RootMAC   string
	BridgeMAC string
	PortRoles map[string]string
}

// PortSecurityInfo holds the result of parsing `show port-security interface`.
//
// Parsed from real IOU L2 capture (Lab 3, 2026-07-30).
type PortSecurityInfo struct {
	Enabled        bool
	MaxMACs        int
	ViolationCount int
	ViolationMode  string
	StickyMACs     []string
}

// ── STP parser (from real IOU captures) ────────────────────────────

var (
	rootAddrRe   = regexp.MustCompile(`(?m)^\s*Root ID.*?\n(?:\s+\S.*\n)*?\s+Address\s+([0-9a-f]{4}\.[0-9a-f]{4}\.[0-9a-f]{4})`)
	isRootRe     = regexp.MustCompile(`This bridge is the root`)
	bridgeAddrRe = regexp.MustCompile(`(?m)^\s*Bridge ID.*?\n(?:\s+\S.*\n)*?\s+Address\s+([0-9a-f]{4}\.[0-9a-f]{4}\.[0-9a-f]{4})`)
	stpRowRe     = regexp.MustCompile(`(?m)^(\S+)\s+(\S+)\s+(\S+)\s+\d+\s+[\d.]+\s+\S+`)
)

func ParseSTP(output string) (*STPInfo, error) {
	info := &STPInfo{PortRoles: map[string]string{}}

	if m := rootAddrRe.FindStringSubmatch(output); m != nil {
		info.RootMAC = normalizeSTPMAC(m[1])
	}
	info.IsRoot = isRootRe.MatchString(output)
	if m := bridgeAddrRe.FindStringSubmatch(output); m != nil {
		info.BridgeMAC = normalizeSTPMAC(m[1])
	}
	for _, match := range stpRowRe.FindAllStringSubmatch(output, -1) {
		iface := match[1]
		role := match[2]
		if !strings.HasPrefix(strings.ToLower(iface), "et") &&
			!strings.HasPrefix(strings.ToLower(iface), "gi") &&
			!strings.HasPrefix(strings.ToLower(iface), "fa") {
			continue
		}
		info.PortRoles[iface] = role
	}
	return info, nil
}

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

// ── Port-security parser (from real IOU capture) ───────────────────

// ParsePortSecurity parses `show port-security interface <iface>` output.
//
// The IOU L2 format is simple key-value pairs: "Field Name  : Value".
func ParsePortSecurity(output string) (*PortSecurityInfo, error) {
	info := &PortSecurityInfo{}

	for _, line := range strings.Split(output, "\n") {
		line = strings.TrimSpace(line)
		if line == "" {
			continue
		}
		parts := strings.SplitN(line, ":", 2)
		if len(parts) != 2 {
			continue
		}
		key := strings.TrimSpace(parts[0])
		val := strings.TrimSpace(parts[1])

		switch key {
		case "Port Security":
			info.Enabled = strings.EqualFold(val, "Enabled")
		case "Maximum MAC Addresses":
			info.MaxMACs, _ = strconv.Atoi(val)
		case "Security Violation Count":
			info.ViolationCount, _ = strconv.Atoi(val)
		case "Violation Mode":
			info.ViolationMode = strings.ToLower(val)
		case "Sticky MAC Addresses":
			n, _ := strconv.Atoi(val)
			if n > 0 {
				info.StickyMACs = make([]string, 0, n)
			}
		}
	}
	return info, nil
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
