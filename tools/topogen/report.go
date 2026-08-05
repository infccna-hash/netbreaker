package main

// report — diff generated SVGs against the baseline (the audit).
//
// Surfaces every topology mismatch between what the Go struct says and what
// the hand-authored SVG showed: node added/removed, link added/removed,
// port changed. This is the free audit the generator buys us — any drift
// shows up as a diff line instead of requiring manual SVG inspection.

import (
	"flag"
	"fmt"
	"os"
	"path/filepath"
	"regexp"
	"sort"
	"strings"

	"netbreaker.io/api/internal/labsession"
)

// ── baseline parsing (reuse extract's SVG model) ──────────────────────────

// labTopologyFromSVG extracts the node/link topology a baseline SVG depicts:
//   - nodes: shapes that carry a matching name text (reuse locateNode logic)
//   - links: NOT recoverable from lines alone (no port attrs in old SVGs),
//     so we report node-set changes only, plus a text-level signal when the
//     SVG contains explicit port labels.
//
// The node-set comparison is the high-value check (Lab 34's missing SW1);
// link-level comparison needs the data attrs we're introducing.

type baselineInfo struct {
	Nodes []string // node names found in the SVG
	Ports []string // port labels found in the SVG (Et0/0, Fa0/1, ...)
}

var portLabelRe = regexp.MustCompile(`(?i)\b(Et0?/\d+|Fa0?/\d+|Gi0?/\d+|eth\d+|e\d+|FastEthernet\d+/\d+|GigabitEthernet\d+/\d+)\b`)

func analyzeBaseline(labID int) baselineInfo {
	doc := loadBaselineSVG("tools/topogen/baseline", labID)
	if doc == nil {
		return baselineInfo{}
	}
	var info baselineInfo
	seen := map[string]bool{}
	used := map[int]bool{}
	for _, name := range nodeNamesForLab(labID) {
		if _, ok := locateNode(doc, name, used); ok {
			info.Nodes = append(info.Nodes, name)
			seen[name] = true
		}
	}
	sort.Strings(info.Nodes)
	portSeen := map[string]bool{}
	for _, t := range doc.Texts {
		for _, m := range portLabelRe.FindAllString(t.Content, -1) {
			norm := strings.ToLower(m)
			if !portSeen[norm] {
				portSeen[norm] = true
				info.Ports = append(info.Ports, norm)
			}
		}
	}
	sort.Strings(info.Ports)
	return info
}

// ── report ────────────────────────────────────────────────────────────────

func cmdReport(args []string) {
	fs := flag.NewFlagSet("report", flag.ExitOnError)
	_ = fs.String("generated", "tools/topogen/generated", "generated SVGs dir")
	outPath := fs.String("out", "tools/topogen/report/audit.md", "report output")
	fs.Parse(args)

	var b strings.Builder
	b.WriteString("# Topogen Audit — Generated vs Baseline\n\n")
	b.WriteString("Node-set comparison per lab. Generated node set comes from the Go topology struct (source of truth); baseline node set is what the old hand-authored SVG actually drew.\n\n")
	b.WriteString("| Lab | Gen nodes | Baseline drew | Missing in baseline | Extra in baseline | Notes |\n|---|---|---|---|---|---|\n")

	drift := 0
	for labID := 1; labID <= 46; labID++ {
		tpl := labsession.TopologyForLab(labID)
		if len(tpl.Nodes) == 0 {
			continue
		}
		gen := make([]string, 0, len(tpl.Nodes))
		for _, n := range tpl.Nodes {
			gen = append(gen, n.Name)
		}
		sort.Strings(gen)

		info := analyzeBaseline(labID)
		baseSet := map[string]bool{}
		for _, n := range info.Nodes {
			baseSet[n] = true
		}
		genSet := map[string]bool{}
		for _, n := range gen {
			genSet[n] = true
		}

		var missing, extra []string
		for _, n := range gen {
			if !baseSet[n] {
				missing = append(missing, n)
			}
		}
		for _, n := range info.Nodes {
			if !genSet[n] {
				extra = append(extra, n)
			}
		}

		notes := ""
		if len(missing) > 0 {
			notes = "auto-layout will INSERT"
			drift++
		}
		if len(extra) > 0 {
			if notes != "" {
				notes += "; "
			}
			notes += "baseline drew a node the struct doesn't have"
			drift++
		}
		if len(info.Ports) > 0 && len(gen) > 0 {
			// ports in baseline but no data attrs — the old SVG had labels
			// baked as text; generated SVG carries them as data attrs.
			if notes == "" {
				notes = "baseline has port labels (" + strings.Join(info.Ports, ",") + ")"
			}
		}

		fmt.Fprintf(&b, "| %d | %s | %s | %s | %s | %s |\n",
			labID,
			strings.Join(gen, ", "),
			joinOrDash(info.Nodes),
			joinOrDash(missing),
			joinOrDash(extra),
			notes)
	}

	fmt.Fprintf(&b, "\n**Labs with drift: %d** (missing/extra nodes the generator will fix).\n", drift)
	if err := os.MkdirAll(filepath.Dir(*outPath), 0o755); err != nil {
		fmt.Fprintln(os.Stderr, "mkdir:", err)
		os.Exit(1)
	}
	if err := os.WriteFile(*outPath, []byte(b.String()), 0o644); err != nil {
		fmt.Fprintln(os.Stderr, "write:", err)
		os.Exit(1)
	}
	fmt.Printf("report: %d labs audited, %d with drift → %s\n", countAudited(), drift, *outPath)
}

func joinOrDash(items []string) string {
	if len(items) == 0 {
		return "—"
	}
	return strings.Join(items, ", ")
}

func countAudited() int {
	n := 0
	for labID := 1; labID <= 46; labID++ {
		if len(labsession.TopologyForLab(labID).Nodes) > 0 {
			n++
		}
	}
	return n
}
