#!/usr/bin/env python3
"""Deploy Lab 15 v3 — terminal-window SVG with orthogonal routing."""
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
# TERMINAL-WINDOW SVG — dark hacker aesthetic, orthogonal routing
# ============================================================

# Shared SVG body for both sizes — just the main content area
# Large: 700×430, Small: 380×240

def make_svg(w, h, scale_x, scale_y):
    """Generate SVG with scaled coordinates."""
    # Scale helper
    def sx(x): return x * scale_x
    def sy(y): return y * scale_y
    def sw(val): return val * min(scale_x, scale_y)  # stroke-width scales uniformly

    return f'''<svg viewBox="0 0 {w} {h}" xmlns="http://www.w3.org/2000/svg">
  <defs>
    <filter id="glow">
      <feGaussianBlur stdDeviation="{sw(3)}" result="blur"/>
      <feMerge><feMergeNode in="blur"/><feMergeNode in="SourceGraphic"/></feMerge>
    </filter>
    <pattern id="grid" width="{sw(20)}" height="{sw(20)}" patternUnits="userSpaceOnUse">
      <path d="M {sw(20)} 0 L 0 0 0 {sw(20)}" fill="none" stroke="#1a1d24" stroke-width="{sw(0.5)}"/>
    </pattern>
  </defs>

  <!-- TERMINAL BACKGROUND -->
  <rect x="0" y="0" width="{w}" height="{h}" rx="{sw(6)}" fill="#0c0e12"/>
  <rect x="0" y="0" width="{w}" height="{h}" rx="{sw(6)}" fill="url(#grid)" opacity="0.5"/>

  <!-- CHROME BAR -->
  <rect x="0" y="0" width="{w}" height="{sy(30)}" rx="{sw(6)}" fill="#16181d"/>
  <rect x="0" y="{sy(16)}" width="{w}" height="{sy(14)}" fill="#16181d"/>
  <!-- Traffic lights -->
  <circle cx="{sx(14)}" cy="{sy(15)}" r="{sw(5)}" fill="#ef4444"/>
  <circle cx="{sx(30)}" cy="{sy(15)}" r="{sw(5)}" fill="#eab308"/>
  <circle cx="{sx(46)}" cy="{sy(15)}" r="{sw(5)}" fill="#22c55e"/>
  <!-- Fake prompt -->
  <text x="{sx(64)}" y="{sy(19)}" font-family="JetBrains Mono,monospace" font-size="{sw(9)}" fill="#6b7280">
    root@netbreaker:~/lab15$<tspan fill="#e4e8ee"> topology</tspan><tspan fill="#6b7280"> --render</tspan><tspan fill="#e4e8ee">▊</tspan>
  </text>

  <!-- SW1 — HORIZONTAL BUS BAR -->
  <rect x="{sx(140)}" y="{sy(52)}" width="{sx(420)}" height="{sy(4)}" rx="{sw(2)}" fill="#4a5568"/>
  <!-- SW1 box -->
  <rect x="{sx(310)}" y="{sy(42)}" width="{sx(80)}" height="{sy(26)}" rx="{sw(4)}" fill="#1e2128" stroke="#8b94a3" stroke-width="{sw(1.2)}"/>
  <text x="{sx(350)}" y="{sy(58)}" text-anchor="middle" font-family="JetBrains Mono,monospace" font-size="{sw(10)}" font-weight="bold" fill="#cbd5e1">SW1</text>

  <!-- BUS DROPS — orthogonal right-angle lines -->
  <!-- Drop to H1: Et0/0 -->
  <line x1="{sx(190)}" y1="{sy(54)}" x2="{sx(190)}" y2="{sy(140)}" stroke="#8b94a3" stroke-width="{sw(1)}"/>
  <!-- Drop to PC3: Et0/1 -->
  <line x1="{sx(290)}" y1="{sy(54)}" x2="{sx(290)}" y2="{sy(130)}" stroke="#8b94a3" stroke-width="{sw(1)}"/>
  <!-- Drop to KALI: Et0/2 -->
  <line x1="{sx(390)}" y1="{sy(54)}" x2="{sx(390)}" y2="{sy(140)}" stroke="#e5484d" stroke-width="{sw(1)}" stroke-dasharray="{sw(4)},{sw(3)}" filter="url(#glow)" opacity="0.8"/>
  <!-- Drop to R1: Et0/3 -->
  <line x1="{sx(510)}" y1="{sy(54)}" x2="{sx(510)}" y2="{sy(140)}" stroke="#8b94a3" stroke-width="{sw(1)}"/>

  <!-- INTERFACE CHIPS on cable segments -->
  <rect x="{sx(170)}" y="{sy(84)}" width="{sx(40)}" height="{sy(12)}" rx="{sw(2)}" fill="#1a1d24" stroke="#4a5568" stroke-width="{sw(0.6)}"/>
  <text x="{sx(190)}" y="{sy(93)}" text-anchor="middle" font-family="JetBrains Mono,monospace" font-size="{sw(7)}" fill="#8b94a3">Et0/0</text>

  <rect x="{sx(270)}" y="{sy(80)}" width="{sx(40)}" height="{sy(12)}" rx="{sw(2)}" fill="#1a1d24" stroke="#4a5568" stroke-width="{sw(0.6)}"/>
  <text x="{sx(290)}" y="{sy(89)}" text-anchor="middle" font-family="JetBrains Mono,monospace" font-size="{sw(7)}" fill="#8b94a3">Et0/1</text>

  <rect x="{sx(370)}" y="{sy(84)}" width="{sx(40)}" height="{sy(12)}" rx="{sw(2)}" fill="#1a1d24" stroke="#e5484d" stroke-width="{sw(0.6)}"/>
  <text x="{sx(390)}" y="{sy(93)}" text-anchor="middle" font-family="JetBrains Mono,monospace" font-size="{sw(7)}" fill="#f87171">Et0/2</text>

  <rect x="{sx(490)}" y="{sy(84)}" width="{sx(40)}" height="{sy(12)}" rx="{sw(2)}" fill="#1a1d24" stroke="#4a5568" stroke-width="{sw(0.6)}"/>
  <text x="{sx(510)}" y="{sy(93)}" text-anchor="middle" font-family="JetBrains Mono,monospace" font-size="{sw(7)}" fill="#8b94a3">Et0/3</text>

  <!-- DEVICE NODES -->

  <!-- H1 — amber hub -->
  <rect x="{sx(140)}" y="{sy(142)}" width="{sx(100)}" height="{sy(40)}" rx="{sw(5)}" fill="#1e1b12" stroke="#f59e0b" stroke-width="{sw(1.2)}"/>
  <text x="{sx(190)}" y="{sy(160)}" text-anchor="middle" font-family="JetBrains Mono,monospace" font-size="{sw(9)}" fill="#fbbf24">H1</text>
  <text x="{sx(190)}" y="{sy(175)}" text-anchor="middle" font-family="JetBrains Mono,monospace" font-size="{sw(7)}" fill="#92400e">hub</text>

  <!-- PC3 — cyan host -->
  <rect x="{sx(255)}" y="{sy(132)}" width="{sx(70)}" height="{sy(40)}" rx="{sw(5)}" fill="#0f1a1a" stroke="#06b6d4" stroke-width="{sw(1.2)}"/>
  <text x="{sx(290)}" y="{sy(150)}" text-anchor="middle" font-family="JetBrains Mono,monospace" font-size="{sw(9)}" fill="#22d3ee">PC3</text>
  <text x="{sx(290)}" y="{sy(165)}" text-anchor="middle" font-family="JetBrains Mono,monospace" font-size="{sw(7)}" fill="#0e7490">.30</text>

  <!-- KALI — red dashed + glow -->
  <rect x="{sx(350)}" y="{sy(142)}" width="{sx(80)}" height="{sy(40)}" rx="{sw(5)}" fill="#1a1012" stroke="#e5484d" stroke-width="{sw(1.2)}" stroke-dasharray="{sw(4)},{sw(2)}" filter="url(#glow)"/>
  <text x="{sx(390)}" y="{sy(160)}" text-anchor="middle" font-family="JetBrains Mono,monospace" font-size="{sw(9)}" fill="#f87171">KALI</text>
  <text x="{sx(390)}" y="{sy(175)}" text-anchor="middle" font-family="JetBrains Mono,monospace" font-size="{sw(7)}" fill="#b91c1c">.100</text>

  <!-- R1 — blue router -->
  <rect x="{sx(465)}" y="{sy(142)}" width="{sx(90)}" height="{sy(40)}" rx="{sw(5)}" fill="#0e161f" stroke="#3b82f6" stroke-width="{sw(1.2)}"/>
  <text x="{sx(510)}" y="{sy(160)}" text-anchor="middle" font-family="JetBrains Mono,monospace" font-size="{sw(9)}" fill="#60a5fa">R1</text>
  <text x="{sx(510)}" y="{sy(175)}" text-anchor="middle" font-family="JetBrains Mono,monospace" font-size="{sw(7)}" fill="#1e40af">router</text>

  <!-- SECOND-ROW: PC1, PC2 below H1 -->
  <!-- H1 → PC1 line -->
  <line x1="{sx(175)}" y1="{sy(182)}" x2="{sx(175)}" y2="{sy(220)}" stroke="#f59e0b" stroke-width="{sw(1)}" opacity="0.6"/>
  <line x1="{sx(175)}" y1="{sy(220)}" x2="{sx(155)}" y2="{sy(220)}" stroke="#f59e0b" stroke-width="{sw(1)}" opacity="0.6"/>
  <line x1="{sx(155)}" y1="{sy(220)}" x2="{sx(155)}" y2="{sy(238)}" stroke="#06b6d4" stroke-width="{sw(1)}"/>

  <!-- H1 → PC2 line -->
  <line x1="{sx(205)}" y1="{sy(182)}" x2="{sx(205)}" y2="{sy(220)}" stroke="#f59e0b" stroke-width="{sw(1)}" opacity="0.6"/>
  <line x1="{sx(205)}" y1="{sy(220)}" x2="{sx(235)}" y2="{sy(220)}" stroke="#f59e0b" stroke-width="{sw(1)}" opacity="0.6"/>
  <line x1="{sx(235)}" y1="{sy(220)}" x2="{sx(235)}" y2="{sy(238)}" stroke="#06b6d4" stroke-width="{sw(1)}"/>

  <!-- R1 → FW1 line -->
  <line x1="{sx(510)}" y1="{sy(182)}" x2="{sx(510)}" y2="{sy(238)}" stroke="#3b82f6" stroke-width="{sw(1)}" opacity="0.6"/>

  <!-- PC1 -->
  <rect x="{sx(120)}" y="{sy(240)}" width="{sx(70)}" height="{sy(36)}" rx="{sw(5)}" fill="#0f1a1a" stroke="#06b6d4" stroke-width="{sw(1.2)}"/>
  <text x="{sx(155)}" y="{sy(256)}" text-anchor="middle" font-family="JetBrains Mono,monospace" font-size="{sw(9)}" fill="#22d3ee">PC1</text>
  <text x="{sx(155)}" y="{sy(270)}" text-anchor="middle" font-family="JetBrains Mono,monospace" font-size="{sw(7)}" fill="#0e7490">.10</text>

  <!-- PC2 -->
  <rect x="{sx(200)}" y="{sy(240)}" width="{sx(70)}" height="{sy(36)}" rx="{sw(5)}" fill="#0f1a1a" stroke="#06b6d4" stroke-width="{sw(1.2)}"/>
  <text x="{sx(235)}" y="{sy(256)}" text-anchor="middle" font-family="JetBrains Mono,monospace" font-size="{sw(9)}" fill="#22d3ee">PC2</text>
  <text x="{sx(235)}" y="{sy(270)}" text-anchor="middle" font-family="JetBrains Mono,monospace" font-size="{sw(7)}" fill="#0e7490">.20</text>

  <!-- FW1 -->
  <rect x="{sx(465)}" y="{sy(240)}" width="{sx(90)}" height="{sy(36)}" rx="{sw(5)}" fill="#0e161f" stroke="#3b82f6" stroke-width="{sw(1.2)}"/>
  <text x="{sx(510)}" y="{sy(256)}" text-anchor="middle" font-family="JetBrains Mono,monospace" font-size="{sw(9)}" fill="#60a5fa">FW1</text>
  <text x="{sx(510)}" y="{sy(270)}" text-anchor="middle" font-family="JetBrains Mono,monospace" font-size="{sw(7)}" fill="#1e40af">firewall</text>

  <!-- FOOTER — config-dump style -->
  <line x1="0" y1="{sy(296)}" x2="{w}" y2="{sy(296)}" stroke="#1e2128" stroke-width="{sw(0.8)}"/>
  <text x="{sx(10)}" y="{sy(314)}" font-family="JetBrains Mono,monospace" font-size="{sw(7)}" fill="#4a5568">
    <tspan fill="#6b7280">// device_legend:</tspan>
    <tspan fill="#cbd5e1">SW1</tspan><tspan fill="#4a5568">=switch</tspan>
    <tspan fill="#fbbf24"> H1</tspan><tspan fill="#4a5568">=hub</tspan>
    <tspan fill="#22d3ee"> PC*</tspan><tspan fill="#4a5568">=host</tspan>
    <tspan fill="#f87171"> KALI</tspan><tspan fill="#4a5568">=attacker</tspan>
    <tspan fill="#60a5fa"> R1</tspan><tspan fill="#4a5568">=router</tspan>
    <tspan fill="#60a5fa"> FW1</tspan><tspan fill="#4a5568">=firewall</tspan>
  </text>
  <text x="{sx(10)}" y="{sy(332)}" font-family="JetBrains Mono,monospace" font-size="{sw(7)}" fill="#4a5568">
    <tspan fill="#6b7280">// initial_build:</tspan>
    <tspan fill="#cbd5e1"> PC1+PC2→H1→SW1(Et0/0), PC3→SW1(Et0/1), KALI→SW1(Et0/2), R1→SW1(Et0/3), FW1→R1</tspan>
  </text>

  <!-- Spare port chip -->
  <rect x="{sx(545)}" y="{sy(84)}" width="{sx(50)}" height="{sy(12)}" rx="{sw(2)}" fill="#1a1d24" stroke="#374151" stroke-width="{sw(0.6)}"/>
  <text x="{sx(570)}" y="{sy(93)}" text-anchor="middle" font-family="JetBrains Mono,monospace" font-size="{sw(7)}" fill="#4a5568">Et0/4</text>
  <line x1="{sx(570)}" y1="{sy(96)}" x2="{sx(570)}" y2="{sy(110)}" stroke="#374151" stroke-width="{sw(0.8)}" stroke-dasharray="{sw(2)},{sw(2)}"/>
  <text x="{sx(585)}" y="{sy(114)}" font-family="JetBrains Mono,monospace" font-size="{sw(6)}" fill="#374151">spare</text>
</svg>'''

# ============================================================
# GENERATE BOTH SIZES
# ============================================================

# Large: 700×360
SVG_LARGE = make_svg(700, 360, 1.0, 1.0)
# Small: 380×200
SVG_SMALL = make_svg(380, 200, 380/700, 200/360)

# ============================================================
# BUILD PHASE — with inline terminal SVG
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

''' + SVG_LARGE + '''

<p><b>Cabling:</b></p>
<ul>
  <li>PC1 + PC2 → H1 (hub) → SW1 (Et0/0)</li>
  <li>PC3 → SW1 (Et0/1)</li>
  <li>KALI → SW1 (Et0/2)</li>
  <li>SW1 (Et0/3) → R1</li>
  <li>R1 → FW1</li>
  <li>Et0/4 — spare (Step 3 PC1 direct connection)</li>
</ul>

<div class="callout info">
<b>Interface naming:</b> commands use <code>Et0/x</code> shorthand. If your SW1 runs IOSvL2, interfaces are <code>GigabitEthernet0/0</code>–<code>Gi3/3</code> — substitute accordingly. The IOU L2 image has 4 ports (Et0/0–Et0/3); Et0/4 is shown for conceptual completeness.
</div>

| Device | Role | Image |
|---|---|---|
| H1 | Legacy hub | Ethernet hub |
| SW1 | Layer-2 switch | IOU L2 / IOSvL2 |
| R1 | Router | c3725 IOSv |
| FW1 | Firewall | VPCS (conceptual) |
| PC1–PC3 | End hosts | VPCS |
| KALI | Observer/attacker | Kali Linux |

<ul class="tool-objectives">
  <li>Understand the role of each device in a network</li>
  <li>Observe collision domains (hub) vs separate collision domains (switch)</li>
  <li>Observe the router as a broadcast boundary</li>
</ul>

## Step 1 — Build &amp; Set up addressing

Cable the topology as shown above.

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

<b>Temporarily unplug PC3 from SW1 (Et0/1) and connect it to H1.</b> On PC3, sniff:
<pre><code>sudo tcpdump -i eth0 -nn</code></pre>

PC3 now sees PC1's traffic — the hub broadcasts everything to every port.

<div class="callout warn">
<b>Collision domain:</b> A hub creates a SINGLE collision domain. A switch creates a SEPARATE collision domain per port.
</div>

## Step 3 — Observe switch behaviour

Move PC1 directly to SW1 (Et0/4 spare, or any available port), bypassing the hub. Run the same ping to PC2. Reconnect PC3 to SW1 (Et0/1).

PC3 no longer sees the PC1↔PC2 traffic — the switch forwards frames only to the destination port.

<pre><code>show mac address-table</code></pre>

## Step 4 — Observe router as broadcast boundary

From PC1, ping the broadcast address:
<pre><code>ping 192.168.1.255</code></pre>

The broadcast reaches all devices on 192.168.1.0/24. Configure a second subnet behind R1 — broadcasts do NOT cross routers.

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
| Fault 4 — Wrong cable | Straight-through vs crossover | Visual / <code>show interfaces</code> |

Faults may land on any of SW1's ports (Et0/0–Et0/4).

## Step 1 — Isolate the faults

From KALI:
<pre><code>for ip in 192.168.1.{10,20,30,1}; do echo -n "$ip: "; fping -c 3 $ip 2>&amp;1 | tail -1; done</code></pre>

## Step 2 — Diagnose each fault

<pre><code>show interfaces status
show interfaces Et0/0 | show interfaces Et0/1
show interfaces Et0/2 | show interfaces Et0/3</code></pre>

Look for: <code>err-disabled</code>, <code>shutdown</code>, <code>half-duplex</code>, 10M.

<div class="callout warn">
<b>Duplex mismatch</b> — most common real-world fault. One side shouts (full) while the other listens half the time. Frame errors on full-duplex side, late collisions on half-duplex side.
</div>

## Step 3 — Fix each fault

<b>Shutdown:</b> <code>interface Et0/X → no shutdown</code><br/>
<b>Duplex:</b> <code>interface Et0/X → duplex full</code><br/>
<b>Speed:</b> <code>interface Et0/X → speed 100</code><br/>
<b>Cable:</b> Swap or use MDIX.

## Step 4 — Verify

Re-run ping sweep. All IPs respond. Check <code>show interfaces Et0/X | include errors</code> — all counters = 0.

<div class="achievement">
  <span class="medal">🔧</span>
  <span class="txt">
    <span class="lbl">Achievement Unlocked</span>
    <span class="name">Device Doctor — four hardware-layer faults diagnosed and fixed</span>
  </span>
</div>'''

HARDEN_HTML = '''<div class="mission">
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
  <li>Document every interface with descriptions</li>
  <li>Set duplex/speed explicitly on trunk links</li>
  <li>Enable errdisable auto-recovery</li>
  <li>Create and save a network baseline</li>
</ul>

## Step 1 — Document interfaces

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
 description SPARE-PC1-DIRECT-STEP3
end</code></pre>

## Step 2 — Explicit duplex/speed on trunks

<pre><code>interface Et0/3
 speed 1000
 duplex full</code></pre>

<div class="callout tip">
Never trust autonegotiation on critical links. A duplex mismatch is invisible to ping but devastates throughput.
</div>

## Step 3 — Errdisable auto-recovery

<pre><code>errdisable recovery cause all
errdisable recovery interval 300</code></pre>

Ports auto-recover after 5 minutes.

## Step 4 — Baseline verification

<pre><code>show running-config | include description
show interfaces description
show errdisable recovery
show interfaces status</code></pre>

Save output as baseline. Compare against future outputs to detect unauthorised changes.

<div class="achievement">
  <span class="medal">🛡️</span>
  <span class="txt">
    <span class="lbl">Achievement Unlocked</span>
    <span class="name">Foundation Guardian — devices documented, hardened, monitored</span>
  </span>
</div>'''

# ============================================================
# DEPLOY
# ============================================================

print("=== Lab 15 v3 — terminal-window SVG ===")
print()

print("1. Updating lab_phases...")
update_phase(15, "build",  "Build — Network Devices & Anatomy", BUILD_HTML)
update_phase(15, "attack", "Attack — Troubleshoot Device Failures", ATTACK_HTML)
update_phase(15, "harden", "Harden — Harden Device Configs", HARDEN_HTML)

print()
print("2. Updating lab_topologies...")
b64_small = base64.b64encode(SVG_SMALL.encode()).decode()
b64_large = base64.b64encode(SVG_LARGE.encode()).decode()
legend = '["Switch infra (SW1)","Hub (H1 — amber)","End host (PC1-3 — cyan)","Attacker (KALI — red dashed+glow)","Router/Firewall (R1,FW1 — blue)"]'

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
