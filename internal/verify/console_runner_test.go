package verify

import (
	"context"
	"fmt"
	"net"
	"regexp"
	"strings"
	"sync"
	"testing"
	"time"
)

// fakeConsole starts a TCP listener that responds to CLI commands.
func fakeConsole(t *testing.T, handler func(conn net.Conn)) (addr string, cleanup func()) {
	t.Helper()
	l, err := net.Listen("tcp", "127.0.0.1:0")
	if err != nil {
		t.Fatalf("listen: %v", err)
	}
	addr = l.Addr().String()
	done := make(chan struct{})
	go func() {
		defer close(done)
		conn, err := l.Accept()
		if err != nil {
			return
		}
		handler(conn)
		conn.Close()
	}()
	cleanup = func() {
		l.Close()
		<-done
	}
	return addr, cleanup
}

func parseAddr(t *testing.T, s string) (string, int) {
	t.Helper()
	host, portStr, err := net.SplitHostPort(s)
	if err != nil {
		t.Fatalf("split host port %q: %v", s, err)
	}
	var port int
	fmt.Sscanf(portStr, "%d", &port)
	return host, port
}

func devicePromptRe(suffix string) *regexp.Regexp {
	return regexp.MustCompile(regexp.QuoteMeta(suffix))
}

func TestRunCommand_BasicExecution(t *testing.T) {
	handler := func(conn net.Conn) {
		buf := make([]byte, 4096)

		// Step 1: consume the runner's CR nudge, then prompt.
		conn.Read(buf)
		conn.Write([]byte("\r\nRouter#"))

		// Terminal length 0 handshake
		conn.Read(buf)
		conn.Write([]byte("\r\nterminal length 0\r\nRouter#"))

		// Read command, send output with prompt
		conn.Read(buf)
		conn.Write([]byte("\r\nshow version\r\nCisco IOS Software, Version 15.1\r\nRouter#"))
	}

	addr, cleanup := fakeConsole(t, handler)
	defer cleanup()

	host, port := parseAddr(t, addr)
	runner := NewTelnetConsoleRunner(host, map[string]NodeAddr{
		"R1": {Host: host, Port: port},
	})

	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	output, err := runner.RunCommand(ctx, "R1", "show version", devicePromptRe("Router#"))
	if err != nil {
		t.Fatalf("RunCommand: %v", err)
	}
	if !strings.Contains(output, "Cisco IOS Software") {
		t.Errorf("expected 'Cisco IOS Software' in output, got: %q", output)
	}
}

func TestRunCommand_PromptStripping(t *testing.T) {
	// Manual handshake (not deviceRespond) to avoid the localhost
	// race where the next command's prompt arrives before the
	// client finishes consuming the current response.
	handler := func(conn net.Conn) {
		buf := make([]byte, 4096)

		// Step 1: consume the runner's CR nudge, then prompt.
		conn.Read(buf)
		conn.Write([]byte("\r\nSwitch#"))

		// Terminal length 0 handshake
		conn.Read(buf)
		conn.Write([]byte("\r\nterminal length 0\r\nSwitch#"))

		// Read command, send output with prompt
		conn.Read(buf)
		conn.Write([]byte("\r\nshow vlan\r\nVLAN0010 active\r\nVLAN0020 active\r\nSwitch#"))
	}

	addr, cleanup := fakeConsole(t, handler)
	defer cleanup()

	host, port := parseAddr(t, addr)
	runner := NewTelnetConsoleRunner(host, map[string]NodeAddr{
		"SW1": {Host: host, Port: port},
	})

	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	output, err := runner.RunCommand(ctx, "SW1", "show vlan", devicePromptRe("Switch#"))
	if err != nil {
		t.Fatalf("RunCommand: %v", err)
	}
	if strings.Contains(output, "Switch#") {
		t.Errorf("output contains un-stripped prompt: %q", output)
	}
	if !strings.Contains(output, "VLAN0010") {
		t.Errorf("expected VLAN0010 in output, got: %q", output)
	}
}

func TestRunCommand_NodeNotFound(t *testing.T) {
	runner := NewTelnetConsoleRunner("localhost", map[string]NodeAddr{})
	_, err := runner.RunCommand(context.Background(), "NONEXISTENT", "show version", devicePromptRe("#"))
	if err == nil {
		t.Fatal("expected error for unknown node, got nil")
	}
	if !strings.Contains(err.Error(), "not found") {
		t.Errorf("error should mention 'not found': %v", err)
	}
}

func TestRunCommand_ContextCancellation(t *testing.T) {
	var wg sync.WaitGroup
	wg.Add(1)

	handler := func(conn net.Conn) {
		defer wg.Done()
		buf := make([]byte, 4096)
		conn.Read(buf) // consumes the CR nudge
		conn.Write([]byte("\r\nRouter#"))
		conn.Read(buf) // consumes terminal length 0
		<-time.After(10 * time.Second)
	}

	addr, cleanup := fakeConsole(t, handler)
	defer cleanup()

	host, port := parseAddr(t, addr)
	runner := NewTelnetConsoleRunner(host, map[string]NodeAddr{
		"R1": {Host: host, Port: port},
	})

	ctx, cancel := context.WithTimeout(context.Background(), 500*time.Millisecond)
	defer cancel()

	_, err := runner.RunCommand(ctx, "R1", "show version", devicePromptRe("Router#"))
	if err == nil {
		t.Fatal("expected error from cancelled context, got nil")
	}
	wg.Wait()
}

// TestRunCommand_ErrorMessageOnTimeout uses net.Pipe to eliminate
// network timing. The "server" side sends partial output without a
// trailing prompt. readUntilPrompt must return the partial data with
// a clear error, not silently drop it.
func TestRunCommand_ErrorMessageOnTimeout(t *testing.T) {
	server, client := net.Pipe()
	defer server.Close()
	defer client.Close()

	go func() {
		buf := make([]byte, 4096)
		server.Write([]byte("\r\nRouter#"))
		server.Read(buf) // terminal length 0
		server.Write([]byte("\r\nterminal length 0\r\nRouter#"))
		server.Read(buf) // show run
		server.Write([]byte("\r\nshow run\r\nLine 1\r\nLine 2\r\n        --More--        "))
		time.Sleep(10 * time.Second)
	}()

	runner := &TelnetConsoleRunner{}
	ctx, cancel := context.WithTimeout(context.Background(), 3*time.Second)
	defer cancel()
	buf := make([]byte, 4096)
	promptRe := devicePromptRe("Router#")

	// Steps 1-4: handshake (same as RunCommand, but manual)
	if _, err := runner.readUntilPrompt(ctx, client, buf, promptRe); err != nil {
		t.Fatalf("step 1 (initial prompt): %v", err)
	}
	fmt.Fprintf(client, "terminal length 0\r\n")
	if _, err := runner.readUntilPrompt(ctx, client, buf, promptRe); err != nil {
		t.Fatalf("step 3 (terminal length 0 echo): %v", err)
	}
	fmt.Fprintf(client, "show run\r\n")

	// Step 5: should get partial data
	output, err := runner.readUntilPrompt(ctx, client, buf, promptRe)
	if err == nil {
		t.Fatal("expected timeout/pagination error, got nil")
	}
	if !strings.Contains(output, "Line 1") {
		t.Errorf("partial output should contain 'Line 1': %q (len=%d)", output, len(output))
	}
	if !strings.Contains(err.Error(), "pagination") {
		t.Errorf("error should mention pagination: %v", err)
	}
}

func TestRunCommand_ConcurrentDifferentNodes(t *testing.T) {
	var mu sync.Mutex
	commands := make(map[string][]string)

	makeHandler := func(nodeName string) func(net.Conn) {
		return func(conn net.Conn) {
			buf := make([]byte, 4096)

			// Step 1: consume the runner's CR nudge, then prompt.
			conn.Read(buf)
			conn.Write([]byte("\r\n" + nodeName + "#"))

			// Terminal length 0 handshake
			conn.Read(buf)
			conn.Write([]byte("\r\nterminal length 0\r\n" + nodeName + "#"))

			mu.Lock()
			commands[nodeName] = append(commands[nodeName], "received")
			mu.Unlock()

			// Read command, send output with prompt
			conn.Read(buf)
			conn.Write([]byte(fmt.Sprintf("\r\nshow version\r\noutput from %s\r\n%s#", nodeName, nodeName)))
		}
	}

	addr1, c1 := fakeConsole(t, makeHandler("R1"))
	defer c1()
	addr2, c2 := fakeConsole(t, makeHandler("R2"))
	defer c2()

	host1, port1 := parseAddr(t, addr1)
	host2, port2 := parseAddr(t, addr2)

	runner := NewTelnetConsoleRunner("host", map[string]NodeAddr{
		"R1": {Host: host1, Port: port1},
		"R2": {Host: host2, Port: port2},
	})

	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()
	promptRe := devicePromptRe("#")

	var wg sync.WaitGroup
	errs := make(chan error, 2)
	for _, node := range []string{"R1", "R2"} {
		wg.Add(1)
		go func(n string) {
			defer wg.Done()
			_, err := runner.RunCommand(ctx, n, "show version", promptRe)
			errs <- err
		}(node)
	}
	wg.Wait()
	close(errs)

	for err := range errs {
		if err != nil {
			t.Errorf("concurrent RunCommand: %v", err)
		}
	}
	mu.Lock()
	if len(commands["R1"]) != 1 || len(commands["R2"]) != 1 {
		t.Errorf("both nodes should have 1 command: R1=%d R2=%d",
			len(commands["R1"]), len(commands["R2"]))
	}
	mu.Unlock()
}

func TestRunCommand_PaginationBlocked(t *testing.T) {
	// terminal length 0 prevents --More-- pagination. Long output
	// arrives in full, prompt appears correctly.
	//
	// We do the handshake and command manually (not via deviceRespond)
	// because deviceRespond sends the NEXT command's prompt before
	// reading the current command — on localhost that prompt races
	// ahead of the client's command and gets consumed prematurely.
	handler := func(conn net.Conn) {
		buf := make([]byte, 4096)

		// Step 1: runner nudges with CR to wake the IOU console
		// (see console_runner.go) — consume the nudge, then prompt.
		conn.Read(buf)
		conn.Write([]byte("\r\nRouter#"))

		// Terminal length 0 handshake
		conn.Read(buf)
		conn.Write([]byte("\r\nterminal length 0\r\nRouter#"))

		// Read the command, then send long output with prompt
		conn.Read(buf)

		var lines []string
		for i := 0; i < 50; i++ {
			lines = append(lines, fmt.Sprintf("Line %02d", i))
		}
		conn.Write([]byte("\r\nshow mac addr\r\n" + strings.Join(lines, "\r\n") + "\r\nRouter#"))
	}

	addr, cleanup := fakeConsole(t, handler)
	defer cleanup()

	host, port := parseAddr(t, addr)
	runner := NewTelnetConsoleRunner(host, map[string]NodeAddr{
		"R1": {Host: host, Port: port},
	})

	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	output, err := runner.RunCommand(ctx, "R1", "show mac addr", devicePromptRe("Router#"))
	if err != nil {
		t.Fatalf("RunCommand: %v", err)
	}
	if !strings.Contains(output, "Line 49") {
		t.Errorf("expected Line 49 in long output, got %d bytes", len(output))
	}
	if strings.Contains(output, "Router#") {
		t.Errorf("prompt not stripped from long output")
	}
}
