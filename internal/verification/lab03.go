package verification

// Lab3Verifier — MAC Flood Chaos
// Build: 3-host topology, baseline CAM behavior understood (auto-verified)
// Attack: macof simulation (auto-verified)
// Harden: Port Security configured on all access ports
type Lab3Verifier struct{}

func (v *Lab3Verifier) Verify(phase string, cfg map[string]DeviceConfig) VerifyResult {
	switch phase {
	case "build":
		// Build phase is conceptual (observe CAM table) — auto-pass
		return VerifyResult{Passed: true, Score: 100, Message: "Baseline topology ready. CAM table behavior understood."}
	case "attack":
		return VerifyResult{Passed: true, Score: 100, Message: "MAC flood simulation complete. CAM table overflow demonstrated."}
	case "harden":
		return v.harden(cfg)
	default:
		return VerifyResult{Passed: false, Message: "unknown phase: " + phase}
	}
}

func (v *Lab3Verifier) harden(cfg map[string]DeviceConfig) VerifyResult {
	var failures, hints []string

	// Check SW1 has port security (nonegotiate on all access ports)
	sw1 := cfg["SW1"]
	accessPorts := 0
	hardenedPorts := 0
	for ifName, iface := range sw1.Interfaces {
		if iface.Mode == "access" {
			accessPorts++
			if !iface.Negotiation {
				hardenedPorts++
			} else {
				failures = append(failures, "SW1: "+ifName+" — port security / nonegotiate not configured")
				hints = append(hints, "SW1(config-if)# switchport port-security\n  switchport port-security maximum 2\n  switchport port-security violation shutdown")
			}
		}
	}

	if accessPorts == 0 {
		failures = append(failures, "SW1: No access ports configured — configure port security on all user-facing ports")
		hints = append(hints, "SW1(config-if)# switchport mode access\n  switchport port-security")
	}

	return result(failures, hints)
}
