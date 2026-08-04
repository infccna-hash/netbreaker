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
//
// THREAD SAFETY: TelnetConsoleRunner opens a dedicated TCP connection per
// RunCommand call and closes it on return. It is safe for concurrent use
// across different nodes, but two concurrent calls targeting the same
// (host, port) will race on the same console channel. The caller (HTTP
// handler or ConsoleRunner orchestrator) MUST serialize calls per
// (session, node) pair. See ios_collector.go for the concurrency spec.
//
// INTERACTIVE CONSOLE CONFLICT: this runner dials the console port
// independently of any WebSocket interactive session (console.go). Two
// simultaneous TCP connections to the same IOU/dynamips console port
// produce undefined behavior. The handler MUST acquire a per-node lock
// that is shared between the verify path and the interactive-console
// path before calling RunCommand.
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

	buf := make([]byte, 4096)

	// Step 1: read until the first prompt (banner + login may precede it)
	// GNS3 IOU consoles send telnet IAC negotiation bytes on connect and
	// wait for input before printing the prompt — nudge with a CR so the
	// prompt appears, then read until it does. Without the nudge the read
	// blocks forever on the 12 IAC bytes (observed 2026-08-04: every
	// console-truth verifier timed out at "wait for prompt").
	fmt.Fprintf(conn, "\r\n")
	if _, err := r.readUntilPrompt(ctx, conn, buf, promptRe); err != nil {
		return "", fmt.Errorf("verify: wait for prompt on %s: %w", nodeID, err)
	}

	// Step 2: disable pagination so long output (show mac address-table,
	// show running-config) doesn't hang at --More--.
	// This is fire-and-forget — if the device doesn't support it, the
	// next readUntilPrompt will still complete (or time out clearly).
	//
	// We send it and re-read the prompt to ensure the command was
	// consumed before proceeding to the actual data-gathering command.
	fmt.Fprintf(conn, "terminal length 0\r\n")
	if _, err := r.readUntilPrompt(ctx, conn, buf, promptRe); err != nil {
		return "", fmt.Errorf("verify: terminal length 0 on %s: %w", nodeID, err)
	}

	// Step 3: send the actual command
	if _, err := fmt.Fprintf(conn, "%s\r\n", cmd); err != nil {
		return "", fmt.Errorf("verify: send command to %s: %w", nodeID, err)
	}

	// Step 4: read output until next prompt, collecting everything before it
	output, err := r.readUntilPrompt(ctx, conn, buf, promptRe)
	if err != nil {
		return "", fmt.Errorf("verify: read output from %s: %w", nodeID, err)
	}

	return output, nil
}

// readUntilPrompt reads from conn into buf until promptRe matches the
// accumulated output, then returns everything read (minus the prompt
// line itself). Callers get the raw command output with the prompt stripped.
//
// The ctx's deadline (if any) controls the per-read timeout; a read that
// produces data resets the timer. This means a hung device with no output
// is caught quickly (ctx deadline), but a streaming device producing data
// one byte at a time is allowed to continue until the overall ctx expires.
func (r *TelnetConsoleRunner) readUntilPrompt(ctx context.Context, conn net.Conn, buf []byte, promptRe *regexp.Regexp) (string, error) {
	// Default per-read timeout when ctx has no deadline
	const defaultReadTimeout = 15 * time.Second

	var accumulated strings.Builder
	for {
		// Set a per-read deadline derived from the context.
		// If ctx has a deadline, use the remaining time (capped).
		// If ctx has no deadline, use a generous default.
		readTimeout := defaultReadTimeout
		if deadline, ok := ctx.Deadline(); ok {
			remaining := time.Until(deadline)
			if remaining <= 0 {
				return accumulated.String(), ctx.Err()
			}
			// Cap at defaultReadTimeout so a single read doesn't
			// block for the entire remaining ctx lifetime — we
			// want to check for prompt matches between reads.
			if remaining < readTimeout {
				readTimeout = remaining
			}
		}
		conn.SetReadDeadline(time.Now().Add(readTimeout))

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
			// Accumulated data with a read timeout means the device
			// stopped sending (likely pagination / --More--). Return
			// what we have with a diagnostic error.
			if netErr, ok := err.(net.Error); ok && netErr.Timeout() {
				if accumulated.Len() > 0 {
					return accumulated.String(), fmt.Errorf("read timeout after %d bytes (pagination blocking? terminal length 0 may not have been applied)", accumulated.Len())
				}
			}
			// Context cancellation takes precedence over I/O errors
			// only when we have no accumulated data to return.
			if ctx.Err() != nil && accumulated.Len() == 0 {
				return accumulated.String(), ctx.Err()
			}
			if err == io.EOF {
				return accumulated.String(), fmt.Errorf("connection closed (accumulated %d bytes)", accumulated.Len())
			}
			return accumulated.String(), err
		}
	}
}
