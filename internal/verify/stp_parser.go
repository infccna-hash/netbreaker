package verify

// STPInfo is the typed representation of `show spanning-tree vlan 1`.
//
// TODO(real capture): this struct is a placeholder. Fields are based on
// the expected IOU L2 output format, but the parser (ParseSTP) is a
// stub until real `show spanning-tree` captures arrive from SW1, SW2,
// and SW3 in a running Lab 2 session.
type STPInfo struct {
	// RootBridge is the bridge ID of the root (e.g. "32768.xxxx.xxxx.xxxx").
	RootBridge string

	// Priority is this bridge's priority (0-61440, default 32768).
	Priority int

	// PortStates maps interface name → STP port role (e.g. Et0/0 → "Root",
	// Et0/2 → "Altn"). Roles are the IOU-reported strings: Root, Desg, Altn.
	PortStates map[string]string
}

// PortSecurityInfo holds the result of parsing `show port-security interface`.
//
// TODO(real capture): this struct and ParsePortSecurity are stubs.
type PortSecurityInfo struct {
	// Enabled is true if port-security is configured on the port.
	Enabled bool

	// MaxMACs is the configured maximum (switchport port-security maximum N).
	MaxMACs int

	// ViolationCount is the number of security violations recorded.
	ViolationCount int

	// ViolationMode is the configured action (shutdown / restrict / protect).
	ViolationMode string

	// StickyMACs is the list of sticky-learned MAC addresses.
	StickyMACs []string
}

// ParseSTP parses `show spanning-tree vlan 1` output into STPInfo.
//
// TODO(real capture): stub — returns an error until real IOU captures
// from Lab 2's SW1/SW2/SW3 are available. Writing the regex before
// seeing the real output is the same mistake parse_test.go's TODO
// warns against: the test won't fail against best-guess output, but
// it will fail against real IOU formatting.
func ParseSTP(output string) (*STPInfo, error) {
	return nil, errNotImplemented("ParseSTP", "show spanning-tree vlan 1")
}

// ParsePortSecurity parses `show port-security interface <iface>` output.
//
// TODO(real capture): stub — same reason as ParseSTP.
func ParsePortSecurity(output string) (*PortSecurityInfo, error) {
	return nil, errNotImplemented("ParsePortSecurity", "show port-security interface")
}

// errNotImplemented is a sentinel for stub parsers. It can be checked
// with errors.Is(err, ErrNotImplemented) once captures are in.
var ErrNotImplemented = notImplErr{}

type notImplErr struct {
	parser  string
	command string
}

func (e notImplErr) Error() string {
	return "parser not implemented — pending real capture of " + e.command
}

func errNotImplemented(parser, command string) error {
	return notImplErr{parser: parser, command: command}
}
