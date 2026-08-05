#!/usr/bin/env python3
"""Generate migration 089 SQL: replace svg_large for the 17 clean labs.

Pattern mirrors 088's verify_replace() safeguard: UPDATE ... SET col =
verify_replace(col, $md$<baseline svg>$md$, $md$<generated svg>$md$) WHERE
lab_id = N. If the live DB's svg_large doesn't match the dumped baseline
byte-for-byte, verify_replace RAISES — a hand-edited SVG in prod would fail
loudly instead of being silently overwritten.

Only svg_large is touched (the frontend renders svg_large || svg_small, so
large wins). The 23 flagged labs are NOT in this migration.

The DOWN migration is the reverse: verify_replace(new, old).
"""
import json
import os
import sys

BASE = os.path.dirname(os.path.abspath(__file__))
BASELINE = os.path.join(BASE, "baseline", "svg_large")
GENERATED = os.path.join(BASE, "generated")

CLEAN_LABS = [1, 3, 4, 5, 8, 10, 12, 14, 17, 18, 20, 32, 37, 38, 43, 44, 46]


def dollar_quote(s: str) -> str:
    """Wrap in $md$...$md$ dollar quoting (content must not contain $md$)."""
    if "$md$" in s:
        raise ValueError("SVG contains $md$ — pick another delimiter")
    return "$md$" + s + "$md$"


def main() -> int:
    up_lines = [
        "-- Migration 089: canonical generated SVGs for 17 clean labs (topogen)",
        "-- Replaces svg_large with generator output for labs whose layouts passed",
        "-- geometric QA (G0-G5 clean). Generated from Go topology structs — the",
        "-- single source of truth — so SVG and provisioning cannot drift.",
        "-- Uses verify_replace() (062): fails loudly if the live DB's SVG differs",
        "-- from the dumped baseline (hand-edit, drift, or re-application).",
        "-- 23 flagged labs (2,6,7,9,11,13,15,16,19,21,24,25,26,27,28,29,31,33,34,",
        "-- 35,36,39,45) are NOT touched — they keep hand-authored SVGs pending",
        "-- manual visual QA.",
        "",
    ]
    down_lines = [
        "-- Migration 089 DOWN: restore baseline hand-authored SVGs (reverse of UP).",
        "",
    ]

    missing = []
    for lab in CLEAN_LABS:
        old_path = os.path.join(BASELINE, f"{lab}.svg")
        new_path = os.path.join(GENERATED, f"{lab}.svg")
        if not os.path.exists(old_path) or not os.path.exists(new_path):
            missing.append(lab)
            continue
        with open(old_path) as f:
            old = f.read()
        with open(new_path) as f:
            new = f.read()
        # The dump script appended a trailing newline after each SVG; the DB
        # value has none (verified: stripped md5 == live md5(svg_large)).
        # verify_replace's old_str must match the DB byte-for-byte or it
        # RAISEs in production. Strip exactly one trailing newline.
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

    up_path = os.path.join(BASE, "..", "..", "migrations", "089_topogen_svgs_clean17.up.sql")
    down_path = os.path.join(BASE, "..", "..", "migrations", "089_topogen_svgs_clean17.down.sql")
    with open(up_path, "w") as f:
        f.write("\n".join(up_lines))
    with open(down_path, "w") as f:
        f.write("\n".join(down_lines))

    size = sum(os.path.getsize(os.path.join(GENERATED, f"{lab}.svg")) for lab in CLEAN_LABS)
    print(f"wrote {up_path} ({os.path.getsize(up_path)} bytes, {len(CLEAN_LABS)} labs, {size} bytes of new SVG)")
    print(f"wrote {down_path} ({os.path.getsize(down_path)} bytes)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
