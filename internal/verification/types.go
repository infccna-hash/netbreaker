package verification

// InterfaceState is the frontend device config state for one interface.
type InterfaceState struct {
	Mode         string `json:"mode"`        // access | trunk | dynamic | routed
	VLAN         int    `json:"vlan"`        // access VLAN
	NativeVLAN   int    `json:"native_vlan"` // trunk native VLAN
	AllowedVLANs []int  `json:"allowed_vlans"`
	IP           string `json:"ip"`
	Mask         string `json:"mask"`
	Encap        int    `json:"encap"`       // dot1Q VLAN ID (subinterfaces)
	Negotiation  bool   `json:"negotiation"` // DTP enabled
	State        string `json:"state"`       // up | down | err-disabled
}

// DeviceConfig is the full config state for one simulated device.
type DeviceConfig struct {
	Type       string                    `json:"type"` // switch | router | host
	VLANs      map[int]string            `json:"vlans,omitempty"`
	Interfaces map[string]InterfaceState `json:"interfaces,omitempty"`
}

// VerifyRequest is what the playground POSTs to /api/v1/labs/{id}/verify.
type VerifyRequest struct {
	Phase  string                  `json:"phase"`  // build | attack | harden
	Config map[string]DeviceConfig `json:"config"` // device_id → config
}

// VerifyResult is what the backend returns.
type VerifyResult struct {
	Passed   bool     `json:"passed"`
	Score    int      `json:"score"`              // 0–100 (how many objectives passed)
	Failures []string `json:"failures,omitempty"` // what is still wrong
	Hints    []string `json:"hints,omitempty"`    // how to fix each failure
	Message  string   `json:"message"`
}
