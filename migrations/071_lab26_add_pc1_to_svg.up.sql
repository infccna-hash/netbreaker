-- 071_lab26_add_pc1_to_svg.up.sql
-- Fix SVG: add missing PC1 node + PC1↔SW1 link

UPDATE lab_topologies
SET svg_large = '<svg viewBox="0 0 550 210" font-family="monospace">
  <rect x="30" y="20" width="180" height="50" rx="10" fill="#fff" stroke="#6b7480" stroke-width="2"/>
  <text x="120" y="46" text-anchor="middle" font-size="14" font-weight="700">SW1</text>
  <text x="120" y="62" text-anchor="middle" font-size="9" fill="#6b7480">Gi0/23 + Gi0/24 → Po1</text>
  <rect x="310" y="20" width="180" height="50" rx="10" fill="#fff" stroke="#6b7480" stroke-width="2"/>
  <text x="400" y="46" text-anchor="middle" font-size="14" font-weight="700">SW2</text>
  <text x="400" y="62" text-anchor="middle" font-size="9" fill="#6b7480">LACP active</text>
  <line x1="210" y1="45" x2="260" y2="45" stroke="#2563eb" stroke-width="2.5"/>
  <line x1="260" y1="35" x2="280" y2="35" stroke="#2563eb" stroke-width="2.5"/>
  <line x1="260" y1="55" x2="280" y2="55" stroke="#2563eb" stroke-width="2.5"/>
  <text x="270" y="28" font-size="8" fill="#2563eb">Po1</text>
  <rect x="170" y="140" width="180" height="40" rx="8" fill="#fff" stroke="#e5484d" stroke-width="2"/>
  <text x="260" y="164" text-anchor="middle" font-size="11" fill="#e5484d" font-weight="600">KALI · LACP spoof</text>
  <line x1="260" y1="140" x2="170" y2="70" stroke="#e5484d" stroke-width="2" stroke-dasharray="6 5"/>
  <rect x="30" y="140" width="100" height="40" rx="6" fill="#fff" stroke="#2563eb" stroke-width="1.5"/>
  <text x="80" y="164" text-anchor="middle" font-size="11" fill="#2563eb" font-weight="600">PC1</text>
  <line x1="80" y1="140" x2="120" y2="70" stroke="#2563eb" stroke-width="2"/>
</svg>'
WHERE lab_id = 26;
