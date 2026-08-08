-- Migration 093 DOWN: restore the 090-era renders (reverse of UP).

UPDATE lab_topologies SET svg_large = verify_replace(svg_large,
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
        <rect x="263" y="135" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="284" y="148" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/0</text>
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
$md$,
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
    </svg>$md$)
WHERE lab_id = 2;

UPDATE lab_topologies SET svg_large = verify_replace(svg_large,
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
        <rect x="216" y="137" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="237" y="150" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/1</text>
        <title>SW1 Et0/1</title>
      </g>
      <g data-port="SW1" data-iface="Et0/2">
        <rect x="347" y="129" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="368" y="142" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/2</text>
        <title>SW1 Et0/2</title>
      </g>
      <g data-port="KALI" data-iface="eth0">
        <rect x="395" y="112" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="416" y="125" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">eth0</text>
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
$md$,
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
    </svg>$md$)
WHERE lab_id = 7;

UPDATE lab_topologies SET svg_large = verify_replace(svg_large,
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
        <rect x="262" y="174" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="283" y="187" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Fa0/0</text>
        <title>R1 Fa0/0</title>
      </g>
      <g data-port="SW1" data-iface="Et0/1">
        <rect x="371" y="101" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="392" y="114" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/1</text>
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
$md$,
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
    </svg>$md$)
WHERE lab_id = 11;

UPDATE lab_topologies SET svg_large = verify_replace(svg_large,
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
        <rect x="500" y="172" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="521" y="185" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/0</text>
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
$md$,
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
    </svg>$md$)
WHERE lab_id = 15;

UPDATE lab_topologies SET svg_large = verify_replace(svg_large,
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
        <rect x="167" y="174" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="188" y="187" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Fa0/1</text>
        <title>R1 Fa0/1</title>
      </g>
      <g data-port="R2" data-iface="Fa0/0">
        <rect x="276" y="101" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="297" y="114" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Fa0/0</text>
        <title>R2 Fa0/0</title>
      </g>
      <g data-port="R2" data-iface="Fa0/1">
        <rect x="357" y="174" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="378" y="187" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Fa0/1</text>
        <title>R2 Fa0/1</title>
      </g>
      <g data-port="R3" data-iface="Fa0/0">
        <rect x="466" y="101" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="487" y="114" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Fa0/0</text>
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
$md$,
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
    </svg>$md$)
WHERE lab_id = 27;

UPDATE lab_topologies SET svg_large = verify_replace(svg_large,
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
        <line x1="315" y1="132" x2="200" y2="103" stroke="#4d5560" stroke-width="1.5"
          data-node-a="R1" data-iface-a="Fa0/0" data-node-b="SW1" data-iface-b="Et0/0" />
        <title>R1 Fa0/0 ↔ SW1 Et0/0</title>
      </g>
      <g data-link="KALI:eth0↔SW1:Et0/1">
        <line x1="310" y1="85" x2="200" y2="85" stroke="#4d5560" stroke-width="1.5"
          data-node-a="KALI" data-iface-a="eth0" data-node-b="SW1" data-iface-b="Et0/1" />
        <title>KALI eth0 ↔ SW1 Et0/1</title>
      </g>
      <g data-link="PC1:eth0↔SW1:Et0/2">
        <line x1="361" y1="252" x2="171" y2="115" stroke="#4d5560" stroke-width="1.5"
          data-node-a="PC1" data-iface-a="eth0" data-node-b="SW1" data-iface-b="Et0/2" />
        <title>PC1 eth0 ↔ SW1 Et0/2</title>
      </g>
      <g data-port="R1" data-iface="Fa0/0">
        <rect x="279" y="119" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="300" y="132" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Fa0/0</text>
        <title>R1 Fa0/0</title>
      </g>
      <g data-port="SW1" data-iface="Et0/0">
        <rect x="204" y="98" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="225" y="111" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/0</text>
        <title>SW1 Et0/0</title>
      </g>
      <g data-port="SW1" data-iface="Et0/1">
        <rect x="203" y="69" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="224" y="82" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/1</text>
        <title>SW1 Et0/1</title>
      </g>
      <g data-port="SW1" data-iface="Et0/2">
        <rect x="171" y="120" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="192" y="133" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/2</text>
        <title>SW1 Et0/2</title>
      </g>
      <g data-port="PC1" data-iface="eth0">
        <rect x="324" y="224" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="345" y="237" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">eth0</text>
        <title>PC1 eth0</title>
      </g>
      <g data-port="KALI" data-iface="eth0">
        <rect x="265" y="69" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="286" y="82" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">eth0</text>
        <title>KALI eth0</title>
      </g>
      <g data-node="R1" data-role="core">
        <rect x="315" y="120" width="140" height="60" rx="6" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
        <text x="385" y="156" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#e6edf3">R1</text>
        <text x="385" y="174" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">router</text>
        <title>R1</title>
      </g>
      <g data-node="SW1" data-role="core">
        <rect x="60" y="55" width="140" height="60" rx="6" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
        <text x="130" y="91" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#e6edf3">SW1</text>
        <text x="130" y="109" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">l2 switch</text>
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
          <rect x="310" y="55" width="140" height="60" rx="6" fill="#1a0f11" stroke="#f85149" stroke-width="1.5" stroke-dasharray="5 3" />
        </g>
        <text x="380" y="91" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#ff7b72">KALI</text>
        <text x="380" y="109" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#f85149">attacker / observer</text>
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
$md$,
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
        <line x1="315" y1="132" x2="200" y2="103" stroke="#4d5560" stroke-width="1.5"
          data-node-a="R1" data-iface-a="Fa0/0" data-node-b="SW1" data-iface-b="Et0/0" />
        <title>R1 Fa0/0 ↔ SW1 Et0/0</title>
      </g>
      <g data-link="KALI:eth0↔SW1:Et0/1">
        <line x1="310" y1="85" x2="200" y2="85" stroke="#4d5560" stroke-width="1.5"
          data-node-a="KALI" data-iface-a="eth0" data-node-b="SW1" data-iface-b="Et0/1" />
        <title>KALI eth0 ↔ SW1 Et0/1</title>
      </g>
      <g data-link="PC1:eth0↔SW1:Et0/2">
        <line x1="361" y1="252" x2="171" y2="115" stroke="#4d5560" stroke-width="1.5"
          data-node-a="PC1" data-iface-a="eth0" data-node-b="SW1" data-iface-b="Et0/2" />
        <title>PC1 eth0 ↔ SW1 Et0/2</title>
      </g>
      <g data-port="R1" data-iface="Fa0/0">
        <rect x="272" y="110" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="293" y="123" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Fa0/0</text>
        <title>R1 Fa0/0</title>
      </g>
      <g data-port="SW1" data-iface="Et0/0">
        <rect x="204" y="98" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="225" y="111" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/0</text>
        <title>SW1 Et0/0</title>
      </g>
      <g data-port="SW1" data-iface="Et0/1">
        <rect x="203" y="69" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="224" y="82" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/1</text>
        <title>SW1 Et0/1</title>
      </g>
      <g data-port="SW1" data-iface="Et0/2">
        <rect x="171" y="120" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="192" y="133" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/2</text>
        <title>SW1 Et0/2</title>
      </g>
      <g data-port="PC1" data-iface="eth0">
        <rect x="324" y="224" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="345" y="237" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">eth0</text>
        <title>PC1 eth0</title>
      </g>
      <g data-port="KALI" data-iface="eth0">
        <rect x="265" y="69" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="286" y="82" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">eth0</text>
        <title>KALI eth0</title>
      </g>
      <g data-node="R1" data-role="core">
        <rect x="315" y="120" width="140" height="60" rx="6" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
        <text x="385" y="156" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#e6edf3">R1</text>
        <text x="385" y="174" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">router</text>
        <title>R1</title>
      </g>
      <g data-node="SW1" data-role="core">
        <rect x="60" y="55" width="140" height="60" rx="6" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
        <text x="130" y="91" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#e6edf3">SW1</text>
        <text x="130" y="109" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">l2 switch</text>
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
          <rect x="310" y="55" width="140" height="60" rx="6" fill="#1a0f11" stroke="#f85149" stroke-width="1.5" stroke-dasharray="5 3" />
        </g>
        <text x="380" y="91" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#ff7b72">KALI</text>
        <text x="380" y="109" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#f85149">attacker / observer</text>
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
    </svg>$md$)
WHERE lab_id = 32;

UPDATE lab_topologies SET svg_large = verify_replace(svg_large,
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
        <rect x="262" y="174" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="283" y="187" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Fa0/0</text>
        <title>R1 Fa0/0</title>
      </g>
      <g data-port="SW1" data-iface="Et0/0">
        <rect x="371" y="101" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="392" y="114" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/0</text>
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
$md$,
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
    </svg>$md$)
WHERE lab_id = 34;

UPDATE lab_topologies SET svg_large = verify_replace(svg_large,
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
        <rect x="67" y="121" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="88" y="134" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Fa0/0</text>
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
$md$,
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
    </svg>$md$)
WHERE lab_id = 35;
