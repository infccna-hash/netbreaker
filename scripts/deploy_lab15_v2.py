#!/usr/bin/env python3
"""Deploy Lab 15 v2 — user's canonical version with inline SVG."""
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
        return False
    v_sql = f"SELECT length(content) FROM lab_phases WHERE lab_id = {lab_id} AND phase = '{phase}'"
    v_out, _, _ = run_sql(v_sql)
    print(f"  OK {phase}: {v_out.strip()} chars")
    return True

# ============================================================
# USER'S SVG — adapted for lab_topologies (small + large)
# Same color scheme and layout as the inline SVG
# ============================================================

SVG_SMALL = '''<svg viewBox="0 0 380 220" xmlns="http://www.w3.org/2000/svg">
  <line x1="190" y1="58" x2="65" y2="108" stroke="#888780" stroke-width="1"/>
  <line x1="190" y1="58" x2="150" y2="108" stroke="#888780" stroke-width="1"/>
  <line x1="190" y1="58" x2="235" y2="108" stroke="#888780" stroke-width="1"/>
  <line x1="190" y1="58" x2="320" y2="108" stroke="#888780" stroke-width="1"/>
  <line x1="65" y1="140" x2="50" y2="170" stroke="#888780" stroke-width="1"/>
  <line x1="65" y1="140" x2="100" y2="170" stroke="#888780" stroke-width="1"/>
  <line x1="320" y1="140" x2="320" y2="170" stroke="#888780" stroke-width="1"/>

  <rect x="150" y="24" width="80" height="34" rx="6" fill="#F1EFE8" stroke="#5F5E5A" stroke-width="1"/>
  <text x="190" y="38" text-anchor="middle" font-family="sans-serif" font-size="10" fill="#2C2C2A">SW1</text>
  <text x="190" y="50" text-anchor="middle" font-family="sans-serif" font-size="8" fill="#444441">L2 switch</text>

  <rect x="24" y="108" width="82" height="34" rx="6" fill="#F1EFE8" stroke="#5F5E5A" stroke-width="1"/>
  <text x="65" y="122" text-anchor="middle" font-family="sans-serif" font-size="9" fill="#2C2C2A">H1</text>
  <text x="65" y="134" text-anchor="middle" font-family="sans-serif" font-size="7" fill="#444441">Shared domain</text>

  <rect x="110" y="108" width="80" height="34" rx="6" fill="#E1F5EE" stroke="#0F6E56" stroke-width="1"/>
  <text x="150" y="122" text-anchor="middle" font-family="sans-serif" font-size="9" fill="#04342C">PC3</text>
  <text x="150" y="134" text-anchor="middle" font-family="sans-serif" font-size="7" fill="#085041">End host</text>

  <rect x="196" y="108" width="78" height="34" rx="6" fill="#FCEBEB" stroke="#A32D2D" stroke-width="1"/>
  <text x="235" y="122" text-anchor="middle" font-family="sans-serif" font-size="9" fill="#501313">KALI</text>
  <text x="235" y="134" text-anchor="middle" font-family="sans-serif" font-size="7" fill="#791F1F">Observer</text>

  <rect x="280" y="108" width="80" height="34" rx="6" fill="#E6F1FB" stroke="#185FA5" stroke-width="1"/>
  <text x="320" y="122" text-anchor="middle" font-family="sans-serif" font-size="9" fill="#042C53">R1</text>
  <text x="320" y="134" text-anchor="middle" font-family="sans-serif" font-size="7" fill="#0C447C">Router</text>

  <rect x="24" y="170" width="52" height="34" rx="6" fill="#E1F5EE" stroke="#0F6E56" stroke-width="1"/>
  <text x="50" y="184" text-anchor="middle" font-family="sans-serif" font-size="9" fill="#04342C">PC1</text>
  <text x="50" y="196" text-anchor="middle" font-family="sans-serif" font-size="7" fill="#085041">Host</text>

  <rect x="80" y="170" width="52" height="34" rx="6" fill="#E1F5EE" stroke="#0F6E56" stroke-width="1"/>
  <text x="106" y="184" text-anchor="middle" font-family="sans-serif" font-size="9" fill="#04342C">PC2</text>
  <text x="106" y="196" text-anchor="middle" font-family="sans-serif" font-size="7" fill="#085041">Host</text>

  <rect x="280" y="170" width="80" height="34" rx="6" fill="#E6F1FB" stroke="#185FA5" stroke-width="1"/>
  <text x="320" y="184" text-anchor="middle" font-family="sans-serif" font-size="9" fill="#042C53">FW1</text>
  <text x="320" y="196" text-anchor="middle" font-family="sans-serif" font-size="7" fill="#0C447C">Firewall</text>
</svg>'''

SVG_LARGE = '''<svg viewBox="0 0 700 380" xmlns="http://www.w3.org/2000/svg">
  <line x1="350" y1="106" x2="120" y2="196" stroke="#888780" stroke-width="1.5"/>
  <line x1="350" y1="106" x2="275" y2="196" stroke="#888780" stroke-width="1.5"/>
  <line x1="350" y1="106" x2="435" y2="196" stroke="#888780" stroke-width="1.5"/>
  <line x1="350" y1="106" x2="585" y2="196" stroke="#888780" stroke-width="1.5"/>
  <line x1="120" y1="256" x2="85" y2="308" stroke="#888780" stroke-width="1.5"/>
  <line x1="120" y1="256" x2="185" y2="308" stroke="#888780" stroke-width="1.5"/>
  <line x1="585" y1="256" x2="585" y2="308" stroke="#888780" stroke-width="1.5"/>

  <rect x="265" y="46" width="170" height="60" rx="8" fill="#F1EFE8" stroke="#5F5E5A" stroke-width="1"/>
  <text x="350" y="68" text-anchor="middle" font-family="sans-serif" font-size="15" fill="#2C2C2A">SW1</text>
  <text x="350" y="88" text-anchor="middle" font-family="sans-serif" font-size="12" fill="#444441">L2 switch</text>

  <rect x="45" y="196" width="150" height="60" rx="8" fill="#F1EFE8" stroke="#5F5E5A" stroke-width="1"/>
  <text x="120" y="218" text-anchor="middle" font-family="sans-serif" font-size="15" fill="#2C2C2A">H1</text>
  <text x="120" y="238" text-anchor="middle" font-family="sans-serif" font-size="12" fill="#444441">Shared collision domain</text>

  <rect x="200" y="196" width="150" height="60" rx="8" fill="#E1F5EE" stroke="#0F6E56" stroke-width="1"/>
  <text x="275" y="218" text-anchor="middle" font-family="sans-serif" font-size="15" fill="#04342C">PC3</text>
  <text x="275" y="238" text-anchor="middle" font-family="sans-serif" font-size="12" fill="#085041">End host</text>

  <rect x="360" y="196" width="150" height="60" rx="8" fill="#FCEBEB" stroke="#A32D2D" stroke-width="1"/>
  <text x="435" y="218" text-anchor="middle" font-family="sans-serif" font-size="15" fill="#501313">KALI</text>
  <text x="435" y="238" text-anchor="middle" font-family="sans-serif" font-size="12" fill="#791F1F">Observer / attacker</text>

  <rect x="520" y="196" width="150" height="60" rx="8" fill="#E6F1FB" stroke="#185FA5" stroke-width="1"/>
  <text x="585" y="218" text-anchor="middle" font-family="sans-serif" font-size="15" fill="#042C53">R1</text>
  <text x="585" y="238" text-anchor="middle" font-family="sans-serif" font-size="12" fill="#0C447C">Router</text>

  <rect x="45" y="310" width="80" height="56" rx="8" fill="#E1F5EE" stroke="#0F6E56" stroke-width="1"/>
  <text x="85" y="332" text-anchor="middle" font-family="sans-serif" font-size="15" fill="#04342C">PC1</text>
  <text x="85" y="350" text-anchor="middle" font-family="sans-serif" font-size="12" fill="#085041">Host</text>

  <rect x="145" y="310" width="80" height="56" rx="8" fill="#E1F5EE" stroke="#0F6E56" stroke-width="1"/>
  <text x="185" y="332" text-anchor="middle" font-family="sans-serif" font-size="15" fill="#04342C">PC2</text>
  <text x="185" y="350" text-anchor="middle" font-family="sans-serif" font-size="12" fill="#085041">Host</text>

  <rect x="520" y="310" width="150" height="56" rx="8" fill="#E6F1FB" stroke="#185FA5" stroke-width="1"/>
  <text x="585" y="332" text-anchor="middle" font-family="sans-serif" font-size="15" fill="#042C53">FW1</text>
  <text x="585" y="350" text-anchor="middle" font-family="sans-serif" font-size="12" fill="#0C447C">Firewall</text>
</svg>'''

# ============================================================
# USER'S EXACT LAB CONTENT — with inline SVG in build phase
# ============================================================

BUILD_HTML = '''<div class="mission">
  <span class="tag">◈ MISSION</span>
  <h3>Identify every device on the wire and what breaks when you get its role wrong</h3>
  <p>A network is built from hubs, switches, routers, and firewalls. Misidentify any one and the topology breaks in invisible ways — frames drop, broadcasts leak, and security boundaries dissolve.</p>
</div>

<div class="stats">
  <span class="chip xp">✦ 300 XP</span>
  <span class="chip diff">◆ Beginner</span>
  <span class="chip time">◷ ~30 min</span>
  <span class="chip loot">⬡ hub · switch · router · collision domain</span>
</div>

## Topology

<svg width="100%" viewBox="0 0 680 350" role="img" style="max-width:680px;background:#0d1117;border-radius:8px;padding:12px">
<title>Lab 15 network topology</title>
<desc>SW1 at the top connects down to H1, PC3, KALI and R1. H1 connects to PC1 and PC2 below it. R1 connects to FW1 below it.</desc>

<line x1="330" y1="96" x2="105" y2="168" stroke="#888780" stroke-width="1"/>
<line x1="330" y1="96" x2="255" y2="168" stroke="#888780" stroke-width="1"/>
<line x1="330" y1="96" x2="405" y2="168" stroke="#888780" stroke-width="1"/>
<line x1="330" y1="96" x2="555" y2="168" stroke="#888780" stroke-width="1"/>
<line x1="105" y1="226" x2="75" y2="268" stroke="#888780" stroke-width="1"/>
<line x1="105" y1="226" x2="165" y2="268" stroke="#888780" stroke-width="1"/>
<line x1="555" y1="226" x2="555" y2="268" stroke="#888780" stroke-width="1"/>

<g>
  <rect x="250" y="40" width="160" height="56" rx="8" fill="#F1EFE8" stroke="#5F5E5A" stroke-width="1"/>
  <text x="330" y="60" text-anchor="middle" font-family="sans-serif" font-size="14" font-weight="500" fill="#2C2C2A">SW1</text>
  <text x="330" y="78" text-anchor="middle" font-family="sans-serif" font-size="12" fill="#444441">L2 switch</text>
</g>

<g>
  <rect x="40" y="170" width="130" height="56" rx="8" fill="#F1EFE8" stroke="#5F5E5A" stroke-width="1"/>
  <text x="105" y="190" text-anchor="middle" font-family="sans-serif" font-size="14" font-weight="500" fill="#2C2C2A">H1</text>
  <text x="105" y="208" text-anchor="middle" font-family="sans-serif" font-size="12" fill="#444441">Shared domain</text>
</g>

<g>
  <rect x="190" y="170" width="130" height="56" rx="8" fill="#E1F5EE" stroke="#0F6E56" stroke-width="1"/>
  <text x="255" y="190" text-anchor="middle" font-family="sans-serif" font-size="14" font-weight="500" fill="#04342C">PC3</text>
  <text x="255" y="208" text-anchor="middle" font-family="sans-serif" font-size="12" fill="#085041">End host</text>
</g>

<g>
  <rect x="340" y="170" width="130" height="56" rx="8" fill="#FCEBEB" stroke="#A32D2D" stroke-width="1"/>
  <text x="405" y="190" text-anchor="middle" font-family="sans-serif" font-size="14" font-weight="500" fill="#501313">KALI</text>
  <text x="405" y="208" text-anchor="middle" font-family="sans-serif" font-size="12" fill="#791F1F">Observer</text>
</g>

<g>
  <rect x="490" y="170" width="130" height="56" rx="8" fill="#E6F1FB" stroke="#185FA5" stroke-width="1"/>
  <text x="555" y="190" text-anchor="middle" font-family="sans-serif" font-size="14" font-weight="500" fill="#042C53">R1</text>
  <text x="555" y="208" text-anchor="middle" font-family="sans-serif" font-size="12" fill="#0C447C">Router</text>
</g>

<g>
  <rect x="40" y="270" width="70" height="56" rx="8" fill="#E1F5EE" stroke="#0F6E56" stroke-width="1"/>
  <text x="75" y="290" text-anchor="middle" font-family="sans-serif" font-size="14" font-weight="500" fill="#04342C">PC1</text>
  <text x="75" y="308" text-anchor="middle" font-family="sans-serif" font-size="12" fill="#085041">Host</text>
</g>

<g>
  <rect x="130" y="270" width="70" height="56" rx="8" fill="#E1F5EE" stroke="#0F6E56" stroke-width="1"/>
  <text x="165" y="290" text-anchor="middle" font-family="sans-serif" font-size="14" font-weight="500" fill="#04342C">PC2</text>
  <text x="165" y="308" text-anchor="middle" font-family="sans-serif" font-size="12" fill="#085041">Host</text>
</g>

<g>
  <rect x="490" y="270" width="130" height="56" rx="8" fill="#E6F1FB" stroke="#185FA5" stroke-width="1"/>
  <text x="555" y="290" text-anchor="middle" font-family="sans-serif" font-size="14" font-weight="500" fill="#042C53">FW1</text>
  <text x="555" y="308" text-anchor="middle" font-family="sans-serif" font-size="12" fill="#0C447C">Firewall</text>
</g>
</svg>

<p><b>Color key:</b> gray = L2 infrastructure (SW1, H1) · teal = end hosts (PC1, PC2, PC3) · blue = router/firewall boundary (R1, FW1) · red = observer/attacker (KALI)</p>

<p><b>Cabling:</b></p>
<ul>
  <li>PC1 + PC2 → H1 (hub) → SW1</li>
  <li>PC3 → SW1</li>
  <li>KALI → SW1</li>
  <li>SW1 → R1</li>
  <li>R1 → FW1</li>
</ul>

<h4>SW1 port map (initial build)</h4>
<table>
<tr><th>Port</th><th>Connects to</th><th>Notes</th></tr>
<tr><td>Et0/0</td><td>H1 (hub uplink)</td><td>Carries PC1 + PC2 traffic</td></tr>
<tr><td>Et0/1</td><td>PC3</td><td>Initial steady-state position</td></tr>
<tr><td>Et0/2</td><td>KALI</td><td>Observer/sniffer</td></tr>
<tr><td>Et0/3</td><td>R1</td><td>Uplink to router</td></tr>
<tr><td>Et0/4</td><td><i>(spare)</i></td><td>Used in Step 3 when PC1 moves directly to SW1</td></tr>
</table>

<div class="callout info">
<b>Note on interface naming:</b> commands below use the <code>Et0/x</code> shorthand. If your SW1 node runs IOSvL2, interfaces are <code>GigabitEthernet0/0</code>–<code>Gi3/3</code> (16 ports) — substitute accordingly.
</div>

| Device | Role | Image |
|---|---|---|
| H1 | Legacy hub | Generic hub or L2 switch in hub mode |
| SW1 | Layer-2 switch | IOSvL2 |
| R1 | Router | IOSv |
| FW1 | Firewall | IOSv (or simulated via ACLs) |
| PC1–PC3 | End hosts | VPCS |
| KALI | Observer | Kali Linux |

<ul class="tool-objectives">
  <li>Understand the role of each device in a network</li>
  <li>Observe collision domains (hub) vs separate collision domains (switch)</li>
  <li>Observe the router as a broadcast boundary</li>
</ul>

## Step 1 — Build &amp; Set up addressing

Cable the topology as shown above: PC1 + PC2 → H1 → SW1 (Et0/0); PC3 → SW1 (Et0/1); KALI → SW1 (Et0/2); SW1 (Et0/3) → R1; R1 → FW1.

On PC1 (VPCS):
<pre><code>ip 192.168.1.10 255.255.255.0 192.168.1.1</code></pre>

On PC2:
<pre><code>ip 192.168.1.20 255.255.255.0 192.168.1.1</code></pre>

On PC3:
<pre><code>ip 192.168.1.30 255.255.255.0 192.168.1.1</code></pre>

On KALI:
<pre><code>sudo ip addr add 192.168.1.100/24 dev eth0
sudo ip route add default via 192.168.1.1</code></pre>

## Step 2 — Observe hub behaviour

From PC1, ping PC2 continuously:
<pre><code>ping 192.168.1.20 -t</code></pre>

While the ping runs, <b>temporarily unplug PC3 from SW1 (Et0/1) and connect it to H1</b> so it shares the hub's collision domain. On PC3, start sniffing:
<pre><code>sudo tcpdump -i eth0 -nn</code></pre>

PC3 now sees PC1's traffic even though it's not the destination — the hub broadcasts everything to every port.

<div class="callout warn">
<b>Collision domain:</b> A hub creates a SINGLE collision domain. If two devices transmit at the same time, a collision occurs. A switch creates a SEPARATE collision domain per port — no collisions, better performance.
</div>

## Step 3 — Observe switch behaviour

Move PC1 directly to SW1 (Et0/4, the spare port), bypassing the hub. Run the same ping to PC2.

Reconnect PC3 to SW1 (Et0/1), back to its original position. PC3 no longer sees the PC1↔PC2 traffic — the switch forwards frames only to the destination port.

Check SW1:
<pre><code>show mac address-table</code></pre>

The switch has learned where each MAC lives.

## Step 4 — Observe router as broadcast boundary

From PC1, ping the broadcast address:
<pre><code>ping 192.168.1.255</code></pre>

The broadcast reaches all devices on the 192.168.1.0/24 LAN. Now configure a second subnet behind R1 and verify the broadcast does NOT cross the router — routers stop broadcasts at the interface boundary.

<div class="achievement">
  <span class="medal">🏗️</span>
  <span class="txt">
    <span class="lbl">Achievement Unlocked</span>
    <span class="name">Network Architect — you understand the four pillars of every network</span>
  </span>
</div>'''

ATTACK_HTML = '''<div class="mission">
  <span class="tag">◈ MISSION</span>
  <h3>Diagnose misconfigurations and device-level failures</h3>
  <p>Networks fail at the device level in predictable ways: wrong cable type, disabled port, duplex mismatch, speed mismatch. Your mission: identify four deliberate faults placed in the topology and fix them using CLI tools and physical inspection.</p>
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
| Fault 1 — Shutdown port | A port is administratively down | <code>show interfaces status</code> |
| Fault 2 — Duplex mismatch | One side full, other half | <code>show interfaces</code> |
| Fault 3 — Speed mismatch | 100 on one side, 10 on the other | <code>show interfaces</code> |
| Fault 4 — Wrong cable | Straight-through instead of crossover | Visual or <code>show interfaces</code> |

Faults may land on any of SW1's five ports (Et0/0–Et0/4) — including the PC3 link (Et0/1) and the PC1-direct spare (Et0/4), not just the hub and KALI links.

## Step 1 — Isolate the faults

From KALI, run a sweep:
<pre><code>for ip in 192.168.1.{10,20,30,1}; do echo -n "$ip: "; fping -c 3 $ip 2>&amp;1 | tail -1; done</code></pre>

Note which IPs are unreachable.

## Step 2 — Diagnose each fault

On SW1:
<pre><code>show interfaces status
show interfaces Et0/0
show interfaces Et0/1
show interfaces Et0/2
show interfaces Et0/3
show interfaces Et0/4</code></pre>

Look for: <code>err-disabled</code>, <code>shutdown</code>, <code>half-duplex</code>, 10M where you expect 100M or 1G.

<div class="callout warn">
<b>Duplex mismatch</b> is the most common real-world fault. One side shouts (full-duplex talking anytime) while the other listens half the time (half-duplex). Result: massive frame errors on the full-duplex side and late collisions on the half-duplex side.
</div>

## Step 3 — Fix each fault

<b>Fault 1 (shutdown port):</b>
<pre><code>configure terminal
interface Et0/X
 no shutdown
end</code></pre>

<b>Fault 2 (duplex):</b>
<pre><code>configure terminal
interface Et0/X
 duplex full
end</code></pre>

<b>Fault 3 (speed):</b>
<pre><code>configure terminal
interface Et0/X
 speed 100
end</code></pre>

<b>Fault 4 (cable):</b> Swap the cable or use a crossover cable / MDIX.

## Step 4 — Verify

Re-run the ping sweep. All IPs should respond.

Check for errors:
<pre><code>show interfaces Et0/X | include errors</code></pre>

All error counters should be 0.

<div class="achievement">
  <span class="medal">🔧</span>
  <span class="txt">
    <span class="lbl">Achievement Unlocked</span>
    <span class="name">Device Doctor — you diagnosed and fixed four hardware-layer faults</span>
  </span>
</div>'''

HARDEN_HTML = '''<div class="mission">
  <span class="tag">◈ MISSION</span>
  <h3>Prevent device-layer failures before they happen</h3>
  <p>Harden the network against device-level issues: enable CDP/LLDP for inventory, configure interface descriptions on <b>all five</b> SW1 ports, set duplex/speed explicitly (don't trust autonegotiation on critical links), enable errdisable auto-recovery, and document everything.</p>
</div>

<div class="stats">
  <span class="chip xp">✦ 200 XP</span>
  <span class="chip diff">◆ Beginner</span>
  <span class="chip time">◷ ~15 min</span>
  <span class="chip loot">⬡ interface docs · errdisable recovery · autonegotiation</span>
</div>

<ul class="objectives">
  <li>Document every interface with descriptions — all 5, not a subset</li>
  <li>Set duplex/speed explicitly on trunk links</li>
  <li>Enable errdisable auto-recovery</li>
  <li>Create a network diagram baseline</li>
</ul>

## Step 1 — Document interfaces

On SW1:
<pre><code>configure terminal
interface Et0/0
 description LINK-TO-HUB-PC1-PC2
interface Et0/1
 description LINK-TO-PC3
interface Et0/2
 description LINK-TO-KALI
interface Et0/3
 description UPLINK-TO-R1
interface Et0/4
 description SPARE-PC1-DIRECT-STEP3-EXPERIMENT
end</code></pre>

## Step 2 — Explicit duplex/speed on trunks

<pre><code>configure terminal
interface Et0/3
 speed 1000
 duplex full
end</code></pre>

## Step 3 — Errdisable auto-recovery

<pre><code>configure terminal
errdisable recovery cause all
errdisable recovery interval 300
end</code></pre>

When a port err-disables (from port-security, BPDU guard, etc.), it automatically recovers after 5 minutes.

## Step 4 — Baseline verification

<pre><code>show running-config | include description
show interfaces description
show errdisable recovery
show interfaces status</code></pre>

Save the output as your network baseline. Compare it against future outputs to detect unauthorised changes. This baseline should show descriptions on all 5 SW1 interfaces, matching the port map in Step 1 of the Build section.

<div class="achievement">
  <span class="medal">🛡️</span>
  <span class="txt">
    <span class="lbl">Achievement Unlocked</span>
    <span class="name">Foundation Guardian — your devices are documented, hardened, and monitored</span>
  </span>
</div>'''

# ============================================================
# DEPLOY
# ============================================================

print("=== Lab 15 v2 — canonical version with inline SVG ===")
print()

print("1. Updating lab_phases...")
update_phase(15, "build",  "Build — Network Devices & Anatomy", BUILD_HTML)
update_phase(15, "attack", "Attack — Troubleshoot Device Failures", ATTACK_HTML)
update_phase(15, "harden", "Harden — Harden Device Configs", HARDEN_HTML)

print()
print("2. Updating lab_topologies...")
b64_small = base64.b64encode(SVG_SMALL.encode()).decode()
b64_large = base64.b64encode(SVG_LARGE.encode()).decode()
legend = '["L2 infrastructure (SW1, H1)","End host (PC1, PC2, PC3)","Router/Firewall (R1, FW1)","Observer/Attacker (KALI)"]'

topo_sql = f"""INSERT INTO lab_topologies (lab_id, svg_small, svg_large, legend) VALUES (
  15,
  convert_from(decode('{b64_small}', 'base64'), 'UTF8'),
  convert_from(decode('{b64_large}', 'base64'), 'UTF8'),
  '{legend}'::jsonb
)
ON CONFLICT (lab_id) DO UPDATE SET
  svg_small = EXCLUDED.svg_small,
  svg_large = EXCLUDED.svg_large,
  legend    = EXCLUDED.legend"""

stdout, stderr, rc = run_sql(topo_sql)
if rc != 0:
    print(f"  FAIL topology: {stderr}")
else:
    print(f"  OK topology")
    v_sql = "SELECT lab_id, length(svg_small), length(svg_large) FROM lab_topologies WHERE lab_id = 15"
    v_out, _, _ = run_sql(v_sql)
    print(f"  {v_out.strip()}")

print()
print("=== DONE ===")
