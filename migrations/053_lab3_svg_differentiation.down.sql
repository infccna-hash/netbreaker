-- 053_lab3_svg_differentiation.down.sql
--
-- Restores Lab 3's original identical SVGs and legend (from migration
-- 030). Content extracted byte-for-byte from the live DB before 053
-- was applied.

BEGIN;

UPDATE lab_topologies
SET
  svg_small = $svg$<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 380 220" font-family="ui-monospace,monospace">
  <rect x="130" y="30" width="120" height="44" rx="9" fill="#fff" stroke="#14161a" stroke-width="1.5"/>
  <text x="190" y="54" text-anchor="middle" font-size="14" fill="#14161a" font-weight="600">SW1</text>
  <text x="190" y="68" text-anchor="middle" font-size="9" fill="#6b7480">CAM: running</text>
  <line x1="70" y1="130" x2="150" y2="74" stroke="#6b7480" stroke-width="2"/>
  <line x1="190" y1="74" x2="310" y2="130" stroke="#6b7480" stroke-width="2"/>
  <line x1="190" y1="74" x2="190" y2="160" stroke="#e5484d" stroke-width="2" stroke-dasharray="5 4"/>
  <rect x="12" y="130" width="116" height="40" rx="8" fill="#fff" stroke="#2563eb" stroke-width="1.5"/>
  <text x="70" y="152" text-anchor="middle" font-size="12" fill="#2563eb" font-weight="600">PC1</text>
  <text x="70" y="164" text-anchor="middle" font-size="8" fill="#6b7480">10.0.0.10</text>
  <rect x="252" y="130" width="116" height="40" rx="8" fill="#fff" stroke="#2563eb" stroke-width="1.5"/>
  <text x="310" y="152" text-anchor="middle" font-size="12" fill="#2563eb" font-weight="600">PC2</text>
  <text x="310" y="164" text-anchor="middle" font-size="8" fill="#6b7480">10.0.0.20</text>
  <rect x="128" y="168" width="124" height="40" rx="8" fill="#fff" stroke="#e5484d" stroke-width="1.5"/>
  <text x="190" y="190" text-anchor="middle" font-size="12" fill="#e5484d" font-weight="600">KALI</text>
  <text x="190" y="202" text-anchor="middle" font-size="8" fill="#6b7480">macof ⚡</text>
</svg>$svg$,
  svg_large = $svg$<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 380 220" font-family="ui-monospace,monospace">
  <rect x="130" y="30" width="120" height="44" rx="9" fill="#fff" stroke="#14161a" stroke-width="1.5"/>
  <text x="190" y="54" text-anchor="middle" font-size="14" fill="#14161a" font-weight="600">SW1</text>
  <text x="190" y="68" text-anchor="middle" font-size="9" fill="#6b7480">CAM: running</text>
  <line x1="70" y1="130" x2="150" y2="74" stroke="#6b7480" stroke-width="2"/>
  <line x1="190" y1="74" x2="310" y2="130" stroke="#6b7480" stroke-width="2"/>
  <line x1="190" y1="74" x2="190" y2="160" stroke="#e5484d" stroke-width="2" stroke-dasharray="5 4"/>
  <rect x="12" y="130" width="116" height="40" rx="8" fill="#fff" stroke="#2563eb" stroke-width="1.5"/>
  <text x="70" y="152" text-anchor="middle" font-size="12" fill="#2563eb" font-weight="600">PC1</text>
  <text x="70" y="164" text-anchor="middle" font-size="8" fill="#6b7480">10.0.0.10</text>
  <rect x="252" y="130" width="116" height="40" rx="8" fill="#fff" stroke="#2563eb" stroke-width="1.5"/>
  <text x="310" y="152" text-anchor="middle" font-size="12" fill="#2563eb" font-weight="600">PC2</text>
  <text x="310" y="164" text-anchor="middle" font-size="8" fill="#6b7480">10.0.0.20</text>
  <rect x="128" y="168" width="124" height="40" rx="8" fill="#fff" stroke="#e5484d" stroke-width="1.5"/>
  <text x="190" y="190" text-anchor="middle" font-size="12" fill="#e5484d" font-weight="600">KALI</text>
  <text x="190" y="202" text-anchor="middle" font-size="8" fill="#6b7480">macof ⚡</text>
</svg>$svg$,
  legend = '[]'::jsonb
WHERE lab_id = 3;

COMMIT;
