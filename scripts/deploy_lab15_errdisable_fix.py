#!/usr/bin/env python3
"""Deploy Lab 15 errdisable interval fix: 300→180 (non-default, verifiable)."""
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

<div class="callout tip">
Never trust autonegotiation on critical links. Duplex mismatch is invisible to ping but devastates throughput.
</div>

## Step 3 — Errdisable auto-recovery

<pre><code>errdisable recovery cause all
errdisable recovery interval 180</code></pre>

<div class="callout info">
<b>Why 180 seconds, not 300?</b> 300 seconds is Cisco's factory default — setting it to 300 means IOS sees "no change" and won't store it in running-config. 180 seconds is a non-default value, which means it persists and can be verified with <code>show errdisable recovery</code>. A port that goes err-disabled auto-recovers after 3 minutes instead of 5.
</div>

## Step 4 — Baseline verification

<pre><code>show running-config | include description
show interfaces description
show errdisable recovery
show interfaces status</code></pre>

Save as baseline. All 5 interfaces should have descriptions matching the port map, and <code>show errdisable recovery</code> should confirm the 180-second timer.

<div class="achievement">
  <span class="medal">🛡️</span>
  <span class="txt">
    <span class="lbl">Achievement Unlocked</span>
    <span class="name">Foundation Guardian — devices documented, hardened, monitored</span>
  </span>
</div>'''

print("Updating Harden phase (300→180)...")
update_phase(15, "harden", "Harden — Harden Device Configs", HARDEN)

v_sql = "SELECT phase, length(content) FROM lab_phases WHERE lab_id=15 ORDER BY phase"
v_out, _, _ = run_sql(v_sql)
print(v_out)
print("DONE")
