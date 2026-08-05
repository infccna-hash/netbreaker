#!/usr/bin/env python3
"""Verify every clean-lab baseline matches live DB md5(svg_large).

Compares md5(stripped_baseline) against the DB's md5(svg_large). Only labs
whose baselines match byte-for-byte (after stripping the dump newline) can
be safely used as verify_replace old_str.
"""
import hashlib
import json
import os
import subprocess
import sys

BASE = os.path.dirname(os.path.abspath(__file__))
CLEAN_LABS = [1, 3, 4, 5, 8, 10, 12, 14, 17, 18, 20, 32, 37, 38, 43, 44, 46]

SSH = [
    "ssh", "-o", "ConnectTimeout=15", "-o", "BatchMode=yes",
    "root@100.66.106.42",
]


def live_md5s() -> dict:
    q = (
        "docker exec netbreaker-postgres psql -U netbreaker -d netbreaker -t -A "
        '-c "SELECT lab_id || \'|\' || md5(svg_large) FROM lab_topologies WHERE '
        f"lab_id IN ({','.join(map(str, CLEAN_LABS))}) ORDER BY lab_id;\""
    )
    proc = subprocess.run(SSH + [q], capture_output=True, text=True, timeout=90)
    if proc.returncode != 0:
        print("SSH failed:", proc.stderr, file=sys.stderr)
        sys.exit(1)
    out = {}
    for line in proc.stdout.strip().splitlines():
        if "|" in line:
            lab, md5 = line.split("|", 1)
            out[int(lab)] = md5.strip()
    return out


def main() -> int:
    live = live_md5s()
    ok, bad = [], []
    for lab in CLEAN_LABS:
        path = os.path.join(BASE, "baseline", "svg_large", f"{lab}.svg")
        with open(path, "rb") as f:
            content = f.read()
        if content.endswith(b"\n"):
            content = content[:-1]
        local = hashlib.md5(content).hexdigest()
        match = live.get(lab) == local
        (ok if match else bad).append(lab)
        print(f"Lab {lab:2d}: {'MATCH' if match else 'MISMATCH'}  live={live.get(lab)} local={local}")

    print(f"\n{len(ok)} match, {len(bad)} mismatch")
    if bad:
        print("MISMATCHED (CANNOT ship as old_str):", bad, file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
