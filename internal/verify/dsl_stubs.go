package verify

import (
	"context"
	"fmt"
)

// ExpectRootBridge asserts that the device IS the STP root bridge.
//
// Uses ParseSTP (real IOU parser, 2026-07-30) to check `show spanning-tree vlan 1`.
func (v *Verifier) ExpectRootBridge(device string) *Verifier {
	return v.add(fmt.Sprintf("%s is STP root bridge", device), func(ctx context.Context, ev *EvidenceStore) (bool, string) {
		info, err := ev.STPTable(ctx)
		if err != nil {
			return false, err.Error()
		}
		if !info.IsRoot {
			return false, fmt.Sprintf("%s is not root — root is %s", device, info.RootMAC)
		}
		return true, fmt.Sprintf("root bridge %s", info.RootMAC)
	})
}

// ExpectPortRole asserts that a specific port has a given STP role.
// role is one of: Root, Desg, Altn, Backup (IOU-reported strings).
//
// Uses ParseSTP (real IOU parser, 2026-07-30).
func (v *Verifier) ExpectPortRole(device, iface, role string) *Verifier {
	name := fmt.Sprintf("%s:%s is STP %s", device, iface, role)
	return v.add(name, func(ctx context.Context, ev *EvidenceStore) (bool, string) {
		info, err := ev.STPTable(ctx)
		if err != nil {
			return false, err.Error()
		}
		if info.PortRoles == nil {
			return false, "no port roles in STP output"
		}
		got, ok := info.PortRoles[iface]
		if !ok {
			// Collect all known interfaces for a helpful message
			known := make([]string, 0, len(info.PortRoles))
			for k := range info.PortRoles {
				known = append(known, k)
			}
			return false, fmt.Sprintf("interface %s not in STP output (known: %v)", iface, known)
		}
		if got != role {
			return false, fmt.Sprintf("expected role %s, found %s", role, got)
		}
		return true, fmt.Sprintf("%s is %s", iface, role)
	})
}

// ExpectMACCount asserts that the CAM table has at least n entries.
//
// Uses ParseMACTable (existing parser from Lab 15) via ev.MACTable.
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
