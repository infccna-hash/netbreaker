package verify

import (
	"context"
	"fmt"
	"regexp"
)

// IOSCollector implements Collector by driving a node's console over
// the existing telnet bridge (console.go), headless. This file only
// knows CLI syntax and transport — every regex/parse lives in
// parse.go, tested with zero console dependency.
//
// CONCURRENCY: two concurrent verify runs against the same session
// (double-click, retry racing a slow first attempt) will interleave
// show commands through the single serialized console channel and
// each will parse the other's output. The DB unique constraint
// protects XP but not verdict correctness.
//
// REQUIRED before wiring the HTTP handler:
//  1. Per-session mutex or command queue so only one verify run
//     executes at a time per (session, device) pair.
//  2. Hard deadline per verify run (hung console → recorded-as-failed
//     attempt, not a hung HTTP request).
//  3. These belong in ConsoleRunner, not here — this file should
//     remain a thin translation layer.
type IOSCollector struct {
	Console  ConsoleRunner
	NodeID   string
	PromptRe *regexp.Regexp
}

// ConsoleRunner is the minimal slice of the console bridge this
// needs — headless command execution, no interactive I/O.
type ConsoleRunner interface {
	RunCommand(ctx context.Context, nodeID, cmd string, promptRe *regexp.Regexp) (string, error)
}

func (c *IOSCollector) run(ctx context.Context, cmd string) (string, error) {
	out, err := c.Console.RunCommand(ctx, c.NodeID, cmd, c.PromptRe)
	if err != nil {
		return "", fmt.Errorf("run %q on %s: %w", cmd, c.NodeID, err)
	}
	return out, nil
}

func (c *IOSCollector) CollectMACTable(ctx context.Context) (MACTable, error) {
	out, err := c.run(ctx, "show mac address-table")
	if err != nil {
		return nil, err
	}
	return parseMACTable(out), nil
}

func (c *IOSCollector) CollectInterfaces(ctx context.Context, ports ...Port) (map[Port]InterfaceStatus, error) {
	result := map[Port]InterfaceStatus{}
	for _, p := range ports {
		out, err := c.run(ctx, "show interfaces "+string(p))
		if err != nil {
			return nil, err
		}
		result[p] = parseInterfaceStatus(out, p)
	}
	return result, nil
}

func (c *IOSCollector) CollectRunningConfig(ctx context.Context) (string, error) {
	return c.run(ctx, "show running-config")
}

func (c *IOSCollector) CollectErrdisableRecovery(ctx context.Context) (ErrdisableConfig, error) {
	out, err := c.run(ctx, "show errdisable recovery")
	if err != nil {
		return ErrdisableConfig{}, err
	}
	return parseErrdisableRecovery(out), nil
}

func (c *IOSCollector) CollectVLANs(ctx context.Context) (map[Port]int, error) {
	out, err := c.run(ctx, "show vlan brief")
	if err != nil {
		return nil, err
	}
	return parseVlanBrief(out), nil
}

func (c *IOSCollector) CollectReachability(ctx context.Context, targets ...string) (map[string]bool, error) {
	result := map[string]bool{}
	for _, t := range targets {
		out, err := c.run(ctx, fmt.Sprintf("ping %s repeat 3", t))
		if err != nil {
			return nil, err
		}
		result[t] = parsePingResult(out)
	}
	return result, nil
}

// ── STP and port-security collectors (Lab 2 / Lab 3) ────────────────
// Wired to the real parsers (stp_parser.go). The console runner
// disables pagination (terminal length 0) before every command, so
// `show spanning-tree vlan 1` never hangs at --More--.

func (c *IOSCollector) CollectSTP(ctx context.Context) (*STPInfo, error) {
	out, err := c.run(ctx, "show spanning-tree vlan 1")
	if err != nil {
		return nil, err
	}
	return ParseSTP(out)
}

func (c *IOSCollector) CollectPortSecurity(ctx context.Context, iface string) (*PortSecurityInfo, error) {
	out, err := c.run(ctx, "show port-security interface "+iface)
	if err != nil {
		return nil, err
	}
	return ParsePortSecurity(out)
}
