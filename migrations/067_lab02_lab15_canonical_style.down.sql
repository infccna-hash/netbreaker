-- 067_lab02_lab15_canonical_style.down.sql
-- Revert to pre-067 layout (post-066 redesign with blue/red lines, no terminal theme)

UPDATE lab_topologies
SET
  svg_large = $SVG$<svg viewBox="0 0 760 460" xmlns="http://www.w3.org/2000/svg" font-family="ui-monospace, monospace">
   <line x1="380" y1="90" x2="180" y2="240" stroke="#6b7480" stroke-width="2.5"/>
   <line x1="380" y1="90" x2="580" y2="240" stroke="#6b7480" stroke-width="2.5"/>
   <line x1="180" y1="260" x2="580" y2="260" stroke="#e5484d" stroke-width="2.5" stroke-dasharray="8 5"/>
   <text x="380" y="290" text-anchor="middle" font-size="10" fill="#e5484d">blocked by STP (loop-prevention)</text>
   <polyline points="120,352 270,352 270,120 330,92" stroke="#2563eb" stroke-width="2" fill="none"/>
   <line x1="640" y1="352" x2="584" y2="286" stroke="#e5484d" stroke-width="2.2" stroke-dasharray="6 4"/>
   <rect x="330" y="46" width="100" height="46" rx="9" fill="#fff" stroke="#10855f" stroke-width="1.8"/>
   <text x="380" y="68" text-anchor="middle" font-size="13" fill="#10855f" font-weight="700">SW1 👑</text>
   <text x="380" y="83" text-anchor="middle" font-size="9" fill="#6b7480">root bridge</text>
   <rect x="120" y="238" width="120" height="48" rx="9" fill="#fff" stroke="#14161a" stroke-width="1.5"/>
   <text x="180" y="260" text-anchor="middle" font-size="13" fill="#14161a" font-weight="600">SW2</text>
   <text x="180" y="275" text-anchor="middle" font-size="9" fill="#6b7480">secondary root</text>
   <rect x="520" y="238" width="120" height="48" rx="9" fill="#fff" stroke="#14161a" stroke-width="1.5"/>
   <text x="580" y="260" text-anchor="middle" font-size="13" fill="#14161a" font-weight="600">SW3</text>
   <text x="580" y="275" text-anchor="middle" font-size="9" fill="#6b7480">Et0/2 → BPDU Guard ⚠</text>
   <rect x="56" y="352" width="120" height="46" rx="9" fill="#fff" stroke="#2563eb" stroke-width="1.6"/>
   <text x="116" y="374" text-anchor="middle" font-size="12" fill="#2563eb" font-weight="600">PC1</text>
   <text x="116" y="389" text-anchor="middle" font-size="8.5" fill="#6b7480">ordinary host</text>
   <rect x="580" y="352" width="128" height="48" rx="9" fill="#fff" stroke="#e5484d" stroke-width="1.8"/>
   <text x="644" y="374" text-anchor="middle" font-size="12" fill="#e5484d" font-weight="700">KALI · attacker</text>
   <text x="644" y="389" text-anchor="middle" font-size="8.5" fill="#6b7480">claims root via BPDU</text>
 </svg>$SVG$,

  svg_small = $SVG$<svg viewBox="0 0 320 220" xmlns="http://www.w3.org/2000/svg" font-family="ui-monospace, monospace">
   <line x1="160" y1="40" x2="70" y2="150" stroke="#6b7480" stroke-width="2.5"/>
   <line x1="160" y1="40" x2="250" y2="150" stroke="#6b7480" stroke-width="2.5"/>
   <line x1="70" y1="150" x2="250" y2="150" stroke="#e5484d" stroke-width="2.5" stroke-dasharray="6 4"/>
   <rect x="120" y="18" width="80" height="34" rx="7" fill="#fff" stroke="#10855f" stroke-width="1.6"/>
   <text x="160" y="40" text-anchor="middle" font-size="12" fill="#10855f" font-weight="700">SW1 👑</text>
   <rect x="26" y="150" width="80" height="34" rx="7" fill="#fff" stroke="#14161a" stroke-width="1.4"/>
   <text x="66" y="172" text-anchor="middle" font-size="12" fill="#14161a" font-weight="600">SW2</text>
   <rect x="206" y="150" width="80" height="34" rx="7" fill="#fff" stroke="#14161a" stroke-width="1.4"/>
   <text x="246" y="172" text-anchor="middle" font-size="12" fill="#14161a" font-weight="600">SW3</text>
   <text x="160" y="196" text-anchor="middle" font-size="9" fill="#e5484d">✂ one link BLOCKED by STP</text>
 </svg>$SVG$

WHERE lab_id = 2;
