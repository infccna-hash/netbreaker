-- 066_lab02_full_layout_redesign.up.sql
-- Complete topology SVG redesign — PC1 relocated to top-left corner
-- Fixes visual routing bug: PC1→SW1 line no longer passes through SW2
-- Also creates symmetrical layout: PC1 (top-left) mirrors KALI (bottom-right)

UPDATE lab_topologies
SET
  svg_large = '<svg viewBox="0 0 760 460" xmlns="http://www.w3.org/2000/svg" font-family="ui-monospace, monospace">
   <line x1="340" y1="96" x2="165" y2="260" stroke="#6b7480" stroke-width="2.5"/>
   <line x1="340" y1="96" x2="525" y2="260" stroke="#6b7480" stroke-width="2.5"/>
   <line x1="240" y1="288" x2="440" y2="288" stroke="#e5484d" stroke-width="2.5" stroke-dasharray="8 5"/>
   <text x="340" y="278" text-anchor="middle" font-size="10" fill="#e5484d">blocked by STP (loop-prevention)</text>
   <line x1="140" y1="140" x2="265" y2="94" stroke="#2563eb" stroke-width="2"/>
   <line x1="525" y1="380" x2="525" y2="316" stroke="#e5484d" stroke-width="2.2" stroke-dasharray="6 4"/>
   <rect x="260" y="40" width="160" height="56" rx="9" fill="#fff" stroke="#10855f" stroke-width="1.8"/>
   <text x="340" y="68" text-anchor="middle" font-size="13" fill="#10855f" font-weight="700">SW1 👑</text>
   <text x="340" y="83" text-anchor="middle" font-size="9" fill="#6b7480">root bridge</text>
   <rect x="90" y="260" width="150" height="56" rx="9" fill="#fff" stroke="#14161a" stroke-width="1.5"/>
   <text x="165" y="286" text-anchor="middle" font-size="13" fill="#14161a" font-weight="600">SW2</text>
   <text x="165" y="301" text-anchor="middle" font-size="9" fill="#6b7480">secondary root</text>
   <rect x="440" y="260" width="170" height="56" rx="9" fill="#fff" stroke="#14161a" stroke-width="1.5"/>
   <text x="525" y="286" text-anchor="middle" font-size="13" fill="#14161a" font-weight="600">SW3</text>
   <text x="525" y="301" text-anchor="middle" font-size="9" fill="#6b7480">Et0/2 → BPDU Guard ⚠</text>
   <rect x="10" y="140" width="130" height="56" rx="9" fill="#fff" stroke="#2563eb" stroke-width="1.6"/>
   <text x="75" y="166" text-anchor="middle" font-size="12" fill="#2563eb" font-weight="600">PC1</text>
   <text x="75" y="181" text-anchor="middle" font-size="8.5" fill="#6b7480">ordinary host</text>
   <rect x="440" y="380" width="170" height="56" rx="9" fill="#fff" stroke="#e5484d" stroke-width="1.8"/>
   <text x="525" y="406" text-anchor="middle" font-size="12" fill="#e5484d" font-weight="700">KALI · attacker</text>
   <text x="525" y="421" text-anchor="middle" font-size="8.5" fill="#6b7480">claims root via BPDU</text>
 </svg>',

  svg_small = '<svg viewBox="0 0 320 220" xmlns="http://www.w3.org/2000/svg" font-family="ui-monospace, monospace">
   <line x1="143" y1="46" x2="70" y2="125" stroke="#6b7480" stroke-width="2.5"/>
   <line x1="143" y1="46" x2="221" y2="125" stroke="#6b7480" stroke-width="2.5"/>
   <line x1="70" y1="125" x2="221" y2="125" stroke="#e5484d" stroke-width="2.5" stroke-dasharray="6 4"/>
   <rect x="109" y="18" width="68" height="28" rx="6" fill="#fff" stroke="#10855f" stroke-width="1.6"/>
   <text x="143" y="37" text-anchor="middle" font-size="11" fill="#10855f" font-weight="700">SW1 👑</text>
   <rect x="38" y="125" width="64" height="28" rx="6" fill="#fff" stroke="#14161a" stroke-width="1.4"/>
   <text x="70" y="144" text-anchor="middle" font-size="11" fill="#14161a" font-weight="600">SW2</text>
   <rect x="185" y="125" width="72" height="28" rx="6" fill="#fff" stroke="#14161a" stroke-width="1.4"/>
   <text x="221" y="144" text-anchor="middle" font-size="11" fill="#14161a" font-weight="600">SW3</text>
   <text x="160" y="196" text-anchor="middle" font-size="9" fill="#e5484d">✂ one link BLOCKED by STP</text>
 </svg>'

WHERE lab_id = 2;
