#!/usr/bin/env python3
"""Generate migration 093 SQL: replace svg_large for the 8 flip-fixed labs.

The chip-flip renderer pass (flipChips) resolves G10 chip-vs-node-box
collisions by rotating/sliding each colliding chip to the nearest valid
position on its link axis, keeping the chip visually attached to its link
(score = link distance + 0.1*owner distance, all candidates bounded by
G1/G4/G5/G8/G9).

The 8 labs here went from FAIL -> PASS on the full geometry suite (G0-G10)
after the flip. old_str is the 090-era generated SVG (the current DB state);
new_str is the post-flip render. verify_replace fails loudly if the DB has
drifted (hand-edit, re-application, or a 090 mismatch).
"""
import os
import subprocess
import sys

BASE = os.path.dirname(os.path.abspath(__file__))
GENERATED = os.path.join(BASE, "generated")

M093_LABS = [2, 7, 11, 15, 27, 32, 34, 35]
MANUAL = [6, 9, 12, 13, 14, 19, 21, 24, 25, 28, 29, 31, 33, 39, 43, 44, 45]


def dollar_quote(s: str) -> str:
    if "$md$" in s:
        raise ValueError("SVG contains $md$ — pick another delimiter")
    return "$md$" + s + "$md$"


def main() -> int:
    up_lines = [
        "-- Migration 093: post-flip generated SVGs for 8 labs (chip-flip pass)",
        "-- flipChips resolves G10 chip-vs-node-box collisions (rotations + link-axis",
        "-- slides, scoring by link proximity). These labs went FAIL->PASS on G0-G10.",
        "-- old_str = 090-era render (current DB); new_str = post-flip render.",
        "-- Labs 6,9,12,13,14,19,21,24,25,28,29,31,33,39,43,44,45 remain manual",
        "-- (dense clusters — min-gap work is next).",
        "",
    ]
    down_lines = [
        "-- Migration 093 DOWN: restore the 090-era renders (reverse of UP).",
        "",
    ]

    missing = []
    for lab in M093_LABS:
        new_path = os.path.join(GENERATED, f"{lab}.svg")
        if not os.path.exists(new_path):
            missing.append(lab)
            continue
        with open(new_path) as f:
            new = f.read()
        try:
            old = subprocess.check_output(
                ["git", "show", f"HEAD:tools/topogen/generated/{lab}.svg"]
            ).decode()
        except subprocess.CalledProcessError:
            missing.append(lab)
            continue
        # strip the dump-script trailing newline so old_str matches the DB
        if old.endswith("\n"):
            old = old[:-1]

        up_lines.append(
            f"UPDATE lab_topologies SET svg_large = verify_replace(svg_large,\n"
            f"  {dollar_quote(old)},\n"
            f"  {dollar_quote(new)})\n"
            f"WHERE lab_id = {lab};\n"
        )
        down_lines.append(
            f"UPDATE lab_topologies SET svg_large = verify_replace(svg_large,\n"
            f"  {dollar_quote(new)},\n"
            f"  {dollar_quote(old)})\n"
            f"WHERE lab_id = {lab};\n"
        )

    if missing:
        print(f"MISSING SVG FILES for labs: {missing}", file=sys.stderr)
        return 1

    up_path = os.path.join(BASE, "..", "..", "migrations", "093_flip_svgs_8labs.up.sql")
    down_path = os.path.join(BASE, "..", "..", "migrations", "093_flip_svgs_8labs.down.sql")
    with open(up_path, "w") as f:
        f.write("\n".join(up_lines))
    with open(down_path, "w") as f:
        f.write("\n".join(down_lines))

    print(f"wrote {up_path} ({os.path.getsize(up_path)} bytes, {len(M093_LABS)} labs)")
    print(f"wrote {down_path} ({os.path.getsize(down_path)} bytes)")
    print(f"manual (not in 093): {MANUAL}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
