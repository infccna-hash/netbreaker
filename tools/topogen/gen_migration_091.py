#!/usr/bin/env python3
"""Generate migration 091: remove the duplicated Step 0 block in Lab 15 attack.

The attack phase content contains the full Step 0 section (callout warn +
Workaround note + Step 0 config + KALI ping + "diagnose it cold") TWICE,
back to back, before '## The four faults'. Students see the setup twice.

Fix: delete the second copy. old_str is the unique junction from the end of
the FIRST copy ('diagnose it cold.') through the entire SECOND copy (which
starts with a second <div class="callout warn">) up to (but not including)
'## The four faults'. new_str keeps just 'diagnose it cold.\n\n' so the
first copy's ending is preserved and the four-faults header follows.
"""
import re
import sys

# Pull the live attack content from the DB via ssh
import subprocess

SSH = ["ssh", "-o", "ConnectTimeout=15", "-o", "BatchMode=yes", "root@100.66.106.42"]
Q = ("docker exec netbreaker-postgres psql -U netbreaker -d netbreaker -t -A -c "
     '"SELECT content FROM lab_phases WHERE lab_id=15 AND phase=\'attack\';"')
proc = subprocess.run(SSH + [Q], capture_output=True, text=True, timeout=90)
html = proc.stdout
if proc.returncode != 0:
    print("SSH failed:", proc.stderr, file=sys.stderr)
    sys.exit(1)

# boundaries
c2 = html.find('<div class="callout warn">', html.find('<div class="callout warn">') + 10)
four = html.find('## The four faults')
if c2 == -1 or four == -1:
    print("markers not found — content may have changed", file=sys.stderr)
    sys.exit(1)

start = html.rfind('diagnose it cold', 0, c2)
old_str = html[start:four]
new_str = 'diagnose it cold.\n\n'

# sanity: unique
if html.count(old_str) != 1:
    print(f"old_str not unique ({html.count(old_str)} occurrences) — aborting", file=sys.stderr)
    sys.exit(1)
# sanity: replacement preserves one copy
after = html.replace(old_str, new_str)
if after.count('## Step 0') != 1 or after.count('Workaround note') != 1:
    print("replacement would not leave exactly one copy — aborting", file=sys.stderr)
    sys.exit(1)

def dollar_quote(s):
    if "$md$" in s:
        # content has no $md$, but be safe
        print("content contains $md$ — aborting", file=sys.stderr)
        sys.exit(1)
    return "$md$" + s + "$md$"

up = f"""-- Migration 091: remove duplicated Step 0 block in Lab 15 attack phase
-- The attack content had the full Step 0 section (callout + Workaround note
-- + config + KALI ping) twice, back-to-back, before '## The four faults'.
-- Deleting the second copy. verify_replace fails loudly if the live content
-- drifted from the byte-exact old_str.

UPDATE lab_phases SET content = verify_replace(content,
  {dollar_quote(old_str)},
  {dollar_quote(new_str)})
WHERE lab_id = 15 AND phase = 'attack';
"""

down = f"""-- Migration 091 DOWN: restore the duplicated Step 0 (reverse of UP).
-- NOTE: the UP migration deleted the SECOND copy; DOWN re-inserts it by
-- replacing 'diagnose it cold.\\n\\n' (the first copy's tail) with the full
-- duplicated region again. Round-trip safe.

UPDATE lab_phases SET content = verify_replace(content,
  {dollar_quote(new_str)},
  {dollar_quote(old_str)})
WHERE lab_id = 15 AND phase = 'attack';
"""

with open("migrations/091_lab15_dedup_step0.up.sql", "w") as f:
    f.write(up)
with open("migrations/091_lab15_dedup_step0.down.sql", "w") as f:
    f.write(down)

print(f"wrote 091 up ({len(up)} bytes), down ({len(down)} bytes)")
print(f"old_str: {len(old_str)} chars, unique: True")
print(f"after fix: Step0 x{after.count('## Step 0')}, Workaround x{after.count('Workaround note')}, callout x{after.count('callout warn')}")
