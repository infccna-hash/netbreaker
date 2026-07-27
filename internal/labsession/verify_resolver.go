package labsession

import "netbreaker.io/api/internal/verify"

// ResolveVerifySession converts a persisted lab session into the shape
// the console-truth verify engine needs. It must be called after the
// session reaches StatusRunning (nodes are started, console ports are
// assigned, MACs are populated).
//
// MACs are read from info.MAC — populated at provision time by
// PopulateNodeMACs (docker/qemu from GNS3 API, vpcs from console).
// Nodes without a resolved MAC (switches, routers, hubs) get the
// "<unresolved:name>" sentinel and will fail any MAC-based assertion
// with a clear error message.
func ResolveVerifySession(sess *Session, computeHost string) *verify.LabSession {
	nodes := make(map[string]verify.NodeAddr, len(sess.NodeMap))
	macs := make(map[string]string, len(sess.NodeMap))
	for name, info := range sess.NodeMap {
		nodes[name] = verify.NodeAddr{
			Host: computeHost,
			Port: info.ConsolePort,
		}
		if info.MAC != "" {
			macs[name] = info.MAC
		}
	}
	return &verify.LabSession{
		ConsoleNodes: nodes,
		MACs:         macs,
		IPs:          make(map[string]string),
	}
}
