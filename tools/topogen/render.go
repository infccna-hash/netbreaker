package main

// render — generate canonical Lab-15-style SVGs from the Go topology structs.
//
// Sources:
//   - nodes/links: labsession.TopologyForLab (single source of truth)
//   - positions:   extracted from baseline SVGs (positions.json); any node
//     missing a position falls back to deterministic layered auto-layout
//
// Output: one SVG per lab with:
//   - terminal chrome (traffic lights, grid, prompt) — Lab 15 canonical style
//   - role-colored nodes (gray switch/router/firewall, amber hub, cyan end
//     host, red attacker with glow)
//   - green port chips with data-port / data-iface attributes
//   - link lines with data-node-a/data-iface-a/data-node-b/data-iface-b
//   - legend footer + initial_build line derived from the actual Links

import (
	"encoding/json"
	"flag"
	"fmt"
	"math"
	"os"
	"path/filepath"
	"sort"
	"strconv"
	"strings"

	"netbreaker.io/api/internal/labsession"
)

// ── style constants (Lab 15 canonical) ────────────────────────────────────

const (
	viewW, viewH = 720.0, 490.0

	bgColor        = "#0b0f14"
	gridColor      = "#1b2129"
	chromeLine     = "#22272e"
	chromeText     = "#6e7681"
	nodeFill       = "#131a21"
	attackerFill   = "#1a0f11"
	coreStroke     = "#8b98a5" // switch / router / firewall
	coreLabel      = "#e6edf3"
	hubStroke      = "#d29922"
	hubLabel       = "#d29922"
	hubSub         = "#a17f2f"
	hostStroke     = "#22d3ee" // end host
	hostLabel      = "#67e8f9"
	attackerStroke = "#f85149"
	attackerLabel  = "#ff7b72"
	portStroke     = "#3fb950"
	portFill       = "#0b0f14"
	subText        = "#8b98a5"

	nodeW, nodeH = 140.0, 60.0
	hostR        = 30.0
	cellW, cellH = 190.0, 120.0 // auto-layout grid cell
)

// nodeRole classifies a node for coloring/shape.
type nodeRole int

const (
	roleCore nodeRole = iota // switch / router / firewall
	roleHub
	roleHost // end host (vpcs)
	roleAttacker
)

func roleOf(n labsession.NodeTemplate) nodeRole {
	if strings.Contains(strings.ToUpper(n.Name), "KALI") {
		return roleAttacker
	}
	switch n.NodeType {
	case "vpcs":
		return roleHost
	case "ethernet_hub":
		return roleHub
	default:
		return roleCore
	}
}

func roleSubtitle(n labsession.NodeTemplate) string {
	switch roleOf(n) {
	case roleAttacker:
		return "attacker / observer"
	case roleHost:
		return "end host"
	case roleHub:
		return "hub — shared domain"
	}
	switch strings.ToUpper(n.Name) {
	case "FW1":
		return "firewall"
	case "SERVER", "SRV1":
		return "server"
	case "AP1":
		return "access point"
	}
	switch n.NodeType {
	case "iou":
		return "l2 switch"
	case "dynamips":
		return "router"
	}
	return "network device"
}

// nodeShape is a computed node position for rendering.
type nodeShape struct {
	Name string
	Role nodeRole
	// Center + footprint
	CX, CY float64
	IsHost bool // circle
}

// ── auto-layout ───────────────────────────────────────────────────────────

// autoLayout places nodes with no extracted position on a deterministic grid.
// Core nodes (switches/routers/hubs) go in the first rows, hosts/attackers
// below — a simple layered arrangement that reads well for ≤10 node graphs.
// Deterministic: same input → same output (sorted iteration, fixed spacing).
//
// CRITICAL: positions are written back into the ORIGINAL shapes slice by
// index. Building core/leaf slices of struct copies and placing those is a
// silent no-op — the original slice is never modified and every auto-laid
// node renders at center (0,0).
func autoLayout(shapes []nodeShape, used map[string]bool) []nodeShape {
	var coreIdx, leafIdx []int
	for i, s := range shapes {
		if used[s.Name] {
			continue
		}
		if s.Role == roleHost || s.Role == roleAttacker {
			leafIdx = append(leafIdx, i)
		} else {
			coreIdx = append(coreIdx, i)
		}
	}
	sort.Slice(coreIdx, func(i, j int) bool { return shapes[coreIdx[i]].Name < shapes[coreIdx[j]].Name })
	sort.Slice(leafIdx, func(i, j int) bool { return shapes[leafIdx[i]].Name < shapes[leafIdx[j]].Name })

	place := func(idxs []int, startY float64) {
		// perRow must fit within the 720px canvas: 4 cells of 190 = 760 >
		// 720, so 4 only works with margin math; 3 is always safe.
		perRow := 3
		if len(idxs) <= 3 {
			perRow = len(idxs)
		}
		for k, idx := range idxs {
			row := k / perRow
			col := k % perRow
			rowCount := perRow
			if rem := len(idxs) - row*perRow; rem < rowCount {
				rowCount = rem
			}
			totalW := float64(rowCount)*cellW - 50
			x0 := (viewW - totalW) / 2
			shapes[idx].CX = x0 + float64(col)*cellW + cellW/2
			shapes[idx].CY = startY + float64(row)*cellH
		}
	}
	place(coreIdx, 110)
	// Leaves start BELOW the last core row. Core rows are ceil(len/3)
	// (perRow=3); the old (len+3)/4 formula assumed perRow=4 and let
	// leaf row 0 overlap core row 1 for 4+ core nodes.
	coreRows := (len(coreIdx) + 2) / 3
	if coreRows < 1 {
		coreRows = 1
	}
	leafStart := 110 + cellH*float64(coreRows)
	place(leafIdx, leafStart)
	return shapes
}

func max(a, b int) int {
	if a > b {
		return a
	}
	return b
}

// ── layout assembly ───────────────────────────────────────────────────────

// layoutLab computes node shapes for a lab. Extracted positions are used when
// they produce a valid layout; if they collapse (nodes overlapping, or links
// shorter than the space chips need), the lab falls back to auto-layout — a
// hand-drawn row that worked for an incomplete topology must not constrain
// the true (fuller) topology's rendering.
func layoutLab(labID int, pos map[string]NodePos) ([]nodeShape, map[string]nodeShape) {
	tpl := labsession.TopologyForLab(labID)

	// build from extracted positions: start from EVERY template node so
	// nodes without an extracted position still get rendered (auto-layout
	// fills them). Overlay extracted coordinates where available.
	build := func(useExtracted bool) ([]nodeShape, map[string]nodeShape) {
		shapes := make([]nodeShape, 0, len(tpl.Nodes))
		byName := map[string]nodeShape{}
		used := map[string]bool{}

		for _, n := range tpl.Nodes {
			s := nodeShape{Name: n.Name, Role: roleOf(n)}
			if s.Role == roleHost {
				s.IsHost = true
			}
			if useExtracted {
				if p, ok := pos[n.Name]; ok {
					// Respect the extracted shape: the canonical Lab 15
					// draws KALI2 as a GLOWING CIRCLE (hub observer) while
					// KALI is a rect — role alone must not override the
					// shape the hand-authored diagram chose.
					if p.Shape == "circle" {
						s.IsHost = true
						s.CX, s.CY = p.X, p.Y
					} else {
						s.CX = p.X + p.W/2
						s.CY = p.Y + p.H/2
					}
					used[n.Name] = true
				}
			}
			shapes = append(shapes, s)
		}
		shapes = autoLayout(shapes, used)
		for _, s := range shapes {
			byName[s.Name] = s
		}
		return shapes, byName
	}

	shapes, byName := build(true)
	if layoutValid(tpl, byName) {
		return shapes, byName
	}
	// fall back: extracted layout collapses → pure auto-layout
	shapes, byName = build(false)
	return shapes, byName
}

// layoutValid reports whether a computed layout can render legibly.
// Only node-footprint overlaps disqualify a layout. Short links are NOT a
// disqualifier: renderPortChip places short-link chips perpendicular to the
// line (above/below), so a 60px hub↔host gap renders cleanly — rejecting it
// would throw away hand-tuned layouts like the canonical Lab 15.
func layoutValid(tpl labsession.TopologyTemplate, byName map[string]nodeShape) bool {
	// node footprint overlap check
	names := make([]string, 0, len(byName))
	for n := range byName {
		names = append(names, n)
	}
	for i := 0; i < len(names); i++ {
		for j := i + 1; j < len(names); j++ {
			a, b := byName[names[i]], byName[names[j]]
			dx := a.CX - b.CX
			dy := a.CY - b.CY
			minDX := 70.0 + 70.0
			minDY := 30.0 + 30.0
			if a.IsHost {
				minDX, minDY = 30+70, 30+30
			}
			if b.IsHost {
				minDX, minDY = 70+30, 30+30
			}
			if a.IsHost && b.IsHost {
				minDX, minDY = 30+30, 30+30
			}
			if math.Abs(dx) < minDX && math.Abs(dy) < minDY {
				return false
			}
		}
	}
	return true
}

// ── SVG rendering ─────────────────────────────────────────────────────────

// pairKey returns a canonical key for an unordered node pair.
func pairKey(a, b string) string {
	if a < b {
		return a + "|" + b
	}
	return b + "|" + a
}

// parallelOffsets computes, per link, a perpendicular offset used to draw
// parallel links (redundant trunks, EtherChannels) side by side instead of
// on top of each other. Links sharing the same unordered node pair fan out
// by (idx - (n-1)/2) * 18px perpendicular to the link direction.
func parallelOffsets(tpl labsession.TopologyTemplate) map[string]float64 {
	pairs := map[string]int{}
	for _, l := range tpl.Links {
		pairs[pairKey(l.NodeA, l.NodeB)]++
	}
	pairIdx := map[string]int{}
	offsets := map[string]float64{}
	for _, l := range tpl.Links {
		key := pairKey(l.NodeA, l.NodeB)
		n := pairs[key]
		i := pairIdx[key]
		pairIdx[key]++
		if n <= 1 {
			offsets[fmt.Sprintf("%s:%s↔%s:%s", l.NodeA, l.IfaceA, l.NodeB, l.IfaceB)] = 0
			continue
		}
		offsets[fmt.Sprintf("%s:%s↔%s:%s", l.NodeA, l.IfaceA, l.NodeB, l.IfaceB)] = (float64(i) - float64(n-1)/2) * 18
	}
	return offsets
}

func renderLab(labID int, pos map[string]NodePos) string {
	tpl := labsession.TopologyForLab(labID)
	shapes, byName := layoutLab(labID, pos)
	parallel := parallelOffsets(tpl)

	var b strings.Builder
	fmt.Fprintf(&b, `<svg
      width="100%%"
      viewBox="0 0 %.0f %.0f"
      xmlns="http://www.w3.org/2000/svg"
      role="img"
      aria-label="NetBreaker Lab %d topology: %s"
    >
      <defs>
        <pattern id="grid" width="24" height="24" patternUnits="userSpaceOnUse">
          <path d="M24 0H0V24" fill="none" stroke="%s" stroke-width="1" />
        </pattern>
        <filter id="glow" x="-40%%" y="-40%%" width="180%%" height="180%%">
          <feGaussianBlur stdDeviation="3" result="blur" />
          <feMerge>
            <feMergeNode in="blur" />
            <feMergeNode in="SourceGraphic" />
          </feMerge>
        </filter>
      </defs>

      <rect x="0" y="0" width="%.0f" height="%.0f" rx="10" fill="%s" />
      <rect x="1" y="37" width="%.0f" height="%.0f" fill="url(#grid)" />
      <rect x="0.5" y="0.5" width="%.0f" height="%.0f" rx="10" fill="none" stroke="%s" stroke-width="1" />

      <line x1="0" y1="36" x2="%.0f" y2="36" stroke="%s" stroke-width="1" />
      <circle cx="20" cy="18" r="6" fill="#ff5f56" />
      <circle cx="40" cy="18" r="6" fill="#ffbd2e" />
      <circle cx="60" cy="18" r="6" fill="#27c93f" />
      <text x="82" y="22" font-family="Courier New, monospace" fontSize="12" fill="%s">
        root@netbreaker:~/lab%d$ topology --render
      </text>
`, viewW, viewH, labID, ariaDesc(tpl),
		gridColor,
		viewW, viewH, bgColor,
		viewW-2, viewH-39,
		viewW-1, viewH-1, chromeLine,
		viewW, chromeLine, chromeText, labID)

	// ── links first (under nodes) ─────────────────────────────────────
	for _, link := range tpl.Links {
		a, okA := byName[link.NodeA]
		bnd, okB := byName[link.NodeB]
		if !okA || !okB {
			continue
		}
		key := fmt.Sprintf("%s:%s↔%s:%s", link.NodeA, link.IfaceA, link.NodeB, link.IfaceB)
		off := parallel[key]
		ax, ay := edgePoint(a, bnd)
		bx, by := edgePoint(bnd, a)
		// perpendicular nudge for parallel links
		dx, dy := bx-ax, by-ay
		len := math.Hypot(dx, dy)
		if len > 0 {
			px, py := -dy/len, dx/len
			ax += px * off
			ay += py * off
			bx += px * off
			by += py * off
		}
		fmt.Fprintf(&b, `      <g data-link="%s">
        <line x1="%.0f" y1="%.0f" x2="%.0f" y2="%.0f" stroke="%s" stroke-width="1.5"
          data-node-a="%s" data-iface-a="%s" data-node-b="%s" data-iface-b="%s" />
        <title>%s %s ↔ %s %s</title>
      </g>
`,
			key,
			ax, ay, bx, by, "#4d5560",
			link.NodeA, link.IfaceA, link.NodeB, link.IfaceB,
			link.NodeA, link.IfaceA, link.NodeB, link.IfaceB)
	}

	// ── port chips ────────────────────────────────────────────────────
	// Chips are scheduled PER NODE: each node's chips get angular placement
	// with enforced minimum separation, so dense nodes (hub with 4 links,
	// switch with parallel trunks) never stack chips.
	chipsByNode := map[string][]chipSpec{}
	for _, link := range tpl.Links {
		a, okA := byName[link.NodeA]
		bnd, okB := byName[link.NodeB]
		if !okA || !okB {
			continue
		}
		key := fmt.Sprintf("%s:%s↔%s:%s", link.NodeA, link.IfaceA, link.NodeB, link.IfaceB)
		off := parallel[key]
		chipsByNode[link.NodeA] = append(chipsByNode[link.NodeA], chipSpec{
			NodeName: link.NodeA, Iface: link.IfaceA, Other: bnd,
			ParallelOff: off, PerpSign: +1,
		})
		chipsByNode[link.NodeB] = append(chipsByNode[link.NodeB], chipSpec{
			NodeName: link.NodeB, Iface: link.IfaceB, Other: a,
			ParallelOff: off, PerpSign: -1,
		})
	}
	for _, s := range shapes {
		specs := chipsByNode[s.Name]
		if len(specs) == 0 {
			continue
		}
		angles := scheduleChips(s, specs)
		for i, c := range specs {
			renderPortChip(&b, s, c.Other, c.NodeName, c.Iface, angles[i], c.ParallelOff, c.PerpSign)
		}
	}

	// ── nodes ─────────────────────────────────────────────────────────
	for _, s := range shapes {
		renderNode(&b, s, tpl)
	}

	// ── legend footer ─────────────────────────────────────────────────
	renderLegend(&b, labID, tpl)

	b.WriteString("    </svg>\n")
	return b.String()
}

func ariaDesc(tpl labsession.TopologyTemplate) string {
	if len(tpl.Links) == 0 {
		return "topology"
	}
	parts := make([]string, 0, len(tpl.Links))
	for _, l := range tpl.Links {
		parts = append(parts, fmt.Sprintf("%s(%s)→%s(%s)", l.NodeA, l.IfaceA, l.NodeB, l.IfaceB))
	}
	return strings.Join(parts, ", ")
}

// edgePoint returns the point on a's boundary where the a→b link exits.
func edgePoint(a, b nodeShape) (float64, float64) {
	dx, dy := b.CX-a.CX, b.CY-a.CY
	// guard: zero-length
	if dx == 0 && dy == 0 {
		return a.CX, a.CY
	}
	if a.IsHost {
		// circle: scale direction to radius
		len := math.Hypot(dx, dy)
		return a.CX + dx/len*hostR, a.CY + dy/len*hostR
	}
	// rect: find intersection with boundary along direction
	halfW, halfH := nodeW/2, nodeH/2
	// parametric t where the ray hits each edge
	tx := math.Inf(1)
	if dx != 0 {
		tx = math.Abs(halfW / dx)
	}
	ty := math.Inf(1)
	if dy != 0 {
		ty = math.Abs(halfH / dy)
	}
	t := tx
	if ty < t {
		t = ty
	}
	return a.CX + dx*t, a.CY + dy*t
}

// chipSpec is one port chip to render, positioned by angular scheduling.
type chipSpec struct {
	NodeName    string
	Iface       string
	Other       nodeShape // the far end of the link (for edgePoint/direction)
	ParallelOff float64   // perpendicular offset for parallel links
	PerpSign    float64   // +1 for NodeA end, -1 for NodeB end
}

// scheduleChips assigns each of a node's chips a placement angle so that no
// two chips overlap. Preferred angle = direction toward the other node;
// enforced minimum separation = arc needed for a 42px chip at the placement
// radius (edge + 24px ≈ 94px → ~26°; hosts r=30 → ~45°).
func scheduleChips(owner nodeShape, chips []chipSpec) []float64 {
	n := len(chips)
	angles := make([]float64, n)
	for i, c := range chips {
		angles[i] = math.Atan2(c.Other.CY-owner.CY, c.Other.CX-owner.CX) * 180 / math.Pi
	}
	// sort indices by angle
	order := make([]int, n)
	for i := range order {
		order[i] = i
	}
	sort.Slice(order, func(i, j int) bool { return angles[order[i]] < angles[order[j]] })

	// radius for min separation
	radius := 94.0
	if owner.IsHost {
		radius = hostR + 24
	}
	minSep := 42.0 / radius * 180 / math.Pi // degrees of arc for one chip
	if minSep > 45 {
		minSep = 45
	}

	// enforce separation in sorted order
	adj := make([]float64, n) // adjusted angles, in order[] positions
	prev := math.Inf(-1)
	for k := 0; k < n; k++ {
		idx := order[k]
		a := angles[idx]
		if a < prev+minSep {
			a = prev + minSep
		}
		adj[idx] = a
		prev = a
	}
	// wrap-around: if the last angle is within minSep of first+360, shift
	// the whole band back so it fits in [-180, 180)
	if n > 1 {
		first, last := adj[order[0]], adj[order[n-1]]
		if last-first > 360-minSep {
			shift := (first + 360 - last + minSep) / 2
			for _, idx := range order {
				adj[idx] -= shift
			}
		}
	}
	return adj
}

func renderPortChip(b *strings.Builder, owner, other nodeShape, nodeName, iface string, angleDeg float64, parallelOff float64, perpSign float64) {
	// direction at the scheduled angle (not the raw link direction)
	rad := angleDeg * math.Pi / 180.0
	rotX, rotY := math.Cos(rad), math.Sin(rad)
	perpX, perpY := -rotY, rotX

	ex, ey := edgePoint(owner, other)
	// Place along the scheduled angle. scheduleChips already guarantees the
	// two endpoints of a link get ~180°-opposite angles, so placing along
	// the angle (instead of perpendicular) separates them even for nearly
	// touching nodes. perpSign nudges perpendicular so same-side chips
	// (multi-link nodes) don't stack exactly.
	cx := ex + rotX*24 + perpX*float64(perpSign)*7 + perpX*parallelOff
	cy := ey + rotY*24 + perpY*float64(perpSign)*7 + perpY*parallelOff
	writeChip(b, nodeName, iface, cx, cy)
}

func writeChip(b *strings.Builder, nodeName, iface string, cx, cy float64) {
	fmt.Fprintf(b, `      <g data-port="%s" data-iface="%s">
        <rect x="%.0f" y="%.0f" width="42" height="18" rx="3" fill="%s" stroke="%s" stroke-width="1" />
        <text x="%.0f" y="%.0f" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="%s">%s</text>
        <title>%s %s</title>
      </g>
`, nodeName, iface,
		cx-21, cy-9, portFill, portStroke,
		cx, cy+4, portStroke, iface,
		nodeName, iface)
}

func renderNode(b *strings.Builder, s nodeShape, tpl labsession.TopologyTemplate) {
	// find the NodeTemplate for the subtitle
	var nt labsession.NodeTemplate
	for _, n := range tpl.Nodes {
		if n.Name == s.Name {
			nt = n
			break
		}
	}
	sub := roleSubtitle(nt)

	if s.Role == roleAttacker {
		if s.IsHost {
			// attacker-as-circle (canonical Lab 15 KALI2): glowing circle
			fmt.Fprintf(b, `      <g data-node="%s" data-role="attacker">
        <g filter="url(#glow)">
          <circle cx="%.0f" cy="%.0f" r="%.0f" fill="%s" stroke="%s" stroke-width="1.5" stroke-dasharray="4 2" />
        </g>
        <text x="%.0f" y="%.0f" text-anchor="middle" font-family="Courier New, monospace" fontSize="12" fontWeight="700" fill="%s">%s</text>
        <title>%s</title>
      </g>
`, s.Name,
				s.CX, s.CY, hostR, attackerFill, attackerStroke,
				s.CX, s.CY+4, attackerLabel, s.Name,
				s.Name)
			return
		}
		// glow group wraps ONLY the shape (text stays sharp outside the filter)
		fmt.Fprintf(b, `      <g data-node="%s" data-role="attacker">
        <g filter="url(#glow)">
          <rect x="%.0f" y="%.0f" width="%.0f" height="%.0f" rx="6" fill="%s" stroke="%s" stroke-width="1.5" stroke-dasharray="5 3" />
        </g>
        <text x="%.0f" y="%.0f" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="%s">%s</text>
        <text x="%.0f" y="%.0f" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="%s">%s</text>
        <title>%s</title>
      </g>
`, s.Name,
			s.CX-nodeW/2, s.CY-nodeH/2, nodeW, nodeH, attackerFill, attackerStroke,
			s.CX, s.CY+6, attackerLabel, s.Name, s.CX, s.CY+24, attackerStroke, sub,
			s.Name)
		return
	}

	if s.IsHost {
		fmt.Fprintf(b, `      <g data-node="%s" data-role="host">
        <circle cx="%.0f" cy="%.0f" r="%.0f" fill="%s" stroke="%s" stroke-width="1.5" />
        <text x="%.0f" y="%.0f" text-anchor="middle" font-family="Courier New, monospace" fontSize="13" fontWeight="700" fill="%s">%s</text>
        <text x="%.0f" y="%.0f" text-anchor="middle" font-family="Courier New, monospace" fontSize="9" fill="%s">%s</text>
        <title>%s</title>
      </g>
`, s.Name,
			s.CX, s.CY, hostR, nodeFill, hostStroke,
			s.CX, s.CY+4, hostLabel, s.Name,
			s.CX, s.CY+18, hostStroke, sub,
			s.Name)
		return
	}

	stroke, label := coreStroke, coreLabel
	if s.Role == roleHub {
		stroke, label = hubStroke, hubLabel
	}
	fmt.Fprintf(b, `      <g data-node="%s" data-role="%s">
        <rect x="%.0f" y="%.0f" width="%.0f" height="%.0f" rx="6" fill="%s" stroke="%s" stroke-width="1.5" />
        <text x="%.0f" y="%.0f" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="%s">%s</text>
        <text x="%.0f" y="%.0f" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="%s">%s</text>
        <title>%s</title>
      </g>
`, s.Name, roleName(s.Role),
		s.CX-nodeW/2, s.CY-nodeH/2, nodeW, nodeH, nodeFill, stroke,
		s.CX, s.CY+6, label, s.Name,
		s.CX, s.CY+24, stroke, sub,
		s.Name)
}

func roleName(r nodeRole) string {
	switch r {
	case roleHub:
		return "hub"
	case roleHost:
		return "host"
	case roleAttacker:
		return "attacker"
	default:
		return "core"
	}
}

// renderLegend renders the footer: divider, legend swatches, initial_build line.
func renderLegend(b *strings.Builder, labID int, tpl labsession.TopologyTemplate) {
	build := make([]string, 0, len(tpl.Links))
	for _, l := range tpl.Links {
		build = append(build, fmt.Sprintf("%s(%s)→%s(%s)", l.NodeA, l.IfaceA, l.NodeB, l.IfaceB))
	}
	buildLine := "initial_build: " + strings.Join(build, " · ")
	if r := []rune(buildLine); len(r) > 118 {
		// Truncate on a rune boundary — byte-slicing a Go string can split
		// a multibyte char (· is 2 bytes, → is 3) and emit invalid UTF-8,
		// which breaks XML parsing of the whole SVG downstream.
		buildLine = string(r[:115]) + "..."
	}

	fmt.Fprintf(b, `      <line x1="30" y1="405" x2="690" y2="405" stroke="%s" stroke-width="1" />
      <text x="30" y="424" font-family="Courier New, monospace" fontSize="10" fill="%s">// device_legend</text>

      <rect x="30" y="438" width="12" height="12" rx="2" fill="%s" stroke="%s" stroke-width="1.5" />
      <text x="50" y="448" font-family="Courier New, monospace" fontSize="11" fill="%s">switch / router / firewall</text>

      <rect x="230" y="438" width="12" height="12" rx="2" fill="%s" stroke="%s" stroke-width="1.5" />
      <text x="250" y="448" font-family="Courier New, monospace" fontSize="11" fill="%s">hub — single collision domain</text>

      <circle cx="486" cy="444" r="6" fill="%s" stroke="%s" stroke-width="1.5" />
      <text x="500" y="448" font-family="Courier New, monospace" fontSize="11" fill="%s">end host</text>

      <rect x="580" y="438" width="12" height="12" rx="2" fill="%s" stroke="%s" stroke-width="1.5" stroke-dasharray="3 2" />
      <text x="600" y="448" font-family="Courier New, monospace" fontSize="11" fill="%s">observer / attacker</text>

      <text x="30" y="475" font-family="Courier New, monospace" fontSize="10" fill="%s">
        %s
      </text>
`, chromeLine, chromeText,
		nodeFill, coreStroke, coreLabel,
		nodeFill, hubStroke, hubLabel,
		nodeFill, hostStroke, hostLabel,
		attackerFill, attackerStroke, attackerLabel,
		subText, buildLine)
}

// ── cmdRender ─────────────────────────────────────────────────────────────

func cmdRender(args []string) {
	fs := flag.NewFlagSet("render", flag.ExitOnError)
	posPath := fs.String("positions", "tools/topogen/positions.json", "extracted positions JSON")
	outDir := fs.String("out", "tools/topogen/generated", "output dir for generated SVGs")
	labsFlag := fs.String("labs", "", "comma list of labs to render (default: all with topology)")
	manifestPath := fs.String("manifest", "tools/topogen/manifest.json", "expected node/link manifest for QA (empty to skip)")
	fs.Parse(args)

	pos := loadPositions(*posPath)

	var labs []int
	if *labsFlag != "" {
		for _, s := range strings.Split(*labsFlag, ",") {
			id, err := strconv.Atoi(strings.TrimSpace(s))
			if err != nil {
				fmt.Fprintln(os.Stderr, "bad lab id:", s)
				os.Exit(1)
			}
			labs = append(labs, id)
		}
	} else {
		for id := 1; id <= 46; id++ {
			if len(labsession.TopologyForLab(id).Nodes) > 0 {
				labs = append(labs, id)
			}
		}
	}

	if err := os.MkdirAll(*outDir, 0o755); err != nil {
		fmt.Fprintln(os.Stderr, "mkdir:", err)
		os.Exit(1)
	}
	manifest := map[string]any{}
	generated := 0
	for _, labID := range labs {
		tpl := labsession.TopologyForLab(labID)
		svg := renderLab(labID, posForLab(pos, labID))
		path := filepath.Join(*outDir, fmt.Sprintf("%d.svg", labID))
		if err := os.WriteFile(path, []byte(svg), 0o644); err != nil {
			fmt.Fprintln(os.Stderr, "write:", err)
			os.Exit(1)
		}
		nodes := make([]string, 0, len(tpl.Nodes))
		for _, n := range tpl.Nodes {
			nodes = append(nodes, n.Name)
		}
		links := make([]string, 0, len(tpl.Links))
		for _, l := range tpl.Links {
			links = append(links, fmt.Sprintf("%s:%s↔%s:%s", l.NodeA, l.IfaceA, l.NodeB, l.IfaceB))
		}
		manifest[fmt.Sprintf("%d", labID)] = map[string]any{
			"nodes": nodes,
			"links": links,
		}
		generated++
	}
	if *manifestPath != "" {
		b, err := json.MarshalIndent(manifest, "", "  ")
		if err != nil {
			fmt.Fprintln(os.Stderr, "manifest marshal:", err)
			os.Exit(1)
		}
		if err := os.WriteFile(*manifestPath, b, 0o644); err != nil {
			fmt.Fprintln(os.Stderr, "manifest write:", err)
			os.Exit(1)
		}
	}
	fmt.Printf("render: %d SVGs written to %s\n", generated, *outDir)
}

// loadPositions reads the per-lab positions JSON. Returns a nested map
// keyed by labID string → node name → position. The nesting is REQUIRED:
// node names repeat across labs (SW1, R1, KALI appear in dozens), so a flat
// name-keyed map would silently apply the last lab's coordinates to every
// lab — the exact "KALI's coords assigned to R1" class of bug.
func loadPositions(path string) map[string]map[string]NodePos {
	b, err := os.ReadFile(path)
	if err != nil {
		return map[string]map[string]NodePos{}
	}
	var raw map[string]map[string]NodePos
	if err := json.Unmarshal(b, &raw); err != nil {
		fmt.Fprintln(os.Stderr, "positions parse:", err)
		os.Exit(1)
	}
	return raw
}

func posForLab(pos map[string]map[string]NodePos, labID int) map[string]NodePos {
	return pos[fmt.Sprintf("%d", labID)]
}
