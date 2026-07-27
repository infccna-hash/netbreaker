package labsession

import (
	"context"
	"fmt"
	"log"
	"net"
	"net/http"
	"strings"
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

// checkSameOrigin returns true when the Origin header belongs to the same
// site as this API server. Behind Caddy the Host header is e.g.
// "api.netbreaker.io" while the frontend sends "https://netbreaker.io".
// Those are the same site — the check extracts hostnames (ignoring scheme
// and port) and compares them after stripping a leading "api." subdomain
// from the Host side, so the API subdomain doesn't block frontend origins.
func checkSameOrigin(r *http.Request) bool {
	origin := r.Header.Get("Origin")
	if origin == "" {
		// No origin header = not a browser-initiated WebSocket.
		// Allow CLI/testing clients through.
		return true
	}

	// Extract hostname from Origin (strip scheme and port).
	originHost := origin
	if after, ok := strings.CutPrefix(originHost, "https://"); ok {
		originHost = after
	} else if after, ok := strings.CutPrefix(originHost, "http://"); ok {
		originHost = after
	}
	if idx := strings.IndexByte(originHost, ':'); idx >= 0 {
		originHost = originHost[:idx]
	}

	// Host as seen by the API (e.g. "api.netbreaker.io").
	host := r.Host
	if idx := strings.IndexByte(host, ':'); idx >= 0 {
		host = host[:idx]
	}

	// Exact match (same hostname).
	if strings.EqualFold(originHost, host) {
		return true
	}

	// Subdomain match: strip known service prefixes (api., app.) from
	// both hostnames, then compare the remaining root domain.
	// "https://netbreaker.io" ↔ "api.netbreaker.io" → strip api. → netbreaker.io = netbreaker.io ✅
	// "https://app.netbreaker.io" ↔ "api.netbreaker.io" → strip both → netbreaker.io = netbreaker.io ✅
	knownPrefixes := []string{"api.", "app."}
	hostBase := host
	originBase := originHost
	for _, p := range knownPrefixes {
		if s, ok := strings.CutPrefix(hostBase, p); ok {
			hostBase = s
			break
		}
	}
	for _, p := range knownPrefixes {
		if s, ok := strings.CutPrefix(originBase, p); ok {
			originBase = s
			break
		}
	}
	return strings.EqualFold(originBase, hostBase)
}


// usesVNCConsole reports whether a node's console is VNC (which the telnet-only
// browser bridge can't render) and should therefore be surfaced to the user as
// a "connect a VNC client" hint rather than attempted as telnet.
//
// It checks node type in addition to console_type on purpose: GNS3 often has
// not assigned console_type yet at the moment we capture NodeInfo during
// provisioning, so ConsoleType can be empty for a Kali/QEMU node. NodeType comes
// straight from the topology template and is always known, so it is the
// reliable signal. Any QEMU node in this catalog (Kali, OpenWRT) is VNC.
func usesVNCConsole(n NodeInfo) bool {
	return n.ConsoleType == "vnc" || n.NodeType == "qemu"
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

	// QEMU nodes (Kali, OpenWRT) expose a VNC console, which the browser
	// terminal bridge (telnet-only) can't render. Detect these by NODE TYPE as
	// well as console_type: GNS3 frequently hasn't assigned console_type at the
	// moment we provision, so keying only off ConsoleType leaves the user
	// staring at a bare "[disconnected]" with no guidance. NodeType is known
	// deterministically from the topology template and is populated at provision.
	if usesVNCConsole(nodeInfo) {
		ws, err := upgrader.Upgrade(w, r, nil)
		if err != nil {
			log.Printf("console upgrade failed: %v", err)
			return
		}
		defer ws.Close()
		msg := fmt.Sprintf(
			"\r\n\x1b[33m[This node has a VNC console, which the browser terminal can't display.\r\n"+
				"Connect a VNC client (e.g. TigerVNC) to %s:%d to use it.]\x1b[0m\r\n",
			h.svc.computeHost, nodeInfo.ConsolePort)
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

	ctx, cancel := context.WithCancel(context.Background()) // bg: survive chi Timeout(30s) middleware
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

	// Keep-alive ticker: send a heartbeat every 60s while the websocket
	// remains open. Without this, a user reading a lab phase without
	// typing for >GNS3_IDLE_TIMEOUT (default 15m) gets reaped — the
	// session is suspended, all consoles disconnect, and unsaved device
	// config is lost. The keystroke heartbeat above still fires on
	// activity for fine-grained last_active_at tracking; this ticker is
	// the safety net for thinking/reading pauses.
	keepAlive := time.NewTicker(60 * time.Second)
	defer keepAlive.Stop()
	go func() {
		for {
			select {
			case <-keepAlive.C:
				_ = h.svc.Heartbeat(ctx, sessionID)
			case <-ctx.Done():
				return
			}
		}
	}()

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
