#!/usr/bin/env python3
"""Deploy Lab 15 — Network Devices & Anatomy (rich content upgrade).
Topology: PC1+PC2→H1→SW1, PC3→SW1, KALI→SW1, R1→FW1
8 nodes: SW1(IOU), H1(hub), R1(c3725), FW1(VPCS), PC1-3(VPCS), KALI(Docker)
IOU L2 has 4 ports (Et0/0-3) — Step 3 adapted accordingly.
"""
import subprocess, base64, sys

def run_sql(sql, dbg=False):
    """Execute SQL via docker exec psql. Returns (stdout, stderr, rc)."""
    # Use -t for tuples-only, -A for unaligned
    cmd = ["docker", "exec", "netbreaker-postgres", "psql",
           "-U", "netbreaker", "-d", "netbreaker", "-c", sql]
    r = subprocess.run(cmd, capture_output=True, text=True, timeout=30)
    if dbg:
        print(f"  STDOUT: {r.stdout.strip()}")
        print(f"  STDERR: {r.stderr.strip()}")
    return r.stdout, r.stderr, r.returncode

def update_phase(lab_id, phase, title, html_content):
    """Update a single lab_phases row via base64 to avoid quoting hell."""
    b64 = base64.b64encode(html_content.encode()).decode()
    sql = f"""UPDATE lab_phases SET
  title = '{title}',
  content = convert_from(decode('{b64}', 'base64'), 'UTF8')
WHERE lab_id = {lab_id} AND phase = '{phase}'"""
    stdout, stderr, rc = run_sql(sql)
    if rc != 0:
        print(f"  ❌ UPDATE {phase} FAILED: {stderr}")
        return False
    # Verify length
    v_sql = f"SELECT length(content) FROM lab_phases WHERE lab_id = {lab_id} AND phase = '{phase}'"
    v_out, _, _ = run_sql(v_sql)
    print(f"  ✅ {phase}: {v_out.strip()} chars")
    return True

# ============================================================
# SVG TOPOLOGIES
# ============================================================

SVG_SMALL = '''<svg viewBox="0 0 380 220" xmlns="http://www.w3.org/2000/svg">
  <defs>
    <marker id="arr" viewBox="0 0 10 10" refX="10" refY="5" markerWidth="6" markerHeight="6" orient="auto-start-reverse"><path d="M0,0 L10,5 L0,10 z" fill="#6b7480"/></marker>
  </defs>
  <style>
    text { font-family: 'JetBrains Mono','Courier New',monospace; }
    .infra { fill:#14161a; stroke:#3a3f47; }
    .host { fill:#2563eb; stroke:#1d4ed8; }
    .kali { fill:#e5484d; stroke:#dc2626; }
    .line { stroke:#6b7480; stroke-width:1.5; fill:none; }
    .lbl { fill:#e4e8ee; font-size:10px; text-anchor:middle; dominant-baseline:central; font-weight:bold; }
    .sub { fill:#6b7480; font-size:7px; text-anchor:middle; }
    .port { fill:#4a5568; font-size:6px; text-anchor:middle; }
  </style>

  <!-- Links -->
  <line x1="62" y1="80" x2="60" y2="110" class="line"/>
  <line x1="62" y1="140" x2="60" y2="130" class="line"/>
  <line x1="82" y1="120" x2="108" y2="120" class="line"/>
  <line x1="110" y1="80" x2="135" y2="82" class="line"/>
  <line x1="110" y1="160" x2="135" y2="158" class="line"/>
  <line x1="177" y1="120" x2="205" y2="120" class="line"/>
  <line x1="227" y1="120" x2="252" y2="120" class="line"/>

  <!-- PC1 -->
  <rect x="20" y="65" width="42" height="30" rx="6" class="host"/>
  <text x="41" y="75" class="lbl" font-size="8">PC1</text>
  <text x="41" y="87" class="sub" font-size="6">.10</text>

  <!-- PC2 -->
  <rect x="20" y="125" width="42" height="30" rx="6" class="host"/>
  <text x="41" y="135" class="lbl" font-size="8">PC2</text>
  <text x="41" y="147" class="sub" font-size="6">.20</text>

  <!-- H1 (hub) -->
  <rect x="62" y="100" width="46" height="40" rx="6" class="infra" opacity="0.85"/>
  <text x="85" y="116" class="lbl" font-size="7">HUB</text>
  <text x="85" y="129" class="sub" font-size="6">H1</text>

  <!-- PC3 -->
  <rect x="88" y="55" width="42" height="30" rx="6" class="host"/>
  <text x="109" y="65" class="lbl" font-size="8">PC3</text>
  <text x="109" y="77" class="sub" font-size="6">.30</text>

  <!-- KALI -->
  <rect x="88" y="150" width="48" height="34" rx="6" class="kali"/>
  <text x="112" y="162" class="lbl" font-size="8">KALI</text>
  <text x="112" y="175" class="sub" font-size="6">.100</text>

  <!-- SW1 -->
  <rect x="135" y="95" width="42" height="50" rx="6" class="infra"/>
  <text x="156" y="114" class="lbl" font-size="8">SW1</text>
  <text x="156" y="127" class="sub" font-size="6">L2</text>
  <text x="156" y="138" class="port">Et0/0-3</text>

  <!-- R1 -->
  <rect x="205" y="100" width="46" height="40" rx="6" class="infra"/>
  <text x="228" y="116" class="lbl" font-size="8">R1</text>
  <text x="228" y="129" class="sub" font-size="6">router</text>

  <!-- FW1 -->
  <rect x="275" y="102" width="44" height="36" rx="6" class="host"/>
  <text x="297" y="115" class="lbl" font-size="8">FW1</text>
  <text x="297" y="128" class="sub" font-size="6">firewall</text>

  <!-- Port labels -->
  <text x="142" y="108" font-size="5" fill="#6b7480">Et0/0</text>
  <text x="142" y="150" font-size="5" fill="#6b7480">Et0/2</text>
  <text x="212" y="108" font-size="5" fill="#6b7480">Et0/3</text>

  <!-- Legend -->
  <rect x="330" y="60" width="45" height="100" rx="4" fill="#1a1d21" stroke="#3a3f47" stroke-width="0.5"/>
  <text x="352" y="78" class="sub" font-size="6">LEGEND</text>
  <rect x="335" y="85" width="14" height="8" rx="2" class="infra"/>
  <text x="355" y="92" font-size="6" fill="#8b94a3">Infra</text>
  <rect x="335" y="98" width="14" height="8" rx="2" class="host"/>
  <text x="355" y="105" font-size="6" fill="#8b94a3">Host</text>
  <rect x="335" y="111" width="14" height="8" rx="2" class="kali"/>
  <text x="355" y="118" font-size="6" fill="#8b94a3">Attacker</text>
  <line x1="335" y1="128" x2="349" y2="128" stroke="#6b7480" stroke-width="1"/>
  <text x="355" y="132" font-size="6" fill="#8b94a3">Link</text>
  <line x1="335" y1="142" x2="349" y2="142" stroke="#e5484d" stroke-width="1" stroke-dasharray="3 2"/>
  <text x="355" y="146" font-size="6" fill="#8b94a3">Attack</text>
  <text x="352" y="156" font-size="5" fill="#4a5568">4 ports</text>
</svg>'''

SVG_LARGE = '''<svg viewBox="0 0 700 380" xmlns="http://www.w3.org/2000/svg">
  <defs>
    <marker id="arr" viewBox="0 0 10 10" refX="10" refY="5" markerWidth="6" markerHeight="6" orient="auto-start-reverse"><path d="M0,0 L10,5 L0,10 z" fill="#6b7480"/></marker>
  </defs>
  <style>
    text { font-family: 'JetBrains Mono','Courier New',monospace; }
    .infra { fill:#14161a; stroke:#3a3f47; stroke-width:1.5; }
    .host { fill:#2563eb; stroke:#1d4ed8; stroke-width:1.5; }
    .kali { fill:#e5484d; stroke:#dc2626; stroke-width:1.5; }
    .line { stroke:#6b7480; stroke-width:2; fill:none; }
    .atk { stroke:#e5484d; stroke-width:2; stroke-dasharray:5 4; fill:none; }
    .lbl { fill:#e4e8ee; font-size:13px; text-anchor:middle; dominant-baseline:central; font-weight:bold; }
    .sub { fill:#6b7480; font-size:10px; text-anchor:middle; }
    .port { fill:#4a5568; font-size:9px; text-anchor:middle; }
    .title { fill:#e4e8ee; font-size:16px; text-anchor:middle; font-weight:bold; }
  </style>

  <!-- Links -->
  <line x1="115" y1="145" x2="115" y2="195" class="line"/>
  <line x1="115" y1="255" x2="115" y2="245" class="line"/>
  <line x1="155" y1="220" x2="210" y2="220" class="line"/>
  <line x1="210" y1="140" x2="260" y2="145" class="line"/>
  <line x1="210" y1="300" x2="260" y2="295" class="line"/>
  <line x1="330" y1="220" x2="390" y2="220" class="line"/>
  <line x1="435" y1="220" x2="480" y2="220" class="line"/>

  <!-- PC1 -->
  <rect x="50" y="120" width="65" height="50" rx="8" class="host"/>
  <text x="82" y="140" class="lbl">PC1</text>
  <text x="82" y="158" class="sub">192.168.1.10</text>

  <!-- PC2 -->
  <rect x="50" y="230" width="65" height="50" rx="8" class="host"/>
  <text x="82" y="250" class="lbl">PC2</text>
  <text x="82" y="268" class="sub">192.168.1.20</text>

  <!-- H1 (hub) -->
  <rect x="115" y="180" width="60" height="80" rx="8" class="infra" opacity="0.85"/>
  <text x="145" y="210" class="lbl">HUB</text>
  <text x="145" y="228" class="sub">H1</text>
  <text x="145" y="243" class="port">collision domain</text>

  <!-- PC3 -->
  <rect x="160" y="80" width="72" height="50" rx="8" class="host"/>
  <text x="196" y="100" class="lbl">PC3</text>
  <text x="196" y="118" class="sub">192.168.1.30</text>

  <!-- KALI -->
  <rect x="160" y="280" width="80" height="56" rx="8" class="kali"/>
  <text x="200" y="302" class="lbl">KALI</text>
  <text x="200" y="320" class="sub">192.168.1.100</text>

  <!-- SW1 -->
  <rect x="260" y="175" width="70" height="90" rx="8" class="infra"/>
  <text x="295" y="205" class="lbl">SW1</text>
  <text x="295" y="223" class="sub">L2 switch</text>
  <text x="295" y="240" class="port">Et0/0–Et0/3</text>
  <text x="295" y="253" class="port">4 ports</text>

  <!-- R1 -->
  <rect x="390" y="185" width="75" height="70" rx="8" class="infra"/>
  <text x="427" y="210" class="lbl">R1</text>
  <text x="427" y="228" class="sub">router</text>
  <text x="427" y="243" class="port">Fa0/0, Fa0/1</text>

  <!-- FW1 -->
  <rect x="510" y="190" width="72" height="60" rx="8" class="host"/>
  <text x="546" y="214" class="lbl">FW1</text>
  <text x="546" y="232" class="sub">firewall</text>

  <!-- Port labels on SW1 -->
  <text x="267" y="195" font-size="8" fill="#6b7480">Et0/0</text>
  <text x="267" y="300" font-size="8" fill="#6b7480">Et0/2</text>
  <text x="265" y="145" font-size="8" fill="#6b7480">Et0/1</text>

  <!-- Legend -->
  <rect x="600" y="60" width="90" height="170" rx="6" fill="#1a1d21" stroke="#3a3f47" stroke-width="1"/>
  <text x="645" y="85" class="sub" font-size="10" fill="#8b94a3">LEGEND</text>
  <rect x="608" y="95" width="20" height="12" rx="3" class="infra"/>
  <text x="635" y="105" font-size="9" fill="#8b94a3">Infrastructure</text>
  <rect x="608" y="115" width="20" height="12" rx="3" class="host"/>
  <text x="635" y="125" font-size="9" fill="#8b94a3">End host</text>
  <rect x="608" y="135" width="20" height="12" rx="3" class="kali"/>
  <text x="635" y="145" font-size="9" fill="#8b94a3">Attacker</text>
  <line x1="608" y1="160" x2="628" y2="160" stroke="#6b7480" stroke-width="1.5"/>
  <text x="635" y="164" font-size="9" fill="#8b94a3">Link</text>
  <line x1="608" y1="178" x2="628" y2="178" stroke="#e5484d" stroke-width="1.5" stroke-dasharray="4 3"/>
  <text x="635" y="182" font-size="9" fill="#8b94a3">Attack path</text>
  <text x="645" y="200" class="sub" font-size="8" fill="#4a5568">IOU 4-port</text>
  <text x="645" y="213" class="sub" font-size="8" fill="#4a5568">Et0/0–3 only</text>
</svg>'''

# ============================================================
# BUILD PHASE HTML
# ============================================================

BUILD_HTML = '''<div class="mission">
  <span class="tag">◈ MISSION</span>
  <h3>Connect the building blocks of a network</h3>
  <p>A network is built from four device types: hubs (dumb repeaters), switches (intelligent forwarders), routers (broadcast boundary enforcers), and firewalls (policy gatekeepers). Misidentify any one and the topology breaks in invisible ways — frames drop, broadcasts leak, and security boundaries dissolve.</p>
</div>

<div class="stats">
  <span class="chip xp">✦ 300 XP</span>
  <span class="chip diff">◆ Beginner</span>
  <span class="chip time">◷ ~30 min</span>
  <span class="chip loot">⬡ hub · switch · router · collision domain</span>
</div>

## Topology

<pre>
              +-------------+
              |     SW1     |
              |  L2 switch  |
              |  4 ports    |
              | Et0/0–Et0/3 |
              +-------------+
              /   |    |    \
             /    |    |     \
          H1     PC3  KALI    R1
         /  \                    \
      PC1   PC2                 FW1
</pre>

<div class="callout info">
  <b>IOU L2 switch limitation:</b> This lab uses the IOU L2 image which has exactly 4 Ethernet ports (Et0/0–Et0/3). In Step 3, the R1 uplink (Et0/3) is temporarily repurposed for PC1's direct switch connection — R1 isn't needed for switching observations. Reconnect R1 before Step 4.
</div>

| Device | Role | Image |
|---|---|---|
| H1 | Legacy hub | Ethernet hub |
| SW1 | Layer-2 switch | IOU L2 (4 ports) |
| R1 | Router | c3725 |
| FW1 | Firewall | VPCS (conceptual) |
| PC1–PC3 | End hosts | VPCS |
| KALI | Observer | Kali Linux |

### SW1 port map (initial build)

| Port | Connects to | Notes |
|---|---|---|
| Et0/0 | H1 (hub uplink) | Carries PC1 + PC2 traffic |
| Et0/1 | PC3 | Initial steady-state position |
| Et0/2 | KALI | Observer/sniffer |
| Et0/3 | R1 | Uplink to router |

<ul class="tool-objectives">
  <li>Understand the role of each device in a network</li>
  <li>Observe collision domains (hub) vs separate collision domains (switch)</li>
  <li>Observe the router as a broadcast boundary</li>
</ul>

## Step 1 — Build & set up addressing

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

PC3 now sees PC1's traffic even though it's not the destination — the hub broadcasts everything to every port, including a device that was never part of the switch-connected steady state.

<div class="callout warn">
  <b>Collision domain:</b> A hub creates a SINGLE collision domain. If two devices transmit at the same time, a collision occurs. A switch creates a SEPARATE collision domain per port — no collisions, better performance.
</div>

## Step 3 — Observe switch behaviour

Reconnect R1 to SW1 Et0/3 first, then temporarily disconnect R1 from Et0/3 to free the port. Move PC1 directly to SW1 (Et0/3 — the now-free R1 uplink port, since R1 isn't needed for this switching observation), bypassing the hub. Run the same ping to PC2.

Reconnect PC3 to SW1 (Et0/1), back to its original position. PC3 no longer sees the PC1↔PC2 traffic — the switch forwards frames only to the destination port.

Check SW1:
<pre><code>show mac address-table</code></pre>

The switch has learned where each MAC lives.

<div class="callout tip">
  After this step, reconnect R1 to SW1 Et0/3 — you'll need it for Step 4.
</div>

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

# ============================================================
# ATTACK PHASE HTML
# ============================================================

ATTACK_HTML = '''<div class="mission">
  <span class="tag">◈ MISSION</span>
  <h3>Diagnose misconfigurations and device-level failures</h3>
  <p>Networks fail at the device level in predictable ways: wrong cable type, disabled port, duplex mismatch, speed mismatch. Your mission: identify four deliberate faults placed in the topology and fix them using CLI tools.</p>
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

Faults may land on any of SW1's four ports (Et0/0–Et0/3) — including the PC3 link (Et0/1) and the PC1-direct port (Et0/3), not just the hub and KALI links.

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
show interfaces Et0/3</code></pre>

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
  <span class="medal">👻</span>
  <span class="txt">
    <span class="lbl">Achievement Unlocked</span>
    <span class="name">Device Doctor — you diagnosed and fixed four hardware-layer faults</span>
  </span>
</div>'''

# ============================================================
# HARDEN PHASE HTML
# ============================================================

HARDEN_HTML = '''<div class="mission">
  <span class="tag">◈ MISSION</span>
  <h3>Prevent device-layer failures before they happen</h3>
  <p>Harden the network against device-level issues: enable CDP/LLDP for inventory, configure interface descriptions on <b>all four</b> SW1 ports, set duplex/speed explicitly (don't trust autonegotiation on critical links), enable errdisable auto-recovery, and document everything.</p>
</div>

<div class="stats">
  <span class="chip xp">✦ 200 XP</span>
  <span class="chip diff">◆ Beginner</span>
  <span class="chip time">◷ ~15 min</span>
  <span class="chip loot">⬡ interface docs · errdisable recovery · autonegotiation</span>
</div>

<ul class="objectives">
  <li>Document every interface with descriptions — all 4, not a subset</li>
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
end</code></pre>

## Step 2 — Explicit duplex/speed on trunks

<pre><code>configure terminal
interface Et0/3
 speed 1000
 duplex full
end</code></pre>

<div class="callout tip">
  Never trust autonegotiation on critical links. A duplex mismatch is invisible to ping but devastates throughput — set speed and duplex explicitly on every trunk and uplink.
</div>

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

Save the output as your network baseline. Compare it against future outputs to detect unauthorised changes. This baseline should show descriptions on all 4 SW1 interfaces, matching the port map in Step 1 of the Build phase.

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

print("=== Lab 15 — Network Devices & Anatomy ===")
print()

# 1. Update phases
print("1. Updating lab_phases...")
update_phase(15, "build",  "Build — Network Devices & Anatomy", BUILD_HTML)
update_phase(15, "attack", "Attack — Troubleshoot Device Failures", ATTACK_HTML)
update_phase(15, "harden", "Harden — Harden Device Configs", HARDEN_HTML)

# 2. Update topology
print()
print("2. Updating lab_topologies...")
b64_small = base64.b64encode(SVG_SMALL.encode()).decode()
b64_large = base64.b64encode(SVG_LARGE.encode()).decode()
legend = '["L2 switch","Hub","Router","Firewall","End host","Attacker (KALI)"]'

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
    print(f"  ❌ topology FAILED: {stderr}")
else:
    print(f"  ✅ topology updated")
    # Verify
    v_sql = "SELECT lab_id, length(svg_small), length(svg_large), legend FROM lab_topologies WHERE lab_id = 15"
    v_out, _, _ = run_sql(v_sql)
    print(f"  {v_out.strip()}")

print()
print("=== DONE ===")
