#!/usr/bin/env python3
"""Deploy Lab 15 v4 — faithful reproduction of Lab15Topology.tsx as plain SVG."""
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
# FAITHFUL PLAIN SVG — converted from Lab15Topology.tsx
# 720×490 viewBox, exact coordinates and colors
# ============================================================

SVG_LARGE = '''<svg viewBox="0 0 720 490" xmlns="http://www.w3.org/2000/svg" role="img" aria-label="NetBreaker Lab 15 topology">
  <defs>
    <pattern id="g15" width="24" height="24" patternUnits="userSpaceOnUse">
      <path d="M24 0H0V24" fill="none" stroke="#1b2129" stroke-width="1"/>
    </pattern>
    <filter id="gl15" x="-40%" y="-40%" width="180%" height="180%">
      <feGaussianBlur stdDeviation="3" result="blur"/>
      <feMerge><feMergeNode in="blur"/><feMergeNode in="SourceGraphic"/></feMerge>
    </filter>
  </defs>

  <rect x="0" y="0" width="720" height="490" rx="10" fill="#0b0f14"/>
  <rect x="1" y="37" width="718" height="452" fill="url(#g15)"/>
  <rect x="0.5" y="0.5" width="719" height="489" rx="10" fill="none" stroke="#22272e" stroke-width="1"/>

  <!-- Chrome bar -->
  <line x1="0" y1="36" x2="720" y2="36" stroke="#22272e" stroke-width="1"/>
  <circle cx="20" cy="18" r="6" fill="#ff5f56"/>
  <circle cx="40" cy="18" r="6" fill="#ffbd2e"/>
  <circle cx="60" cy="18" r="6" fill="#27c93f"/>
  <text x="82" y="22" font-family="'Courier New',monospace" font-size="12" fill="#6e7681">root@netbreaker:~/lab15$ topology --render</text>

  <!-- Bus routing: SW1 drop → horizontal bus → device drops -->
  <line x1="360" y1="130" x2="360" y2="160" stroke="#4d5560" stroke-width="1.5"/>
  <line x1="120" y1="160" x2="600" y2="160" stroke="#4d5560" stroke-width="1.5"/>
  <line x1="120" y1="160" x2="120" y2="190" stroke="#4d5560" stroke-width="1.5"/>
  <line x1="280" y1="160" x2="280" y2="190" stroke="#4d5560" stroke-width="1.5"/>
  <line x1="440" y1="160" x2="440" y2="190" stroke="#4d5560" stroke-width="1.5"/>
  <line x1="600" y1="160" x2="600" y2="190" stroke="#4d5560" stroke-width="1.5"/>

  <!-- Interface chips (GREEN) -->
  <rect x="99" y="150" width="42" height="16" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1"/>
  <text x="120" y="161" text-anchor="middle" font-family="'Courier New',monospace" font-size="10" fill="#3fb950">Et0/0</text>
  <rect x="259" y="150" width="42" height="16" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1"/>
  <text x="280" y="161" text-anchor="middle" font-family="'Courier New',monospace" font-size="10" fill="#3fb950">Et0/1</text>
  <rect x="419" y="150" width="42" height="16" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1"/>
  <text x="440" y="161" text-anchor="middle" font-family="'Courier New',monospace" font-size="10" fill="#3fb950">Et0/2</text>
  <rect x="579" y="150" width="42" height="16" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1"/>
  <text x="600" y="161" text-anchor="middle" font-family="'Courier New',monospace" font-size="10" fill="#3fb950">Et0/3</text>

  <!-- H1 → PC1/PC2 lines (cyan) -->
  <line x1="120" y1="250" x2="120" y2="280" stroke="#22d3ee" stroke-width="1.5"/>
  <line x1="75" y1="280" x2="165" y2="280" stroke="#22d3ee" stroke-width="1.5"/>
  <line x1="75" y1="280" x2="75" y2="310" stroke="#22d3ee" stroke-width="1.5"/>
  <line x1="165" y1="280" x2="165" y2="310" stroke="#22d3ee" stroke-width="1.5"/>

  <!-- R1 → FW1 line -->
  <line x1="600" y1="250" x2="600" y2="310" stroke="#4d5560" stroke-width="1.5"/>

  <!-- Et0/4 spare chip -->
  <rect x="609" y="270" width="42" height="16" rx="3" fill="#0b0f14" stroke="#4d5560" stroke-width="1"/>
  <text x="630" y="281" text-anchor="middle" font-family="'Courier New',monospace" font-size="10" fill="#8b98a5">Et0/4</text>

  <!-- SW1 -->
  <g>
    <rect x="280" y="70" width="160" height="60" rx="6" fill="#131a21" stroke="#8b98a5" stroke-width="1.5"/>
    <text x="360" y="95" text-anchor="middle" font-family="'Courier New',monospace" font-size="15" font-weight="700" fill="#e6edf3">SW1</text>
    <text x="360" y="114" text-anchor="middle" font-family="'Courier New',monospace" font-size="10" fill="#8b98a5">l2_switch — 5 ports</text>
  </g>

  <!-- H1 (amber hub) -->
  <g>
    <rect x="50" y="190" width="140" height="60" rx="6" fill="#131a21" stroke="#d29922" stroke-width="1.5"/>
    <text x="120" y="215" text-anchor="middle" font-family="'Courier New',monospace" font-size="15" font-weight="700" fill="#d29922">H1</text>
    <text x="120" y="234" text-anchor="middle" font-family="'Courier New',monospace" font-size="10" fill="#a17f2f">hub — shared domain</text>
  </g>

  <!-- PC3 (cyan host) -->
  <g>
    <rect x="210" y="190" width="140" height="60" rx="6" fill="#131a21" stroke="#22d3ee" stroke-width="1.5"/>
    <text x="280" y="215" text-anchor="middle" font-family="'Courier New',monospace" font-size="15" font-weight="700" fill="#67e8f9">PC3</text>
    <text x="280" y="234" text-anchor="middle" font-family="'Courier New',monospace" font-size="10" fill="#22d3ee">end_host</text>
  </g>

  <!-- KALI (red dashed + glow on rect ONLY, text outside filter) -->
  <g filter="url(#gl15)">
    <rect x="370" y="190" width="140" height="60" rx="6" fill="#1a0f11" stroke="#f85149" stroke-width="1.5" stroke-dasharray="5 3"/>
  </g>
  <text x="440" y="215" text-anchor="middle" font-family="'Courier New',monospace" font-size="15" font-weight="700" fill="#ff7b72">KALI</text>
  <text x="440" y="234" text-anchor="middle" font-family="'Courier New',monospace" font-size="10" fill="#f85149">observer / sniffer</text>

  <!-- R1 (gray router — same class as SW1) -->
  <g>
    <rect x="530" y="190" width="140" height="60" rx="6" fill="#131a21" stroke="#8b98a5" stroke-width="1.5"/>
    <text x="600" y="215" text-anchor="middle" font-family="'Courier New',monospace" font-size="15" font-weight="700" fill="#e6edf3">R1</text>
    <text x="600" y="234" text-anchor="middle" font-family="'Courier New',monospace" font-size="10" fill="#8b98a5">router</text>
  </g>

  <!-- PC1 (CIRCLE, not rect) -->
  <circle cx="75" cy="340" r="30" fill="#131a21" stroke="#22d3ee" stroke-width="1.5"/>
  <text x="75" y="345" text-anchor="middle" font-family="'Courier New',monospace" font-size="13" font-weight="700" fill="#67e8f9">PC1</text>

  <!-- PC2 (CIRCLE) -->
  <circle cx="165" cy="340" r="30" fill="#131a21" stroke="#22d3ee" stroke-width="1.5"/>
  <text x="165" y="345" text-anchor="middle" font-family="'Courier New',monospace" font-size="13" font-weight="700" fill="#67e8f9">PC2</text>

  <!-- FW1 (gray firewall — same class) -->
  <g>
    <rect x="530" y="310" width="140" height="60" rx="6" fill="#131a21" stroke="#8b98a5" stroke-width="1.5"/>
    <text x="600" y="335" text-anchor="middle" font-family="'Courier New',monospace" font-size="15" font-weight="700" fill="#e6edf3">FW1</text>
    <text x="600" y="354" text-anchor="middle" font-family="'Courier New',monospace" font-size="10" fill="#8b98a5">firewall</text>
  </g>

  <!-- Footer -->
  <line x1="30" y1="405" x2="690" y2="405" stroke="#22272e" stroke-width="1"/>
  <text x="30" y="424" font-family="'Courier New',monospace" font-size="10" fill="#6e7681">// device_legend</text>

  <rect x="30" y="438" width="12" height="12" rx="2" fill="#131a21" stroke="#8b98a5" stroke-width="1.5"/>
  <text x="50" y="448" font-family="'Courier New',monospace" font-size="11" fill="#8b98a5">switch / router / firewall</text>

  <rect x="230" y="438" width="12" height="12" rx="2" fill="#131a21" stroke="#d29922" stroke-width="1.5"/>
  <text x="250" y="448" font-family="'Courier New',monospace" font-size="11" fill="#a17f2f">hub — single collision domain</text>

  <circle cx="486" cy="444" r="6" fill="#131a21" stroke="#22d3ee" stroke-width="1.5"/>
  <text x="500" y="448" font-family="'Courier New',monospace" font-size="11" fill="#22d3ee">end host</text>

  <rect x="580" y="438" width="12" height="12" rx="2" fill="#1a0f11" stroke="#f85149" stroke-width="1.5" stroke-dasharray="3 2"/>
  <text x="600" y="448" font-family="'Courier New',monospace" font-size="11" fill="#f85149">observer / attacker</text>

  <text x="30" y="475" font-family="'Courier New',monospace" font-size="10" fill="#4d5560">initial_build: pc1+pc2→h1→sw1(et0/0) · pc3→sw1(et0/1) · kali→sw1(et0/2) · sw1→r1(et0/3) · r1→fw1</text>
</svg>'''

# Small version: 380×258 (proportional to 720×490)
SVG_SMALL = '''<svg viewBox="0 0 380 258" xmlns="http://www.w3.org/2000/svg" role="img" aria-label="NetBreaker Lab 15 topology">
  <defs>
    <pattern id="g15s" width="13" height="13" patternUnits="userSpaceOnUse">
      <path d="M13 0H0V13" fill="none" stroke="#1b2129" stroke-width="1"/>
    </pattern>
    <filter id="gl15s" x="-40%" y="-40%" width="180%" height="180%">
      <feGaussianBlur stdDeviation="1.5" result="blur"/>
      <feMerge><feMergeNode in="blur"/><feMergeNode in="SourceGraphic"/></feMerge>
    </filter>
  </defs>

  <rect x="0" y="0" width="380" height="258" rx="6" fill="#0b0f14"/>
  <rect x="1" y="20" width="378" height="237" fill="url(#g15s)"/>
  <rect x="0.5" y="0.5" width="379" height="257" rx="6" fill="none" stroke="#22272e" stroke-width="1"/>

  <!-- Chrome bar -->
  <line x1="0" y1="20" x2="380" y2="20" stroke="#22272e" stroke-width="1"/>
  <circle cx="12" cy="10" r="3" fill="#ff5f56"/>
  <circle cx="22" cy="10" r="3" fill="#ffbd2e"/>
  <circle cx="32" cy="10" r="3" fill="#27c93f"/>
  <text x="44" y="13" font-family="'Courier New',monospace" font-size="7" fill="#6e7681">root@netbreaker:~/lab15$ topology --render</text>

  <!-- Bus routing -->
  <line x1="190" y1="72" x2="190" y2="88" stroke="#4d5560" stroke-width="1"/>
  <line x1="62" y1="88" x2="318" y2="88" stroke="#4d5560" stroke-width="1"/>
  <line x1="62" y1="88" x2="62" y2="104" stroke="#4d5560" stroke-width="1"/>
  <line x1="148" y1="88" x2="148" y2="104" stroke="#4d5560" stroke-width="1"/>
  <line x1="232" y1="88" x2="232" y2="104" stroke="#4d5560" stroke-width="1"/>
  <line x1="318" y1="88" x2="318" y2="104" stroke="#4d5560" stroke-width="1"/>

  <!-- Interface chips -->
  <rect x="50" y="82" width="24" height="10" rx="2" fill="#0b0f14" stroke="#3fb950" stroke-width="0.6"/>
  <text x="62" y="89" text-anchor="middle" font-family="'Courier New',monospace" font-size="6" fill="#3fb950">Et0/0</text>
  <rect x="136" y="82" width="24" height="10" rx="2" fill="#0b0f14" stroke="#3fb950" stroke-width="0.6"/>
  <text x="148" y="89" text-anchor="middle" font-family="'Courier New',monospace" font-size="6" fill="#3fb950">Et0/1</text>
  <rect x="220" y="82" width="24" height="10" rx="2" fill="#0b0f14" stroke="#3fb950" stroke-width="0.6"/>
  <text x="232" y="89" text-anchor="middle" font-family="'Courier New',monospace" font-size="6" fill="#3fb950">Et0/2</text>
  <rect x="306" y="82" width="24" height="10" rx="2" fill="#0b0f14" stroke="#3fb950" stroke-width="0.6"/>
  <text x="318" y="89" text-anchor="middle" font-family="'Courier New',monospace" font-size="6" fill="#3fb950">Et0/3</text>

  <!-- H1 → PCs -->
  <line x1="62" y1="135" x2="62" y2="150" stroke="#22d3ee" stroke-width="1"/>
  <line x1="38" y1="150" x2="88" y2="150" stroke="#22d3ee" stroke-width="1"/>
  <line x1="38" y1="150" x2="38" y2="165" stroke="#22d3ee" stroke-width="1"/>
  <line x1="88" y1="150" x2="88" y2="165" stroke="#22d3ee" stroke-width="1"/>

  <!-- R1 → FW1 -->
  <line x1="318" y1="135" x2="318" y2="165" stroke="#4d5560" stroke-width="1"/>

  <!-- SW1 -->
  <rect x="148" y="38" width="84" height="34" rx="4" fill="#131a21" stroke="#8b98a5" stroke-width="1"/>
  <text x="190" y="52" text-anchor="middle" font-family="'Courier New',monospace" font-size="9" font-weight="700" fill="#e6edf3">SW1</text>
  <text x="190" y="63" text-anchor="middle" font-family="'Courier New',monospace" font-size="6" fill="#8b98a5">l2_switch</text>

  <!-- H1 -->
  <rect x="26" y="104" width="74" height="32" rx="4" fill="#131a21" stroke="#d29922" stroke-width="1"/>
  <text x="62" y="117" text-anchor="middle" font-family="'Courier New',monospace" font-size="9" font-weight="700" fill="#d29922">H1</text>
  <text x="62" y="129" text-anchor="middle" font-family="'Courier New',monospace" font-size="6" fill="#a17f2f">hub</text>

  <!-- PC3 -->
  <rect x="110" y="104" width="74" height="32" rx="4" fill="#131a21" stroke="#22d3ee" stroke-width="1"/>
  <text x="148" y="117" text-anchor="middle" font-family="'Courier New',monospace" font-size="9" font-weight="700" fill="#67e8f9">PC3</text>
  <text x="148" y="129" text-anchor="middle" font-family="'Courier New',monospace" font-size="6" fill="#22d3ee">end_host</text>

  <!-- KALI -->
  <g filter="url(#gl15s)">
    <rect x="194" y="104" width="74" height="32" rx="4" fill="#1a0f11" stroke="#f85149" stroke-width="1" stroke-dasharray="3 2"/>
  </g>
  <text x="232" y="117" text-anchor="middle" font-family="'Courier New',monospace" font-size="9" font-weight="700" fill="#ff7b72">KALI</text>
  <text x="232" y="129" text-anchor="middle" font-family="'Courier New',monospace" font-size="6" fill="#f85149">observer</text>

  <!-- R1 -->
  <rect x="280" y="104" width="74" height="32" rx="4" fill="#131a21" stroke="#8b98a5" stroke-width="1"/>
  <text x="318" y="117" text-anchor="middle" font-family="'Courier New',monospace" font-size="9" font-weight="700" fill="#e6edf3">R1</text>
  <text x="318" y="129" text-anchor="middle" font-family="'Courier New',monospace" font-size="6" fill="#8b98a5">router</text>

  <!-- PC1, PC2 circles -->
  <circle cx="38" cy="180" r="16" fill="#131a21" stroke="#22d3ee" stroke-width="1"/>
  <text x="38" y="183" text-anchor="middle" font-family="'Courier New',monospace" font-size="7" font-weight="700" fill="#67e8f9">PC1</text>
  <circle cx="88" cy="180" r="16" fill="#131a21" stroke="#22d3ee" stroke-width="1"/>
  <text x="88" y="183" text-anchor="middle" font-family="'Courier New',monospace" font-size="7" font-weight="700" fill="#67e8f9">PC2</text>

  <!-- FW1 -->
  <rect x="280" y="165" width="74" height="32" rx="4" fill="#131a21" stroke="#8b98a5" stroke-width="1"/>
  <text x="318" y="178" text-anchor="middle" font-family="'Courier New',monospace" font-size="9" font-weight="700" fill="#e6edf3">FW1</text>
  <text x="318" y="190" text-anchor="middle" font-family="'Courier New',monospace" font-size="6" fill="#8b98a5">firewall</text>

  <!-- Footer -->
  <line x1="16" y1="215" x2="364" y2="215" stroke="#22272e" stroke-width="0.6"/>
  <text x="16" y="226" font-family="'Courier New',monospace" font-size="6" fill="#6e7681">// device_legend</text>

  <rect x="16" y="233" width="7" height="7" rx="1" fill="#131a21" stroke="#8b98a5" stroke-width="1"/>
  <text x="26" y="239" font-family="'Courier New',monospace" font-size="6" fill="#8b98a5">switch/router/fw</text>
  <rect x="128" y="233" width="7" height="7" rx="1" fill="#131a21" stroke="#d29922" stroke-width="1"/>
  <text x="138" y="239" font-family="'Courier New',monospace" font-size="6" fill="#a17f2f">hub</text>
  <circle cx="190" cy="237" r="3.5" fill="#131a21" stroke="#22d3ee" stroke-width="1"/>
  <text x="198" y="239" font-family="'Courier New',monospace" font-size="6" fill="#22d3ee">host</text>
  <rect x="244" y="233" width="7" height="7" rx="1" fill="#1a0f11" stroke="#f85149" stroke-width="1" stroke-dasharray="2 1"/>
  <text x="254" y="239" font-family="'Courier New',monospace" font-size="6" fill="#f85149">attacker</text>

  <text x="16" y="252" font-family="'Courier New',monospace" font-size="6" fill="#4d5560">initial_build: pc1+pc2→h1→sw1(et0/0) · pc3→sw1(et0/1) · kali→sw1(et0/2) · r1→sw1(et0/3) · fw1→r1</text>
</svg>'''

# ============================================================
# BUILD PHASE — inline terminal SVG
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
<b>Interface naming:</b> commands use <code>Et0/x</code> shorthand. If your SW1 runs IOSvL2, interfaces are <code>GigabitEthernet0/0</code>–<code>Gi3/3</code> — substitute accordingly.
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

From PC1, ping PC2:
<pre><code>ping 192.168.1.20 -t</code></pre>

<b>Temporarily unplug PC3 from SW1 (Et0/1) and connect it to H1.</b> On PC3, sniff:
<pre><code>sudo tcpdump -i eth0 -nn</code></pre>

PC3 sees PC1's traffic — the hub broadcasts everything to every port.

<div class="callout warn">
<b>Collision domain:</b> A hub creates a SINGLE collision domain. A switch creates a SEPARATE collision domain per port — no collisions.
</div>

## Step 3 — Observe switch behaviour

Move PC1 directly to SW1 (Et0/4 spare, or any available port), bypassing the hub. Ping PC2. Reconnect PC3 to SW1 (Et0/1). PC3 no longer sees PC1↔PC2 traffic — the switch forwards only to the destination port.

<pre><code>show mac address-table</code></pre>

## Step 4 — Observe router as broadcast boundary

<pre><code>ping 192.168.1.255</code></pre>

Broadcast reaches everyone on 192.168.1.0/24. Configure a second subnet behind R1 — broadcasts stop at the router.

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

Faults may land on any of SW1's ports.

## Step 1 — Isolate

From KALI:
<pre><code>for ip in 192.168.1.{10,20,30,1}; do echo -n "$ip: "; fping -c 3 $ip 2>&amp;1 | tail -1; done</code></pre>

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

Re-run ping sweep. All IPs respond. <code>show interfaces Et0/X | include errors</code> — all counters = 0.

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
  <li>Set duplex/speed explicitly on trunks</li>
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
Never trust autonegotiation on critical links. Duplex mismatch is invisible to ping but devastates throughput.
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

print("=== Lab 15 v4 — faithful TSX reproduction ===")
print()

print("1. Updating lab_phases...")
update_phase(15, "build",  "Build — Network Devices & Anatomy", BUILD_HTML)
update_phase(15, "attack", "Attack — Troubleshoot Device Failures", ATTACK_HTML)
update_phase(15, "harden", "Harden — Harden Device Configs", HARDEN_HTML)

print()
print("2. Updating lab_topologies...")
b64_small = base64.b64encode(SVG_SMALL.encode()).decode()
b64_large = base64.b64encode(SVG_LARGE.encode()).decode()
legend = '["Switch / Router / FW (gray)","Hub — single collision domain (amber)","End host (cyan circle)","Observer / Attacker (red dashed+glow)"]'

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
