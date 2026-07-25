#!/usr/bin/env python3
"""
NetBreaker interface-name platform guard.

Run in CI AFTER migrations are applied. Exit code 1 on any violation.

Enforces three invariants that come directly from the hardware the labs
actually provision on (see internal/labsession/*_topology.go):

  1. ZERO-GIGABIT: every router node in the catalog is a Dynamips c3725,
     which has no GigabitEthernet interfaces, and every switch is an IOU L2
     image (Et0/0-3 only). Therefore *no* valid interface is ever "Gi"/"gi".
     Any Gi token in student-facing lab_phases.content is wrong.
     (The single legitimate exception is an explicit placeholder like
     "gi0/X" used as a fill-in-the-blank; add real ones to ALLOW below.)

  2. NO-FA-ON-IOU: an IOU switch has only Et0/0-3. A "Fa0/N" or "Gi0/N"
     interface command typed into an IOU node returns %Invalid input.
     Flagged per-lab using the node map parsed from the topology files.

  3. NO-L3-ON-SWITCHPORT: an "ip address" / "ipv6 address" line must never
     sit under an "interface Et0/x" (that's an L2 switchport). This catches
     the mixed-device find/replace corruption class.

Usage:
    PGHOST=... PGPORT=... PGUSER=... PGDATABASE=... \
        python3 check_interface_names.py [--topology-dir internal/labsession]

Why this exists: the interface-name bug shipped past three "full-catalog
clean" sign-offs because it was verified by hand each time. Interface tokens
are ambiguous across device types within a single lab, so a human diff is
not a reliable gate. This makes the gate mechanical.
"""
import os, re, sys, glob, subprocess, argparse

# Labs deliberately deferred for GNS3-in-the-loop review (structural issues,
# port numbers exceeding IOU's 4 ports, phantom nodes). Remove as they're fixed.
DEFERRED = {13, 15, 17, 19, 20}
# Known-good literal placeholders that are not real interface names.
ALLOW = {"gi0/X"}

GI = re.compile(r'\b[Gg]i\d/\S*')
IFACE = re.compile(r'interface\s+(Gi|gi|Fa|fa|Et|et)\d/', re.I)
L3 = re.compile(r'^\s*(ip address|ipv6 address)\b', re.I)


def psql(sql):
    # -A unaligned, -t tuples-only, -F sets a distinctive field separator that
    # cannot appear in base64 content.
    cmd = ["psql", "-A", "-t", "-F", "|~|", "-c", sql]
    env = dict(os.environ)
    r = subprocess.run(cmd, capture_output=True, text=True, env=env)
    if r.returncode != 0:
        sys.stderr.write(r.stderr)
        sys.exit(2)
    return r.stdout


def parse_node_types(topo_dir):
    """lab_id -> {node_name: node_type} from labNN_topology.go."""
    out = {}
    for fn in glob.glob(os.path.join(topo_dir, "lab*_topology.go")):
        m = re.search(r'lab(\d+)_topology', fn)
        if not m:
            continue
        lid = int(m.group(1))
        txt = open(fn).read()
        nodes = {}
        for blk in re.finditer(r'\{(?P<b>[^{}]*?(?:\{[^{}]*\}[^{}]*?)*)\}', txt):
            b = blk.group('b')
            nm = re.search(r'Name:\s*"([^"]+)"', b)
            nt = re.search(r'NodeType:\s*"([^"]+)"', b)
            if nm and nt:
                nodes[nm.group(1)] = nt.group(1)
        out[lid] = nodes
    return out


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--topology-dir", default="internal/labsession")
    args = ap.parse_args()

    node_types = parse_node_types(args.topology_dir)
    violations = []

    # base64 keeps multi-line content on one row; replace() strips its newlines.
    rows = psql("SELECT lab_id, phase, "
                "replace(encode(convert_to(content,'UTF8'),'base64'), E'\\n', '') "
                "FROM lab_phases;")
    import base64
    for line in rows.splitlines():
        if "|~|" not in line:
            continue
        lid_s, phase, b64 = line.split('|~|', 2)
        lid = int(lid_s)
        content = base64.b64decode(b64).decode('utf-8', 'replace')
        lines = content.splitlines()

        # INV 1: zero Gigabit tokens (skip deferred labs + allowed placeholders)
        if lid not in DEFERRED:
            for ln in lines:
                for m in GI.finditer(ln):
                    if m.group(0) in ALLOW:
                        continue
                    violations.append(
                        f"[INV1 zero-Gi] lab {lid}/{phase}: '{m.group(0)}' "
                        f"— no c3725/IOU node has a Gigabit interface")

        # INV 3: no L3 address on an Et0/ switchport
        for i, ln in enumerate(lines):
            if re.match(r'\s*interface\s+Et0/', ln, re.I):
                for j in range(i + 1, min(i + 3, len(lines))):
                    if L3.match(lines[j]):
                        violations.append(
                            f"[INV3 L3-on-switchport] lab {lid}/{phase}: "
                            f"'{lines[j].strip()}' under '{ln.strip()}' "
                            f"(IOU switchports are L2-only)")

        # INV 2: Fa on an IOU-only lab (no dynamips node) is invalid
        types = set(node_types.get(lid, {}).values())
        if types and 'dynamips' not in types and lid not in DEFERRED:
            for ln in lines:
                if re.search(r'\b[Ff]a\d/', ln):
                    violations.append(
                        f"[INV2 Fa-on-IOU] lab {lid}/{phase}: '{ln.strip()[:70]}' "
                        f"— lab has no router; FastEthernet is invalid on IOU")

    if violations:
        print(f"FAIL: {len(violations)} interface-name violation(s):\n")
        for v in violations:
            print("  " + v)
        print(f"\nDeferred labs (not checked): {sorted(DEFERRED)}")
        sys.exit(1)
    print("PASS: interface names consistent with provisioned platforms "
          f"(deferred: {sorted(DEFERRED)})")
    sys.exit(0)


if __name__ == "__main__":
    main()
