#!/usr/bin/env python3
"""Deploy Lab 15 v5 attack + harden phases."""
import subprocess, base64

def run_sql(sql):
    cmd = ["docker", "exec", "netbreaker-postgres", "psql",
           "-U", "netbreaker", "-d", "netbreaker", "-c", sql]
    r = subprocess.run(cmd, capture_output=True, text=True, timeout=30)
    return r.stdout, r.stderr, r.returncode

def update_phase(lab_id, phase, title, html_content):
    b64 = base64.b64encode(html_content.encode()).decode()
    sql = f"""UPDATE lab_phases SET
  title = '{title}',
  content = convert_from(decode('{b64}', 'base64'), 'UTF8')
WHERE lab_id = {lab_id} AND phase = '{phase}'"""
    stdout, stderr, rc = run_sql(sql)
    if rc != 0:
        print(f"  FAIL {phase}: {stderr}")
        return
    v_sql = f"SELECT length(content) FROM lab_phases WHERE lab_id = {lab_id} AND phase = '{phase}'"
    v_out, _, _ = run_sql(v_sql)
    print(f"  OK {phase}: {v_out.strip()} chars")

ATTACK = '''<div class="mission">
  <span class="tag">◈ MISSION</span>
  <h3>Diagnose misconfigurations and device-level failures</h3>
  <p>Networks fail at the device level in predictable ways: wrong cable type, disabled port, duplex mismatch, speed mismatch. Identify four deliberate faults and fix them.</p>
</div>

<div class="stats">
  <span class="chip xp">✦ 400 XP</span>
  <span class="chip diff">◆ Beginner</span>
  <span class="chip time">◷ ~25 min</span>
  <span class="chip loot">⬡ troubleshooting · duplex · speed · shutdown</span>
</div>

### The four faults

| Fault | Symptom | Tool |
|---|---|---|
| Fault 1 — Shutdown port | Port administratively down | <code>show interfaces status</code> |
| Fault 2 — Duplex mismatch | One side full, other half | <code>show interfaces</code> |
| Fault 3 — Speed mismatch | 100 vs 10 Mbps | <code>show interfaces</code> |
| Fault 4 — Wrong cable | Straight-through vs crossover | <code>show interfaces</code> |

Faults may land on any of SW1's active ports (Et0/0–Et0/3).

## Step 1 — Isolate

From KALI:
<pre><code>for ip in 192.168.1.{10,20,30,1,101}; do echo -n "$ip: "; fping -c 3 $ip 2>&amp;1 | tail -1; done</code></pre>

## Step 2 — Diagnose

<pre><code>show interfaces status
show interfaces Et0/0 | show interfaces Et0/1
show interfaces Et0/2 | show interfaces Et0/3</code></pre>

Look for: <code>err-disabled</code>, <code>shutdown</code>, <code>half-duplex</code>, 10M.

<div class="callout warn">
<b>Duplex mismatch</b> — most common real-world fault. One side full-duplex, other half. Frame errors on full side, late collisions on half side.
</div>

## Step 3 — Fix

<b>Shutdown:</b> <code>interface Et0/X → no shutdown</code><br/>
<b>Duplex:</b> <code>interface Et0/X → duplex full</code><br/>
<b>Speed:</b> <code>interface Et0/X → speed 100</code><br/>
<b>Cable:</b> Swap or use MDIX.

## Step 4 — Verify

Re-run ping sweep. All IPs respond. <code>show interfaces Et0/X | include errors</code> — counters = 0.

<div class="achievement">
  <span class="medal">🔧</span>
  <span class="txt">
    <span class="lbl">Achievement Unlocked</span>
    <span class="name">Device Doctor — four hardware-layer faults diagnosed and fixed</span>
  </span>
</div>'''

HARDEN = '''<div class="mission">
  <span class="tag">◈ MISSION</span>
  <h3>Prevent device-layer failures before they happen</h3>
  <p>Harden the network: interface descriptions, explicit duplex/speed, errdisable auto-recovery, baseline documentation.</p>
</div>

<div class="stats">
  <span class="chip xp">✦ 200 XP</span>
  <span class="chip diff">◆ Beginner</span>
  <span class="chip time">◷ ~15 min</span>
  <span class="chip loot">⬡ interface docs · errdisable recovery · autonegotiation</span>
</div>

<ul class="objectives">
  <li>Document every interface with descriptions — all 5 ports, including the spare</li>
  <li>Set duplex/speed explicitly on trunk links</li>
  <li>Enable errdisable auto-recovery</li>
  <li>Create a network diagram baseline</li>
</ul>

## Step 1 — Document interfaces

<pre><code>configure terminal
interface Et0/0
 description LINK-TO-HUB-PC1-PC2-KALI2
interface Et0/1
 description LINK-TO-PC3
interface Et0/2
 description LINK-TO-KALI
interface Et0/3
 description UPLINK-TO-R1
interface Et0/4
 description SPARE-UNUSED
end</code></pre>

## Step 2 — Explicit duplex/speed on trunks

<pre><code>interface Et0/3
 speed 1000
 duplex full</code></pre>

## Step 3 — Errdisable auto-recovery

<pre><code>errdisable recovery cause all
errdisable recovery interval 300</code></pre>

Ports auto-recover after 5 minutes.

## Step 4 — Baseline verification

<pre><code>show running-config | include description
show interfaces description
show errdisable recovery
show interfaces status</code></pre>

Save as baseline. All 5 interfaces should have descriptions matching the port map.

<div class="achievement">
  <span class="medal">🛡️</span>
  <span class="txt">
    <span class="lbl">Achievement Unlocked</span>
    <span class="name">Foundation Guardian — devices documented, hardened, monitored</span>
  </span>
</div>'''

print("Updating attack + harden phases...")
update_phase(15, "attack", "Attack — Troubleshoot Device Failures", ATTACK)
update_phase(15, "harden", "Harden — Harden Device Configs", HARDEN)

v_sql = "SELECT phase, length(content) FROM lab_phases WHERE lab_id=15 ORDER BY phase"
v_out, _, _ = run_sql(v_sql)
print(v_out)
print("DONE")
