#!/usr/bin/env python3
"""Dump lab_topologies to disk as per-lab files (baseline for topogen).

Uses Postgres row_to_json so embedded newlines in SVG are handled by JSON,
not TSV parsing. Output layout:
  baseline/svg_small/<lab_id>.svg
  baseline/svg_large/<lab_id>.svg
  baseline/legend.json        # {lab_id: [legend items]}
"""
import json
import os
import subprocess
import sys

BASE = os.path.dirname(os.path.abspath(__file__))
BASELINE = os.path.join(BASE, "baseline")

SSH_CMD = [
    "ssh", "-o", "ConnectTimeout=15", "-o", "BatchMode=yes",
    "root@100.66.106.42",
]
PSQL_QUERY = (
    "docker exec netbreaker-postgres psql -U netbreaker -d netbreaker -t -A "
    "-c \"SELECT json_agg(row_to_json(t)) FROM (SELECT lab_id, svg_small, svg_large, "
    "COALESCE(legend::text,'[]') AS legend FROM lab_topologies ORDER BY lab_id) t;\""
)


def main() -> int:
    os.makedirs(os.path.join(BASELINE, "svg_small"), exist_ok=True)
    os.makedirs(os.path.join(BASELINE, "svg_large"), exist_ok=True)

    print("running remote query...", file=sys.stderr)
    proc = subprocess.run(
        SSH_CMD + [PSQL_QUERY], capture_output=True, text=True, timeout=120
    )
    if proc.returncode != 0:
        print("SSH failed:", proc.stderr, file=sys.stderr)
        return 1

    out = proc.stdout.strip()
    try:
        rows = json.loads(out)
    except json.JSONDecodeError as e:
        print(f"JSON decode failed: {e}", file=sys.stderr)
        print("first 500 chars:", out[:500], file=sys.stderr)
        return 1

    print(f"parsed {len(rows)} records", file=sys.stderr)
    legends = {}
    for row in rows:
        lab_id = int(row["lab_id"])
        small = row["svg_small"] or ""
        large = row["svg_large"] or ""
        with open(os.path.join(BASELINE, "svg_small", f"{lab_id}.svg"), "w") as f:
            f.write(small)
            if small and not small.endswith("\n"):
                f.write("\n")
        with open(os.path.join(BASELINE, "svg_large", f"{lab_id}.svg"), "w") as f:
            f.write(large)
            if large and not large.endswith("\n"):
                f.write("\n")
        try:
            legends[lab_id] = json.loads(row["legend"]) if row["legend"].strip() else []
        except json.JSONDecodeError:
            legends[lab_id] = []
    with open(os.path.join(BASELINE, "legend.json"), "w") as f:
        json.dump(legends, f, indent=1)
    print("done.", file=sys.stderr)
    return 0


if __name__ == "__main__":
    sys.exit(main())
