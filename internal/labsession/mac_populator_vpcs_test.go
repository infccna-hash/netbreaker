package labsession

import (
	"context"
	"fmt"
	"io"
	"net"
	"strings"
	"sync"
	"testing"
	"time"
)

// TestResolveVPCS_VerboseFormat tests MAC extraction from VPCS verbose output.
func TestResolveVPCS_VerboseFormat(t *testing.T) {
	addr, done := startFakeVPCS(t, fakeVPCSHandler(func(conn net.Conn) {
		// Banner + first prompt
		fmt.Fprint(conn, "Welcome to Virtual PC Simulator, version 0.8b\nPC1> ")
		// Wait for "show" command
		buf := make([]byte, 256)
		n, _ := conn.Read(buf)
		if n > 0 {
			// Send verbose output
			fmt.Fprint(conn, "show\r\nNAME              : PC1\r\nIP/MASK           : 10.0.0.1/24\r\nGATEWAY           : 10.0.0.254\r\nMAC               : 00:50:79:66:68:00\r\nLPORT             : 20000\r\nPC1> ")
		}
	}))
	defer done()

	mac, err := resolveVPCS(context.Background(), gns3NodeProperties{
		NodeType:    "vpcs",
		ConsoleHost: addr.host,
		Console:     addr.port,
	})
	if err != nil {
		t.Fatalf("resolveVPCS: %v", err)
	}
	if mac != "00:50:79:66:68:00" {
		t.Errorf("expected 00:50:79:66:68:00, got %q", mac)
	}
}

// TestResolveVPCS_TabularFormat tests MAC extraction from VPCS tabular output.
func TestResolveVPCS_TabularFormat(t *testing.T) {
	addr, done := startFakeVPCS(t, fakeVPCSHandler(func(conn net.Conn) {
		fmt.Fprint(conn, "PC2> ")
		buf := make([]byte, 256)
		n, _ := conn.Read(buf)
		if n > 0 {
			fmt.Fprint(conn, "show\r\nNAME   IP/MASK              GATEWAY           MAC                LPORT  RHOST:PORT\r\nPC2    10.0.0.5/24          10.0.0.254        00:50:79:66:68:05  20005  127.0.0.1:20006\r\n\r\nPC2> ")
		}
	}))
	defer done()

	mac, err := resolveVPCS(context.Background(), gns3NodeProperties{
		NodeType:    "vpcs",
		ConsoleHost: addr.host,
		Console:     addr.port,
	})
	if err != nil {
		t.Fatalf("resolveVPCS: %v", err)
	}
	if mac != "00:50:79:66:68:05" {
		t.Errorf("expected 00:50:79:66:68:05, got %q", mac)
	}
}

// TestResolveVPCS_DialFailure tests that connection errors propagate.
func TestResolveVPCS_DialFailure(t *testing.T) {
	_, err := resolveVPCS(context.Background(), gns3NodeProperties{
		NodeType:    "vpcs",
		ConsoleHost: "127.0.0.1",
		Console:     19999, // nothing listening
	})
	if err == nil {
		t.Fatal("expected dial error for closed port")
	}
	if !strings.Contains(err.Error(), "console dial") {
		t.Errorf("error should mention console dial: %v", err)
	}
}

// TestResolveVPCS_NoMACInOutput tests that empty MAC is an error.
func TestResolveVPCS_NoMACInOutput(t *testing.T) {
	addr, done := startFakeVPCS(t, fakeVPCSHandler(func(conn net.Conn) {
		fmt.Fprint(conn, "PC1> ")
		buf := make([]byte, 256)
		n, _ := conn.Read(buf)
		if n > 0 {
			// Send output with no MAC
			fmt.Fprint(conn, "show\r\nNo MAC configured\r\nPC1> ")
		}
	}))
	defer done()

	_, err := resolveVPCS(context.Background(), gns3NodeProperties{
		NodeType:    "vpcs",
		ConsoleHost: addr.host,
		Console:     addr.port,
	})
	if err == nil {
		t.Fatal("expected error for output with no MAC")
	}
	if !strings.Contains(err.Error(), "no MAC address") {
		t.Errorf("error should mention no MAC: %v", err)
	}
}

// TestResolveVPCS_ContextCancelled tests that a cancelled context is respected.
func TestResolveVPCS_ContextCancelled(t *testing.T) {
	addr, done := startFakeVPCS(t, fakeVPCSHandler(func(conn net.Conn) {
		// Never send anything — client's context should time out
		time.Sleep(5 * time.Second)
	}))
	defer done()

	ctx, cancel := context.WithTimeout(context.Background(), 500*time.Millisecond)
	defer cancel()

	_, err := resolveVPCS(ctx, gns3NodeProperties{
		NodeType:    "vpcs",
		ConsoleHost: addr.host,
		Console:     addr.port,
	})
	if err == nil {
		t.Fatal("expected timeout error")
	}
}

// TestParseVPCSMAC covers both output formats and edge cases.
func TestParseVPCSMAC(t *testing.T) {
	tests := []struct {
		name   string
		output string
		want   string
	}{
		{
			name: "verbose",
			output: "show\r\nNAME              : PC1\r\n" +
				"MAC               : 00:50:79:66:68:00\r\n" +
				"PC1> ",
			want: "00:50:79:66:68:00",
		},
		{
			name: "tabular",
			output: "show\r\nNAME   IP/MASK              GATEWAY           MAC                LPORT\r\n" +
				"PC1    10.0.0.1/24          10.0.0.254        00:11:22:33:44:55  20001\r\n" +
				"PC1> ",
			want: "00:11:22:33:44:55",
		},
		{
			name:   "no MAC",
			output: "show\r\nNo MAC configured\r\nPC1> ",
			want:   "",
		},
		{
			name:   "empty",
			output: "",
			want:   "",
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got := parseVPCSMAC(tt.output)
			if got != tt.want {
				t.Errorf("parseVPCSMAC() = %q, want %q", got, tt.want)
			}
		})
	}
}

// TestResolveVPCS_ThroughResolveMAC verifies the strategy map path.
func TestResolveVPCS_ThroughResolveMAC(t *testing.T) {
	addr, done := startFakeVPCS(t, fakeVPCSHandler(func(conn net.Conn) {
		fmt.Fprint(conn, "PC3> ")
		buf := make([]byte, 256)
		n, _ := conn.Read(buf)
		if n > 0 {
			fmt.Fprint(conn, "show\r\nMAC : aa:bb:cc:dd:ee:ff\r\nPC3> ")
		}
	}))
	defer done()

	mac, err := ResolveMAC(context.Background(), gns3NodeProperties{
		NodeType:    "vpcs",
		ConsoleHost: addr.host,
		Console:     addr.port,
	})
	if err != nil {
		t.Fatalf("ResolveMAC(vpcs): %v", err)
	}
	if mac != "aa:bb:cc:dd:ee:ff" {
		t.Errorf("expected aa:bb:cc:dd:ee:ff, got %q", mac)
	}
}

// --- Fake VPCS server ---

type listenAddr struct {
	host string
	port int
}

// fakeVPCSHandler is a function that handles one VPCS client connection.
// It receives the connected socket and should simulate the VPCS protocol.
type fakeVPCSHandler func(conn net.Conn)

// startFakeVPCS starts a TCP server on a random port. The handler function
// runs in a goroutine for each accepted connection (only one expected).
// Returns the listen address and a cleanup function.
func startFakeVPCS(t *testing.T, handler fakeVPCSHandler) (listenAddr, func()) {
	t.Helper()

	ln, err := net.Listen("tcp", "127.0.0.1:0")
	if err != nil {
		t.Fatalf("fake VPCS listen: %v", err)
	}

	addr := ln.Addr().(*net.TCPAddr)
	la := listenAddr{host: "127.0.0.1", port: addr.Port}

	var wg sync.WaitGroup
	wg.Add(1)
	go func() {
		defer wg.Done()
		conn, err := ln.Accept()
		if err != nil {
			return
		}
		defer conn.Close()
		// Give the handler a write deadline so tests don't hang
		conn.SetDeadline(time.Now().Add(5 * time.Second))
		handler(conn)
		// Drain any remaining bytes the handler didn't read
		io.Copy(io.Discard, conn)
	}()

	done := func() {
		ln.Close()
		wg.Wait()
	}
	return la, done
}
