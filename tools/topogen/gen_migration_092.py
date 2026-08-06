#!/usr/bin/env python3
"""Generate migration 092: replace Lab 15 Fault 3 port-security trap with
BPDU-guard trap (option a — verified end-to-end via probes).

Text changes (attack phase):
1. Step 0 Et0/2 config block: port-security → portfast + bpduguard
2. Explanation paragraph: port-security/MAC trap → bpduguard trap
3. KALI trigger: ping 192.168.1.1 → yersinia stp -attack 1 -interface eth0
4. Result paragraph: 'switch really did detect and react' → bpduguard framing
5. Fault 3 table row: Port-security → BPDU guard

Go changes (same commit, no divergence window):
- lab15_scenario.go: command list
- lab15_scenario_test.go: expected sequence + failAtIdx

Migration approach: verify_replace on SHORT unique literals only (the
long-literal byte-exact problem documented in 091). Each old_str must be
unique and present exactly once in the live content.
"""
import re
import subprocess
import sys

SSH = ["ssh", "-o", "ConnectTimeout=15", "-o", "BatchMode=yes", "root@100.66.106.42"]
Q = ("docker exec netbreaker-postgres psql -U netbreaker -d netbreaker -t -A -c "
     '"SELECT content FROM lab_phases WHERE lab_id=15 AND phase=\'attack\';"')
proc = subprocess.run(SSH + [Q], capture_output=True, text=True, timeout=90)
html = proc.stdout
if proc.returncode != 0:
    print("SSH failed:", proc.stderr, file=sys.stderr)
    sys.exit(1)

# ── text replacements (short unique literals) ──────────────
REPL = [
    # 1. config block Et0/2
    (
        "interface Et0/2\n switchport port-security\n switchport port-security maximum 1\n"
        " switchport port-security violation shutdown\n switchport port-security mac-address 0000.0000.0001",
        "interface Et0/2\n spanning-tree portfast\n spanning-tree bpduguard enable",
    ),
    # 2. explanation paragraph (config-side)
    (
        "That port-security command on Et0/2 doesn't fake an err-disabled state — it sets a real trap. "
        "You've told the switch the only MAC allowed on that port is `0000.0000.0001`, which isn't KALI's "
        "real MAC. The next real frame KALI sends trips a genuine security violation. Go make that happen:",
        "That bpduguard command on Et0/2 doesn't fake an err-disabled state — it sets a real trap. "
        "The switch will err-disable any port in portfast mode the moment it receives an STP BPDU "
        "while bpduguard is enabled. Yersinia injects exactly that. Go make that happen:",
    ),
    # 3. KALI trigger
    ("ping 192.168.1.1 -c 1", "yersinia stp -attack 1 -interface eth0"),
    # 4. result paragraph
    (
        "Et0/2 is now actually err-disabled — not simulated, not scripted, the switch really did detect "
        "and react to a real (if artificially set up) violation.",
        "Et0/2 is now actually err-disabled — not simulated, not scripted, the switch really did detect "
        "and react to a real (if artificially set up) BPDU-guard violation.",
    ),
    # 5. Fault 3 table row
    (
        "| **Fault 3** — Port-security violation (Et0/2, KALI) | Port is err-disabled |",
        "| **Fault 3** — BPDU guard violation (Et0/2, KALI) | Port is err-disabled (STP BPDU on a portfast+bpduguard port) |",
    ),
    # 6. mission intro mention
    (
        "a port left shut down, a host dropped in the wrong VLAN, a port-security violation nobody noticed.",
        "a port left shut down, a host dropped in the wrong VLAN, a BPDU-guard violation nobody noticed.",
    ),
    # 7. tag chips
    (
        "⬡ Troubleshooting · VLANs · port-security · shutdown",
        "⬡ Troubleshooting · VLANs · BPDU guard · shutdown",
    ),
    # 8. Step 3 fault 3 diagnosis header + commands (match live HTML with newlines)
    (
        "Fault 3 (Et0/2 err-disabled from port-security):\n\nFirst, look at *why* before you clear it — don't just bounce the port blind:\n```\nshow port-security interface Et0/2\nshow port-security\n```\nThis shows you the violation count, the secure MAC(s) already learned, and the configured action (Shutdown).",
        "Fault 3 (Et0/2 err-disabled from BPDU guard):\n\nFirst, look at *why* before you clear it — don't just bounce the port blind:\n```\nshow logging | include BPDUGUARD\nshow errdisable recovery\n```\nThe syslog tells you exactly what tripped it (SPANTREE-2-BLOCK_BPDUGUARD: received BPDU with guard enabled), and `show errdisable recovery` shows the port and the recovery timer.",
    ),
    # 9. callout tip (match live HTML)
    (
        "Port-security violations are one of the most common real triggers for err-disable in production — a port learns more MACs than its configured maximum (or the \"wrong\" MAC on a sticky port) and shuts itself down rather than fail open.",
        "BPDU-guard violations are a real trigger for err-disable: a portfast port that should never see STP traffic receives a BPDU — from a rogue switch, a misconfigured uplink, or an attack tool like yersinia — and shuts itself down rather than risk a loop.",
    ),
]

def dollar_quote(s):
    if "$md$" in s:
        print("content contains $md$ — aborting", file=sys.stderr)
        sys.exit(1)
    return "$md$" + s + "$md$"


# sanity-check uniqueness + count on the LIVE content
checked = html
for old, new in REPL:
    n = html.count(old)
    if n != 1:
        print(f"old_str not unique/absent (count={n}): {old[:60]!r}", file=sys.stderr)
        sys.exit(1)
    checked = checked.replace(old, new)

# post-checks: no port-security remnants in attack phase
for remnant in ["port-security", "port security", "MAC allowed"]:
    if remnant in checked.lower():
        print(f"remnant '{remnant}' still present after replacements", file=sys.stderr)
        sys.exit(1)
if "bpduguard" not in checked:
    print("bpduguard missing after replacements", file=sys.stderr)
    sys.exit(1)

up_lines = [
    "-- Migration 092: Lab 15 Fault 3 — port-security trap → BPDU-guard trap",
    "--",
    "-- Why: IOU 15.1a accepts port-security config but never fires the",
    "-- violation (Security Violation Count stays 0; verified twice in full",
    "-- walkthroughs). 12.2 upk9 rejects the command outright. BPDU guard",
    "-- DOES fire on 15.1a (verified probe: %SPANTREE-2-BLOCK_BPDUGUARD +",
    "-- %PM-4-ERR_DISABLE), and KALI can inject the trigger via yersinia",
    "-- (verified probe: yersinia stp -attack 1 → port err-disabled).",
    "--",
    "-- Text + lab15_scenario.go + lab15_scenario_test.go ship together in",
    "-- the SAME commit (no divergence window).",
    "",
]
down_lines = [
    "-- Migration 092 DOWN: restore port-security Fault 3 (reverse of UP).",
    "",
]

for old, new in REPL:
    up_lines.append(
        f"UPDATE lab_phases SET content = verify_replace(content,\n"
        f"  {dollar_quote(old)},\n"
        f"  {dollar_quote(new)})\n"
        f"WHERE lab_id = 15 AND phase = 'attack';\n"
    )
    down_lines.append(
        f"UPDATE lab_phases SET content = verify_replace(content,\n"
        f"  {dollar_quote(new)},\n"
        f"  {dollar_quote(old)})\n"
        f"WHERE lab_id = 15 AND phase = 'attack';\n"
    )

with open("migrations/092_lab15_fault3_bpduguard.up.sql", "w") as f:
    f.write("\n".join(up_lines))
with open("migrations/092_lab15_fault3_bpduguard.down.sql", "w") as f:
    f.write("\n".join(down_lines))

print(f"wrote 092 up ({sum(len(l) for l in up_lines)} chars, {len(REPL)} replacements)")
print(f"wrote 092 down ({sum(len(l) for l in down_lines)} chars)")
print("post-replacement checks: port-security remnants absent, bpduguard present")
