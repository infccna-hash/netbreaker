package verify

import (
	"context"
	"fmt"
	"io"
	"net"
	"regexp"
	"strings"
	"time"
)

// TelnetConsoleRunner executes CLI commands on GNS3 nodes via raw TCP
// telnet — headless, no WebSocket. It looks up console ports from the
// session's node_map.
type TelnetConsoleRunner struct {
	host    string              // compute host (Tailscale IP)
	nodeMap map[string]NodeAddr // node name → (host:port)
}

// NodeAddr is the telnet address for a single node.
type NodeAddr struct {
	Host string
	Port int
}

// NewTelnetConsoleRunner builds a runner from the compute host and
// a mapping of node name → console port. nodeMap keys are the same
// logical names used in the topology template (e.g. "SW1", "PC1").
func NewTelnetConsoleRunner(computeHost string, nodes map[string]NodeAddr) *TelnetConsoleRunner {
	return &TelnetConsoleRunner{host: computeHost, nodeMap: nodes}
}

func (r *TelnetConsoleRunner) RunCommand(ctx context.Context, nodeID, cmd string, promptRe *regexp.Regexp) (string, error) {
	addr, ok := r.nodeMap[nodeID]
	if !ok {
		return "", fmt.Errorf("verify: node %q not found in console map", nodeID)
	}

	var dialer net.Dialer
	conn, err := dialer.DialContext(ctx, "tcp", fmt.Sprintf("%s:%d", addr.Host, addr.Port))
	if err != nil {
		return "", fmt.Errorf("verify: dial %s:%d: %w", addr.Host, addr.Port, err)
	}
	defer conn.Close()

	// Set a generous read deadline; the caller's context controls cancellation.
	conn.SetDeadline(time.Now().Add(30 * time.Second))

	// Drain any banner/login output until the prompt appears, then send the
	// command. We use a simple read-until-prompt strategy.
	buf := make([]byte, 4096)

	// Step 1: read until the first prompt (banner + login may precede it)
	if _, err := r.readUntilPrompt(conn, buf, promptRe, 5*time.Second); err != nil {
		return "", fmt.Errorf("verify: wait for prompt on %s: %w", nodeID, err)
	}

	// Step 2: send the command
	if _, err := fmt.Fprintf(conn, "%s\r\n", cmd); err != nil {
		return "", fmt.Errorf("verify: send command to %s: %w", nodeID, err)
	}

	// Step 3: read output until next prompt, collecting everything before it
	output, err := r.readUntilPrompt(conn, buf, promptRe, 15*time.Second)
	if err != nil {
		return "", fmt.Errorf("verify: read output from %s: %w", nodeID, err)
	}

	return output, nil
}

// readUntilPrompt reads from conn into buf until promptRe matches the
// accumulated output, then returns everything read (minus the prompt
// line itself). Callers get the raw command output with the prompt stripped.
func (r *TelnetConsoleRunner) readUntilPrompt(conn net.Conn, buf []byte, promptRe *regexp.Regexp, timeout time.Duration) (string, error) {
	conn.SetReadDeadline(time.Now().Add(timeout))

	var accumulated strings.Builder
	for {
		n, err := conn.Read(buf)
		if n > 0 {
			chunk := string(buf[:n])
			accumulated.WriteString(chunk)
			if promptRe.MatchString(accumulated.String()) {
				// Strip everything from the prompt match onward — return
				// only the command output that preceded the prompt.
				raw := accumulated.String()
				idx := promptRe.FindStringIndex(raw)
				if idx != nil {
					return raw[:idx[0]], nil
				}
				return raw, nil
			}
		}
		if err != nil {
			if err == io.EOF {
				return accumulated.String(), fmt.Errorf("connection closed (accumulated %d bytes)", accumulated.Len())
			}
			if netErr, ok := err.(net.Error); ok && netErr.Timeout() {
				if accumulated.Len() > 0 {
					return accumulated.String(), nil
				}
			}
			return accumulated.String(), err
		}
	}
}
