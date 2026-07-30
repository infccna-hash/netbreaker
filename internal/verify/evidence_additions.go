package verify

import (
	"context"
	"fmt"
)

// ── Evidence struct additions ──────────────────────────────────────
// These fields are added to evidence.go's Evidence struct and its
// corresponding EvidenceStore methods.

// STPTable returns the parsed spanning-tree state.
//
// TODO(real capture): ParseSTP is a stub — this always returns an
// error until real `show spanning-tree vlan 1` captures are available.
func (s *EvidenceStore) STPTable(ctx context.Context) (*STPInfo, error) {
	s.mu.Lock()
	defer s.mu.Unlock()
	if !s.fetched["stp"] {
		info, err := s.collector.CollectSTP(ctx)
		if err != nil {
			return nil, fmt.Errorf("collect stp: %w", err)
		}
		s.evidence.STP = info
		s.fetched["stp"] = true
	}
	return s.evidence.STP, nil
}

// PortSecurity returns the parsed port-security state for a specific
// interface.
//
// TODO(real capture): ParsePortSecurity is a stub.
func (s *EvidenceStore) PortSecurity(ctx context.Context, iface string) (*PortSecurityInfo, error) {
	s.mu.Lock()
	defer s.mu.Unlock()
	key := "portsec:" + iface
	if !s.fetched[key] {
		info, err := s.collector.CollectPortSecurity(ctx, iface)
		if err != nil {
			return nil, fmt.Errorf("collect port-security %s: %w", iface, err)
		}
		if s.evidence.PortSecurities == nil {
			s.evidence.PortSecurities = map[string]*PortSecurityInfo{}
		}
		s.evidence.PortSecurities[iface] = info
		s.fetched[key] = true
	}
	return s.evidence.PortSecurities[iface], nil
}

// ── Evidence struct additions ──────────────────────────────────────
// STP is the parsed spanning-tree output (nil until collected).
// PortSecurities maps interface names to their port-security state.
// These must be added to the Evidence struct in evidence.go:
//
//   STP             *STPInfo
//   PortSecurities  map[string]*PortSecurityInfo
//
// And two new Collector methods must be added to the Collector interface:
//
//   CollectSTP(ctx context.Context) (*STPInfo, error)
//   CollectPortSecurity(ctx context.Context, iface string) (*PortSecurityInfo, error)
