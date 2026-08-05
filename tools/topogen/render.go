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
func autoLayout(shapes []nodeShape, used map[string]bool) []nodeShape {
	var core, leaf []nodeShape
	for _, s := range shapes {
		if used[s.Name] {
			continue
		}
		if s.Role == roleHost || s.Role == roleAttacker {
			leaf = append(leaf, s)
		} else {
			core = append(core, s)
		}
	}
	sort.Slice(core, func(i, j int) bool { return core[i].Name < core[j].Name })
	sort.Slice(leaf, func(i, j int) bool { return leaf[i].Name < leaf[j].Name })

	place := func(list []nodeShape, startY float64) {
		perRow := 4
		for i, s := range list {
			row := i / perRow
			col := i % perRow
			// center the row's columns around view middle
			rowCount := perRow
			if rem := len(list) - row*perRow; rem < rowCount {
				rowCount = rem
			}
			totalW := float64(rowCount)*cellW - 50
			x0 := (viewW - totalW) / 2
			s.CX = x0 + float64(col)*cellW + cellW/2
			s.CY = startY + float64(row)*cellH
			list[i] = s
		}
	}
	place(core, 110)
	place(leaf, 110+cellH*float64(max(1, (len(core)+3)/4)))
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

	// build from extracted positions
	build := func(useExtracted bool) ([]nodeShape, map[string]nodeShape) {
		shapes := make([]nodeShape, 0, len(tpl.Nodes))
		byName := map[string]nodeShape{}
		used := map[string]bool{}

		if useExtracted {
			for _, n := range tpl.Nodes {
				p, ok := pos[n.Name]
				if !ok {
					continue
				}
				s := nodeShape{Name: n.Name, Role: roleOf(n)}
				if p.Shape == "circle" {
					s.IsHost = true
					s.CX, s.CY = p.X, p.Y
				} else {
					s.CX = p.X + p.W/2
					s.CY = p.Y + p.H/2
				}
				if s.Role == roleHost {
					s.IsHost = true
				}
				shapes = append(shapes, s)
				byName[n.Name] = s
				used[n.Name] = true
			}
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

// layoutValid reports whether a computed layout can render legibly:
//   - every link's node-to-node gap must fit the two 42px-wide port chips
//     (24px offset each side + a little margin)
//   - no two node footprints may overlap
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
	// link gap check: each link needs ~96px between node edges for two chips
	for _, link := range tpl.Links {
		a, okA := byName[link.NodeA]
		b, okB := byName[link.NodeB]
		if !okA || !okB {
			continue
		}
		ax, ay := edgePoint(a, b)
		bx, by := edgePoint(b, a)
		gap := math.Hypot(bx-ax, by-ay)
		if gap < 96 {
			return false
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
	// A node with multiple links gets its chips fanned around the node edge
	// (per-link angular offset) so they don't stack on the same spot.
	// Additionally, the two chips of ONE link get opposite perpendicular
	// offsets so they don't collide mid-link when the nodes sit close.
	incident := map[string][]string{} // node name -> list of link keys
	for _, link := range tpl.Links {
		key := fmt.Sprintf("%s:%s↔%s:%s", link.NodeA, link.IfaceA, link.NodeB, link.IfaceB)
		incident[link.NodeA] = append(incident[link.NodeA], key)
		incident[link.NodeB] = append(incident[link.NodeB], key)
	}
	chipIdx := map[string]int{}
	for _, link := range tpl.Links {
		a, okA := byName[link.NodeA]
		bnd, okB := byName[link.NodeB]
		if !okA || !okB {
			continue
		}
		key := fmt.Sprintf("%s:%s↔%s:%s", link.NodeA, link.IfaceA, link.NodeB, link.IfaceB)
		off := parallel[key]
		renderPortChip(&b, a, bnd, link.NodeA, link.IfaceA, chipIdx[link.NodeA], len(incident[link.NodeA]), +1, off)
		chipIdx[link.NodeA]++
		renderPortChip(&b, bnd, a, link.NodeB, link.IfaceB, chipIdx[link.NodeB], len(incident[link.NodeB]), -1, off)
		chipIdx[link.NodeB]++
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

func renderPortChip(b *strings.Builder, owner, other nodeShape, nodeName, iface string, idx, total int, perpSign int, parallelOff float64) {
	// fan-out: rotate the chip around the node edge by a small angle per link,
	// centered on the link direction. For 1 link, angle = 0 (straight out).
	var angle float64
	if total > 1 {
		// spread ±24° across the node's links
		angle = (float64(idx) - float64(total-1)/2) * (48.0 / float64(total))
	}
	dirX, dirY := other.CX-owner.CX, other.CY-owner.CY
	len := math.Hypot(dirX, dirY)
	if len == 0 {
		dirX, dirY = 1, 0
	} else {
		dirX, dirY = dirX/len, dirY/len
	}
	// rotate the direction by angle degrees
	rad := angle * math.Pi / 180.0
	cosA, sinA := math.Cos(rad), math.Sin(rad)
	rotX := dirX*cosA - dirY*sinA
	rotY := dirX*sinA + dirY*cosA

	// perpendicular offset: the two chips of one link sit on opposite sides
	// of the link line, so they can't collide mid-link when nodes are close
	perpX, perpY := -rotY, rotX

	// place chip just outside the node boundary along the (rotated) direction,
	// nudged perpendicular by perpSign + the link's parallel-line offset
	ex, ey := edgePoint(owner, other)
	cx := ex + rotX*24 + perpX*float64(perpSign)*7 + perpX*parallelOff
	cy := ey + rotY*24 + perpY*float64(perpSign)*7 + perpY*parallelOff
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
	generated := 0
	for _, labID := range labs {
		svg := renderLab(labID, posForLab(pos, labID))
		path := filepath.Join(*outDir, fmt.Sprintf("%d.svg", labID))
		if err := os.WriteFile(path, []byte(svg), 0o644); err != nil {
			fmt.Fprintln(os.Stderr, "write:", err)
			os.Exit(1)
		}
		generated++
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
