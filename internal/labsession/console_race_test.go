package labsession

import (
	"context"
	"net"
	"net/http"
	"net/http/httptest"
	"net/url"
	"strings"
	"testing"
	"time"

	"github.com/gorilla/websocket"
)

// TestConsoleBridge_NoWriteRace proves that bridgeConsole does not trigger
// the Go race detector when the ping goroutine and the tcp→ws relay
// goroutine write to the WebSocket connection concurrently.
//
// Single-run race detection under -race is inherently probabilistic —
// whether a particular run observes the interleaving that trips the
// detector depends on goroutine scheduling. To make the test reliable
// we wrap the scenario in 5 independent shots so the compound catch
// probability approaches 100 %.
func TestConsoleBridge_NoWriteRace(t *testing.T) {
	for shot := 0; shot < 5; shot++ {
		runNoWriteRaceShot(t)
	}
}

func runNoWriteRaceShot(t *testing.T) {
	// ── Fake telnet endpoint (stands in for the GNS3 console) ────
	// Blasts output continuously — max concurrency stress on the
	// tcp→ws relay goroutine.
	telnetLis, err := net.Listen("tcp", "127.0.0.1:0")
	if err != nil {
		t.Fatal(err)
	}
	defer telnetLis.Close()

	blastDone := make(chan struct{})
	go func() {
		defer close(blastDone)
		conn, err := telnetLis.Accept()
		if err != nil {
			return
		}
		defer conn.Close()
		// Firehose: 1000-byte chunks as fast as the network accepts them.
		payload := make([]byte, 1000)
		for i := range payload {
			payload[i] = 'x'
		}
		for {
			_, err := conn.Write(payload)
			if err != nil {
				return
			}
		}
	}()

	// ── httptest server with a minimal bridgeConsole wrapper ─────
	srv := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		ws, err := upgrader.Upgrade(w, r, nil)
		if err != nil {
			t.Logf("upgrade failed: %v", err)
			return
		}
		defer ws.Close()

		tcpConn, err := net.DialTimeout("tcp", telnetLis.Addr().String(), 1*time.Second)
		if err != nil {
			t.Logf("dial fake telnet: %v", err)
			return
		}
		defer tcpConn.Close()

		ctx, cancel := context.WithCancel(context.Background())
		defer cancel()

		// Fast timers: pings every 3 ms, pongWait 10 ms, writeWait 5 ms.
		// Dozens of ping/relay interleavings in ~300 ms test duration —
		// enough to reliably trigger a data race if the mutex is missing.
		cfg := ConsoleBridgeConfig{
			PongWait:   10 * time.Millisecond,
			PingPeriod: 3 * time.Millisecond,
			WriteWait:  5 * time.Millisecond,
		}

		bridgeConsole(ctx, cancel, ws, tcpConn, cfg, nil)
	}))
	defer srv.Close()

	// ── Dial the bridge as a real WebSocket client ───────────────
	u, _ := url.Parse(srv.URL)
	u.Scheme = "ws"
	dialer := websocket.Dialer{HandshakeTimeout: 2 * time.Second}
	client, _, err := dialer.Dial(u.String(), nil)
	if err != nil {
		t.Fatal(err)
	}
	defer client.Close()

	// Read incoming frames (the relayed blast) for ~500 ms so that
	// the ping goroutine fires many times while the relay is
	// simultaneously writing.
	deadline := time.After(500 * time.Millisecond)
	for {
		select {
		case <-deadline:
			return // success — no race detected
		default:
		}
		client.SetReadDeadline(time.Now().Add(100 * time.Millisecond))
		_, _, err := client.ReadMessage()
		if err != nil {
			if netErr, ok := err.(net.Error); ok && netErr.Timeout() {
				// Read timeout is expected — the relay may pause
				// briefly. Continue reading until the deadline.
				continue
			}
			// Genuine close or protocol error — the relay has
			// exited. We've run long enough for -race to observe
			// any unsynchronized write.
			if !isClose(err) {
				t.Logf("client read: %v", err)
			}
			return
		}
	}
}

func isClose(err error) bool {
	if err == nil {
		return false
	}
	s := err.Error()
	return strings.Contains(s, "close 1006") ||
		strings.Contains(s, "closed")
}
