package labsession

import "netbreaker.io/api/internal/verify"

// ResolveVerifySession converts a persisted lab session into the shape
// the console-truth verify engine needs. It must be called after the
// session reaches StatusRunning (nodes are started, console ports are
// assigned).
//
// BLOCKER — MAC resolution: MACs are NOT populated here (left empty).
// This means any verifier using ExpectMACOnPort or ExpectMACsShareOnePort
// (e.g. Lab 15 Build) will fail 100% of the time because sess.MAC("PC3")
// returns "<unresolved:PC3>".
//
// The fix requires a provisioning-time MAC populator that queries each
// host individually:
//   - VPCS nodes: telnet → "show" command → parse MAC
//   - Docker nodes: "docker exec <id> cat /sys/class/net/eth0/address"
//   - IOU/dynamips: these are switches/routers; their own MACs aren't needed
//
// This must run at session launch time (between StatusProvisioning and
// StatusRunning) and write results into Session.NodeMap or a new
// session_macs table.
//
// Verifiers using only port-based assertions (ExpectPortVLAN, ExpectInterfaceUp)
// are NOT blocked — Lab 1 Build works today. Lab 15 Build is blocked until
// MAC resolution ships.
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
