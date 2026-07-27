package verify

import (
	"regexp"
	"strconv"
	"strings"
)

// This file has zero dependency on Console/transport. Every function
// here takes raw command output and returns typed data — drop real
// `show ...` captures straight into parse_test.go against these.

var macTableLineRe = regexp.MustCompile(`(?i)^\s*(\d+)\s+([0-9a-f]{4}\.[0-9a-f]{4}\.[0-9a-f]{4})\s+\S+\s+(\S+)\s*$`)

func parseMACTable(out string) MACTable {
	var table MACTable
	for _, line := range strings.Split(out, "\n") {
		m := macTableLineRe.FindStringSubmatch(line)
		if m == nil {
			continue
		}
		vlan, _ := strconv.Atoi(m[1])
		table = append(table, MACEntry{
			MAC:  MAC(normalizeMAC(m[2])),
			Port: Port(m[3]),
			VLAN: vlan,
		})
	}
	return table
}

// normalizeMAC converts Cisco's xxxx.xxxx.xxxx form to xx:xx:xx:xx:xx:xx
// so it matches the MAC format GNS3's node-details API returns.
func normalizeMAC(cisco string) string {
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

var (
	adminStateRe = regexp.MustCompile(`(?i)administratively down`)
	lineProtoRe  = regexp.MustCompile(`(?i)line protocol is (up|down)`)
	errDisableRe = regexp.MustCompile(`(?i)err-disabled`)
	speedRe      = regexp.MustCompile(`(?i)(\d+)\s*Mb/?s`)
	duplexRe     = regexp.MustCompile(`(?i)(full|half)-duplex`)
	descRe       = regexp.MustCompile(`(?i)Description:\s*(.+)`)
)

// parseInterfaceStatus parses `show interfaces <port>` output into
// typed state. SpeedMbps and Duplex are zero/empty when the interface
// reports Auto-speed / Auto-duplex — this is the permanent state on
// IOU L2 where virtual Ethernet has no PHY and the `speed` command is
// rejected (% Invalid input). ExpectInterfaceSpeed/ExpectInterfaceDuplex
// are only meaningful on dynamips or IOSvL2 platforms.
func parseInterfaceStatus(out string, port Port) InterfaceStatus {
	status := InterfaceStatus{Name: port, AdminUp: true, LinkUp: false}
	if adminStateRe.MatchString(out) {
		status.AdminUp = false
	}
	if m := lineProtoRe.FindStringSubmatch(out); m != nil {
		status.LinkUp = strings.EqualFold(m[1], "up")
	}
	if errDisableRe.MatchString(out) {
		status.ErrDisabled = true
	}
	if m := speedRe.FindStringSubmatch(out); m != nil {
		status.SpeedMbps, _ = strconv.Atoi(m[1])
	}
	if m := duplexRe.FindStringSubmatch(out); m != nil {
		status.Duplex = Duplex(strings.ToLower(m[1]))
	}
	if m := descRe.FindStringSubmatch(out); m != nil {
		status.Description = strings.TrimSpace(m[1])
	}
	return status
}

var errdisableIntervalRe = regexp.MustCompile(`(?i)Timer interval:\s*(\d+)\s*seconds`)

func parseErrdisableRecovery(out string) ErrdisableConfig {
	// Enabled: check for Timer interval presence — IOU L2 shows all
	// individual causes as "Disabled" even when recovery is globally
	// active, but the timer interval line proves it's configured.
	enabled := strings.Contains(strings.ToLower(out), "enabled") ||
		strings.Contains(out, "Timer interval:")
	cfg := ErrdisableConfig{Enabled: enabled}
	if m := errdisableIntervalRe.FindStringSubmatch(out); m != nil {
		cfg.IntervalSec, _ = strconv.Atoi(m[1])
	}
	return cfg
}

var pingSuccessRe = regexp.MustCompile(`(?i)Success rate is (\d+) percent`)

// TODO(real capture): parseVlanBrief is written against typical IOS
// `show vlan brief` formatting, not yet validated against real IOU
// output the way MAC table / interface / errdisable parsing was.
// Get a real capture (with at least one port explicitly moved to a
// non-default VLAN) before trusting this in the Attack verifier.
//
// Specific concerns to test when capture comes in:
//  1. IOU may wrap port lists aggressively — even short lists (2-3
//     ports) can split across lines, not just long ones.
//  2. The continuation-line heuristic (currentVLAN >= 0 &&
//     strings.Contains(trimmed, "Et")) could bleed a wrapped line
//     from VLAN 1 into VLAN 99's assignment if a new VLAN header
//     line isn't recognized correctly. The capture MUST include
//     BOTH VLAN 1 and VLAN 99 in the same output, not just the
//     faulty port in isolation — that's the case that exercises
//     whether currentVLAN state correctly resets between blocks.
//  3. The regex vlanRowRe assumes "VLAN-ID Name Status Ports"
//     column order. If IOU's column layout differs (extra Status
//     columns, different spacing), the regex won't match. Confirm
//     against real output.
var vlanRowRe = regexp.MustCompile(`^(\d+)\s+\S+\s+\S+\s+(.*)$`)

func parseVlanBrief(out string) map[Port]int {
	result := map[Port]int{}
	currentVLAN := -1
	for _, line := range strings.Split(out, "\n") {
		trimmed := strings.TrimRight(line, " \r")
		if trimmed == "" {
			continue
		}
		if m := vlanRowRe.FindStringSubmatch(trimmed); m != nil {
			vlan, err := strconv.Atoi(m[1])
			if err != nil {
				continue
			}
			currentVLAN = vlan
			assignPorts(result, m[2], vlan)
			continue
		}
		// Continuation line: IOS wraps long port lists onto indented
		// lines with no leading VLAN id — only "Ports" column repeats.
		if currentVLAN >= 0 && strings.Contains(trimmed, "Et") {
			assignPorts(result, strings.TrimSpace(trimmed), currentVLAN)
		}
	}
	return result
}

func assignPorts(result map[Port]int, portsField string, vlan int) {
	for _, p := range strings.Split(portsField, ",") {
		p = strings.TrimSpace(p)
		if p == "" {
			continue
		}
		result[Port(p)] = vlan
	}
}

// parsePingResult reads IOS's `ping` summary line and treats anything
// >= 66% as reachable — tolerates one dropped packet (common on first
// ping while ARP resolves) without treating real link failure as pass.
func parsePingResult(out string) bool {
	m := pingSuccessRe.FindStringSubmatch(out)
	if m == nil {
		return false
	}
	pct, _ := strconv.Atoi(m[1])
	return pct >= 66
}
