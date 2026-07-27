package verify

import "testing"

// TODO(real capture): every `raw` string below is a best-guess IOS/IOSvL2
// output shape, not a real capture. Replace each with the actual output
// from SW1 in a live Lab 15 session and re-run — if a test fails against
// real output, the regex in parse.go is wrong, not the test.

func TestParseMACTable(t *testing.T) {
	// Real capture from IOU L2 (i86bi-linux-l2-adventerprisek9-15.1a)
	raw := `show mac address-table
          Mac Address Table
-------------------------------------------

Vlan    Mac Address       Type        Ports
----    -----------       --------    -----
Switch>`
	table := parseMACTable(raw)
	if len(table) != 0 {
		t.Fatalf("expected 0 entries from empty table, got %d: %+v", len(table), table)
	}
}

func TestParseMACTable_EmptyOrHeaderOnly(t *testing.T) {
	raw := `
          Mac Address Table
-------------------------------------------

Vlan    Mac Address       Type        Ports
----    -----------       --------    -----
`
	table := parseMACTable(raw)
	if len(table) != 0 {
		t.Errorf("expected 0 entries from header-only output, got %d", len(table))
	}
}

func TestNormalizeMAC(t *testing.T) {
	cases := map[string]string{
		"aabb.cc00.1010": "aa:bb:cc:00:10:10",
		"0011.2233.4455": "00:11:22:33:44:55",
	}
	for in, want := range cases {
		if got := normalizeMAC(in); got != want {
			t.Errorf("normalizeMAC(%q) = %q, want %q", in, got, want)
		}
	}
}

func TestParseInterfaceStatus_UpFullDuplex(t *testing.T) {
	// Real capture from IOU L2 — interface with auto-negotiation (no explicit speed/duplex set)
	raw := `show interfaces Et0/0
Ethernet0/0 is up, line protocol is up (connected) 
  Hardware is AmdP2, address is aabb.cc00.0100 (bia aabb.cc00.0100)
  MTU 1500 bytes, BW 10000 Kbit/sec, DLY 1000 usec, 
     reliability 255/255, txload 1/255, rxload 1/255
  Encapsulation ARPA, loopback not set
  Keepalive set (10 sec)
  Auto-duplex, Auto-speed, media type is unknown`
	iface := parseInterfaceStatus(raw, "Et0/0")
	if !iface.AdminUp || !iface.LinkUp {
		t.Errorf("expected up/up, got AdminUp=%v LinkUp=%v", iface.AdminUp, iface.LinkUp)
	}
	// Auto-duplex means no explicit config — Duplex stays empty
	if iface.Duplex != "" {
		t.Errorf("expected empty duplex for auto-negotiated port, got %s", iface.Duplex)
	}
	// Auto-speed means SpeedMbps stays 0
	if iface.SpeedMbps != 0 {
		t.Errorf("expected 0 speed for auto-negotiated port, got %d", iface.SpeedMbps)
	}
	if iface.ErrDisabled {
		t.Error("should not be err-disabled")
	}
}

func TestParseInterfaceStatus_AdminDown(t *testing.T) {
	raw := `
Et0/1 is administratively down, line protocol is down
  Hardware is AmdP2, address is aabb.cc80.0102
`
	iface := parseInterfaceStatus(raw, "Et0/1")
	if iface.AdminUp {
		t.Error("expected AdminUp = false")
	}
	if iface.LinkUp {
		t.Error("expected LinkUp = false")
	}
}

func TestParseInterfaceStatus_ErrDisabled(t *testing.T) {
	raw := `
Et0/2 is down, line protocol is down (err-disabled)
  Hardware is AmdP2, address is aabb.cc80.0203
`
	iface := parseInterfaceStatus(raw, "Et0/2")
	if !iface.ErrDisabled {
		t.Error("expected ErrDisabled = true")
	}
}

func TestParseInterfaceStatus_HalfDuplexMismatchCandidate(t *testing.T) {
	raw := `
Et0/0 is up, line protocol is up
  Half-duplex, 10Mb/s, media type is RJ45
`
	iface := parseInterfaceStatus(raw, "Et0/0")
	if iface.Duplex != DuplexHalf {
		t.Errorf("expected half duplex, got %s", iface.Duplex)
	}
	if iface.SpeedMbps != 10 {
		t.Errorf("expected 10Mbps, got %d", iface.SpeedMbps)
	}
}

func TestParseErrdisableRecovery(t *testing.T) {
	// Real capture from IOU L2 — all causes "Disabled" but timer active
	raw := `show errdisable recovery
ErrDisable Reason            Timer Status
-----------------            --------------
arp-inspection               Disabled
bpduguard                    Disabled
channel-misconfig (STP)      Disabled

Timer interval: 300 seconds`
	cfg := parseErrdisableRecovery(raw)
	if !cfg.Enabled {
		t.Error("expected Enabled = true (Timer interval present even though individual causes say Disabled)")
	}
	if cfg.IntervalSec != 300 {
		t.Errorf("expected 300s interval, got %d", cfg.IntervalSec)
	}
}

func TestParseErrdisableRecovery_Disabled(t *testing.T) {
	raw := `
ErrDisable Reason            Timer Status
-----------------            --------------
all                          Disabled
`
	cfg := parseErrdisableRecovery(raw)
	if cfg.Enabled {
		t.Error("expected Enabled = false when output says Disabled")
	}
}

// TODO(real capture): placeholder `show vlan brief` shape, not yet
// validated against IOU. Get a real capture with Et0/1 deliberately
// moved to VLAN 99 (the Fault 2 scenario) before trusting this.
func TestParseVlanBrief(t *testing.T) {
	raw := `
VLAN Name                             Status    Ports
---- -------------------------------- --------- -------------------------------
1    default                          active    Et0/0, Et0/3
99   VLAN0099                         active    Et0/1
`
	vlans := parseVlanBrief(raw)
	if vlans["Et0/0"] != 1 {
		t.Errorf("expected Et0/0 in VLAN 1, got %d", vlans["Et0/0"])
	}
	if vlans["Et0/1"] != 99 {
		t.Errorf("expected Et0/1 in VLAN 99, got %d", vlans["Et0/1"])
	}
	if vlans["Et0/3"] != 1 {
		t.Errorf("expected Et0/3 in VLAN 1, got %d", vlans["Et0/3"])
	}
}

func TestParseVlanBrief_ContinuationLine(t *testing.T) {
	raw := `
VLAN Name                             Status    Ports
---- -------------------------------- --------- -------------------------------
1    default                          active    Et0/0, Et0/2, Et0/3,
                                                 Et1/0
`
	vlans := parseVlanBrief(raw)
	if vlans["Et1/0"] != 1 {
		t.Errorf("expected wrapped port Et1/0 in VLAN 1, got %d", vlans["Et1/0"])
	}
}

func TestParsePingResult(t *testing.T) {
	cases := []struct {
		raw  string
		want bool
	}{
		{"Success rate is 100 percent (3/3), round-trip min/avg/max = 1/1/2 ms", true},
		{"Success rate is 66 percent (2/3), round-trip min/avg/max = 1/1/2 ms", true},
		{"Success rate is 0 percent (0/3)", false},
		{"garbage output with no summary line", false},
	}
	for _, c := range cases {
		if got := parsePingResult(c.raw); got != c.want {
			t.Errorf("parsePingResult(%q) = %v, want %v", c.raw, got, c.want)
		}
	}
}
