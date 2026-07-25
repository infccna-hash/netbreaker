#!/usr/bin/env python3
"""
NetBreaker GNS3 orphan-project sweep.

Deletes GNS3 projects on the compute host that no longer correspond to a live
NetBreaker session. This clears the backlog the reaper can't reach: projects
left behind when a teardown (DeleteProject) failed on a starved GNS3 and the
session moved on, or crash/restart debris.

WHY THIS IS NEEDED (and why the reaper alone can't do it): the reaper acts per
DB session row. A project whose session row is already 'ended'/'failed' — or has
no row at all — is invisible to it. This tool reconciles the *other* direction:
GNS3 reality → DB.

SAFETY (this is a destructive tool; read before running):
  1. DRY-RUN BY DEFAULT. Nothing is deleted unless you pass --delete.
  2. NAME ALLOW-LIST. Only projects matching NetBreaker's own naming scheme
     `nb-u<userID>-l<labID>-<unixtime>` are ever considered. Hand-made or
     unrelated GNS3 projects on the host are never touched.
  3. AGE GRACE PERIOD. The unix timestamp embedded in the project name gives a
     reliable creation age. Projects younger than --min-age-minutes (default 30)
     are skipped, so a just-created project whose session row hasn't committed
     its gns3_project_id yet is never mistaken for an orphan.
  4. FAIL-CLOSED ON DB ERROR. If the "which projects are live" query fails, the
     tool aborts rather than treating the live-set as empty (which would look
     like "everything is an orphan").

Usage:
    # dry run — show what WOULD be deleted, change nothing
    GNS3_SERVER_URL=http://falcon:3080 GNS3_USERNAME=admin GNS3_PASSWORD=... \
    PGHOST=... PGPORT=... PGUSER=... PGDATABASE=... \
        python3 gns3_orphan_sweep.py

    # actually delete
        python3 gns3_orphan_sweep.py --delete

Exit codes: 0 ok (incl. clean dry-run), 1 some deletions failed, 2 setup/abort.
"""
import argparse
import base64
import json
import os
import re
import subprocess
import sys
import time
import urllib.error
import urllib.request

NB_PROJECT_RE = re.compile(r'^nb-u\d+-l\d+-(\d+)$')  # capture the unix timestamp
LIVE_STATUSES = ("provisioning", "running", "idle_stopped")


def gns3_request(base, user, pw, method, path):
    url = base.rstrip("/") + path
    req = urllib.request.Request(url, method=method)
    if user:
        token = base64.b64encode(f"{user}:{pw}".encode()).decode()
        req.add_header("Authorization", "Basic " + token)
    req.add_header("Content-Type", "application/json")
    with urllib.request.urlopen(req, timeout=30) as resp:
        body = resp.read()
        return resp.status, (json.loads(body) if body else None)


def _psql(sql, extra_args=None):
    """Run a psql query via docker exec (preferred) or bare psql."""
    cmd = ["docker", "exec", "-i", "netbreaker-postgres", "psql", "-U", "netbreaker", "-d", "netbreaker"]
    if extra_args:
        cmd.extend(extra_args)
    cmd.extend(["-c", sql])
    return subprocess.run(cmd, capture_output=True, text=True)


def live_project_ids():
    """Project IDs of sessions still occupying a slot. Fail-closed on error."""
    sql = ("SELECT gns3_project_id FROM lab_sessions "
           "WHERE status IN %s AND gns3_project_id IS NOT NULL" %
           str(LIVE_STATUSES))
    r = _psql(sql, ["-A", "-t"])
    if r.returncode != 0:
        sys.stderr.write("ABORT: could not query live sessions from DB:\n" + r.stderr)
        sys.exit(2)
    return {line.strip() for line in r.stdout.splitlines() if line.strip()}


def session_status_by_project():
    """Map project_id -> status for ALL sessions (for reporting)."""
    r = _psql(
        "SELECT gns3_project_id, status FROM lab_sessions WHERE gns3_project_id IS NOT NULL",
        ["-A", "-t", "-F", "|"])
    out = {}
    for line in r.stdout.splitlines():
        if "|" in line:
            pid, st = line.split("|", 1)
            out[pid.strip()] = st.strip()
    return out


def main():
    ap = argparse.ArgumentParser(description="Sweep orphaned NetBreaker GNS3 projects.")
    ap.add_argument("--delete", action="store_true",
                    help="actually delete (default is dry-run)")
    ap.add_argument("--min-age-minutes", type=int, default=30,
                    help="skip projects created more recently than this (default 30)")
    ap.add_argument("--limit", type=int, default=0,
                    help="safety cap: refuse to delete more than N in one run (0 = no cap)")
    args = ap.parse_args()

    base = os.getenv("GNS3_SERVER_URL")
    if not base:
        sys.stderr.write("ABORT: GNS3_SERVER_URL not set\n")
        sys.exit(2)
    user = os.getenv("GNS3_USERNAME", "")
    pw = os.getenv("GNS3_PASSWORD", "")

    # 1. Everything GNS3 currently has.
    try:
        _, projects = gns3_request(base, user, pw, "GET", "/v2/projects")
    except (urllib.error.URLError, urllib.error.HTTPError, TimeoutError) as e:
        sys.stderr.write(f"ABORT: cannot reach GNS3 at {base}: {e}\n")
        sys.exit(2)
    projects = projects or []

    # 2. The live-set (fail-closed) and a status map for reporting.
    live = live_project_ids()
    status_map = session_status_by_project()

    now = time.time()
    cutoff = args.min_age_minutes * 60

    nb_total = 0
    orphans = []          # (project_id, name, age_min, why)
    skipped_young = 0
    for p in projects:
        name = p.get("name", "")
        pid = p.get("project_id", "")
        m = NB_PROJECT_RE.match(name)
        if not m:
            continue  # SAFETY: not a NetBreaker project — never touch
        nb_total += 1
        if pid in live:
            continue  # belongs to an active session — keep
        age = now - int(m.group(1))
        if age < cutoff:
            skipped_young += 1
            continue  # SAFETY: too new, might be mid-provision
        why = ("session=" + status_map[pid]) if pid in status_map else "no session row"
        orphans.append((pid, name, int(age // 60), why))

    # 3. Report.
    print(f"GNS3 projects total ............ {len(projects)}")
    print(f"  NetBreaker-owned (nb-u*) ..... {nb_total}")
    print(f"  live (kept) .................. {sum(1 for p in projects if p.get('project_id') in live)}")
    print(f"  skipped (younger than {args.min_age_minutes}m) .. {skipped_young}")
    print(f"  ORPHANS ...................... {len(orphans)}")
    if orphans:
        print("\n  " + f"{'project_id':38} {'age':>6}  name / reason")
        for pid, name, age_min, why in sorted(orphans, key=lambda x: -x[2]):
            print(f"  {pid:38} {age_min:>5}m  {name}  [{why}]")

    if not orphans:
        print("\nNothing to sweep.")
        return 0

    if not args.delete:
        print("\nDRY RUN — nothing deleted. Re-run with --delete to remove the above.")
        return 0

    if args.limit and len(orphans) > args.limit:
        sys.stderr.write(
            f"\nABORT: {len(orphans)} orphans exceeds --limit {args.limit}. "
            f"Raise --limit or investigate before mass-deleting.\n")
        sys.exit(2)

    # 4. Delete.
    print(f"\nDeleting {len(orphans)} orphaned project(s)...")
    failed = 0
    for pid, name, _, _ in orphans:
        try:
            gns3_request(base, user, pw, "DELETE", f"/v2/projects/{pid}")
            print(f"  deleted {name} ({pid})")
        except (urllib.error.URLError, urllib.error.HTTPError, TimeoutError) as e:
            print(f"  FAILED  {name} ({pid}): {e}")
            failed += 1
    print(f"\nDone. {len(orphans) - failed} deleted, {failed} failed.")
    return 1 if failed else 0


if __name__ == "__main__":
    sys.exit(main())
