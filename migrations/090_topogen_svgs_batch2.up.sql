-- Migration 090: canonical generated SVGs for 20 more labs (topogen batch 2)
-- Replaces svg_large with generator output for labs that passed geometric
-- QA + visual QA. Extends 089's pattern (verify_replace, byte-exact).
-- Labs 9, 25, 29 remain manual (dense congestion clusters — see qa_geometry).

UPDATE lab_topologies SET svg_large = verify_replace(svg_large,
  $md$<svg
  width="100%"
  viewBox="0 0 720 490"
  xmlns="http://www.w3.org/2000/svg"
  role="img"
  aria-label="NetBreaker Lab 2 topology: SW1 root bridge connects to SW2 and SW3 (trunk). SW2↔SW3 blocked by STP. PC1 on SW1 Et0/2. KALI attacker floods BPDU via SW3 Et0/1."
>
  <defs>
    <pattern id="grid" width="24" height="24" patternUnits="userSpaceOnUse">
      <path d="M24 0H0V24" fill="none" stroke="#1b2129" stroke-width="1" />
    </pattern>
    <filter id="glow-kali" x="-40%" y="-40%" width="180%" height="180%">
      <feGaussianBlur stdDeviation="3" result="blur" />
      <feMerge>
        <feMergeNode in="blur" />
        <feMergeNode in="SourceGraphic" />
      </feMerge>
    </filter>
  </defs>

  <rect x="0" y="0" width="720" height="490" rx="10" fill="#0b0f14" />
  <rect x="1" y="37" width="718" height="452" fill="url(#grid)" />
  <rect x="0.5" y="0.5" width="719" height="489" rx="10" fill="none" stroke="#22272e" stroke-width="1" />

  <line x1="0" y1="36" x2="720" y2="36" stroke="#22272e" stroke-width="1" />
  <circle cx="20" cy="18" r="6" fill="#ff5f56" />
  <circle cx="40" cy="18" r="6" fill="#ffbd2e" />
  <circle cx="60" cy="18" r="6" fill="#27c93f" />
  <text x="82" y="22" font-family="Courier New, monospace" font-size="12" fill="#6e7681">
    root@netbreaker:~/lab2$ topology --render
  </text>

  <line x1="310" y1="115" x2="130" y2="195" stroke="#4d5560" stroke-width="1.5" />
  <line x1="410" y1="115" x2="510" y2="195" stroke="#4d5560" stroke-width="1.5" />
  <line x1="228" y1="225" x2="572" y2="225" stroke="#e5484d" stroke-width="2" stroke-dasharray="8 5" />
  <text x="400" y="218" text-anchor="middle" font-family="Courier New, monospace" font-size="9" fill="#e5484d">✂ blocked by STP (loop-prevention)</text>
  <line x1="360" y1="115" x2="170" y2="300" stroke="#22d3ee" stroke-width="1.5" />
  <line x1="540" y1="225" x2="540" y2="310" stroke="#f85149" stroke-width="1.5" stroke-dasharray="5 3" />

  <rect x="288" y="95" width="42" height="16" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
  <text x="309" y="106" text-anchor="middle" font-family="Courier New, monospace" font-size="10" fill="#3fb950">Et0/0</text>
  <rect x="339" y="95" width="42" height="16" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
  <text x="360" y="106" text-anchor="middle" font-family="Courier New, monospace" font-size="10" fill="#3fb950">Et0/2</text>
  <rect x="390" y="95" width="42" height="16" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
  <text x="411" y="106" text-anchor="middle" font-family="Courier New, monospace" font-size="10" fill="#3fb950">Et0/1</text>

  <rect x="108" y="175" width="42" height="16" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
  <text x="129" y="186" text-anchor="middle" font-family="Courier New, monospace" font-size="10" fill="#3fb950">Et0/0</text>
  <rect x="206" y="175" width="42" height="16" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
  <text x="227" y="186" text-anchor="middle" font-family="Courier New, monospace" font-size="10" fill="#3fb950">Et0/2</text>

  <rect x="488" y="175" width="42" height="16" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
  <text x="509" y="186" text-anchor="middle" font-family="Courier New, monospace" font-size="10" fill="#3fb950">Et0/0</text>
  <rect x="550" y="175" width="42" height="16" rx="3" fill="#0b0f14" stroke="#f85149" stroke-width="1" />
  <text x="571" y="186" text-anchor="middle" font-family="Courier New, monospace" font-size="10" fill="#f85149">Et0/1</text>

  <g>
    <rect x="280" y="55" width="160" height="60" rx="6" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
    <text x="360" y="78" text-anchor="middle" font-family="Courier New, monospace" font-size="15" font-weight="700" fill="#e6edf3">SW1 👑</text>
    <text x="360" y="97" text-anchor="middle" font-family="Courier New, monospace" font-size="10" fill="#8b98a5">root bridge — l2_switch</text>
  </g>
  <g>
    <rect x="100" y="195" width="160" height="60" rx="6" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
    <text x="180" y="218" text-anchor="middle" font-family="Courier New, monospace" font-size="15" font-weight="700" fill="#e6edf3">SW2</text>
    <text x="180" y="237" text-anchor="middle" font-family="Courier New, monospace" font-size="10" fill="#8b98a5">secondary root</text>
  </g>
  <g>
    <rect x="460" y="195" width="160" height="60" rx="6" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
    <text x="540" y="218" text-anchor="middle" font-family="Courier New, monospace" font-size="15" font-weight="700" fill="#e6edf3">SW3</text>
    <text x="540" y="237" text-anchor="middle" font-family="Courier New, monospace" font-size="10" fill="#8b98a5">BPDU Guard ⚠ — l2_switch</text>
  </g>

  <circle cx="180" cy="330" r="30" fill="#131a21" stroke="#22d3ee" stroke-width="1.5" />
  <text x="180" y="335" text-anchor="middle" font-family="Courier New, monospace" font-size="13" font-weight="700" fill="#67e8f9">PC1</text>

  <g filter="url(#glow-kali)">
    <rect x="470" y="315" width="140" height="60" rx="6" fill="#1a0f11" stroke="#f85149" stroke-width="1.5" stroke-dasharray="5 3" />
  </g>
  <text x="540" y="340" text-anchor="middle" font-family="Courier New, monospace" font-size="15" font-weight="700" fill="#ff7b72">KALI</text>
  <text x="540" y="359" text-anchor="middle" font-family="Courier New, monospace" font-size="10" fill="#f85149">observer / attacker</text>

  <line x1="30" y1="405" x2="690" y2="405" stroke="#22272e" stroke-width="1" />
  <text x="30" y="424" font-family="Courier New, monospace" font-size="10" fill="#6e7681">// device_legend</text>
  <rect x="30" y="438" width="12" height="12" rx="2" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
  <text x="50" y="448" font-family="Courier New, monospace" font-size="11" fill="#8b98a5">switch</text>
  <circle cx="120" cy="444" r="6" fill="#131a21" stroke="#22d3ee" stroke-width="1.5" />
  <text x="134" y="448" font-family="Courier New, monospace" font-size="11" fill="#22d3ee">end host</text>
  <rect x="230" y="438" width="12" height="12" rx="2" fill="#131a21" stroke="#3fb950" stroke-width="1.5" />
  <text x="250" y="448" font-family="Courier New, monospace" font-size="11" fill="#3fb950">active port</text>
  <rect x="370" y="438" width="12" height="12" rx="2" fill="#1a0f11" stroke="#f85149" stroke-width="1.5" stroke-dasharray="3 2" />
  <text x="390" y="448" font-family="Courier New, monospace" font-size="11" fill="#f85149">observer / attacker</text>
  <rect x="550" y="438" width="12" height="12" rx="2" fill="none" stroke="#e5484d" stroke-width="1.5" stroke-dasharray="3 2" />
  <text x="570" y="448" font-family="Courier New, monospace" font-size="11" fill="#e5484d">blocked (STP)</text>
  <text x="30" y="475" font-family="Courier New, monospace" font-size="10" fill="#4d5560">
    build: sw1(root)·sw2·sw3+kali · pc1→sw1(et0/2) · kali→sw3(et0/1) · stp blocks sw2↔sw3
  </text>
</svg>$md$,
  $md$<svg
      width="100%"
      viewBox="0 0 720 490"
      xmlns="http://www.w3.org/2000/svg"
      role="img"
      aria-label="NetBreaker Lab 2 topology: SW1(Et0/0)→SW2(Et0/1), SW1(Et0/2)→SW3(Et0/1), SW2(Et0/2)→SW3(Et0/3), SW1(Et0/1)→PC1(eth0), SW3(Et0/2)→KALI(eth0)"
    >
      <defs>
        <pattern id="grid" width="24" height="24" patternUnits="userSpaceOnUse">
          <path d="M24 0H0V24" fill="none" stroke="#1b2129" stroke-width="1" />
        </pattern>
        <filter id="glow" x="-40%" y="-40%" width="180%" height="180%">
          <feGaussianBlur stdDeviation="3" result="blur" />
          <feMerge>
            <feMergeNode in="blur" />
            <feMergeNode in="SourceGraphic" />
          </feMerge>
        </filter>
      </defs>

      <rect x="0" y="0" width="720" height="490" rx="10" fill="#0b0f14" />
      <rect x="1" y="37" width="718" height="451" fill="url(#grid)" />
      <rect x="0.5" y="0.5" width="719" height="489" rx="10" fill="none" stroke="#22272e" stroke-width="1" />

      <line x1="0" y1="36" x2="720" y2="36" stroke="#22272e" stroke-width="1" />
      <circle cx="20" cy="18" r="6" fill="#ff5f56" />
      <circle cx="40" cy="18" r="6" fill="#ffbd2e" />
      <circle cx="60" cy="18" r="6" fill="#27c93f" />
      <text x="82" y="22" font-family="Courier New, monospace" fontSize="12" fill="#6e7681">
        root@netbreaker:~/lab2$ topology --render
      </text>
      <g data-link="SW1:Et0/0↔SW2:Et0/1">
        <line x1="321" y1="115" x2="219" y2="195" stroke="#4d5560" stroke-width="1.5"
          data-node-a="SW1" data-iface-a="Et0/0" data-node-b="SW2" data-iface-b="Et0/1" />
        <title>SW1 Et0/0 ↔ SW2 Et0/1</title>
      </g>
      <g data-link="SW1:Et0/2↔SW3:Et0/1">
        <line x1="399" y1="115" x2="501" y2="195" stroke="#4d5560" stroke-width="1.5"
          data-node-a="SW1" data-iface-a="Et0/2" data-node-b="SW3" data-iface-b="Et0/1" />
        <title>SW1 Et0/2 ↔ SW3 Et0/1</title>
      </g>
      <g data-link="SW2:Et0/2↔SW3:Et0/3">
        <line x1="250" y1="225" x2="470" y2="225" stroke="#4d5560" stroke-width="1.5"
          data-node-a="SW2" data-iface-a="Et0/2" data-node-b="SW3" data-iface-b="Et0/3" />
        <title>SW2 Et0/2 ↔ SW3 Et0/3</title>
      </g>
      <g data-link="SW1:Et0/1↔PC1:eth0">
        <line x1="338" y1="115" x2="198" y2="306" stroke="#4d5560" stroke-width="1.5"
          data-node-a="SW1" data-iface-a="Et0/1" data-node-b="PC1" data-iface-b="eth0" />
        <title>SW1 Et0/1 ↔ PC1 eth0</title>
      </g>
      <g data-link="SW3:Et0/2↔KALI:eth0">
        <line x1="540" y1="255" x2="540" y2="315" stroke="#4d5560" stroke-width="1.5"
          data-node-a="SW3" data-iface-a="Et0/2" data-node-b="KALI" data-iface-b="eth0" />
        <title>SW3 Et0/2 ↔ KALI eth0</title>
      </g>
      <g data-port="SW1" data-iface="Et0/0">
        <rect x="267" y="107" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="288" y="120" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/0</text>
        <title>SW1 Et0/0</title>
      </g>
      <g data-port="SW1" data-iface="Et0/2">
        <rect x="392" y="126" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="413" y="139" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/2</text>
        <title>SW1 Et0/2</title>
      </g>
      <g data-port="SW1" data-iface="Et0/1">
        <rect x="306" y="125" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="327" y="138" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/1</text>
        <title>SW1 Et0/1</title>
      </g>
      <g data-port="SW2" data-iface="Et0/1">
        <rect x="212" y="166" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="233" y="179" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/1</text>
        <title>SW2 Et0/1</title>
      </g>
      <g data-port="SW2" data-iface="Et0/2">
        <rect x="253" y="223" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="274" y="236" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/2</text>
        <title>SW2 Et0/2</title>
      </g>
      <g data-port="SW3" data-iface="Et0/1">
        <rect x="457" y="177" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="478" y="190" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/1</text>
        <title>SW3 Et0/1</title>
      </g>
      <g data-port="SW3" data-iface="Et0/3">
        <rect x="425" y="223" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="446" y="236" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/3</text>
        <title>SW3 Et0/3</title>
      </g>
      <g data-port="SW3" data-iface="Et0/2">
        <rect x="512" y="256" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="533" y="269" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/2</text>
        <title>SW3 Et0/2</title>
      </g>
      <g data-port="PC1" data-iface="eth0">
        <rect x="185" y="273" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="206" y="286" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">eth0</text>
        <title>PC1 eth0</title>
      </g>
      <g data-port="KALI" data-iface="eth0">
        <rect x="512" y="296" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="533" y="309" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">eth0</text>
        <title>KALI eth0</title>
      </g>
      <g data-node="SW1" data-role="core">
        <rect x="290" y="55" width="140" height="60" rx="6" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
        <text x="360" y="91" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#e6edf3">SW1</text>
        <text x="360" y="109" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">l2 switch</text>
        <title>SW1</title>
      </g>
      <g data-node="SW2" data-role="core">
        <rect x="110" y="195" width="140" height="60" rx="6" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
        <text x="180" y="231" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#e6edf3">SW2</text>
        <text x="180" y="249" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">l2 switch</text>
        <title>SW2</title>
      </g>
      <g data-node="SW3" data-role="core">
        <rect x="470" y="195" width="140" height="60" rx="6" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
        <text x="540" y="231" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#e6edf3">SW3</text>
        <text x="540" y="249" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">l2 switch</text>
        <title>SW3</title>
      </g>
      <g data-node="PC1" data-role="host">
        <circle cx="180" cy="330" r="30" fill="#131a21" stroke="#22d3ee" stroke-width="1.5" />
        <text x="180" y="334" text-anchor="middle" font-family="Courier New, monospace" fontSize="13" fontWeight="700" fill="#67e8f9">PC1</text>
        <text x="180" y="348" text-anchor="middle" font-family="Courier New, monospace" fontSize="9" fill="#22d3ee">end host</text>
        <title>PC1</title>
      </g>
      <g data-node="KALI" data-role="attacker">
        <g filter="url(#glow)">
          <rect x="470" y="315" width="140" height="60" rx="6" fill="#1a0f11" stroke="#f85149" stroke-width="1.5" stroke-dasharray="5 3" />
        </g>
        <text x="540" y="351" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#ff7b72">KALI</text>
        <text x="540" y="369" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#f85149">attacker / observer</text>
        <title>KALI</title>
      </g>
      <line x1="30" y1="405" x2="690" y2="405" stroke="#22272e" stroke-width="1" />
      <text x="30" y="424" font-family="Courier New, monospace" fontSize="10" fill="#6e7681">// device_legend</text>

      <rect x="30" y="438" width="12" height="12" rx="2" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
      <text x="50" y="448" font-family="Courier New, monospace" fontSize="11" fill="#e6edf3">switch / router / firewall</text>

      <rect x="230" y="438" width="12" height="12" rx="2" fill="#131a21" stroke="#d29922" stroke-width="1.5" />
      <text x="250" y="448" font-family="Courier New, monospace" fontSize="11" fill="#d29922">hub — single collision domain</text>

      <circle cx="486" cy="444" r="6" fill="#131a21" stroke="#22d3ee" stroke-width="1.5" />
      <text x="500" y="448" font-family="Courier New, monospace" fontSize="11" fill="#67e8f9">end host</text>

      <rect x="580" y="438" width="12" height="12" rx="2" fill="#1a0f11" stroke="#f85149" stroke-width="1.5" stroke-dasharray="3 2" />
      <text x="600" y="448" font-family="Courier New, monospace" fontSize="11" fill="#ff7b72">observer / attacker</text>

      <text x="30" y="475" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">
        initial_build: SW1(Et0/0)→SW2(Et0/1) · SW1(Et0/2)→SW3(Et0/1) · SW2(Et0/2)→SW3(Et0/3) · SW1(Et0/1)→PC1(eth0) · SW3(E...
      </text>
    </svg>
$md$)
WHERE lab_id = 2;

UPDATE lab_topologies SET svg_large = verify_replace(svg_large,
  $md$<svg viewBox="0 0 720 250" role="img" aria-label="Kali outside, a switch, a router enforcing an inbound ACL, and an internal server behind it">
       <rect x="40" y="95" width="130" height="56" rx="8" fill="#fef2f2" stroke="#e5484d" stroke-width="1.5"/>
       <text x="105" y="117" text-anchor="middle" font-family="monospace" font-size="13" font-weight="700" fill="#e5484d">KALI</text>
       <text x="105" y="133" text-anchor="middle" font-family="monospace" font-size="9.5" fill="#e5484d">outside · 203.0.113.66</text>
       <rect x="210" y="95" width="120" height="56" rx="8" fill="#fff" stroke="#6b7480" stroke-width="1.5"/>
       <text x="270" y="117" text-anchor="middle" font-family="monospace" font-size="13" font-weight="700" fill="#0f172a">SW1</text>
       <text x="270" y="133" text-anchor="middle" font-family="monospace" font-size="9.5" fill="#64748b">IOU L2 · VLAN 20</text>
       <rect x="370" y="90" width="140" height="66" rx="8" fill="#eff6ff" stroke="#2563eb" stroke-width="2"/>
       <text x="440" y="114" text-anchor="middle" font-family="monospace" font-size="14" font-weight="700" fill="#2563eb">R1</text>
       <text x="440" y="132" text-anchor="middle" font-family="monospace" font-size="9" fill="#64748b">ACL OUTSIDE-IN (in)</text>
       <text x="440" y="146" text-anchor="middle" font-family="monospace" font-size="9" fill="#64748b">c3725</text>
       <rect x="550" y="95" width="130" height="56" rx="8" fill="#fff" stroke="#2563eb" stroke-width="1.5"/>
       <text x="615" y="117" text-anchor="middle" font-family="monospace" font-size="13" font-weight="700" fill="#0f172a">SERVER</text>
       <text x="615" y="133" text-anchor="middle" font-family="monospace" font-size="9.5" fill="#64748b">10.0.20.10 · :80</text>
       <line x1="170" y1="123" x2="210" y2="123" stroke="#e5484d" stroke-width="2" stroke-dasharray="6 4"/>
       <text x="190" y="114" text-anchor="middle" font-family="monospace" font-size="9" fill="#64748b">Et0/1</text>
       <line x1="330" y1="123" x2="370" y2="123" stroke="#6b7480" stroke-width="2"/>
       <text x="350" y="114" text-anchor="middle" font-family="monospace" font-size="9" fill="#64748b">Et0/0</text>
       <line x1="510" y1="123" x2="550" y2="123" stroke="#2563eb" stroke-width="2"/>
       <text x="530" y="114" text-anchor="middle" font-family="monospace" font-size="9" fill="#64748b">f0/1 · inside</text>
       <text x="360" y="230" text-anchor="middle" font-family="monospace" font-size="10" fill="#94a3b8">the inbound ACL is meant to block outside→inside except "replies" — that exception is the hole</text>
     </svg>$md$,
  $md$<svg
      width="100%"
      viewBox="0 0 720 490"
      xmlns="http://www.w3.org/2000/svg"
      role="img"
      aria-label="NetBreaker Lab 6 topology: R1(Fa0/0)→SW1(Et0/0), KALI(eth0)→SW1(Et0/1), R1(Fa0/1)→SERVER(eth0)"
    >
      <defs>
        <pattern id="grid" width="24" height="24" patternUnits="userSpaceOnUse">
          <path d="M24 0H0V24" fill="none" stroke="#1b2129" stroke-width="1" />
        </pattern>
        <filter id="glow" x="-40%" y="-40%" width="180%" height="180%">
          <feGaussianBlur stdDeviation="3" result="blur" />
          <feMerge>
            <feMergeNode in="blur" />
            <feMergeNode in="SourceGraphic" />
          </feMerge>
        </filter>
      </defs>

      <rect x="0" y="0" width="720" height="490" rx="10" fill="#0b0f14" />
      <rect x="1" y="37" width="718" height="451" fill="url(#grid)" />
      <rect x="0.5" y="0.5" width="719" height="489" rx="10" fill="none" stroke="#22272e" stroke-width="1" />

      <line x1="0" y1="36" x2="720" y2="36" stroke="#22272e" stroke-width="1" />
      <circle cx="20" cy="18" r="6" fill="#ff5f56" />
      <circle cx="40" cy="18" r="6" fill="#ffbd2e" />
      <circle cx="60" cy="18" r="6" fill="#27c93f" />
      <text x="82" y="22" font-family="Courier New, monospace" fontSize="12" fill="#6e7681">
        root@netbreaker:~/lab6$ topology --render
      </text>
      <g data-link="R1:Fa0/0↔SW1:Et0/0">
        <line x1="370" y1="123" x2="340" y2="123" stroke="#4d5560" stroke-width="1.5"
          data-node-a="R1" data-iface-a="Fa0/0" data-node-b="SW1" data-iface-b="Et0/0" />
        <title>R1 Fa0/0 ↔ SW1 Et0/0</title>
      </g>
      <g data-link="KALI:eth0↔SW1:Et0/1">
        <line x1="175" y1="123" x2="200" y2="123" stroke="#4d5560" stroke-width="1.5"
          data-node-a="KALI" data-iface-a="eth0" data-node-b="SW1" data-iface-b="Et0/1" />
        <title>KALI eth0 ↔ SW1 Et0/1</title>
      </g>
      <g data-link="R1:Fa0/1↔SERVER:eth0">
        <line x1="510" y1="123" x2="585" y2="123" stroke="#4d5560" stroke-width="1.5"
          data-node-a="R1" data-iface-a="Fa0/1" data-node-b="SERVER" data-iface-b="eth0" />
        <title>R1 Fa0/1 ↔ SERVER eth0</title>
      </g>
      <g data-port="R1" data-iface="Fa0/0">
        <rect x="312" y="107" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="333" y="120" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Fa0/0</text>
        <title>R1 Fa0/0</title>
      </g>
      <g data-port="R1" data-iface="Fa0/1">
        <rect x="500" y="121" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="521" y="134" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Fa0/1</text>
        <title>R1 Fa0/1</title>
      </g>
      <g data-port="SW1" data-iface="Et0/0">
        <rect x="356" y="107" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="377" y="120" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/0</text>
        <title>SW1 Et0/0</title>
      </g>
      <g data-port="SW1" data-iface="Et0/1">
        <rect x="143" y="121" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="164" y="134" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/1</text>
        <title>SW1 Et0/1</title>
      </g>
      <g data-port="SERVER" data-iface="eth0">
        <rect x="553" y="121" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="574" y="134" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">eth0</text>
        <title>SERVER eth0</title>
      </g>
      <g data-port="KALI" data-iface="eth0">
        <rect x="190" y="121" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="211" y="134" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">eth0</text>
        <title>KALI eth0</title>
      </g>
      <g data-node="R1" data-role="core">
        <rect x="370" y="93" width="140" height="60" rx="6" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
        <text x="440" y="129" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#e6edf3">R1</text>
        <text x="440" y="147" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">router</text>
        <title>R1</title>
      </g>
      <g data-node="SW1" data-role="core">
        <rect x="200" y="93" width="140" height="60" rx="6" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
        <text x="270" y="129" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#e6edf3">SW1</text>
        <text x="270" y="147" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">l2 switch</text>
        <title>SW1</title>
      </g>
      <g data-node="SERVER" data-role="host">
        <circle cx="615" cy="123" r="30" fill="#131a21" stroke="#22d3ee" stroke-width="1.5" />
        <text x="615" y="127" text-anchor="middle" font-family="Courier New, monospace" fontSize="13" fontWeight="700" fill="#67e8f9">SERVER</text>
        <text x="615" y="141" text-anchor="middle" font-family="Courier New, monospace" fontSize="9" fill="#22d3ee">end host</text>
        <title>SERVER</title>
      </g>
      <g data-node="KALI" data-role="attacker">
        <g filter="url(#glow)">
          <rect x="35" y="93" width="140" height="60" rx="6" fill="#1a0f11" stroke="#f85149" stroke-width="1.5" stroke-dasharray="5 3" />
        </g>
        <text x="105" y="129" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#ff7b72">KALI</text>
        <text x="105" y="147" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#f85149">attacker / observer</text>
        <title>KALI</title>
      </g>
      <line x1="30" y1="405" x2="690" y2="405" stroke="#22272e" stroke-width="1" />
      <text x="30" y="424" font-family="Courier New, monospace" fontSize="10" fill="#6e7681">// device_legend</text>

      <rect x="30" y="438" width="12" height="12" rx="2" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
      <text x="50" y="448" font-family="Courier New, monospace" fontSize="11" fill="#e6edf3">switch / router / firewall</text>

      <rect x="230" y="438" width="12" height="12" rx="2" fill="#131a21" stroke="#d29922" stroke-width="1.5" />
      <text x="250" y="448" font-family="Courier New, monospace" fontSize="11" fill="#d29922">hub — single collision domain</text>

      <circle cx="486" cy="444" r="6" fill="#131a21" stroke="#22d3ee" stroke-width="1.5" />
      <text x="500" y="448" font-family="Courier New, monospace" fontSize="11" fill="#67e8f9">end host</text>

      <rect x="580" y="438" width="12" height="12" rx="2" fill="#1a0f11" stroke="#f85149" stroke-width="1.5" stroke-dasharray="3 2" />
      <text x="600" y="448" font-family="Courier New, monospace" fontSize="11" fill="#ff7b72">observer / attacker</text>

      <text x="30" y="475" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">
        initial_build: R1(Fa0/0)→SW1(Et0/0) · KALI(eth0)→SW1(Et0/1) · R1(Fa0/1)→SERVER(eth0)
      </text>
    </svg>
$md$)
WHERE lab_id = 6;

UPDATE lab_topologies SET svg_large = verify_replace(svg_large,
  $md$<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 600 280" font-family="ui-monospace,monospace">
  <rect x="40" y="20" width="180" height="54" rx="10" fill="#fff" stroke="#14161a" stroke-width="2"/>
  <text x="130" y="46" text-anchor="middle" font-size="14" fill="#14161a" font-weight="700">R1</text>
  <text x="130" y="64" text-anchor="middle" font-size="10" fill="#6b7480">CDP: enabled · LLDP: enabled</text>
  <rect x="190" y="120" width="220" height="46" rx="10" fill="#fff" stroke="#6b7480" stroke-width="2"/>
  <text x="300" y="144" text-anchor="middle" font-size="14" fill="#14161a" font-weight="600">SW1</text>
  <text x="300" y="160" text-anchor="middle" font-size="10" fill="#6b7480">Trunk to R1 · Access to KALI</text>
  <line x1="170" y1="74" x2="250" y2="120" stroke="#6b7480" stroke-width="2.5"/>
  <rect x="380" y="20" width="200" height="60" rx="10" fill="#fff" stroke="#e5484d" stroke-width="2"/>
  <text x="480" y="46" text-anchor="middle" font-size="14" fill="#e5484d" font-weight="700">KALI</text>
  <text x="480" y="64" text-anchor="middle" font-size="10" fill="#6b7480">CDP: IOSvL2, vlan 1, VTP lab.local</text>
  <line x1="410" y1="143" x2="380" y2="50" stroke="#e5484d" stroke-width="2.5" stroke-dasharray="6 5"/>
  <text x="420" y="130" font-size="10" fill="#e5484d">CDP multicast every 60s</text>
</svg>$md$,
  $md$<svg
      width="100%"
      viewBox="0 0 720 490"
      xmlns="http://www.w3.org/2000/svg"
      role="img"
      aria-label="NetBreaker Lab 7 topology: R1(Fa0/0)→SW1(Et0/1), KALI(eth0)→SW1(Et0/2)"
    >
      <defs>
        <pattern id="grid" width="24" height="24" patternUnits="userSpaceOnUse">
          <path d="M24 0H0V24" fill="none" stroke="#1b2129" stroke-width="1" />
        </pattern>
        <filter id="glow" x="-40%" y="-40%" width="180%" height="180%">
          <feGaussianBlur stdDeviation="3" result="blur" />
          <feMerge>
            <feMergeNode in="blur" />
            <feMergeNode in="SourceGraphic" />
          </feMerge>
        </filter>
      </defs>

      <rect x="0" y="0" width="720" height="490" rx="10" fill="#0b0f14" />
      <rect x="1" y="37" width="718" height="451" fill="url(#grid)" />
      <rect x="0.5" y="0.5" width="719" height="489" rx="10" fill="none" stroke="#22272e" stroke-width="1" />

      <line x1="0" y1="36" x2="720" y2="36" stroke="#22272e" stroke-width="1" />
      <circle cx="20" cy="18" r="6" fill="#ff5f56" />
      <circle cx="40" cy="18" r="6" fill="#ffbd2e" />
      <circle cx="60" cy="18" r="6" fill="#27c93f" />
      <text x="82" y="22" font-family="Courier New, monospace" fontSize="12" fill="#6e7681">
        root@netbreaker:~/lab7$ topology --render
      </text>
      <g data-link="R1:Fa0/0↔SW1:Et0/1">
        <line x1="183" y1="115" x2="247" y2="151" stroke="#4d5560" stroke-width="1.5"
          data-node-a="R1" data-iface-a="Fa0/0" data-node-b="SW1" data-iface-b="Et0/1" />
        <title>R1 Fa0/0 ↔ SW1 Et0/1</title>
      </g>
      <g data-link="KALI:eth0↔SW1:Et0/2">
        <line x1="422" y1="118" x2="358" y2="151" stroke="#4d5560" stroke-width="1.5"
          data-node-a="KALI" data-iface-a="eth0" data-node-b="SW1" data-iface-b="Et0/2" />
        <title>KALI eth0 ↔ SW1 Et0/2</title>
      </g>
      <g data-port="R1" data-iface="Fa0/0">
        <rect x="172" y="120" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="193" y="133" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Fa0/0</text>
        <title>R1 Fa0/0</title>
      </g>
      <g data-port="SW1" data-iface="Et0/1">
        <rect x="209" y="141" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="230" y="154" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/1</text>
        <title>SW1 Et0/1</title>
      </g>
      <g data-port="SW1" data-iface="Et0/2">
        <rect x="347" y="129" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="368" y="142" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/2</text>
        <title>SW1 Et0/2</title>
      </g>
      <g data-port="KALI" data-iface="eth0">
        <rect x="384" y="110" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="405" y="123" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">eth0</text>
        <title>KALI eth0</title>
      </g>
      <g data-node="R1" data-role="core">
        <rect x="60" y="55" width="140" height="60" rx="6" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
        <text x="130" y="91" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#e6edf3">R1</text>
        <text x="130" y="109" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">router</text>
        <title>R1</title>
      </g>
      <g data-node="SW1" data-role="core">
        <rect x="230" y="151" width="140" height="60" rx="6" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
        <text x="300" y="187" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#e6edf3">SW1</text>
        <text x="300" y="205" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">l2 switch</text>
        <title>SW1</title>
      </g>
      <g data-node="KALI" data-role="attacker">
        <g filter="url(#glow)">
          <rect x="410" y="58" width="140" height="60" rx="6" fill="#1a0f11" stroke="#f85149" stroke-width="1.5" stroke-dasharray="5 3" />
        </g>
        <text x="480" y="94" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#ff7b72">KALI</text>
        <text x="480" y="112" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#f85149">attacker / observer</text>
        <title>KALI</title>
      </g>
      <line x1="30" y1="405" x2="690" y2="405" stroke="#22272e" stroke-width="1" />
      <text x="30" y="424" font-family="Courier New, monospace" fontSize="10" fill="#6e7681">// device_legend</text>

      <rect x="30" y="438" width="12" height="12" rx="2" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
      <text x="50" y="448" font-family="Courier New, monospace" fontSize="11" fill="#e6edf3">switch / router / firewall</text>

      <rect x="230" y="438" width="12" height="12" rx="2" fill="#131a21" stroke="#d29922" stroke-width="1.5" />
      <text x="250" y="448" font-family="Courier New, monospace" fontSize="11" fill="#d29922">hub — single collision domain</text>

      <circle cx="486" cy="444" r="6" fill="#131a21" stroke="#22d3ee" stroke-width="1.5" />
      <text x="500" y="448" font-family="Courier New, monospace" fontSize="11" fill="#67e8f9">end host</text>

      <rect x="580" y="438" width="12" height="12" rx="2" fill="#1a0f11" stroke="#f85149" stroke-width="1.5" stroke-dasharray="3 2" />
      <text x="600" y="448" font-family="Courier New, monospace" fontSize="11" fill="#ff7b72">observer / attacker</text>

      <text x="30" y="475" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">
        initial_build: R1(Fa0/0)→SW1(Et0/1) · KALI(eth0)→SW1(Et0/2)
      </text>
    </svg>
$md$)
WHERE lab_id = 7;

UPDATE lab_topologies SET svg_large = verify_replace(svg_large,
  $md$<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 600 300" font-family="ui-monospace,monospace">
  <rect x="200" y="14" width="200" height="54" rx="10" fill="#fff" stroke="#14161a" stroke-width="2"/>
  <text x="300" y="40" text-anchor="middle" font-size="16" fill="#14161a" font-weight="700">R1</text>
  <text x="300" y="56" text-anchor="middle" font-size="11" fill="#6b7480">Telnet 🠕 cleartext · SSH 🠕 encrypted</text>
  <line x1="300" y1="68" x2="300" y2="100" stroke="#6b7480" stroke-width="2"/>
  <rect x="200" y="100" width="200" height="46" rx="10" fill="#fff" stroke="#6b7480" stroke-width="2"/>
  <text x="300" y="126" text-anchor="middle" font-size="14" fill="#14161a" font-weight="600">SW1 (transparent)</text>
  <line x1="300" y1="146" x2="300" y2="188" stroke="#6b7480" stroke-width="2"/>
  <rect x="140" y="188" width="320" height="70" rx="10" fill="#fff" stroke="#e5484d" stroke-width="2"/>
  <text x="300" y="216" text-anchor="middle" font-size="15" fill="#e5484d" font-weight="700">KALI · Wireshark</text>
  <text x="300" y="234" text-anchor="middle" font-size="11" fill="#6b7480">Telnet:  "admin:cisco123" 🠔 cleartext</text>
  <text x="300" y="250" text-anchor="middle" font-size="11" fill="#6b7480">SSH:     "1a3f8c2b...e7d0" 🠔 encrypted</text>
</svg>$md$,
  $md$<svg
      width="100%"
      viewBox="0 0 720 490"
      xmlns="http://www.w3.org/2000/svg"
      role="img"
      aria-label="NetBreaker Lab 11 topology: R1(Fa0/0)→SW1(Et0/1), KALI(eth0)→SW1(Et0/2)"
    >
      <defs>
        <pattern id="grid" width="24" height="24" patternUnits="userSpaceOnUse">
          <path d="M24 0H0V24" fill="none" stroke="#1b2129" stroke-width="1" />
        </pattern>
        <filter id="glow" x="-40%" y="-40%" width="180%" height="180%">
          <feGaussianBlur stdDeviation="3" result="blur" />
          <feMerge>
            <feMergeNode in="blur" />
            <feMergeNode in="SourceGraphic" />
          </feMerge>
        </filter>
      </defs>

      <rect x="0" y="0" width="720" height="490" rx="10" fill="#0b0f14" />
      <rect x="1" y="37" width="718" height="451" fill="url(#grid)" />
      <rect x="0.5" y="0.5" width="719" height="489" rx="10" fill="none" stroke="#22272e" stroke-width="1" />

      <line x1="0" y1="36" x2="720" y2="36" stroke="#22272e" stroke-width="1" />
      <circle cx="20" cy="18" r="6" fill="#ff5f56" />
      <circle cx="40" cy="18" r="6" fill="#ffbd2e" />
      <circle cx="60" cy="18" r="6" fill="#27c93f" />
      <text x="82" y="22" font-family="Courier New, monospace" fontSize="12" fill="#6e7681">
        root@netbreaker:~/lab11$ topology --render
      </text>
      <g data-link="R1:Fa0/0↔SW1:Et0/1">
        <line x1="360" y1="110" x2="410" y2="110" stroke="#4d5560" stroke-width="1.5"
          data-node-a="R1" data-iface-a="Fa0/0" data-node-b="SW1" data-iface-b="Et0/1" />
        <title>R1 Fa0/0 ↔ SW1 Et0/1</title>
      </g>
      <g data-link="KALI:eth0↔SW1:Et0/2">
        <line x1="409" y1="200" x2="456" y2="140" stroke="#4d5560" stroke-width="1.5"
          data-node-a="KALI" data-iface-a="eth0" data-node-b="SW1" data-iface-b="Et0/2" />
        <title>KALI eth0 ↔ SW1 Et0/2</title>
      </g>
      <g data-port="R1" data-iface="Fa0/0">
        <rect x="342" y="108" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="363" y="121" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Fa0/0</text>
        <title>R1 Fa0/0</title>
      </g>
      <g data-port="SW1" data-iface="Et0/1">
        <rect x="386" y="108" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="407" y="121" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/1</text>
        <title>SW1 Et0/1</title>
      </g>
      <g data-port="SW1" data-iface="Et0/2">
        <rect x="426" y="154" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="447" y="167" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/2</text>
        <title>SW1 Et0/2</title>
      </g>
      <g data-port="KALI" data-iface="eth0">
        <rect x="408" y="177" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="429" y="190" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">eth0</text>
        <title>KALI eth0</title>
      </g>
      <g data-node="R1" data-role="core">
        <rect x="220" y="80" width="140" height="60" rx="6" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
        <text x="290" y="116" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#e6edf3">R1</text>
        <text x="290" y="134" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">router</text>
        <title>R1</title>
      </g>
      <g data-node="SW1" data-role="core">
        <rect x="410" y="80" width="140" height="60" rx="6" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
        <text x="480" y="116" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#e6edf3">SW1</text>
        <text x="480" y="134" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">l2 switch</text>
        <title>SW1</title>
      </g>
      <g data-node="KALI" data-role="attacker">
        <g filter="url(#glow)">
          <rect x="315" y="200" width="140" height="60" rx="6" fill="#1a0f11" stroke="#f85149" stroke-width="1.5" stroke-dasharray="5 3" />
        </g>
        <text x="385" y="236" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#ff7b72">KALI</text>
        <text x="385" y="254" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#f85149">attacker / observer</text>
        <title>KALI</title>
      </g>
      <line x1="30" y1="405" x2="690" y2="405" stroke="#22272e" stroke-width="1" />
      <text x="30" y="424" font-family="Courier New, monospace" fontSize="10" fill="#6e7681">// device_legend</text>

      <rect x="30" y="438" width="12" height="12" rx="2" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
      <text x="50" y="448" font-family="Courier New, monospace" fontSize="11" fill="#e6edf3">switch / router / firewall</text>

      <rect x="230" y="438" width="12" height="12" rx="2" fill="#131a21" stroke="#d29922" stroke-width="1.5" />
      <text x="250" y="448" font-family="Courier New, monospace" fontSize="11" fill="#d29922">hub — single collision domain</text>

      <circle cx="486" cy="444" r="6" fill="#131a21" stroke="#22d3ee" stroke-width="1.5" />
      <text x="500" y="448" font-family="Courier New, monospace" fontSize="11" fill="#67e8f9">end host</text>

      <rect x="580" y="438" width="12" height="12" rx="2" fill="#1a0f11" stroke="#f85149" stroke-width="1.5" stroke-dasharray="3 2" />
      <text x="600" y="448" font-family="Courier New, monospace" fontSize="11" fill="#ff7b72">observer / attacker</text>

      <text x="30" y="475" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">
        initial_build: R1(Fa0/0)→SW1(Et0/1) · KALI(eth0)→SW1(Et0/2)
      </text>
    </svg>
$md$)
WHERE lab_id = 11;

UPDATE lab_topologies SET svg_large = verify_replace(svg_large,
  $md$<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 700 380" font-family="ui-monospace,monospace">
  <rect x="230" y="10" width="240" height="50" rx="10" fill="#fff" stroke="#6b7480" stroke-width="2"/>
  <text x="350" y="36" text-anchor="middle" font-size="14" fill="#14161a" font-weight="600">SW1 (wired backbone)</text>
  <line x1="140" y1="60" x2="260" y2="140" stroke="#2563eb" stroke-width="2"/>
  <line x1="560" y1="60" x2="440" y2="140" stroke="#e5484d" stroke-width="2" stroke-dasharray="6 5"/>
  <rect x="220" y="168" width="260" height="50" rx="10" fill="#fff" stroke="#2563eb" stroke-width="2"/>
  <text x="350" y="196" text-anchor="middle" font-size="14" fill="#2563eb" font-weight="700">AP1 · legit NetBreaker-WiFi</text>
  <text x="350" y="212" text-anchor="middle" font-size="10" fill="#6b7480">BSSID: AA:BB:CC:11:22:33 · ch 6 · WPA2</text>
  <rect x="40" y="250" width="180" height="54" rx="10" fill="#fff" stroke="#2563eb" stroke-width="2"/>
  <text x="130" y="276" text-anchor="middle" font-size="14" fill="#2563eb" font-weight="600">PC1 (client)</text>
  <text x="130" y="294" text-anchor="middle" font-size="10" fill="#6b7480">connected to NetBreaker-WiFi</text>
  <rect x="480" y="250" width="180" height="60" rx="10" fill="#fff" stroke="#e5484d" stroke-width="2"/>
  <text x="570" y="276" text-anchor="middle" font-size="14" fill="#e5484d" font-weight="700">KALI (rogue AP)</text>
  <text x="570" y="294" text-anchor="middle" font-size="10" fill="#6b7480">hostapd · SSID: NetBreaker-WiFi</text>
  <line x1="130" y1="250" x2="300" y2="218" stroke="#2563eb" stroke-width="2"/>
  <line x1="480" y1="280" x2="400" y2="218" stroke="#e5484d" stroke-width="2" stroke-dasharray="6 5"/>
  <text x="570" y="230" font-size="11" fill="#e5484d">↑ deauth → client roams here</text>
</svg>$md$,
  $md$<svg
      width="100%"
      viewBox="0 0 720 490"
      xmlns="http://www.w3.org/2000/svg"
      role="img"
      aria-label="NetBreaker Lab 13 topology: R1(Fa0/0)→SW1(Et0/0), AP1(Et0/0)→SW1(Et0/1), PC1(eth0)→SW1(Et0/2), KALI(eth0)→SW1(Et0/3)"
    >
      <defs>
        <pattern id="grid" width="24" height="24" patternUnits="userSpaceOnUse">
          <path d="M24 0H0V24" fill="none" stroke="#1b2129" stroke-width="1" />
        </pattern>
        <filter id="glow" x="-40%" y="-40%" width="180%" height="180%">
          <feGaussianBlur stdDeviation="3" result="blur" />
          <feMerge>
            <feMergeNode in="blur" />
            <feMergeNode in="SourceGraphic" />
          </feMerge>
        </filter>
      </defs>

      <rect x="0" y="0" width="720" height="490" rx="10" fill="#0b0f14" />
      <rect x="1" y="37" width="718" height="451" fill="url(#grid)" />
      <rect x="0.5" y="0.5" width="719" height="489" rx="10" fill="none" stroke="#22272e" stroke-width="1" />

      <line x1="0" y1="36" x2="720" y2="36" stroke="#22272e" stroke-width="1" />
      <circle cx="20" cy="18" r="6" fill="#ff5f56" />
      <circle cx="40" cy="18" r="6" fill="#ffbd2e" />
      <circle cx="60" cy="18" r="6" fill="#27c93f" />
      <text x="82" y="22" font-family="Courier New, monospace" fontSize="12" fill="#6e7681">
        root@netbreaker:~/lab13$ topology --render
      </text>
      <g data-link="R1:Fa0/0↔SW1:Et0/0">
        <line x1="371" y1="130" x2="364" y2="115" stroke="#4d5560" stroke-width="1.5"
          data-node-a="R1" data-iface-a="Fa0/0" data-node-b="SW1" data-iface-b="Et0/0" />
        <title>R1 Fa0/0 ↔ SW1 Et0/0</title>
      </g>
      <g data-link="AP1:Et0/0↔SW1:Et0/1">
        <line x1="350" y1="213" x2="350" y2="115" stroke="#4d5560" stroke-width="1.5"
          data-node-a="AP1" data-iface-a="Et0/0" data-node-b="SW1" data-iface-b="Et0/1" />
        <title>AP1 Et0/0 ↔ SW1 Et0/1</title>
      </g>
      <g data-link="PC1:eth0↔SW1:Et0/2">
        <line x1="150" y1="305" x2="323" y2="115" stroke="#4d5560" stroke-width="1.5"
          data-node-a="PC1" data-iface-a="eth0" data-node-b="SW1" data-iface-b="Et0/2" />
        <title>PC1 eth0 ↔ SW1 Et0/2</title>
      </g>
      <g data-link="KALI:eth0↔SW1:Et0/3">
        <line x1="543" y1="300" x2="377" y2="115" stroke="#4d5560" stroke-width="1.5"
          data-node-a="KALI" data-iface-a="eth0" data-node-b="SW1" data-iface-b="Et0/3" />
        <title>KALI eth0 ↔ SW1 Et0/3</title>
      </g>
      <g data-port="R1" data-iface="Fa0/0">
        <rect x="345" y="96" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="366" y="109" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Fa0/0</text>
        <title>R1 Fa0/0</title>
      </g>
      <g data-port="SW1" data-iface="Et0/0">
        <rect x="371" y="135" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="392" y="148" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/0</text>
        <title>SW1 Et0/0</title>
      </g>
      <g data-port="SW1" data-iface="Et0/1">
        <rect x="320" y="133" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="341" y="146" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/1</text>
        <title>SW1 Et0/1</title>
      </g>
      <g data-port="SW1" data-iface="Et0/2">
        <rect x="278" y="126" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="299" y="139" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/2</text>
        <title>SW1 Et0/2</title>
      </g>
      <g data-port="SW1" data-iface="Et0/3">
        <rect x="388" y="112" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="409" y="125" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/3</text>
        <title>SW1 Et0/3</title>
      </g>
      <g data-port="AP1" data-iface="Et0/0">
        <rect x="336" y="180" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="357" y="193" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/0</text>
        <title>AP1 Et0/0</title>
      </g>
      <g data-port="PC1" data-iface="eth0">
        <rect x="151" y="283" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="172" y="296" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">eth0</text>
        <title>PC1 eth0</title>
      </g>
      <g data-port="KALI" data-iface="eth0">
        <rect x="511" y="268" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="532" y="281" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">eth0</text>
        <title>KALI eth0</title>
      </g>
      <g data-node="R1" data-role="core">
        <rect x="315" y="130" width="140" height="60" rx="6" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
        <text x="385" y="166" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#e6edf3">R1</text>
        <text x="385" y="184" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">router</text>
        <title>R1</title>
      </g>
      <g data-node="SW1" data-role="core">
        <rect x="280" y="55" width="140" height="60" rx="6" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
        <text x="350" y="91" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#e6edf3">SW1</text>
        <text x="350" y="109" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">l2 switch</text>
        <title>SW1</title>
      </g>
      <g data-node="AP1" data-role="core">
        <rect x="280" y="213" width="140" height="60" rx="6" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
        <text x="350" y="249" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#e6edf3">AP1</text>
        <text x="350" y="267" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">access point</text>
        <title>AP1</title>
      </g>
      <g data-node="PC1" data-role="host">
        <circle cx="130" cy="327" r="30" fill="#131a21" stroke="#22d3ee" stroke-width="1.5" />
        <text x="130" y="331" text-anchor="middle" font-family="Courier New, monospace" fontSize="13" fontWeight="700" fill="#67e8f9">PC1</text>
        <text x="130" y="345" text-anchor="middle" font-family="Courier New, monospace" fontSize="9" fill="#22d3ee">end host</text>
        <title>PC1</title>
      </g>
      <g data-node="KALI" data-role="attacker">
        <g filter="url(#glow)">
          <rect x="500" y="300" width="140" height="60" rx="6" fill="#1a0f11" stroke="#f85149" stroke-width="1.5" stroke-dasharray="5 3" />
        </g>
        <text x="570" y="336" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#ff7b72">KALI</text>
        <text x="570" y="354" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#f85149">attacker / observer</text>
        <title>KALI</title>
      </g>
      <line x1="30" y1="405" x2="690" y2="405" stroke="#22272e" stroke-width="1" />
      <text x="30" y="424" font-family="Courier New, monospace" fontSize="10" fill="#6e7681">// device_legend</text>

      <rect x="30" y="438" width="12" height="12" rx="2" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
      <text x="50" y="448" font-family="Courier New, monospace" fontSize="11" fill="#e6edf3">switch / router / firewall</text>

      <rect x="230" y="438" width="12" height="12" rx="2" fill="#131a21" stroke="#d29922" stroke-width="1.5" />
      <text x="250" y="448" font-family="Courier New, monospace" fontSize="11" fill="#d29922">hub — single collision domain</text>

      <circle cx="486" cy="444" r="6" fill="#131a21" stroke="#22d3ee" stroke-width="1.5" />
      <text x="500" y="448" font-family="Courier New, monospace" fontSize="11" fill="#67e8f9">end host</text>

      <rect x="580" y="438" width="12" height="12" rx="2" fill="#1a0f11" stroke="#f85149" stroke-width="1.5" stroke-dasharray="3 2" />
      <text x="600" y="448" font-family="Courier New, monospace" fontSize="11" fill="#ff7b72">observer / attacker</text>

      <text x="30" y="475" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">
        initial_build: R1(Fa0/0)→SW1(Et0/0) · AP1(Et0/0)→SW1(Et0/1) · PC1(eth0)→SW1(Et0/2) · KALI(eth0)→SW1(Et0/3)
      </text>
    </svg>
$md$)
WHERE lab_id = 13;

UPDATE lab_topologies SET svg_large = verify_replace(svg_large,
  $md$<svg
      width="100%"
      viewBox="0 0 720 490"
      xmlns="http://www.w3.org/2000/svg"
      role="img"
      aria-label="NetBreaker Lab 15 topology: SW1 switch routes to H1 hub (Et0/0), PC3 (Et0/1), KALI (Et0/2), R1 (Et0/3), and a spare unused port (Et0/4). H1 connects to PC1, PC2, and KALI2 — all three share the hub's single collision domain. R1 connects to FW1."
    >
      <defs>
        <pattern id="grid-kali2" width="24" height="24" patternUnits="userSpaceOnUse">
          <path d="M24 0H0V24" fill="none" stroke="#1b2129" stroke-width="1" />
        </pattern>
        <filter id="glow-kali2" x="-40%" y="-40%" width="180%" height="180%">
          <feGaussianBlur stdDeviation="3" result="blur" />
          <feMerge>
            <feMergeNode in="blur" />
            <feMergeNode in="SourceGraphic" />
          </feMerge>
        </filter>
      </defs>

      <rect x="0" y="0" width="720" height="490" rx="10" fill="#0b0f14" />
      <rect x="1" y="37" width="718" height="452" fill="url(#grid-kali2)" />
      <rect x="0.5" y="0.5" width="719" height="489" rx="10" fill="none" stroke="#22272e" stroke-width="1" />

      <line x1="0" y1="36" x2="720" y2="36" stroke="#22272e" stroke-width="1" />
      <circle cx="20" cy="18" r="6" fill="#ff5f56" />
      <circle cx="40" cy="18" r="6" fill="#ffbd2e" />
      <circle cx="60" cy="18" r="6" fill="#27c93f" />
      <text x="82" y="22" font-family="Courier New, monospace" fontSize="12" fill="#6e7681">
        root@netbreaker:~/lab15$ topology --render
      </text>

      <line x1="360" y1="130" x2="360" y2="160" stroke="#4d5560" stroke-width="1.5" />
      <line x1="120" y1="160" x2="699" y2="160" stroke="#4d5560" stroke-width="1.5" />
      <line x1="120" y1="160" x2="120" y2="190" stroke="#4d5560" stroke-width="1.5" />
      <line x1="280" y1="160" x2="280" y2="190" stroke="#4d5560" stroke-width="1.5" />
      <line x1="440" y1="160" x2="440" y2="190" stroke="#4d5560" stroke-width="1.5" />
      <line x1="600" y1="160" x2="600" y2="190" stroke="#4d5560" stroke-width="1.5" />
      <line x1="699" y1="160" x2="699" y2="190" stroke="#4d5560" stroke-width="1.5" stroke-dasharray="3 2" />

      <rect x="99" y="150" width="42" height="16" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
      <text x="120" y="161" textAnchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/0</text>
      <rect x="259" y="150" width="42" height="16" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
      <text x="280" y="161" textAnchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/1</text>
      <rect x="419" y="150" width="42" height="16" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
      <text x="440" y="161" textAnchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/2</text>
      <rect x="579" y="150" width="42" height="16" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
      <text x="600" y="161" textAnchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/3</text>
      <rect x="678" y="150" width="42" height="16" rx="3" fill="#0b0f14" stroke="#8b98a5" stroke-width="1" stroke-dasharray="3 2" />
      <text x="699" y="161" textAnchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">Et0/4</text>
      <text x="699" y="204" textAnchor="middle" font-family="Courier New, monospace" fontSize="9" fill="#6e7681">spare</text>

      <line x1="120" y1="250" x2="120" y2="280" stroke="#22d3ee" stroke-width="1.5" />
      <line x1="75" y1="280" x2="255" y2="280" stroke="#22d3ee" stroke-width="1.5" />
      <line x1="75" y1="280" x2="75" y2="310" stroke="#22d3ee" stroke-width="1.5" />
      <line x1="165" y1="280" x2="165" y2="310" stroke="#22d3ee" stroke-width="1.5" />
      <line x1="255" y1="280" x2="255" y2="310" stroke="#22d3ee" stroke-width="1.5" />
      <line x1="600" y1="250" x2="600" y2="310" stroke="#4d5560" stroke-width="1.5" />


      <g>
        <rect x="280" y="70" width="160" height="60" rx="6" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
        <text x="360" y="95" textAnchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#e6edf3">SW1</text>
        <text x="360" y="114" textAnchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">l2_switch — 5 ports</text>
      </g>

      <g>
        <rect x="50" y="190" width="140" height="60" rx="6" fill="#131a21" stroke="#d29922" stroke-width="1.5" />
        <text x="120" y="215" textAnchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#d29922">H1</text>
        <text x="120" y="234" textAnchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#a17f2f">hub — shared domain</text>
      </g>

      <g>
        <rect x="210" y="190" width="140" height="60" rx="6" fill="#131a21" stroke="#22d3ee" stroke-width="1.5" />
        <text x="280" y="215" textAnchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#67e8f9">PC3</text>
        <text x="280" y="234" textAnchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#22d3ee">end_host</text>
      </g>

      <g filter="url(#glow-kali2)">
        <rect x="370" y="190" width="140" height="60" rx="6" fill="#1a0f11" stroke="#f85149" stroke-width="1.5" stroke-dasharray="5 3" />
      </g>
      <text x="440" y="215" textAnchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#ff7b72">KALI</text>
      <text x="440" y="234" textAnchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#f85149">observer / sniffer</text>

      <g>
        <rect x="530" y="190" width="140" height="60" rx="6" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
        <text x="600" y="215" textAnchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#e6edf3">R1</text>
        <text x="600" y="234" textAnchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">router</text>
      </g>

      <circle cx="75" cy="340" r="30" fill="#131a21" stroke="#22d3ee" stroke-width="1.5" />
      <text x="75" y="345" textAnchor="middle" font-family="Courier New, monospace" fontSize="13" fontWeight="700" fill="#67e8f9">PC1</text>

      <circle cx="165" cy="340" r="30" fill="#131a21" stroke="#22d3ee" stroke-width="1.5" />
      <text x="165" y="345" textAnchor="middle" font-family="Courier New, monospace" fontSize="13" fontWeight="700" fill="#67e8f9">PC2</text>

      <g filter="url(#glow-kali2)">
        <circle cx="255" cy="340" r="30" fill="#1a0f11" stroke="#f85149" stroke-width="1.5" stroke-dasharray="4 2" />
      </g>
      <text x="255" y="345" textAnchor="middle" font-family="Courier New, monospace" fontSize="12" fontWeight="700" fill="#ff7b72">KALI2</text>

      <g>
        <rect x="530" y="310" width="140" height="60" rx="6" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
        <text x="600" y="335" textAnchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#e6edf3">FW1</text>
        <text x="600" y="354" textAnchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">firewall</text>
      </g>

      <line x1="30" y1="405" x2="690" y2="405" stroke="#22272e" stroke-width="1" />
      <text x="30" y="424" font-family="Courier New, monospace" fontSize="10" fill="#6e7681">// device_legend</text>

      <rect x="30" y="438" width="12" height="12" rx="2" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
      <text x="50" y="448" font-family="Courier New, monospace" fontSize="11" fill="#8b98a5">switch / router / firewall</text>

      <rect x="230" y="438" width="12" height="12" rx="2" fill="#131a21" stroke="#d29922" stroke-width="1.5" />
      <text x="250" y="448" font-family="Courier New, monospace" fontSize="11" fill="#a17f2f">hub — single collision domain</text>

      <circle cx="486" cy="444" r="6" fill="#131a21" stroke="#22d3ee" stroke-width="1.5" />
      <text x="500" y="448" font-family="Courier New, monospace" fontSize="11" fill="#22d3ee">end host</text>

      <rect x="580" y="438" width="12" height="12" rx="2" fill="#1a0f11" stroke="#f85149" stroke-width="1.5" stroke-dasharray="3 2" />
      <text x="600" y="448" font-family="Courier New, monospace" fontSize="11" fill="#f85149">observer / attacker</text>

      <text x="30" y="475" font-family="Courier New, monospace" fontSize="10" fill="#4d5560">
        initial_build: pc1+pc2+kali2→h1→sw1(et0/0) · pc3→sw1(et0/1) · kali→sw1(et0/2) · sw1→r1(et0/3) · sw1(et0/4)=spare · r1→fw1
      </text>
    </svg>$md$,
  $md$<svg
      width="100%"
      viewBox="0 0 720 490"
      xmlns="http://www.w3.org/2000/svg"
      role="img"
      aria-label="NetBreaker Lab 15 topology: PC1(eth0)→H1(e0), PC2(eth0)→H1(e1), KALI2(eth0)→H1(e3), H1(e2)→SW1(Et0/0), PC3(eth0)→SW1(Et0/1), KALI(eth0)→SW1(Et0/2), SW1(Et0/3)→R1(Et0/0), R1(Et0/1)→FW1(Ethernet0)"
    >
      <defs>
        <pattern id="grid" width="24" height="24" patternUnits="userSpaceOnUse">
          <path d="M24 0H0V24" fill="none" stroke="#1b2129" stroke-width="1" />
        </pattern>
        <filter id="glow" x="-40%" y="-40%" width="180%" height="180%">
          <feGaussianBlur stdDeviation="3" result="blur" />
          <feMerge>
            <feMergeNode in="blur" />
            <feMergeNode in="SourceGraphic" />
          </feMerge>
        </filter>
      </defs>

      <rect x="0" y="0" width="720" height="490" rx="10" fill="#0b0f14" />
      <rect x="1" y="37" width="718" height="451" fill="url(#grid)" />
      <rect x="0.5" y="0.5" width="719" height="489" rx="10" fill="none" stroke="#22272e" stroke-width="1" />

      <line x1="0" y1="36" x2="720" y2="36" stroke="#22272e" stroke-width="1" />
      <circle cx="20" cy="18" r="6" fill="#ff5f56" />
      <circle cx="40" cy="18" r="6" fill="#ffbd2e" />
      <circle cx="60" cy="18" r="6" fill="#27c93f" />
      <text x="82" y="22" font-family="Courier New, monospace" fontSize="12" fill="#6e7681">
        root@netbreaker:~/lab15$ topology --render
      </text>
      <g data-link="PC1:eth0↔H1:e0">
        <line x1="86" y1="312" x2="109" y2="250" stroke="#4d5560" stroke-width="1.5"
          data-node-a="PC1" data-iface-a="eth0" data-node-b="H1" data-iface-b="e0" />
        <title>PC1 eth0 ↔ H1 e0</title>
      </g>
      <g data-link="PC2:eth0↔H1:e1">
        <line x1="154" y1="312" x2="131" y2="250" stroke="#4d5560" stroke-width="1.5"
          data-node-a="PC2" data-iface-a="eth0" data-node-b="H1" data-iface-b="e1" />
        <title>PC2 eth0 ↔ H1 e1</title>
      </g>
      <g data-link="KALI2:eth0↔H1:e3">
        <line x1="233" y1="320" x2="154" y2="250" stroke="#4d5560" stroke-width="1.5"
          data-node-a="KALI2" data-iface-a="eth0" data-node-b="H1" data-iface-b="e3" />
        <title>KALI2 eth0 ↔ H1 e3</title>
      </g>
      <g data-link="H1:e2↔SW1:Et0/0">
        <line x1="180" y1="190" x2="300" y2="130" stroke="#4d5560" stroke-width="1.5"
          data-node-a="H1" data-iface-a="e2" data-node-b="SW1" data-iface-b="Et0/0" />
        <title>H1 e2 ↔ SW1 Et0/0</title>
      </g>
      <g data-link="PC3:eth0↔SW1:Et0/1">
        <line x1="297" y1="195" x2="340" y2="130" stroke="#4d5560" stroke-width="1.5"
          data-node-a="PC3" data-iface-a="eth0" data-node-b="SW1" data-iface-b="Et0/1" />
        <title>PC3 eth0 ↔ SW1 Et0/1</title>
      </g>
      <g data-link="KALI:eth0↔SW1:Et0/2">
        <line x1="420" y1="190" x2="380" y2="130" stroke="#4d5560" stroke-width="1.5"
          data-node-a="KALI" data-iface-a="eth0" data-node-b="SW1" data-iface-b="Et0/2" />
        <title>KALI eth0 ↔ SW1 Et0/2</title>
      </g>
      <g data-link="SW1:Et0/3↔R1:Et0/0">
        <line x1="420" y1="130" x2="540" y2="190" stroke="#4d5560" stroke-width="1.5"
          data-node-a="SW1" data-iface-a="Et0/3" data-node-b="R1" data-iface-b="Et0/0" />
        <title>SW1 Et0/3 ↔ R1 Et0/0</title>
      </g>
      <g data-link="R1:Et0/1↔FW1:Ethernet0">
        <line x1="600" y1="250" x2="600" y2="310" stroke="#4d5560" stroke-width="1.5"
          data-node-a="R1" data-iface-a="Et0/1" data-node-b="FW1" data-iface-b="Ethernet0" />
        <title>R1 Et0/1 ↔ FW1 Ethernet0</title>
      </g>
      <g data-port="H1" data-iface="e0">
        <rect x="73" y="252" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="94" y="265" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">e0</text>
        <title>H1 e0</title>
      </g>
      <g data-port="H1" data-iface="e1">
        <rect x="118" y="254" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="139" y="267" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">e1</text>
        <title>H1 e1</title>
      </g>
      <g data-port="H1" data-iface="e3">
        <rect x="169" y="249" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="190" y="262" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">e3</text>
        <title>H1 e3</title>
      </g>
      <g data-port="H1" data-iface="e2">
        <rect x="184" y="177" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="205" y="190" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">e2</text>
        <title>H1 e2</title>
      </g>
      <g data-port="SW1" data-iface="Et0/0">
        <rect x="261" y="138" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="282" y="151" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/0</text>
        <title>SW1 Et0/0</title>
      </g>
      <g data-port="SW1" data-iface="Et0/1">
        <rect x="312" y="145" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="333" y="158" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/1</text>
        <title>SW1 Et0/1</title>
      </g>
      <g data-port="SW1" data-iface="Et0/2">
        <rect x="372" y="137" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="393" y="150" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/2</text>
        <title>SW1 Et0/2</title>
      </g>
      <g data-port="SW1" data-iface="Et0/3">
        <rect x="423" y="138" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="444" y="151" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/3</text>
        <title>SW1 Et0/3</title>
      </g>
      <g data-port="R1" data-iface="Et0/0">
        <rect x="494" y="177" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="515" y="190" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/0</text>
        <title>R1 Et0/0</title>
      </g>
      <g data-port="R1" data-iface="Et0/1">
        <rect x="572" y="251" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="593" y="264" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/1</text>
        <title>R1 Et0/1</title>
      </g>
      <g data-port="FW1" data-iface="Ethernet0">
        <rect x="572" y="291" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="593" y="304" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Ethernet0</text>
        <title>FW1 Ethernet0</title>
      </g>
      <g data-port="PC1" data-iface="eth0">
        <rect x="80" y="297" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="101" y="310" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">eth0</text>
        <title>PC1 eth0</title>
      </g>
      <g data-port="PC2" data-iface="eth0">
        <rect x="138" y="287" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="159" y="300" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">eth0</text>
        <title>PC2 eth0</title>
      </g>
      <g data-port="PC3" data-iface="eth0">
        <rect x="295" y="170" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="316" y="183" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">eth0</text>
        <title>PC3 eth0</title>
      </g>
      <g data-port="KALI" data-iface="eth0">
        <rect x="392" y="157" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="413" y="170" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">eth0</text>
        <title>KALI eth0</title>
      </g>
      <g data-port="KALI2" data-iface="eth0">
        <rect x="198" y="290" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="219" y="303" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">eth0</text>
        <title>KALI2 eth0</title>
      </g>
      <g data-node="H1" data-role="hub">
        <rect x="50" y="190" width="140" height="60" rx="6" fill="#131a21" stroke="#d29922" stroke-width="1.5" />
        <text x="120" y="226" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#d29922">H1</text>
        <text x="120" y="244" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#d29922">hub — shared domain</text>
        <title>H1</title>
      </g>
      <g data-node="SW1" data-role="core">
        <rect x="290" y="70" width="140" height="60" rx="6" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
        <text x="360" y="106" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#e6edf3">SW1</text>
        <text x="360" y="124" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">l2 switch</text>
        <title>SW1</title>
      </g>
      <g data-node="R1" data-role="core">
        <rect x="530" y="190" width="140" height="60" rx="6" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
        <text x="600" y="226" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#e6edf3">R1</text>
        <text x="600" y="244" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">l2 switch</text>
        <title>R1</title>
      </g>
      <g data-node="FW1" data-role="core">
        <rect x="530" y="310" width="140" height="60" rx="6" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
        <text x="600" y="346" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#e6edf3">FW1</text>
        <text x="600" y="364" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">firewall</text>
        <title>FW1</title>
      </g>
      <g data-node="PC1" data-role="host">
        <circle cx="75" cy="340" r="30" fill="#131a21" stroke="#22d3ee" stroke-width="1.5" />
        <text x="75" y="344" text-anchor="middle" font-family="Courier New, monospace" fontSize="13" fontWeight="700" fill="#67e8f9">PC1</text>
        <text x="75" y="358" text-anchor="middle" font-family="Courier New, monospace" fontSize="9" fill="#22d3ee">end host</text>
        <title>PC1</title>
      </g>
      <g data-node="PC2" data-role="host">
        <circle cx="165" cy="340" r="30" fill="#131a21" stroke="#22d3ee" stroke-width="1.5" />
        <text x="165" y="344" text-anchor="middle" font-family="Courier New, monospace" fontSize="13" fontWeight="700" fill="#67e8f9">PC2</text>
        <text x="165" y="358" text-anchor="middle" font-family="Courier New, monospace" fontSize="9" fill="#22d3ee">end host</text>
        <title>PC2</title>
      </g>
      <g data-node="PC3" data-role="host">
        <circle cx="280" cy="220" r="30" fill="#131a21" stroke="#22d3ee" stroke-width="1.5" />
        <text x="280" y="224" text-anchor="middle" font-family="Courier New, monospace" fontSize="13" fontWeight="700" fill="#67e8f9">PC3</text>
        <text x="280" y="238" text-anchor="middle" font-family="Courier New, monospace" fontSize="9" fill="#22d3ee">end host</text>
        <title>PC3</title>
      </g>
      <g data-node="KALI" data-role="attacker">
        <g filter="url(#glow)">
          <rect x="370" y="190" width="140" height="60" rx="6" fill="#1a0f11" stroke="#f85149" stroke-width="1.5" stroke-dasharray="5 3" />
        </g>
        <text x="440" y="226" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#ff7b72">KALI</text>
        <text x="440" y="244" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#f85149">attacker / observer</text>
        <title>KALI</title>
      </g>
      <g data-node="KALI2" data-role="attacker">
        <g filter="url(#glow)">
          <circle cx="255" cy="340" r="30" fill="#1a0f11" stroke="#f85149" stroke-width="1.5" stroke-dasharray="4 2" />
        </g>
        <text x="255" y="344" text-anchor="middle" font-family="Courier New, monospace" fontSize="12" fontWeight="700" fill="#ff7b72">KALI2</text>
        <title>KALI2</title>
      </g>
      <line x1="30" y1="405" x2="690" y2="405" stroke="#22272e" stroke-width="1" />
      <text x="30" y="424" font-family="Courier New, monospace" fontSize="10" fill="#6e7681">// device_legend</text>

      <rect x="30" y="438" width="12" height="12" rx="2" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
      <text x="50" y="448" font-family="Courier New, monospace" fontSize="11" fill="#e6edf3">switch / router / firewall</text>

      <rect x="230" y="438" width="12" height="12" rx="2" fill="#131a21" stroke="#d29922" stroke-width="1.5" />
      <text x="250" y="448" font-family="Courier New, monospace" fontSize="11" fill="#d29922">hub — single collision domain</text>

      <circle cx="486" cy="444" r="6" fill="#131a21" stroke="#22d3ee" stroke-width="1.5" />
      <text x="500" y="448" font-family="Courier New, monospace" fontSize="11" fill="#67e8f9">end host</text>

      <rect x="580" y="438" width="12" height="12" rx="2" fill="#1a0f11" stroke="#f85149" stroke-width="1.5" stroke-dasharray="3 2" />
      <text x="600" y="448" font-family="Courier New, monospace" fontSize="11" fill="#ff7b72">observer / attacker</text>

      <text x="30" y="475" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">
        initial_build: PC1(eth0)→H1(e0) · PC2(eth0)→H1(e1) · KALI2(eth0)→H1(e3) · H1(e2)→SW1(Et0/0) · PC3(eth0)→SW1(Et0/1) ...
      </text>
    </svg>
$md$)
WHERE lab_id = 15;

UPDATE lab_topologies SET svg_large = verify_replace(svg_large,
  $md$<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 600 280" font-family="ui-monospace,monospace">
  <rect x="60" y="14" width="180" height="44" rx="8" fill="#fff" stroke="#6b7480" stroke-width="1.5"/>
  <text x="150" y="36" text-anchor="middle" font-size="13" fill="#14161a" font-weight="600">SW1</text>
  <text x="150" y="52" text-anchor="middle" font-size="8" fill="#6b7480">ports: Et0/0-2</text>
  <rect x="360" y="14" width="180" height="44" rx="8" fill="#fff" stroke="#6b7480" stroke-width="1.5"/>
  <text x="450" y="36" text-anchor="middle" font-size="13" fill="#14161a" font-weight="600">SW2</text>
  <text x="450" y="52" text-anchor="middle" font-size="8" fill="#6b7480">ports: Et0/0-2</text>
  <line x1="240" y1="36" x2="360" y2="36" stroke="#6b7480" stroke-width="2"/>
<text x="300" y="30" text-anchor="middle" font-size="9" fill="#6b7480">Et0/2 trunk</text>
  <rect x="20" y="190" width="130" height="40" rx="6" fill="#fff" stroke="#2563eb" stroke-width="1.5"/>
  <text x="85" y="214" text-anchor="middle" font-size="11" fill="#2563eb">PC1</text>
  <rect x="170" y="190" width="130" height="40" rx="6" fill="#fff" stroke="#14161a" stroke-width="1.5"/>
  <text x="235" y="214" text-anchor="middle" font-size="11" fill="#14161a">R1 (console)</text>
  <rect x="330" y="190" width="130" height="40" rx="6" fill="#fff" stroke="#2563eb" stroke-width="1.5"/>
  <text x="395" y="214" text-anchor="middle" font-size="11" fill="#2563eb">PC2</text>
  <rect x="470" y="190" width="130" height="44" rx="6" fill="#fff" stroke="#e5484d" stroke-width="1.5"/>
  <text x="535" y="216" text-anchor="middle" font-size="11" fill="#e5484d">KALI (tapper)</text>
  <line x1="85" y1="190" x2="85" y2="58" stroke="#2563eb" stroke-width="2"/>
  <line x1="235" y1="190" x2="200" y2="58" stroke="#14161a" stroke-width="2"/>
  <line x1="395" y1="190" x2="420" y2="58" stroke="#2563eb" stroke-width="2"/>
  <line x1="535" y1="190" x2="500" y2="58" stroke="#e5484d" stroke-width="2"/>
</svg>$md$,
  $md$<svg
      width="100%"
      viewBox="0 0 720 490"
      xmlns="http://www.w3.org/2000/svg"
      role="img"
      aria-label="NetBreaker Lab 16 topology: PC1(eth0)→SW1(Et0/0), R1(Fa0/0)→SW1(Et0/1), SW1(Et0/2)→SW2(Et0/1), KALI(eth0)→SW2(Et0/0), PC2(eth0)→SW2(Et0/2)"
    >
      <defs>
        <pattern id="grid" width="24" height="24" patternUnits="userSpaceOnUse">
          <path d="M24 0H0V24" fill="none" stroke="#1b2129" stroke-width="1" />
        </pattern>
        <filter id="glow" x="-40%" y="-40%" width="180%" height="180%">
          <feGaussianBlur stdDeviation="3" result="blur" />
          <feMerge>
            <feMergeNode in="blur" />
            <feMergeNode in="SourceGraphic" />
          </feMerge>
        </filter>
      </defs>

      <rect x="0" y="0" width="720" height="490" rx="10" fill="#0b0f14" />
      <rect x="1" y="37" width="718" height="451" fill="url(#grid)" />
      <rect x="0.5" y="0.5" width="719" height="489" rx="10" fill="none" stroke="#22272e" stroke-width="1" />

      <line x1="0" y1="36" x2="720" y2="36" stroke="#22272e" stroke-width="1" />
      <circle cx="20" cy="18" r="6" fill="#ff5f56" />
      <circle cx="40" cy="18" r="6" fill="#ffbd2e" />
      <circle cx="60" cy="18" r="6" fill="#27c93f" />
      <text x="82" y="22" font-family="Courier New, monospace" fontSize="12" fill="#6e7681">
        root@netbreaker:~/lab16$ topology --render
      </text>
      <g data-link="PC1:eth0↔SW1:Et0/0">
        <line x1="95" y1="231" x2="139" y2="115" stroke="#4d5560" stroke-width="1.5"
          data-node-a="PC1" data-iface-a="eth0" data-node-b="SW1" data-iface-b="Et0/0" />
        <title>PC1 eth0 ↔ SW1 Et0/0</title>
      </g>
      <g data-link="R1:Fa0/0↔SW1:Et0/1">
        <line x1="220" y1="229" x2="165" y2="115" stroke="#4d5560" stroke-width="1.5"
          data-node-a="R1" data-iface-a="Fa0/0" data-node-b="SW1" data-iface-b="Et0/1" />
        <title>R1 Fa0/0 ↔ SW1 Et0/1</title>
      </g>
      <g data-link="SW1:Et0/2↔SW2:Et0/1">
        <line x1="220" y1="85" x2="380" y2="85" stroke="#4d5560" stroke-width="1.5"
          data-node-a="SW1" data-iface-a="Et0/2" data-node-b="SW2" data-iface-b="Et0/1" />
        <title>SW1 Et0/2 ↔ SW2 Et0/1</title>
      </g>
      <g data-link="KALI:eth0↔SW2:Et0/0">
        <line x1="521" y1="231" x2="464" y2="115" stroke="#4d5560" stroke-width="1.5"
          data-node-a="KALI" data-iface-a="eth0" data-node-b="SW2" data-iface-b="Et0/0" />
        <title>KALI eth0 ↔ SW2 Et0/0</title>
      </g>
      <g data-link="PC2:eth0↔SW2:Et0/2">
        <line x1="404" y1="230" x2="441" y2="115" stroke="#4d5560" stroke-width="1.5"
          data-node-a="PC2" data-iface-a="eth0" data-node-b="SW2" data-iface-b="Et0/2" />
        <title>PC2 eth0 ↔ SW2 Et0/2</title>
      </g>
      <g data-port="SW1" data-iface="Et0/0">
        <rect x="116" y="131" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="137" y="144" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/0</text>
        <title>SW1 Et0/0</title>
      </g>
      <g data-port="SW1" data-iface="Et0/1">
        <rect x="160" y="124" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="181" y="137" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/1</text>
        <title>SW1 Et0/1</title>
      </g>
      <g data-port="SW1" data-iface="Et0/2">
        <rect x="223" y="83" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="244" y="96" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/2</text>
        <title>SW1 Et0/2</title>
      </g>
      <g data-port="SW2" data-iface="Et0/1">
        <rect x="335" y="83" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="356" y="96" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/1</text>
        <title>SW2 Et0/1</title>
      </g>
      <g data-port="SW2" data-iface="Et0/0">
        <rect x="466" y="124" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="487" y="137" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/0</text>
        <title>SW2 Et0/0</title>
      </g>
      <g data-port="SW2" data-iface="Et0/2">
        <rect x="414" y="132" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="435" y="145" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/2</text>
        <title>SW2 Et0/2</title>
      </g>
      <g data-port="R1" data-iface="Fa0/0">
        <rect x="195" y="195" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="216" y="208" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Fa0/0</text>
        <title>R1 Fa0/0</title>
      </g>
      <g data-port="PC1" data-iface="eth0">
        <rect x="89" y="202" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="110" y="215" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">eth0</text>
        <title>PC1 eth0</title>
      </g>
      <g data-port="PC2" data-iface="eth0">
        <rect x="397" y="201" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="418" y="214" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">eth0</text>
        <title>PC2 eth0</title>
      </g>
      <g data-port="KALI" data-iface="eth0">
        <rect x="495" y="197" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="516" y="210" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">eth0</text>
        <title>KALI eth0</title>
      </g>
      <g data-node="SW1" data-role="core">
        <rect x="80" y="55" width="140" height="60" rx="6" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
        <text x="150" y="91" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#e6edf3">SW1</text>
        <text x="150" y="109" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">l2 switch</text>
        <title>SW1</title>
      </g>
      <g data-node="SW2" data-role="core">
        <rect x="380" y="55" width="140" height="60" rx="6" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
        <text x="450" y="91" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#e6edf3">SW2</text>
        <text x="450" y="109" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">l2 switch</text>
        <title>SW2</title>
      </g>
      <g data-node="R1" data-role="core">
        <rect x="165" y="229" width="140" height="60" rx="6" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
        <text x="235" y="265" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#e6edf3">R1</text>
        <text x="235" y="283" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">router</text>
        <title>R1</title>
      </g>
      <g data-node="PC1" data-role="host">
        <circle cx="85" cy="259" r="30" fill="#131a21" stroke="#22d3ee" stroke-width="1.5" />
        <text x="85" y="263" text-anchor="middle" font-family="Courier New, monospace" fontSize="13" fontWeight="700" fill="#67e8f9">PC1</text>
        <text x="85" y="277" text-anchor="middle" font-family="Courier New, monospace" fontSize="9" fill="#22d3ee">end host</text>
        <title>PC1</title>
      </g>
      <g data-node="PC2" data-role="host">
        <circle cx="395" cy="259" r="30" fill="#131a21" stroke="#22d3ee" stroke-width="1.5" />
        <text x="395" y="263" text-anchor="middle" font-family="Courier New, monospace" fontSize="13" fontWeight="700" fill="#67e8f9">PC2</text>
        <text x="395" y="277" text-anchor="middle" font-family="Courier New, monospace" fontSize="9" fill="#22d3ee">end host</text>
        <title>PC2</title>
      </g>
      <g data-node="KALI" data-role="attacker">
        <g filter="url(#glow)">
          <rect x="465" y="231" width="140" height="60" rx="6" fill="#1a0f11" stroke="#f85149" stroke-width="1.5" stroke-dasharray="5 3" />
        </g>
        <text x="535" y="267" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#ff7b72">KALI</text>
        <text x="535" y="285" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#f85149">attacker / observer</text>
        <title>KALI</title>
      </g>
      <line x1="30" y1="405" x2="690" y2="405" stroke="#22272e" stroke-width="1" />
      <text x="30" y="424" font-family="Courier New, monospace" fontSize="10" fill="#6e7681">// device_legend</text>

      <rect x="30" y="438" width="12" height="12" rx="2" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
      <text x="50" y="448" font-family="Courier New, monospace" fontSize="11" fill="#e6edf3">switch / router / firewall</text>

      <rect x="230" y="438" width="12" height="12" rx="2" fill="#131a21" stroke="#d29922" stroke-width="1.5" />
      <text x="250" y="448" font-family="Courier New, monospace" fontSize="11" fill="#d29922">hub — single collision domain</text>

      <circle cx="486" cy="444" r="6" fill="#131a21" stroke="#22d3ee" stroke-width="1.5" />
      <text x="500" y="448" font-family="Courier New, monospace" fontSize="11" fill="#67e8f9">end host</text>

      <rect x="580" y="438" width="12" height="12" rx="2" fill="#1a0f11" stroke="#f85149" stroke-width="1.5" stroke-dasharray="3 2" />
      <text x="600" y="448" font-family="Courier New, monospace" fontSize="11" fill="#ff7b72">observer / attacker</text>

      <text x="30" y="475" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">
        initial_build: PC1(eth0)→SW1(Et0/0) · R1(Fa0/0)→SW1(Et0/1) · SW1(Et0/2)→SW2(Et0/1) · KALI(eth0)→SW2(Et0/0) · PC2(et...
      </text>
    </svg>
$md$)
WHERE lab_id = 16;

UPDATE lab_topologies SET svg_large = verify_replace(svg_large,
  $md$<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 700 340" font-family="ui-monospace,monospace">
  <rect x="30" y="20" width="170" height="50" rx="10" fill="#fff" stroke="#2563eb" stroke-width="2"/>
  <text x="115" y="46" text-anchor="middle" font-size="13" fill="#2563eb" font-weight="600">LAN A: 192.168.10.0/24</text>
  <text x="115" y="62" text-anchor="middle" font-size="9" fill="#6b7480">PC1 .10 · PC2 .20 · R1 .1</text>
  <rect x="260" y="20" width="180" height="50" rx="10" fill="#fff" stroke="#14161a" stroke-width="2"/>
  <text x="350" y="46" text-anchor="middle" font-size="14" fill="#14161a" font-weight="700">R1 · Gateway</text>
  <text x="350" y="62" text-anchor="middle" font-size="9" fill="#6b7480">gi0/0 (.10.1) · gi0/1 (.20.1) · gi0/2 (10.0.0.1)</text>
  <rect x="500" y="20" width="170" height="50" rx="10" fill="#fff" stroke="#6b7480" stroke-width="2"/>
  <text x="585" y="46" text-anchor="middle" font-size="13" fill="#6b7480" font-weight="600">WAN: 10.0.0.0/30</text>
  <text x="585" y="62" text-anchor="middle" font-size="9" fill="#6b7480">R1 .1 → R2 .2</text>
  <line x1="200" y1="45" x2="260" y2="45" stroke="#2563eb" stroke-width="2.5"/>
  <line x1="440" y1="45" x2="500" y2="45" stroke="#6b7480" stroke-width="2.5"/>
  <rect x="500" y="130" width="170" height="50" rx="10" fill="#fff" stroke="#2563eb" stroke-width="2"/>
  <text x="585" y="156" text-anchor="middle" font-size="13" fill="#2563eb" font-weight="600">LAN B: 172.16.20.0/24</text>
  <text x="585" y="172" text-anchor="middle" font-size="9" fill="#6b7480">PC3 .10 · R1 .1</text>
  <line x1="440" y1="70" x2="540" y2="130" stroke="#6b7480" stroke-width="2.5"/>
  <rect x="40" y="210" width="200" height="54" rx="10" fill="#fff" stroke="#e5484d" stroke-width="2"/>
  <text x="140" y="236" text-anchor="middle" font-size="13" fill="#e5484d" font-weight="600">KALI</text>
  <text x="140" y="254" text-anchor="middle" font-size="9" fill="#6b7480">nmap scan · IP spoof · DHCP flood</text>
  <rect x="440" y="210" width="180" height="54" rx="10" fill="#fff" stroke="#2563eb" stroke-width="2"/>
  <text x="530" y="236" text-anchor="middle" font-size="13" fill="#2563eb" font-weight="600">PC2</text>
  <text x="530" y="254" text-anchor="middle" font-size="9" fill="#6b7480">192.168.10.20</text>
  <line x1="140" y1="210" x2="210" y2="70" stroke="#e5484d" stroke-width="2" stroke-dasharray="6 5"/>
</svg>$md$,
  $md$<svg
      width="100%"
      viewBox="0 0 720 490"
      xmlns="http://www.w3.org/2000/svg"
      role="img"
      aria-label="NetBreaker Lab 19 topology: R1(Fa0/0)→SW1(Et0/0), PC1(eth0)→SW1(Et0/1), PC2(eth0)→SW1(Et0/2), KALI(eth0)→SW1(Et0/3), R1(Fa0/1)→PC3(eth0), R1(Fa2/0)→R2(Fa0/0)"
    >
      <defs>
        <pattern id="grid" width="24" height="24" patternUnits="userSpaceOnUse">
          <path d="M24 0H0V24" fill="none" stroke="#1b2129" stroke-width="1" />
        </pattern>
        <filter id="glow" x="-40%" y="-40%" width="180%" height="180%">
          <feGaussianBlur stdDeviation="3" result="blur" />
          <feMerge>
            <feMergeNode in="blur" />
            <feMergeNode in="SourceGraphic" />
          </feMerge>
        </filter>
      </defs>

      <rect x="0" y="0" width="720" height="490" rx="10" fill="#0b0f14" />
      <rect x="1" y="37" width="718" height="451" fill="url(#grid)" />
      <rect x="0.5" y="0.5" width="719" height="489" rx="10" fill="none" stroke="#22272e" stroke-width="1" />

      <line x1="0" y1="36" x2="720" y2="36" stroke="#22272e" stroke-width="1" />
      <circle cx="20" cy="18" r="6" fill="#ff5f56" />
      <circle cx="40" cy="18" r="6" fill="#ffbd2e" />
      <circle cx="60" cy="18" r="6" fill="#27c93f" />
      <text x="82" y="22" font-family="Courier New, monospace" fontSize="12" fill="#6e7681">
        root@netbreaker:~/lab19$ topology --render
      </text>
      <g data-link="R1:Fa0/0↔SW1:Et0/0">
        <line x1="410" y1="115" x2="420" y2="120" stroke="#4d5560" stroke-width="1.5"
          data-node-a="R1" data-iface-a="Fa0/0" data-node-b="SW1" data-iface-b="Et0/0" />
        <title>R1 Fa0/0 ↔ SW1 Et0/0</title>
      </g>
      <g data-link="PC1:eth0↔SW1:Et0/1">
        <line x1="145" y1="90" x2="410" y2="138" stroke="#4d5560" stroke-width="1.5"
          data-node-a="PC1" data-iface-a="eth0" data-node-b="SW1" data-iface-b="Et0/1" />
        <title>PC1 eth0 ↔ SW1 Et0/1</title>
      </g>
      <g data-link="PC2:eth0↔SW1:Et0/2">
        <line x1="519" y1="249" x2="492" y2="180" stroke="#4d5560" stroke-width="1.5"
          data-node-a="PC2" data-iface-a="eth0" data-node-b="SW1" data-iface-b="Et0/2" />
        <title>PC2 eth0 ↔ SW1 Et0/2</title>
      </g>
      <g data-link="KALI:eth0↔SW1:Et0/3">
        <line x1="210" y1="251" x2="410" y2="176" stroke="#4d5560" stroke-width="1.5"
          data-node-a="KALI" data-iface-a="eth0" data-node-b="SW1" data-iface-b="Et0/3" />
        <title>KALI eth0 ↔ SW1 Et0/3</title>
      </g>
      <g data-link="R1:Fa0/1↔PC3:eth0">
        <line x1="414" y1="115" x2="558" y2="182" stroke="#4d5560" stroke-width="1.5"
          data-node-a="R1" data-iface-a="Fa0/1" data-node-b="PC3" data-iface-b="eth0" />
        <title>R1 Fa0/1 ↔ PC3 eth0</title>
      </g>
      <g data-link="R1:Fa2/0↔R2:Fa0/0">
        <line x1="322" y1="115" x2="318" y2="120" stroke="#4d5560" stroke-width="1.5"
          data-node-a="R1" data-iface-a="Fa2/0" data-node-b="R2" data-iface-b="Fa0/0" />
        <title>R1 Fa2/0 ↔ R2 Fa0/0</title>
      </g>
      <g data-port="R1" data-iface="Fa0/0">
        <rect x="396" y="142" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="417" y="155" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Fa0/0</text>
        <title>R1 Fa0/0</title>
      </g>
      <g data-port="R1" data-iface="Fa0/1">
        <rect x="426" y="112" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="447" y="125" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Fa0/1</text>
        <title>R1 Fa0/1</title>
      </g>
      <g data-port="R1" data-iface="Fa2/0">
        <rect x="280" y="119" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="301" y="132" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Fa2/0</text>
        <title>R1 Fa2/0</title>
      </g>
      <g data-port="R2" data-iface="Fa0/0">
        <rect x="308" y="89" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="329" y="102" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Fa0/0</text>
        <title>R2 Fa0/0</title>
      </g>
      <g data-port="SW1" data-iface="Et0/0">
        <rect x="375" y="103" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="396" y="116" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/0</text>
        <title>SW1 Et0/0</title>
      </g>
      <g data-port="SW1" data-iface="Et0/1">
        <rect x="353" y="129" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="374" y="142" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/1</text>
        <title>SW1 Et0/1</title>
      </g>
      <g data-port="SW1" data-iface="Et0/2">
        <rect x="486" y="191" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="507" y="204" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/2</text>
        <title>SW1 Et0/2</title>
      </g>
      <g data-port="SW1" data-iface="Et0/3">
        <rect x="369" y="182" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="390" y="195" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/3</text>
        <title>SW1 Et0/3</title>
      </g>
      <g data-port="PC1" data-iface="eth0">
        <rect x="146" y="92" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="167" y="105" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">eth0</text>
        <title>PC1 eth0</title>
      </g>
      <g data-port="PC2" data-iface="eth0">
        <rect x="496" y="215" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="517" y="228" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">eth0</text>
        <title>PC2 eth0</title>
      </g>
      <g data-port="PC3" data-iface="eth0">
        <rect x="512" y="169" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="533" y="182" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">eth0</text>
        <title>PC3 eth0</title>
      </g>
      <g data-port="KALI" data-iface="eth0">
        <rect x="214" y="240" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="235" y="253" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">eth0</text>
        <title>KALI eth0</title>
      </g>
      <g data-node="R1" data-role="core">
        <rect x="280" y="55" width="140" height="60" rx="6" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
        <text x="350" y="91" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#e6edf3">R1</text>
        <text x="350" y="109" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">router</text>
        <title>R1</title>
      </g>
      <g data-node="R2" data-role="core">
        <rect x="220" y="120" width="140" height="60" rx="6" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
        <text x="290" y="156" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#e6edf3">R2</text>
        <text x="290" y="174" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">router</text>
        <title>R2</title>
      </g>
      <g data-node="SW1" data-role="core">
        <rect x="410" y="120" width="140" height="60" rx="6" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
        <text x="480" y="156" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#e6edf3">SW1</text>
        <text x="480" y="174" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">l2 switch</text>
        <title>SW1</title>
      </g>
      <g data-node="PC1" data-role="host">
        <circle cx="115" cy="85" r="30" fill="#131a21" stroke="#22d3ee" stroke-width="1.5" />
        <text x="115" y="89" text-anchor="middle" font-family="Courier New, monospace" fontSize="13" fontWeight="700" fill="#67e8f9">PC1</text>
        <text x="115" y="103" text-anchor="middle" font-family="Courier New, monospace" fontSize="9" fill="#22d3ee">end host</text>
        <title>PC1</title>
      </g>
      <g data-node="PC2" data-role="host">
        <circle cx="530" cy="277" r="30" fill="#131a21" stroke="#22d3ee" stroke-width="1.5" />
        <text x="530" y="281" text-anchor="middle" font-family="Courier New, monospace" fontSize="13" fontWeight="700" fill="#67e8f9">PC2</text>
        <text x="530" y="295" text-anchor="middle" font-family="Courier New, monospace" fontSize="9" fill="#22d3ee">end host</text>
        <title>PC2</title>
      </g>
      <g data-node="PC3" data-role="host">
        <circle cx="585" cy="195" r="30" fill="#131a21" stroke="#22d3ee" stroke-width="1.5" />
        <text x="585" y="199" text-anchor="middle" font-family="Courier New, monospace" fontSize="13" fontWeight="700" fill="#67e8f9">PC3</text>
        <text x="585" y="213" text-anchor="middle" font-family="Courier New, monospace" fontSize="9" fill="#22d3ee">end host</text>
        <title>PC3</title>
      </g>
      <g data-node="KALI" data-role="attacker">
        <g filter="url(#glow)">
          <rect x="70" y="247" width="140" height="60" rx="6" fill="#1a0f11" stroke="#f85149" stroke-width="1.5" stroke-dasharray="5 3" />
        </g>
        <text x="140" y="283" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#ff7b72">KALI</text>
        <text x="140" y="301" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#f85149">attacker / observer</text>
        <title>KALI</title>
      </g>
      <line x1="30" y1="405" x2="690" y2="405" stroke="#22272e" stroke-width="1" />
      <text x="30" y="424" font-family="Courier New, monospace" fontSize="10" fill="#6e7681">// device_legend</text>

      <rect x="30" y="438" width="12" height="12" rx="2" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
      <text x="50" y="448" font-family="Courier New, monospace" fontSize="11" fill="#e6edf3">switch / router / firewall</text>

      <rect x="230" y="438" width="12" height="12" rx="2" fill="#131a21" stroke="#d29922" stroke-width="1.5" />
      <text x="250" y="448" font-family="Courier New, monospace" fontSize="11" fill="#d29922">hub — single collision domain</text>

      <circle cx="486" cy="444" r="6" fill="#131a21" stroke="#22d3ee" stroke-width="1.5" />
      <text x="500" y="448" font-family="Courier New, monospace" fontSize="11" fill="#67e8f9">end host</text>

      <rect x="580" y="438" width="12" height="12" rx="2" fill="#1a0f11" stroke="#f85149" stroke-width="1.5" stroke-dasharray="3 2" />
      <text x="600" y="448" font-family="Courier New, monospace" fontSize="11" fill="#ff7b72">observer / attacker</text>

      <text x="30" y="475" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">
        initial_build: R1(Fa0/0)→SW1(Et0/0) · PC1(eth0)→SW1(Et0/1) · PC2(eth0)→SW1(Et0/2) · KALI(eth0)→SW1(Et0/3) · R1(Fa0/...
      </text>
    </svg>
$md$)
WHERE lab_id = 19;

UPDATE lab_topologies SET svg_large = verify_replace(svg_large,
  $md$<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 700 320" font-family="ui-monospace,monospace">
  <rect x="30" y="14" width="180" height="46" rx="10" fill="#fff" stroke="#14161a" stroke-width="2"/>
  <text x="120" y="38" text-anchor="middle" font-size="13" fill="#14161a" font-weight="600">R1</text>
  <text x="120" y="54" text-anchor="middle" font-size="8" fill="#6b7480">.1.1 · 10.0.0.1/30</text>
  <rect x="260" y="14" width="180" height="46" rx="10" fill="#fff" stroke="#14161a" stroke-width="2"/>
  <text x="350" y="38" text-anchor="middle" font-size="13" fill="#14161a" font-weight="600">R2</text>
  <text x="350" y="54" text-anchor="middle" font-size="8" fill="#6b7480">.2.1 · 10.0.0.5/30</text>
  <rect x="490" y="14" width="180" height="46" rx="10" fill="#fff" stroke="#14161a" stroke-width="2"/>
  <text x="580" y="38" text-anchor="middle" font-size="13" fill="#14161a" font-weight="600">R3</text>
  <text x="580" y="54" text-anchor="middle" font-size="8" fill="#6b7480">.3.1 · 10.0.0.10/30</text>
  <line x1="210" y1="37" x2="260" y2="37" stroke="#6b7480" stroke-width="2.5"/>
  <line x1="440" y1="37" x2="490" y2="37" stroke="#6b7480" stroke-width="2.5"/>
  <rect x="30" y="130" width="180" height="46" rx="10" fill="#fff" stroke="#2563eb" stroke-width="2"/>
  <text x="120" y="156" text-anchor="middle" font-size="12" fill="#2563eb" font-weight="600">LAN: 192.168.1.0/24</text>
  <rect x="260" y="130" width="180" height="46" rx="10" fill="#fff" stroke="#2563eb" stroke-width="2"/>
  <text x="350" y="156" text-anchor="middle" font-size="12" fill="#2563eb" font-weight="600">LAN: 192.168.2.0/24</text>
  <rect x="490" y="130" width="180" height="46" rx="10" fill="#fff" stroke="#2563eb" stroke-width="2"/>
  <text x="580" y="156" text-anchor="middle" font-size="12" fill="#2563eb" font-weight="600">LAN: 192.168.3.0/24</text>
  <rect x="240" y="240" width="220" height="54" rx="10" fill="#fff" stroke="#e5484d" stroke-width="2"/>
  <text x="350" y="266" text-anchor="middle" font-size="13" fill="#e5484d" font-weight="700">KALI</text>
  <text x="350" y="284" text-anchor="middle" font-size="9" fill="#6b7480">blackhole · hijack · loop</text>
  <line x1="350" y1="240" x2="120" y2="60" stroke="#e5484d" stroke-width="2" stroke-dasharray="6 5"/>
</svg>$md$,
  $md$<svg
      width="100%"
      viewBox="0 0 720 490"
      xmlns="http://www.w3.org/2000/svg"
      role="img"
      aria-label="NetBreaker Lab 21 topology: R1(Fa0/0)→R2(Fa0/0), R2(Fa0/1)→R3(Fa0/0), R3(Fa0/1)→R1(Fa0/1), R1(Gi1/1)→PC1(eth0), R1(Gi1/2)→KALI(eth0), R2(Gi1/1)→PC2(eth0), R3(Gi1/1)→PC3(eth0)"
    >
      <defs>
        <pattern id="grid" width="24" height="24" patternUnits="userSpaceOnUse">
          <path d="M24 0H0V24" fill="none" stroke="#1b2129" stroke-width="1" />
        </pattern>
        <filter id="glow" x="-40%" y="-40%" width="180%" height="180%">
          <feGaussianBlur stdDeviation="3" result="blur" />
          <feMerge>
            <feMergeNode in="blur" />
            <feMergeNode in="SourceGraphic" />
          </feMerge>
        </filter>
      </defs>

      <rect x="0" y="0" width="720" height="490" rx="10" fill="#0b0f14" />
      <rect x="1" y="37" width="718" height="451" fill="url(#grid)" />
      <rect x="0.5" y="0.5" width="719" height="489" rx="10" fill="none" stroke="#22272e" stroke-width="1" />

      <line x1="0" y1="36" x2="720" y2="36" stroke="#22272e" stroke-width="1" />
      <circle cx="20" cy="18" r="6" fill="#ff5f56" />
      <circle cx="40" cy="18" r="6" fill="#ffbd2e" />
      <circle cx="60" cy="18" r="6" fill="#27c93f" />
      <text x="82" y="22" font-family="Courier New, monospace" fontSize="12" fill="#6e7681">
        root@netbreaker:~/lab21$ topology --render
      </text>
      <g data-link="R1:Fa0/0↔R2:Fa0/0">
        <line x1="265" y1="110" x2="315" y2="110" stroke="#4d5560" stroke-width="1.5"
          data-node-a="R1" data-iface-a="Fa0/0" data-node-b="R2" data-iface-b="Fa0/0" />
        <title>R1 Fa0/0 ↔ R2 Fa0/0</title>
      </g>
      <g data-link="R2:Fa0/1↔R3:Fa0/0">
        <line x1="455" y1="110" x2="505" y2="110" stroke="#4d5560" stroke-width="1.5"
          data-node-a="R2" data-iface-a="Fa0/1" data-node-b="R3" data-iface-b="Fa0/0" />
        <title>R2 Fa0/1 ↔ R3 Fa0/0</title>
      </g>
      <g data-link="R3:Fa0/1↔R1:Fa0/1">
        <line x1="505" y1="110" x2="265" y2="110" stroke="#4d5560" stroke-width="1.5"
          data-node-a="R3" data-iface-a="Fa0/1" data-node-b="R1" data-iface-b="Fa0/1" />
        <title>R3 Fa0/1 ↔ R1 Fa0/1</title>
      </g>
      <g data-link="R1:Gi1/1↔PC1:eth0">
        <line x1="246" y1="140" x2="359" y2="207" stroke="#4d5560" stroke-width="1.5"
          data-node-a="R1" data-iface-a="Gi1/1" data-node-b="PC1" data-iface-b="eth0" />
        <title>R1 Gi1/1 ↔ PC1 eth0</title>
      </g>
      <g data-link="R1:Gi1/2↔KALI:eth0">
        <line x1="195" y1="140" x2="195" y2="192" stroke="#4d5560" stroke-width="1.5"
          data-node-a="R1" data-iface-a="Gi1/2" data-node-b="KALI" data-iface-b="eth0" />
        <title>R1 Gi1/2 ↔ KALI eth0</title>
      </g>
      <g data-link="R2:Gi1/1↔PC2:eth0">
        <line x1="436" y1="140" x2="549" y2="207" stroke="#4d5560" stroke-width="1.5"
          data-node-a="R2" data-iface-a="Gi1/1" data-node-b="PC2" data-iface-b="eth0" />
        <title>R2 Gi1/1 ↔ PC2 eth0</title>
      </g>
      <g data-link="R3:Gi1/1↔PC3:eth0">
        <line x1="550" y1="140" x2="404" y2="312" stroke="#4d5560" stroke-width="1.5"
          data-node-a="R3" data-iface-a="Gi1/1" data-node-b="PC3" data-iface-b="eth0" />
        <title>R3 Gi1/1 ↔ PC3 eth0</title>
      </g>
      <g data-port="R1" data-iface="Fa0/0">
        <rect x="263" y="126" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="284" y="139" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Fa0/0</text>
        <title>R1 Fa0/0</title>
      </g>
      <g data-port="R1" data-iface="Fa0/1">
        <rect x="255" y="88" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="276" y="101" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Fa0/1</text>
        <title>R1 Fa0/1</title>
      </g>
      <g data-port="R1" data-iface="Gi1/1">
        <rect x="234" y="154" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="255" y="167" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Gi1/1</text>
        <title>R1 Gi1/1</title>
      </g>
      <g data-port="R1" data-iface="Gi1/2">
        <rect x="167" y="146" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="188" y="159" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Gi1/2</text>
        <title>R1 Gi1/2</title>
      </g>
      <g data-port="R2" data-iface="Fa0/0">
        <rect x="289" y="107" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="310" y="120" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Fa0/0</text>
        <title>R2 Fa0/0</title>
      </g>
      <g data-port="R2" data-iface="Fa0/1">
        <rect x="436" y="108" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="457" y="121" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Fa0/1</text>
        <title>R2 Fa0/1</title>
      </g>
      <g data-port="R2" data-iface="Gi1/1">
        <rect x="432" y="149" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="453" y="162" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Gi1/1</text>
        <title>R2 Gi1/1</title>
      </g>
      <g data-port="R3" data-iface="Fa0/0">
        <rect x="482" y="108" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="503" y="121" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Fa0/0</text>
        <title>R3 Fa0/0</title>
      </g>
      <g data-port="R3" data-iface="Fa0/1">
        <rect x="465" y="84" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="486" y="97" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Fa0/1</text>
        <title>R3 Fa0/1</title>
      </g>
      <g data-port="R3" data-iface="Gi1/1">
        <rect x="508" y="145" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="529" y="158" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Gi1/1</text>
        <title>R3 Gi1/1</title>
      </g>
      <g data-port="PC1" data-iface="eth0">
        <rect x="314" y="192" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="335" y="205" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">eth0</text>
        <title>PC1 eth0</title>
      </g>
      <g data-port="PC2" data-iface="eth0">
        <rect x="504" y="192" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="525" y="205" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">eth0</text>
        <title>PC2 eth0</title>
      </g>
      <g data-port="PC3" data-iface="eth0">
        <rect x="393" y="280" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="414" y="293" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">eth0</text>
        <title>PC3 eth0</title>
      </g>
      <g data-port="KALI" data-iface="eth0">
        <rect x="167" y="169" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="188" y="182" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">eth0</text>
        <title>KALI eth0</title>
      </g>
      <g data-node="R1" data-role="core">
        <rect x="125" y="80" width="140" height="60" rx="6" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
        <text x="195" y="116" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#e6edf3">R1</text>
        <text x="195" y="134" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">router</text>
        <title>R1</title>
      </g>
      <g data-node="R2" data-role="core">
        <rect x="315" y="80" width="140" height="60" rx="6" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
        <text x="385" y="116" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#e6edf3">R2</text>
        <text x="385" y="134" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">router</text>
        <title>R2</title>
      </g>
      <g data-node="R3" data-role="core">
        <rect x="505" y="80" width="140" height="60" rx="6" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
        <text x="575" y="116" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#e6edf3">R3</text>
        <text x="575" y="134" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">router</text>
        <title>R3</title>
      </g>
      <g data-node="PC1" data-role="host">
        <circle cx="385" cy="222" r="30" fill="#131a21" stroke="#22d3ee" stroke-width="1.5" />
        <text x="385" y="226" text-anchor="middle" font-family="Courier New, monospace" fontSize="13" fontWeight="700" fill="#67e8f9">PC1</text>
        <text x="385" y="240" text-anchor="middle" font-family="Courier New, monospace" fontSize="9" fill="#22d3ee">end host</text>
        <title>PC1</title>
      </g>
      <g data-node="PC2" data-role="host">
        <circle cx="575" cy="222" r="30" fill="#131a21" stroke="#22d3ee" stroke-width="1.5" />
        <text x="575" y="226" text-anchor="middle" font-family="Courier New, monospace" fontSize="13" fontWeight="700" fill="#67e8f9">PC2</text>
        <text x="575" y="240" text-anchor="middle" font-family="Courier New, monospace" fontSize="9" fill="#22d3ee">end host</text>
        <title>PC2</title>
      </g>
      <g data-node="PC3" data-role="host">
        <circle cx="385" cy="335" r="30" fill="#131a21" stroke="#22d3ee" stroke-width="1.5" />
        <text x="385" y="339" text-anchor="middle" font-family="Courier New, monospace" fontSize="13" fontWeight="700" fill="#67e8f9">PC3</text>
        <text x="385" y="353" text-anchor="middle" font-family="Courier New, monospace" fontSize="9" fill="#22d3ee">end host</text>
        <title>PC3</title>
      </g>
      <g data-node="KALI" data-role="attacker">
        <g filter="url(#glow)">
          <rect x="125" y="192" width="140" height="60" rx="6" fill="#1a0f11" stroke="#f85149" stroke-width="1.5" stroke-dasharray="5 3" />
        </g>
        <text x="195" y="228" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#ff7b72">KALI</text>
        <text x="195" y="246" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#f85149">attacker / observer</text>
        <title>KALI</title>
      </g>
      <line x1="30" y1="405" x2="690" y2="405" stroke="#22272e" stroke-width="1" />
      <text x="30" y="424" font-family="Courier New, monospace" fontSize="10" fill="#6e7681">// device_legend</text>

      <rect x="30" y="438" width="12" height="12" rx="2" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
      <text x="50" y="448" font-family="Courier New, monospace" fontSize="11" fill="#e6edf3">switch / router / firewall</text>

      <rect x="230" y="438" width="12" height="12" rx="2" fill="#131a21" stroke="#d29922" stroke-width="1.5" />
      <text x="250" y="448" font-family="Courier New, monospace" fontSize="11" fill="#d29922">hub — single collision domain</text>

      <circle cx="486" cy="444" r="6" fill="#131a21" stroke="#22d3ee" stroke-width="1.5" />
      <text x="500" y="448" font-family="Courier New, monospace" fontSize="11" fill="#67e8f9">end host</text>

      <rect x="580" y="438" width="12" height="12" rx="2" fill="#1a0f11" stroke="#f85149" stroke-width="1.5" stroke-dasharray="3 2" />
      <text x="600" y="448" font-family="Courier New, monospace" fontSize="11" fill="#ff7b72">observer / attacker</text>

      <text x="30" y="475" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">
        initial_build: R1(Fa0/0)→R2(Fa0/0) · R2(Fa0/1)→R3(Fa0/0) · R3(Fa0/1)→R1(Fa0/1) · R1(Gi1/1)→PC1(eth0) · R1(Gi1/2)→KA...
      </text>
    </svg>
$md$)
WHERE lab_id = 21;

UPDATE lab_topologies SET svg_large = verify_replace(svg_large,
  $md$<svg viewBox="0 0 600 240" font-family="monospace"><rect x="30" y="14" width="160" height="46" rx="8" fill="#fff" stroke="#14161a" stroke-width="2"/><text x="110" y="38" text-anchor="middle" font-size="13" font-weight="700">SW1 · VTP Server</text><text x="110" y="54" text-anchor="middle" font-size="8" fill="#6b7480">revision 5 · VLANs 1,10,20</text><rect x="220" y="14" width="160" height="46" rx="8" fill="#fff" stroke="#6b7480" stroke-width="2"/><text x="300" y="38" text-anchor="middle" font-size="13" font-weight="700">SW2 · VTP Client</text><text x="300" y="54" text-anchor="middle" font-size="8" fill="#6b7480">revision 5 · learns VLANs</text><rect x="410" y="14" width="160" height="46" rx="8" fill="#fff" stroke="#6b7480" stroke-width="2"/><text x="490" y="38" text-anchor="middle" font-size="13" font-weight="700">SW3 · Transparent</text><text x="490" y="54" text-anchor="middle" font-size="8" fill="#6b7480">same VTP domain · forwards</text><line x1="190" y1="37" x2="220" y2="37" stroke="#6b7480" stroke-width="2"/><line x1="380" y1="37" x2="410" y2="37" stroke="#6b7480" stroke-width="2"/><rect x="30" y="130" width="160" height="46" rx="8" fill="#fff" stroke="#2563eb" stroke-width="2"/><text x="110" y="156" text-anchor="middle" font-size="12" fill="#2563eb" font-weight="600">PC1 · VLAN 10</text><rect x="410" y="130" width="160" height="46" rx="8" fill="#fff" stroke="#2563eb" stroke-width="2"/><text x="490" y="156" text-anchor="middle" font-size="12" fill="#2563eb" font-weight="600">PC2 · VLAN 20</text><rect x="200" y="190" width="200" height="40" rx="8" fill="#fff" stroke="#e5484d" stroke-width="2"/><text x="300" y="214" text-anchor="middle" font-size="11" fill="#e5484d" font-weight="600">KALI · VTP poison · DTP hijack</text><line x1="110" y1="130" x2="110" y2="60" stroke="#2563eb" stroke-width="2"/><line x1="490" y1="130" x2="490" y2="60" stroke="#2563eb" stroke-width="2"/><line x1="300" y1="190" x2="220" y2="60" stroke="#e5484d" stroke-width="2" stroke-dasharray="6 5"/></svg>$md$,
  $md$<svg
      width="100%"
      viewBox="0 0 720 490"
      xmlns="http://www.w3.org/2000/svg"
      role="img"
      aria-label="NetBreaker Lab 24 topology: SW1(Et0/0)→SW2(Et0/0), KALI(eth0)→SW1(Et0/1), PC1(eth0)→SW1(Et0/2)"
    >
      <defs>
        <pattern id="grid" width="24" height="24" patternUnits="userSpaceOnUse">
          <path d="M24 0H0V24" fill="none" stroke="#1b2129" stroke-width="1" />
        </pattern>
        <filter id="glow" x="-40%" y="-40%" width="180%" height="180%">
          <feGaussianBlur stdDeviation="3" result="blur" />
          <feMerge>
            <feMergeNode in="blur" />
            <feMergeNode in="SourceGraphic" />
          </feMerge>
        </filter>
      </defs>

      <rect x="0" y="0" width="720" height="490" rx="10" fill="#0b0f14" />
      <rect x="1" y="37" width="718" height="451" fill="url(#grid)" />
      <rect x="0.5" y="0.5" width="719" height="489" rx="10" fill="none" stroke="#22272e" stroke-width="1" />

      <line x1="0" y1="36" x2="720" y2="36" stroke="#22272e" stroke-width="1" />
      <circle cx="20" cy="18" r="6" fill="#ff5f56" />
      <circle cx="40" cy="18" r="6" fill="#ffbd2e" />
      <circle cx="60" cy="18" r="6" fill="#27c93f" />
      <text x="82" y="22" font-family="Courier New, monospace" fontSize="12" fill="#6e7681">
        root@netbreaker:~/lab24$ topology --render
      </text>
      <g data-link="SW1:Et0/0↔SW2:Et0/0">
        <line x1="180" y1="85" x2="230" y2="85" stroke="#4d5560" stroke-width="1.5"
          data-node-a="SW1" data-iface-a="Et0/0" data-node-b="SW2" data-iface-b="Et0/0" />
        <title>SW1 Et0/0 ↔ SW2 Et0/0</title>
      </g>
      <g data-link="KALI:eth0↔SW1:Et0/1">
        <line x1="267" y1="228" x2="143" y2="115" stroke="#4d5560" stroke-width="1.5"
          data-node-a="KALI" data-iface-a="eth0" data-node-b="SW1" data-iface-b="Et0/1" />
        <title>KALI eth0 ↔ SW1 Et0/1</title>
      </g>
      <g data-link="PC1:eth0↔SW1:Et0/2">
        <line x1="110" y1="171" x2="110" y2="115" stroke="#4d5560" stroke-width="1.5"
          data-node-a="PC1" data-iface-a="eth0" data-node-b="SW1" data-iface-b="Et0/2" />
        <title>PC1 eth0 ↔ SW1 Et0/2</title>
      </g>
      <g data-port="SW1" data-iface="Et0/0">
        <rect x="162" y="83" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="183" y="96" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/0</text>
        <title>SW1 Et0/0</title>
      </g>
      <g data-port="SW1" data-iface="Et0/1">
        <rect x="144" y="117" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="165" y="130" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/1</text>
        <title>SW1 Et0/1</title>
      </g>
      <g data-port="SW1" data-iface="Et0/2">
        <rect x="96" y="116" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="117" y="129" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/2</text>
        <title>SW1 Et0/2</title>
      </g>
      <g data-port="SW2" data-iface="Et0/0">
        <rect x="206" y="83" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="227" y="96" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/0</text>
        <title>SW2 Et0/0</title>
      </g>
      <g data-port="PC1" data-iface="eth0">
        <rect x="96" y="152" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="117" y="165" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">eth0</text>
        <title>PC1 eth0</title>
      </g>
      <g data-port="KALI" data-iface="eth0">
        <rect x="233" y="198" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="254" y="211" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">eth0</text>
        <title>KALI eth0</title>
      </g>
      <g data-node="SW1" data-role="core">
        <rect x="40" y="55" width="140" height="60" rx="6" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
        <text x="110" y="91" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#e6edf3">SW1</text>
        <text x="110" y="109" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">l2 switch</text>
        <title>SW1</title>
      </g>
      <g data-node="SW2" data-role="core">
        <rect x="230" y="55" width="140" height="60" rx="6" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
        <text x="300" y="91" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#e6edf3">SW2</text>
        <text x="300" y="109" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">l2 switch</text>
        <title>SW2</title>
      </g>
      <g data-node="PC1" data-role="host">
        <circle cx="110" cy="201" r="30" fill="#131a21" stroke="#22d3ee" stroke-width="1.5" />
        <text x="110" y="205" text-anchor="middle" font-family="Courier New, monospace" fontSize="13" fontWeight="700" fill="#67e8f9">PC1</text>
        <text x="110" y="219" text-anchor="middle" font-family="Courier New, monospace" fontSize="9" fill="#22d3ee">end host</text>
        <title>PC1</title>
      </g>
      <g data-node="KALI" data-role="attacker">
        <g filter="url(#glow)">
          <rect x="230" y="228" width="140" height="60" rx="6" fill="#1a0f11" stroke="#f85149" stroke-width="1.5" stroke-dasharray="5 3" />
        </g>
        <text x="300" y="264" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#ff7b72">KALI</text>
        <text x="300" y="282" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#f85149">attacker / observer</text>
        <title>KALI</title>
      </g>
      <line x1="30" y1="405" x2="690" y2="405" stroke="#22272e" stroke-width="1" />
      <text x="30" y="424" font-family="Courier New, monospace" fontSize="10" fill="#6e7681">// device_legend</text>

      <rect x="30" y="438" width="12" height="12" rx="2" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
      <text x="50" y="448" font-family="Courier New, monospace" fontSize="11" fill="#e6edf3">switch / router / firewall</text>

      <rect x="230" y="438" width="12" height="12" rx="2" fill="#131a21" stroke="#d29922" stroke-width="1.5" />
      <text x="250" y="448" font-family="Courier New, monospace" fontSize="11" fill="#d29922">hub — single collision domain</text>

      <circle cx="486" cy="444" r="6" fill="#131a21" stroke="#22d3ee" stroke-width="1.5" />
      <text x="500" y="448" font-family="Courier New, monospace" fontSize="11" fill="#67e8f9">end host</text>

      <rect x="580" y="438" width="12" height="12" rx="2" fill="#1a0f11" stroke="#f85149" stroke-width="1.5" stroke-dasharray="3 2" />
      <text x="600" y="448" font-family="Courier New, monospace" fontSize="11" fill="#ff7b72">observer / attacker</text>

      <text x="30" y="475" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">
        initial_build: SW1(Et0/0)→SW2(Et0/0) · KALI(eth0)→SW1(Et0/1) · PC1(eth0)→SW1(Et0/2)
      </text>
    </svg>
$md$)
WHERE lab_id = 24;

UPDATE lab_topologies SET svg_large = verify_replace(svg_large,
  $md$<svg viewBox="0 0 550 210" font-family="monospace">
  <rect x="30" y="20" width="180" height="50" rx="10" fill="#fff" stroke="#6b7480" stroke-width="2"/>
  <text x="120" y="46" text-anchor="middle" font-size="14" font-weight="700">SW1</text>
  <text x="120" y="62" text-anchor="middle" font-size="9" fill="#6b7480">Gi0/23 + Gi0/24 → Po1</text>
  <rect x="310" y="20" width="180" height="50" rx="10" fill="#fff" stroke="#6b7480" stroke-width="2"/>
  <text x="400" y="46" text-anchor="middle" font-size="14" font-weight="700">SW2</text>
  <text x="400" y="62" text-anchor="middle" font-size="9" fill="#6b7480">LACP active</text>
  <line x1="210" y1="45" x2="310" y2="45" stroke="#2563eb" stroke-width="2.5"/>
  <line x1="210" y1="35" x2="310" y2="35" stroke="#2563eb" stroke-width="2.5"/>
  <line x1="210" y1="55" x2="310" y2="55" stroke="#2563eb" stroke-width="2.5"/>
  <text x="270" y="28" font-size="8" fill="#2563eb">Po1</text>
  <rect x="170" y="140" width="180" height="40" rx="8" fill="#fff" stroke="#e5484d" stroke-width="2"/>
  <text x="260" y="164" text-anchor="middle" font-size="11" fill="#e5484d" font-weight="600">KALI · LACP spoof</text>
  <line x1="260" y1="140" x2="170" y2="70" stroke="#e5484d" stroke-width="2" stroke-dasharray="6 5"/>
  <rect x="30" y="140" width="100" height="40" rx="6" fill="#fff" stroke="#2563eb" stroke-width="1.5"/>
  <text x="80" y="164" text-anchor="middle" font-size="11" fill="#2563eb" font-weight="600">PC1</text>
  <line x1="80" y1="140" x2="120" y2="70" stroke="#2563eb" stroke-width="2"/>
</svg>$md$,
  $md$<svg
      width="100%"
      viewBox="0 0 720 490"
      xmlns="http://www.w3.org/2000/svg"
      role="img"
      aria-label="NetBreaker Lab 26 topology: SW1(Et0/0)→SW2(Et0/0), SW1(Et0/1)→SW2(Et0/1), KALI(eth0)→SW1(Et0/2), PC1(eth0)→SW1(Et0/3)"
    >
      <defs>
        <pattern id="grid" width="24" height="24" patternUnits="userSpaceOnUse">
          <path d="M24 0H0V24" fill="none" stroke="#1b2129" stroke-width="1" />
        </pattern>
        <filter id="glow" x="-40%" y="-40%" width="180%" height="180%">
          <feGaussianBlur stdDeviation="3" result="blur" />
          <feMerge>
            <feMergeNode in="blur" />
            <feMergeNode in="SourceGraphic" />
          </feMerge>
        </filter>
      </defs>

      <rect x="0" y="0" width="720" height="490" rx="10" fill="#0b0f14" />
      <rect x="1" y="37" width="718" height="451" fill="url(#grid)" />
      <rect x="0.5" y="0.5" width="719" height="489" rx="10" fill="none" stroke="#22272e" stroke-width="1" />

      <line x1="0" y1="36" x2="720" y2="36" stroke="#22272e" stroke-width="1" />
      <circle cx="20" cy="18" r="6" fill="#ff5f56" />
      <circle cx="40" cy="18" r="6" fill="#ffbd2e" />
      <circle cx="60" cy="18" r="6" fill="#27c93f" />
      <text x="82" y="22" font-family="Courier New, monospace" fontSize="12" fill="#6e7681">
        root@netbreaker:~/lab26$ topology --render
      </text>
      <g data-link="SW1:Et0/0↔SW2:Et0/0">
        <line x1="190" y1="76" x2="330" y2="76" stroke="#4d5560" stroke-width="1.5"
          data-node-a="SW1" data-iface-a="Et0/0" data-node-b="SW2" data-iface-b="Et0/0" />
        <title>SW1 Et0/0 ↔ SW2 Et0/0</title>
      </g>
      <g data-link="SW1:Et0/1↔SW2:Et0/1">
        <line x1="190" y1="94" x2="330" y2="94" stroke="#4d5560" stroke-width="1.5"
          data-node-a="SW1" data-iface-a="Et0/1" data-node-b="SW2" data-iface-b="Et0/1" />
        <title>SW1 Et0/1 ↔ SW2 Et0/1</title>
      </g>
      <g data-link="KALI:eth0↔SW1:Et0/2">
        <line x1="223" y1="170" x2="157" y2="115" stroke="#4d5560" stroke-width="1.5"
          data-node-a="KALI" data-iface-a="eth0" data-node-b="SW1" data-iface-b="Et0/2" />
        <title>KALI eth0 ↔ SW1 Et0/2</title>
      </g>
      <g data-link="PC1:eth0↔SW1:Et0/3">
        <line x1="90" y1="172" x2="110" y2="115" stroke="#4d5560" stroke-width="1.5"
          data-node-a="PC1" data-iface-a="eth0" data-node-b="SW1" data-iface-b="Et0/3" />
        <title>PC1 eth0 ↔ SW1 Et0/3</title>
      </g>
      <g data-port="SW1" data-iface="Et0/0">
        <rect x="193" y="74" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="214" y="87" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/0</text>
        <title>SW1 Et0/0</title>
      </g>
      <g data-port="SW1" data-iface="Et0/1">
        <rect x="184" y="101" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="205" y="114" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/1</text>
        <title>SW1 Et0/1</title>
      </g>
      <g data-port="SW1" data-iface="Et0/2">
        <rect x="156" y="120" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="177" y="133" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/2</text>
        <title>SW1 Et0/2</title>
      </g>
      <g data-port="SW1" data-iface="Et0/3">
        <rect x="93" y="116" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="114" y="129" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/3</text>
        <title>SW1 Et0/3</title>
      </g>
      <g data-port="SW2" data-iface="Et0/0">
        <rect x="285" y="92" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="306" y="105" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/0</text>
        <title>SW2 Et0/0</title>
      </g>
      <g data-port="SW2" data-iface="Et0/1">
        <rect x="288" y="64" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="309" y="77" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/1</text>
        <title>SW2 Et0/1</title>
      </g>
      <g data-port="PC1" data-iface="eth0">
        <rect x="78" y="157" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="99" y="170" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">eth0</text>
        <title>PC1 eth0</title>
      </g>
      <g data-port="KALI" data-iface="eth0">
        <rect x="188" y="140" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="209" y="153" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">eth0</text>
        <title>KALI eth0</title>
      </g>
      <g data-node="SW1" data-role="core">
        <rect x="50" y="55" width="140" height="60" rx="6" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
        <text x="120" y="91" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#e6edf3">SW1</text>
        <text x="120" y="109" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">l2 switch</text>
        <title>SW1</title>
      </g>
      <g data-node="SW2" data-role="core">
        <rect x="330" y="55" width="140" height="60" rx="6" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
        <text x="400" y="91" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#e6edf3">SW2</text>
        <text x="400" y="109" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">l2 switch</text>
        <title>SW2</title>
      </g>
      <g data-node="PC1" data-role="host">
        <circle cx="80" cy="200" r="30" fill="#131a21" stroke="#22d3ee" stroke-width="1.5" />
        <text x="80" y="204" text-anchor="middle" font-family="Courier New, monospace" fontSize="13" fontWeight="700" fill="#67e8f9">PC1</text>
        <text x="80" y="218" text-anchor="middle" font-family="Courier New, monospace" fontSize="9" fill="#22d3ee">end host</text>
        <title>PC1</title>
      </g>
      <g data-node="KALI" data-role="attacker">
        <g filter="url(#glow)">
          <rect x="190" y="170" width="140" height="60" rx="6" fill="#1a0f11" stroke="#f85149" stroke-width="1.5" stroke-dasharray="5 3" />
        </g>
        <text x="260" y="206" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#ff7b72">KALI</text>
        <text x="260" y="224" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#f85149">attacker / observer</text>
        <title>KALI</title>
      </g>
      <line x1="30" y1="405" x2="690" y2="405" stroke="#22272e" stroke-width="1" />
      <text x="30" y="424" font-family="Courier New, monospace" fontSize="10" fill="#6e7681">// device_legend</text>

      <rect x="30" y="438" width="12" height="12" rx="2" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
      <text x="50" y="448" font-family="Courier New, monospace" fontSize="11" fill="#e6edf3">switch / router / firewall</text>

      <rect x="230" y="438" width="12" height="12" rx="2" fill="#131a21" stroke="#d29922" stroke-width="1.5" />
      <text x="250" y="448" font-family="Courier New, monospace" fontSize="11" fill="#d29922">hub — single collision domain</text>

      <circle cx="486" cy="444" r="6" fill="#131a21" stroke="#22d3ee" stroke-width="1.5" />
      <text x="500" y="448" font-family="Courier New, monospace" fontSize="11" fill="#67e8f9">end host</text>

      <rect x="580" y="438" width="12" height="12" rx="2" fill="#1a0f11" stroke="#f85149" stroke-width="1.5" stroke-dasharray="3 2" />
      <text x="600" y="448" font-family="Courier New, monospace" fontSize="11" fill="#ff7b72">observer / attacker</text>

      <text x="30" y="475" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">
        initial_build: SW1(Et0/0)→SW2(Et0/0) · SW1(Et0/1)→SW2(Et0/1) · KALI(eth0)→SW1(Et0/2) · PC1(eth0)→SW1(Et0/3)
      </text>
    </svg>
$md$)
WHERE lab_id = 26;

UPDATE lab_topologies SET svg_large = verify_replace(svg_large,
  $md$<svg viewBox="0 0 600 220" font-family="monospace"><rect x="20" y="14" width="160" height="46" rx="8" fill="#fff" stroke="#14161a" stroke-width="2"/><text x="100" y="38" text-anchor="middle" font-size="13" font-weight="700">R1 · RIP</text><text x="100" y="54" text-anchor="middle" font-size="8" fill="#6b7480">learning from R2+R3</text><rect x="220" y="14" width="160" height="46" rx="8" fill="#fff" stroke="#14161a" stroke-width="2"/><text x="300" y="38" text-anchor="middle" font-size="13" font-weight="700">R2 · RIP</text><text x="300" y="54" text-anchor="middle" font-size="8" fill="#6b7480">redistributes</text><rect x="420" y="14" width="160" height="46" rx="8" fill="#fff" stroke="#14161a" stroke-width="2"/><text x="500" y="38" text-anchor="middle" font-size="13" font-weight="700">R3 · RIP</text><text x="500" y="54" text-anchor="middle" font-size="8" fill="#6b7480">redistributes</text><line x1="180" y1="37" x2="220" y2="37" stroke="#2563eb" stroke-width="2"/><line x1="380" y1="37" x2="420" y2="37" stroke="#2563eb" stroke-width="2"/><rect x="160" y="140" width="280" height="50" rx="10" fill="#fff" stroke="#e5484d" stroke-width="2"/><text x="300" y="166" text-anchor="middle" font-size="13" fill="#e5484d" font-weight="700">KALI · FRR Rogue RIP</text><text x="300" y="182" text-anchor="middle" font-size="9" fill="#6b7480">injecting 0.0.0.0/0 · metric 1</text><line x1="180" y1="140" x2="140" y2="60" stroke="#e5484d" stroke-width="2" stroke-dasharray="6 5"/></svg>$md$,
  $md$<svg
      width="100%"
      viewBox="0 0 720 490"
      xmlns="http://www.w3.org/2000/svg"
      role="img"
      aria-label="NetBreaker Lab 27 topology: R1(Fa0/0)→SW1(Et0/0), R1(Fa0/1)→R2(Fa0/0), R2(Fa0/1)→R3(Fa0/0), R3(Fa0/1)→PC2(eth0), PC1(eth0)→SW1(Et0/1), KALI(eth0)→SW1(Et0/2)"
    >
      <defs>
        <pattern id="grid" width="24" height="24" patternUnits="userSpaceOnUse">
          <path d="M24 0H0V24" fill="none" stroke="#1b2129" stroke-width="1" />
        </pattern>
        <filter id="glow" x="-40%" y="-40%" width="180%" height="180%">
          <feGaussianBlur stdDeviation="3" result="blur" />
          <feMerge>
            <feMergeNode in="blur" />
            <feMergeNode in="SourceGraphic" />
          </feMerge>
        </filter>
      </defs>

      <rect x="0" y="0" width="720" height="490" rx="10" fill="#0b0f14" />
      <rect x="1" y="37" width="718" height="451" fill="url(#grid)" />
      <rect x="0.5" y="0.5" width="719" height="489" rx="10" fill="none" stroke="#22272e" stroke-width="1" />

      <line x1="0" y1="36" x2="720" y2="36" stroke="#22272e" stroke-width="1" />
      <circle cx="20" cy="18" r="6" fill="#ff5f56" />
      <circle cx="40" cy="18" r="6" fill="#ffbd2e" />
      <circle cx="60" cy="18" r="6" fill="#27c93f" />
      <text x="82" y="22" font-family="Courier New, monospace" fontSize="12" fill="#6e7681">
        root@netbreaker:~/lab27$ topology --render
      </text>
      <g data-link="R1:Fa0/0↔SW1:Et0/0">
        <line x1="246" y1="140" x2="334" y2="192" stroke="#4d5560" stroke-width="1.5"
          data-node-a="R1" data-iface-a="Fa0/0" data-node-b="SW1" data-iface-b="Et0/0" />
        <title>R1 Fa0/0 ↔ SW1 Et0/0</title>
      </g>
      <g data-link="R1:Fa0/1↔R2:Fa0/0">
        <line x1="265" y1="110" x2="315" y2="110" stroke="#4d5560" stroke-width="1.5"
          data-node-a="R1" data-iface-a="Fa0/1" data-node-b="R2" data-iface-b="Fa0/0" />
        <title>R1 Fa0/1 ↔ R2 Fa0/0</title>
      </g>
      <g data-link="R2:Fa0/1↔R3:Fa0/0">
        <line x1="455" y1="110" x2="505" y2="110" stroke="#4d5560" stroke-width="1.5"
          data-node-a="R2" data-iface-a="Fa0/1" data-node-b="R3" data-iface-b="Fa0/0" />
        <title>R2 Fa0/1 ↔ R3 Fa0/0</title>
      </g>
      <g data-link="R3:Fa0/1↔PC2:eth0">
        <line x1="575" y1="140" x2="575" y2="305" stroke="#4d5560" stroke-width="1.5"
          data-node-a="R3" data-iface-a="Fa0/1" data-node-b="PC2" data-iface-b="eth0" />
        <title>R3 Fa0/1 ↔ PC2 eth0</title>
      </g>
      <g data-link="PC1:eth0↔SW1:Et0/1">
        <line x1="385" y1="305" x2="385" y2="252" stroke="#4d5560" stroke-width="1.5"
          data-node-a="PC1" data-iface-a="eth0" data-node-b="SW1" data-iface-b="Et0/1" />
        <title>PC1 eth0 ↔ SW1 Et0/1</title>
      </g>
      <g data-link="KALI:eth0↔SW1:Et0/2">
        <line x1="246" y1="305" x2="334" y2="252" stroke="#4d5560" stroke-width="1.5"
          data-node-a="KALI" data-iface-a="eth0" data-node-b="SW1" data-iface-b="Et0/2" />
        <title>KALI eth0 ↔ SW1 Et0/2</title>
      </g>
      <g data-port="R1" data-iface="Fa0/0">
        <rect x="242" y="149" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="263" y="162" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Fa0/0</text>
        <title>R1 Fa0/0</title>
      </g>
      <g data-port="R1" data-iface="Fa0/1">
        <rect x="247" y="108" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="268" y="121" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Fa0/1</text>
        <title>R1 Fa0/1</title>
      </g>
      <g data-port="R2" data-iface="Fa0/0">
        <rect x="291" y="108" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="312" y="121" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Fa0/0</text>
        <title>R2 Fa0/0</title>
      </g>
      <g data-port="R2" data-iface="Fa0/1">
        <rect x="437" y="108" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="458" y="121" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Fa0/1</text>
        <title>R2 Fa0/1</title>
      </g>
      <g data-port="R3" data-iface="Fa0/0">
        <rect x="481" y="108" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="502" y="121" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Fa0/0</text>
        <title>R3 Fa0/0</title>
      </g>
      <g data-port="R3" data-iface="Fa0/1">
        <rect x="547" y="155" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="568" y="168" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Fa0/1</text>
        <title>R3 Fa0/1</title>
      </g>
      <g data-port="SW1" data-iface="Et0/0">
        <rect x="289" y="177" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="310" y="190" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/0</text>
        <title>SW1 Et0/0</title>
      </g>
      <g data-port="SW1" data-iface="Et0/1">
        <rect x="371" y="253" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="392" y="266" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/1</text>
        <title>SW1 Et0/1</title>
      </g>
      <g data-port="SW1" data-iface="Et0/2">
        <rect x="296" y="262" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="317" y="275" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/2</text>
        <title>SW1 Et0/2</title>
      </g>
      <g data-port="PC1" data-iface="eth0">
        <rect x="371" y="286" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="392" y="299" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">eth0</text>
        <title>PC1 eth0</title>
      </g>
      <g data-port="PC2" data-iface="eth0">
        <rect x="547" y="272" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="568" y="285" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">eth0</text>
        <title>PC2 eth0</title>
      </g>
      <g data-port="KALI" data-iface="eth0">
        <rect x="249" y="290" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="270" y="303" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">eth0</text>
        <title>KALI eth0</title>
      </g>
      <g data-node="R1" data-role="core">
        <rect x="125" y="80" width="140" height="60" rx="6" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
        <text x="195" y="116" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#e6edf3">R1</text>
        <text x="195" y="134" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">router</text>
        <title>R1</title>
      </g>
      <g data-node="R2" data-role="core">
        <rect x="315" y="80" width="140" height="60" rx="6" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
        <text x="385" y="116" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#e6edf3">R2</text>
        <text x="385" y="134" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">router</text>
        <title>R2</title>
      </g>
      <g data-node="R3" data-role="core">
        <rect x="505" y="80" width="140" height="60" rx="6" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
        <text x="575" y="116" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#e6edf3">R3</text>
        <text x="575" y="134" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">router</text>
        <title>R3</title>
      </g>
      <g data-node="SW1" data-role="core">
        <rect x="315" y="192" width="140" height="60" rx="6" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
        <text x="385" y="228" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#e6edf3">SW1</text>
        <text x="385" y="246" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">l2 switch</text>
        <title>SW1</title>
      </g>
      <g data-node="PC1" data-role="host">
        <circle cx="385" cy="335" r="30" fill="#131a21" stroke="#22d3ee" stroke-width="1.5" />
        <text x="385" y="339" text-anchor="middle" font-family="Courier New, monospace" fontSize="13" fontWeight="700" fill="#67e8f9">PC1</text>
        <text x="385" y="353" text-anchor="middle" font-family="Courier New, monospace" fontSize="9" fill="#22d3ee">end host</text>
        <title>PC1</title>
      </g>
      <g data-node="PC2" data-role="host">
        <circle cx="575" cy="335" r="30" fill="#131a21" stroke="#22d3ee" stroke-width="1.5" />
        <text x="575" y="339" text-anchor="middle" font-family="Courier New, monospace" fontSize="13" fontWeight="700" fill="#67e8f9">PC2</text>
        <text x="575" y="353" text-anchor="middle" font-family="Courier New, monospace" fontSize="9" fill="#22d3ee">end host</text>
        <title>PC2</title>
      </g>
      <g data-node="KALI" data-role="attacker">
        <g filter="url(#glow)">
          <rect x="125" y="305" width="140" height="60" rx="6" fill="#1a0f11" stroke="#f85149" stroke-width="1.5" stroke-dasharray="5 3" />
        </g>
        <text x="195" y="341" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#ff7b72">KALI</text>
        <text x="195" y="359" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#f85149">attacker / observer</text>
        <title>KALI</title>
      </g>
      <line x1="30" y1="405" x2="690" y2="405" stroke="#22272e" stroke-width="1" />
      <text x="30" y="424" font-family="Courier New, monospace" fontSize="10" fill="#6e7681">// device_legend</text>

      <rect x="30" y="438" width="12" height="12" rx="2" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
      <text x="50" y="448" font-family="Courier New, monospace" fontSize="11" fill="#e6edf3">switch / router / firewall</text>

      <rect x="230" y="438" width="12" height="12" rx="2" fill="#131a21" stroke="#d29922" stroke-width="1.5" />
      <text x="250" y="448" font-family="Courier New, monospace" fontSize="11" fill="#d29922">hub — single collision domain</text>

      <circle cx="486" cy="444" r="6" fill="#131a21" stroke="#22d3ee" stroke-width="1.5" />
      <text x="500" y="448" font-family="Courier New, monospace" fontSize="11" fill="#67e8f9">end host</text>

      <rect x="580" y="438" width="12" height="12" rx="2" fill="#1a0f11" stroke="#f85149" stroke-width="1.5" stroke-dasharray="3 2" />
      <text x="600" y="448" font-family="Courier New, monospace" fontSize="11" fill="#ff7b72">observer / attacker</text>

      <text x="30" y="475" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">
        initial_build: R1(Fa0/0)→SW1(Et0/0) · R1(Fa0/1)→R2(Fa0/0) · R2(Fa0/1)→R3(Fa0/0) · R3(Fa0/1)→PC2(eth0) · PC1(eth0)→S...
      </text>
    </svg>
$md$)
WHERE lab_id = 27;

UPDATE lab_topologies SET svg_large = verify_replace(svg_large,
  $md$<svg viewBox="0 0 600 220" font-family="monospace"><rect x="180" y="14" width="240" height="50" rx="10" fill="#fff" stroke="#14161a" stroke-width="2"/><text x="300" y="40" text-anchor="middle" font-size="14" font-weight="700">R1 · IPv6 Gateway</text><text x="300" y="56" text-anchor="middle" font-size="9" fill="#6b7480">2001:db8:1::1/64 · RA every 200s</text><rect x="30" y="120" width="160" height="50" rx="10" fill="#fff" stroke="#2563eb" stroke-width="2"/><text x="110" y="146" text-anchor="middle" font-size="12" fill="#2563eb" font-weight="600">PC1 · SLAAC</text><text x="110" y="162" text-anchor="middle" font-size="8" fill="#6b7480">EUI-64 auto IP</text><rect x="410" y="120" width="160" height="50" rx="10" fill="#fff" stroke="#e5484d" stroke-width="2"/><text x="490" y="146" text-anchor="middle" font-size="12" fill="#e5484d" font-weight="600">KALI</text><text x="490" y="162" text-anchor="middle" font-size="8" fill="#6b7480">rogue RA · EUI-64 predict</text><line x1="110" y1="120" x2="210" y2="64" stroke="#2563eb" stroke-width="2"/><line x1="490" y1="120" x2="400" y2="64" stroke="#e5484d" stroke-width="2" stroke-dasharray="6 5"/></svg>$md$,
  $md$<svg
      width="100%"
      viewBox="0 0 720 490"
      xmlns="http://www.w3.org/2000/svg"
      role="img"
      aria-label="NetBreaker Lab 28 topology: R1(Fa0/0)→SW1(Et0/0), R1(Fa0/1)→R2(Fa0/0), R2(Fa0/1)→PC2(eth0), PC1(eth0)→SW1(Et0/1), KALI(eth0)→SW1(Et0/2)"
    >
      <defs>
        <pattern id="grid" width="24" height="24" patternUnits="userSpaceOnUse">
          <path d="M24 0H0V24" fill="none" stroke="#1b2129" stroke-width="1" />
        </pattern>
        <filter id="glow" x="-40%" y="-40%" width="180%" height="180%">
          <feGaussianBlur stdDeviation="3" result="blur" />
          <feMerge>
            <feMergeNode in="blur" />
            <feMergeNode in="SourceGraphic" />
          </feMerge>
        </filter>
      </defs>

      <rect x="0" y="0" width="720" height="490" rx="10" fill="#0b0f14" />
      <rect x="1" y="37" width="718" height="451" fill="url(#grid)" />
      <rect x="0.5" y="0.5" width="719" height="489" rx="10" fill="none" stroke="#22272e" stroke-width="1" />

      <line x1="0" y1="36" x2="720" y2="36" stroke="#22272e" stroke-width="1" />
      <circle cx="20" cy="18" r="6" fill="#ff5f56" />
      <circle cx="40" cy="18" r="6" fill="#ffbd2e" />
      <circle cx="60" cy="18" r="6" fill="#27c93f" />
      <text x="82" y="22" font-family="Courier New, monospace" fontSize="12" fill="#6e7681">
        root@netbreaker:~/lab28$ topology --render
      </text>
      <g data-link="R1:Fa0/0↔SW1:Et0/0">
        <line x1="265" y1="110" x2="505" y2="110" stroke="#4d5560" stroke-width="1.5"
          data-node-a="R1" data-iface-a="Fa0/0" data-node-b="SW1" data-iface-b="Et0/0" />
        <title>R1 Fa0/0 ↔ SW1 Et0/0</title>
      </g>
      <g data-link="R1:Fa0/1↔R2:Fa0/0">
        <line x1="265" y1="110" x2="315" y2="110" stroke="#4d5560" stroke-width="1.5"
          data-node-a="R1" data-iface-a="Fa0/1" data-node-b="R2" data-iface-b="Fa0/0" />
        <title>R1 Fa0/1 ↔ R2 Fa0/0</title>
      </g>
      <g data-link="R2:Fa0/1↔PC2:eth0">
        <line x1="432" y1="140" x2="550" y2="214" stroke="#4d5560" stroke-width="1.5"
          data-node-a="R2" data-iface-a="Fa0/1" data-node-b="PC2" data-iface-b="eth0" />
        <title>R2 Fa0/1 ↔ PC2 eth0</title>
      </g>
      <g data-link="PC1:eth0↔SW1:Et0/1">
        <line x1="410" y1="214" x2="528" y2="140" stroke="#4d5560" stroke-width="1.5"
          data-node-a="PC1" data-iface-a="eth0" data-node-b="SW1" data-iface-b="Et0/1" />
        <title>PC1 eth0 ↔ SW1 Et0/1</title>
      </g>
      <g data-link="KALI:eth0↔SW1:Et0/2">
        <line x1="265" y1="208" x2="505" y2="132" stroke="#4d5560" stroke-width="1.5"
          data-node-a="KALI" data-iface-a="eth0" data-node-b="SW1" data-iface-b="Et0/2" />
        <title>KALI eth0 ↔ SW1 Et0/2</title>
      </g>
      <g data-port="R1" data-iface="Fa0/0">
        <rect x="281" y="81" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="302" y="94" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Fa0/0</text>
        <title>R1 Fa0/0</title>
      </g>
      <g data-port="R1" data-iface="Fa0/1">
        <rect x="246" y="141" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="267" y="154" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Fa0/1</text>
        <title>R1 Fa0/1</title>
      </g>
      <g data-port="R2" data-iface="Fa0/0">
        <rect x="274" y="111" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="295" y="124" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Fa0/0</text>
        <title>R2 Fa0/0</title>
      </g>
      <g data-port="R2" data-iface="Fa0/1">
        <rect x="424" y="152" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="445" y="165" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Fa0/1</text>
        <title>R2 Fa0/1</title>
      </g>
      <g data-port="SW1" data-iface="Et0/0">
        <rect x="459" y="100" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="480" y="113" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/0</text>
        <title>SW1 Et0/0</title>
      </g>
      <g data-port="SW1" data-iface="Et0/1">
        <rect x="490" y="150" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="511" y="163" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/1</text>
        <title>SW1 Et0/1</title>
      </g>
      <g data-port="SW1" data-iface="Et0/2">
        <rect x="465" y="131" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="486" y="144" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/2</text>
        <title>SW1 Et0/2</title>
      </g>
      <g data-port="PC1" data-iface="eth0">
        <rect x="413" y="198" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="434" y="211" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">eth0</text>
        <title>PC1 eth0</title>
      </g>
      <g data-port="PC2" data-iface="eth0">
        <rect x="505" y="198" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="526" y="211" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">eth0</text>
        <title>PC2 eth0</title>
      </g>
      <g data-port="KALI" data-iface="eth0">
        <rect x="269" y="198" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="290" y="211" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">eth0</text>
        <title>KALI eth0</title>
      </g>
      <g data-node="R1" data-role="core">
        <rect x="125" y="80" width="140" height="60" rx="6" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
        <text x="195" y="116" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#e6edf3">R1</text>
        <text x="195" y="134" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">router</text>
        <title>R1</title>
      </g>
      <g data-node="R2" data-role="core">
        <rect x="315" y="80" width="140" height="60" rx="6" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
        <text x="385" y="116" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#e6edf3">R2</text>
        <text x="385" y="134" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">router</text>
        <title>R2</title>
      </g>
      <g data-node="SW1" data-role="core">
        <rect x="505" y="80" width="140" height="60" rx="6" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
        <text x="575" y="116" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#e6edf3">SW1</text>
        <text x="575" y="134" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">l2 switch</text>
        <title>SW1</title>
      </g>
      <g data-node="PC1" data-role="host">
        <circle cx="385" cy="230" r="30" fill="#131a21" stroke="#22d3ee" stroke-width="1.5" />
        <text x="385" y="234" text-anchor="middle" font-family="Courier New, monospace" fontSize="13" fontWeight="700" fill="#67e8f9">PC1</text>
        <text x="385" y="248" text-anchor="middle" font-family="Courier New, monospace" fontSize="9" fill="#22d3ee">end host</text>
        <title>PC1</title>
      </g>
      <g data-node="PC2" data-role="host">
        <circle cx="575" cy="230" r="30" fill="#131a21" stroke="#22d3ee" stroke-width="1.5" />
        <text x="575" y="234" text-anchor="middle" font-family="Courier New, monospace" fontSize="13" fontWeight="700" fill="#67e8f9">PC2</text>
        <text x="575" y="248" text-anchor="middle" font-family="Courier New, monospace" fontSize="9" fill="#22d3ee">end host</text>
        <title>PC2</title>
      </g>
      <g data-node="KALI" data-role="attacker">
        <g filter="url(#glow)">
          <rect x="125" y="200" width="140" height="60" rx="6" fill="#1a0f11" stroke="#f85149" stroke-width="1.5" stroke-dasharray="5 3" />
        </g>
        <text x="195" y="236" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#ff7b72">KALI</text>
        <text x="195" y="254" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#f85149">attacker / observer</text>
        <title>KALI</title>
      </g>
      <line x1="30" y1="405" x2="690" y2="405" stroke="#22272e" stroke-width="1" />
      <text x="30" y="424" font-family="Courier New, monospace" fontSize="10" fill="#6e7681">// device_legend</text>

      <rect x="30" y="438" width="12" height="12" rx="2" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
      <text x="50" y="448" font-family="Courier New, monospace" fontSize="11" fill="#e6edf3">switch / router / firewall</text>

      <rect x="230" y="438" width="12" height="12" rx="2" fill="#131a21" stroke="#d29922" stroke-width="1.5" />
      <text x="250" y="448" font-family="Courier New, monospace" fontSize="11" fill="#d29922">hub — single collision domain</text>

      <circle cx="486" cy="444" r="6" fill="#131a21" stroke="#22d3ee" stroke-width="1.5" />
      <text x="500" y="448" font-family="Courier New, monospace" fontSize="11" fill="#67e8f9">end host</text>

      <rect x="580" y="438" width="12" height="12" rx="2" fill="#1a0f11" stroke="#f85149" stroke-width="1.5" stroke-dasharray="3 2" />
      <text x="600" y="448" font-family="Courier New, monospace" fontSize="11" fill="#ff7b72">observer / attacker</text>

      <text x="30" y="475" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">
        initial_build: R1(Fa0/0)→SW1(Et0/0) · R1(Fa0/1)→R2(Fa0/0) · R2(Fa0/1)→PC2(eth0) · PC1(eth0)→SW1(Et0/1) · KALI(eth0)...
      </text>
    </svg>
$md$)
WHERE lab_id = 28;

UPDATE lab_topologies SET svg_large = verify_replace(svg_large,
  $md$<svg viewBox="0 0 600 180" font-family="monospace"><rect x="30" y="20" width="180" height="50" rx="10" fill="#fff" stroke="#14161a" stroke-width="2"/><text x="120" y="46" text-anchor="middle" font-size="13" font-weight="700">R1 · NTP stratum 3</text><text x="120" y="62" text-anchor="middle" font-size="8" fill="#6b7480">authenticated NTP</text><rect x="250" y="20" width="160" height="50" rx="10" fill="#fff" stroke="#6b7480" stroke-width="2"/><text x="330" y="46" text-anchor="middle" font-size="13" font-weight="700">SW1 · client</text><text x="330" y="62" text-anchor="middle" font-size="8" fill="#6b7480">key 1 · MD5</text><line x1="210" y1="45" x2="250" y2="45" stroke="#6b7480" stroke-width="2"/><rect x="420" y="20" width="160" height="50" rx="10" fill="#fff" stroke="#e5484d" stroke-width="2"/><text x="500" y="46" text-anchor="middle" font-size="13" fill="#e5484d" font-weight="700">KALI · NTP spoof</text><text x="500" y="62" text-anchor="middle" font-size="8" fill="#6b7480">forged NTP · amplification</text><line x1="410" y1="45" x2="420" y2="45" stroke="#e5484d" stroke-width="2" stroke-dasharray="6 5"/></svg>$md$,
  $md$<svg
      width="100%"
      viewBox="0 0 720 490"
      xmlns="http://www.w3.org/2000/svg"
      role="img"
      aria-label="NetBreaker Lab 31 topology: R1(Fa0/0)→SW1(Et0/0), R1(Fa0/1)→R2(Fa0/0), KALI(eth0)→SW1(Et0/1), PC1(eth0)→SW1(Et0/2)"
    >
      <defs>
        <pattern id="grid" width="24" height="24" patternUnits="userSpaceOnUse">
          <path d="M24 0H0V24" fill="none" stroke="#1b2129" stroke-width="1" />
        </pattern>
        <filter id="glow" x="-40%" y="-40%" width="180%" height="180%">
          <feGaussianBlur stdDeviation="3" result="blur" />
          <feMerge>
            <feMergeNode in="blur" />
            <feMergeNode in="SourceGraphic" />
          </feMerge>
        </filter>
      </defs>

      <rect x="0" y="0" width="720" height="490" rx="10" fill="#0b0f14" />
      <rect x="1" y="37" width="718" height="451" fill="url(#grid)" />
      <rect x="0.5" y="0.5" width="719" height="489" rx="10" fill="none" stroke="#22272e" stroke-width="1" />

      <line x1="0" y1="36" x2="720" y2="36" stroke="#22272e" stroke-width="1" />
      <circle cx="20" cy="18" r="6" fill="#ff5f56" />
      <circle cx="40" cy="18" r="6" fill="#ffbd2e" />
      <circle cx="60" cy="18" r="6" fill="#27c93f" />
      <text x="82" y="22" font-family="Courier New, monospace" fontSize="12" fill="#6e7681">
        root@netbreaker:~/lab31$ topology --render
      </text>
      <g data-link="R1:Fa0/0↔SW1:Et0/0">
        <line x1="190" y1="85" x2="260" y2="85" stroke="#4d5560" stroke-width="1.5"
          data-node-a="R1" data-iface-a="Fa0/0" data-node-b="SW1" data-iface-b="Et0/0" />
        <title>R1 Fa0/0 ↔ SW1 Et0/0</title>
      </g>
      <g data-link="R1:Fa0/1↔R2:Fa0/0">
        <line x1="190" y1="102" x2="315" y2="133" stroke="#4d5560" stroke-width="1.5"
          data-node-a="R1" data-iface-a="Fa0/1" data-node-b="R2" data-iface-b="Fa0/0" />
        <title>R1 Fa0/1 ↔ R2 Fa0/0</title>
      </g>
      <g data-link="KALI:eth0↔SW1:Et0/1">
        <line x1="430" y1="85" x2="400" y2="85" stroke="#4d5560" stroke-width="1.5"
          data-node-a="KALI" data-iface-a="eth0" data-node-b="SW1" data-iface-b="Et0/1" />
        <title>KALI eth0 ↔ SW1 Et0/1</title>
      </g>
      <g data-link="PC1:eth0↔SW1:Et0/2">
        <line x1="376" y1="241" x2="339" y2="115" stroke="#4d5560" stroke-width="1.5"
          data-node-a="PC1" data-iface-a="eth0" data-node-b="SW1" data-iface-b="Et0/2" />
        <title>PC1 eth0 ↔ SW1 Et0/2</title>
      </g>
      <g data-port="R1" data-iface="Fa0/0">
        <rect x="178" y="83" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="199" y="96" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Fa0/0</text>
        <title>R1 Fa0/0</title>
      </g>
      <g data-port="R1" data-iface="Fa0/1">
        <rect x="188" y="110" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="209" y="123" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Fa0/1</text>
        <title>R1 Fa0/1</title>
      </g>
      <g data-port="R2" data-iface="Fa0/0">
        <rect x="269" y="125" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="290" y="138" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Fa0/0</text>
        <title>R2 Fa0/0</title>
      </g>
      <g data-port="SW1" data-iface="Et0/0">
        <rect x="230" y="83" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="251" y="96" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/0</text>
        <title>SW1 Et0/0</title>
      </g>
      <g data-port="SW1" data-iface="Et0/1">
        <rect x="419" y="69" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="440" y="82" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/1</text>
        <title>SW1 Et0/1</title>
      </g>
      <g data-port="SW1" data-iface="Et0/2">
        <rect x="331" y="127" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="352" y="140" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/2</text>
        <title>SW1 Et0/2</title>
      </g>
      <g data-port="PC1" data-iface="eth0">
        <rect x="355" y="207" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="376" y="220" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">eth0</text>
        <title>PC1 eth0</title>
      </g>
      <g data-port="KALI" data-iface="eth0">
        <rect x="369" y="69" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="390" y="82" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">eth0</text>
        <title>KALI eth0</title>
      </g>
      <g data-node="R1" data-role="core">
        <rect x="50" y="55" width="140" height="60" rx="6" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
        <text x="120" y="91" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#e6edf3">R1</text>
        <text x="120" y="109" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">router</text>
        <title>R1</title>
      </g>
      <g data-node="R2" data-role="core">
        <rect x="315" y="120" width="140" height="60" rx="6" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
        <text x="385" y="156" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#e6edf3">R2</text>
        <text x="385" y="174" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">router</text>
        <title>R2</title>
      </g>
      <g data-node="SW1" data-role="core">
        <rect x="260" y="55" width="140" height="60" rx="6" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
        <text x="330" y="91" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#e6edf3">SW1</text>
        <text x="330" y="109" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">l2 switch</text>
        <title>SW1</title>
      </g>
      <g data-node="PC1" data-role="host">
        <circle cx="385" cy="270" r="30" fill="#131a21" stroke="#22d3ee" stroke-width="1.5" />
        <text x="385" y="274" text-anchor="middle" font-family="Courier New, monospace" fontSize="13" fontWeight="700" fill="#67e8f9">PC1</text>
        <text x="385" y="288" text-anchor="middle" font-family="Courier New, monospace" fontSize="9" fill="#22d3ee">end host</text>
        <title>PC1</title>
      </g>
      <g data-node="KALI" data-role="attacker">
        <g filter="url(#glow)">
          <rect x="430" y="55" width="140" height="60" rx="6" fill="#1a0f11" stroke="#f85149" stroke-width="1.5" stroke-dasharray="5 3" />
        </g>
        <text x="500" y="91" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#ff7b72">KALI</text>
        <text x="500" y="109" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#f85149">attacker / observer</text>
        <title>KALI</title>
      </g>
      <line x1="30" y1="405" x2="690" y2="405" stroke="#22272e" stroke-width="1" />
      <text x="30" y="424" font-family="Courier New, monospace" fontSize="10" fill="#6e7681">// device_legend</text>

      <rect x="30" y="438" width="12" height="12" rx="2" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
      <text x="50" y="448" font-family="Courier New, monospace" fontSize="11" fill="#e6edf3">switch / router / firewall</text>

      <rect x="230" y="438" width="12" height="12" rx="2" fill="#131a21" stroke="#d29922" stroke-width="1.5" />
      <text x="250" y="448" font-family="Courier New, monospace" fontSize="11" fill="#d29922">hub — single collision domain</text>

      <circle cx="486" cy="444" r="6" fill="#131a21" stroke="#22d3ee" stroke-width="1.5" />
      <text x="500" y="448" font-family="Courier New, monospace" fontSize="11" fill="#67e8f9">end host</text>

      <rect x="580" y="438" width="12" height="12" rx="2" fill="#1a0f11" stroke="#f85149" stroke-width="1.5" stroke-dasharray="3 2" />
      <text x="600" y="448" font-family="Courier New, monospace" fontSize="11" fill="#ff7b72">observer / attacker</text>

      <text x="30" y="475" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">
        initial_build: R1(Fa0/0)→SW1(Et0/0) · R1(Fa0/1)→R2(Fa0/0) · KALI(eth0)→SW1(Et0/1) · PC1(eth0)→SW1(Et0/2)
      </text>
    </svg>
$md$)
WHERE lab_id = 31;

UPDATE lab_topologies SET svg_large = verify_replace(svg_large,
  $md$<svg viewBox="0 0 600 220" xmlns="http://www.w3.org/2000/svg" font-family="ui-monospace, monospace">
  <rect x="60" y="80" width="160" height="52" rx="9" fill="#fff" stroke="#14161a" stroke-width="1.5"/>
  <text x="140" y="103" text-anchor="middle" font-size="13" fill="#14161a" font-weight="600">R1</text>
  <text x="140" y="120" text-anchor="middle" font-size="9" fill="#6b7480">logging host + seq-numbers</text>
  <rect x="380" y="80" width="170" height="56" rx="9" fill="#fff" stroke="#c02a30" stroke-width="1.8"/>
  <text x="465" y="103" text-anchor="middle" font-size="13" fill="#c02a30" font-weight="700">KALI</text>
  <text x="465" y="120" text-anchor="middle" font-size="9" fill="#6b7480">rsyslog collector</text>
  <text x="465" y="132" text-anchor="middle" font-size="8" fill="#6b7480">+ forged UDP source</text>
  <line x1="220" y1="106" x2="380" y2="106" stroke="#6b7480" stroke-width="2.5"/>
  <text x="300" y="96" text-anchor="middle" font-size="9" fill="#6b7480">UDP 514 → TCP 6514</text>
</svg>$md$,
  $md$<svg
      width="100%"
      viewBox="0 0 720 490"
      xmlns="http://www.w3.org/2000/svg"
      role="img"
      aria-label="NetBreaker Lab 33 topology: R1(Fa0/0)→SW1(Et0/0), KALI(eth0)→SW1(Et0/1), PC1(eth0)→SW1(Et0/2)"
    >
      <defs>
        <pattern id="grid" width="24" height="24" patternUnits="userSpaceOnUse">
          <path d="M24 0H0V24" fill="none" stroke="#1b2129" stroke-width="1" />
        </pattern>
        <filter id="glow" x="-40%" y="-40%" width="180%" height="180%">
          <feGaussianBlur stdDeviation="3" result="blur" />
          <feMerge>
            <feMergeNode in="blur" />
            <feMergeNode in="SourceGraphic" />
          </feMerge>
        </filter>
      </defs>

      <rect x="0" y="0" width="720" height="490" rx="10" fill="#0b0f14" />
      <rect x="1" y="37" width="718" height="451" fill="url(#grid)" />
      <rect x="0.5" y="0.5" width="719" height="489" rx="10" fill="none" stroke="#22272e" stroke-width="1" />

      <line x1="0" y1="36" x2="720" y2="36" stroke="#22272e" stroke-width="1" />
      <circle cx="20" cy="18" r="6" fill="#ff5f56" />
      <circle cx="40" cy="18" r="6" fill="#ffbd2e" />
      <circle cx="60" cy="18" r="6" fill="#27c93f" />
      <text x="82" y="22" font-family="Courier New, monospace" fontSize="12" fill="#6e7681">
        root@netbreaker:~/lab33$ topology --render
      </text>
      <g data-link="R1:Fa0/0↔SW1:Et0/0">
        <line x1="360" y1="110" x2="410" y2="110" stroke="#4d5560" stroke-width="1.5"
          data-node-a="R1" data-iface-a="Fa0/0" data-node-b="SW1" data-iface-b="Et0/0" />
        <title>R1 Fa0/0 ↔ SW1 Et0/0</title>
      </g>
      <g data-link="KALI:eth0↔SW1:Et0/1">
        <line x1="338" y1="200" x2="432" y2="140" stroke="#4d5560" stroke-width="1.5"
          data-node-a="KALI" data-iface-a="eth0" data-node-b="SW1" data-iface-b="Et0/1" />
        <title>KALI eth0 ↔ SW1 Et0/1</title>
      </g>
      <g data-link="PC1:eth0↔SW1:Et0/2">
        <line x1="480" y1="200" x2="480" y2="140" stroke="#4d5560" stroke-width="1.5"
          data-node-a="PC1" data-iface-a="eth0" data-node-b="SW1" data-iface-b="Et0/2" />
        <title>PC1 eth0 ↔ SW1 Et0/2</title>
      </g>
      <g data-port="R1" data-iface="Fa0/0">
        <rect x="342" y="108" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="363" y="121" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Fa0/0</text>
        <title>R1 Fa0/0</title>
      </g>
      <g data-port="SW1" data-iface="Et0/0">
        <rect x="386" y="108" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="407" y="121" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/0</text>
        <title>SW1 Et0/0</title>
      </g>
      <g data-port="SW1" data-iface="Et0/1">
        <rect x="395" y="150" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="416" y="163" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/1</text>
        <title>SW1 Et0/1</title>
      </g>
      <g data-port="SW1" data-iface="Et0/2">
        <rect x="466" y="141" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="487" y="154" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/2</text>
        <title>SW1 Et0/2</title>
      </g>
      <g data-port="PC1" data-iface="eth0">
        <rect x="466" y="181" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="487" y="194" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">eth0</text>
        <title>PC1 eth0</title>
      </g>
      <g data-port="KALI" data-iface="eth0">
        <rect x="341" y="184" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="362" y="197" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">eth0</text>
        <title>KALI eth0</title>
      </g>
      <g data-node="R1" data-role="core">
        <rect x="220" y="80" width="140" height="60" rx="6" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
        <text x="290" y="116" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#e6edf3">R1</text>
        <text x="290" y="134" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">router</text>
        <title>R1</title>
      </g>
      <g data-node="SW1" data-role="core">
        <rect x="410" y="80" width="140" height="60" rx="6" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
        <text x="480" y="116" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#e6edf3">SW1</text>
        <text x="480" y="134" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">l2 switch</text>
        <title>SW1</title>
      </g>
      <g data-node="PC1" data-role="host">
        <circle cx="480" cy="230" r="30" fill="#131a21" stroke="#22d3ee" stroke-width="1.5" />
        <text x="480" y="234" text-anchor="middle" font-family="Courier New, monospace" fontSize="13" fontWeight="700" fill="#67e8f9">PC1</text>
        <text x="480" y="248" text-anchor="middle" font-family="Courier New, monospace" fontSize="9" fill="#22d3ee">end host</text>
        <title>PC1</title>
      </g>
      <g data-node="KALI" data-role="attacker">
        <g filter="url(#glow)">
          <rect x="220" y="200" width="140" height="60" rx="6" fill="#1a0f11" stroke="#f85149" stroke-width="1.5" stroke-dasharray="5 3" />
        </g>
        <text x="290" y="236" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#ff7b72">KALI</text>
        <text x="290" y="254" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#f85149">attacker / observer</text>
        <title>KALI</title>
      </g>
      <line x1="30" y1="405" x2="690" y2="405" stroke="#22272e" stroke-width="1" />
      <text x="30" y="424" font-family="Courier New, monospace" fontSize="10" fill="#6e7681">// device_legend</text>

      <rect x="30" y="438" width="12" height="12" rx="2" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
      <text x="50" y="448" font-family="Courier New, monospace" fontSize="11" fill="#e6edf3">switch / router / firewall</text>

      <rect x="230" y="438" width="12" height="12" rx="2" fill="#131a21" stroke="#d29922" stroke-width="1.5" />
      <text x="250" y="448" font-family="Courier New, monospace" fontSize="11" fill="#d29922">hub — single collision domain</text>

      <circle cx="486" cy="444" r="6" fill="#131a21" stroke="#22d3ee" stroke-width="1.5" />
      <text x="500" y="448" font-family="Courier New, monospace" fontSize="11" fill="#67e8f9">end host</text>

      <rect x="580" y="438" width="12" height="12" rx="2" fill="#1a0f11" stroke="#f85149" stroke-width="1.5" stroke-dasharray="3 2" />
      <text x="600" y="448" font-family="Courier New, monospace" fontSize="11" fill="#ff7b72">observer / attacker</text>

      <text x="30" y="475" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">
        initial_build: R1(Fa0/0)→SW1(Et0/0) · KALI(eth0)→SW1(Et0/1) · PC1(eth0)→SW1(Et0/2)
      </text>
    </svg>
$md$)
WHERE lab_id = 33;

UPDATE lab_topologies SET svg_large = verify_replace(svg_large,
  $md$<svg viewBox="0 0 600 220" xmlns="http://www.w3.org/2000/svg" font-family="ui-monospace, monospace">
  <rect x="60" y="80" width="170" height="56" rx="9" fill="#fff" stroke="#14161a" stroke-width="1.5"/>
  <text x="145" y="103" text-anchor="middle" font-size="13" fill="#14161a" font-weight="600">R1</text>
  <text x="145" y="120" text-anchor="middle" font-size="9" fill="#6b7480">config + enable pw (type 7)</text>
  <rect x="370" y="80" width="180" height="56" rx="9" fill="#fff" stroke="#c02a30" stroke-width="1.8"/>
  <text x="460" y="103" text-anchor="middle" font-size="13" fill="#c02a30" font-weight="700">KALI</text>
  <text x="460" y="120" text-anchor="middle" font-size="9" fill="#6b7480">TFTP get + FTP sniff</text>
  <text x="460" y="132" text-anchor="middle" font-size="8" fill="#6b7480">+ type-7 decrypt</text>
  <line x1="230" y1="106" x2="370" y2="106" stroke="#c02a30" stroke-width="2.5" stroke-dasharray="6 5"/>
  <text x="300" y="96" text-anchor="middle" font-size="9" fill="#6b7480">TFTP 69 / FTP 21 → SCP 22</text>
</svg>$md$,
  $md$<svg
      width="100%"
      viewBox="0 0 720 490"
      xmlns="http://www.w3.org/2000/svg"
      role="img"
      aria-label="NetBreaker Lab 34 topology: R1(Fa0/0)→SW1(Et0/0), KALI(eth0)→SW1(Et0/1)"
    >
      <defs>
        <pattern id="grid" width="24" height="24" patternUnits="userSpaceOnUse">
          <path d="M24 0H0V24" fill="none" stroke="#1b2129" stroke-width="1" />
        </pattern>
        <filter id="glow" x="-40%" y="-40%" width="180%" height="180%">
          <feGaussianBlur stdDeviation="3" result="blur" />
          <feMerge>
            <feMergeNode in="blur" />
            <feMergeNode in="SourceGraphic" />
          </feMerge>
        </filter>
      </defs>

      <rect x="0" y="0" width="720" height="490" rx="10" fill="#0b0f14" />
      <rect x="1" y="37" width="718" height="451" fill="url(#grid)" />
      <rect x="0.5" y="0.5" width="719" height="489" rx="10" fill="none" stroke="#22272e" stroke-width="1" />

      <line x1="0" y1="36" x2="720" y2="36" stroke="#22272e" stroke-width="1" />
      <circle cx="20" cy="18" r="6" fill="#ff5f56" />
      <circle cx="40" cy="18" r="6" fill="#ffbd2e" />
      <circle cx="60" cy="18" r="6" fill="#27c93f" />
      <text x="82" y="22" font-family="Courier New, monospace" fontSize="12" fill="#6e7681">
        root@netbreaker:~/lab34$ topology --render
      </text>
      <g data-link="R1:Fa0/0↔SW1:Et0/0">
        <line x1="360" y1="110" x2="410" y2="110" stroke="#4d5560" stroke-width="1.5"
          data-node-a="R1" data-iface-a="Fa0/0" data-node-b="SW1" data-iface-b="Et0/0" />
        <title>R1 Fa0/0 ↔ SW1 Et0/0</title>
      </g>
      <g data-link="KALI:eth0↔SW1:Et0/1">
        <line x1="409" y1="200" x2="456" y2="140" stroke="#4d5560" stroke-width="1.5"
          data-node-a="KALI" data-iface-a="eth0" data-node-b="SW1" data-iface-b="Et0/1" />
        <title>KALI eth0 ↔ SW1 Et0/1</title>
      </g>
      <g data-port="R1" data-iface="Fa0/0">
        <rect x="342" y="108" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="363" y="121" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Fa0/0</text>
        <title>R1 Fa0/0</title>
      </g>
      <g data-port="SW1" data-iface="Et0/0">
        <rect x="386" y="108" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="407" y="121" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/0</text>
        <title>SW1 Et0/0</title>
      </g>
      <g data-port="SW1" data-iface="Et0/1">
        <rect x="426" y="154" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="447" y="167" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/1</text>
        <title>SW1 Et0/1</title>
      </g>
      <g data-port="KALI" data-iface="eth0">
        <rect x="408" y="177" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="429" y="190" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">eth0</text>
        <title>KALI eth0</title>
      </g>
      <g data-node="R1" data-role="core">
        <rect x="220" y="80" width="140" height="60" rx="6" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
        <text x="290" y="116" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#e6edf3">R1</text>
        <text x="290" y="134" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">router</text>
        <title>R1</title>
      </g>
      <g data-node="SW1" data-role="core">
        <rect x="410" y="80" width="140" height="60" rx="6" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
        <text x="480" y="116" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#e6edf3">SW1</text>
        <text x="480" y="134" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">l2 switch</text>
        <title>SW1</title>
      </g>
      <g data-node="KALI" data-role="attacker">
        <g filter="url(#glow)">
          <rect x="315" y="200" width="140" height="60" rx="6" fill="#1a0f11" stroke="#f85149" stroke-width="1.5" stroke-dasharray="5 3" />
        </g>
        <text x="385" y="236" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#ff7b72">KALI</text>
        <text x="385" y="254" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#f85149">attacker / observer</text>
        <title>KALI</title>
      </g>
      <line x1="30" y1="405" x2="690" y2="405" stroke="#22272e" stroke-width="1" />
      <text x="30" y="424" font-family="Courier New, monospace" fontSize="10" fill="#6e7681">// device_legend</text>

      <rect x="30" y="438" width="12" height="12" rx="2" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
      <text x="50" y="448" font-family="Courier New, monospace" fontSize="11" fill="#e6edf3">switch / router / firewall</text>

      <rect x="230" y="438" width="12" height="12" rx="2" fill="#131a21" stroke="#d29922" stroke-width="1.5" />
      <text x="250" y="448" font-family="Courier New, monospace" fontSize="11" fill="#d29922">hub — single collision domain</text>

      <circle cx="486" cy="444" r="6" fill="#131a21" stroke="#22d3ee" stroke-width="1.5" />
      <text x="500" y="448" font-family="Courier New, monospace" fontSize="11" fill="#67e8f9">end host</text>

      <rect x="580" y="438" width="12" height="12" rx="2" fill="#1a0f11" stroke="#f85149" stroke-width="1.5" stroke-dasharray="3 2" />
      <text x="600" y="448" font-family="Courier New, monospace" fontSize="11" fill="#ff7b72">observer / attacker</text>

      <text x="30" y="475" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">
        initial_build: R1(Fa0/0)→SW1(Et0/0) · KALI(eth0)→SW1(Et0/1)
      </text>
    </svg>
$md$)
WHERE lab_id = 34;

UPDATE lab_topologies SET svg_large = verify_replace(svg_large,
  $md$<svg viewBox="0 0 700 260" xmlns="http://www.w3.org/2000/svg" font-family="ui-monospace, monospace">
  <rect x="270" y="100" width="160" height="56" rx="9" fill="#fff" stroke="#14161a" stroke-width="1.8"/>
  <text x="350" y="124" text-anchor="middle" font-size="13" fill="#14161a" font-weight="700">R1 → R2</text>
  <text x="350" y="140" text-anchor="middle" font-size="9" fill="#6b7480">512 kbps · LLQ policy</text>
  <rect x="40" y="30" width="150" height="52" rx="9" fill="#fff" stroke="#1d4fc7" stroke-width="1.8"/>
  <text x="115" y="53" text-anchor="middle" font-size="12" fill="#1d4fc7" font-weight="600">PC1 · voice</text>
  <text x="115" y="69" text-anchor="middle" font-size="8" fill="#6b7480">20ms interval · DSCP EF</text>
  <rect x="510" y="30" width="150" height="52" rx="9" fill="#fff" stroke="#c02a30" stroke-width="1.8"/>
  <text x="585" y="53" text-anchor="middle" font-size="12" fill="#c02a30" font-weight="600">KALI · bulk</text>
  <text x="585" y="69" text-anchor="middle" font-size="8" fill="#6b7480">iperf3 · saturating flood</text>
  <line x1="115" y1="82" x2="300" y2="100" stroke="#1d4fc7" stroke-width="2.5"/>
  <line x1="585" y1="82" x2="400" y2="100" stroke="#c02a30" stroke-width="2.5" stroke-dasharray="6 5"/>
  <rect x="270" y="190" width="160" height="46" rx="8" fill="#fff" stroke="#0d7050" stroke-width="1.6"/>
  <text x="350" y="212" text-anchor="middle" font-size="11" fill="#0d7050" font-weight="600">priority 20% · voice</text>
  <text x="350" y="226" text-anchor="middle" font-size="9" fill="#6b7480">class-default: fair-queue</text>
  <line x1="350" y1="156" x2="350" y2="190" stroke="#0d7050" stroke-width="2"/>
</svg>$md$,
  $md$<svg
      width="100%"
      viewBox="0 0 720 490"
      xmlns="http://www.w3.org/2000/svg"
      role="img"
      aria-label="NetBreaker Lab 35 topology: R1(Fa0/0)→SW1(Et0/0), R1(Fa0/1)→R2(Fa0/0), PC1(eth0)→SW1(Et0/1), KALI(eth0)→SW1(Et0/2)"
    >
      <defs>
        <pattern id="grid" width="24" height="24" patternUnits="userSpaceOnUse">
          <path d="M24 0H0V24" fill="none" stroke="#1b2129" stroke-width="1" />
        </pattern>
        <filter id="glow" x="-40%" y="-40%" width="180%" height="180%">
          <feGaussianBlur stdDeviation="3" result="blur" />
          <feMerge>
            <feMergeNode in="blur" />
            <feMergeNode in="SourceGraphic" />
          </feMerge>
        </filter>
      </defs>

      <rect x="0" y="0" width="720" height="490" rx="10" fill="#0b0f14" />
      <rect x="1" y="37" width="718" height="451" fill="url(#grid)" />
      <rect x="0.5" y="0.5" width="719" height="489" rx="10" fill="none" stroke="#22272e" stroke-width="1" />

      <line x1="0" y1="36" x2="720" y2="36" stroke="#22272e" stroke-width="1" />
      <circle cx="20" cy="18" r="6" fill="#ff5f56" />
      <circle cx="40" cy="18" r="6" fill="#ffbd2e" />
      <circle cx="60" cy="18" r="6" fill="#27c93f" />
      <text x="82" y="22" font-family="Courier New, monospace" fontSize="12" fill="#6e7681">
        root@netbreaker:~/lab35$ topology --render
      </text>
      <g data-link="R1:Fa0/0↔SW1:Et0/0">
        <line x1="265" y1="110" x2="505" y2="110" stroke="#4d5560" stroke-width="1.5"
          data-node-a="R1" data-iface-a="Fa0/0" data-node-b="SW1" data-iface-b="Et0/0" />
        <title>R1 Fa0/0 ↔ SW1 Et0/0</title>
      </g>
      <g data-link="R1:Fa0/1↔R2:Fa0/0">
        <line x1="265" y1="110" x2="315" y2="110" stroke="#4d5560" stroke-width="1.5"
          data-node-a="R1" data-iface-a="Fa0/1" data-node-b="R2" data-iface-b="Fa0/0" />
        <title>R1 Fa0/1 ↔ R2 Fa0/0</title>
      </g>
      <g data-link="PC1:eth0↔SW1:Et0/1">
        <line x1="499" y1="206" x2="551" y2="140" stroke="#4d5560" stroke-width="1.5"
          data-node-a="PC1" data-iface-a="eth0" data-node-b="SW1" data-iface-b="Et0/1" />
        <title>PC1 eth0 ↔ SW1 Et0/1</title>
      </g>
      <g data-link="KALI:eth0↔SW1:Et0/2">
        <line x1="360" y1="201" x2="505" y2="139" stroke="#4d5560" stroke-width="1.5"
          data-node-a="KALI" data-iface-a="eth0" data-node-b="SW1" data-iface-b="Et0/2" />
        <title>KALI eth0 ↔ SW1 Et0/2</title>
      </g>
      <g data-port="R1" data-iface="Fa0/0">
        <rect x="281" y="81" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="302" y="94" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Fa0/0</text>
        <title>R1 Fa0/0</title>
      </g>
      <g data-port="R1" data-iface="Fa0/1">
        <rect x="246" y="141" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="267" y="154" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Fa0/1</text>
        <title>R1 Fa0/1</title>
      </g>
      <g data-port="R2" data-iface="Fa0/0">
        <rect x="274" y="111" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="295" y="124" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Fa0/0</text>
        <title>R2 Fa0/0</title>
      </g>
      <g data-port="SW1" data-iface="Et0/0">
        <rect x="460" y="107" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="481" y="120" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/0</text>
        <title>SW1 Et0/0</title>
      </g>
      <g data-port="SW1" data-iface="Et0/1">
        <rect x="521" y="154" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="542" y="167" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/1</text>
        <title>SW1 Et0/1</title>
      </g>
      <g data-port="SW1" data-iface="Et0/2">
        <rect x="465" y="146" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="486" y="159" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/2</text>
        <title>SW1 Et0/2</title>
      </g>
      <g data-port="PC1" data-iface="eth0">
        <rect x="498" y="183" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="519" y="196" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">eth0</text>
        <title>PC1 eth0</title>
      </g>
      <g data-port="KALI" data-iface="eth0">
        <rect x="364" y="189" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="385" y="202" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">eth0</text>
        <title>KALI eth0</title>
      </g>
      <g data-node="R1" data-role="core">
        <rect x="125" y="80" width="140" height="60" rx="6" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
        <text x="195" y="116" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#e6edf3">R1</text>
        <text x="195" y="134" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">router</text>
        <title>R1</title>
      </g>
      <g data-node="R2" data-role="core">
        <rect x="315" y="80" width="140" height="60" rx="6" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
        <text x="385" y="116" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#e6edf3">R2</text>
        <text x="385" y="134" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">router</text>
        <title>R2</title>
      </g>
      <g data-node="SW1" data-role="core">
        <rect x="505" y="80" width="140" height="60" rx="6" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
        <text x="575" y="116" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#e6edf3">SW1</text>
        <text x="575" y="134" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">l2 switch</text>
        <title>SW1</title>
      </g>
      <g data-node="PC1" data-role="host">
        <circle cx="480" cy="230" r="30" fill="#131a21" stroke="#22d3ee" stroke-width="1.5" />
        <text x="480" y="234" text-anchor="middle" font-family="Courier New, monospace" fontSize="13" fontWeight="700" fill="#67e8f9">PC1</text>
        <text x="480" y="248" text-anchor="middle" font-family="Courier New, monospace" fontSize="9" fill="#22d3ee">end host</text>
        <title>PC1</title>
      </g>
      <g data-node="KALI" data-role="attacker">
        <g filter="url(#glow)">
          <rect x="220" y="200" width="140" height="60" rx="6" fill="#1a0f11" stroke="#f85149" stroke-width="1.5" stroke-dasharray="5 3" />
        </g>
        <text x="290" y="236" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#ff7b72">KALI</text>
        <text x="290" y="254" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#f85149">attacker / observer</text>
        <title>KALI</title>
      </g>
      <line x1="30" y1="405" x2="690" y2="405" stroke="#22272e" stroke-width="1" />
      <text x="30" y="424" font-family="Courier New, monospace" fontSize="10" fill="#6e7681">// device_legend</text>

      <rect x="30" y="438" width="12" height="12" rx="2" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
      <text x="50" y="448" font-family="Courier New, monospace" fontSize="11" fill="#e6edf3">switch / router / firewall</text>

      <rect x="230" y="438" width="12" height="12" rx="2" fill="#131a21" stroke="#d29922" stroke-width="1.5" />
      <text x="250" y="448" font-family="Courier New, monospace" fontSize="11" fill="#d29922">hub — single collision domain</text>

      <circle cx="486" cy="444" r="6" fill="#131a21" stroke="#22d3ee" stroke-width="1.5" />
      <text x="500" y="448" font-family="Courier New, monospace" fontSize="11" fill="#67e8f9">end host</text>

      <rect x="580" y="438" width="12" height="12" rx="2" fill="#1a0f11" stroke="#f85149" stroke-width="1.5" stroke-dasharray="3 2" />
      <text x="600" y="448" font-family="Courier New, monospace" fontSize="11" fill="#ff7b72">observer / attacker</text>

      <text x="30" y="475" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">
        initial_build: R1(Fa0/0)→SW1(Et0/0) · R1(Fa0/1)→R2(Fa0/0) · PC1(eth0)→SW1(Et0/1) · KALI(eth0)→SW1(Et0/2)
      </text>
    </svg>
$md$)
WHERE lab_id = 35;

UPDATE lab_topologies SET svg_large = verify_replace(svg_large,
  $md$<svg viewBox="0 0 700 260" xmlns="http://www.w3.org/2000/svg" font-family="ui-monospace, monospace">
   <rect x="270" y="90" width="160" height="56" rx="9" fill="#fff" stroke="#14161a" stroke-width="1.8"/>
   <text x="350" y="113" text-anchor="middle" font-size="13" fill="#14161a" font-weight="700">SW1</text>
   <text x="350" y="130" text-anchor="middle" font-size="9" fill="#6b7480">Fa0/1 · port-security max 1</text>
   <rect x="40" y="30" width="160" height="52" rx="9" fill="#fff" stroke="#1d4fc7" stroke-width="1.8"/>
   <text x="120" y="53" text-anchor="middle" font-size="12" fill="#1d4fc7" font-weight="600">PC1 · authorized</text>
   <text x="120" y="69" text-anchor="middle" font-size="8" fill="#6b7480">sticky-learned MAC</text>
   <rect x="40" y="170" width="200" height="56" rx="9" fill="#fff" stroke="#c02a30" stroke-width="1.8"/>
   <text x="140" y="193" text-anchor="middle" font-size="12" fill="#c02a30" font-weight="600">KALI · macchanger</text>
   <text x="140" y="209" text-anchor="middle" font-size="8" fill="#6b7480">clones PC1 MAC exactly</text>
   <rect x="450" y="170" width="160" height="52" rx="9" fill="#fff" stroke="#1d4fc7" stroke-width="1.8"/>
   <text x="530" y="193" text-anchor="middle" font-size="12" fill="#1d4fc7" font-weight="600">PC2 · authorized</text>
   <text x="530" y="209" text-anchor="middle" font-size="8" fill="#6b7480">also protected</text>
   <line x1="120" y1="82" x2="290" y2="118" stroke="#1d4fc7" stroke-width="2.5"/>
   <line x1="140" y1="170" x2="290" y2="130" stroke="#c02a30" stroke-width="2.5" stroke-dasharray="6 5"/>
   <line x1="530" y1="170" x2="380" y2="130" stroke="#1d4fc7" stroke-width="2.5"/>
 </svg>$md$,
  $md$<svg
      width="100%"
      viewBox="0 0 720 490"
      xmlns="http://www.w3.org/2000/svg"
      role="img"
      aria-label="NetBreaker Lab 36 topology: PC1(eth0)→SW1(Et0/0), PC2(eth0)→SW1(Et0/2), KALI(eth0)→SW1(Et0/1)"
    >
      <defs>
        <pattern id="grid" width="24" height="24" patternUnits="userSpaceOnUse">
          <path d="M24 0H0V24" fill="none" stroke="#1b2129" stroke-width="1" />
        </pattern>
        <filter id="glow" x="-40%" y="-40%" width="180%" height="180%">
          <feGaussianBlur stdDeviation="3" result="blur" />
          <feMerge>
            <feMergeNode in="blur" />
            <feMergeNode in="SourceGraphic" />
          </feMerge>
        </filter>
      </defs>

      <rect x="0" y="0" width="720" height="490" rx="10" fill="#0b0f14" />
      <rect x="1" y="37" width="718" height="451" fill="url(#grid)" />
      <rect x="0.5" y="0.5" width="719" height="489" rx="10" fill="none" stroke="#22272e" stroke-width="1" />

      <line x1="0" y1="36" x2="720" y2="36" stroke="#22272e" stroke-width="1" />
      <circle cx="20" cy="18" r="6" fill="#ff5f56" />
      <circle cx="40" cy="18" r="6" fill="#ffbd2e" />
      <circle cx="60" cy="18" r="6" fill="#27c93f" />
      <text x="82" y="22" font-family="Courier New, monospace" fontSize="12" fill="#6e7681">
        root@netbreaker:~/lab36$ topology --render
      </text>
      <g data-link="PC1:eth0↔SW1:Et0/0">
        <line x1="149" y1="93" x2="280" y2="128" stroke="#4d5560" stroke-width="1.5"
          data-node-a="PC1" data-iface-a="eth0" data-node-b="SW1" data-iface-b="Et0/0" />
        <title>PC1 eth0 ↔ SW1 Et0/0</title>
      </g>
      <g data-link="PC2:eth0↔SW1:Et0/2">
        <line x1="502" y1="213" x2="419" y2="177" stroke="#4d5560" stroke-width="1.5"
          data-node-a="PC2" data-iface-a="eth0" data-node-b="SW1" data-iface-b="Et0/2" />
        <title>PC2 eth0 ↔ SW1 Et0/2</title>
      </g>
      <g data-link="KALI:eth0↔SW1:Et0/1">
        <line x1="210" y1="200" x2="280" y2="174" stroke="#4d5560" stroke-width="1.5"
          data-node-a="KALI" data-iface-a="eth0" data-node-b="SW1" data-iface-b="Et0/1" />
        <title>KALI eth0 ↔ SW1 Et0/1</title>
      </g>
      <g data-port="SW1" data-iface="Et0/0">
        <rect x="234" y="120" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="255" y="133" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/0</text>
        <title>SW1 Et0/0</title>
      </g>
      <g data-port="SW1" data-iface="Et0/2">
        <rect x="421" y="170" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="442" y="183" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/2</text>
        <title>SW1 Et0/2</title>
      </g>
      <g data-port="SW1" data-iface="Et0/1">
        <rect x="247" y="177" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="268" y="190" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/1</text>
        <title>SW1 Et0/1</title>
      </g>
      <g data-port="PC1" data-iface="eth0">
        <rect x="149" y="97" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="170" y="110" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">eth0</text>
        <title>PC1 eth0</title>
      </g>
      <g data-port="PC2" data-iface="eth0">
        <rect x="464" y="189" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="485" y="202" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">eth0</text>
        <title>PC2 eth0</title>
      </g>
      <g data-port="KALI" data-iface="eth0">
        <rect x="206" y="192" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="227" y="205" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">eth0</text>
        <title>KALI eth0</title>
      </g>
      <g data-node="SW1" data-role="core">
        <rect x="280" y="117" width="140" height="60" rx="6" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
        <text x="350" y="153" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#e6edf3">SW1</text>
        <text x="350" y="171" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">l2 switch</text>
        <title>SW1</title>
      </g>
      <g data-node="PC1" data-role="host">
        <circle cx="120" cy="85" r="30" fill="#131a21" stroke="#22d3ee" stroke-width="1.5" />
        <text x="120" y="89" text-anchor="middle" font-family="Courier New, monospace" fontSize="13" fontWeight="700" fill="#67e8f9">PC1</text>
        <text x="120" y="103" text-anchor="middle" font-family="Courier New, monospace" fontSize="9" fill="#22d3ee">end host</text>
        <title>PC1</title>
      </g>
      <g data-node="PC2" data-role="host">
        <circle cx="530" cy="225" r="30" fill="#131a21" stroke="#22d3ee" stroke-width="1.5" />
        <text x="530" y="229" text-anchor="middle" font-family="Courier New, monospace" fontSize="13" fontWeight="700" fill="#67e8f9">PC2</text>
        <text x="530" y="243" text-anchor="middle" font-family="Courier New, monospace" fontSize="9" fill="#22d3ee">end host</text>
        <title>PC2</title>
      </g>
      <g data-node="KALI" data-role="attacker">
        <g filter="url(#glow)">
          <rect x="70" y="197" width="140" height="60" rx="6" fill="#1a0f11" stroke="#f85149" stroke-width="1.5" stroke-dasharray="5 3" />
        </g>
        <text x="140" y="233" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#ff7b72">KALI</text>
        <text x="140" y="251" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#f85149">attacker / observer</text>
        <title>KALI</title>
      </g>
      <line x1="30" y1="405" x2="690" y2="405" stroke="#22272e" stroke-width="1" />
      <text x="30" y="424" font-family="Courier New, monospace" fontSize="10" fill="#6e7681">// device_legend</text>

      <rect x="30" y="438" width="12" height="12" rx="2" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
      <text x="50" y="448" font-family="Courier New, monospace" fontSize="11" fill="#e6edf3">switch / router / firewall</text>

      <rect x="230" y="438" width="12" height="12" rx="2" fill="#131a21" stroke="#d29922" stroke-width="1.5" />
      <text x="250" y="448" font-family="Courier New, monospace" fontSize="11" fill="#d29922">hub — single collision domain</text>

      <circle cx="486" cy="444" r="6" fill="#131a21" stroke="#22d3ee" stroke-width="1.5" />
      <text x="500" y="448" font-family="Courier New, monospace" fontSize="11" fill="#67e8f9">end host</text>

      <rect x="580" y="438" width="12" height="12" rx="2" fill="#1a0f11" stroke="#f85149" stroke-width="1.5" stroke-dasharray="3 2" />
      <text x="600" y="448" font-family="Courier New, monospace" fontSize="11" fill="#ff7b72">observer / attacker</text>

      <text x="30" y="475" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">
        initial_build: PC1(eth0)→SW1(Et0/0) · PC2(eth0)→SW1(Et0/2) · KALI(eth0)→SW1(Et0/1)
      </text>
    </svg>
$md$)
WHERE lab_id = 36;

UPDATE lab_topologies SET svg_large = verify_replace(svg_large,
  $md$<svg viewBox="0 0 700 260" xmlns="http://www.w3.org/2000/svg" font-family="ui-monospace, monospace">
  <rect x="30" y="110" width="150" height="46" rx="8" fill="#fff" stroke="#1d4fc7" stroke-width="1.6"/>
  <text x="105" y="132" text-anchor="middle" font-size="12" fill="#1d4fc7" font-weight="600">PC1 / PC2</text>
  <text x="105" y="147" text-anchor="middle" font-size="8" fill="#6b7480">access tier</text>
  <rect x="230" y="30" width="150" height="46" rx="8" fill="#fff" stroke="#14161a" stroke-width="1.6"/>
  <text x="305" y="52" text-anchor="middle" font-size="12" fill="#14161a" font-weight="600">SW1 · access</text>
  <rect x="230" y="190" width="150" height="46" rx="8" fill="#fff" stroke="#14161a" stroke-width="1.6"/>
  <text x="305" y="212" text-anchor="middle" font-size="12" fill="#14161a" font-weight="600">SW1 · access</text>
  <rect x="470" y="110" width="170" height="50" rx="9" fill="#fff" stroke="#0d7050" stroke-width="1.8"/>
  <text x="555" y="132" text-anchor="middle" font-size="12" fill="#0d7050" font-weight="600">SW2 · dist/core</text>
  <text x="555" y="147" text-anchor="middle" font-size="8" fill="#6b7480">redundant uplinks + STP</text>
  <line x1="180" y1="130" x2="240" y2="70" stroke="#6b7480" stroke-width="2"/>
  <line x1="380" y1="53" x2="475" y2="120" stroke="#0d7050" stroke-width="2.5"/>
  <line x1="380" y1="213" x2="475" y2="145" stroke="#0d7050" stroke-width="2.5" stroke-dasharray="5 4"/>
  <text x="430" y="180" text-anchor="middle" font-size="8" fill="#6b7480">two uplinks — one can fail safely</text>
</svg>$md$,
  $md$<svg
      width="100%"
      viewBox="0 0 720 490"
      xmlns="http://www.w3.org/2000/svg"
      role="img"
      aria-label="NetBreaker Lab 39 topology: R1(Fa0/0)→SW1(Et0/0), R1(Fa0/1)→R2(Fa0/0), R2(Fa0/1)→R3(Fa0/0), R3(Fa0/1)→SW2(Et0/0), PC1(eth0)→SW1(Et0/1), PC2(eth0)→SW1(Et0/2), PC3(eth0)→SW2(Et0/1), KALI(eth0)→SW1(Et0/3)"
    >
      <defs>
        <pattern id="grid" width="24" height="24" patternUnits="userSpaceOnUse">
          <path d="M24 0H0V24" fill="none" stroke="#1b2129" stroke-width="1" />
        </pattern>
        <filter id="glow" x="-40%" y="-40%" width="180%" height="180%">
          <feGaussianBlur stdDeviation="3" result="blur" />
          <feMerge>
            <feMergeNode in="blur" />
            <feMergeNode in="SourceGraphic" />
          </feMerge>
        </filter>
      </defs>

      <rect x="0" y="0" width="720" height="490" rx="10" fill="#0b0f14" />
      <rect x="1" y="37" width="718" height="451" fill="url(#grid)" />
      <rect x="0.5" y="0.5" width="719" height="489" rx="10" fill="none" stroke="#22272e" stroke-width="1" />

      <line x1="0" y1="36" x2="720" y2="36" stroke="#22272e" stroke-width="1" />
      <circle cx="20" cy="18" r="6" fill="#ff5f56" />
      <circle cx="40" cy="18" r="6" fill="#ffbd2e" />
      <circle cx="60" cy="18" r="6" fill="#27c93f" />
      <text x="82" y="22" font-family="Courier New, monospace" fontSize="12" fill="#6e7681">
        root@netbreaker:~/lab39$ topology --render
      </text>
      <g data-link="R1:Fa0/0↔SW1:Et0/0">
        <line x1="233" y1="140" x2="252" y2="155" stroke="#4d5560" stroke-width="1.5"
          data-node-a="R1" data-iface-a="Fa0/0" data-node-b="SW1" data-iface-b="Et0/0" />
        <title>R1 Fa0/0 ↔ SW1 Et0/0</title>
      </g>
      <g data-link="R1:Fa0/1↔R2:Fa0/0">
        <line x1="265" y1="110" x2="315" y2="110" stroke="#4d5560" stroke-width="1.5"
          data-node-a="R1" data-iface-a="Fa0/1" data-node-b="R2" data-iface-b="Fa0/0" />
        <title>R1 Fa0/1 ↔ R2 Fa0/0</title>
      </g>
      <g data-link="R2:Fa0/1↔R3:Fa0/0">
        <line x1="455" y1="110" x2="505" y2="110" stroke="#4d5560" stroke-width="1.5"
          data-node-a="R2" data-iface-a="Fa0/1" data-node-b="R3" data-iface-b="Fa0/0" />
        <title>R2 Fa0/1 ↔ R3 Fa0/0</title>
      </g>
      <g data-link="R3:Fa0/1↔SW2:Et0/0">
        <line x1="537" y1="140" x2="518" y2="155" stroke="#4d5560" stroke-width="1.5"
          data-node-a="R3" data-iface-a="Fa0/1" data-node-b="SW2" data-iface-b="Et0/0" />
        <title>R3 Fa0/1 ↔ SW2 Et0/0</title>
      </g>
      <g data-link="PC1:eth0↔SW1:Et0/1">
        <line x1="361" y1="241" x2="328" y2="215" stroke="#4d5560" stroke-width="1.5"
          data-node-a="PC1" data-iface-a="eth0" data-node-b="SW1" data-iface-b="Et0/1" />
        <title>PC1 eth0 ↔ SW1 Et0/1</title>
      </g>
      <g data-link="PC2:eth0↔SW1:Et0/2">
        <line x1="546" y1="252" x2="360" y2="203" stroke="#4d5560" stroke-width="1.5"
          data-node-a="PC2" data-iface-a="eth0" data-node-b="SW1" data-iface-b="Et0/2" />
        <title>PC2 eth0 ↔ SW1 Et0/2</title>
      </g>
      <g data-link="PC3:eth0↔SW2:Et0/1">
        <line x1="401" y1="310" x2="461" y2="215" stroke="#4d5560" stroke-width="1.5"
          data-node-a="PC3" data-iface-a="eth0" data-node-b="SW2" data-iface-b="Et0/1" />
        <title>PC3 eth0 ↔ SW2 Et0/1</title>
      </g>
      <g data-link="KALI:eth0↔SW1:Et0/3">
        <line x1="233" y1="230" x2="252" y2="215" stroke="#4d5560" stroke-width="1.5"
          data-node-a="KALI" data-iface-a="eth0" data-node-b="SW1" data-iface-b="Et0/3" />
        <title>KALI eth0 ↔ SW1 Et0/3</title>
      </g>
      <g data-port="R1" data-iface="Fa0/0">
        <rect x="228" y="153" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="249" y="166" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Fa0/0</text>
        <title>R1 Fa0/0</title>
      </g>
      <g data-port="R1" data-iface="Fa0/1">
        <rect x="246" y="108" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="267" y="121" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Fa0/1</text>
        <title>R1 Fa0/1</title>
      </g>
      <g data-port="R2" data-iface="Fa0/0">
        <rect x="292" y="108" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="313" y="121" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Fa0/0</text>
        <title>R2 Fa0/0</title>
      </g>
      <g data-port="R2" data-iface="Fa0/1">
        <rect x="435" y="110" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="456" y="123" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Fa0/1</text>
        <title>R2 Fa0/1</title>
      </g>
      <g data-port="R3" data-iface="Fa0/0">
        <rect x="478" y="104" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="499" y="117" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Fa0/0</text>
        <title>R3 Fa0/0</title>
      </g>
      <g data-port="R3" data-iface="Fa0/1">
        <rect x="486" y="144" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="507" y="157" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Fa0/1</text>
        <title>R3 Fa0/1</title>
      </g>
      <g data-port="SW1" data-iface="Et0/0">
        <rect x="206" y="135" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="227" y="148" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/0</text>
        <title>SW1 Et0/0</title>
      </g>
      <g data-port="SW1" data-iface="Et0/1">
        <rect x="336" y="223" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="357" y="236" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/1</text>
        <title>SW1 Et0/1</title>
      </g>
      <g data-port="SW1" data-iface="Et0/2">
        <rect x="364" y="194" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="385" y="207" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/2</text>
        <title>SW1 Et0/2</title>
      </g>
      <g data-port="SW1" data-iface="Et0/3">
        <rect x="215" y="228" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="236" y="241" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/3</text>
        <title>SW1 Et0/3</title>
      </g>
      <g data-port="SW2" data-iface="Et0/0">
        <rect x="523" y="124" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="544" y="137" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/0</text>
        <title>SW2 Et0/0</title>
      </g>
      <g data-port="SW2" data-iface="Et0/1">
        <rect x="433" y="230" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="454" y="243" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/1</text>
        <title>SW2 Et0/1</title>
      </g>
      <g data-port="PC1" data-iface="eth0">
        <rect x="320" y="205" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="341" y="218" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">eth0</text>
        <title>PC1 eth0</title>
      </g>
      <g data-port="PC2" data-iface="eth0">
        <rect x="504" y="230" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="525" y="243" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">eth0</text>
        <title>PC2 eth0</title>
      </g>
      <g data-port="PC3" data-iface="eth0">
        <rect x="399" y="284" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="420" y="297" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">eth0</text>
        <title>PC3 eth0</title>
      </g>
      <g data-port="KALI" data-iface="eth0">
        <rect x="237" y="210" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="258" y="223" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">eth0</text>
        <title>KALI eth0</title>
      </g>
      <g data-node="R1" data-role="core">
        <rect x="125" y="80" width="140" height="60" rx="6" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
        <text x="195" y="116" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#e6edf3">R1</text>
        <text x="195" y="134" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">router</text>
        <title>R1</title>
      </g>
      <g data-node="R2" data-role="core">
        <rect x="315" y="80" width="140" height="60" rx="6" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
        <text x="385" y="116" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#e6edf3">R2</text>
        <text x="385" y="134" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">router</text>
        <title>R2</title>
      </g>
      <g data-node="R3" data-role="core">
        <rect x="505" y="80" width="140" height="60" rx="6" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
        <text x="575" y="116" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#e6edf3">R3</text>
        <text x="575" y="134" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">router</text>
        <title>R3</title>
      </g>
      <g data-node="SW1" data-role="core">
        <rect x="220" y="155" width="140" height="60" rx="6" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
        <text x="290" y="191" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#e6edf3">SW1</text>
        <text x="290" y="209" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">l2 switch</text>
        <title>SW1</title>
      </g>
      <g data-node="SW2" data-role="core">
        <rect x="410" y="155" width="140" height="60" rx="6" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
        <text x="480" y="191" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#e6edf3">SW2</text>
        <text x="480" y="209" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">l2 switch</text>
        <title>SW2</title>
      </g>
      <g data-node="PC1" data-role="host">
        <circle cx="385" cy="260" r="30" fill="#131a21" stroke="#22d3ee" stroke-width="1.5" />
        <text x="385" y="264" text-anchor="middle" font-family="Courier New, monospace" fontSize="13" fontWeight="700" fill="#67e8f9">PC1</text>
        <text x="385" y="278" text-anchor="middle" font-family="Courier New, monospace" fontSize="9" fill="#22d3ee">end host</text>
        <title>PC1</title>
      </g>
      <g data-node="PC2" data-role="host">
        <circle cx="575" cy="260" r="30" fill="#131a21" stroke="#22d3ee" stroke-width="1.5" />
        <text x="575" y="264" text-anchor="middle" font-family="Courier New, monospace" fontSize="13" fontWeight="700" fill="#67e8f9">PC2</text>
        <text x="575" y="278" text-anchor="middle" font-family="Courier New, monospace" fontSize="9" fill="#22d3ee">end host</text>
        <title>PC2</title>
      </g>
      <g data-node="PC3" data-role="host">
        <circle cx="385" cy="335" r="30" fill="#131a21" stroke="#22d3ee" stroke-width="1.5" />
        <text x="385" y="339" text-anchor="middle" font-family="Courier New, monospace" fontSize="13" fontWeight="700" fill="#67e8f9">PC3</text>
        <text x="385" y="353" text-anchor="middle" font-family="Courier New, monospace" fontSize="9" fill="#22d3ee">end host</text>
        <title>PC3</title>
      </g>
      <g data-node="KALI" data-role="attacker">
        <g filter="url(#glow)">
          <rect x="125" y="230" width="140" height="60" rx="6" fill="#1a0f11" stroke="#f85149" stroke-width="1.5" stroke-dasharray="5 3" />
        </g>
        <text x="195" y="266" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#ff7b72">KALI</text>
        <text x="195" y="284" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#f85149">attacker / observer</text>
        <title>KALI</title>
      </g>
      <line x1="30" y1="405" x2="690" y2="405" stroke="#22272e" stroke-width="1" />
      <text x="30" y="424" font-family="Courier New, monospace" fontSize="10" fill="#6e7681">// device_legend</text>

      <rect x="30" y="438" width="12" height="12" rx="2" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
      <text x="50" y="448" font-family="Courier New, monospace" fontSize="11" fill="#e6edf3">switch / router / firewall</text>

      <rect x="230" y="438" width="12" height="12" rx="2" fill="#131a21" stroke="#d29922" stroke-width="1.5" />
      <text x="250" y="448" font-family="Courier New, monospace" fontSize="11" fill="#d29922">hub — single collision domain</text>

      <circle cx="486" cy="444" r="6" fill="#131a21" stroke="#22d3ee" stroke-width="1.5" />
      <text x="500" y="448" font-family="Courier New, monospace" fontSize="11" fill="#67e8f9">end host</text>

      <rect x="580" y="438" width="12" height="12" rx="2" fill="#1a0f11" stroke="#f85149" stroke-width="1.5" stroke-dasharray="3 2" />
      <text x="600" y="448" font-family="Courier New, monospace" fontSize="11" fill="#ff7b72">observer / attacker</text>

      <text x="30" y="475" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">
        initial_build: R1(Fa0/0)→SW1(Et0/0) · R1(Fa0/1)→R2(Fa0/0) · R2(Fa0/1)→R3(Fa0/0) · R3(Fa0/1)→SW2(Et0/0) · PC1(eth0)→...
      </text>
    </svg>
$md$)
WHERE lab_id = 39;

UPDATE lab_topologies SET svg_large = verify_replace(svg_large,
  $md$<svg viewBox="0 0 600 120" font-family="monospace"><rect x="30" y="14" width="160" height="46" rx="8" fill="#fff" stroke="#2563eb" stroke-width="2"/><text x="110" y="40" text-anchor="middle" font-size="13" fill="#2563eb" font-weight="700">Ansible control</text><text x="110" y="56" text-anchor="middle" font-size="8" fill="#6b7480">playbook + inventory</text><rect x="220" y="14" width="160" height="46" rx="8" fill="#fff" stroke="#14161a" stroke-width="2"/><text x="300" y="40" text-anchor="middle" font-size="13" font-weight="700">R1 · managed</text><text x="300" y="56" text-anchor="middle" font-size="8" fill="#6b7480">IOS config pushed</text><rect x="410" y="14" width="160" height="46" rx="8" fill="#fff" stroke="#e5484d" stroke-width="2"/><text x="490" y="40" text-anchor="middle" font-size="13" fill="#e5484d" font-weight="700">KALI · rogue</text><text x="490" y="56" text-anchor="middle" font-size="8" fill="#6b7480">malicious playbook</text><line x1="190" y1="37" x2="220" y2="37" stroke="#2563eb" stroke-width="2"/><line x1="380" y1="37" x2="410" y2="37" stroke="#e5484d" stroke-width="2" stroke-dasharray="6 5"/></svg>$md$,
  $md$<svg
      width="100%"
      viewBox="0 0 720 490"
      xmlns="http://www.w3.org/2000/svg"
      role="img"
      aria-label="NetBreaker Lab 45 topology: R1(Fa0/0)→SW1(Et0/0), KALI(eth0)→SW1(Et0/1)"
    >
      <defs>
        <pattern id="grid" width="24" height="24" patternUnits="userSpaceOnUse">
          <path d="M24 0H0V24" fill="none" stroke="#1b2129" stroke-width="1" />
        </pattern>
        <filter id="glow" x="-40%" y="-40%" width="180%" height="180%">
          <feGaussianBlur stdDeviation="3" result="blur" />
          <feMerge>
            <feMergeNode in="blur" />
            <feMergeNode in="SourceGraphic" />
          </feMerge>
        </filter>
      </defs>

      <rect x="0" y="0" width="720" height="490" rx="10" fill="#0b0f14" />
      <rect x="1" y="37" width="718" height="451" fill="url(#grid)" />
      <rect x="0.5" y="0.5" width="719" height="489" rx="10" fill="none" stroke="#22272e" stroke-width="1" />

      <line x1="0" y1="36" x2="720" y2="36" stroke="#22272e" stroke-width="1" />
      <circle cx="20" cy="18" r="6" fill="#ff5f56" />
      <circle cx="40" cy="18" r="6" fill="#ffbd2e" />
      <circle cx="60" cy="18" r="6" fill="#27c93f" />
      <text x="82" y="22" font-family="Courier New, monospace" fontSize="12" fill="#6e7681">
        root@netbreaker:~/lab45$ topology --render
      </text>
      <g data-link="R1:Fa0/0↔SW1:Et0/0">
        <line x1="335" y1="115" x2="350" y2="128" stroke="#4d5560" stroke-width="1.5"
          data-node-a="R1" data-iface-a="Fa0/0" data-node-b="SW1" data-iface-b="Et0/0" />
        <title>R1 Fa0/0 ↔ SW1 Et0/0</title>
      </g>
      <g data-link="KALI:eth0↔SW1:Et0/1">
        <line x1="447" y1="115" x2="428" y2="128" stroke="#4d5560" stroke-width="1.5"
          data-node-a="KALI" data-iface-a="eth0" data-node-b="SW1" data-iface-b="Et0/1" />
        <title>KALI eth0 ↔ SW1 Et0/1</title>
      </g>
      <g data-port="R1" data-iface="Fa0/0">
        <rect x="328" y="127" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="349" y="140" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Fa0/0</text>
        <title>R1 Fa0/0</title>
      </g>
      <g data-port="SW1" data-iface="Et0/0">
        <rect x="306" y="109" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="327" y="122" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/0</text>
        <title>SW1 Et0/0</title>
      </g>
      <g data-port="SW1" data-iface="Et0/1">
        <rect x="431" y="94" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="452" y="107" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/1</text>
        <title>SW1 Et0/1</title>
      </g>
      <g data-port="KALI" data-iface="eth0">
        <rect x="394" y="119" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="415" y="132" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">eth0</text>
        <title>KALI eth0</title>
      </g>
      <g data-node="R1" data-role="core">
        <rect x="230" y="55" width="140" height="60" rx="6" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
        <text x="300" y="91" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#e6edf3">R1</text>
        <text x="300" y="109" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">router</text>
        <title>R1</title>
      </g>
      <g data-node="SW1" data-role="core">
        <rect x="315" y="128" width="140" height="60" rx="6" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
        <text x="385" y="164" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#e6edf3">SW1</text>
        <text x="385" y="182" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">l2 switch</text>
        <title>SW1</title>
      </g>
      <g data-node="KALI" data-role="attacker">
        <g filter="url(#glow)">
          <rect x="420" y="55" width="140" height="60" rx="6" fill="#1a0f11" stroke="#f85149" stroke-width="1.5" stroke-dasharray="5 3" />
        </g>
        <text x="490" y="91" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#ff7b72">KALI</text>
        <text x="490" y="109" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#f85149">attacker / observer</text>
        <title>KALI</title>
      </g>
      <line x1="30" y1="405" x2="690" y2="405" stroke="#22272e" stroke-width="1" />
      <text x="30" y="424" font-family="Courier New, monospace" fontSize="10" fill="#6e7681">// device_legend</text>

      <rect x="30" y="438" width="12" height="12" rx="2" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
      <text x="50" y="448" font-family="Courier New, monospace" fontSize="11" fill="#e6edf3">switch / router / firewall</text>

      <rect x="230" y="438" width="12" height="12" rx="2" fill="#131a21" stroke="#d29922" stroke-width="1.5" />
      <text x="250" y="448" font-family="Courier New, monospace" fontSize="11" fill="#d29922">hub — single collision domain</text>

      <circle cx="486" cy="444" r="6" fill="#131a21" stroke="#22d3ee" stroke-width="1.5" />
      <text x="500" y="448" font-family="Courier New, monospace" fontSize="11" fill="#67e8f9">end host</text>

      <rect x="580" y="438" width="12" height="12" rx="2" fill="#1a0f11" stroke="#f85149" stroke-width="1.5" stroke-dasharray="3 2" />
      <text x="600" y="448" font-family="Courier New, monospace" fontSize="11" fill="#ff7b72">observer / attacker</text>

      <text x="30" y="475" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">
        initial_build: R1(Fa0/0)→SW1(Et0/0) · KALI(eth0)→SW1(Et0/1)
      </text>
    </svg>
$md$)
WHERE lab_id = 45;
