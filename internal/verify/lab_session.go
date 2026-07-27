package verify

// LabSession is the per-lab-session context a verifier needs to map
// logical device names ("PC1", "KALI2") to their actual MAC addresses,
// IP addresses, and console ports. It wraps the session's node_map and
// lab-specific configuration.
type LabSession struct {
	// MACs maps logical node name → actual MAC (e.g. from GNS3 node details).
	// Populated at provision time or fetched on first use.
	MACs map[string]string

	// IPs maps logical node name → expected IP (lab-specific, from the
	// verifier's knowledge of addressing).
	IPs map[string]string

	// ConsoleNodes maps logical node name → telnet address so the
	// ConsoleRunner knows where to dial.
	ConsoleNodes map[string]NodeAddr
}

// MAC returns the MAC address for a named node.
func (s *LabSession) MAC(name string) MAC { return MAC(s.MACs[name]) }

// IP returns the expected IP address for a named node.
func (s *LabSession) IP(name string) string { return s.IPs[name] }
