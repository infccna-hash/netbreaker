package labsession

import "netbreaker.io/api/internal/verify"

// ResolveVerifySession converts a persisted lab session into the shape
// the console-truth verify engine needs. It must be called after the
// session reaches StatusRunning (nodes are started, console ports are
// assigned).
//
// MACs are NOT populated here — they're resolved at verification time
// by the IOSCollector via show commands. IPs are also left empty; each
// lab's verifier factory knows its own addressing plan.
func ResolveVerifySession(sess *Session, computeHost string) *verify.LabSession {
	nodes := make(map[string]verify.NodeAddr, len(sess.NodeMap))
	for name, info := range sess.NodeMap {
		nodes[name] = verify.NodeAddr{
			Host: computeHost,
			Port: info.ConsolePort,
		}
	}
	return &verify.LabSession{
		ConsoleNodes: nodes,
		MACs:         make(map[string]string),
		IPs:          make(map[string]string),
	}
}
