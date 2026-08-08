#!/usr/bin/env python3
"""Generate migration 096 SQL: replace svg_large for the 3 Category B labs.

The unshoveChips renderer pass (added 2026-08-08) resolves chips that END
inside their own owner's box after the full placement pipeline (relaxChips ->
flipChips -> applyChipOverrides -> unshoveChips). relaxChips pushes overlapping
chip pairs apart along their center vector with no knowledge of node
footprints — in a tight triangle the push can shove a chip INTO its own
owner's box. unshoveChips walks the offending chip outward along the ray from
its owner's center through the chip position, in 2px steps up to the G4 bound
(120px), taking the FIRST position that clears the own box AND stays clear of
canvas (G1), header (G8), legend (G9), other chips (G5) and all node boxes
(own eps 6, foreign eps 2 — the same chipBoxHit the gate uses).

The 3 labs here (21, 24, 28) went from FAIL -> PASS on the full geometry
suite (G0-G10) after unshove. old_str is the HEAD-committed generated SVG
(the current DB state — 090-era render for these labs, which is what the DB
holds); new_str is the post-unshove render. verify_replace fails loudly if
the DB has drifted.

Byte-identical criterion (verified 2026-08-08): regenerating with unshove
changes ONLY labs that have actual own-box violations — 34/40 labs
regenerate byte-identical vs the HEAD-source render. The 3 shipped labs are
the ones with the cleanest signal: all their G10 failures were own-node hits.
"""
import os
import subprocess
import sys

BASE = os.path.dirname(os.path.abspath(__file__))
GENERATED = os.path.join(BASE, "generated")

M096_LABS = [21, 24, 28]
MANUAL = [6, 9, 12, 13, 14, 19, 25, 29, 31, 39]


def dollar_quote(s: str) -> str:
    if "$md$" in s:
        raise ValueError("SVG contains $md$ — pick another delimiter")
    return "$md$" + s + "$md$"


def main() -> int:
    up_lines = [
        "-- Migration 096: post-unshove generated SVGs for 3 Category B labs",
        "-- unshoveChips resolves G10 own-node chip violations (chips shoved",
        "-- INTO their own owner's box by the relaxation pass). These labs went",
        "-- FAIL->PASS on G0-G10 (Lab 21 had 4 own-node hits, Lab 24 had 2,",
        "-- Lab 28 had 2). old_str = HEAD-committed render (current DB);",
        "-- new_str = post-unshove render.",
        "-- Labs 6,9,12,13,14,19,25,29,31,39 remain (A2 extracted gaps,",
        "-- dense clusters, and auto-layout boxed-in cases).",
        "",
    ]
    down_lines = [
        "-- Migration 096 DOWN: restore the pre-unshove renders (reverse of UP).",
        "",
    ]

    missing = []
    for lab in M096_LABS:
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

    up_path = os.path.join(BASE, "..", "..", "migrations", "096_unshove_svgs_3labs.up.sql")
    down_path = os.path.join(BASE, "..", "..", "migrations", "096_unshove_svgs_3labs.down.sql")
    with open(up_path, "w") as f:
        f.write("\n".join(up_lines))
    with open(down_path, "w") as f:
        f.write("\n".join(down_lines))

    print(f"wrote {up_path} ({os.path.getsize(up_path)} bytes, {len(M096_LABS)} labs)")
    print(f"wrote {down_path} ({os.path.getsize(down_path)} bytes)")
    print(f"manual (not in 096): {MANUAL}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
