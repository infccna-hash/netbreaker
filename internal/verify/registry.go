package verify

import "context"

// VerifierFactory is called with a LabSession to produce a Verifier for
// a specific lab+phase combination. Each lab registers one factory per
// phase (build/attack/harden).
type VerifierFactory func(sess *LabSession) *Verifier

// RegistryEntry pairs a verifier factory with the target IOU device
// that the console-truth collector must probe. The target device is
// set explicitly at registration time — NEVER discovered at runtime
// by iterating a Go map (random iteration order; see handler.go for
// the bug this prevents).
type RegistryEntry struct {
	Factory      VerifierFactory
	TargetDevice string // e.g. "SW1" — the IOU switch to probe
}

// VerifierRegistry maps (labID, phase) → RegistryEntry.
// Labs that don't register a verifier for a phase get nil from Lookup.
type VerifierRegistry struct {
	entries map[labPhaseKey]RegistryEntry
}

type labPhaseKey struct {
	labID int
	phase string
}

func NewVerifierRegistry() *VerifierRegistry {
	return &VerifierRegistry{entries: map[labPhaseKey]RegistryEntry{}}
}

// Register wires a verifier factory and its target IOU device for a
// specific lab+phase. targetDevice is the exact node name that the
// collector must probe (e.g. "SW1"), set explicitly here so it never
// depends on map iteration order at runtime.
func (r *VerifierRegistry) Register(labID int, phase string, targetDevice string, fn VerifierFactory) {
	r.entries[labPhaseKey{labID, phase}] = RegistryEntry{
		Factory:      fn,
		TargetDevice: targetDevice,
	}
}

// Lookup returns the registry entry for a lab+phase, or nil if none
// is registered.
func (r *VerifierRegistry) Lookup(labID int, phase string) *RegistryEntry {
	e, ok := r.entries[labPhaseKey{labID, phase}]
	if !ok {
		return nil
	}
	return &e
}

// Run executes the registered verifier for (labID, phase) against the
// given session and collector, returning the result. If no verifier is
// registered, all checks pass vacuously (no assertions = no failures).
func (r *VerifierRegistry) Run(ctx context.Context, labID int, phase string, sess *LabSession, c Collector) VerifyResult {
	e := r.Lookup(labID, phase)
	if e == nil {
		return VerifyResult{Passed: true}
	}
	return e.Factory(sess).Run(ctx, c)
}
