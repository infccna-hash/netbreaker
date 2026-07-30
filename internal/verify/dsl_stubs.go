package verify

import (
	"context"
	"fmt"
)

// ExpectRootBridge asserts that the device IS the STP root bridge.
//
// TODO(real capture): stub — ParseSTP is not yet implemented.
// Once real captures arrive, this will:
//  1. Call ev.STPTable(ctx) to get ParseSTP output
//  2. Compare the root bridge ID against this device's bridge ID
//  3. Pass if they match (device IS root)
func (v *Verifier) ExpectRootBridge(device string) *Verifier {
	return v.add(fmt.Sprintf("%s is STP root bridge", device), func(ctx context.Context, ev *EvidenceStore) (bool, string) {
		info, err := ev.STPTable(ctx)
		if err != nil {
			return false, err.Error()
		}
		_ = info // TODO(real capture): compare RootBridge against device's bridge ID
		return false, "not implemented — pending real `show spanning-tree vlan 1` capture"
	})
}

// ExpectPortRole asserts that a specific port has a given STP role.
// role is the IOU-reported string: "Root", "Desg", "Altn", "Backup".
//
// TODO(real capture): stub — same as ExpectRootBridge.
func (v *Verifier) ExpectPortRole(device, iface, role string) *Verifier {
	name := fmt.Sprintf("%s:%s is STP %s", device, iface, role)
	return v.add(name, func(ctx context.Context, ev *EvidenceStore) (bool, string) {
		info, err := ev.STPTable(ctx)
		if err != nil {
			return false, err.Error()
		}
		_ = info
		_ = iface
		_ = role
		return false, "not implemented — pending real `show spanning-tree vlan 1` capture"
	})
}

// ExpectMACCount asserts that the CAM table has at least n entries.
//
// TODO(real capture): stub — will use ParseMACTable (which already
// works against real IOU output) via ev.MACTable(ctx). The stub just
// reports not-implemented for now while we await the verifier skeleton
// integration test.
func (v *Verifier) ExpectMACCount(n int) *Verifier {
	name := fmt.Sprintf("CAM table has >= %d entries", n)
	return v.add(name, func(ctx context.Context, ev *EvidenceStore) (bool, string) {
		table, err := ev.MACTable(ctx)
		if err != nil {
			return false, err.Error()
		}
		if len(table) < n {
			return false, fmt.Sprintf("expected >= %d MAC entries, found %d", n, len(table))
		}
		return true, fmt.Sprintf("%d entries (min %d)", len(table), n)
	})
}

// ExpectPortSecurityViolations asserts that port-security has recorded
// at least min violations on the given interface.
//
// TODO(real capture): stub — ParsePortSecurity is not yet implemented.
func (v *Verifier) ExpectPortSecurityViolations(iface string, min int) *Verifier {
	name := fmt.Sprintf("port-security violations on %s >= %d", iface, min)
	return v.add(name, func(ctx context.Context, ev *EvidenceStore) (bool, string) {
		info, err := ev.PortSecurity(ctx, iface)
		if err != nil {
			return false, err.Error()
		}
		if info.ViolationCount < min {
			return false, fmt.Sprintf("expected >= %d violations on %s, found %d", min, iface, info.ViolationCount)
		}
		return true, fmt.Sprintf("%d violations on %s (min %d)", info.ViolationCount, iface, min)
	})
}

// ExpectPortSecurityEnabled asserts that port-security is configured
// on the given interface.
//
// TODO(real capture): stub — same as ExpectPortSecurityViolations.
func (v *Verifier) ExpectPortSecurityEnabled(iface string) *Verifier {
	name := fmt.Sprintf("port-security enabled on %s", iface)
	return v.add(name, func(ctx context.Context, ev *EvidenceStore) (bool, string) {
		info, err := ev.PortSecurity(ctx, iface)
		if err != nil {
			return false, err.Error()
		}
		if !info.Enabled {
			return false, fmt.Sprintf("port-security not enabled on %s", iface)
		}
		return true, fmt.Sprintf("port-security enabled on %s (max %d, mode %s)", iface, info.MaxMACs, info.ViolationMode)
	})
}
