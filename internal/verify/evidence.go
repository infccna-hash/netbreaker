package verify

import (
	"context"
	"fmt"
	"sync"
)

type Port string
type MAC string

type MACEntry struct {
	MAC  MAC
	Port Port
	VLAN int
}

type MACTable []MACEntry

func (t MACTable) PortFor(mac MAC) (Port, bool) {
	for _, e := range t {
		if e.MAC == mac {
			return e.Port, true
		}
	}
	return "", false
}

type Duplex string

const (
	DuplexFull Duplex = "full"
	DuplexHalf Duplex = "half"
)

type InterfaceStatus struct {
	Name        Port
	AdminUp     bool
	LinkUp      bool
	ErrDisabled bool
	SpeedMbps   int
	Duplex      Duplex
	Description string
}

type ErrdisableConfig struct {
	Enabled     bool
	IntervalSec int
	Causes      []string
}

// Evidence is the full typed snapshot collected during one verify run.
// Nothing in the DSL layer parses CLI — it only ever reads from this.
type Evidence struct {
	MACTable           MACTable
	Interfaces         map[Port]InterfaceStatus
	RunningConfig      string
	ErrdisableRecovery ErrdisableConfig
	Reachability       map[string]bool
	VLANs              map[Port]int
}

// Collector is the transport-agnostic boundary. An IOS implementation
// translates these into `show ...` commands; a future VyOS/FRR
// implementation would translate them differently. Assertions never
// see a Collector directly — only through the caching EvidenceStore.
type Collector interface {
	CollectMACTable(ctx context.Context) (MACTable, error)
	CollectInterfaces(ctx context.Context, ports ...Port) (map[Port]InterfaceStatus, error)
	CollectRunningConfig(ctx context.Context) (string, error)
	CollectErrdisableRecovery(ctx context.Context) (ErrdisableConfig, error)
	CollectReachability(ctx context.Context, targets ...string) (map[string]bool, error)
	CollectVLANs(ctx context.Context) (map[Port]int, error)
}

// EvidenceStore wraps a Collector with per-run caching so that N
// assertions needing the same data (e.g. three checks all reading
// interface state) only ever trigger one console round-trip.
type EvidenceStore struct {
	collector Collector
	mu        sync.Mutex
	evidence  Evidence
	fetched   map[string]bool
}

func NewEvidenceStore(c Collector) *EvidenceStore {
	return &EvidenceStore{
		collector: c,
		fetched:   map[string]bool{},
		evidence:  Evidence{Interfaces: map[Port]InterfaceStatus{}},
	}
}

func (s *EvidenceStore) Snapshot() Evidence {
	s.mu.Lock()
	defer s.mu.Unlock()
	return s.evidence
}

func (s *EvidenceStore) MACTable(ctx context.Context) (MACTable, error) {
	s.mu.Lock()
	defer s.mu.Unlock()
	if !s.fetched["mac_table"] {
		t, err := s.collector.CollectMACTable(ctx)
		if err != nil {
			return nil, fmt.Errorf("collect mac table: %w", err)
		}
		s.evidence.MACTable = t
		s.fetched["mac_table"] = true
	}
	return s.evidence.MACTable, nil
}

func (s *EvidenceStore) Interface(ctx context.Context, port Port) (InterfaceStatus, error) {
	s.mu.Lock()
	defer s.mu.Unlock()
	if iface, ok := s.evidence.Interfaces[port]; ok {
		return iface, nil
	}
	got, err := s.collector.CollectInterfaces(ctx, port)
	if err != nil {
		return InterfaceStatus{}, fmt.Errorf("collect interface %s: %w", port, err)
	}
	for k, v := range got {
		s.evidence.Interfaces[k] = v
	}
	return s.evidence.Interfaces[port], nil
}

func (s *EvidenceStore) ErrdisableRecovery(ctx context.Context) (ErrdisableConfig, error) {
	s.mu.Lock()
	defer s.mu.Unlock()
	if !s.fetched["errdisable"] {
		c, err := s.collector.CollectErrdisableRecovery(ctx)
		if err != nil {
			return ErrdisableConfig{}, fmt.Errorf("collect errdisable recovery: %w", err)
		}
		s.evidence.ErrdisableRecovery = c
		s.fetched["errdisable"] = true
	}
	return s.evidence.ErrdisableRecovery, nil
}

func (s *EvidenceStore) VLANFor(ctx context.Context, port Port) (int, bool, error) {
	s.mu.Lock()
	defer s.mu.Unlock()
	if !s.fetched["vlans"] {
		vlans, err := s.collector.CollectVLANs(ctx)
		if err != nil {
			return 0, false, fmt.Errorf("collect vlans: %w", err)
		}
		s.evidence.VLANs = vlans
		s.fetched["vlans"] = true
	}
	v, ok := s.evidence.VLANs[port]
	return v, ok, nil
}

func (s *EvidenceStore) Reachable(ctx context.Context, target string) (bool, error) {
	s.mu.Lock()
	defer s.mu.Unlock()
	if s.evidence.Reachability == nil {
		s.evidence.Reachability = map[string]bool{}
	}
	if v, ok := s.evidence.Reachability[target]; ok {
		return v, nil
	}
	got, err := s.collector.CollectReachability(ctx, target)
	if err != nil {
		return false, fmt.Errorf("collect reachability %s: %w", target, err)
	}
	for k, v := range got {
		s.evidence.Reachability[k] = v
	}
	return s.evidence.Reachability[target], nil
}
