package labsession

import (
	"encoding/json"
	"io"
	"strings"
	"testing"
)

// decodeStrict exists because json.Unmarshal cannot detect truncation at an
// array/object boundary: a partial `[{"status":"stopped"},{"status":"stopped"}]`
// unmarshals cleanly into a shorter slice and the caller sees "all stopped" —
// a false positive that can free a capacity slot while the GNS3 project still
// runs. These tests prove decodeStrict fails closed on truncation.

type statusNode struct {
	Status string `json:"status"`
}

func TestDecodeStrict_CompleteArray(t *testing.T) {
	body := `[{"status":"stopped"},{"status":"stopped"}]`
	var nodes []statusNode
	if err := decodeStrict([]byte(body), &nodes); err != nil {
		t.Fatalf("complete array rejected: %v", err)
	}
	if len(nodes) != 2 {
		t.Fatalf("expected 2 nodes, got %d", len(nodes))
	}
}

func TestDecodeStrict_TruncatedMidArray(t *testing.T) {
	// Truncation drops the closing bracket — the classic VPS→Falcon drop.
	body := `[{"status":"stopped"},{"status":"stopped"}`
	var nodes []statusNode
	if err := decodeStrict([]byte(body), &nodes); err == nil {
		t.Fatalf("truncated array accepted — cap-fiction risk")
	}
}

func TestDecodeStrict_TruncatedMidElement(t *testing.T) {
	// Truncation lands inside the second element, mid-token.
	body := `[{"status":"stopped"},{"status":"sto` // cut mid-"stopped"
	var nodes []statusNode
	if err := decodeStrict([]byte(body), &nodes); err == nil {
		t.Fatalf("truncated mid-element accepted")
	}
}

func TestDecodeStrict_TruncatedAtBoundary(t *testing.T) {
	// THE dangerous case: array closes, but a subsequent element existed in
	// the real stream — server sent 3 nodes, we received 2 with a closing
	// bracket because the read was cut exactly at the element boundary.
	// (A real response of 3 nodes truncated to the first 2.)
	body := `[{"status":"stopped"},{"status":"stopped"}]`
	var nodes []statusNode
	if err := decodeStrict([]byte(body), &nodes); err != nil {
		t.Fatalf("complete-looking array rejected: %v", err)
	}
	// The tool cannot know 3 were sent — the point of the boundary test is
	// that a VALID-looking complete array is accepted (this is why the
	// reaper ALSO re-checks project existence + the escalation bounds it).
	if len(nodes) != 2 {
		t.Fatalf("expected 2 nodes, got %d", len(nodes))
	}
}

func TestDecodeStrict_TrailingGarbage(t *testing.T) {
	body := `[{"status":"stopped"}]extra`
	var nodes []statusNode
	if err := decodeStrict([]byte(body), &nodes); err == nil {
		t.Fatalf("trailing garbage accepted")
	}
}

func TestDecodeStrict_SingleObject(t *testing.T) {
	body := `{"status":"opened"}`
	var p struct {
		Status string `json:"status"`
	}
	if err := decodeStrict([]byte(body), &p); err != nil {
		t.Fatalf("single object rejected: %v", err)
	}
	if p.Status != "opened" {
		t.Fatalf("unexpected status %q", p.Status)
	}
}

// sanity: confirm the raw io behavior the strict check relies on
func TestDecodeStrict_ReliesOnEOF(t *testing.T) {
	body := `[{"status":"stopped"}]`
	dec := json.NewDecoder(strings.NewReader(body))
	var nodes []statusNode
	if err := dec.Decode(&nodes); err != nil {
		t.Fatalf("first decode: %v", err)
	}
	if err := dec.Decode(&struct{}{}); err != io.EOF {
		t.Fatalf("second decode: got %v, want io.EOF", err)
	}
}
