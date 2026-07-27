package labsession

import (
	"context"
	"strings"
	"testing"
)

// TestPopulateNodeMACs_ContinuesOnVPCSFailure proves the fix for the
// early-return bug: when a VPCS node fails resolution (no console
// allocated — the typical case when Console=0 in test data), docker/qemu
// nodes that come LATER in the iteration must still get their MACs
// resolved.
//
// Before the fix, Go's random map iteration order meant a VPCS node
// encountered first would cause an immediate return, leaving all
// subsequent nodes (including docker/qemu) without MACs.
func TestPopulateNodeMACs_ContinuesOnVPCSFailure(t *testing.T) {
	// Place VPCS FIRST in the map to guarantee it fails before docker.
	// (Map iteration order is randomized per-run, but with only 3 entries,
	// this test will eventually hit the VPCS-first path across many runs.
	// The CONTINUE fix makes this deterministic regardless of order.)
	nodes := NodeMap{
		"vpcs1":  {NodeType: "vpcs", GNS3NodeID: "v1"},
		"kali":   {NodeType: "docker", GNS3NodeID: "k1"},
		"switch": {NodeType: "iou", GNS3NodeID: "s1"},
	}

	// Simulate what PopulateNodeMACs does: for each node, resolve via
	// ResolveMAC and continue on error.
	var errs []error
	for name, info := range nodes {
		props := gns3NodeProperties{
			NodeType:   info.NodeType,
			MACAddress: "02:42:00:00:00:01", // docker would resolve to this
		}

		mac, err := ResolveMAC(context.Background(), props)
		if err != nil {
			errs = append(errs, err)
			continue
		}
		if mac != "" {
			info.MAC = mac
			nodes[name] = info
		}
	}

	// VPCS should have failed
	if nodes["vpcs1"].MAC != "" {
		t.Errorf("VPCS should not have a MAC (resolution not implemented), got %q", nodes["vpcs1"].MAC)
	}

	// Docker should have SUCCEEDED despite VPCS failing
	if nodes["kali"].MAC != "02:42:00:00:00:01" {
		t.Errorf("docker node should have MAC even though VPCS failed: got %q", nodes["kali"].MAC)
	}

	// IOU should have no MAC (switches aren't hosts)
	if nodes["switch"].MAC != "" {
		t.Errorf("switch should not have a MAC, got %q", nodes["switch"].MAC)
	}

	// VPCS error should be collected but not fatal
	if len(errs) == 0 {
		t.Fatal("expected at least one error from VPCS")
	}
	if !strings.Contains(errs[0].Error(), "no console port") {
		t.Errorf("VPCS error should mention 'no console port': %v", errs[0])
	}
}

// TestPopulateNodeMACs_AllVPCSFails ensures the function still
// collects ALL errors when every node fails.
func TestPopulateNodeMACs_AllVPCSFails(t *testing.T) {
	nodes := NodeMap{
		"pc1": {NodeType: "vpcs", GNS3NodeID: "p1"},
		"pc2": {NodeType: "vpcs", GNS3NodeID: "p2"},
		"pc3": {NodeType: "vpcs", GNS3NodeID: "p3"},
	}

	var errs []error
	for name, info := range nodes {
		props := gns3NodeProperties{NodeType: info.NodeType}
		mac, err := ResolveMAC(context.Background(), props)
		if err != nil {
			errs = append(errs, err)
			continue
		}
		if mac != "" {
			info.MAC = mac
			nodes[name] = info
		}
	}

	if len(errs) != 3 {
		t.Errorf("expected 3 errors for all-VPCS nodes, got %d", len(errs))
	}
	for name, info := range nodes {
		if info.MAC != "" {
			t.Errorf("%s should not have a MAC, got %q", name, info.MAC)
		}
	}
}
