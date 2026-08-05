-- Migration 089: canonical generated SVGs for 17 clean labs (topogen)
-- Replaces svg_large with generator output for labs whose layouts passed
-- geometric QA (G0-G5 clean). Generated from Go topology structs — the
-- single source of truth — so SVG and provisioning cannot drift.
-- Uses verify_replace() (062): fails loudly if the live DB's SVG differs
-- from the dumped baseline (hand-edit, drift, or re-application).
-- 23 flagged labs (2,6,7,9,11,13,15,16,19,21,24,25,26,27,28,29,31,33,34,
-- 35,36,39,45) are NOT touched — they keep hand-authored SVGs pending
-- manual visual QA.

UPDATE lab_topologies SET svg_large = verify_replace(svg_large,
  $md$<svg viewBox="0 0 760 440" xmlns="http://www.w3.org/2000/svg" font-family="ui-monospace, monospace">
  <!-- links -->
  <line x1="380" y1="72" x2="212" y2="168" stroke="#6b7480" stroke-width="2.5"/>
  <text x="300" y="112" text-anchor="middle" font-size="10" fill="#6b7480">trunk</text>
  <line x1="272" y1="196" x2="488" y2="196" stroke="#6b7480" stroke-width="4"/>
  <line x1="118" y1="330" x2="180" y2="222" stroke="#2563eb" stroke-width="2"/>
  <line x1="310" y1="338" x2="238" y2="222" stroke="#e5484d" stroke-width="2.2" stroke-dasharray="6 4"/>
  <line x1="628" y1="330" x2="556" y2="222" stroke="#7c3aed" stroke-width="2"/>

  <!-- trunk label -->
  <rect x="316" y="185" width="128" height="22" rx="11" fill="#fff" stroke="#e6e8ec"/>
  <text x="380" y="200" text-anchor="middle" font-size="10.5" fill="#6b7480">802.1Q TRUNK</text>

  <!-- R1 -->
  <rect x="328" y="28" width="104" height="44" rx="9" fill="#fff" stroke="#14161a" stroke-width="1.5"/>
  <text x="380" y="49" text-anchor="middle" font-size="13" fill="#14161a" font-weight="600">R1</text>
  <text x="380" y="63" text-anchor="middle" font-size="9" fill="#6b7480">router-on-a-stick</text>

  <!-- SW1 -->
  <rect x="140" y="170" width="132" height="52" rx="9" fill="#fff" stroke="#14161a" stroke-width="1.5"/>
  <text x="206" y="193" text-anchor="middle" font-size="13" fill="#14161a" font-weight="600">SW1</text>
  <text x="206" y="210" text-anchor="middle" font-size="9" fill="#6b7480">VLAN 10 · 20 · 99</text>

  <!-- SW2 -->
  <rect x="488" y="170" width="132" height="52" rx="9" fill="#fff" stroke="#14161a" stroke-width="1.5"/>
  <text x="554" y="193" text-anchor="middle" font-size="13" fill="#14161a" font-weight="600">SW2</text>
  <text x="554" y="210" text-anchor="middle" font-size="9" fill="#6b7480">VLAN 10 · 20 · 99</text>

  <!-- PC1 -->
  <rect x="56" y="330" width="118" height="46" rx="9" fill="#fff" stroke="#2563eb" stroke-width="1.6"/>
  <text x="115" y="352" text-anchor="middle" font-size="12" fill="#2563eb" font-weight="600">PC1</text>
  <text x="115" y="367" text-anchor="middle" font-size="8.5" fill="#6b7480">VLAN 10 · 10.0.10.10</text>

  <!-- KALI -->
  <rect x="250" y="338" width="128" height="50" rx="9" fill="#fff" stroke="#e5484d" stroke-width="1.8"/>
  <text x="314" y="360" text-anchor="middle" font-size="12" fill="#e5484d" font-weight="700">KALI · attacker</text>
  <text x="314" y="375" text-anchor="middle" font-size="8.5" fill="#6b7480">Fa0/3 · dynamic-auto ⚠</text>

  <!-- SRV1 -->
  <rect x="560" y="330" width="140" height="48" rx="9" fill="#fff" stroke="#7c3aed" stroke-width="1.8"/>
  <text x="630" y="352" text-anchor="middle" font-size="12" fill="#7c3aed" font-weight="700">SRV1 · 🏆</text>
  <text x="630" y="367" text-anchor="middle" font-size="8.5" fill="#6b7480">VLAN 20 · 10.0.20.10</text>
</svg>$md$,
  $md$<svg
      width="100%"
      viewBox="0 0 720 490"
      xmlns="http://www.w3.org/2000/svg"
      role="img"
      aria-label="NetBreaker Lab 1 topology: R1(Fa0/0)→SW1(Et0/0), PC1(eth0)→SW1(Et0/1), SW1(Et0/2)→SW2(Et0/1), KALI(eth0)→SW1(Et0/3), SRV1(eth0)→SW2(Et0/2)"
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
        root@netbreaker:~/lab1$ topology --render
      </text>
      <g data-link="R1:Fa0/0↔SW1:Et0/0">
        <line x1="344" y1="80" x2="242" y2="166" stroke="#4d5560" stroke-width="1.5"
          data-node-a="R1" data-iface-a="Fa0/0" data-node-b="SW1" data-iface-b="Et0/0" />
        <title>R1 Fa0/0 ↔ SW1 Et0/0</title>
      </g>
      <g data-link="PC1:eth0↔SW1:Et0/1">
        <line x1="130" y1="327" x2="189" y2="226" stroke="#4d5560" stroke-width="1.5"
          data-node-a="PC1" data-iface-a="eth0" data-node-b="SW1" data-iface-b="Et0/1" />
        <title>PC1 eth0 ↔ SW1 Et0/1</title>
      </g>
      <g data-link="SW1:Et0/2↔SW2:Et0/1">
        <line x1="276" y1="196" x2="484" y2="196" stroke="#4d5560" stroke-width="1.5"
          data-node-a="SW1" data-iface-a="Et0/2" data-node-b="SW2" data-iface-b="Et0/1" />
        <title>SW1 Et0/2 ↔ SW2 Et0/1</title>
      </g>
      <g data-link="KALI:eth0↔SW1:Et0/3">
        <line x1="295" y1="333" x2="225" y2="226" stroke="#4d5560" stroke-width="1.5"
          data-node-a="KALI" data-iface-a="eth0" data-node-b="SW1" data-iface-b="Et0/3" />
        <title>KALI eth0 ↔ SW1 Et0/3</title>
      </g>
      <g data-link="SRV1:eth0↔SW2:Et0/2">
        <line x1="617" y1="327" x2="568" y2="226" stroke="#4d5560" stroke-width="1.5"
          data-node-a="SRV1" data-iface-a="eth0" data-node-b="SW2" data-iface-b="Et0/2" />
        <title>SRV1 eth0 ↔ SW2 Et0/2</title>
      </g>
      <g data-port="R1" data-iface="Fa0/0">
        <rect x="300" y="81" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="321" y="94" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Fa0/0</text>
        <title>R1 Fa0/0</title>
      </g>
      <g data-port="SW1" data-iface="Et0/0">
        <rect x="235" y="136" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="256" y="149" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/0</text>
        <title>SW1 Et0/0</title>
      </g>
      <g data-port="SW1" data-iface="Et0/1">
        <rect x="162" y="241" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="183" y="254" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/1</text>
        <title>SW1 Et0/1</title>
      </g>
      <g data-port="SW1" data-iface="Et0/2">
        <rect x="279" y="194" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="300" y="207" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/2</text>
        <title>SW1 Et0/2</title>
      </g>
      <g data-port="SW1" data-iface="Et0/3">
        <rect x="223" y="233" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="244" y="246" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/3</text>
        <title>SW1 Et0/3</title>
      </g>
      <g data-port="SW2" data-iface="Et0/1">
        <rect x="439" y="194" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="460" y="207" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/1</text>
        <title>SW2 Et0/1</title>
      </g>
      <g data-port="SW2" data-iface="Et0/2">
        <rect x="564" y="236" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="585" y="249" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/2</text>
        <title>SW2 Et0/2</title>
      </g>
      <g data-port="PC1" data-iface="eth0">
        <rect x="127" y="301" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="148" y="314" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">eth0</text>
        <title>PC1 eth0</title>
      </g>
      <g data-port="KALI" data-iface="eth0">
        <rect x="266" y="300" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="287" y="313" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">eth0</text>
        <title>KALI eth0</title>
      </g>
      <g data-port="SRV1" data-iface="eth0">
        <rect x="592" y="293" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="613" y="306" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">eth0</text>
        <title>SRV1 eth0</title>
      </g>
      <g data-node="R1" data-role="core">
        <rect x="310" y="20" width="140" height="60" rx="6" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
        <text x="380" y="56" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#e6edf3">R1</text>
        <text x="380" y="74" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">router</text>
        <title>R1</title>
      </g>
      <g data-node="SW1" data-role="core">
        <rect x="136" y="166" width="140" height="60" rx="6" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
        <text x="206" y="202" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#e6edf3">SW1</text>
        <text x="206" y="220" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">l2 switch</text>
        <title>SW1</title>
      </g>
      <g data-node="SW2" data-role="core">
        <rect x="484" y="166" width="140" height="60" rx="6" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
        <text x="554" y="202" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#e6edf3">SW2</text>
        <text x="554" y="220" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">l2 switch</text>
        <title>SW2</title>
      </g>
      <g data-node="PC1" data-role="host">
        <circle cx="115" cy="353" r="30" fill="#131a21" stroke="#22d3ee" stroke-width="1.5" />
        <text x="115" y="357" text-anchor="middle" font-family="Courier New, monospace" fontSize="13" fontWeight="700" fill="#67e8f9">PC1</text>
        <text x="115" y="371" text-anchor="middle" font-family="Courier New, monospace" fontSize="9" fill="#22d3ee">end host</text>
        <title>PC1</title>
      </g>
      <g data-node="KALI" data-role="attacker">
        <g filter="url(#glow)">
          <rect x="244" y="333" width="140" height="60" rx="6" fill="#1a0f11" stroke="#f85149" stroke-width="1.5" stroke-dasharray="5 3" />
        </g>
        <text x="314" y="369" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#ff7b72">KALI</text>
        <text x="314" y="387" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#f85149">attacker / observer</text>
        <title>KALI</title>
      </g>
      <g data-node="SRV1" data-role="host">
        <circle cx="630" cy="354" r="30" fill="#131a21" stroke="#22d3ee" stroke-width="1.5" />
        <text x="630" y="358" text-anchor="middle" font-family="Courier New, monospace" fontSize="13" fontWeight="700" fill="#67e8f9">SRV1</text>
        <text x="630" y="372" text-anchor="middle" font-family="Courier New, monospace" fontSize="9" fill="#22d3ee">end host</text>
        <title>SRV1</title>
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
        initial_build: R1(Fa0/0)→SW1(Et0/0) · PC1(eth0)→SW1(Et0/1) · SW1(Et0/2)→SW2(Et0/1) · KALI(eth0)→SW1(Et0/3) · SRV1(e...
      </text>
    </svg>
$md$)
WHERE lab_id = 1;

UPDATE lab_topologies SET svg_large = verify_replace(svg_large,
  $md$<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 560 260" font-family="ui-monospace,monospace">
  <rect x="180" y="18" width="200" height="52" rx="9" fill="#fff" stroke="#14161a" stroke-width="1.5"/>
  <text x="280" y="42" text-anchor="middle" font-size="15" fill="#14161a" font-weight="600">SW1</text>
  <text x="280" y="60" text-anchor="middle" font-size="9" fill="#6b7480">CAM table · MAC flooding target</text>
  <line x1="100" y1="160" x2="210" y2="70" stroke="#6b7480" stroke-width="2"/>
  <text x="165" y="108" text-anchor="middle" font-size="8" fill="#6b7480">Et0/1</text>
  <line x1="280" y1="70" x2="460" y2="160" stroke="#6b7480" stroke-width="2"/>
  <text x="370" y="108" text-anchor="middle" font-size="8" fill="#6b7480">Et0/2</text>
  <line x1="280" y1="70" x2="280" y2="186" stroke="#e5484d" stroke-width="2" stroke-dasharray="5 4"/>
  <text x="294" y="130" font-size="8" fill="#e5484d">Et0/3</text>
  <rect x="12" y="160" width="150" height="44" rx="8" fill="#fff" stroke="#2563eb" stroke-width="1.5"/>
  <text x="87" y="184" text-anchor="middle" font-size="13" fill="#2563eb" font-weight="600">PC1</text>
  <text x="87" y="198" text-anchor="middle" font-size="9" fill="#6b7480">10.0.0.10 /24</text>
  <rect x="398" y="160" width="150" height="44" rx="8" fill="#fff" stroke="#2563eb" stroke-width="1.5"/>
  <text x="473" y="184" text-anchor="middle" font-size="13" fill="#2563eb" font-weight="600">PC2</text>
  <text x="473" y="198" text-anchor="middle" font-size="9" fill="#6b7480">10.0.0.20 /24</text>
  <rect x="200" y="196" width="160" height="44" rx="8" fill="#fff" stroke="#e5484d" stroke-width="1.5"/>
  <text x="280" y="220" text-anchor="middle" font-size="13" fill="#e5484d" font-weight="600">KALI (attacker)</text>
  <text x="280" y="234" text-anchor="middle" font-size="9" fill="#6b7480">macof · dsniff</text>
</svg>$md$,
  $md$<svg
      width="100%"
      viewBox="0 0 720 490"
      xmlns="http://www.w3.org/2000/svg"
      role="img"
      aria-label="NetBreaker Lab 3 topology: PC1(eth0)→SW1(Et0/1), PC2(eth0)→SW1(Et0/2), KALI(eth0)→SW1(Et0/3)"
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
        root@netbreaker:~/lab3$ topology --render
      </text>
      <g data-link="PC1:eth0↔SW1:Et0/1">
        <line x1="111" y1="165" x2="238" y2="74" stroke="#4d5560" stroke-width="1.5"
          data-node-a="PC1" data-iface-a="eth0" data-node-b="SW1" data-iface-b="Et0/1" />
        <title>PC1 eth0 ↔ SW1 Et0/1</title>
      </g>
      <g data-link="PC2:eth0↔SW1:Et0/2">
        <line x1="449" y1="165" x2="322" y2="74" stroke="#4d5560" stroke-width="1.5"
          data-node-a="PC2" data-iface-a="eth0" data-node-b="SW1" data-iface-b="Et0/2" />
        <title>PC2 eth0 ↔ SW1 Et0/2</title>
      </g>
      <g data-link="KALI:eth0↔SW1:Et0/3">
        <line x1="280" y1="188" x2="280" y2="74" stroke="#4d5560" stroke-width="1.5"
          data-node-a="KALI" data-iface-a="eth0" data-node-b="SW1" data-iface-b="Et0/3" />
        <title>KALI eth0 ↔ SW1 Et0/3</title>
      </g>
      <g data-port="SW1" data-iface="Et0/1">
        <rect x="202" y="85" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="223" y="98" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/1</text>
        <title>SW1 Et0/1</title>
      </g>
      <g data-port="SW1" data-iface="Et0/2">
        <rect x="325" y="73" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="346" y="86" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/2</text>
        <title>SW1 Et0/2</title>
      </g>
      <g data-port="SW1" data-iface="Et0/3">
        <rect x="266" y="89" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="287" y="102" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/3</text>
        <title>SW1 Et0/3</title>
      </g>
      <g data-port="PC1" data-iface="eth0">
        <rect x="114" y="147" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="135" y="160" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">eth0</text>
        <title>PC1 eth0</title>
      </g>
      <g data-port="PC2" data-iface="eth0">
        <rect x="412" y="136" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="433" y="149" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">eth0</text>
        <title>PC2 eth0</title>
      </g>
      <g data-port="KALI" data-iface="eth0">
        <rect x="266" y="155" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="287" y="168" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">eth0</text>
        <title>KALI eth0</title>
      </g>
      <g data-node="SW1" data-role="core">
        <rect x="210" y="14" width="140" height="60" rx="6" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
        <text x="280" y="50" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#e6edf3">SW1</text>
        <text x="280" y="68" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">l2 switch</text>
        <title>SW1</title>
      </g>
      <g data-node="PC1" data-role="host">
        <circle cx="87" cy="182" r="30" fill="#131a21" stroke="#22d3ee" stroke-width="1.5" />
        <text x="87" y="186" text-anchor="middle" font-family="Courier New, monospace" fontSize="13" fontWeight="700" fill="#67e8f9">PC1</text>
        <text x="87" y="200" text-anchor="middle" font-family="Courier New, monospace" fontSize="9" fill="#22d3ee">end host</text>
        <title>PC1</title>
      </g>
      <g data-node="PC2" data-role="host">
        <circle cx="473" cy="182" r="30" fill="#131a21" stroke="#22d3ee" stroke-width="1.5" />
        <text x="473" y="186" text-anchor="middle" font-family="Courier New, monospace" fontSize="13" fontWeight="700" fill="#67e8f9">PC2</text>
        <text x="473" y="200" text-anchor="middle" font-family="Courier New, monospace" fontSize="9" fill="#22d3ee">end host</text>
        <title>PC2</title>
      </g>
      <g data-node="KALI" data-role="attacker">
        <g filter="url(#glow)">
          <rect x="210" y="188" width="140" height="60" rx="6" fill="#1a0f11" stroke="#f85149" stroke-width="1.5" stroke-dasharray="5 3" />
        </g>
        <text x="280" y="224" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#ff7b72">KALI</text>
        <text x="280" y="242" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#f85149">attacker / observer</text>
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
        initial_build: PC1(eth0)→SW1(Et0/1) · PC2(eth0)→SW1(Et0/2) · KALI(eth0)→SW1(Et0/3)
      </text>
    </svg>
$md$)
WHERE lab_id = 3;

UPDATE lab_topologies SET svg_large = verify_replace(svg_large,
  $md$<svg viewBox="0 0 720 340" role="img" aria-label="Topology: R1 fronting a server subnet and R2 fronting a client subnet, joined on an OSPF transit segment through SW1, with a Kali attacker also on the transit segment">
      <!-- server subnet -->
      <rect x="40" y="26" width="150" height="46" rx="8" fill="#fff" stroke="#2563eb" stroke-width="1.5"/>
      <text x="115" y="46" text-anchor="middle" font-family="monospace" font-size="12" font-weight="700" fill="#0f172a">SERVER LAN</text>
      <text x="115" y="62" text-anchor="middle" font-family="monospace" font-size="10" fill="#64748b">10.0.20.0/24</text>

      <!-- R1 -->
      <rect x="55" y="120" width="120" height="46" rx="8" fill="#eff6ff" stroke="#2563eb" stroke-width="2"/>
      <text x="115" y="140" text-anchor="middle" font-family="monospace" font-size="14" font-weight="700" fill="#2563eb">R1</text>
      <text x="115" y="156" text-anchor="middle" font-family="monospace" font-size="9.5" fill="#64748b">.1 on transit</text>
      <line x1="115" y1="72" x2="115" y2="120" stroke="#2563eb" stroke-width="2"/>

      <!-- SW1 transit -->
      <rect x="300" y="120" width="130" height="46" rx="8" fill="#eff6ff" stroke="#2563eb" stroke-width="2"/>
      <text x="365" y="140" text-anchor="middle" font-family="monospace" font-size="13" font-weight="700" fill="#2563eb">SW1</text>
      <text x="365" y="156" text-anchor="middle" font-family="monospace" font-size="9.5" fill="#64748b">transit · 10.0.99.0/24</text>

      <!-- R2 -->
      <rect x="545" y="120" width="120" height="46" rx="8" fill="#eff6ff" stroke="#2563eb" stroke-width="2"/>
      <text x="605" y="140" text-anchor="middle" font-family="monospace" font-size="14" font-weight="700" fill="#2563eb">R2</text>
      <text x="605" y="156" text-anchor="middle" font-family="monospace" font-size="9.5" fill="#64748b">.2 on transit</text>

      <!-- client subnet -->
      <rect x="530" y="26" width="150" height="46" rx="8" fill="#fff" stroke="#2563eb" stroke-width="1.5"/>
      <text x="605" y="46" text-anchor="middle" font-family="monospace" font-size="12" font-weight="700" fill="#0f172a">CLIENT LAN</text>
      <text x="605" y="62" text-anchor="middle" font-family="monospace" font-size="10" fill="#64748b">10.0.10.0/24</text>
      <line x1="605" y1="72" x2="605" y2="120" stroke="#2563eb" stroke-width="2"/>

      <!-- transit links -->
      <line x1="175" y1="143" x2="300" y2="143" stroke="#2563eb" stroke-width="2"/>
      <line x1="430" y1="143" x2="545" y2="143" stroke="#2563eb" stroke-width="2"/>
      <text x="237" y="135" text-anchor="middle" font-family="monospace" font-size="9" fill="#16a34a">OSPF area 0</text>
      <text x="487" y="135" text-anchor="middle" font-family="monospace" font-size="9" fill="#16a34a">OSPF area 0</text>

      <!-- Kali on transit -->
      <line x1="365" y1="166" x2="365" y2="250" stroke="#e5484d" stroke-width="2" stroke-dasharray="6 4"/>
      <rect x="305" y="250" width="120" height="56" rx="8" fill="#fef2f2" stroke="#e5484d" stroke-width="1.5"/>
      <text x="365" y="272" text-anchor="middle" font-family="monospace" font-size="13" font-weight="700" fill="#e5484d">KALI</text>
      <text x="365" y="288" text-anchor="middle" font-family="monospace" font-size="9.5" fill="#e5484d">.66 · rogue OSPF</text>

      <text x="365" y="326" text-anchor="middle" font-family="monospace" font-size="10" fill="#94a3b8">on the transit segment, an unauthenticated router is just another neighbor</text>
    </svg>$md$,
  $md$<svg
      width="100%"
      viewBox="0 0 720 490"
      xmlns="http://www.w3.org/2000/svg"
      role="img"
      aria-label="NetBreaker Lab 4 topology: R1(Fa0/0)→SW1(Et0/0), R2(Fa0/0)→SW1(Et0/1), KALI(eth0)→SW1(Et0/2)"
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
        root@netbreaker:~/lab4$ topology --render
      </text>
      <g data-link="R1:Fa0/0↔SW1:Et0/0">
        <line x1="185" y1="143" x2="295" y2="143" stroke="#4d5560" stroke-width="1.5"
          data-node-a="R1" data-iface-a="Fa0/0" data-node-b="SW1" data-iface-b="Et0/0" />
        <title>R1 Fa0/0 ↔ SW1 Et0/0</title>
      </g>
      <g data-link="R2:Fa0/0↔SW1:Et0/1">
        <line x1="535" y1="143" x2="435" y2="143" stroke="#4d5560" stroke-width="1.5"
          data-node-a="R2" data-iface-a="Fa0/0" data-node-b="SW1" data-iface-b="Et0/1" />
        <title>R2 Fa0/0 ↔ SW1 Et0/1</title>
      </g>
      <g data-link="KALI:eth0↔SW1:Et0/2">
        <line x1="365" y1="248" x2="365" y2="173" stroke="#4d5560" stroke-width="1.5"
          data-node-a="KALI" data-iface-a="eth0" data-node-b="SW1" data-iface-b="Et0/2" />
        <title>KALI eth0 ↔ SW1 Et0/2</title>
      </g>
      <g data-port="SW1" data-iface="Et0/0">
        <rect x="250" y="141" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="271" y="154" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/0</text>
        <title>SW1 Et0/0</title>
      </g>
      <g data-port="SW1" data-iface="Et0/1">
        <rect x="438" y="127" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="459" y="140" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/1</text>
        <title>SW1 Et0/1</title>
      </g>
      <g data-port="SW1" data-iface="Et0/2">
        <rect x="351" y="188" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="372" y="201" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/2</text>
        <title>SW1 Et0/2</title>
      </g>
      <g data-port="R1" data-iface="Fa0/0">
        <rect x="188" y="141" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="209" y="154" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Fa0/0</text>
        <title>R1 Fa0/0</title>
      </g>
      <g data-port="R2" data-iface="Fa0/0">
        <rect x="490" y="127" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="511" y="140" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Fa0/0</text>
        <title>R2 Fa0/0</title>
      </g>
      <g data-port="KALI" data-iface="eth0">
        <rect x="351" y="215" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="372" y="228" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">eth0</text>
        <title>KALI eth0</title>
      </g>
      <g data-node="SW1" data-role="core">
        <rect x="295" y="113" width="140" height="60" rx="6" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
        <text x="365" y="149" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#e6edf3">SW1</text>
        <text x="365" y="167" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">l2 switch</text>
        <title>SW1</title>
      </g>
      <g data-node="R1" data-role="core">
        <rect x="45" y="113" width="140" height="60" rx="6" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
        <text x="115" y="149" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#e6edf3">R1</text>
        <text x="115" y="167" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">router</text>
        <title>R1</title>
      </g>
      <g data-node="R2" data-role="core">
        <rect x="535" y="113" width="140" height="60" rx="6" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
        <text x="605" y="149" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#e6edf3">R2</text>
        <text x="605" y="167" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">router</text>
        <title>R2</title>
      </g>
      <g data-node="KALI" data-role="attacker">
        <g filter="url(#glow)">
          <rect x="295" y="248" width="140" height="60" rx="6" fill="#1a0f11" stroke="#f85149" stroke-width="1.5" stroke-dasharray="5 3" />
        </g>
        <text x="365" y="284" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#ff7b72">KALI</text>
        <text x="365" y="302" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#f85149">attacker / observer</text>
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
        initial_build: R1(Fa0/0)→SW1(Et0/0) · R2(Fa0/0)→SW1(Et0/1) · KALI(eth0)→SW1(Et0/2)
      </text>
    </svg>
$md$)
WHERE lab_id = 4;

UPDATE lab_topologies SET svg_large = verify_replace(svg_large,
  $md$<svg viewBox="0 0 720 340" role="img" aria-label="R1 and R2 running HSRP with virtual IP .1, Kali on the same subnet, SW1 access switch">
      <rect x="40" y="30" width="150" height="50" rx="8" fill="#eff6ff" stroke="#2563eb" stroke-width="2"/>
      <text x="115" y="52" text-anchor="middle" font-family="monospace" font-size="14" font-weight="700" fill="#2563eb">R1</text>
      <text x="115" y="68" text-anchor="middle" font-family="monospace" font-size="9.5" fill="#64748b">HSRP pri 110 · .2</text>
      <rect x="530" y="30" width="150" height="50" rx="8" fill="#eff6ff" stroke="#2563eb" stroke-width="2"/>
      <text x="605" y="52" text-anchor="middle" font-family="monospace" font-size="14" font-weight="700" fill="#2563eb">R2</text>
      <text x="605" y="68" text-anchor="middle" font-family="monospace" font-size="9.5" fill="#64748b">HSRP pri 100 · .3</text>
      <rect x="285" y="30" width="150" height="50" rx="8" fill="#eff6ff" stroke="#2563eb" stroke-width="2"/>
      <text x="360" y="52" text-anchor="middle" font-family="monospace" font-size="14" font-weight="700" fill="#2563eb">SW1</text>
      <text x="360" y="68" text-anchor="middle" font-family="monospace" font-size="9.5" fill="#64748b">IOU L2 · VLAN 10</text>
      <line x1="190" y1="55" x2="285" y2="55" stroke="#2563eb" stroke-width="2"/>
      <text x="238" y="46" text-anchor="middle" font-family="monospace" font-size="9" fill="#64748b">e0/0</text>
      <line x1="435" y1="55" x2="530" y2="55" stroke="#2563eb" stroke-width="2"/>
      <text x="483" y="46" text-anchor="middle" font-family="monospace" font-size="9" fill="#64748b">e0/1</text>
      <line x1="360" y1="80" x2="360" y2="250" stroke="#e5484d" stroke-width="2" stroke-dasharray="6 4"/>
      <text x="375" y="170" font-family="monospace" font-size="9" fill="#e5484d">e0/2 · access</text>
      <rect x="300" y="250" width="120" height="56" rx="8" fill="#fef2f2" stroke="#e5484d" stroke-width="1.5"/>
      <text x="360" y="272" text-anchor="middle" font-family="monospace" font-size="13" font-weight="700" fill="#e5484d">KALI</text>
      <text x="360" y="288" text-anchor="middle" font-family="monospace" font-size="9.5" fill="#e5484d">HSRP hijacker</text>
      <text x="360" y="328" text-anchor="middle" font-family="monospace" font-size="10" fill="#94a3b8">VIP: 10.0.10.1 — whoever shouts loudest owns it</text>
    </svg>$md$,
  $md$<svg
      width="100%"
      viewBox="0 0 720 490"
      xmlns="http://www.w3.org/2000/svg"
      role="img"
      aria-label="NetBreaker Lab 5 topology: R1(Fa0/0)→SW1(Et0/0), R2(Fa0/0)→SW1(Et0/1), KALI(eth0)→SW1(Et0/2)"
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
        root@netbreaker:~/lab5$ topology --render
      </text>
      <g data-link="R1:Fa0/0↔SW1:Et0/0">
        <line x1="185" y1="55" x2="290" y2="55" stroke="#4d5560" stroke-width="1.5"
          data-node-a="R1" data-iface-a="Fa0/0" data-node-b="SW1" data-iface-b="Et0/0" />
        <title>R1 Fa0/0 ↔ SW1 Et0/0</title>
      </g>
      <g data-link="R2:Fa0/0↔SW1:Et0/1">
        <line x1="535" y1="55" x2="430" y2="55" stroke="#4d5560" stroke-width="1.5"
          data-node-a="R2" data-iface-a="Fa0/0" data-node-b="SW1" data-iface-b="Et0/1" />
        <title>R2 Fa0/0 ↔ SW1 Et0/1</title>
      </g>
      <g data-link="KALI:eth0↔SW1:Et0/2">
        <line x1="360" y1="248" x2="360" y2="85" stroke="#4d5560" stroke-width="1.5"
          data-node-a="KALI" data-iface-a="eth0" data-node-b="SW1" data-iface-b="Et0/2" />
        <title>KALI eth0 ↔ SW1 Et0/2</title>
      </g>
      <g data-port="SW1" data-iface="Et0/0">
        <rect x="245" y="53" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="266" y="66" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/0</text>
        <title>SW1 Et0/0</title>
      </g>
      <g data-port="SW1" data-iface="Et0/1">
        <rect x="433" y="39" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="454" y="52" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/1</text>
        <title>SW1 Et0/1</title>
      </g>
      <g data-port="SW1" data-iface="Et0/2">
        <rect x="346" y="100" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="367" y="113" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/2</text>
        <title>SW1 Et0/2</title>
      </g>
      <g data-port="R1" data-iface="Fa0/0">
        <rect x="188" y="53" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="209" y="66" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Fa0/0</text>
        <title>R1 Fa0/0</title>
      </g>
      <g data-port="R2" data-iface="Fa0/0">
        <rect x="490" y="39" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="511" y="52" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Fa0/0</text>
        <title>R2 Fa0/0</title>
      </g>
      <g data-port="KALI" data-iface="eth0">
        <rect x="346" y="215" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="367" y="228" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">eth0</text>
        <title>KALI eth0</title>
      </g>
      <g data-node="SW1" data-role="core">
        <rect x="290" y="25" width="140" height="60" rx="6" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
        <text x="360" y="61" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#e6edf3">SW1</text>
        <text x="360" y="79" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">l2 switch</text>
        <title>SW1</title>
      </g>
      <g data-node="R1" data-role="core">
        <rect x="45" y="25" width="140" height="60" rx="6" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
        <text x="115" y="61" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#e6edf3">R1</text>
        <text x="115" y="79" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">router</text>
        <title>R1</title>
      </g>
      <g data-node="R2" data-role="core">
        <rect x="535" y="25" width="140" height="60" rx="6" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
        <text x="605" y="61" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#e6edf3">R2</text>
        <text x="605" y="79" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">router</text>
        <title>R2</title>
      </g>
      <g data-node="KALI" data-role="attacker">
        <g filter="url(#glow)">
          <rect x="290" y="248" width="140" height="60" rx="6" fill="#1a0f11" stroke="#f85149" stroke-width="1.5" stroke-dasharray="5 3" />
        </g>
        <text x="360" y="284" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#ff7b72">KALI</text>
        <text x="360" y="302" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#f85149">attacker / observer</text>
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
        initial_build: R1(Fa0/0)→SW1(Et0/0) · R2(Fa0/0)→SW1(Et0/1) · KALI(eth0)→SW1(Et0/2)
      </text>
    </svg>
$md$)
WHERE lab_id = 5;

UPDATE lab_topologies SET svg_large = verify_replace(svg_large,
  $md$<svg viewBox="0 0 720 320" role="img" aria-label="Router as gateway and DHCP server, a switch, two clients, and a Kali attacker running a rogue DHCP server">
      <rect x="40" y="30" width="150" height="50" rx="8" fill="#eff6ff" stroke="#2563eb" stroke-width="2"/>
      <text x="115" y="52" text-anchor="middle" font-family="monospace" font-size="14" font-weight="700" fill="#2563eb">R1</text>
      <text x="115" y="68" text-anchor="middle" font-family="monospace" font-size="9.5" fill="#64748b">gateway + DHCP · 10.0.10.1</text>
      <rect x="300" y="30" width="130" height="50" rx="8" fill="#eff6ff" stroke="#2563eb" stroke-width="2"/>
      <text x="365" y="52" text-anchor="middle" font-family="monospace" font-size="14" font-weight="700" fill="#2563eb">SW1</text>
      <text x="365" y="68" text-anchor="middle" font-family="monospace" font-size="9.5" fill="#64748b">IOU L2 · VLAN 10</text>
      <line x1="190" y1="55" x2="300" y2="55" stroke="#2563eb" stroke-width="2"/>
      <text x="245" y="46" text-anchor="middle" font-family="monospace" font-size="9" fill="#16a34a">e0/0 · uplink</text>
      <line x1="330" y1="80" x2="160" y2="230" stroke="#2563eb" stroke-width="2"/>
      <line x1="365" y1="80" x2="365" y2="230" stroke="#2563eb" stroke-width="2"/>
      <line x1="400" y1="80" x2="575" y2="230" stroke="#e5484d" stroke-width="2" stroke-dasharray="6 4"/>
      <text x="255" y="160" font-family="monospace" font-size="9" fill="#64748b">e0/1</text>
      <text x="372" y="160" font-family="monospace" font-size="9" fill="#64748b">e0/2</text>
      <text x="475" y="160" font-family="monospace" font-size="9" fill="#e5484d">e0/3</text>
      <rect x="100" y="230" width="120" height="56" rx="8" fill="#fff" stroke="#2563eb" stroke-width="1.5"/>
      <text x="160" y="252" text-anchor="middle" font-family="monospace" font-size="13" font-weight="700" fill="#0f172a">PC1</text>
      <text x="160" y="268" text-anchor="middle" font-family="monospace" font-size="9.5" fill="#64748b">DHCP client</text>
      <rect x="305" y="230" width="120" height="56" rx="8" fill="#fff" stroke="#2563eb" stroke-width="1.5"/>
      <text x="365" y="252" text-anchor="middle" font-family="monospace" font-size="13" font-weight="700" fill="#0f172a">PC-B</text>
      <text x="365" y="268" text-anchor="middle" font-family="monospace" font-size="9.5" fill="#64748b">boots mid-attack</text>
      <rect x="515" y="230" width="120" height="56" rx="8" fill="#fef2f2" stroke="#e5484d" stroke-width="1.5"/>
      <text x="575" y="252" text-anchor="middle" font-family="monospace" font-size="13" font-weight="700" fill="#e5484d">KALI</text>
      <text x="575" y="268" text-anchor="middle" font-family="monospace" font-size="9.5" fill="#e5484d">rogue DHCP · .66</text>
      <text x="360" y="308" text-anchor="middle" font-family="monospace" font-size="10" fill="#94a3b8">two moves: drain R1's pool, then answer in its place</text>
    </svg>$md$,
  $md$<svg
      width="100%"
      viewBox="0 0 720 490"
      xmlns="http://www.w3.org/2000/svg"
      role="img"
      aria-label="NetBreaker Lab 8 topology: R1(Fa0/0)→SW1(Et0/0), PC1(eth0)→SW1(Et0/1), KALI(eth0)→SW1(Et0/3)"
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
        root@netbreaker:~/lab8$ topology --render
      </text>
      <g data-link="R1:Fa0/0↔SW1:Et0/0">
        <line x1="185" y1="55" x2="295" y2="55" stroke="#4d5560" stroke-width="1.5"
          data-node-a="R1" data-iface-a="Fa0/0" data-node-b="SW1" data-iface-b="Et0/0" />
        <title>R1 Fa0/0 ↔ SW1 Et0/0</title>
      </g>
      <g data-link="PC1:eth0↔SW1:Et0/1">
        <line x1="181" y1="237" x2="335" y2="85" stroke="#4d5560" stroke-width="1.5"
          data-node-a="PC1" data-iface-a="eth0" data-node-b="SW1" data-iface-b="Et0/1" />
        <title>PC1 eth0 ↔ SW1 Et0/1</title>
      </g>
      <g data-link="KALI:eth0↔SW1:Et0/3">
        <line x1="544" y1="228" x2="396" y2="85" stroke="#4d5560" stroke-width="1.5"
          data-node-a="KALI" data-iface-a="eth0" data-node-b="SW1" data-iface-b="Et0/3" />
        <title>KALI eth0 ↔ SW1 Et0/3</title>
      </g>
      <g data-port="R1" data-iface="Fa0/0">
        <rect x="188" y="53" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="209" y="66" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Fa0/0</text>
        <title>R1 Fa0/0</title>
      </g>
      <g data-port="SW1" data-iface="Et0/0">
        <rect x="250" y="53" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="271" y="66" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/0</text>
        <title>SW1 Et0/0</title>
      </g>
      <g data-port="SW1" data-iface="Et0/1">
        <rect x="302" y="98" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="323" y="111" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/1</text>
        <title>SW1 Et0/1</title>
      </g>
      <g data-port="SW1" data-iface="Et0/3">
        <rect x="397" y="88" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="418" y="101" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/3</text>
        <title>SW1 Et0/3</title>
      </g>
      <g data-port="PC1" data-iface="eth0">
        <rect x="182" y="216" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="203" y="229" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">eth0</text>
        <title>PC1 eth0</title>
      </g>
      <g data-port="KALI" data-iface="eth0">
        <rect x="511" y="197" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="532" y="210" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">eth0</text>
        <title>KALI eth0</title>
      </g>
      <g data-node="R1" data-role="core">
        <rect x="45" y="25" width="140" height="60" rx="6" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
        <text x="115" y="61" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#e6edf3">R1</text>
        <text x="115" y="79" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">router</text>
        <title>R1</title>
      </g>
      <g data-node="SW1" data-role="core">
        <rect x="295" y="25" width="140" height="60" rx="6" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
        <text x="365" y="61" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#e6edf3">SW1</text>
        <text x="365" y="79" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">l2 switch</text>
        <title>SW1</title>
      </g>
      <g data-node="PC1" data-role="host">
        <circle cx="160" cy="258" r="30" fill="#131a21" stroke="#22d3ee" stroke-width="1.5" />
        <text x="160" y="262" text-anchor="middle" font-family="Courier New, monospace" fontSize="13" fontWeight="700" fill="#67e8f9">PC1</text>
        <text x="160" y="276" text-anchor="middle" font-family="Courier New, monospace" fontSize="9" fill="#22d3ee">end host</text>
        <title>PC1</title>
      </g>
      <g data-node="KALI" data-role="attacker">
        <g filter="url(#glow)">
          <rect x="505" y="228" width="140" height="60" rx="6" fill="#1a0f11" stroke="#f85149" stroke-width="1.5" stroke-dasharray="5 3" />
        </g>
        <text x="575" y="264" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#ff7b72">KALI</text>
        <text x="575" y="282" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#f85149">attacker / observer</text>
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
        initial_build: R1(Fa0/0)→SW1(Et0/0) · PC1(eth0)→SW1(Et0/1) · KALI(eth0)→SW1(Et0/3)
      </text>
    </svg>
$md$)
WHERE lab_id = 8;

UPDATE lab_topologies SET svg_large = verify_replace(svg_large,
  $md$<svg viewBox="0 0 720 320" role="img" aria-label="Router as gateway and DNS, switch, two clients, and Kali intercepting DNS to redirect a domain">
      <rect x="40" y="30" width="150" height="50" rx="8" fill="#eff6ff" stroke="#2563eb" stroke-width="2"/>
      <text x="115" y="52" text-anchor="middle" font-family="monospace" font-size="14" font-weight="700" fill="#2563eb">R1</text>
      <text x="115" y="68" text-anchor="middle" font-family="monospace" font-size="9.5" fill="#64748b">gateway + real DNS</text>
      <rect x="300" y="30" width="130" height="50" rx="8" fill="#eff6ff" stroke="#2563eb" stroke-width="2"/>
      <text x="365" y="52" text-anchor="middle" font-family="monospace" font-size="14" font-weight="700" fill="#2563eb">SW1</text>
      <text x="365" y="68" text-anchor="middle" font-family="monospace" font-size="9.5" fill="#64748b">IOU L2</text>
      <line x1="190" y1="55" x2="300" y2="55" stroke="#2563eb" stroke-width="2"/>
      <line x1="310" y1="80" x2="100" y2="230" stroke="#2563eb" stroke-width="2"/>
      <line x1="365" y1="80" x2="365" y2="230" stroke="#2563eb" stroke-width="2"/>
      <line x1="420" y1="80" x2="630" y2="230" stroke="#e5484d" stroke-width="2" stroke-dasharray="6 4"/>
      <text x="195" y="160" font-family="monospace" font-size="9" fill="#64748b">e0/1</text>
      <text x="378" y="160" font-family="monospace" font-size="9" fill="#64748b">e0/2</text>
      <text x="505" y="160" font-family="monospace" font-size="9" fill="#e5484d">e0/3</text>
      <rect x="30" y="230" width="130" height="56" rx="8" fill="#fff" stroke="#2563eb" stroke-width="1.5"/>
      <text x="95" y="252" text-anchor="middle" font-family="monospace" font-size="13" font-weight="700" fill="#0f172a">PC-A</text>
      <text x="95" y="268" text-anchor="middle" font-family="monospace" font-size="9.5" fill="#64748b">DHCP client · DNS→Kali</text>
      <rect x="300" y="230" width="130" height="56" rx="8" fill="#fff" stroke="#2563eb" stroke-width="1.5"/>
      <text x="365" y="252" text-anchor="middle" font-family="monospace" font-size="13" font-weight="700" fill="#0f172a">PC-B</text>
      <text x="365" y="268" text-anchor="middle" font-family="monospace" font-size="9.5" fill="#64748b">visits "bank.com"</text>
      <rect x="570" y="230" width="120" height="56" rx="8" fill="#fef2f2" stroke="#e5484d" stroke-width="1.5"/>
      <text x="630" y="252" text-anchor="middle" font-family="monospace" font-size="13" font-weight="700" fill="#e5484d">KALI</text>
      <text x="630" y="268" text-anchor="middle" font-family="monospace" font-size="9.5" fill="#e5484d">dnschef · .66</text>
      <text x="360" y="308" text-anchor="middle" font-family="monospace" font-size="10" fill="#94a3b8">PC-B asks "where is bank.com?" — Kali answers first, with its own IP</text>
    </svg>$md$,
  $md$<svg
      width="100%"
      viewBox="0 0 720 490"
      xmlns="http://www.w3.org/2000/svg"
      role="img"
      aria-label="NetBreaker Lab 10 topology: R1(Fa0/0)→SW1(Et0/0), PC-A(eth0)→SW1(Et0/1), PC-B(eth0)→SW1(Et0/2), KALI(eth0)→SW1(Et0/3)"
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
        root@netbreaker:~/lab10$ topology --render
      </text>
      <g data-link="R1:Fa0/0↔SW1:Et0/0">
        <line x1="185" y1="55" x2="295" y2="55" stroke="#4d5560" stroke-width="1.5"
          data-node-a="R1" data-iface-a="Fa0/0" data-node-b="SW1" data-iface-b="Et0/0" />
        <title>R1 Fa0/0 ↔ SW1 Et0/0</title>
      </g>
      <g data-link="PC-A:eth0↔SW1:Et0/1">
        <line x1="119" y1="240" x2="325" y2="85" stroke="#4d5560" stroke-width="1.5"
          data-node-a="PC-A" data-iface-a="eth0" data-node-b="SW1" data-iface-b="Et0/1" />
        <title>PC-A eth0 ↔ SW1 Et0/1</title>
      </g>
      <g data-link="PC-B:eth0↔SW1:Et0/2">
        <line x1="365" y1="228" x2="365" y2="85" stroke="#4d5560" stroke-width="1.5"
          data-node-a="PC-B" data-iface-a="eth0" data-node-b="SW1" data-iface-b="Et0/2" />
        <title>PC-B eth0 ↔ SW1 Et0/2</title>
      </g>
      <g data-link="KALI:eth0↔SW1:Et0/3">
        <line x1="591" y1="228" x2="404" y2="85" stroke="#4d5560" stroke-width="1.5"
          data-node-a="KALI" data-iface-a="eth0" data-node-b="SW1" data-iface-b="Et0/3" />
        <title>KALI eth0 ↔ SW1 Et0/3</title>
      </g>
      <g data-port="R1" data-iface="Fa0/0">
        <rect x="188" y="53" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="209" y="66" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Fa0/0</text>
        <title>R1 Fa0/0</title>
      </g>
      <g data-port="SW1" data-iface="Et0/0">
        <rect x="250" y="53" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="271" y="66" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/0</text>
        <title>SW1 Et0/0</title>
      </g>
      <g data-port="SW1" data-iface="Et0/1">
        <rect x="289" y="96" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="310" y="109" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/1</text>
        <title>SW1 Et0/1</title>
      </g>
      <g data-port="SW1" data-iface="Et0/2">
        <rect x="351" y="100" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="372" y="113" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/2</text>
        <title>SW1 Et0/2</title>
      </g>
      <g data-port="SW1" data-iface="Et0/3">
        <rect x="406" y="85" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="427" y="98" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/3</text>
        <title>SW1 Et0/3</title>
      </g>
      <g data-port="PC-A" data-iface="eth0">
        <rect x="121" y="222" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="142" y="235" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">eth0</text>
        <title>PC-A eth0</title>
      </g>
      <g data-port="PC-B" data-iface="eth0">
        <rect x="351" y="195" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="372" y="208" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">eth0</text>
        <title>PC-B eth0</title>
      </g>
      <g data-port="KALI" data-iface="eth0">
        <rect x="555" y="199" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="576" y="212" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">eth0</text>
        <title>KALI eth0</title>
      </g>
      <g data-node="R1" data-role="core">
        <rect x="45" y="25" width="140" height="60" rx="6" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
        <text x="115" y="61" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#e6edf3">R1</text>
        <text x="115" y="79" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">router</text>
        <title>R1</title>
      </g>
      <g data-node="SW1" data-role="core">
        <rect x="295" y="25" width="140" height="60" rx="6" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
        <text x="365" y="61" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#e6edf3">SW1</text>
        <text x="365" y="79" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">l2 switch</text>
        <title>SW1</title>
      </g>
      <g data-node="PC-A" data-role="host">
        <circle cx="95" cy="258" r="30" fill="#131a21" stroke="#22d3ee" stroke-width="1.5" />
        <text x="95" y="262" text-anchor="middle" font-family="Courier New, monospace" fontSize="13" fontWeight="700" fill="#67e8f9">PC-A</text>
        <text x="95" y="276" text-anchor="middle" font-family="Courier New, monospace" fontSize="9" fill="#22d3ee">end host</text>
        <title>PC-A</title>
      </g>
      <g data-node="PC-B" data-role="host">
        <circle cx="365" cy="258" r="30" fill="#131a21" stroke="#22d3ee" stroke-width="1.5" />
        <text x="365" y="262" text-anchor="middle" font-family="Courier New, monospace" fontSize="13" fontWeight="700" fill="#67e8f9">PC-B</text>
        <text x="365" y="276" text-anchor="middle" font-family="Courier New, monospace" fontSize="9" fill="#22d3ee">end host</text>
        <title>PC-B</title>
      </g>
      <g data-node="KALI" data-role="attacker">
        <g filter="url(#glow)">
          <rect x="560" y="228" width="140" height="60" rx="6" fill="#1a0f11" stroke="#f85149" stroke-width="1.5" stroke-dasharray="5 3" />
        </g>
        <text x="630" y="264" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#ff7b72">KALI</text>
        <text x="630" y="282" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#f85149">attacker / observer</text>
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
        initial_build: R1(Fa0/0)→SW1(Et0/0) · PC-A(eth0)→SW1(Et0/1) · PC-B(eth0)→SW1(Et0/2) · KALI(eth0)→SW1(Et0/3)
      </text>
    </svg>
$md$)
WHERE lab_id = 10;

UPDATE lab_topologies SET svg_large = verify_replace(svg_large,
  $md$<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 700 380" font-family="ui-monospace,monospace">
  <rect x="230" y="20" width="240" height="50" rx="10" fill="#fff" stroke="#14161a" stroke-width="2"/>
  <text x="350" y="46" text-anchor="middle" font-size="15" fill="#14161a" font-weight="700">R1 · RADIUS Server</text>
  <text x="350" y="62" text-anchor="middle" font-size="10" fill="#6b7480">AAA · EAP · port 1812</text>
  <rect x="230" y="100" width="240" height="50" rx="10" fill="#fff" stroke="#6b7480" stroke-width="2"/>
  <text x="350" y="126" text-anchor="middle" font-size="14" fill="#14161a" font-weight="600">SW1 · 802.1X Authenticator</text>
  <text x="350" y="142" text-anchor="middle" font-size="10" fill="#6b7480">dot1x pae authenticator</text>
  <line x1="350" y1="70" x2="350" y2="100" stroke="#6b7480" stroke-width="2.5"/>
  <rect x="30" y="260" width="180" height="54" rx="10" fill="#fff" stroke="#2563eb" stroke-width="2"/>
  <text x="120" y="286" text-anchor="middle" font-size="14" fill="#2563eb" font-weight="600">PC1 ✅</text>
  <text x="120" y="304" text-anchor="middle" font-size="10" fill="#6b7480">supplicant · EAP-MD5</text>
  <rect x="260" y="260" width="180" height="54" rx="10" fill="#fff" stroke="#e5484d" stroke-width="2"/>
  <text x="350" y="286" text-anchor="middle" font-size="14" fill="#e5484d" font-weight="700">KALI ❌</text>
  <text x="350" y="304" text-anchor="middle" font-size="10" fill="#6b7480">EAP relay · MAB bypass · RADIUS DoS</text>
  <rect x="490" y="260" width="180" height="54" rx="10" fill="#fff" stroke="#6b7480" stroke-width="2"/>
  <text x="580" y="286" text-anchor="middle" font-size="14" fill="#6b7480" font-weight="600">PC2 ❌</text>
  <text x="580" y="304" text-anchor="middle" font-size="10" fill="#6b7480">no supplicant · port blocked</text>
  <line x1="120" y1="260" x2="290" y2="150" stroke="#2563eb" stroke-width="2"/>
  <line x1="350" y1="260" x2="350" y2="150" stroke="#e5484d" stroke-width="2" stroke-dasharray="6 5"/>
  <line x1="580" y1="260" x2="410" y2="150" stroke="#6b7480" stroke-width="2" stroke-dasharray="3 3"/>
</svg>$md$,
  $md$<svg
      width="100%"
      viewBox="0 0 720 490"
      xmlns="http://www.w3.org/2000/svg"
      role="img"
      aria-label="NetBreaker Lab 12 topology: R1(Fa0/0)→SW1(Et0/0), PC1(eth0)→SW1(Et0/1), KALI(eth0)→SW1(Et0/2), PC2(eth0)→SW1(Et0/3)"
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
        root@netbreaker:~/lab12$ topology --render
      </text>
      <g data-link="R1:Fa0/0↔SW1:Et0/0">
        <line x1="350" y1="75" x2="350" y2="95" stroke="#4d5560" stroke-width="1.5"
          data-node-a="R1" data-iface-a="Fa0/0" data-node-b="SW1" data-iface-b="Et0/0" />
        <title>R1 Fa0/0 ↔ SW1 Et0/0</title>
      </g>
      <g data-link="PC1:eth0↔SW1:Et0/1">
        <line x1="145" y1="270" x2="307" y2="155" stroke="#4d5560" stroke-width="1.5"
          data-node-a="PC1" data-iface-a="eth0" data-node-b="SW1" data-iface-b="Et0/1" />
        <title>PC1 eth0 ↔ SW1 Et0/1</title>
      </g>
      <g data-link="KALI:eth0↔SW1:Et0/2">
        <line x1="350" y1="257" x2="350" y2="155" stroke="#4d5560" stroke-width="1.5"
          data-node-a="KALI" data-iface-a="eth0" data-node-b="SW1" data-iface-b="Et0/2" />
        <title>KALI eth0 ↔ SW1 Et0/2</title>
      </g>
      <g data-link="PC2:eth0↔SW1:Et0/3">
        <line x1="555" y1="270" x2="393" y2="155" stroke="#4d5560" stroke-width="1.5"
          data-node-a="PC2" data-iface-a="eth0" data-node-b="SW1" data-iface-b="Et0/3" />
        <title>PC2 eth0 ↔ SW1 Et0/3</title>
      </g>
      <g data-port="R1" data-iface="Fa0/0">
        <rect x="322" y="90" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="343" y="103" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Fa0/0</text>
        <title>R1 Fa0/0</title>
      </g>
      <g data-port="SW1" data-iface="Et0/0">
        <rect x="322" y="62" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="343" y="75" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/0</text>
        <title>SW1 Et0/0</title>
      </g>
      <g data-port="SW1" data-iface="Et0/1">
        <rect x="271" y="166" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="292" y="179" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/1</text>
        <title>SW1 Et0/1</title>
      </g>
      <g data-port="SW1" data-iface="Et0/2">
        <rect x="336" y="170" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="357" y="183" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/2</text>
        <title>SW1 Et0/2</title>
      </g>
      <g data-port="SW1" data-iface="Et0/3">
        <rect x="395" y="154" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="416" y="167" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/3</text>
        <title>SW1 Et0/3</title>
      </g>
      <g data-port="PC1" data-iface="eth0">
        <rect x="147" y="253" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="168" y="266" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">eth0</text>
        <title>PC1 eth0</title>
      </g>
      <g data-port="PC2" data-iface="eth0">
        <rect x="519" y="241" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="540" y="254" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">eth0</text>
        <title>PC2 eth0</title>
      </g>
      <g data-port="KALI" data-iface="eth0">
        <rect x="336" y="224" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="357" y="237" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">eth0</text>
        <title>KALI eth0</title>
      </g>
      <g data-node="R1" data-role="core">
        <rect x="280" y="15" width="140" height="60" rx="6" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
        <text x="350" y="51" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#e6edf3">R1</text>
        <text x="350" y="69" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">router</text>
        <title>R1</title>
      </g>
      <g data-node="SW1" data-role="core">
        <rect x="280" y="95" width="140" height="60" rx="6" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
        <text x="350" y="131" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#e6edf3">SW1</text>
        <text x="350" y="149" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">l2 switch</text>
        <title>SW1</title>
      </g>
      <g data-node="PC1" data-role="host">
        <circle cx="120" cy="287" r="30" fill="#131a21" stroke="#22d3ee" stroke-width="1.5" />
        <text x="120" y="291" text-anchor="middle" font-family="Courier New, monospace" fontSize="13" fontWeight="700" fill="#67e8f9">PC1</text>
        <text x="120" y="305" text-anchor="middle" font-family="Courier New, monospace" fontSize="9" fill="#22d3ee">end host</text>
        <title>PC1</title>
      </g>
      <g data-node="PC2" data-role="host">
        <circle cx="580" cy="287" r="30" fill="#131a21" stroke="#22d3ee" stroke-width="1.5" />
        <text x="580" y="291" text-anchor="middle" font-family="Courier New, monospace" fontSize="13" fontWeight="700" fill="#67e8f9">PC2</text>
        <text x="580" y="305" text-anchor="middle" font-family="Courier New, monospace" fontSize="9" fill="#22d3ee">end host</text>
        <title>PC2</title>
      </g>
      <g data-node="KALI" data-role="attacker">
        <g filter="url(#glow)">
          <rect x="280" y="257" width="140" height="60" rx="6" fill="#1a0f11" stroke="#f85149" stroke-width="1.5" stroke-dasharray="5 3" />
        </g>
        <text x="350" y="293" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#ff7b72">KALI</text>
        <text x="350" y="311" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#f85149">attacker / observer</text>
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
        initial_build: R1(Fa0/0)→SW1(Et0/0) · PC1(eth0)→SW1(Et0/1) · KALI(eth0)→SW1(Et0/2) · PC2(eth0)→SW1(Et0/3)
      </text>
    </svg>
$md$)
WHERE lab_id = 12;

UPDATE lab_topologies SET svg_large = verify_replace(svg_large,
  $md$<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 700 380" font-family="ui-monospace,monospace">
   <rect x="230" y="20" width="240" height="50" rx="10" fill="#fff" stroke="#14161a" stroke-width="2"/>
   <text x="350" y="46" text-anchor="middle" font-size="15" fill="#14161a" font-weight="700">R1 · IPv6 Gateway</text>
   <text x="350" y="62" text-anchor="middle" font-size="10" fill="#6b7480">2001:db8:1::1/64 · RA every 200s</text>
   <rect x="230" y="100" width="240" height="46" rx="10" fill="#fff" stroke="#6b7480" stroke-width="2"/>
   <text x="350" y="126" text-anchor="middle" font-size="14" fill="#14161a" font-weight="600">SW1 · RA Guard</text>
   <text x="350" y="142" text-anchor="middle" font-size="10" fill="#6b7480">port Gi0/3: untrusted · RAs dropped</text>
   <line x1="350" y1="70" x2="350" y2="100" stroke="#6b7480" stroke-width="2.5"/>
   <rect x="40" y="250" width="180" height="54" rx="10" fill="#fff" stroke="#2563eb" stroke-width="2"/>
   <text x="130" y="276" text-anchor="middle" font-size="14" fill="#2563eb" font-weight="600">PC1</text>
   <text x="130" y="294" text-anchor="middle" font-size="10" fill="#6b7480">SLAAC: 2001:db8:1::100</text>
   <rect x="260" y="250" width="180" height="54" rx="10" fill="#fff" stroke="#2563eb" stroke-width="2"/>
   <text x="350" y="276" text-anchor="middle" font-size="14" fill="#2563eb" font-weight="600">PC2</text>
   <text x="350" y="294" text-anchor="middle" font-size="10" fill="#6b7480">SLAAC: 2001:db8:1::200</text>
   <rect x="480" y="250" width="180" height="54" rx="10" fill="#fff" stroke="#e5484d" stroke-width="2"/>
   <text x="570" y="276" text-anchor="middle" font-size="14" fill="#e5484d" font-weight="700">KALI</text>
   <text x="570" y="294" text-anchor="middle" font-size="10" fill="#6b7480">rogue RA · NA spoof · mitm6</text>
   <line x1="130" y1="250" x2="290" y2="146" stroke="#2563eb" stroke-width="2"/>
   <line x1="350" y1="250" x2="350" y2="146" stroke="#2563eb" stroke-width="2"/>
   <line x1="480" y1="276" x2="410" y2="146" stroke="#e5484d" stroke-width="2" stroke-dasharray="6 5"/>
 </svg>$md$,
  $md$<svg
      width="100%"
      viewBox="0 0 720 490"
      xmlns="http://www.w3.org/2000/svg"
      role="img"
      aria-label="NetBreaker Lab 14 topology: R1(Fa0/0)→SW1(Et0/0), PC1(eth0)→SW1(Et0/1), PC2(eth0)→SW1(Et0/2), KALI(eth0)→SW1(Et0/3)"
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
        root@netbreaker:~/lab14$ topology --render
      </text>
      <g data-link="R1:Fa0/0↔SW1:Et0/0">
        <line x1="350" y1="75" x2="350" y2="93" stroke="#4d5560" stroke-width="1.5"
          data-node-a="R1" data-iface-a="Fa0/0" data-node-b="SW1" data-iface-b="Et0/0" />
        <title>R1 Fa0/0 ↔ SW1 Et0/0</title>
      </g>
      <g data-link="PC1:eth0↔SW1:Et0/1">
        <line x1="155" y1="260" x2="307" y2="153" stroke="#4d5560" stroke-width="1.5"
          data-node-a="PC1" data-iface-a="eth0" data-node-b="SW1" data-iface-b="Et0/1" />
        <title>PC1 eth0 ↔ SW1 Et0/1</title>
      </g>
      <g data-link="PC2:eth0↔SW1:Et0/2">
        <line x1="350" y1="247" x2="350" y2="153" stroke="#4d5560" stroke-width="1.5"
          data-node-a="PC2" data-iface-a="eth0" data-node-b="SW1" data-iface-b="Et0/2" />
        <title>PC2 eth0 ↔ SW1 Et0/2</title>
      </g>
      <g data-link="KALI:eth0↔SW1:Et0/3">
        <line x1="527" y1="247" x2="393" y2="153" stroke="#4d5560" stroke-width="1.5"
          data-node-a="KALI" data-iface-a="eth0" data-node-b="SW1" data-iface-b="Et0/3" />
        <title>KALI eth0 ↔ SW1 Et0/3</title>
      </g>
      <g data-port="R1" data-iface="Fa0/0">
        <rect x="322" y="90" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="343" y="103" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Fa0/0</text>
        <title>R1 Fa0/0</title>
      </g>
      <g data-port="SW1" data-iface="Et0/0">
        <rect x="322" y="60" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="343" y="73" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/0</text>
        <title>SW1 Et0/0</title>
      </g>
      <g data-port="SW1" data-iface="Et0/1">
        <rect x="270" y="163" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="291" y="176" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/1</text>
        <title>SW1 Et0/1</title>
      </g>
      <g data-port="SW1" data-iface="Et0/2">
        <rect x="336" y="168" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="357" y="181" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/2</text>
        <title>SW1 Et0/2</title>
      </g>
      <g data-port="SW1" data-iface="Et0/3">
        <rect x="396" y="152" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="417" y="165" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/3</text>
        <title>SW1 Et0/3</title>
      </g>
      <g data-port="PC1" data-iface="eth0">
        <rect x="157" y="243" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="178" y="256" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">eth0</text>
        <title>PC1 eth0</title>
      </g>
      <g data-port="PC2" data-iface="eth0">
        <rect x="336" y="214" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="357" y="227" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">eth0</text>
        <title>PC2 eth0</title>
      </g>
      <g data-port="KALI" data-iface="eth0">
        <rect x="490" y="219" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="511" y="232" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">eth0</text>
        <title>KALI eth0</title>
      </g>
      <g data-node="R1" data-role="core">
        <rect x="280" y="15" width="140" height="60" rx="6" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
        <text x="350" y="51" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#e6edf3">R1</text>
        <text x="350" y="69" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">router</text>
        <title>R1</title>
      </g>
      <g data-node="SW1" data-role="core">
        <rect x="280" y="93" width="140" height="60" rx="6" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
        <text x="350" y="129" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#e6edf3">SW1</text>
        <text x="350" y="147" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">l2 switch</text>
        <title>SW1</title>
      </g>
      <g data-node="PC1" data-role="host">
        <circle cx="130" cy="277" r="30" fill="#131a21" stroke="#22d3ee" stroke-width="1.5" />
        <text x="130" y="281" text-anchor="middle" font-family="Courier New, monospace" fontSize="13" fontWeight="700" fill="#67e8f9">PC1</text>
        <text x="130" y="295" text-anchor="middle" font-family="Courier New, monospace" fontSize="9" fill="#22d3ee">end host</text>
        <title>PC1</title>
      </g>
      <g data-node="PC2" data-role="host">
        <circle cx="350" cy="277" r="30" fill="#131a21" stroke="#22d3ee" stroke-width="1.5" />
        <text x="350" y="281" text-anchor="middle" font-family="Courier New, monospace" fontSize="13" fontWeight="700" fill="#67e8f9">PC2</text>
        <text x="350" y="295" text-anchor="middle" font-family="Courier New, monospace" fontSize="9" fill="#22d3ee">end host</text>
        <title>PC2</title>
      </g>
      <g data-node="KALI" data-role="attacker">
        <g filter="url(#glow)">
          <rect x="500" y="247" width="140" height="60" rx="6" fill="#1a0f11" stroke="#f85149" stroke-width="1.5" stroke-dasharray="5 3" />
        </g>
        <text x="570" y="283" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#ff7b72">KALI</text>
        <text x="570" y="301" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#f85149">attacker / observer</text>
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
        initial_build: R1(Fa0/0)→SW1(Et0/0) · PC1(eth0)→SW1(Et0/1) · PC2(eth0)→SW1(Et0/2) · KALI(eth0)→SW1(Et0/3)
      </text>
    </svg>
$md$)
WHERE lab_id = 14;

UPDATE lab_topologies SET svg_large = verify_replace(svg_large,
  $md$<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 700 340" font-family="ui-monospace,monospace">
  <rect x="40" y="20" width="160" height="44" rx="8" fill="#fff" stroke="#2563eb" stroke-width="1.5"/>
  <text x="120" y="42" text-anchor="middle" font-size="13" fill="#2563eb" font-weight="600">PC1 (client)</text>
  <text x="120" y="58" text-anchor="middle" font-size="8" fill="#6b7480">App → L7 → L4 → L3 → L2 → wire</text>
  <rect x="250" y="20" width="200" height="44" rx="8" fill="#fff" stroke="#6b7480" stroke-width="1.5"/>
  <text x="350" y="42" text-anchor="middle" font-size="13" fill="#14161a" font-weight="600">SW1 (L2 switch)</text>
  <text x="350" y="58" text-anchor="middle" font-size="8" fill="#6b7480">DHCP snoop · DAI · port-security</text>
  <rect x="500" y="20" width="160" height="44" rx="8" fill="#fff" stroke="#14161a" stroke-width="1.5"/>
  <text x="580" y="42" text-anchor="middle" font-size="13" fill="#14161a" font-weight="600">R1 (gateway)</text>
  <text x="580" y="58" text-anchor="middle" font-size="8" fill="#6b7480">uRPF · TCP intercept · ACL</text>
  <line x1="200" y1="42" x2="250" y2="42" stroke="#2563eb" stroke-width="2"/>
  <line x1="450" y1="42" x2="500" y2="42" stroke="#6b7480" stroke-width="2"/>
  <rect x="500" y="140" width="160" height="44" rx="8" fill="#fff" stroke="#2563eb" stroke-width="1.5"/>
  <text x="580" y="162" text-anchor="middle" font-size="13" fill="#2563eb" font-weight="600">PC2 (server)</text>
  <text x="580" y="178" text-anchor="middle" font-size="8" fill="#6b7480">HTTP · responds to PC1</text>
  <rect x="40" y="220" width="200" height="54" rx="8" fill="#fff" stroke="#e5484d" stroke-width="1.5"/>
  <text x="140" y="244" text-anchor="middle" font-size="13" fill="#e5484d" font-weight="600">KALI</text>
  <text x="140" y="262" text-anchor="middle" font-size="9" fill="#6b7480">L2: ARP spoof · L3: fragment · L4: SYN flood</text>
  <line x1="580" y1="64" x2="580" y2="140" stroke="#2563eb" stroke-width="2"/>
  <line x1="140" y1="220" x2="320" y2="64" stroke="#e5484d" stroke-width="2" stroke-dasharray="6 5"/>
</svg>$md$,
  $md$<svg
      width="100%"
      viewBox="0 0 720 490"
      xmlns="http://www.w3.org/2000/svg"
      role="img"
      aria-label="NetBreaker Lab 17 topology: R1(Fa0/0)→SW1(Et0/0), PC1(eth0)→SW1(Et0/1), PC2(eth0)→SW1(Et0/2), KALI(eth0)→SW1(Et0/3)"
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
        root@netbreaker:~/lab17$ topology --render
      </text>
      <g data-link="R1:Fa0/0↔SW1:Et0/0">
        <line x1="510" y1="42" x2="420" y2="42" stroke="#4d5560" stroke-width="1.5"
          data-node-a="R1" data-iface-a="Fa0/0" data-node-b="SW1" data-iface-b="Et0/0" />
        <title>R1 Fa0/0 ↔ SW1 Et0/0</title>
      </g>
      <g data-link="PC1:eth0↔SW1:Et0/1">
        <line x1="150" y1="42" x2="280" y2="42" stroke="#4d5560" stroke-width="1.5"
          data-node-a="PC1" data-iface-a="eth0" data-node-b="SW1" data-iface-b="Et0/1" />
        <title>PC1 eth0 ↔ SW1 Et0/1</title>
      </g>
      <g data-link="PC2:eth0↔SW1:Et0/2">
        <line x1="553" y1="148" x2="408" y2="72" stroke="#4d5560" stroke-width="1.5"
          data-node-a="PC2" data-iface-a="eth0" data-node-b="SW1" data-iface-b="Et0/2" />
        <title>PC2 eth0 ↔ SW1 Et0/2</title>
      </g>
      <g data-link="KALI:eth0↔SW1:Et0/3">
        <line x1="171" y1="217" x2="319" y2="72" stroke="#4d5560" stroke-width="1.5"
          data-node-a="KALI" data-iface-a="eth0" data-node-b="SW1" data-iface-b="Et0/3" />
        <title>KALI eth0 ↔ SW1 Et0/3</title>
      </g>
      <g data-port="R1" data-iface="Fa0/0">
        <rect x="465" y="26" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="486" y="39" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Fa0/0</text>
        <title>R1 Fa0/0</title>
      </g>
      <g data-port="SW1" data-iface="Et0/0">
        <rect x="423" y="26" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="444" y="39" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/0</text>
        <title>SW1 Et0/0</title>
      </g>
      <g data-port="SW1" data-iface="Et0/1">
        <rect x="235" y="40" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="256" y="53" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/1</text>
        <title>SW1 Et0/1</title>
      </g>
      <g data-port="SW1" data-iface="Et0/2">
        <rect x="411" y="68" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="432" y="81" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/2</text>
        <title>SW1 Et0/2</title>
      </g>
      <g data-port="SW1" data-iface="Et0/3">
        <rect x="286" y="85" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="307" y="98" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/3</text>
        <title>SW1 Et0/3</title>
      </g>
      <g data-port="PC1" data-iface="eth0">
        <rect x="153" y="40" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="174" y="53" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">eth0</text>
        <title>PC1 eth0</title>
      </g>
      <g data-port="PC2" data-iface="eth0">
        <rect x="514" y="122" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="535" y="135" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">eth0</text>
        <title>PC2 eth0</title>
      </g>
      <g data-port="KALI" data-iface="eth0">
        <rect x="172" y="196" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="193" y="209" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">eth0</text>
        <title>KALI eth0</title>
      </g>
      <g data-node="R1" data-role="core">
        <rect x="510" y="12" width="140" height="60" rx="6" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
        <text x="580" y="48" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#e6edf3">R1</text>
        <text x="580" y="66" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">router</text>
        <title>R1</title>
      </g>
      <g data-node="SW1" data-role="core">
        <rect x="280" y="12" width="140" height="60" rx="6" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
        <text x="350" y="48" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#e6edf3">SW1</text>
        <text x="350" y="66" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">l2 switch</text>
        <title>SW1</title>
      </g>
      <g data-node="PC1" data-role="host">
        <circle cx="120" cy="42" r="30" fill="#131a21" stroke="#22d3ee" stroke-width="1.5" />
        <text x="120" y="46" text-anchor="middle" font-family="Courier New, monospace" fontSize="13" fontWeight="700" fill="#67e8f9">PC1</text>
        <text x="120" y="60" text-anchor="middle" font-family="Courier New, monospace" fontSize="9" fill="#22d3ee">end host</text>
        <title>PC1</title>
      </g>
      <g data-node="PC2" data-role="host">
        <circle cx="580" cy="162" r="30" fill="#131a21" stroke="#22d3ee" stroke-width="1.5" />
        <text x="580" y="166" text-anchor="middle" font-family="Courier New, monospace" fontSize="13" fontWeight="700" fill="#67e8f9">PC2</text>
        <text x="580" y="180" text-anchor="middle" font-family="Courier New, monospace" fontSize="9" fill="#22d3ee">end host</text>
        <title>PC2</title>
      </g>
      <g data-node="KALI" data-role="attacker">
        <g filter="url(#glow)">
          <rect x="70" y="217" width="140" height="60" rx="6" fill="#1a0f11" stroke="#f85149" stroke-width="1.5" stroke-dasharray="5 3" />
        </g>
        <text x="140" y="253" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#ff7b72">KALI</text>
        <text x="140" y="271" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#f85149">attacker / observer</text>
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
        initial_build: R1(Fa0/0)→SW1(Et0/0) · PC1(eth0)→SW1(Et0/1) · PC2(eth0)→SW1(Et0/2) · KALI(eth0)→SW1(Et0/3)
      </text>
    </svg>
$md$)
WHERE lab_id = 17;

UPDATE lab_topologies SET svg_large = verify_replace(svg_large,
  $md$<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 600 260" font-family="ui-monospace,monospace">
  <rect x="40" y="20" width="180" height="50" rx="10" fill="#fff" stroke="#14161a" stroke-width="2"/>
  <text x="130" y="46" text-anchor="middle" font-size="14" fill="#14161a" font-weight="600">R1 · CLI Target</text>
  <text x="130" y="62" text-anchor="middle" font-size="9" fill="#6b7480">IP: 192.168.1.1 · SNMP: public/private</text>
  <rect x="380" y="20" width="180" height="50" rx="10" fill="#fff" stroke="#6b7480" stroke-width="2"/>
  <text x="470" y="46" text-anchor="middle" font-size="14" fill="#14161a" font-weight="600">SW1</text>
  <text x="470" y="62" text-anchor="middle" font-size="9" fill="#6b7480">management interface</text>
  <rect x="40" y="160" width="200" height="54" rx="10" fill="#fff" stroke="#e5484d" stroke-width="2"/>
  <text x="140" y="186" text-anchor="middle" font-size="13" fill="#e5484d" font-weight="600">KALI (attacker)</text>
  <text x="140" y="204" text-anchor="middle" font-size="9" fill="#6b7480">SSH · SNMP · tcpdump port 23</text>
  <rect x="380" y="160" width="180" height="54" rx="10" fill="#fff" stroke="#2563eb" stroke-width="2"/>
  <text x="470" y="186" text-anchor="middle" font-size="13" fill="#2563eb" font-weight="600">PC1 (admin)</text>
  <text x="470" y="204" text-anchor="middle" font-size="9" fill="#6b7480">SSH / Telnet to R1</text>
  <line x1="130" y1="160" x2="130" y2="70" stroke="#e5484d" stroke-width="2" stroke-dasharray="6 5"/>
  <line x1="470" y1="160" x2="200" y2="70" stroke="#2563eb" stroke-width="2"/>
</svg>$md$,
  $md$<svg
      width="100%"
      viewBox="0 0 720 490"
      xmlns="http://www.w3.org/2000/svg"
      role="img"
      aria-label="NetBreaker Lab 18 topology: R1(Fa0/0)→SW1(Et0/0), PC1(eth0)→SW1(Et0/1), KALI(eth0)→SW1(Et0/2)"
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
        root@netbreaker:~/lab18$ topology --render
      </text>
      <g data-link="R1:Fa0/0↔SW1:Et0/0">
        <line x1="200" y1="45" x2="400" y2="45" stroke="#4d5560" stroke-width="1.5"
          data-node-a="R1" data-iface-a="Fa0/0" data-node-b="SW1" data-iface-b="Et0/0" />
        <title>R1 Fa0/0 ↔ SW1 Et0/0</title>
      </g>
      <g data-link="PC1:eth0↔SW1:Et0/1">
        <line x1="470" y1="157" x2="470" y2="75" stroke="#4d5560" stroke-width="1.5"
          data-node-a="PC1" data-iface-a="eth0" data-node-b="SW1" data-iface-b="Et0/1" />
        <title>PC1 eth0 ↔ SW1 Et0/1</title>
      </g>
      <g data-link="KALI:eth0↔SW1:Et0/2">
        <line x1="210" y1="157" x2="400" y2="75" stroke="#4d5560" stroke-width="1.5"
          data-node-a="KALI" data-iface-a="eth0" data-node-b="SW1" data-iface-b="Et0/2" />
        <title>KALI eth0 ↔ SW1 Et0/2</title>
      </g>
      <g data-port="R1" data-iface="Fa0/0">
        <rect x="203" y="43" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="224" y="56" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Fa0/0</text>
        <title>R1 Fa0/0</title>
      </g>
      <g data-port="SW1" data-iface="Et0/0">
        <rect x="355" y="42" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="376" y="55" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/0</text>
        <title>SW1 Et0/0</title>
      </g>
      <g data-port="SW1" data-iface="Et0/1">
        <rect x="456" y="90" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="477" y="103" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/1</text>
        <title>SW1 Et0/1</title>
      </g>
      <g data-port="SW1" data-iface="Et0/2">
        <rect x="360" y="82" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="381" y="95" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/2</text>
        <title>SW1 Et0/2</title>
      </g>
      <g data-port="PC1" data-iface="eth0">
        <rect x="456" y="124" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="477" y="137" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">eth0</text>
        <title>PC1 eth0</title>
      </g>
      <g data-port="KALI" data-iface="eth0">
        <rect x="214" y="145" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="235" y="158" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">eth0</text>
        <title>KALI eth0</title>
      </g>
      <g data-node="R1" data-role="core">
        <rect x="60" y="15" width="140" height="60" rx="6" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
        <text x="130" y="51" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#e6edf3">R1</text>
        <text x="130" y="69" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">router</text>
        <title>R1</title>
      </g>
      <g data-node="SW1" data-role="core">
        <rect x="400" y="15" width="140" height="60" rx="6" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
        <text x="470" y="51" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#e6edf3">SW1</text>
        <text x="470" y="69" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">l2 switch</text>
        <title>SW1</title>
      </g>
      <g data-node="PC1" data-role="host">
        <circle cx="470" cy="187" r="30" fill="#131a21" stroke="#22d3ee" stroke-width="1.5" />
        <text x="470" y="191" text-anchor="middle" font-family="Courier New, monospace" fontSize="13" fontWeight="700" fill="#67e8f9">PC1</text>
        <text x="470" y="205" text-anchor="middle" font-family="Courier New, monospace" fontSize="9" fill="#22d3ee">end host</text>
        <title>PC1</title>
      </g>
      <g data-node="KALI" data-role="attacker">
        <g filter="url(#glow)">
          <rect x="70" y="157" width="140" height="60" rx="6" fill="#1a0f11" stroke="#f85149" stroke-width="1.5" stroke-dasharray="5 3" />
        </g>
        <text x="140" y="193" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#ff7b72">KALI</text>
        <text x="140" y="211" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#f85149">attacker / observer</text>
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
        initial_build: R1(Fa0/0)→SW1(Et0/0) · PC1(eth0)→SW1(Et0/1) · KALI(eth0)→SW1(Et0/2)
      </text>
    </svg>
$md$)
WHERE lab_id = 18;

UPDATE lab_topologies SET svg_large = verify_replace(svg_large,
  $md$<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 700 340" font-family="ui-monospace,monospace">
  <rect x="220" y="14" width="260" height="50" rx="10" fill="#fff" stroke="#6b7480" stroke-width="2"/>
  <text x="350" y="40" text-anchor="middle" font-size="15" fill="#14161a" font-weight="600">SW1 · L2 Switch</text>
  <text x="350" y="56" text-anchor="middle" font-size="9" fill="#6b7480">Gi0/1: V10 · Gi0/2: V20 · Gi0/24: trunk</text>
  <line x1="120" y1="130" x2="280" y2="64" stroke="#2563eb" stroke-width="2.5"/>
  <line x1="420" y1="64" x2="580" y2="130" stroke="#14161a" stroke-width="2.5"/>
  <line x1="350" y1="64" x2="350" y2="220" stroke="#e5484d" stroke-width="2.5" stroke-dasharray="6 5"/>
  <rect x="30" y="130" width="180" height="50" rx="10" fill="#fff" stroke="#2563eb" stroke-width="2"/>
  <text x="120" y="156" text-anchor="middle" font-size="13" fill="#2563eb" font-weight="600">PC1 · VLAN 10</text>
  <text x="120" y="174" text-anchor="middle" font-size="9" fill="#6b7480">192.168.10.10/24 · access port</text>
  <rect x="490" y="130" width="180" height="50" rx="10" fill="#fff" stroke="#14161a" stroke-width="2"/>
  <text x="580" y="156" text-anchor="middle" font-size="13" fill="#14161a" font-weight="600">R1 · Router</text>
  <text x="580" y="174" text-anchor="middle" font-size="9" fill="#6b7480">Gi0/0: routed · Lo0: 1.1.1.1</text>
  <rect x="220" y="220" width="260" height="60" rx="10" fill="#fff" stroke="#e5484d" stroke-width="2"/>
  <text x="350" y="246" text-anchor="middle" font-size="13" fill="#e5484d" font-weight="700">KALI</text>
  <text x="350" y="264" text-anchor="middle" font-size="9" fill="#6b7480">DTP spoof · duplex mismatch · port flap</text>
</svg>$md$,
  $md$<svg
      width="100%"
      viewBox="0 0 720 490"
      xmlns="http://www.w3.org/2000/svg"
      role="img"
      aria-label="NetBreaker Lab 20 topology: PC1(eth0)→SW1(Et0/1), KALI(eth0)→SW1(Et0/2), R1(Fa0/0)→SW1(Et0/3)"
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
        root@netbreaker:~/lab20$ topology --render
      </text>
      <g data-link="PC1:eth0↔SW1:Et0/1">
        <line x1="147" y1="141" x2="291" y2="69" stroke="#4d5560" stroke-width="1.5"
          data-node-a="PC1" data-iface-a="eth0" data-node-b="SW1" data-iface-b="Et0/1" />
        <title>PC1 eth0 ↔ SW1 Et0/1</title>
      </g>
      <g data-link="KALI:eth0↔SW1:Et0/2">
        <line x1="350" y1="220" x2="350" y2="69" stroke="#4d5560" stroke-width="1.5"
          data-node-a="KALI" data-iface-a="eth0" data-node-b="SW1" data-iface-b="Et0/2" />
        <title>KALI eth0 ↔ SW1 Et0/2</title>
      </g>
      <g data-link="R1:Fa0/0↔SW1:Et0/3">
        <line x1="521" y1="125" x2="409" y2="69" stroke="#4d5560" stroke-width="1.5"
          data-node-a="R1" data-iface-a="Fa0/0" data-node-b="SW1" data-iface-b="Et0/3" />
        <title>R1 Fa0/0 ↔ SW1 Et0/3</title>
      </g>
      <g data-port="SW1" data-iface="Et0/1">
        <rect x="251" y="77" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="272" y="90" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/1</text>
        <title>SW1 Et0/1</title>
      </g>
      <g data-port="SW1" data-iface="Et0/2">
        <rect x="336" y="84" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="357" y="97" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/2</text>
        <title>SW1 Et0/2</title>
      </g>
      <g data-port="SW1" data-iface="Et0/3">
        <rect x="413" y="65" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="434" y="78" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/3</text>
        <title>SW1 Et0/3</title>
      </g>
      <g data-port="PC1" data-iface="eth0">
        <rect x="150" y="128" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="171" y="141" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">eth0</text>
        <title>PC1 eth0</title>
      </g>
      <g data-port="R1" data-iface="Fa0/0">
        <rect x="481" y="99" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="502" y="112" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Fa0/0</text>
        <title>R1 Fa0/0</title>
      </g>
      <g data-port="KALI" data-iface="eth0">
        <rect x="336" y="187" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="357" y="200" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">eth0</text>
        <title>KALI eth0</title>
      </g>
      <g data-node="SW1" data-role="core">
        <rect x="280" y="9" width="140" height="60" rx="6" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
        <text x="350" y="45" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#e6edf3">SW1</text>
        <text x="350" y="63" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">l2 switch</text>
        <title>SW1</title>
      </g>
      <g data-node="PC1" data-role="host">
        <circle cx="120" cy="155" r="30" fill="#131a21" stroke="#22d3ee" stroke-width="1.5" />
        <text x="120" y="159" text-anchor="middle" font-family="Courier New, monospace" fontSize="13" fontWeight="700" fill="#67e8f9">PC1</text>
        <text x="120" y="173" text-anchor="middle" font-family="Courier New, monospace" fontSize="9" fill="#22d3ee">end host</text>
        <title>PC1</title>
      </g>
      <g data-node="R1" data-role="core">
        <rect x="510" y="125" width="140" height="60" rx="6" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
        <text x="580" y="161" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#e6edf3">R1</text>
        <text x="580" y="179" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">router</text>
        <title>R1</title>
      </g>
      <g data-node="KALI" data-role="attacker">
        <g filter="url(#glow)">
          <rect x="280" y="220" width="140" height="60" rx="6" fill="#1a0f11" stroke="#f85149" stroke-width="1.5" stroke-dasharray="5 3" />
        </g>
        <text x="350" y="256" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#ff7b72">KALI</text>
        <text x="350" y="274" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#f85149">attacker / observer</text>
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
        initial_build: PC1(eth0)→SW1(Et0/1) · KALI(eth0)→SW1(Et0/2) · R1(Fa0/0)→SW1(Et0/3)
      </text>
    </svg>
$md$)
WHERE lab_id = 20;

UPDATE lab_topologies SET svg_large = verify_replace(svg_large,
  $md$<svg viewBox="0 0 500 150" font-family="monospace"><rect x="30" y="20" width="200" height="50" rx="10" fill="#fff" stroke="#6b7480" stroke-width="2"/><text x="130" y="46" text-anchor="middle" font-size="13" font-weight="700">SW1 · SNMP Agent</text><text x="130" y="62" text-anchor="middle" font-size="8" fill="#6b7480">public/private → v3 only</text><rect x="280" y="20" width="200" height="50" rx="10" fill="#fff" stroke="#e5484d" stroke-width="2"/><text x="380" y="46" text-anchor="middle" font-size="13" fill="#e5484d" font-weight="700">KALI · SNMP Tools</text><text x="380" y="62" text-anchor="middle" font-size="8" fill="#6b7480">snmpwalk · snmpset · onesixtyone</text><line x1="230" y1="45" x2="280" y2="45" stroke="#e5484d" stroke-width="2" stroke-dasharray="6 5"/></svg>$md$,
  $md$<svg
      width="100%"
      viewBox="0 0 720 490"
      xmlns="http://www.w3.org/2000/svg"
      role="img"
      aria-label="NetBreaker Lab 32 topology: R1(Fa0/0)→SW1(Et0/0), KALI(eth0)→SW1(Et0/1), PC1(eth0)→SW1(Et0/2)"
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
        root@netbreaker:~/lab32$ topology --render
      </text>
      <g data-link="R1:Fa0/0↔SW1:Et0/0">
        <line x1="315" y1="92" x2="200" y2="63" stroke="#4d5560" stroke-width="1.5"
          data-node-a="R1" data-iface-a="Fa0/0" data-node-b="SW1" data-iface-b="Et0/0" />
        <title>R1 Fa0/0 ↔ SW1 Et0/0</title>
      </g>
      <g data-link="KALI:eth0↔SW1:Et0/1">
        <line x1="310" y1="45" x2="200" y2="45" stroke="#4d5560" stroke-width="1.5"
          data-node-a="KALI" data-iface-a="eth0" data-node-b="SW1" data-iface-b="Et0/1" />
        <title>KALI eth0 ↔ SW1 Et0/1</title>
      </g>
      <g data-link="PC1:eth0↔SW1:Et0/2">
        <line x1="361" y1="212" x2="171" y2="75" stroke="#4d5560" stroke-width="1.5"
          data-node-a="PC1" data-iface-a="eth0" data-node-b="SW1" data-iface-b="Et0/2" />
        <title>PC1 eth0 ↔ SW1 Et0/2</title>
      </g>
      <g data-port="R1" data-iface="Fa0/0">
        <rect x="272" y="70" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="293" y="83" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Fa0/0</text>
        <title>R1 Fa0/0</title>
      </g>
      <g data-port="SW1" data-iface="Et0/0">
        <rect x="204" y="58" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="225" y="71" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/0</text>
        <title>SW1 Et0/0</title>
      </g>
      <g data-port="SW1" data-iface="Et0/1">
        <rect x="203" y="29" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="224" y="42" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/1</text>
        <title>SW1 Et0/1</title>
      </g>
      <g data-port="SW1" data-iface="Et0/2">
        <rect x="171" y="80" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="192" y="93" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/2</text>
        <title>SW1 Et0/2</title>
      </g>
      <g data-port="PC1" data-iface="eth0">
        <rect x="324" y="184" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="345" y="197" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">eth0</text>
        <title>PC1 eth0</title>
      </g>
      <g data-port="KALI" data-iface="eth0">
        <rect x="265" y="29" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="286" y="42" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">eth0</text>
        <title>KALI eth0</title>
      </g>
      <g data-node="R1" data-role="core">
        <rect x="315" y="80" width="140" height="60" rx="6" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
        <text x="385" y="116" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#e6edf3">R1</text>
        <text x="385" y="134" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">router</text>
        <title>R1</title>
      </g>
      <g data-node="SW1" data-role="core">
        <rect x="60" y="15" width="140" height="60" rx="6" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
        <text x="130" y="51" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#e6edf3">SW1</text>
        <text x="130" y="69" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">l2 switch</text>
        <title>SW1</title>
      </g>
      <g data-node="PC1" data-role="host">
        <circle cx="385" cy="230" r="30" fill="#131a21" stroke="#22d3ee" stroke-width="1.5" />
        <text x="385" y="234" text-anchor="middle" font-family="Courier New, monospace" fontSize="13" fontWeight="700" fill="#67e8f9">PC1</text>
        <text x="385" y="248" text-anchor="middle" font-family="Courier New, monospace" fontSize="9" fill="#22d3ee">end host</text>
        <title>PC1</title>
      </g>
      <g data-node="KALI" data-role="attacker">
        <g filter="url(#glow)">
          <rect x="310" y="15" width="140" height="60" rx="6" fill="#1a0f11" stroke="#f85149" stroke-width="1.5" stroke-dasharray="5 3" />
        </g>
        <text x="380" y="51" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#ff7b72">KALI</text>
        <text x="380" y="69" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#f85149">attacker / observer</text>
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
WHERE lab_id = 32;

UPDATE lab_topologies SET svg_large = verify_replace(svg_large,
  $md$<svg viewBox="0 0 720 320" role="img" aria-label="Switch with a trusted uplink to the real DHCP server and untrusted client ports, one of which hosts a rogue server">
      <rect x="40" y="30" width="150" height="50" rx="8" fill="#eff6ff" stroke="#2563eb" stroke-width="2"/>
      <text x="115" y="52" text-anchor="middle" font-family="monospace" font-size="14" font-weight="700" fill="#2563eb">R1</text>
      <text x="115" y="68" text-anchor="middle" font-family="monospace" font-size="9.5" fill="#64748b">real DHCP · 10.0.10.1</text>
      <rect x="300" y="30" width="130" height="50" rx="8" fill="#eff6ff" stroke="#2563eb" stroke-width="2"/>
      <text x="365" y="52" text-anchor="middle" font-family="monospace" font-size="14" font-weight="700" fill="#2563eb">SW1</text>
      <text x="365" y="68" text-anchor="middle" font-family="monospace" font-size="9.5" fill="#64748b">snooping enabled</text>
      <!-- trusted uplink -->
      <line x1="190" y1="55" x2="300" y2="55" stroke="#16a34a" stroke-width="3"/>
      <text x="245" y="46" text-anchor="middle" font-family="monospace" font-size="9" fill="#16a34a" font-weight="700">e0/0 · TRUSTED</text>
      <!-- untrusted downlinks -->
      <line x1="330" y1="80" x2="160" y2="230" stroke="#64748b" stroke-width="2"/>
      <line x1="400" y1="80" x2="575" y2="230" stroke="#e5484d" stroke-width="2" stroke-dasharray="6 4"/>
      <text x="238" y="160" font-family="monospace" font-size="9" fill="#64748b">e0/1 · untrusted</text>
      <text x="470" y="160" font-family="monospace" font-size="9" fill="#e5484d">e0/3 · untrusted</text>
      <rect x="100" y="230" width="120" height="56" rx="8" fill="#fff" stroke="#2563eb" stroke-width="1.5"/>
      <text x="160" y="252" text-anchor="middle" font-family="monospace" font-size="13" font-weight="700" fill="#0f172a">PC1</text>
      <text x="160" y="268" text-anchor="middle" font-family="monospace" font-size="9.5" fill="#64748b">legit client</text>
      <rect x="515" y="230" width="120" height="56" rx="8" fill="#fef2f2" stroke="#e5484d" stroke-width="1.5"/>
      <text x="575" y="252" text-anchor="middle" font-family="monospace" font-size="13" font-weight="700" fill="#e5484d">KALI</text>
      <text x="575" y="268" text-anchor="middle" font-family="monospace" font-size="9.5" fill="#e5484d">rogue server</text>
      <text x="360" y="308" text-anchor="middle" font-family="monospace" font-size="10" fill="#94a3b8">server replies are legal only from the trusted uplink — anywhere else, dropped</text>
    </svg>$md$,
  $md$<svg
      width="100%"
      viewBox="0 0 720 490"
      xmlns="http://www.w3.org/2000/svg"
      role="img"
      aria-label="NetBreaker Lab 37 topology: R1(Fa0/0)→SW1(Et0/0), KALI(eth0)→SW1(Et0/1), PC1(eth0)→SW1(Et0/2)"
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
        root@netbreaker:~/lab37$ topology --render
      </text>
      <g data-link="R1:Fa0/0↔SW1:Et0/0">
        <line x1="185" y1="55" x2="295" y2="55" stroke="#4d5560" stroke-width="1.5"
          data-node-a="R1" data-iface-a="Fa0/0" data-node-b="SW1" data-iface-b="Et0/0" />
        <title>R1 Fa0/0 ↔ SW1 Et0/0</title>
      </g>
      <g data-link="KALI:eth0↔SW1:Et0/1">
        <line x1="544" y1="228" x2="396" y2="85" stroke="#4d5560" stroke-width="1.5"
          data-node-a="KALI" data-iface-a="eth0" data-node-b="SW1" data-iface-b="Et0/1" />
        <title>KALI eth0 ↔ SW1 Et0/1</title>
      </g>
      <g data-link="PC1:eth0↔SW1:Et0/2">
        <line x1="181" y1="237" x2="335" y2="85" stroke="#4d5560" stroke-width="1.5"
          data-node-a="PC1" data-iface-a="eth0" data-node-b="SW1" data-iface-b="Et0/2" />
        <title>PC1 eth0 ↔ SW1 Et0/2</title>
      </g>
      <g data-port="R1" data-iface="Fa0/0">
        <rect x="188" y="53" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="209" y="66" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Fa0/0</text>
        <title>R1 Fa0/0</title>
      </g>
      <g data-port="SW1" data-iface="Et0/0">
        <rect x="250" y="53" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="271" y="66" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/0</text>
        <title>SW1 Et0/0</title>
      </g>
      <g data-port="SW1" data-iface="Et0/1">
        <rect x="397" y="88" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="418" y="101" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/1</text>
        <title>SW1 Et0/1</title>
      </g>
      <g data-port="SW1" data-iface="Et0/2">
        <rect x="302" y="98" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="323" y="111" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/2</text>
        <title>SW1 Et0/2</title>
      </g>
      <g data-port="PC1" data-iface="eth0">
        <rect x="182" y="216" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="203" y="229" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">eth0</text>
        <title>PC1 eth0</title>
      </g>
      <g data-port="KALI" data-iface="eth0">
        <rect x="511" y="197" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="532" y="210" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">eth0</text>
        <title>KALI eth0</title>
      </g>
      <g data-node="R1" data-role="core">
        <rect x="45" y="25" width="140" height="60" rx="6" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
        <text x="115" y="61" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#e6edf3">R1</text>
        <text x="115" y="79" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">router</text>
        <title>R1</title>
      </g>
      <g data-node="SW1" data-role="core">
        <rect x="295" y="25" width="140" height="60" rx="6" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
        <text x="365" y="61" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#e6edf3">SW1</text>
        <text x="365" y="79" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">l2 switch</text>
        <title>SW1</title>
      </g>
      <g data-node="PC1" data-role="host">
        <circle cx="160" cy="258" r="30" fill="#131a21" stroke="#22d3ee" stroke-width="1.5" />
        <text x="160" y="262" text-anchor="middle" font-family="Courier New, monospace" fontSize="13" fontWeight="700" fill="#67e8f9">PC1</text>
        <text x="160" y="276" text-anchor="middle" font-family="Courier New, monospace" fontSize="9" fill="#22d3ee">end host</text>
        <title>PC1</title>
      </g>
      <g data-node="KALI" data-role="attacker">
        <g filter="url(#glow)">
          <rect x="505" y="228" width="140" height="60" rx="6" fill="#1a0f11" stroke="#f85149" stroke-width="1.5" stroke-dasharray="5 3" />
        </g>
        <text x="575" y="264" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#ff7b72">KALI</text>
        <text x="575" y="282" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#f85149">attacker / observer</text>
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
WHERE lab_id = 37;

UPDATE lab_topologies SET svg_large = verify_replace(svg_large,
  $md$<svg viewBox="0 0 720 320" role="img" aria-label="Router gateway, switch with DHCP snooping, a client, and a Kali attacker poisoning ARP to sit between them">
      <rect x="40" y="30" width="150" height="50" rx="8" fill="#eff6ff" stroke="#2563eb" stroke-width="2"/>
      <text x="115" y="52" text-anchor="middle" font-family="monospace" font-size="14" font-weight="700" fill="#2563eb">R1</text>
      <text x="115" y="68" text-anchor="middle" font-family="monospace" font-size="9.5" fill="#64748b">gateway · 10.0.10.1</text>
      <rect x="300" y="30" width="130" height="50" rx="8" fill="#eff6ff" stroke="#2563eb" stroke-width="2"/>
      <text x="365" y="52" text-anchor="middle" font-family="monospace" font-size="14" font-weight="700" fill="#2563eb">SW1</text>
      <text x="365" y="68" text-anchor="middle" font-family="monospace" font-size="9.5" fill="#64748b">snooping + DAI</text>
      <line x1="190" y1="55" x2="300" y2="55" stroke="#16a34a" stroke-width="3"/>
      <text x="245" y="46" text-anchor="middle" font-family="monospace" font-size="9" fill="#16a34a" font-weight="700">e0/0 · trusted</text>
      <line x1="330" y1="80" x2="200" y2="230" stroke="#64748b" stroke-width="2"/>
      <line x1="400" y1="80" x2="560" y2="230" stroke="#e5484d" stroke-width="2" stroke-dasharray="6 4"/>
      <text x="250" y="160" font-family="monospace" font-size="9" fill="#64748b">e0/1 · untrusted</text>
      <text x="460" y="160" font-family="monospace" font-size="9" fill="#e5484d">e0/3 · untrusted</text>
      <rect x="130" y="230" width="130" height="56" rx="8" fill="#fff" stroke="#2563eb" stroke-width="1.5"/>
      <text x="195" y="252" text-anchor="middle" font-family="monospace" font-size="13" font-weight="700" fill="#0f172a">PC-A</text>
      <text x="195" y="268" text-anchor="middle" font-family="monospace" font-size="9.5" fill="#64748b">10.0.10.10 (DHCP)</text>
      <rect x="500" y="230" width="130" height="56" rx="8" fill="#fef2f2" stroke="#e5484d" stroke-width="1.5"/>
      <text x="565" y="252" text-anchor="middle" font-family="monospace" font-size="13" font-weight="700" fill="#e5484d">KALI</text>
      <text x="565" y="268" text-anchor="middle" font-family="monospace" font-size="9.5" fill="#e5484d">claims to be .1</text>
      <text x="360" y="308" text-anchor="middle" font-family="monospace" font-size="10" fill="#94a3b8">Kali tells PC-A "I am 10.0.10.1" — DAI checks that claim against the binding table</text>
    </svg>$md$,
  $md$<svg
      width="100%"
      viewBox="0 0 720 490"
      xmlns="http://www.w3.org/2000/svg"
      role="img"
      aria-label="NetBreaker Lab 38 topology: R1(Fa0/0)→SW1(Et0/0), PC-A(eth0)→SW1(Et0/1), KALI(eth0)→SW1(Et0/2)"
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
        root@netbreaker:~/lab38$ topology --render
      </text>
      <g data-link="R1:Fa0/0↔SW1:Et0/0">
        <line x1="185" y1="55" x2="295" y2="55" stroke="#4d5560" stroke-width="1.5"
          data-node-a="R1" data-iface-a="Fa0/0" data-node-b="SW1" data-iface-b="Et0/0" />
        <title>R1 Fa0/0 ↔ SW1 Et0/0</title>
      </g>
      <g data-link="PC-A:eth0↔SW1:Et0/1">
        <line x1="214" y1="235" x2="340" y2="85" stroke="#4d5560" stroke-width="1.5"
          data-node-a="PC-A" data-iface-a="eth0" data-node-b="SW1" data-iface-b="Et0/1" />
        <title>PC-A eth0 ↔ SW1 Et0/1</title>
      </g>
      <g data-link="KALI:eth0↔SW1:Et0/2">
        <line x1="535" y1="228" x2="395" y2="85" stroke="#4d5560" stroke-width="1.5"
          data-node-a="KALI" data-iface-a="eth0" data-node-b="SW1" data-iface-b="Et0/2" />
        <title>KALI eth0 ↔ SW1 Et0/2</title>
      </g>
      <g data-port="R1" data-iface="Fa0/0">
        <rect x="188" y="53" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="209" y="66" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Fa0/0</text>
        <title>R1 Fa0/0</title>
      </g>
      <g data-port="SW1" data-iface="Et0/0">
        <rect x="250" y="53" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="271" y="66" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/0</text>
        <title>SW1 Et0/0</title>
      </g>
      <g data-port="SW1" data-iface="Et0/1">
        <rect x="309" y="99" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="330" y="112" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/1</text>
        <title>SW1 Et0/1</title>
      </g>
      <g data-port="SW1" data-iface="Et0/2">
        <rect x="395" y="88" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="416" y="101" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/2</text>
        <title>SW1 Et0/2</title>
      </g>
      <g data-port="PC-A" data-iface="eth0">
        <rect x="214" y="212" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="235" y="225" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">eth0</text>
        <title>PC-A eth0</title>
      </g>
      <g data-port="KALI" data-iface="eth0">
        <rect x="503" y="197" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="524" y="210" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">eth0</text>
        <title>KALI eth0</title>
      </g>
      <g data-node="R1" data-role="core">
        <rect x="45" y="25" width="140" height="60" rx="6" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
        <text x="115" y="61" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#e6edf3">R1</text>
        <text x="115" y="79" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">router</text>
        <title>R1</title>
      </g>
      <g data-node="SW1" data-role="core">
        <rect x="295" y="25" width="140" height="60" rx="6" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
        <text x="365" y="61" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#e6edf3">SW1</text>
        <text x="365" y="79" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">l2 switch</text>
        <title>SW1</title>
      </g>
      <g data-node="PC-A" data-role="host">
        <circle cx="195" cy="258" r="30" fill="#131a21" stroke="#22d3ee" stroke-width="1.5" />
        <text x="195" y="262" text-anchor="middle" font-family="Courier New, monospace" fontSize="13" fontWeight="700" fill="#67e8f9">PC-A</text>
        <text x="195" y="276" text-anchor="middle" font-family="Courier New, monospace" fontSize="9" fill="#22d3ee">end host</text>
        <title>PC-A</title>
      </g>
      <g data-node="KALI" data-role="attacker">
        <g filter="url(#glow)">
          <rect x="495" y="228" width="140" height="60" rx="6" fill="#1a0f11" stroke="#f85149" stroke-width="1.5" stroke-dasharray="5 3" />
        </g>
        <text x="565" y="264" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#ff7b72">KALI</text>
        <text x="565" y="282" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#f85149">attacker / observer</text>
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
        initial_build: R1(Fa0/0)→SW1(Et0/0) · PC-A(eth0)→SW1(Et0/1) · KALI(eth0)→SW1(Et0/2)
      </text>
    </svg>
$md$)
WHERE lab_id = 38;

UPDATE lab_topologies SET svg_large = verify_replace(svg_large,
  $md$<svg viewBox="0 0 500 120" font-family="monospace"><rect x="30" y="14" width="160" height="46" rx="8" fill="#fff" stroke="#14161a" stroke-width="2"/><text x="110" y="40" text-anchor="middle" font-size="13" font-weight="700">R1 · RESTCONF</text><text x="110" y="56" text-anchor="middle" font-size="8" fill="#6b7480">HTTPS · YANG data model</text><rect x="260" y="14" width="200" height="46" rx="8" fill="#fff" stroke="#2563eb" stroke-width="2"/><text x="360" y="40" text-anchor="middle" font-size="13" fill="#2563eb" font-weight="700">KALI · curl + Postman</text><text x="360" y="56" text-anchor="middle" font-size="8" fill="#6b7480">RESTCONF API calls</text><line x1="190" y1="37" x2="260" y2="37" stroke="#2563eb" stroke-width="2"/></svg>$md$,
  $md$<svg
      width="100%"
      viewBox="0 0 720 490"
      xmlns="http://www.w3.org/2000/svg"
      role="img"
      aria-label="NetBreaker Lab 43 topology: R1(Fa0/0)→SW1(Et0/0), KALI(eth0)→SW1(Et0/1)"
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
        root@netbreaker:~/lab43$ topology --render
      </text>
      <g data-link="R1:Fa0/0↔SW1:Et0/0">
        <line x1="180" y1="56" x2="315" y2="91" stroke="#4d5560" stroke-width="1.5"
          data-node-a="R1" data-iface-a="Fa0/0" data-node-b="SW1" data-iface-b="Et0/0" />
        <title>R1 Fa0/0 ↔ SW1 Et0/0</title>
      </g>
      <g data-link="KALI:eth0↔SW1:Et0/1">
        <line x1="370" y1="67" x2="375" y2="80" stroke="#4d5560" stroke-width="1.5"
          data-node-a="KALI" data-iface-a="eth0" data-node-b="SW1" data-iface-b="Et0/1" />
        <title>KALI eth0 ↔ SW1 Et0/1</title>
      </g>
      <g data-port="R1" data-iface="Fa0/0">
        <rect x="180" y="60" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="201" y="73" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Fa0/0</text>
        <title>R1 Fa0/0</title>
      </g>
      <g data-port="SW1" data-iface="Et0/0">
        <rect x="269" y="83" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="290" y="96" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/0</text>
        <title>SW1 Et0/0</title>
      </g>
      <g data-port="SW1" data-iface="Et0/1">
        <rect x="339" y="51" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="360" y="64" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/1</text>
        <title>SW1 Et0/1</title>
      </g>
      <g data-port="KALI" data-iface="eth0">
        <rect x="350" y="83" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="371" y="96" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">eth0</text>
        <title>KALI eth0</title>
      </g>
      <g data-node="R1" data-role="core">
        <rect x="40" y="7" width="140" height="60" rx="6" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
        <text x="110" y="43" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#e6edf3">R1</text>
        <text x="110" y="61" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">router</text>
        <title>R1</title>
      </g>
      <g data-node="SW1" data-role="core">
        <rect x="315" y="80" width="140" height="60" rx="6" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
        <text x="385" y="116" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#e6edf3">SW1</text>
        <text x="385" y="134" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">l2 switch</text>
        <title>SW1</title>
      </g>
      <g data-node="KALI" data-role="attacker">
        <g filter="url(#glow)">
          <rect x="290" y="7" width="140" height="60" rx="6" fill="#1a0f11" stroke="#f85149" stroke-width="1.5" stroke-dasharray="5 3" />
        </g>
        <text x="360" y="43" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#ff7b72">KALI</text>
        <text x="360" y="61" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#f85149">attacker / observer</text>
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
WHERE lab_id = 43;

UPDATE lab_topologies SET svg_large = verify_replace(svg_large,
  $md$<svg viewBox="0 0 500 120" font-family="monospace"><rect x="30" y="14" width="160" height="46" rx="8" fill="#fff" stroke="#14161a" stroke-width="2"/><text x="110" y="40" text-anchor="middle" font-size="13" font-weight="700">R1 · NETCONF</text><text x="110" y="56" text-anchor="middle" font-size="8" fill="#6b7480">SSH port 830 · YANG</text><rect x="260" y="14" width="200" height="46" rx="8" fill="#fff" stroke="#2563eb" stroke-width="2"/><text x="360" y="40" text-anchor="middle" font-size="13" fill="#2563eb" font-weight="700">KALI · SSH + XML</text><text x="360" y="56" text-anchor="middle" font-size="8" fill="#6b7480">NETCONF get-config/edit-config</text><line x1="190" y1="37" x2="260" y2="37" stroke="#2563eb" stroke-width="2"/></svg>$md$,
  $md$<svg
      width="100%"
      viewBox="0 0 720 490"
      xmlns="http://www.w3.org/2000/svg"
      role="img"
      aria-label="NetBreaker Lab 44 topology: R1(Fa0/0)→SW1(Et0/0), KALI(eth0)→SW1(Et0/1)"
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
        root@netbreaker:~/lab44$ topology --render
      </text>
      <g data-link="R1:Fa0/0↔SW1:Et0/0">
        <line x1="180" y1="56" x2="315" y2="91" stroke="#4d5560" stroke-width="1.5"
          data-node-a="R1" data-iface-a="Fa0/0" data-node-b="SW1" data-iface-b="Et0/0" />
        <title>R1 Fa0/0 ↔ SW1 Et0/0</title>
      </g>
      <g data-link="KALI:eth0↔SW1:Et0/1">
        <line x1="370" y1="67" x2="375" y2="80" stroke="#4d5560" stroke-width="1.5"
          data-node-a="KALI" data-iface-a="eth0" data-node-b="SW1" data-iface-b="Et0/1" />
        <title>KALI eth0 ↔ SW1 Et0/1</title>
      </g>
      <g data-port="R1" data-iface="Fa0/0">
        <rect x="180" y="60" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="201" y="73" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Fa0/0</text>
        <title>R1 Fa0/0</title>
      </g>
      <g data-port="SW1" data-iface="Et0/0">
        <rect x="269" y="83" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="290" y="96" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/0</text>
        <title>SW1 Et0/0</title>
      </g>
      <g data-port="SW1" data-iface="Et0/1">
        <rect x="339" y="51" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="360" y="64" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/1</text>
        <title>SW1 Et0/1</title>
      </g>
      <g data-port="KALI" data-iface="eth0">
        <rect x="350" y="83" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="371" y="96" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">eth0</text>
        <title>KALI eth0</title>
      </g>
      <g data-node="R1" data-role="core">
        <rect x="40" y="7" width="140" height="60" rx="6" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
        <text x="110" y="43" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#e6edf3">R1</text>
        <text x="110" y="61" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">router</text>
        <title>R1</title>
      </g>
      <g data-node="SW1" data-role="core">
        <rect x="315" y="80" width="140" height="60" rx="6" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
        <text x="385" y="116" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#e6edf3">SW1</text>
        <text x="385" y="134" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">l2 switch</text>
        <title>SW1</title>
      </g>
      <g data-node="KALI" data-role="attacker">
        <g filter="url(#glow)">
          <rect x="290" y="7" width="140" height="60" rx="6" fill="#1a0f11" stroke="#f85149" stroke-width="1.5" stroke-dasharray="5 3" />
        </g>
        <text x="360" y="43" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#ff7b72">KALI</text>
        <text x="360" y="61" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#f85149">attacker / observer</text>
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
WHERE lab_id = 44;

UPDATE lab_topologies SET svg_large = verify_replace(svg_large,
  $md$<svg viewBox="0 0 720 300" role="img" aria-label="Network topology: one switch with two legitimate hosts and one Kali attacker">
      <!-- switch -->
      <rect x="290" y="30" width="140" height="46" rx="8" fill="#eff6ff" stroke="#2563eb" stroke-width="2"/>
      <text x="360" y="52" text-anchor="middle" font-family="monospace" font-size="14" font-weight="700" fill="#2563eb">SW1</text>
      <text x="360" y="68" text-anchor="middle" font-family="monospace" font-size="10" fill="#64748b">IOU L2 · VLAN 10</text>

      <!-- links -->
      <line x1="330" y1="76" x2="150" y2="210" stroke="#2563eb" stroke-width="2"/>
      <line x1="360" y1="76" x2="360" y2="210" stroke="#2563eb" stroke-width="2"/>
      <line x1="390" y1="76" x2="575" y2="210" stroke="#e5484d" stroke-width="2" stroke-dasharray="6 4"/>

      <!-- port labels -->
      <text x="250" y="140" font-family="monospace" font-size="10" fill="#64748b">e0/1</text>
      <text x="368" y="140" font-family="monospace" font-size="10" fill="#64748b">e0/2</text>
      <text x="470" y="140" font-family="monospace" font-size="10" fill="#e5484d">e0/3</text>

      <!-- PC-A -->
      <rect x="90" y="210" width="120" height="56" rx="8" fill="#fff" stroke="#2563eb" stroke-width="1.5"/>
      <text x="150" y="232" text-anchor="middle" font-family="monospace" font-size="13" font-weight="700" fill="#0f172a">PC-A</text>
      <text x="150" y="248" text-anchor="middle" font-family="monospace" font-size="10" fill="#64748b">10.0.10.10 · finance</text>

      <!-- PC-B -->
      <rect x="300" y="210" width="120" height="56" rx="8" fill="#fff" stroke="#2563eb" stroke-width="1.5"/>
      <text x="360" y="232" text-anchor="middle" font-family="monospace" font-size="13" font-weight="700" fill="#0f172a">PC-B</text>
      <text x="360" y="248" text-anchor="middle" font-family="monospace" font-size="10" fill="#64748b">10.0.10.20 · server</text>

      <!-- Kali -->
      <rect x="515" y="210" width="120" height="56" rx="8" fill="#fef2f2" stroke="#e5484d" stroke-width="1.5"/>
      <text x="575" y="232" text-anchor="middle" font-family="monospace" font-size="13" font-weight="700" fill="#e5484d">KALI</text>
      <text x="575" y="248" text-anchor="middle" font-family="monospace" font-size="10" fill="#e5484d">10.0.10.66 · attacker</text>

      <text x="575" y="292" text-anchor="middle" font-family="monospace" font-size="10" fill="#94a3b8">same VLAN, access port — no L3 hop needed</text>
    </svg>$md$,
  $md$<svg
      width="100%"
      viewBox="0 0 720 490"
      xmlns="http://www.w3.org/2000/svg"
      role="img"
      aria-label="NetBreaker Lab 46 topology: PC-A(eth0)→SW1(Et0/1), PC-B(eth0)→SW1(Et0/2), KALI(eth0)→SW1(Et0/3)"
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
        root@netbreaker:~/lab46$ topology --render
      </text>
      <g data-link="PC-A:eth0↔SW1:Et0/1">
        <line x1="173" y1="218" x2="326" y2="83" stroke="#4d5560" stroke-width="1.5"
          data-node-a="PC-A" data-iface-a="eth0" data-node-b="SW1" data-iface-b="Et0/1" />
        <title>PC-A eth0 ↔ SW1 Et0/1</title>
      </g>
      <g data-link="PC-B:eth0↔SW1:Et0/2">
        <line x1="360" y1="208" x2="360" y2="83" stroke="#4d5560" stroke-width="1.5"
          data-node-a="PC-B" data-iface-a="eth0" data-node-b="SW1" data-iface-b="Et0/2" />
        <title>PC-B eth0 ↔ SW1 Et0/2</title>
      </g>
      <g data-link="KALI:eth0↔SW1:Et0/3">
        <line x1="540" y1="208" x2="395" y2="83" stroke="#4d5560" stroke-width="1.5"
          data-node-a="KALI" data-iface-a="eth0" data-node-b="SW1" data-iface-b="Et0/3" />
        <title>KALI eth0 ↔ SW1 Et0/3</title>
      </g>
      <g data-port="SW1" data-iface="Et0/1">
        <rect x="292" y="95" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="313" y="108" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/1</text>
        <title>SW1 Et0/1</title>
      </g>
      <g data-port="SW1" data-iface="Et0/2">
        <rect x="346" y="98" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="367" y="111" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/2</text>
        <title>SW1 Et0/2</title>
      </g>
      <g data-port="SW1" data-iface="Et0/3">
        <rect x="397" y="84" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="418" y="97" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/3</text>
        <title>SW1 Et0/3</title>
      </g>
      <g data-port="PC-A" data-iface="eth0">
        <rect x="174" y="199" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="195" y="212" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">eth0</text>
        <title>PC-A eth0</title>
      </g>
      <g data-port="PC-B" data-iface="eth0">
        <rect x="346" y="175" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="367" y="188" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">eth0</text>
        <title>PC-B eth0</title>
      </g>
      <g data-port="KALI" data-iface="eth0">
        <rect x="506" y="178" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="527" y="191" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">eth0</text>
        <title>KALI eth0</title>
      </g>
      <g data-node="SW1" data-role="core">
        <rect x="290" y="23" width="140" height="60" rx="6" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
        <text x="360" y="59" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#e6edf3">SW1</text>
        <text x="360" y="77" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">l2 switch</text>
        <title>SW1</title>
      </g>
      <g data-node="PC-A" data-role="host">
        <circle cx="150" cy="238" r="30" fill="#131a21" stroke="#22d3ee" stroke-width="1.5" />
        <text x="150" y="242" text-anchor="middle" font-family="Courier New, monospace" fontSize="13" fontWeight="700" fill="#67e8f9">PC-A</text>
        <text x="150" y="256" text-anchor="middle" font-family="Courier New, monospace" fontSize="9" fill="#22d3ee">end host</text>
        <title>PC-A</title>
      </g>
      <g data-node="PC-B" data-role="host">
        <circle cx="360" cy="238" r="30" fill="#131a21" stroke="#22d3ee" stroke-width="1.5" />
        <text x="360" y="242" text-anchor="middle" font-family="Courier New, monospace" fontSize="13" fontWeight="700" fill="#67e8f9">PC-B</text>
        <text x="360" y="256" text-anchor="middle" font-family="Courier New, monospace" fontSize="9" fill="#22d3ee">end host</text>
        <title>PC-B</title>
      </g>
      <g data-node="KALI" data-role="attacker">
        <g filter="url(#glow)">
          <rect x="505" y="208" width="140" height="60" rx="6" fill="#1a0f11" stroke="#f85149" stroke-width="1.5" stroke-dasharray="5 3" />
        </g>
        <text x="575" y="244" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#ff7b72">KALI</text>
        <text x="575" y="262" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#f85149">attacker / observer</text>
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
        initial_build: PC-A(eth0)→SW1(Et0/1) · PC-B(eth0)→SW1(Et0/2) · KALI(eth0)→SW1(Et0/3)
      </text>
    </svg>
$md$)
WHERE lab_id = 46;
