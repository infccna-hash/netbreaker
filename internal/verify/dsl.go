package verify

import (
	"context"
	"fmt"
)

type Check struct {
	Name   string
	Passed bool
	Detail string
}

type VerifyResult struct {
	Passed   bool
	Checks   []Check
	Evidence Evidence
}

type assertion func(ctx context.Context, ev *EvidenceStore) Check

// Verifier is a declarative list of assertions. Each lab phase builds
// one of these and nothing else — no CLI strings, no parsing, no
// transport code lives at this layer.
type Verifier struct {
	assertions []assertion
}

func New() *Verifier {
	return &Verifier{}
}

func (v *Verifier) add(name string, fn func(ctx context.Context, ev *EvidenceStore) (bool, string)) *Verifier {
	v.assertions = append(v.assertions, func(ctx context.Context, ev *EvidenceStore) Check {
		ok, detail := fn(ctx, ev)
		return Check{Name: name, Passed: ok, Detail: detail}
	})
	return v
}

// ExpectMACOnPort asserts a MAC is learned on exactly the given port.
//
// False-negative safety: dynamic MAC entries only exist if the host
// recently transmitted (default aging 300s). If a student provisions
// a session and immediately hits verify without generating traffic,
// the MAC table is empty and the failure message explicitly tells them
// to generate traffic and re-verify — same logic as ExpectMACsShareOnePort.
//
// TODO(anti-cheat): the parser currently ignores the Type column
// (DYNAMIC vs STATIC). A student could plant a static entry to pass
// without correct topology. When MACEntry grows a Type field, assert
// DYNAMIC here. The method name (ExpectMACOnPort, not ExpectDynamicMACOnPort)
// deliberately defers that decision until the product decision on anti-cheat
// scope is made.
func (v *Verifier) ExpectMACOnPort(name string, mac MAC, port Port) *Verifier {
	return v.add(name, func(ctx context.Context, ev *EvidenceStore) (bool, string) {
		table, err := ev.MACTable(ctx)
		if err != nil {
			return false, err.Error()
		}
		got, ok := table.PortFor(mac)
		if !ok {
			return false, fmt.Sprintf("MAC %s not learned on any port — generate traffic from this host (e.g. ping from it) and re-verify", mac)
		}
		if got != port {
			return false, fmt.Sprintf("expected %s, found on %s", port, got)
		}
		return true, fmt.Sprintf("learned on %s", port)
	})
}

// ExpectMACsShareOnePort asserts a group of MACs all resolve to the
// same single port (e.g. hosts sharing a hub segment behind one
// switch uplink) — used for Lab 15's core lesson.
func (v *Verifier) ExpectMACsShareOnePort(name string, macs []MAC, port Port) *Verifier {
	return v.add(name, func(ctx context.Context, ev *EvidenceStore) (bool, string) {
		table, err := ev.MACTable(ctx)
		if err != nil {
			return false, err.Error()
		}
		for _, m := range macs {
			got, ok := table.PortFor(m)
			if !ok {
				return false, fmt.Sprintf("MAC %s not learned on any port — generate traffic from this host and re-verify", m)
			}
			if got != port {
				return false, fmt.Sprintf("MAC %s expected on %s, found on %s", m, port, got)
			}
		}
		return true, fmt.Sprintf("all %d MACs learned on %s", len(macs), port)
	})
}

func (v *Verifier) ExpectInterfaceUp(port Port) *Verifier {
	return v.add(fmt.Sprintf("%s is up", port), func(ctx context.Context, ev *EvidenceStore) (bool, string) {
		iface, err := ev.Interface(ctx, port)
		if err != nil {
			return false, err.Error()
		}
		if iface.ErrDisabled {
			return false, "port is err-disabled"
		}
		if !iface.AdminUp {
			return false, "port is administratively shut down"
		}
		if !iface.LinkUp {
			return false, "no link detected"
		}
		return true, "up and forwarding"
	})
}

func (v *Verifier) ExpectInterfaceSpeed(port Port, mbps int) *Verifier {
	return v.add(fmt.Sprintf("%s speed = %dMbps", port, mbps), func(ctx context.Context, ev *EvidenceStore) (bool, string) {
		iface, err := ev.Interface(ctx, port)
		if err != nil {
			return false, err.Error()
		}
		if iface.SpeedMbps != mbps {
			return false, fmt.Sprintf("expected %dMbps, found %dMbps", mbps, iface.SpeedMbps)
		}
		return true, "speed matches"
	})
}

func (v *Verifier) ExpectInterfaceDuplex(port Port, d Duplex) *Verifier {
	return v.add(fmt.Sprintf("%s duplex = %s", port, d), func(ctx context.Context, ev *EvidenceStore) (bool, string) {
		iface, err := ev.Interface(ctx, port)
		if err != nil {
			return false, err.Error()
		}
		if iface.Duplex != d {
			return false, fmt.Sprintf("expected %s, found %s", d, iface.Duplex)
		}
		return true, "duplex matches"
	})
}

// ExpectPortVLAN asserts a port's access VLAN. Replaces speed/duplex
// as the "Fault 2" check — VLAN membership shows up in real `show
// vlan brief` output on IOU, unlike speed/duplex which the platform
// silently ignores (see parse.go for the confirmed limitation).
func (v *Verifier) ExpectPortVLAN(port Port, vlan int) *Verifier {
	return v.add(fmt.Sprintf("%s in VLAN %d", port, vlan), func(ctx context.Context, ev *EvidenceStore) (bool, string) {
		got, ok, err := ev.VLANFor(ctx, port)
		if err != nil {
			return false, err.Error()
		}
		if !ok {
			return false, fmt.Sprintf("no VLAN assignment found for %s", port)
		}
		if got != vlan {
			return false, fmt.Sprintf("expected VLAN %d, found VLAN %d", vlan, got)
		}
		return true, fmt.Sprintf("in VLAN %d", vlan)
	})
}

func (v *Verifier) ExpectDescription(port Port, text string) *Verifier {
	return v.add(fmt.Sprintf("%s description set", port), func(ctx context.Context, ev *EvidenceStore) (bool, string) {
		iface, err := ev.Interface(ctx, port)
		if err != nil {
			return false, err.Error()
		}
		if iface.Description != text {
			return false, fmt.Sprintf("expected %q, found %q", text, iface.Description)
		}
		return true, "description matches"
	})
}

func (v *Verifier) ExpectErrdisableRecovery(intervalSec int) *Verifier {
	return v.add("errdisable auto-recovery enabled", func(ctx context.Context, ev *EvidenceStore) (bool, string) {
		cfg, err := ev.ErrdisableRecovery(ctx)
		if err != nil {
			return false, err.Error()
		}
		if !cfg.Enabled {
			return false, "errdisable recovery not enabled"
		}
		if cfg.IntervalSec != intervalSec {
			return false, fmt.Sprintf("expected interval %ds, found %ds", intervalSec, cfg.IntervalSec)
		}
		return true, "enabled with correct interval"
	})
}

func (v *Verifier) ExpectReachable(name, target string) *Verifier {
	return v.add(fmt.Sprintf("%s reachable", name), func(ctx context.Context, ev *EvidenceStore) (bool, string) {
		if target == "" {
			return false, fmt.Sprintf("IP not configured for host %s", name)
		}
		ok, err := ev.Reachable(ctx, target)
		if err != nil {
			return false, err.Error()
		}
		if !ok {
			return false, fmt.Sprintf("%s (%s) did not respond", target, name)
		}
		return true, fmt.Sprintf("%s responded", target)
	})
}

// Run executes every assertion against a fresh EvidenceStore, so
// each verify call gets its own dedup cache but shares it across
// all assertions in this run.
func (v *Verifier) Run(ctx context.Context, c Collector) VerifyResult {
	ev := NewEvidenceStore(c)
	checks := make([]Check, 0, len(v.assertions))
	passed := true
	for _, a := range v.assertions {
		chk := a(ctx, ev)
		checks = append(checks, chk)
		if !chk.Passed {
			passed = false
		}
	}
	return VerifyResult{Passed: passed, Checks: checks, Evidence: ev.Snapshot()}
}
