-- Migration 94 DOWN: restore pre-min-gap renders (reverse of UP).

UPDATE lab_topologies SET svg_large = verify_replace(svg_large,
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
        <line x1="175" y1="115" x2="320" y2="181" stroke="#4d5560" stroke-width="1.5"
          data-node-a="R1" data-iface-a="Fa0/0" data-node-b="SW1" data-iface-b="Et0/0" />
        <title>R1 Fa0/0 ↔ SW1 Et0/0</title>
      </g>
      <g data-link="KALI:eth0↔SW1:Et0/1">
        <line x1="366" y1="115" x2="379" y2="181" stroke="#4d5560" stroke-width="1.5"
          data-node-a="KALI" data-iface-a="eth0" data-node-b="SW1" data-iface-b="Et0/1" />
        <title>KALI eth0 ↔ SW1 Et0/1</title>
      </g>
      <g data-port="R1" data-iface="Fa0/0">
        <rect x="173" y="122" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="194" y="135" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Fa0/0</text>
        <title>R1 Fa0/0</title>
      </g>
      <g data-port="SW1" data-iface="Et0/0">
        <rect x="274" y="168" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="295" y="181" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/0</text>
        <title>SW1 Et0/0</title>
      </g>
      <g data-port="SW1" data-iface="Et0/1">
        <rect x="347" y="150" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="368" y="163" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/1</text>
        <title>SW1 Et0/1</title>
      </g>
      <g data-port="KALI" data-iface="eth0">
        <rect x="343" y="131" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="364" y="144" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">eth0</text>
        <title>KALI eth0</title>
      </g>
      <g data-node="R1" data-role="core">
        <rect x="40" y="55" width="140" height="60" rx="6" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
        <text x="110" y="91" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#e6edf3">R1</text>
        <text x="110" y="109" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">router</text>
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
          <rect x="290" y="55" width="140" height="60" rx="6" fill="#1a0f11" stroke="#f85149" stroke-width="1.5" stroke-dasharray="5 3" />
        </g>
        <text x="360" y="91" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#ff7b72">KALI</text>
        <text x="360" y="109" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#f85149">attacker / observer</text>
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
        <line x1="180" y1="104" x2="315" y2="139" stroke="#4d5560" stroke-width="1.5"
          data-node-a="R1" data-iface-a="Fa0/0" data-node-b="SW1" data-iface-b="Et0/0" />
        <title>R1 Fa0/0 ↔ SW1 Et0/0</title>
      </g>
      <g data-link="KALI:eth0↔SW1:Et0/1">
        <line x1="370" y1="115" x2="375" y2="128" stroke="#4d5560" stroke-width="1.5"
          data-node-a="KALI" data-iface-a="eth0" data-node-b="SW1" data-iface-b="Et0/1" />
        <title>KALI eth0 ↔ SW1 Et0/1</title>
      </g>
      <g data-port="R1" data-iface="Fa0/0">
        <rect x="180" y="108" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="201" y="121" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Fa0/0</text>
        <title>R1 Fa0/0</title>
      </g>
      <g data-port="SW1" data-iface="Et0/0">
        <rect x="269" y="131" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="290" y="144" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/0</text>
        <title>SW1 Et0/0</title>
      </g>
      <g data-port="SW1" data-iface="Et0/1">
        <rect x="339" y="99" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="360" y="112" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/1</text>
        <title>SW1 Et0/1</title>
      </g>
      <g data-port="KALI" data-iface="eth0">
        <rect x="350" y="131" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="371" y="144" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">eth0</text>
        <title>KALI eth0</title>
      </g>
      <g data-node="R1" data-role="core">
        <rect x="40" y="55" width="140" height="60" rx="6" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
        <text x="110" y="91" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#e6edf3">R1</text>
        <text x="110" y="109" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">router</text>
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
          <rect x="290" y="55" width="140" height="60" rx="6" fill="#1a0f11" stroke="#f85149" stroke-width="1.5" stroke-dasharray="5 3" />
        </g>
        <text x="360" y="91" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#ff7b72">KALI</text>
        <text x="360" y="109" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#f85149">attacker / observer</text>
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
WHERE lab_id = 43;

UPDATE lab_topologies SET svg_large = verify_replace(svg_large,
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
        <line x1="175" y1="115" x2="320" y2="181" stroke="#4d5560" stroke-width="1.5"
          data-node-a="R1" data-iface-a="Fa0/0" data-node-b="SW1" data-iface-b="Et0/0" />
        <title>R1 Fa0/0 ↔ SW1 Et0/0</title>
      </g>
      <g data-link="KALI:eth0↔SW1:Et0/1">
        <line x1="366" y1="115" x2="379" y2="181" stroke="#4d5560" stroke-width="1.5"
          data-node-a="KALI" data-iface-a="eth0" data-node-b="SW1" data-iface-b="Et0/1" />
        <title>KALI eth0 ↔ SW1 Et0/1</title>
      </g>
      <g data-port="R1" data-iface="Fa0/0">
        <rect x="173" y="122" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="194" y="135" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Fa0/0</text>
        <title>R1 Fa0/0</title>
      </g>
      <g data-port="SW1" data-iface="Et0/0">
        <rect x="274" y="168" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="295" y="181" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/0</text>
        <title>SW1 Et0/0</title>
      </g>
      <g data-port="SW1" data-iface="Et0/1">
        <rect x="347" y="150" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="368" y="163" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/1</text>
        <title>SW1 Et0/1</title>
      </g>
      <g data-port="KALI" data-iface="eth0">
        <rect x="343" y="131" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="364" y="144" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">eth0</text>
        <title>KALI eth0</title>
      </g>
      <g data-node="R1" data-role="core">
        <rect x="40" y="55" width="140" height="60" rx="6" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
        <text x="110" y="91" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#e6edf3">R1</text>
        <text x="110" y="109" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">router</text>
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
          <rect x="290" y="55" width="140" height="60" rx="6" fill="#1a0f11" stroke="#f85149" stroke-width="1.5" stroke-dasharray="5 3" />
        </g>
        <text x="360" y="91" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#ff7b72">KALI</text>
        <text x="360" y="109" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#f85149">attacker / observer</text>
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
        <line x1="180" y1="104" x2="315" y2="139" stroke="#4d5560" stroke-width="1.5"
          data-node-a="R1" data-iface-a="Fa0/0" data-node-b="SW1" data-iface-b="Et0/0" />
        <title>R1 Fa0/0 ↔ SW1 Et0/0</title>
      </g>
      <g data-link="KALI:eth0↔SW1:Et0/1">
        <line x1="370" y1="115" x2="375" y2="128" stroke="#4d5560" stroke-width="1.5"
          data-node-a="KALI" data-iface-a="eth0" data-node-b="SW1" data-iface-b="Et0/1" />
        <title>KALI eth0 ↔ SW1 Et0/1</title>
      </g>
      <g data-port="R1" data-iface="Fa0/0">
        <rect x="180" y="108" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="201" y="121" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Fa0/0</text>
        <title>R1 Fa0/0</title>
      </g>
      <g data-port="SW1" data-iface="Et0/0">
        <rect x="269" y="131" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="290" y="144" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/0</text>
        <title>SW1 Et0/0</title>
      </g>
      <g data-port="SW1" data-iface="Et0/1">
        <rect x="339" y="99" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="360" y="112" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">Et0/1</text>
        <title>SW1 Et0/1</title>
      </g>
      <g data-port="KALI" data-iface="eth0">
        <rect x="350" y="131" width="42" height="18" rx="3" fill="#0b0f14" stroke="#3fb950" stroke-width="1" />
        <text x="371" y="144" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#3fb950">eth0</text>
        <title>KALI eth0</title>
      </g>
      <g data-node="R1" data-role="core">
        <rect x="40" y="55" width="140" height="60" rx="6" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
        <text x="110" y="91" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#e6edf3">R1</text>
        <text x="110" y="109" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#8b98a5">router</text>
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
          <rect x="290" y="55" width="140" height="60" rx="6" fill="#1a0f11" stroke="#f85149" stroke-width="1.5" stroke-dasharray="5 3" />
        </g>
        <text x="360" y="91" text-anchor="middle" font-family="Courier New, monospace" fontSize="15" fontWeight="700" fill="#ff7b72">KALI</text>
        <text x="360" y="109" text-anchor="middle" font-family="Courier New, monospace" fontSize="10" fill="#f85149">attacker / observer</text>
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
WHERE lab_id = 44;
