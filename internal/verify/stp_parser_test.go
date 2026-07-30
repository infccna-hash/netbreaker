package verify

import "testing"

// Real captures from Lab 2 IOU session (2026-07-30).
// SW1: root bridge (priority 32769, MAC aabb.cc00.0c00)
// SW2: non-root (bridge aabb.cc00.0d00, root port Et0/1, Et0/3 Altn BLK)
// SW3: non-root (bridge aabb.cc00.0e00, root port Et0/1, Et0/3 Altn BLK)

const sw1STP = `VLAN0001
  Spanning tree enabled protocol ieee
  Root ID    Priority    32769
             Address     aabb.cc00.0c00
             This bridge is the root
             Hello Time   2 sec  Max Age 20 sec  Forward Delay 15 sec

  Bridge ID  Priority    32769  (priority 32768 sys-id-ext 1)
             Address     aabb.cc00.0c00
             Hello Time   2 sec  Max Age 20 sec  Forward Delay 15 sec
             Aging Time  300 sec

Interface           Role Sts Cost      Prio.Nbr Type
------------------- ---- --- --------- -------- --------------------------------
Et0/0               Desg FWD 100       128.1    Shr 
Et0/1               Desg FWD 100       128.2    Shr 
Et0/2               Desg FWD 100       128.3    Shr 
Et0/3               Desg FWD 100       128.4    Shr 
Et1/0               Desg FWD 100       128.5    Shr 
Et1/1               Desg FWD 100       128.6    Shr 
Et1/2               Desg FWD 100       128.7    Shr 
Et1/3               Desg FWD 100       128.8    Shr`

const sw2STP = `VLAN0001
  Spanning tree enabled protocol ieee
  Root ID    Priority    32769
             Address     aabb.cc00.0c00
             Cost        100
             Port        2 (Ethernet0/1)
             Hello Time   2 sec  Max Age 20 sec  Forward Delay 15 sec

  Bridge ID  Priority    32769  (priority 32768 sys-id-ext 1)
             Address     aabb.cc00.0d00
             Hello Time   2 sec  Max Age 20 sec  Forward Delay 15 sec
             Aging Time  300 sec

Interface           Role Sts Cost      Prio.Nbr Type
------------------- ---- --- --------- -------- --------------------------------
Et0/0               Desg FWD 100       128.1    Shr 
Et0/1               Root FWD 100       128.2    Shr 
Et0/2               Desg FWD 100       128.3    Shr 
Et0/3               Altn BLK 100       128.4    Shr 
Et1/0               Desg FWD 100       128.5    Shr 
Et1/1               Desg FWD 100       128.6    Shr 
Et1/2               Desg FWD 100       128.7    Shr 
Et1/3               Desg FWD 100       128.8    Shr`

const sw3STP = `VLAN0001
  Spanning tree enabled protocol ieee
  Root ID    Priority    32769
             Address     aabb.cc00.0c00
             Cost        100
             Port        2 (Ethernet0/1)
             Hello Time   2 sec  Max Age 20 sec  Forward Delay 15 sec

  Bridge ID  Priority    32769  (priority 32768 sys-id-ext 1)
             Address     aabb.cc00.0e00
             Hello Time   2 sec  Max Age 20 sec  Forward Delay 15 sec
             Aging Time  300 sec

Interface           Role Sts Cost      Prio.Nbr Type
------------------- ---- --- --------- -------- --------------------------------
Et0/0               Desg FWD 100       128.1    Shr 
Et0/1               Root FWD 100       128.2    Shr 
Et0/2               Desg FWD 100       128.3    Shr 
Et0/3               Altn BLK 100       128.4    Shr 
Et1/0               Desg FWD 100       128.5    Shr 
Et1/1               Desg FWD 100       128.6    Shr 
Et1/2               Desg FWD 100       128.7    Shr 
Et1/3               Desg FWD 100       128.8    Shr`

func TestParseSTP_RootBridge(t *testing.T) {
	info, err := ParseSTP(sw1STP)
	if err != nil {
		t.Fatal(err)
	}
	if !info.IsRoot {
		t.Error("SW1 should be root")
	}
	if info.RootMAC != info.BridgeMAC {
		t.Errorf("root MAC %s != bridge MAC %s on root bridge", info.RootMAC, info.BridgeMAC)
	}
	if len(info.PortRoles) == 0 {
		t.Error("no port roles parsed")
	}
	// All ports on root are Designated
	for iface, role := range info.PortRoles {
		if role != "Desg" {
			t.Errorf("%s: expected Desg, got %s", iface, role)
		}
	}
}

func TestParseSTP_NonRoot(t *testing.T) {
	info, err := ParseSTP(sw2STP)
	if err != nil {
		t.Fatal(err)
	}
	if info.IsRoot {
		t.Error("SW2 should NOT be root")
	}
	if info.RootMAC == "" {
		t.Error("root MAC not parsed")
	}
	if info.BridgeMAC == "" {
		t.Error("bridge MAC not parsed")
	}

	// SW2: Et0/1 is Root port, Et0/3 is Altn (blocked link)
	if role := info.PortRoles["Et0/1"]; role != "Root" {
		t.Errorf("Et0/1: expected Root, got %s", role)
	}
	if role := info.PortRoles["Et0/3"]; role != "Altn" {
		t.Errorf("Et0/3: expected Altn, got %s (blocked link)", role)
	}
}

func TestParseSTP_SW3(t *testing.T) {
	info, err := ParseSTP(sw3STP)
	if err != nil {
		t.Fatal(err)
	}
	if info.IsRoot {
		t.Error("SW3 should NOT be root")
	}

	// SW3: Et0/1 is Root port, Et0/3 is Altn (other end of blocked link)
	if role := info.PortRoles["Et0/1"]; role != "Root" {
		t.Errorf("Et0/1: expected Root, got %s", role)
	}
	if role := info.PortRoles["Et0/3"]; role != "Altn" {
		t.Errorf("Et0/3: expected Altn, got %s", role)
	}
}

func TestParseSTP_RoundTripAllThree(t *testing.T) {
	for name, out := range map[string]string{"SW1": sw1STP, "SW2": sw2STP, "SW3": sw3STP} {
		info, err := ParseSTP(out)
		if err != nil {
			t.Errorf("%s: %v", name, err)
			continue
		}
		// Every switch must parse at least 4 interface rows
		if len(info.PortRoles) < 4 {
			t.Errorf("%s: only %d port roles, expected >= 4", name, len(info.PortRoles))
		}
		// RootMAC must always be parsed
		if info.RootMAC == "" {
			t.Errorf("%s: root MAC not parsed", name)
		}
	}
}
