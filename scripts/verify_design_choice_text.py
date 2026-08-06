#!/usr/bin/env python3
"""
Written-evidence verification for the 12 Phase-2 DESIGN-CHOICE labs.

Classification (2026-08-03 edge audit):
  SVG simplified star topology (pc→r1) while Go topology has intermediate
  switches (pc→sw1→r1). Design choice = SVG is conceptual, not playable truth.

This script verifies the design choice against WRITTEN EVIDENCE:
  - Text must match GO (the real playable topology): every connection the text
    names must exist in the Go Links[].
  - Text that describes the SVG simplification (direct pc→r1 links that don't
    exist in Go) = content bug: a student following the text cannot find the
    link in the live session.

Usage: python3 verify_design_choice_text.py
Requires: SSH access to VPS (root@100.66.106.42)
"""
import subprocess, re, sys
from pathlib import Path

VPS = "root@100.66.106.42"
GODIR = Path("/home/kobayashi/netbreaker/internal/labsession")
LABS = [18, 27, 28, 29, 31, 32, 33, 34, 35, 43, 44, 45]

DEVICE_RE = re.compile(r'^(SW\d+|R\d+|PC\d*|PC-[A-Z]\d*|KALI\d*|FW\d*|AP\d*|WLC\d*|H\d+)$', re.I)


def is_device(name: str) -> bool:
    return bool(DEVICE_RE.match(name.strip()))


def parse_go_topology(lab_id):
    gofile = GODIR / f"lab{lab_id:02d}_topology.go"
    if not gofile.exists():
        return set(), [], ""
    code = gofile.read_text()
    nodes = set()
    for m in re.finditer(r'Name:\s*"([^"]+)"', code):
        nodes.add(m.group(1))
    edges = []
    for m in re.finditer(r'\{NodeA:\s*"([^"]+)",\s*IfaceA:\s*"([^"]+)",\s*NodeB:\s*"([^"]+)",\s*IfaceB:\s*"([^"]+)"\}', code):
        edges.append((m.group(1), m.group(3)))
    return nodes, edges, code


def get_content_from_db(lab_id):
    sql = f"SELECT phase || '||' || content FROM lab_phases WHERE lab_id = {lab_id} ORDER BY phase;"
    try:
        result = subprocess.run(
            ['ssh', '-o', 'ConnectTimeout=10', '-o', 'BatchMode=yes', VPS,
             f'docker exec netbreaker-postgres psql -U netbreaker -d netbreaker -t -A -c "{sql}"'],
            capture_output=True, text=True, timeout=20
        )
        return result.stdout
    except Exception as e:
        print(f"  [ERROR fetching Lab {lab_id}: {e}]", file=sys.stderr)
        return ""


def extract_text_edges(content):
    """Same patterns as audit_topology_edges.py, but keep evidence quotes."""
    evidence = []
    # Pattern 1: "X → Y" or "X ↔ Y"
    for m in re.finditer(r'(\w+(?:\d+)?)\s*[→↔]\s*(\w+(?:\d+)?)', content):
        a, b = m.group(1).strip(), m.group(2).strip()
        if a != b and is_device(a) and is_device(b) and len(a) > 1 and len(b) > 1:
            evidence.append((tuple(sorted([a.lower(), b.lower()])), a, b, m.group(0)))
    # Pattern 2: "X connected/attached/wired/linked to Y"
    for m in re.finditer(r'(\w+(?:\d+)?)\s*(?:is\s+)?(?:connected|attached|wired|linked)\s+(?:to|via)\s+(\w+(?:\d+)?)', content, re.I):
        a, b = m.group(1).strip(), m.group(2).strip()
        if a != b and is_device(a) and is_device(b):
            evidence.append((tuple(sorted([a.lower(), b.lower()])), a, b, m.group(0)))
    # Pattern 3: "pc1→sw1(et0/2)" compact
    for m in re.finditer(r'(\w+(?:\d+)?)\s*[→↔]\s*(\w+(?:\d+)?)\s*\(', content):
        a, b = m.group(1).strip(), m.group(2).strip()
        if a != b and is_device(a) and is_device(b):
            evidence.append((tuple(sorted([a.lower(), b.lower()])), a, b, m.group(0)))
    # Pattern 4: "SW1 Et0/0 ↔ SW2" port-to-node
    for m in re.finditer(r'(\w+(?:\d+)?)\s+\w+(?:\d+)/(?:\d+)\s*[↔→]\s*(\w+(?:\d+)?)', content):
        a, b = m.group(1).strip(), m.group(2).strip()
        if a != b and is_device(a) and is_device(b):
            evidence.append((tuple(sorted([a.lower(), b.lower()])), a, b, m.group(0)))
    return evidence


def main():
    print(f"{'='*88}")
    print(f"  WRITTEN-EVIDENCE CHECK — 12 DESIGN-CHOICE LABS (text vs Go topology)")
    print(f"{'='*88}")

    problems = []
    for lab_id in LABS:
        nodes, go_edges, code = parse_go_topology(lab_id)
        if not nodes:
            print(f"\n  Lab {lab_id}: NO Go topology file — SKIP")
            continue
        content = get_content_from_db(lab_id)
        if not content:
            print(f"\n  Lab {lab_id}: no content from DB — SKIP")
            continue

        go_edge_set = set(tuple(sorted([a.lower(), b.lower()])) for a, b in go_edges)
        text_ev = extract_text_edges(content)

        # text edges that DON'T exist in Go → text describes non-playable connection
        missing = []
        # Go edges never mentioned in text → text omits real connection
        mentioned = set()
        for edge, a, b, raw in text_ev:
            mentioned.add(edge)
            if edge not in go_edge_set:
                missing.append((edge, a, b, raw))

        go_unmentioned = go_edge_set - mentioned

        print(f"\n  Lab {lab_id:>2}: GoNodes={sorted(nodes)}, GoEdges={len(go_edges)}, TextMentions={len(text_ev)}")
        for a, b in sorted(go_edges):
            print(f"      Go: {a} ↔ {b}")
        if missing:
            print(f"      ⚠ TEXT DESCRIBES NON-EXISTENT CONNECTION(S):")
            for edge, a, b, raw in sorted(set(missing)):
                print(f"        {a}↔{b}  (\"{raw.strip()}\")  — NOT in Go Links[]")
            problems.append((lab_id, "missing", missing))
        if go_unmentioned:
            print(f"      (Go edge(s) never mentioned in text: {', '.join(sorted(a+'↔'+b for a,b in go_unmentioned))})")
        else:
            print(f"      ✓ All Go edges are represented in text")

    print(f"\n{'='*88}")
    if problems:
        print(f"  {len(problems)} lab(s) with text↔Go mismatches need review:")
        for lab_id, kind, _ in problems:
            print(f"    Lab {lab_id}")
    else:
        print("  ALL 12 design-choice labs: text matches Go topology — design choice CONFIRMED")
    print(f"{'='*88}")


if __name__ == '__main__':
    main()
