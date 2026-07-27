package verify

import "context"

// VerifierFactory is called with a LabSession to produce a Verifier for
// a specific lab+phase combination. Each lab registers one factory per
// phase (build/attack/harden).
type VerifierFactory func(sess *LabSession) *Verifier

// VerifierRegistry maps (labID, phase) → Verifier factory.
// Labs that don't register a verifier for a phase get a no-op that
// treats every assertion as passed.
type VerifierRegistry struct {
	factories map[labPhaseKey]VerifierFactory
}

type labPhaseKey struct {
	labID int
	phase string
}

func NewVerifierRegistry() *VerifierRegistry {
	return &VerifierRegistry{factories: map[labPhaseKey]VerifierFactory{}}
}

// Register wires a verifier factory for a specific lab+phase.
func (r *VerifierRegistry) Register(labID int, phase string, fn VerifierFactory) {
	r.factories[labPhaseKey{labID, phase}] = fn
}

// Lookup returns the verifier factory for a lab+phase, or nil if none
// is registered.
func (r *VerifierRegistry) Lookup(labID int, phase string) VerifierFactory {
	return r.factories[labPhaseKey{labID, phase}]
}

// Run executes the registered verifier for (labID, phase) against the
// given session and collector, returning the result. If no verifier is
// registered, all checks pass vacuously (no assertions = no failures).
func (r *VerifierRegistry) Run(ctx context.Context, labID int, phase string, sess *LabSession, c Collector) VerifyResult {
	fn := r.Lookup(labID, phase)
	if fn == nil {
		return VerifyResult{Passed: true}
	}
	return fn(sess).Run(ctx, c)
}
