#!/usr/bin/env python3
"""Debug chip collisions in a generated SVG."""
import re
import sys

svg = open(sys.argv[1]).read()

print("=== chips ===")
chips = []
for m in re.finditer(r'<g data-port="([^"]+)"[^>]*>\s*<rect x="([\d.]+)" y="([\d.]+)" width="([\d.]+)" height="([\d.]+)"', svg):
    name, x, y, w, h = m.group(1), *map(float, m.groups()[1:])
    chips.append((name, x + w / 2, y + h / 2))
    print(f"  {name:6s} center=({x+w/2:.0f},{y+h/2:.0f})")

print("\n=== chip pairs < 30px apart ===")
for i in range(len(chips)):
    for j in range(i + 1, len(chips)):
        n1, ax, ay = chips[i]
        n2, bx, by = chips[j]
        d = ((ax - bx) ** 2 + (ay - by) ** 2) ** 0.5
        if d < 30:
            print(f"  {n1} vs {n2}: d={d:.0f}")

print("\n=== nodes ===")
for m in re.finditer(r'<g data-node="([^"]+)"[^>]*data-role="([^"]+)"[^>]*>', svg):
    print(f"  {m.group(1):6s} role={m.group(2)}")
