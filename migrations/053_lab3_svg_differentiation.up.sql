-- 053_lab3_svg_differentiation.up.sql
--
-- Lab 3's topology SVGs were byte-identical (both 1561 chars, same
-- 380x220 viewBox). The lab is free (is_free=true) so the diagram
-- appears directly in the student view — it needs a proper large/small
-- pair like every other lab.
--
-- svg_small: compact overview (380×200), same layout but slightly
--   shorter — fits in the sidebar preview.
-- svg_large: detailed (560×260), adds Et0/ port labels on every link,
--   IP addresses on host boxes, and a note about the CAM table target.
--   Designed to look good in the full lab-view modal.
--
-- Both drawn from lab03_topology.go: SW1 center, PC1→Et0/1, PC2→Et0/2,
-- KALI→Et0/3. Port numbers verified against build-phase content.

BEGIN;

UPDATE lab_topologies
SET
  svg_small = $svg$<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 380 200" font-family="ui-monospace,monospace">
  <rect x="130" y="24" width="120" height="40" rx="8" fill="#fff" stroke="#14161a" stroke-width="1.5"/>
  <text x="190" y="48" text-anchor="middle" font-size="13" fill="#14161a" font-weight="600">SW1</text>
  <line x1="70" y1="118" x2="150" y2="64" stroke="#6b7480" stroke-width="2"/>
  <line x1="190" y1="64" x2="310" y2="118" stroke="#6b7480" stroke-width="2"/>
  <line x1="190" y1="64" x2="190" y2="140" stroke="#e5484d" stroke-width="2" stroke-dasharray="5 4"/>
  <rect x="12" y="118" width="116" height="36" rx="7" fill="#fff" stroke="#2563eb" stroke-width="1.5"/>
  <text x="70" y="139" text-anchor="middle" font-size="11" fill="#2563eb" font-weight="600">PC1</text>
  <rect x="252" y="118" width="116" height="36" rx="7" fill="#fff" stroke="#2563eb" stroke-width="1.5"/>
  <text x="310" y="139" text-anchor="middle" font-size="11" fill="#2563eb" font-weight="600">PC2</text>
  <rect x="128" y="148" width="124" height="36" rx="7" fill="#fff" stroke="#e5484d" stroke-width="1.5"/>
  <text x="190" y="169" text-anchor="middle" font-size="11" fill="#e5484d" font-weight="600">KALI</text>
</svg>$svg$,
  svg_large = $svg$<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 560 260" font-family="ui-monospace,monospace">
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
</svg>$svg$,
  legend = '["Layer-2 switch", "Access port (VLAN 1)", "End host (10.0.0.0/24)", "Attacker (macof flood source)"]'::jsonb
WHERE lab_id = 3;

COMMIT;
