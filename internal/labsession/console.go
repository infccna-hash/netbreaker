package labsession

import (
	"context"
	"fmt"
	"log"
	"net"
	"net/http"
	"time"

	"github.com/go-chi/chi/v5"
	"github.com/google/uuid"
	"github.com/gorilla/websocket"
)

var upgrader = websocket.Upgrader{
	ReadBufferSize:  4096,
	WriteBufferSize: 4096,
	// Same-origin by design (Caddy proxies same-origin to the API).
	// Tightened from the wide-open CheckOrigin to a proper check below.
	CheckOrigin: checkSameOrigin,
}

// checkSameOrigin returns true when the Origin header matches this server's
// own origin — same rule Caddy enforces at the proxy layer.
func checkSameOrigin(r *http.Request) bool {
	origin := r.Header.Get("Origin")
	if origin == "" {
		// No origin header = not a browser-initiated WebSocket.
		// Allow CLI/testing clients through.
		return true
	}
	// Compare against the Host header; in production behind Caddy this
	// is the actual domain, not an IP.
	scheme := "http"
	if r.TLS != nil {
		scheme = "https"
	}
	expected := fmt.Sprintf("%s://%s", scheme, r.Host)
	return origin == expected
}

func (h *Handler) console(w http.ResponseWriter, r *http.Request) {
	userID, _ := authFromContext(r.Context())

	sessionID, err := uuid.Parse(chi.URLParam(r, "id"))
	if err != nil {
		http.Error(w, "invalid session id", http.StatusBadRequest)
		return
	}
	nodeName := chi.URLParam(r, "node")

	sess, err := h.svc.Get(r.Context(), sessionID)
	if err != nil {
		http.Error(w, "session not found", http.StatusNotFound)
		return
	}

	// ── Auth: verify this session belongs to the requesting user ──────
	if sess.UserID != userID {
		http.Error(w, "session does not belong to this user", http.StatusForbidden)
		return
	}

	if sess.Status != StatusRunning {
		http.Error(w, "session not running", http.StatusConflict)
		return
	}

	nodeInfo, ok := sess.NodeMap[nodeName]
	if !ok {
		http.Error(w, "unknown node", http.StatusNotFound)
		return
	}

	// QEMU nodes (Kali, OpenWRT) use VNC console, not telnet.
	// The console bridge only supports telnet for now.
	if nodeInfo.ConsoleType == "vnc" {
		ws, err := upgrader.Upgrade(w, r, nil)
		if err != nil {
			log.Printf("console upgrade failed: %v", err)
			return
		}
		defer ws.Close()
		msg := fmt.Sprintf("\r\n\x1b[33m[VNC console not yet supported via browser. Use a VNC client (e.g. TigerVNC) on port %d]\x1b[0m\r\n", nodeInfo.ConsolePort)
		ws.WriteMessage(websocket.TextMessage, []byte(msg))
		return
	}

	ws, err := upgrader.Upgrade(w, r, nil)
	if err != nil {
		log.Printf("console upgrade failed: %v", err)
		return
	}
	defer ws.Close()

	// GNS3 console ports are plain telnet on the compute host.
	telnetAddr := fmt.Sprintf("%s:%d", h.svc.computeHost, nodeInfo.ConsolePort)
	tcpConn, err := net.DialTimeout("tcp", telnetAddr, 5*time.Second)
	if err != nil {
		ws.WriteMessage(websocket.TextMessage, []byte("\r\n\x1b[31m[console: compute host unreachable]\x1b[0m\r\n"))
		return
	}
	defer tcpConn.Close()

	// Set a keepalive so a hung console half-open doesn't leak
	if tcp, ok := tcpConn.(*net.TCPConn); ok {
		tcp.SetKeepAlive(true)
		tcp.SetKeepAlivePeriod(30 * time.Second)
	}

	ctx, cancel := context.WithCancel(r.Context())
	defer cancel()

	// tcp → websocket (GNS3 console output → browser)
	go func() {
		defer cancel()
		buf := make([]byte, 4096)
		for {
			n, err := tcpConn.Read(buf)
			if n > 0 {
				if werr := ws.WriteMessage(websocket.BinaryMessage, buf[:n]); werr != nil {
					return
				}
			}
			if err != nil {
				return
			}
		}
	}()

	// websocket → tcp (keystrokes → GNS3 console), with heartbeat-on-keystroke
	lastTouch := time.Now()
	for {
		_, msg, err := ws.ReadMessage()
		if err != nil {
			break
		}
		if _, err := tcpConn.Write(msg); err != nil {
			break
		}
		// Throttle: touch at most once per ~20s of activity
		if time.Since(lastTouch) > 20*time.Second {
			_ = h.svc.Heartbeat(ctx, sessionID)
			lastTouch = time.Now()
		}
	}
}
