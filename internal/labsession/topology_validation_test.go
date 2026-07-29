package labsession

import (
	"fmt"
	"testing"
)

// TestAllTopologies_NoPortConflicts is a systemic guard against the bug
// found in Lab 2 (2026-07-29): SW1's Et0/1 was wired to BOTH the SW2
// trunk and PC1 in the same Links list — a real interface can't carry
// two links, so this would fail at GNS3 provisioning. Rather than fix
// Lab 2 in isolation, this checks every lab's topology for the same
// class of bug: any (node, interface) pair appearing more than once
// across a topology's Links, on either side of the link.
//
// This iterates every lab ID via lookupTopologyTemplate rather than
// importing each LabNNTopology var directly — that way a newly added
// lab is automatically covered the moment it's wired into
// lookupTopologyTemplate, with no test-file update needed.
func TestAllTopologies_NoPortConflicts(t *testing.T) {
	for labID := 1; labID <= 46; labID++ {
		tpl := lookupTopologyTemplate(labID)
		if len(tpl.Nodes) == 0 {
			continue // conceptual lab, no live topology (e.g. 22, 23, 30, 40-42)
		}

		seen := map[string]string{} // "nodeName|iface" -> description of first use
		for _, link := range tpl.Links {
			checkPort(t, labID, seen, link.NodeA, link.IfaceA, link)
			checkPort(t, labID, seen, link.NodeB, link.IfaceB, link)
		}
	}
}

func checkPort(t *testing.T, labID int, seen map[string]string, node, iface string, link LinkTemplate) {
	t.Helper()
	key := node + "|" + iface
	desc := fmt.Sprintf("%s<->%s (%s:%s <-> %s:%s)", link.NodeA, link.NodeB, link.NodeA, link.IfaceA, link.NodeB, link.IfaceB)
	if prior, ok := seen[key]; ok {
		t.Errorf("lab %d: port conflict — %s:%s is used by both %q and %q; "+
			"a real interface can't carry two links, this topology would fail at GNS3 provisioning",
			labID, node, iface, prior, desc)
		return
	}
	seen[key] = desc
}
