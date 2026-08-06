#!/usr/bin/env python3
"""
3-source edge-list audit: Go code ↔ SVG geometry ↔ lab_phases text
Detects SEMANTIC mismatches (wrong attachment), not just missing nodes.

For each lab with a Go topology template:
  1. Extract edges from Go code (Node:Iface ↔ Node:Iface)
  2. Extract edges from SVG (geometric proximity: line endpoint → nearest node)
  3. Extract edges from lab_phases content (regex on connection patterns)
  4. Compare all three — any edge present in one source but absent/mismatched
     in another gets flagged by lab number and exact edge.

Usage: python3 audit_topology_edges.py
Requires: SSH access to VPS (root@100.66.106.42)
"""

import subprocess, re, json, math, sys
from collections import defaultdict
from pathlib import Path

VPS = "root@100.66.106.42"
REPO = Path("/home/kobayashi/netbreaker")
GODIR = REPO / "internal" / "labsession"

# ─── STEP 1: Extract edges from Go topology templates ──────────────

def parse_go_topology(lab_id):
    """Extract nodes and links from a labNN_topology.go file."""
    gofile = GODIR / f"lab{lab_id:02d}_topology.go"
    if not gofile.exists():
        return None, None

    code = gofile.read_text()

    # Extract NodeTemplate blocks — format: Name:"SW1", NodeType:"iou", ...
    nodes = {}
    for m in re.finditer(r'NodeTemplate\{([^}]+)\}', code):
        block = m.group(1)
        name = re.search(r'Name:\s*"([^"]+)"', block)
        ntype = re.search(r'NodeType:\s*"([^"]+)"', block)
        if name:
            nodes[name.group(1)] = ntype.group(1) if ntype else "unknown"

    # Extract LinkTemplate blocks — format: {NodeA:"SW1", IfaceA:"Et0/0", NodeB:"SW2", IfaceB:"Et0/1"},
    edges = []
    for m in re.finditer(r'\{NodeA:\s*"([^"]+)",\s*IfaceA:\s*"([^"]+)",\s*NodeB:\s*"([^"]+)",\s*IfaceB:\s*"([^"]+)"\}', code):
        edges.append((m.group(1), m.group(2), m.group(3), m.group(4)))

    return nodes, edges


# ─── STEP 2: Extract edges from SVG via geometric proximity ────────

def parse_svg_edges(svg_text):
    """
    Parse SVG to find node positions and line endpoints, then build
    edges by finding the closest node to each line endpoint.
    Returns list of (nodeA, nodeB) edges and list of raw lines.
    """
    if not svg_text or len(svg_text) < 100:
        return [], []

    # Find all node boxes: <rect> elements with text labels
    node_positions = {}  # name → (cx, cy, x, y, w, h)
    
    # Find rects with rx (rounded — these are nodes)
    rects = list(re.finditer(
        r'<rect\s[^>]*x="([\d.]+)"\s[^>]*y="([\d.]+)"\s[^>]*width="([\d.]+)"\s[^>]*height="([\d.]+)"[^>]*>',
        svg_text
    ))
    
    # Find circles (end hosts in Lab 15 canonical style)
    circles = list(re.finditer(
        r'<circle\s[^>]*cx="([\d.]+)"\s[^>]*cy="([\d.]+)"\s[^>]*r="([\d.]+)"[^>]*>',
        svg_text
    ))

    # Find text elements near each shape to get node name
    all_texts = list(re.finditer(
        r'<text\s[^>]*x="([\d.]+)"\s[^>]*y="([\d.]+)"[^>]*>([^<]+)</text>',
        svg_text
    ))
    
    def clean_name(raw):
        """Strip emoji, suffix markers, whitespace."""
        name = raw.strip()
        # Remove emoji/special chars: 👑 ⚠ ⚡ etc.
        name = re.sub(r'[\U0001F300-\U0001F9FF\u2600-\u27BF\u2B50]', '', name)
        # Remove suffix in parentheses that's not a node name
        name = re.sub(r'\s*\(.*?\)', '', name)
        name = re.sub(r'\s*·.*', '', name)  # KALI · attacker
        return name.strip()

    # For each rect, find the nearest text element (node label)
    for rect in rects:
        try:
            rx, ry = float(rect.group(1)), float(rect.group(2))
            rw, rh = float(rect.group(3)), float(rect.group(4))
            cx, cy = rx + rw/2, ry + rh/2
        except (ValueError, IndexError):
            continue

        # Find closest text within the rect bounds
        best_dist = float('inf')
        best_name = None
        for text in all_texts:
            try:
                tx, ty = float(text.group(1)), float(text.group(2))
                tname = text.group(3)
            except (ValueError, IndexError):
                continue
            
            # Text must be within or near the rect
            if rx - 20 <= tx <= rx + rw + 20 and ry - 5 <= ty <= ry + rh + 10:
                dist = abs(tx - cx) + abs(ty - cy)
                if dist < best_dist:
                    best_dist = dist
                    best_name = clean_name(tname)

        if best_name and best_name:
            node_positions[best_name] = (cx, cy, rx, ry, rw, rh)

    # For each circle, find nearest text
    for circ in circles:
        try:
            ccx, ccy, cr = float(circ.group(1)), float(circ.group(2)), float(circ.group(3))
        except (ValueError, IndexError):
            continue

        best_dist = float('inf')
        best_name = None
        for text in all_texts:
            try:
                tx, ty = float(text.group(1)), float(text.group(2))
                tname = text.group(3)
            except (ValueError, IndexError):
                continue

            dist = math.sqrt((tx - ccx)**2 + (ty - ccy)**2)
            if dist < cr * 1.5:  # text should be inside/near circle
                cname = clean_name(tname)
                if cname and dist < best_dist:
                    best_dist = dist
                    best_name = cname

        if best_name:
            node_positions[best_name] = (ccx, ccy, ccx - cr, ccy - cr, cr * 2, cr * 2)

    # Now find all lines and map endpoints to nearest nodes
    lines = list(re.finditer(
        r'<(?:line|polyline)\s[^>]*>',
        svg_text
    ))

    edges = []
    raw_lines = []

    for line_match in lines:
        tag = line_match.group(0)
        
        # Extract coordinates — handle both <line> and <polyline>
        if tag.startswith('<line'):
            x1 = re.search(r'x1="([\d.]+)"', tag)
            y1 = re.search(r'y1="([\d.]+)"', tag)
            x2 = re.search(r'x2="([\d.]+)"', tag)
            y2 = re.search(r'y2="([\d.]+)"', tag)
            if not all([x1, y1, x2, y2]):
                continue
            segments = [(float(x1.group(1)), float(y1.group(1)),
                        float(x2.group(1)), float(y2.group(1)))]
        elif tag.startswith('<polyline'):
            pts = re.search(r'points="([^"]+)"', tag)
            if not pts:
                continue
            coords = [tuple(map(float, p.split(','))) for p in pts.group(1).split()]
            segments = [(coords[i][0], coords[i][1], coords[i+1][0], coords[i+1][1])
                       for i in range(len(coords) - 1)]
        else:
            continue

        for (sx, sy, ex, ey) in segments:
            raw_lines.append((sx, sy, ex, ey))
            
            # Find nearest node to start and end points
            min_s = (float('inf'), None)
            min_e = (float('inf'), None)
            
            for name, (cx, cy, *_rest) in node_positions.items():
                ds = math.sqrt((sx - cx)**2 + (sy - cy)**2)
                de = math.sqrt((ex - cx)**2 + (ey - cy)**2)
                if ds < min_s[0]:
                    min_s = (ds, name)
                if de < min_e[0]:
                    min_e = (de, name)

            # Only create edge if both endpoints are close to nodes
            # (threshold: 150px — generous to handle long lines)
            if min_s[0] < 150 and min_e[0] < 150 and min_s[1] != min_e[1]:
                edge = tuple(sorted([min_s[1], min_e[1]]))
                edges.append(edge)

    return list(set(edges)), node_positions


# ─── STEP 3: Extract edges from lab content text ────────────────────

def extract_text_edges(content):
    """
    Find connection mentions in content text.
    Patterns: "X connected to Y", "X → Y", "X on Y Etx/x", etc.
    Only returns edges where BOTH sides look like real device names.
    """
    # Known device name patterns
    DEVICE_RE = re.compile(r'^(SW\d+|R\d+|PC\d*|PC-[A-Z]\d*|KALI\d*|FW\d*|AP\d*|WLC\d*|H\d+)$', re.I)
    
    def is_device(name):
        return bool(DEVICE_RE.match(name.strip()))
    
    edges = set()
    
    # Pattern 1: "X → Y" or "X ↔ Y" (diagram-style)
    for m in re.finditer(r'(\w+(?:\d+)?)\s*[→↔]\s*(\w+(?:\d+)?)', content):
        a, b = m.group(1).strip(), m.group(2).strip()
        if a != b and is_device(a) and is_device(b) and len(a) > 1 and len(b) > 1:
            edges.add(tuple(sorted([a, b])))

    # Pattern 2: "X connected to Y" or "X attached to Y"
    for m in re.finditer(r'(\w+(?:\d+)?)\s*(?:is\s+)?(?:connected|attached|wired|linked)\s+(?:to|via)\s+(\w+(?:\d+)?)', content, re.I):
        a, b = m.group(1).strip(), m.group(2).strip()
        if a != b and is_device(a) and is_device(b):
            edges.add(tuple(sorted([a, b])))

    # Pattern 3: "pc1→sw1(et0/2)" — compact notation
    for m in re.finditer(r'(\w+(?:\d+)?)\s*[→↔]\s*(\w+(?:\d+)?)\s*\(', content):
        a, b = m.group(1).strip(), m.group(2).strip()
        if a != b and is_device(a) and is_device(b):
            edges.add(tuple(sorted([a, b])))

    # Pattern 4: "SW1 Et0/0 ↔ SW2" — port-to-node
    for m in re.finditer(r'(\w+(?:\d+)?)\s+\w+(?:\d+)/(?:\d+)\s*[↔→]\s*(\w+(?:\d+)?)', content):
        a, b = m.group(1).strip(), m.group(2).strip()
        if a != b and is_device(a) and is_device(b):
            edges.add(tuple(sorted([a, b])))

    return list(edges)


# ─── MAIN AUDIT ─────────────────────────────────────────────────────

def get_svg_from_db(lab_id):
    """Fetch svg_large from production DB."""
    sql = f"SELECT svg_large FROM lab_topologies WHERE lab_id = {lab_id};"
    try:
        result = subprocess.run(
            ['ssh', '-o', 'ConnectTimeout=10', VPS,
             f'docker exec netbreaker-postgres psql -U netbreaker -d netbreaker -t -c "{sql}"'],
            capture_output=True, text=True, timeout=15
        )
        return result.stdout.strip()
    except Exception as e:
        print(f"  [ERROR fetching Lab {lab_id}: {e}]", file=sys.stderr)
        return ""

def get_content_from_db(lab_id):
    """Fetch all phase content from production DB."""
    sql = f"SELECT content FROM lab_phases WHERE lab_id = {lab_id};"
    try:
        result = subprocess.run(
            ['ssh', '-o', 'ConnectTimeout=10', VPS,
             f'docker exec netbreaker-postgres psql -U netbreaker -d netbreaker -t -c "{sql}"'],
            capture_output=True, text=True, timeout=15
        )
        return result.stdout
    except Exception as e:
        return ""


def edge_set(edges):
    """Normalize: (A, B) → "A↔B" string, case-insensitive, sorted."""
    normalized = set()
    for a, b in edges:
        a, b = a.lower().strip(), b.lower().strip()
        if a and b and a != b:
            normalized.add(tuple(sorted([a, b])))
    return normalized


def main():
    # Find all labs with Go topology templates
    go_files = sorted(GODIR.glob("lab*_topology.go"))
    
    results = []
    
    for gofile in go_files:
        lab_id = int(re.search(r'lab(\d+)_topology', gofile.name).group(1))
        
        # Step 1: Go edges
        nodes, go_edges = parse_go_topology(lab_id)
        if nodes is None:
            continue  # no template file

        go_edge_set = edge_set([(e[0], e[2]) for e in go_edges])

        # Step 2: SVG edges (geometric)
        svg = get_svg_from_db(lab_id)
        svg_edges, svg_nodes = parse_svg_edges(svg)
        svg_edge_set = edge_set(svg_edges)
        
        # Step 3: Text edges
        content = get_content_from_db(lab_id)
        text_edges = extract_text_edges(content)
        text_edge_set = edge_set(text_edges)

        # ── Compare ──
        all_edges = go_edge_set | svg_edge_set | text_edge_set
        issues = []
        
        for edge in sorted(all_edges):
            sources = []
            if edge in go_edge_set:
                sources.append("Go")
            if edge in svg_edge_set:
                sources.append("SVG")
            if edge in text_edge_set:
                sources.append("Text")
            
            if len(sources) < 2:
                # Edge present in only one source — suspicious
                missing = {"Go", "SVG", "Text"} - set(sources)
                issues.append(f"    {edge[0]}↔{edge[1]}: only in {','.join(sources)}, missing from {','.join(sorted(missing))}")

        # Also check: edges in Go but NOT in SVG at all
        go_only = go_edge_set - svg_edge_set - text_edge_set
        svg_only = svg_edge_set - go_edge_set - text_edge_set
        text_only = text_edge_set - go_edge_set - svg_edge_set
        
        # Summary
        status = "CLEAN"
        if issues or go_only or svg_only:
            status = "MISMATCH"
        elif not svg_edges and go_edges:
            status = "SVG_EMPTY"
        elif not svg_edges and not go_edges:
            status = "NO_SVG"

        results.append({
            'lab': lab_id,
            'status': status,
            'go_nodes': len(nodes) if nodes else 0,
            'svg_nodes': len(svg_nodes),
            'go_edges': len(go_edges),
            'svg_edges': len(svg_edges),
            'text_edges': len(text_edges),
            'issues': issues,
            'go_only': go_only,
            'svg_only': svg_only,
        })

    # ── REPORT ──
    print(f"\n{'='*80}")
    print(f"  3-SOURCE EDGE AUDIT — {len(go_files)} labs with Go topology templates")
    print(f"{'='*80}\n")

    by_status = defaultdict(list)
    for r in results:
        by_status[r['status']].append(r)

    for status in ["MISMATCH", "SVG_EMPTY", "CLEAN"]:
        items = by_status.get(status, [])
        if not items:
            continue
        print(f"── {status} ({len(items)} labs) ──")
        for r in sorted(items, key=lambda x: x['lab']):
            print(f"\n  Lab {r['lab']:>2}: Go={r['go_edges']}edges, SVG={r['svg_edges']}edges, "
                  f"Text={r['text_edges']}edges, "
                  f"GoNodes={r['go_nodes']}, SVGNodes={r['svg_nodes']}")
            if r['go_only']:
                print(f"    Go-only edges (missing from SVG+Text):")
                for e in sorted(r['go_only']):
                    print(f"      {e[0]}↔{e[1]}")
            if r['svg_only']:
                print(f"    SVG-only edges (not in Go):")
                for e in sorted(r['svg_only']):
                    print(f"      {e[0]}↔{e[1]}")
            for issue in r['issues']:
                print(issue)

    print(f"\n{'='*80}")
    clean = len(by_status.get('CLEAN', []))
    mismatch = len(by_status.get('MISMATCH', []))
    empty = len(by_status.get('SVG_EMPTY', []))
    print(f"  CLEAN: {clean}  |  MISMATCH: {mismatch}  |  SVG_EMPTY: {empty}")
    print(f"{'='*80}")


if __name__ == '__main__':
    main()
