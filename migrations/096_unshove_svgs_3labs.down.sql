-- Migration 096 DOWN: restore the pre-unshove renders (reverse of UP).

UPDATE lab_topologies SET svg_large = verify_replace(svg_large,
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
        <line x1="265" y1="96" x2="315" y2="96" stroke="#4d5560" stroke-width="1.5"
          data-node-a="R1" data-iface-a="Fa0/0" data-node-b="R2" data-iface-b="Fa0/0" />
        <title>R1 Fa0/0 ↔ R2 Fa0/0</title>
      </g>
      <g data-link="R2:Fa0/1↔R3:Fa0/0">
        <line x1="455" y1="96" x2="505" y2="96" stroke="#4d5560" stroke-width="1.5"
          data-node-a="R2" data-iface-a="Fa0/1" data-node-b="R3" data-iface-b="Fa0/0" />
        <title>R2 Fa0/1 ↔ R3 Fa0/0</title>
      </g>
      <g data-link="R3:Fa0/1↔R1:Fa0/1">
        <line x1="505" y1="96" x2="265" y2="96" stroke="#4d5560" stroke-width="1.5"
          data-node-a="R3" data-iface-a="Fa0/1" data-node-b="R1" data-iface-b="Fa0/1" />
        <title>R3 Fa0/1 ↔ R1 Fa0/1</title>
      </g>
      <g data-link="R1:Gi1/1↔PC1:eth0">
        <line x1="240" y1="126" x2="360" y2="206" stroke="#4d5560" stroke-width="1.5"
          data-node-a="R1" data-iface-a="Gi1/1" data-node-b="PC1" data-iface-b="eth0" />
        <title>R1 Gi1/1 ↔ PC1 eth0</title>
      </g>
      <g data-link="R1:Gi1/2↔KALI:eth0">
        <line x1="195" y1="126" x2="195" y2="192" stroke="#4d5560" stroke-width="1.5"
          data-node-a="R1" data-iface-a="Gi1/2" data-node-b="KALI" data-iface-b="eth0" />
        <title>R1 Gi1/2 ↔ KALI eth0</title>
      </g>
      <g data-link="R2:Gi1/1↔PC2:eth0">
        <line x1="430" y1="126" x2="550" y2="206" stroke="#4d5560" stroke-width="1.5"
          data-node-a="R2" data-iface-a="Gi1/1" data-node-b="PC2" data-iface-b="eth0" />
        <title>R2 Gi1/1 ↔ PC2 eth0</title>
      </g>
      <g data-link="R3:Gi1/1↔PC3:eth0">
        <line x1="552" y1="126" x2="403" y2="325" stroke="#4d5560" stroke-width="1.5"
          data-node-a="R3" data-iface-a="Gi1/1" data-node-b="PC3" data-iface-b="eth0" />
        <title>R3 Gi1/1 ↔ PC3 eth0</title>
      </g>
      <g data-port="R1" data-iface="Fa0/0">
        <rect x="263" y="112" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="284" y="125" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Fa0/0</text>
        <title>R1 Fa0/0</title>
      </g>
      <g data-port="R1" data-iface="Fa0/1">
        <rect x="261" y="74" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="282" y="87" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Fa0/1</text>
        <title>R1 Fa0/1</title>
      </g>
      <g data-port="R1" data-iface="Gi1/1">
        <rect x="229" y="141" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="250" y="154" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Gi1/1</text>
        <title>R1 Gi1/1</title>
      </g>
      <g data-port="R1" data-iface="Gi1/2">
        <rect x="167" y="142" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="188" y="154" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Gi1/2</text>
        <title>R1 Gi1/2</title>
      </g>
      <g data-port="R2" data-iface="Fa0/0">
        <rect x="370" y="162" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="391" y="175" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Fa0/0</text>
        <title>R2 Fa0/0</title>
      </g>
      <g data-port="R2" data-iface="Fa0/1">
        <rect x="450" y="96" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="471" y="109" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Fa0/1</text>
        <title>R2 Fa0/1</title>
      </g>
      <g data-port="R2" data-iface="Gi1/1">
        <rect x="425" y="137" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="446" y="150" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Gi1/1</text>
        <title>R2 Gi1/1</title>
      </g>
      <g data-port="R3" data-iface="Fa0/0">
        <rect x="561" y="160" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="582" y="173" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Fa0/0</text>
        <title>R3 Fa0/0</title>
      </g>
      <g data-port="R3" data-iface="Fa0/1">
        <rect x="465" y="71" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="486" y="84" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Fa0/1</text>
        <title>R3 Fa0/1</title>
      </g>
      <g data-port="R3" data-iface="Gi1/1">
        <rect x="511" y="132" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="532" y="145" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Gi1/1</text>
        <title>R3 Gi1/1</title>
      </g>
      <g data-port="PC1" data-iface="eth0">
        <rect x="315" y="189" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="336" y="202" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">eth0</text>
        <title>PC1 eth0</title>
      </g>
      <g data-port="PC2" data-iface="eth0">
        <rect x="505" y="189" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="526" y="202" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">eth0</text>
        <title>PC2 eth0</title>
      </g>
      <g data-port="PC3" data-iface="eth0">
        <rect x="391" y="292" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="412" y="305" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">eth0</text>
        <title>PC3 eth0</title>
      </g>
      <g data-port="KALI" data-iface="eth0">
        <rect x="167" y="160" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="188" y="172" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">eth0</text>
        <title>KALI eth0</title>
      </g>
      <g data-node="R1" data-role="core">
        <rect x="125" y="66" width="140" height="60" rx="6" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
        <text x="195" y="102" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#e6edf3">R1</text>
        <text x="195" y="120" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">router</text>
        <title>R1</title>
      </g>
      <g data-node="R2" data-role="core">
        <rect x="315" y="66" width="140" height="60" rx="6" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
        <text x="385" y="102" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#e6edf3">R2</text>
        <text x="385" y="120" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">router</text>
        <title>R2</title>
      </g>
      <g data-node="R3" data-role="core">
        <rect x="505" y="66" width="140" height="60" rx="6" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
        <text x="575" y="102" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#e6edf3">R3</text>
        <text x="575" y="120" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">router</text>
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
        <circle cx="385" cy="348" r="30" fill="#131a21" stroke="#22d3ee" stroke-width="1.5" />
        <text x="385" y="352" text-anchor="middle" font-family="Courier New, monospace" fontSize="13" fontWeight="700" fill="#67e8f9">PC3</text>
        <text x="385" y="366" text-anchor="middle" font-family="Courier New, monospace" fontSize="9" fill="#22d3ee">end host</text>
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
$md$,
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
    </svg>$md$)
WHERE lab_id = 21;

UPDATE lab_topologies SET svg_large = verify_replace(svg_large,
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
        <rect x="175" y="84" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="196" y="97" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/0</text>
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
        <rect x="286" y="149" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="307" y="162" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/0</text>
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
$md$,
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
    </svg>$md$)
WHERE lab_id = 24;

UPDATE lab_topologies SET svg_large = verify_replace(svg_large,
  $md$<svg
      width="100%"
      viewBox="0 0 720 490"
      xmlns="http://www.w3.org/2000/svg"
      role="img"
      aria-label="NetBreaker Lab 28 topology: R1(Fa0/0)→SW1(Et0/0), PC1(eth0)→SW1(Et0/1), KALI(eth0)→SW1(Et0/2), PC2(eth0)→SW1(Et0/3)"
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
        <line x1="360" y1="104" x2="410" y2="104" stroke="#4d5560" stroke-width="1.5"
          data-node-a="R1" data-iface-a="Fa0/0" data-node-b="SW1" data-iface-b="Et0/0" />
        <title>R1 Fa0/0 ↔ SW1 Et0/0</title>
      </g>
      <g data-link="PC1:eth0↔SW1:Et0/1">
        <line x1="403" y1="206" x2="457" y2="134" stroke="#4d5560" stroke-width="1.5"
          data-node-a="PC1" data-iface-a="eth0" data-node-b="SW1" data-iface-b="Et0/1" />
        <title>PC1 eth0 ↔ SW1 Et0/1</title>
      </g>
      <g data-link="KALI:eth0↔SW1:Et0/2">
        <line x1="263" y1="200" x2="412" y2="134" stroke="#4d5560" stroke-width="1.5"
          data-node-a="KALI" data-iface-a="eth0" data-node-b="SW1" data-iface-b="Et0/2" />
        <title>KALI eth0 ↔ SW1 Et0/2</title>
      </g>
      <g data-link="PC2:eth0↔SW1:Et0/3">
        <line x1="557" y1="206" x2="503" y2="134" stroke="#4d5560" stroke-width="1.5"
          data-node-a="PC2" data-iface-a="eth0" data-node-b="SW1" data-iface-b="Et0/3" />
        <title>PC2 eth0 ↔ SW1 Et0/3</title>
      </g>
      <g data-port="R1" data-iface="Fa0/0">
        <rect x="354" y="110" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="375" y="123" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Fa0/0</text>
        <title>R1 Fa0/0</title>
      </g>
      <g data-port="SW1" data-iface="Et0/0">
        <rect x="458" y="173" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="479" y="186" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/0</text>
        <title>SW1 Et0/0</title>
      </g>
      <g data-port="SW1" data-iface="Et0/1">
        <rect x="428" y="148" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="449" y="161" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/1</text>
        <title>SW1 Et0/1</title>
      </g>
      <g data-port="SW1" data-iface="Et0/2">
        <rect x="372" y="141" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="393" y="154" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/2</text>
        <title>SW1 Et0/2</title>
      </g>
      <g data-port="SW1" data-iface="Et0/3">
        <rect x="502" y="140" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="523" y="153" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/3</text>
        <title>SW1 Et0/3</title>
      </g>
      <g data-port="PC1" data-iface="eth0">
        <rect x="402" y="182" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="423" y="195" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">eth0</text>
        <title>PC1 eth0</title>
      </g>
      <g data-port="PC2" data-iface="eth0">
        <rect x="527" y="174" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="548" y="187" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">eth0</text>
        <title>PC2 eth0</title>
      </g>
      <g data-port="KALI" data-iface="eth0">
        <rect x="267" y="188" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="288" y="201" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">eth0</text>
        <title>KALI eth0</title>
      </g>
      <g data-node="R1" data-role="core">
        <rect x="220" y="74" width="140" height="60" rx="6" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
        <text x="290" y="110" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#e6edf3">R1</text>
        <text x="290" y="128" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">router</text>
        <title>R1</title>
      </g>
      <g data-node="SW1" data-role="core">
        <rect x="410" y="74" width="140" height="60" rx="6" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
        <text x="480" y="110" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#e6edf3">SW1</text>
        <text x="480" y="128" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">l2 switch</text>
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
        initial_build: R1(Fa0/0)→SW1(Et0/0) · PC1(eth0)→SW1(Et0/1) · KALI(eth0)→SW1(Et0/2) · PC2(eth0)→SW1(Et0/3)
      </text>
    </svg>
$md$,
  $md$<svg
      width="100%"
      viewBox="0 0 720 490"
      xmlns="http://www.w3.org/2000/svg"
      role="img"
      aria-label="NetBreaker Lab 28 topology: R1(Fa0/0)→SW1(Et0/0), PC1(eth0)→SW1(Et0/1), KALI(eth0)→SW1(Et0/2), PC2(eth0)→SW1(Et0/3)"
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
        <line x1="360" y1="110" x2="410" y2="110" stroke="#4d5560" stroke-width="1.5"
          data-node-a="R1" data-iface-a="Fa0/0" data-node-b="SW1" data-iface-b="Et0/0" />
        <title>R1 Fa0/0 ↔ SW1 Et0/0</title>
      </g>
      <g data-link="PC1:eth0↔SW1:Et0/1">
        <line x1="404" y1="206" x2="456" y2="140" stroke="#4d5560" stroke-width="1.5"
          data-node-a="PC1" data-iface-a="eth0" data-node-b="SW1" data-iface-b="Et0/1" />
        <title>PC1 eth0 ↔ SW1 Et0/1</title>
      </g>
      <g data-link="KALI:eth0↔SW1:Et0/2">
        <line x1="265" y1="201" x2="410" y2="139" stroke="#4d5560" stroke-width="1.5"
          data-node-a="KALI" data-iface-a="eth0" data-node-b="SW1" data-iface-b="Et0/2" />
        <title>KALI eth0 ↔ SW1 Et0/2</title>
      </g>
      <g data-link="PC2:eth0↔SW1:Et0/3">
        <line x1="556" y1="206" x2="504" y2="140" stroke="#4d5560" stroke-width="1.5"
          data-node-a="PC2" data-iface-a="eth0" data-node-b="SW1" data-iface-b="Et0/3" />
        <title>PC2 eth0 ↔ SW1 Et0/3</title>
      </g>
      <g data-port="R1" data-iface="Fa0/0">
        <rect x="349" y="118" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="370" y="131" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Fa0/0</text>
        <title>R1 Fa0/0</title>
      </g>
      <g data-port="SW1" data-iface="Et0/0">
        <rect x="379" y="97" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="400" y="110" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/0</text>
        <title>SW1 Et0/0</title>
      </g>
      <g data-port="SW1" data-iface="Et0/1">
        <rect x="426" y="154" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="447" y="167" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/1</text>
        <title>SW1 Et0/1</title>
      </g>
      <g data-port="SW1" data-iface="Et0/2">
        <rect x="370" y="146" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="391" y="159" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/2</text>
        <title>SW1 Et0/2</title>
      </g>
      <g data-port="SW1" data-iface="Et0/3">
        <rect x="503" y="145" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="524" y="158" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/3</text>
        <title>SW1 Et0/3</title>
      </g>
      <g data-port="PC1" data-iface="eth0">
        <rect x="403" y="183" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="424" y="196" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">eth0</text>
        <title>PC1 eth0</title>
      </g>
      <g data-port="PC2" data-iface="eth0">
        <rect x="526" y="174" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="547" y="187" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">eth0</text>
        <title>PC2 eth0</title>
      </g>
      <g data-port="KALI" data-iface="eth0">
        <rect x="269" y="189" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="290" y="202" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">eth0</text>
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
        initial_build: R1(Fa0/0)→SW1(Et0/0) · PC1(eth0)→SW1(Et0/1) · KALI(eth0)→SW1(Et0/2) · PC2(eth0)→SW1(Et0/3)
      </text>
    </svg>$md$)
WHERE lab_id = 28;
