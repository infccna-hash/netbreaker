package verification

import "fmt"

// Lab1Verifier — VLAN Warfare
// Build: VLANs configured, trunk set up with native VLAN 999, R1 subinterfaces with encap+IP
// Attack: auto-passed (simulation-only)
// Harden: DTP disabled on all access ports, native VLAN 999 enforced
type Lab1Verifier struct{}

func (v *Lab1Verifier) Verify(phase string, cfg map[string]DeviceConfig) VerifyResult {
	switch phase {
	case "build":
		return v.build(cfg)
	case "attack":
		// Attack is a guided simulation — just verify the user watched it
		return VerifyResult{Passed: true, Score: 100, Message: "Attack simulation complete."}
	case "harden":
		return v.harden(cfg)
	default:
		return VerifyResult{Passed: false, Message: "unknown phase: " + phase}
	}
}

func (v *Lab1Verifier) build(cfg map[string]DeviceConfig) VerifyResult {
	var failures, hints []string

	sw1 := cfg["SW1"]
	sw2 := cfg["SW2"]
	r1 := cfg["R1"]

	// SW1: VLANs 10, 20, 99
	for _, vlan := range []int{10, 20, 99} {
		if _, ok := sw1.VLANs[vlan]; !ok {
			failures = append(failures, fmt.Sprintf("SW1: VLAN %d not configured", vlan))
			hints = append(hints, fmt.Sprintf("SW1(config)# vlan %d", vlan))
		}
	}

	// SW2: VLANs 10, 20, 99
	for _, vlan := range []int{10, 20, 99} {
		if _, ok := sw2.VLANs[vlan]; !ok {
			failures = append(failures, fmt.Sprintf("SW2: VLAN %d not configured", vlan))
			hints = append(hints, fmt.Sprintf("SW2(config)# vlan %d", vlan))
		}
	}

	// SW1 G0/1 → trunk toward SW2, native VLAN 999
	sw1g01 := sw1.Interfaces["GigabitEthernet0/1"]
	if sw1g01.Mode != "trunk" {
		failures = append(failures, "SW1: G0/1 must be in trunk mode")
		hints = append(hints, "SW1(config-if)# switchport mode trunk")
	} else if sw1g01.NativeVLAN != 999 {
		failures = append(failures, "SW1: G0/1 native VLAN must be 999 (prevents double-tag attacks)")
		hints = append(hints, "SW1(config-if)# switchport trunk native vlan 999")
	}

	// SW2 G0/0 → trunk toward SW1
	sw2g00 := sw2.Interfaces["GigabitEthernet0/0"]
	if sw2g00.Mode != "trunk" {
		failures = append(failures, "SW2: G0/0 must be in trunk mode (link toward SW1)")
		hints = append(hints, "SW2(config-if)# switchport mode trunk")
	}

	// R1 subinterface .10 — encap + IP
	sub10 := r1.Interfaces["GigabitEthernet0/0.10"]
	if sub10.Encap != 10 {
		failures = append(failures, "R1: G0/0.10 must have encapsulation dot1Q 10")
		hints = append(hints, "R1(config-subif)# encapsulation dot1Q 10")
	}
	if sub10.IP == "" {
		failures = append(failures, "R1: G0/0.10 must have an IP address (gateway for VLAN 10)")
		hints = append(hints, "R1(config-subif)# ip address 192.168.10.1 255.255.255.0")
	}

	// R1 subinterface .20 — encap + IP
	sub20 := r1.Interfaces["GigabitEthernet0/0.20"]
	if sub20.Encap != 20 {
		failures = append(failures, "R1: G0/0.20 must have encapsulation dot1Q 20")
		hints = append(hints, "R1(config-subif)# encapsulation dot1Q 20")
	}
	if sub20.IP == "" {
		failures = append(failures, "R1: G0/0.20 must have an IP address (gateway for VLAN 20)")
		hints = append(hints, "R1(config-subif)# ip address 192.168.20.1 255.255.255.0")
	}

	return result(failures, hints)
}

func (v *Lab1Verifier) harden(cfg map[string]DeviceConfig) VerifyResult {
	var failures, hints []string

	sw2 := cfg["SW2"]

	// SW2 F0/2 (Kali port) must be access mode with DTP disabled
	f02 := sw2.Interfaces["FastEthernet0/2"]
	if f02.Mode == "dynamic" || f02.Mode == "trunk" {
		failures = append(failures, "SW2: F0/2 (attacker port) is still vulnerable — DTP enabled or in trunk mode")
		hints = append(hints, "SW2(config-if)# switchport mode access")
	}
	if f02.Negotiation {
		failures = append(failures, "SW2: F0/2 DTP negotiation still active — attacker can re-negotiate trunk")
		hints = append(hints, "SW2(config-if)# switchport nonegotiate")
	}

	// All access ports should have nonegotiate
	sw1 := cfg["SW1"]
	for name, iface := range sw1.Interfaces {
		if iface.Mode == "access" && iface.Negotiation {
			failures = append(failures, fmt.Sprintf("SW1: %s is access mode but DTP still active", name))
			hints = append(hints, fmt.Sprintf("SW1(config-if)# interface %s → switchport nonegotiate", name))
		}
	}

	return result(failures, hints)
}
