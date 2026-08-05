#!/usr/bin/env python3
"""Report chip pair distances to distinguish real collisions from marginal ones."""
import re
import sys

svg = open(sys.argv[1]).read()
chips = []
for m in re.finditer(r'<g data-port="([^"]+)"[^>]*>\s*<rect x="([\d.]+)" y="([\d.]+)" width="([\d.]+)" height="([\d.]+)"', svg):
    name, x, y, w, h = m.group(1), *map(float, m.groups()[1:])
    chips.append((name, x + w / 2, y + h / 2))

pairs = []
for i in range(len(chips)):
    for j in range(i + 1, len(chips)):
        n1, ax, ay = chips[i]
        n2, bx, by = chips[j]
        d = ((ax - bx) ** 2 + (ay - by) ** 2) ** 0.5
        if d < 45:
            pairs.append((d, n1, n2, ax, ay, bx, by))
pairs.sort()
for d, n1, n2, ax, ay, bx, by in pairs:
    flag = "BAD" if d < 18 else "marginal"
    print(f"  [{flag}] d={d:.0f}  {n1}@({ax:.0f},{ay:.0f}) vs {n2}@({bx:.0f},{by:.0f})")
print(f"total pairs < 45px: {len(pairs)}")
