#!/usr/bin/env python3
"""Fix: Deploy Lab 15 v5 DB content (topology + phases) with SVG embedded."""
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

# Read SVG from the bundled file
with open("/tmp/lab-15-topology.svg") as f:
    SVG_LARGE = f.read().strip()

# Minimal small SVG placeholder (hand-crafted)
SVG_SMALL = r'''<svg viewBox="0 0 380 258" xmlns="http://www.w3.org/2000/svg" role="img">
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
  <line x1="0" y1="20" x2="380" y2="20" stroke="#22272e" stroke-width="1"/>
  <circle cx="12" cy="10" r="3" fill="#ff5f56"/><circle cx="22" cy="10" r="3" fill="#ffbd2e"/><circle cx="32" cy="10" r="3" fill="#27c93f"/>
  <text x="44" y="13" font-family="'Courier New',monospace" font-size="7" fill="#6e7681">root@netbreaker:~/lab15$ topology --render</text>

  <line x1="190" y1="72" x2="190" y2="88" stroke="#4d5560" stroke-width="1"/>
  <line x1="62" y1="88" x2="318" y2="88" stroke="#4d5560" stroke-width="1"/>
  <line x1="62" y1="88" x2="62" y2="104" stroke="#4d5560" stroke-width="1"/>
  <line x1="148" y1="88" x2="148" y2="104" stroke="#4d5560" stroke-width="1"/>
  <line x1="232" y1="88" x2="232" y2="104" stroke="#4d5560" stroke-width="1"/>
  <line x1="318" y1="88" x2="318" y2="104" stroke="#4d5560" stroke-width="1"/>

  <rect x="50" y="82" width="24" height="10" rx="2" fill="#0b0f14" stroke="#3fb950" stroke-width="0.6"/>
  <text x="62" y="89" text-anchor="middle" font-family="'Courier New',monospace" font-size="6" fill="#3fb950">Et0/0</text>
  <rect x="136" y="82" width="24" height="10" rx="2" fill="#0b0f14" stroke="#3fb950" stroke-width="0.6"/>
  <text x="148" y="89" text-anchor="middle" font-family="'Courier New',monospace" font-size="6" fill="#3fb950">Et0/1</text>
  <rect x="220" y="82" width="24" height="10" rx="2" fill="#0b0f14" stroke="#3fb950" stroke-width="0.6"/>
  <text x="232" y="89" text-anchor="middle" font-family="'Courier New',monospace" font-size="6" fill="#3fb950">Et0/2</text>
  <rect x="306" y="82" width="24" height="10" rx="2" fill="#0b0f14" stroke="#3fb950" stroke-width="0.6"/>
  <text x="318" y="89" text-anchor="middle" font-family="'Courier New',monospace" font-size="6" fill="#3fb950">Et0/3</text>

  <line x1="62" y1="135" x2="62" y2="150" stroke="#22d3ee" stroke-width="1"/>
  <line x1="38" y1="150" x2="148" y2="150" stroke="#22d3ee" stroke-width="1"/>
  <line x1="38" y1="150" x2="38" y2="165" stroke="#22d3ee" stroke-width="1"/>
  <line x1="88" y1="150" x2="88" y2="165" stroke="#22d3ee" stroke-width="1"/>
  <line x1="148" y1="150" x2="148" y2="167" stroke="#22d3ee" stroke-width="1"/>

  <line x1="318" y1="135" x2="318" y2="165" stroke="#4d5560" stroke-width="1"/>

  <rect x="148" y="38" width="84" height="34" rx="4" fill="#131a21" stroke="#8b98a5" stroke-width="1"/>
  <text x="190" y="52" text-anchor="middle" font-family="'Courier New',monospace" font-size="9" font-weight="700" fill="#e6edf3">SW1</text>
  <text x="190" y="63" text-anchor="middle" font-family="'Courier New',monospace" font-size="6" fill="#8b98a5">l2_switch</text>

  <rect x="26" y="104" width="74" height="32" rx="4" fill="#131a21" stroke="#d29922" stroke-width="1"/>
  <text x="62" y="117" text-anchor="middle" font-family="'Courier New',monospace" font-size="9" font-weight="700" fill="#d29922">H1</text>
  <text x="62" y="129" text-anchor="middle" font-family="'Courier New',monospace" font-size="6" fill="#a17f2f">hub</text>

  <rect x="110" y="104" width="74" height="32" rx="4" fill="#131a21" stroke="#22d3ee" stroke-width="1"/>
  <text x="148" y="117" text-anchor="middle" font-family="'Courier New',monospace" font-size="9" font-weight="700" fill="#67e8f9">PC3</text>

  <g filter="url(#gl15s)">
    <rect x="194" y="104" width="74" height="32" rx="4" fill="#1a0f11" stroke="#f85149" stroke-width="1" stroke-dasharray="3 2"/>
  </g>
  <text x="232" y="117" text-anchor="middle" font-family="'Courier New',monospace" font-size="9" font-weight="700" fill="#ff7b72">KALI</text>

  <rect x="280" y="104" width="74" height="32" rx="4" fill="#131a21" stroke="#8b98a5" stroke-width="1"/>
  <text x="318" y="117" text-anchor="middle" font-family="'Courier New',monospace" font-size="9" font-weight="700" fill="#e6edf3">R1</text>

  <circle cx="38" cy="180" r="16" fill="#131a21" stroke="#22d3ee" stroke-width="1"/>
  <text x="38" y="183" text-anchor="middle" font-family="'Courier New',monospace" font-size="7" font-weight="700" fill="#67e8f9">PC1</text>
  <circle cx="88" cy="180" r="16" fill="#131a21" stroke="#22d3ee" stroke-width="1"/>
  <text x="88" y="183" text-anchor="middle" font-family="'Courier New',monospace" font-size="7" font-weight="700" fill="#67e8f9">PC2</text>

  <g filter="url(#gl15s)">
    <rect x="120" y="167" width="56" height="30" rx="4" fill="#1a0f11" stroke="#f85149" stroke-width="1" stroke-dasharray="3 2"/>
  </g>
  <text x="148" y="181" text-anchor="middle" font-family="'Courier New',monospace" font-size="8" font-weight="700" fill="#ff7b72">KALI2</text>

  <rect x="280" y="165" width="74" height="32" rx="4" fill="#131a21" stroke="#8b98a5" stroke-width="1"/>
  <text x="318" y="178" text-anchor="middle" font-family="'Courier New',monospace" font-size="9" font-weight="700" fill="#e6edf3">FW1</text>

  <line x1="16" y1="215" x2="364" y2="215" stroke="#22272e" stroke-width="0.6"/>
  <text x="16" y="226" font-family="'Courier New',monospace" font-size="6" fill="#6e7681">// device_legend</text>
  <rect x="16" y="233" width="7" height="7" rx="1" fill="#131a21" stroke="#8b98a5" stroke-width="1"/>
  <text x="26" y="239" font-family="'Courier New',monospace" font-size="6" fill="#8b98a5">switch/router/fw</text>
  <rect x="128" y="233" width="7" height="7" rx="1" fill="#131a21" stroke="#d29922" stroke-width="1"/>
  <text x="138" y="239" font-family="'Courier New',monospace" font-size="6" fill="#a17f2f">hub</text>
  <circle cx="190" cy="237" r="3.5" fill="#131a21" stroke="#22d3ee" stroke-width="1"/>
  <text x="198" y="239" font-family="'Courier New',monospace" font-size="6" fill="#22d3ee">host</text>
  <rect x="244" y="233" width="7" height="7" rx="1" fill="#1a0f11" stroke="#f85149" stroke-width="1" stroke-dasharray="2 1"/>
  <text x="254" y="239" font-family="'Courier New',monospace" font-size="6" fill="#f85149">sniffer</text>
  <text x="16" y="252" font-family="'Courier New',monospace" font-size="6" fill="#4d5560">build: pc1+pc2+kali2→h1→sw1(et0/0) · pc3→sw1(et0/1) · kali→sw1(et0/2) · r1→sw1(et0/3)</text>
</svg>'''

# Simple build HTML with inline SVG
BUILD = '<div class="mission"><span class="tag">MISSION</span><h3>Identify every device on the wire</h3></div>' + SVG_LARGE

print("Updating topology...")
b64_large = base64.b64encode(SVG_LARGE.encode()).decode()
b64_small = base64.b64encode(SVG_SMALL.encode()).decode()
legend = '["Switch / Router / FW","Hub (amber)","End host (cyan)","Sniffer — permanent (red dashed+glow)"]'

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
    print(f"FAIL topology: {stderr}")
else:
    print(f"OK topology (large={len(SVG_LARGE)}, small={len(SVG_SMALL)})")

print("Updating build phase...")
update_phase(15, "build", "Build — Network Devices & Anatomy", BUILD)

# Verify
v_sql = "SELECT phase, length(content) FROM lab_phases WHERE lab_id=15 ORDER BY phase"
v_out, _, _ = run_sql(v_sql)
print(v_out)

print("DONE")
