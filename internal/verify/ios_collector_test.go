package verify

import (
	"context"
	"net"
	"regexp"
	"strings"
	"testing"
	"time"
)

// TestCollectSTP_WiredToParser is the negative control for P0-1: the
// collector must run `show spanning-tree vlan 1` and hand the output
// to ParseSTP — NOT return ErrNotImplemented (which silently blocked
// every Lab 2 grader pass before 2026-08-04).
//
// It drives a fake console that responds to the full CLI handshake and
// serves a real SW3-style STP capture (the exact topology we verified
// in the walkthrough: non-root, Et0/3 Altn BLK).
func TestCollectSTP_WiredToParser(t *testing.T) {
	const stpOut = "\r\n" +
		"VLAN0001\r\n" +
		"  Spanning tree enabled protocol ieee\r\n" +
		"  Root ID    Priority    32769\r\n" +
		"             Address     aabb.cc00.0100\r\n" +
		"  Bridge ID  Priority    32769  (priority 32768 sys-id-ext 1)\r\n" +
		"             Address     aabb.cc00.0500\r\n" +
		"Interface           Role Sts Cost      Prio.Nbr Type\r\n" +
		"------------------- ---- --- --------- -------- --------------------------------\r\n" +
		"Et0/1               Root FWD 100       128.2    Shr \r\n" +
		"Et0/3               Altn BLK 100       128.4    Shr \r\n"

	handler := func(conn net.Conn) {
		buf := make([]byte, 4096)
		// Regression: the IOU console replays a previous command's
		// pending output to the new connection. It arrives during the
		// FIRST drain — the runner must flush it (and the prompt inside
		// it) before the handshake proceeds, so the real STP output
		// isn't misattributed.
		conn.Read(buf) // drain nudge 1
		conn.Write([]byte("\xff\xfb\x01\xff\xfb\x03\xff\xfb\x00\xff\xfd\x00an 1\r\nVLAN0001\r\n  Spanning tree enabled protocol ieee\r\nEt0/3               Altn BLK 100       128.4    Shr \r\nSW3#\r\n\r\nSW3#"))

		// remaining 2 drain nudges
		conn.Read(buf)
		conn.Write([]byte("\r\nSW3#"))
		conn.Read(buf)
		conn.Write([]byte("\r\nSW3#"))

		// terminal length 0
		conn.Read(buf)
		conn.Write([]byte("\r\nterminal length 0\r\nSW3#"))

		// the actual command
		conn.Read(buf)
		conn.Write([]byte(stpOut + "SW3#"))
	}

	addr, cleanup := fakeConsole(t, handler)
	defer cleanup()

	host, port := parseAddr(t, addr)
	runner := NewTelnetConsoleRunner(host, map[string]NodeAddr{
		"SW3": {Host: host, Port: port},
	})
	collector := &IOSCollector{
		Console:  runner,
		NodeID:   "SW3",
		PromptRe: regexp.MustCompile(`SW3#`),
	}

	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	info, err := collector.CollectSTP(ctx)
	if err != nil {
		t.Fatalf("CollectSTP returned error (stub regression?): %v", err)
	}
	if info.IsRoot {
		t.Error("SW3 should not be root in this capture")
	}
	if info.RootMAC != "aa:bb:cc:00:01:00" {
		t.Errorf("RootMAC = %q, want aa:bb:cc:00:01:00", info.RootMAC)
	}
	if role, ok := info.PortRoles["Et0/3"]; !ok || role != "Altn" {
		t.Errorf("PortRoles[Et0/3] = %q, ok=%v — want Altn (the console-truth blocked port)", role, ok)
	}
	if role, ok := info.PortRoles["Et0/1"]; !ok || role != "Root" {
		t.Errorf("PortRoles[Et0/1] = %q, ok=%v — want Root", role, ok)
	}
}

// TestCollectPortSecurity_WiredToParser is the negative control for
// the Lab 3 collector: must parse a real `show port-security
// interface` response, not ErrNotImplemented.
func TestCollectPortSecurity_WiredToParser(t *testing.T) {
	const psOut = "\r\n" +
		"Port Security              : Enabled\r\n" +
		"Maximum MAC Addresses      : 2\r\n" +
		"Security Violation Count   : 1\r\n" +
		"Violation Mode             : Shutdown\r\n" +
		"Sticky MAC Addresses       : 0\r\n"

	handler := func(conn net.Conn) {
		buf := make([]byte, 4096)
		conn.Write([]byte("\xff\xfb\x01\xff\xfb\x03\xff\xfb\x00\xff\xfd\x00"))
		iouHandshake(conn, buf, "SW1#")
		conn.Write([]byte(psOut + "SW1#"))
	}

	addr, cleanup := fakeConsole(t, handler)
	defer cleanup()

	host, port := parseAddr(t, addr)
	runner := NewTelnetConsoleRunner(host, map[string]NodeAddr{
		"SW1": {Host: host, Port: port},
	})
	collector := &IOSCollector{
		Console:  runner,
		NodeID:   "SW1",
		PromptRe: regexp.MustCompile(`SW1#`),
	}

	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	info, err := collector.CollectPortSecurity(ctx, "Ethernet0/2")
	if err != nil {
		t.Fatalf("CollectPortSecurity returned error (stub regression?): %v", err)
	}
	if !info.Enabled {
		t.Error("port-security should be Enabled")
	}
	if info.MaxMACs != 2 {
		t.Errorf("MaxMACs = %d, want 2", info.MaxMACs)
	}
	if info.ViolationCount != 1 {
		t.Errorf("ViolationCount = %d, want 1", info.ViolationCount)
	}
	if !strings.EqualFold(info.ViolationMode, "shutdown") {
		t.Errorf("ViolationMode = %q, want shutdown", info.ViolationMode)
	}
}
