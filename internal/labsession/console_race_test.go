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
// The test stress-config uses generous timeouts (PongWait=500ms,
// WriteWait=500ms, PingPeriod=3ms) so that the shot runs its full
// read window rather than being cut short by a write-edge timeout
// cascade under -race slowdown.
func TestConsoleBridge_NoWriteRace(t *testing.T) {
	for shot := 0; shot < 5; shot++ {
		runNoWriteRaceShot(t)
	}
}

func runNoWriteRaceShot(t *testing.T) {
	shotStart := time.Now()

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

		cfg := ConsoleBridgeConfig{
			PongWait:   500 * time.Millisecond,
			PingPeriod: 3 * time.Millisecond,
			WriteWait:  500 * time.Millisecond,
		}

		bridgeConsole(ctx, cancel, ws, tcpConn, cfg, nil)
	}))
	defer srv.Close()

	u, _ := url.Parse(srv.URL)
	u.Scheme = "ws"
	dialer := websocket.Dialer{HandshakeTimeout: 2 * time.Second}
	client, _, err := dialer.Dial(u.String(), nil)
	if err != nil {
		t.Fatal(err)
	}
	defer client.Close()

	client.SetReadDeadline(time.Now().Add(500 * time.Millisecond))
	for {
		_, _, err := client.ReadMessage()
		if err != nil {
			if !isClose(err) {
				t.Logf("client read: %v", err)
			}
			break
		}
	}

	t.Logf("shot duration: %v", time.Since(shotStart).Round(time.Millisecond))
}

func isClose(err error) bool {
	if err == nil {
		return false
	}
	s := err.Error()
	return strings.Contains(s, "close 1006") ||
		strings.Contains(s, "closed")
}
