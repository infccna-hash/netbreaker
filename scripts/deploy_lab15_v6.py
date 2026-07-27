#!/usr/bin/env python3
"""Deploy Lab 15 content updates: VLAN/port-security faults + errdisable interval fix."""
import subprocess, base64, sys

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
        return False
    v_sql = f"SELECT length(content) FROM lab_phases WHERE lab_id = {lab_id} AND phase = '{phase}'"
    v_out, _, _ = run_sql(v_sql)
    print(f"  OK {phase}: {v_out.strip()} chars")
    return True

ATTACK = '''<div class="mission">
  <span class="tag">◈ MISSION</span>
  <h3>Diagnose misconfigurations and device-level failures</h3>
  <p>Networks fail at the device level in predictable ways: wrong cable type, disabled port, wrong VLAN, port-security violation. Identify four deliberate faults and fix them using CLI tools.</p>
</div>

<div class="stats">
  <span class="chip xp">✦ 400 XP</span>
  <span class="chip diff">◆ Beginner</span>
  <span class="chip time">◷ ~25 min</span>
  <span class="chip loot">⬡ Troubleshooting · VLAN · errdisable · cabling</span>
</div>

## The four faults

<div class="callout warning">
<b>Platform note:</b> Faults 2 and 3 were originally duplex/speed mismatches. Real IOU captures confirmed <code>speed 1000</code> is rejected outright (<code>% Invalid input</code>) and <code>duplex full</code> is accepted but never reported as anything but <code>Auto-duplex</code> — the simulator has no real PHY negotiation, so those faults are invisible in <code>show interfaces</code> regardless of whether they're injected. Replaced with faults that produce a real, observable difference on IOU.
</div>

| Fault | Symptom | Tool |
|---|---|---|
| Fault 1 — Shutdown port | A port is administratively down | `show interfaces status` |
| Fault 2 — Wrong VLAN | Port moved off the data VLAN | `show vlan brief` |
| Fault 3 — Port-security violation | Port err-disabled after an unauthorized MAC | `show interfaces status`, `show port-security interface Et0/X` |
| Fault 4 — Wrong cable | Straight-through instead of crossover | `show interfaces` |

Faults may land on any of SW1's active ports (Et0/0–Et0/3).

## Step 1 — Isolate the faults

From KALI, run a sweep:

<pre><code>for ip in 192.168.1.{10,20,30,1,101}; do echo -n "$ip: "; fping -c 3 $ip 2>&1 | tail -1; done</code></pre>

Note which IPs are unreachable.

## Step 2 — Diagnose each fault

On SW1:

<pre><code>show interfaces status
show interfaces Et0/0
show interfaces Et0/1
show interfaces Et0/2
show interfaces Et0/3
show vlan brief
show port-security interface Et0/2</code></pre>

Look for: <code>err-disabled</code>, <code>shutdown</code>, and — for Fault 2 — a port listed under a VLAN other than the one it should be on (<code>show vlan brief</code> groups ports by VLAN; a port hiding under <code>VLAN0099</code> instead of <code>default</code> won't pass traffic even though the interface itself shows <code>up/up</code>).

<div class="callout tip">
Port-security violations are a common real-world fault class: a port learns (or is statically configured with) an allowed MAC, a different device shows up, and the switch err-disables the port rather than silently forwarding for an unrecognized device. <code>show port-security interface</code> tells you the configured/violation MAC and the action taken.
</div>

## Step 3 — Fix each fault

<b>Fault 1</b> (shutdown port):

<pre><code>configure terminal
interface Et0/X
 no shutdown
end</code></pre>

<b>Fault 2</b> (wrong VLAN):

<pre><code>configure terminal
interface Et0/1
 switchport access vlan 1
end</code></pre>

<b>Fault 3</b> (port-security err-disable):

<pre><code>configure terminal
interface Et0/2
 shutdown
 no shutdown
end</code></pre>

If the port keeps re-violating, check <code>show port-security interface Et0/2</code> and correct the configured MAC, or clear the sticky entry with <code>no switchport port-security</code> / re-enable as needed.

<b>Fault 4</b> (cable): Swap the cable or use a crossover cable / MDIX.

## Step 4 — Verify

Re-run the ping sweep. All IPs should respond.

Check for errors:

<pre><code>show interfaces Et0/X | include errors</code></pre>

All error counters should be 0. Confirm PC3's port is back under the correct VLAN with <code>show vlan brief</code>, and that Et0/2 shows <code>connected</code>/<code>err-disabled: no</code> in <code>show interfaces status</code>.

<div class="achievement">
  <span class="medal">🔧</span>
  <span class="txt">
    <span class="lbl">Achievement Unlocked</span>
    <span class="name">Device Doctor — you diagnosed and fixed four hardware-layer faults</span>
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

# Deploy
print("Deploying...")
ok1 = update_phase(15, "attack", "Attack — Troubleshoot Device Failures", ATTACK)
ok2 = update_phase(15, "harden", "Harden — Harden Device Configs", HARDEN)

if ok1 and ok2:
    print("ALL DONE")
else:
    print("SOME FAILED")
    sys.exit(1)
