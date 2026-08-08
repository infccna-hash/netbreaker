-- Migration 95 DOWN: restore pre-min-gap renders (reverse of UP).

UPDATE lab_topologies SET svg_large = verify_replace(svg_large,
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
        <line x1="360" y1="104" x2="410" y2="104" stroke="#4d5560" stroke-width="1.5"
          data-node-a="R1" data-iface-a="Fa0/0" data-node-b="SW1" data-iface-b="Et0/0" />
        <title>R1 Fa0/0 ↔ SW1 Et0/0</title>
      </g>
      <g data-link="KALI:eth0↔SW1:Et0/1">
        <line x1="335" y1="200" x2="435" y2="134" stroke="#4d5560" stroke-width="1.5"
          data-node-a="KALI" data-iface-a="eth0" data-node-b="SW1" data-iface-b="Et0/1" />
        <title>KALI eth0 ↔ SW1 Et0/1</title>
      </g>
      <g data-link="PC1:eth0↔SW1:Et0/2">
        <line x1="480" y1="200" x2="480" y2="134" stroke="#4d5560" stroke-width="1.5"
          data-node-a="PC1" data-iface-a="eth0" data-node-b="SW1" data-iface-b="Et0/2" />
        <title>PC1 eth0 ↔ SW1 Et0/2</title>
      </g>
      <g data-port="R1" data-iface="Fa0/0">
        <rect x="262" y="168" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="283" y="181" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Fa0/0</text>
        <title>R1 Fa0/0</title>
      </g>
      <g data-port="SW1" data-iface="Et0/0">
        <rect x="371" y="95" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="392" y="108" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/0</text>
        <title>SW1 Et0/0</title>
      </g>
      <g data-port="SW1" data-iface="Et0/1">
        <rect x="398" y="144" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="419" y="157" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/1</text>
        <title>SW1 Et0/1</title>
      </g>
      <g data-port="SW1" data-iface="Et0/2">
        <rect x="466" y="149" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="487" y="162" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/2</text>
        <title>SW1 Et0/2</title>
      </g>
      <g data-port="PC1" data-iface="eth0">
        <rect x="466" y="167" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="487" y="180" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">eth0</text>
        <title>PC1 eth0</title>
      </g>
      <g data-port="KALI" data-iface="eth0">
        <rect x="338" y="184" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="359" y="197" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">eth0</text>
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
$md$,
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
    </svg>$md$)
WHERE lab_id = 33;

UPDATE lab_topologies SET svg_large = verify_replace(svg_large,
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
        <line x1="320" y1="115" x2="365" y2="181" stroke="#4d5560" stroke-width="1.5"
          data-node-a="R1" data-iface-a="Fa0/0" data-node-b="SW1" data-iface-b="Et0/0" />
        <title>R1 Fa0/0 ↔ SW1 Et0/0</title>
      </g>
      <g data-link="KALI:eth0↔SW1:Et0/1">
        <line x1="465" y1="115" x2="410" y2="181" stroke="#4d5560" stroke-width="1.5"
          data-node-a="KALI" data-iface-a="eth0" data-node-b="SW1" data-iface-b="Et0/1" />
        <title>KALI eth0 ↔ SW1 Et0/1</title>
      </g>
      <g data-port="R1" data-iface="Fa0/0">
        <rect x="307" y="130" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="328" y="143" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Fa0/0</text>
        <title>R1 Fa0/0</title>
      </g>
      <g data-port="SW1" data-iface="Et0/0">
        <rect x="325" y="156" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="346" y="169" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/0</text>
        <title>SW1 Et0/0</title>
      </g>
      <g data-port="SW1" data-iface="Et0/1">
        <rect x="399" y="149" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="420" y="162" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/1</text>
        <title>SW1 Et0/1</title>
      </g>
      <g data-port="KALI" data-iface="eth0">
        <rect x="423" y="120" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="444" y="133" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">eth0</text>
        <title>KALI eth0</title>
      </g>
      <g data-node="R1" data-role="core">
        <rect x="230" y="55" width="140" height="60" rx="6" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
        <text x="300" y="91" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#e6edf3">R1</text>
        <text x="300" y="109" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">router</text>
        <title>R1</title>
      </g>
      <g data-node="SW1" data-role="core">
        <rect x="315" y="181" width="140" height="60" rx="6" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
        <text x="385" y="217" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#e6edf3">SW1</text>
        <text x="385" y="235" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">l2 switch</text>
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
$md$,
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
    </svg>$md$)
WHERE lab_id = 45;
