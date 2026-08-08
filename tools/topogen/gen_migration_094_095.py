#!/usr/bin/env python3
"""Generate migrations 094 + 095: min-gap fixed SVGs.

Migration 094: Labs 43, 44 — the planned min-gap targets (duplicate
topology, sim-verified FAIL->PASS with vertical push).
Migration 095: Labs 33, 45 — discovered as a side-effect of the same
code change, eyeball-verified separately. Kept in a separate migration
so rollback of either batch is independent (same traceability as 093).

old_str = current generated SVG (pre-min-gap, the DB state);
new_str = post-min-gap render. verify_replace fails loudly on drift.
"""
import os
import subprocess
import sys

BASE = os.path.dirname(os.path.abspath(__file__))
GENERATED = os.path.join(BASE, "generated")

M094_LABS = [43, 44]
M095_LABS = [33, 45]


def dollar_quote(s: str) -> str:
    if "$md$" in s:
        raise ValueError("SVG contains $md$ — pick another delimiter")
    return "$md$" + s + "$md$"


def build_migration(num, name, labs, note_lines):
    up_lines = [
        f"-- Migration {num}: {name}",
    ] + [f"-- {n}" for n in note_lines] + [
        "",
    ]
    down_lines = [
        f"-- Migration {num} DOWN: restore pre-min-gap renders (reverse of UP).",
        "",
    ]
    missing = []
    for lab in labs:
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
        print(f"MISSING for {num}: {missing}", file=sys.stderr)
        return 1
    up_path = os.path.join(BASE, "..", "..", "migrations", f"{num}_topogen_{name}.up.sql")
    down_path = os.path.join(BASE, "..", "..", "migrations", f"{num}_topogen_{name}.down.sql")
    with open(up_path, "w") as f:
        f.write("\n".join(up_lines))
    with open(down_path, "w") as f:
        f.write("\n".join(down_lines))
    print(f"wrote {up_path} ({os.path.getsize(up_path)} bytes, {len(labs)} labs)")
    print(f"wrote {down_path} ({os.path.getsize(down_path)} bytes)")
    return 0


def main():
    ok = 0
    ok += build_migration(
        94,
        "mingap_svgs_2labs",
        M094_LABS,
        [
            "enforceAutoMinGap: auto-layout nodes pushed to 66px chip-clearance",
            "from same-column neighbors (extracted positions never moved).",
            "Planned targets: duplicate topology (43/44), sim-verified FAIL->PASS.",
        ],
    )
    ok += build_migration(
        95,
        "mingap_sideeffect_2labs",
        M095_LABS,
        [
            "SAME code change as 094, but these two were NOT planned targets —",
            "they resolved as a verified side-effect (SW1 push down cleared the",
            "hidden chips). Eyeball-confirmed separately. Kept in their own",
            "migration so rollback stays independent.",
        ],
    )
    return 0 if ok == 0 else 1


if __name__ == "__main__":
    sys.exit(main())
