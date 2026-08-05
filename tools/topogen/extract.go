package main

// extract — salvage human-chosen node positions from baseline SVGs.
//
// Matching is BY NAME against the Go topology template (the single source of
// truth). For each node name in the template, we look for a <text> element
// whose content equals that name (case-insensitive, trimmed). The node gets
// the position of the shape (rect or circle) that contains that text — or the
// nearest shape if containment fails. A node whose name never appears in the
// SVG gets no position → the renderer falls back to auto-layout.
//
// This is deliberately strict: we never guess a node's identity from
// geometry. If the SVG disagrees with the struct, the node is simply missing
// and shows up in the gate report + the render diff.

import (
	"encoding/json"
	"encoding/xml"
	"flag"
	"fmt"
	"io"
	"math"
	"os"
	"path/filepath"
	"sort"
	"strings"

	"netbreaker.io/api/internal/labsession"
)

// ── SVG model ────────────────────────────────────────────────────────────

type shape struct {
	Kind string  // "rect" | "circle"
	X, Y float64 // rect top-left / circle center
	W, H float64 // rect only
	R    float64 // circle only
}

func (s shape) contains(px, py float64) bool {
	if s.Kind == "rect" {
		return px >= s.X && px <= s.X+s.W && py >= s.Y && py <= s.Y+s.H
	}
	dx, dy := px-s.X, py-s.Y
	return dx*dx+dy*dy <= s.R*s.R
}

func (s shape) center() (float64, float64) {
	if s.Kind == "rect" {
		return s.X + s.W/2, s.Y + s.H/2
	}
	return s.X, s.Y
}

type textEl struct {
	Content string
	X, Y    float64
}

type svgDoc struct {
	Shapes []shape
	Texts  []textEl
}

func parseSVG(r io.Reader) (*svgDoc, error) {
	dec := xml.NewDecoder(r)
	doc := &svgDoc{}
	var attrs map[string]string
	depth := 0
	for {
		tok, err := dec.Token()
		if err == io.EOF {
			break
		}
		if err != nil {
			return nil, err
		}
		switch t := tok.(type) {
		case xml.StartElement:
			depth++
			attrs = attrMap(t.Attr)
			switch t.Name.Local {
			case "rect":
				doc.Shapes = append(doc.Shapes, shape{
					Kind: "rect",
					X:    num(attrs["x"]), Y: num(attrs["y"]),
					W: num(attrs["width"]), H: num(attrs["height"]),
				})
			case "circle":
				doc.Shapes = append(doc.Shapes, shape{
					Kind: "circle",
					X:    num(attrs["cx"]), Y: num(attrs["cy"]),
					R: num(attrs["r"]),
				})
			case "text":
				// Capture the full text content of this element.
				content, err := textContent(dec)
				if err != nil {
					return nil, err
				}
				doc.Texts = append(doc.Texts, textEl{
					Content: content,
					X:       num(attrs["x"]), Y: num(attrs["y"]),
				})
			}
		case xml.EndElement:
			depth--
			if depth == 0 {
				attrs = nil
			}
		}
	}
	return doc, nil
}

func attrMap(attrs []xml.Attr) map[string]string {
	m := make(map[string]string, len(attrs))
	for _, a := range attrs {
		m[a.Name.Local] = a.Value
	}
	return m
}

func num(s string) float64 {
	var f float64
	fmt.Sscanf(s, "%f", &f)
	return f
}

func textContent(dec *xml.Decoder) (string, error) {
	var sb strings.Builder
	depth := 1
	for depth > 0 {
		tok, err := dec.Token()
		if err != nil {
			return "", err
		}
		switch t := tok.(type) {
		case xml.StartElement:
			depth++
		case xml.EndElement:
			depth--
		case xml.CharData:
			sb.Write(t)
		}
	}
	return strings.TrimSpace(sb.String()), nil
}

// ── Position model ────────────────────────────────────────────────────────

type NodePos struct {
	X     float64 `json:"x,omitempty"`
	Y     float64 `json:"y,omitempty"`
	W     float64 `json:"w,omitempty"`
	H     float64 `json:"h,omitempty"`
	R     float64 `json:"r,omitempty"`
	Shape string  `json:"shape"` // "rect" | "circle"
}

// Positions maps labID → node name → position.
type Positions map[string]map[string]NodePos

// ── Template access ──────────────────────────────────────────────────────

// nodeNamesForLab returns the node names from the Go topology template.
// We read them via the same registry the service uses.
func nodeNamesForLab(labID int) []string {
	tpl := labsession.TopologyForLab(labID)
	names := make([]string, 0, len(tpl.Nodes))
	for _, n := range tpl.Nodes {
		names = append(names, n.Name)
	}
	sort.Strings(names)
	return names
}

// ── cmdExtract ────────────────────────────────────────────────────────────

func cmdExtract(args []string) {
	fs := flag.NewFlagSet("extract", flag.ExitOnError)
	baseDir := fs.String("baseline", "tools/topogen/baseline", "baseline dir (svg_large/, svg_small/)")
	outPath := fs.String("out", "tools/topogen/positions.json", "output positions JSON")
	gatePath := fs.String("gate", "tools/topogen/report/extraction-gate.md", "human gate report")
	fs.Parse(args)

	pos := Positions{}
	gate := strings.Builder{}
	gate.WriteString("# Extraction Gate Report\n\n")
	gate.WriteString("Node positions salvaged from baseline SVGs, matched **by name** against the Go topology template.\n\n")
	gate.WriteString("| Lab | Node | Status | Source shape |\n|---|---|---|---|\n")

	var labs []int
	for labID := 1; labID <= 46; labID++ {
		if len(nodeNamesForLab(labID)) == 0 {
			continue
		}
		labs = append(labs, labID)
	}
	labKey := func(id int) string { return fmt.Sprintf("%d", id) }

	for _, labID := range labs {
		doc := loadBaselineSVG(*baseDir, labID)
		if doc == nil {
			fmt.Fprintf(&gate, "| %d | — | **NO SVG** | — |\n", labID)
			continue
		}
		per := map[string]NodePos{}
		usedShapes := map[int]bool{}
		for _, name := range nodeNamesForLab(labID) {
			sp, ok := locateNode(doc, name, usedShapes)
			if !ok {
				fmt.Fprintf(&gate, "| %d | %s | MISSING (auto-layout) | — |\n", labID, name)
				continue
			}
			per[name] = sp
			fmt.Fprintf(&gate, "| %d | %s | OK | %s @ (%.0f,%.0f) |\n", labID, name, sp.Shape, sp.X, sp.Y)
		}
		if len(per) > 0 {
			pos[labKey(labID)] = per
		}
	}

	if err := os.MkdirAll(filepath.Dir(*outPath), 0o755); err != nil {
		fmt.Fprintln(os.Stderr, "mkdir:", err)
		os.Exit(1)
	}
	b, err := json.MarshalIndent(pos, "", "  ")
	if err != nil {
		fmt.Fprintln(os.Stderr, "marshal:", err)
		os.Exit(1)
	}
	if err := os.WriteFile(*outPath, b, 0o644); err != nil {
		fmt.Fprintln(os.Stderr, "write:", err)
		os.Exit(1)
	}
	if err := os.MkdirAll(filepath.Dir(*gatePath), 0o755); err != nil {
		fmt.Fprintln(os.Stderr, "mkdir:", err)
		os.Exit(1)
	}
	if err := os.WriteFile(*gatePath, []byte(gate.String()), 0o644); err != nil {
		fmt.Fprintln(os.Stderr, "write:", err)
		os.Exit(1)
	}

	total, found := 0, 0
	for _, per := range pos {
		for range per {
			found++
		}
	}
	for _, labID := range labs {
		total += len(nodeNamesForLab(labID))
	}
	fmt.Printf("extract: %d nodes across %d labs; %d positions found (%d missing → auto-layout)\n",
		total, len(pos), found, total-found)
	fmt.Printf("gate report: %s\npositions: %s\n", *gatePath, *outPath)
}

func loadBaselineSVG(baseDir string, labID int) *svgDoc {
	large := filepath.Join(baseDir, "svg_large", fmt.Sprintf("%d.svg", labID))
	small := filepath.Join(baseDir, "svg_small", fmt.Sprintf("%d.svg", labID))
	for _, p := range []string{large, small} {
		f, err := os.Open(p)
		if err != nil {
			continue
		}
		doc, err := parseSVG(f)
		f.Close()
		if err == nil {
			return doc
		}
	}
	return nil
}

// maxNodeShapeArea is the largest area a real node shape can have
// (node rects are ~140×60 ≈ 8400; circles r=30 ≈ 2827). Background and grid
// rects span the whole viewBox (720×490 ≈ 350k) and must never be selected
// as a node position — otherwise "KALI → rect @ (0,0)" (the background).
const maxNodeShapeArea = 20000.0

func isNodeShape(s shape) bool {
	if s.Kind == "rect" {
		return s.W*s.H <= maxNodeShapeArea
	}
	return math.Pi*s.R*s.R <= maxNodeShapeArea
}

// nameMatches reports whether a text element's content is the given node
// name. Exact (case-insensitive) match, or name followed by whitespace —
// e.g. "SW1 👑" matches SW1 (crown emoji for root bridge), but "R1" never
// matches "R10" because the char after the name must be whitespace.
func nameMatches(content, name string) bool {
	t := strings.TrimSpace(content)
	if strings.EqualFold(t, name) {
		return true
	}
	if len(t) > len(name) && strings.EqualFold(t[:len(name)], name) {
		next := t[len(name)]
		return next == ' ' || next == '	' || next == '\n'
	}
	return false
}

// locateNode finds the position for a node name: a <text> matching the name,
// then the shape containing (or nearest to) it.
func locateNode(doc *svgDoc, name string, used map[int]bool) (NodePos, bool) {
	var match *textEl
	for i := range doc.Texts {
		if nameMatches(doc.Texts[i].Content, name) {
			match = &doc.Texts[i]
			break
		}
	}
	if match == nil {
		return NodePos{}, false
	}
	// Prefer the SMALLEST shape that contains the text anchor — the
	// background/grid rects contain everything, so "first match" is wrong.
	bestIdx, bestArea := -1, math.MaxFloat64
	for i, s := range doc.Shapes {
		if used[i] || !isNodeShape(s) {
			continue
		}
		if s.contains(match.X, match.Y) {
			a := s.W * s.H
			if s.Kind == "circle" {
				a = math.Pi * s.R * s.R
			}
			if a < bestArea {
				bestIdx, bestArea = i, a
			}
		}
	}
	if bestIdx >= 0 {
		used[bestIdx] = true
		return toNodePos(doc.Shapes[bestIdx]), true
	}
	// Fallback: nearest unused node-shaped element by center distance.
	bestIdx, bestDist := -1, math.MaxFloat64
	for i, s := range doc.Shapes {
		if used[i] || !isNodeShape(s) {
			continue
		}
		cx, cy := s.center()
		d := math.Hypot(cx-match.X, cy-match.Y)
		if d < bestDist {
			bestIdx, bestDist = i, d
		}
	}
	if bestIdx >= 0 {
		used[bestIdx] = true
		return toNodePos(doc.Shapes[bestIdx]), true
	}
	return NodePos{}, false
}

func toNodePos(s shape) NodePos {
	np := NodePos{X: s.X, Y: s.Y, Shape: s.Kind}
	if s.Kind == "rect" {
		np.W, np.H = s.W, s.H
	} else {
		np.R = s.R
	}
	return np
}
