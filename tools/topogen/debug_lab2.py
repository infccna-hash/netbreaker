#!/usr/bin/env python3
"""Debug: dump what qa_geometry parses for Lab 2's generated SVG."""
import re
import sys

svg = open('tools/topogen/generated/2.svg').read()

print("=== core data-node groups ===")
for m in re.finditer(r'<g data-node="([^"]+)"[^>]*>\s*<rect x="([\d.]+)" y="([\d.]+)"', svg):
    print(f"  {m.group(1)} rect at ({m.group(2)},{m.group(3)})")

print("=== glow attacker groups ===")
for m in re.finditer(r'<g filter="url\(#glow\)">\s*<rect x="([\d.]+)" y="([\d.]+)"', svg):
    print(f"  glow rect at ({m.group(1)},{m.group(2)})")

print("=== all <text> contents with position ===")
for m in re.finditer(r'<text x="([\d.]+)" y="([\d.]+)"[^>]*>([^<]*)</text>', svg):
    content = m.group(3).strip()
    if content and not content.startswith('//') and 'root@' not in content:
        print(f"  ({m.group(1)},{m.group(2)}) {content!r}")

print("=== circle elements ===")
for m in re.finditer(r'<circle cx="([\d.]+)" cy="([\d.]+)" r="([\d.]+)"', svg):
    print(f"  circle at ({m.group(1)},{m.group(2)}) r={m.group(3)}")

print("=== port chips ===")
for m in re.finditer(r'<g data-port="([^"]+)"[^>]*>\s*<rect x="([\d.]+)" y="([\d.]+)"', svg):
    print(f"  chip {m.group(1)} at ({m.group(2)},{m.group(3)})")
