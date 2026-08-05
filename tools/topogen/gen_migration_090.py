#!/usr/bin/env python3
"""Generate migration 090 SQL: replace svg_large for the 20 newly-clean labs.

Same pattern as 089 (verify_replace safeguard). Labs 9/25/29 remain manual —
dense congestion clusters the relaxation pass could not resolve (per the
timebox decision). Lab 36 ships on eyeball QA (user confirmed clean despite
G5 over-flag). Lab 39 ships after the legend-collision fix (G9 gate).
"""
import os
import sys

BASE = os.path.dirname(os.path.abspath(__file__))
BASELINE = os.path.join(BASE, "baseline", "svg_large")
GENERATED = os.path.join(BASE, "generated")

M090_LABS = [2, 6, 7, 11, 13, 15, 16, 19, 21, 24, 26, 27, 28, 31, 33, 34, 35, 36, 39, 45]
MANUAL = [9, 25, 29]


def dollar_quote(s: str) -> str:
    if "$md$" in s:
        raise ValueError("SVG contains $md$ — pick another delimiter")
    return "$md$" + s + "$md$"


def main() -> int:
    up_lines = [
        "-- Migration 090: canonical generated SVGs for 20 more labs (topogen batch 2)",
        "-- Replaces svg_large with generator output for labs that passed geometric",
        "-- QA + visual QA. Extends 089's pattern (verify_replace, byte-exact).",
        "-- Labs 9, 25, 29 remain manual (dense congestion clusters — see qa_geometry).",
        "",
    ]
    down_lines = [
        "-- Migration 090 DOWN: restore baseline hand-authored SVGs (reverse of UP).",
        "",
    ]

    missing = []
    for lab in M090_LABS:
        old_path = os.path.join(BASELINE, f"{lab}.svg")
        new_path = os.path.join(GENERATED, f"{lab}.svg")
        if not os.path.exists(old_path) or not os.path.exists(new_path):
            missing.append(lab)
            continue
        with open(old_path) as f:
            old = f.read()
        with open(new_path) as f:
            new = f.read()
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

    up_path = os.path.join(BASE, "..", "..", "migrations", "090_topogen_svgs_batch2.up.sql")
    down_path = os.path.join(BASE, "..", "..", "migrations", "090_topogen_svgs_batch2.down.sql")
    with open(up_path, "w") as f:
        f.write("\n".join(up_lines))
    with open(down_path, "w") as f:
        f.write("\n".join(down_lines))

    print(f"wrote {up_path} ({os.path.getsize(up_path)} bytes, {len(M090_LABS)} labs)")
    print(f"wrote {down_path} ({os.path.getsize(down_path)} bytes)")
    print(f"manual (not in 090): {MANUAL}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
