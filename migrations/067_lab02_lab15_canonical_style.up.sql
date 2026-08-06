-- 067_lab02_lab15_canonical_style.up.sql
-- Complete SVG redesign: Apply Lab 15 canonical visual dictionary to Lab 2
-- Dark terminal theme, grid background, color-coded device types, legend
-- Switch = grey rect, End host = cyan circle, Attacker = red dashed rect + glow

UPDATE lab_topologies
SET
  svg_large = $SVG$<svg
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
</svg>$SVG$,

  svg_small = $SVG$<svg viewBox="0 0 320 220" xmlns="http://www.w3.org/2000/svg" font-family="Courier New, monospace">
   <rect width="320" height="220" rx="6" fill="#0b0f14" stroke="#22272e" stroke-width="1" />
   <line x1="160" y1="40" x2="70" y2="120" stroke="#4d5560" stroke-width="1.5" />
   <line x1="160" y1="40" x2="250" y2="120" stroke="#4d5560" stroke-width="1.5" />
   <line x1="70" y1="120" x2="250" y2="120" stroke="#e5484d" stroke-width="1.5" stroke-dasharray="6 4" />
   <rect x="110" y="15" width="100" height="36" rx="5" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
   <text x="160" y="37" text-anchor="middle" font-size="12" font-weight="700" fill="#e6edf3">SW1 👑</text>
   <rect x="30" y="120" width="80" height="36" rx="5" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
   <text x="70" y="142" text-anchor="middle" font-size="12" font-weight="700" fill="#e6edf3">SW2</text>
   <rect x="210" y="120" width="80" height="36" rx="5" fill="#131a21" stroke="#8b98a5" stroke-width="1.5" />
   <text x="250" y="142" text-anchor="middle" font-size="12" font-weight="700" fill="#e6edf3">SW3</text>
   <circle cx="70" cy="185" r="16" fill="#131a21" stroke="#22d3ee" stroke-width="1.5" />
   <text x="70" y="189" text-anchor="middle" font-size="9" font-weight="700" fill="#67e8f9">PC1</text>
   <rect x="210" y="173" width="70" height="30" rx="4" fill="#1a0f11" stroke="#f85149" stroke-width="1.5" stroke-dasharray="4 2" />
   <text x="245" y="192" text-anchor="middle" font-size="9" font-weight="700" fill="#ff7b72">KALI</text>
   <text x="160" y="212" text-anchor="middle" font-size="8" fill="#e5484d">✂ one link BLOCKED by STP</text>
 </svg>$SVG$

WHERE lab_id = 2;
