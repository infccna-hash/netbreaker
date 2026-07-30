-- 051_lab16_topology_diagram_fix.up.sql
--
-- Fixes three real bugs in Lab 16's topology diagram (lab_topologies,
-- separate from lab_phases content fixed in migration 050), found by
-- comparing the rendered diagram against lab16_topology.go:
--
--   1. svg_large: PC2's connector line terminated at (280,58) -- empty
--      space between the switches, not touching any node box.
--   2. svg_small: PC2 was missing from the diagram entirely.
--   3. svg_small: KALI was drawn connected to R1 instead of SW2 --
--      backwards from the real wiring (SW2: Et0/0=KALI, Et0/2=PC2).
--
-- Both diagrams are redrawn from lab16_topology.go's actual wiring
-- (SW1: Et0/0=PC1, Et0/1=R1, Et0/2=SW2 / SW2: Et0/0=KALI, Et0/1=SW1,
-- Et0/2=PC2). Every connector line was checked programmatically to
-- confirm it actually terminates inside both endpoint boxes before
-- this migration was written.
--
-- Legend text also updated: "cable type critical" no longer applies
-- (migration 050 replaced the cable-type fault with shutdown/no
-- shutdown); "physical tap" attacker description softened to
-- "observation point" to match Attack-1 becoming conceptual-only.
--
-- Node shape (rect, not circle) intentionally left as-is: rect is
-- the dominant convention across the curriculum (Lab1: 0 circles/11
-- rects, Lab8: 0/8) -- Lab15's circles are the outlier, not Lab16.

BEGIN;

UPDATE lab_topologies
SET
  svg_small = $svg$<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 380 180" font-family="ui-monospace,monospace">
  <rect x="10" y="10" width="90" height="34" rx="6" fill="#fff" stroke="#6b7480" stroke-width="1.5"/>
  <text x="55" y="31" text-anchor="middle" font-size="11" fill="#14161a" font-weight="600">SW1</text>
  <rect x="280" y="10" width="90" height="34" rx="6" fill="#fff" stroke="#6b7480" stroke-width="1.5"/>
  <text x="325" y="31" text-anchor="middle" font-size="11" fill="#14161a" font-weight="600">SW2</text>
  <line x1="100" y1="27" x2="280" y2="27" stroke="#6b7480" stroke-width="2"/>
  <text x="190" y="23" text-anchor="middle" font-size="7" fill="#6b7480">Et0/2 trunk</text>
  <rect x="10" y="130" width="70" height="32" rx="6" fill="#fff" stroke="#2563eb" stroke-width="1.5"/>
  <text x="45" y="150" text-anchor="middle" font-size="9" fill="#2563eb">PC1</text>
  <rect x="95" y="130" width="70" height="32" rx="6" fill="#fff" stroke="#14161a" stroke-width="1.5"/>
  <text x="130" y="150" text-anchor="middle" font-size="9" fill="#14161a">R1</text>
  <rect x="215" y="130" width="70" height="32" rx="6" fill="#fff" stroke="#2563eb" stroke-width="1.5"/>
  <text x="250" y="150" text-anchor="middle" font-size="9" fill="#2563eb">PC2</text>
  <rect x="300" y="130" width="75" height="32" rx="6" fill="#fff" stroke="#e5484d" stroke-width="1.5"/>
  <text x="337" y="150" text-anchor="middle" font-size="9" fill="#e5484d">KALI</text>
  <line x1="45" y1="130" x2="45" y2="44" stroke="#2563eb" stroke-width="2"/>
  <line x1="130" y1="130" x2="95" y2="44" stroke="#14161a" stroke-width="2"/>
  <line x1="250" y1="130" x2="295" y2="44" stroke="#2563eb" stroke-width="2"/>
  <line x1="337" y1="130" x2="337" y2="44" stroke="#e5484d" stroke-width="2"/>
</svg>$svg$,
  svg_large = $svg$<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 600 280" font-family="ui-monospace,monospace">
  <rect x="60" y="14" width="180" height="44" rx="8" fill="#fff" stroke="#6b7480" stroke-width="1.5"/>
  <text x="150" y="36" text-anchor="middle" font-size="13" fill="#14161a" font-weight="600">SW1</text>
  <text x="150" y="52" text-anchor="middle" font-size="8" fill="#6b7480">ports: Et0/0-2</text>
  <rect x="360" y="14" width="180" height="44" rx="8" fill="#fff" stroke="#6b7480" stroke-width="1.5"/>
  <text x="450" y="36" text-anchor="middle" font-size="13" fill="#14161a" font-weight="600">SW2</text>
  <text x="450" y="52" text-anchor="middle" font-size="8" fill="#6b7480">ports: Et0/0-2</text>
  <line x1="240" y1="36" x2="360" y2="36" stroke="#6b7480" stroke-width="2"/>
<text x="300" y="30" text-anchor="middle" font-size="9" fill="#6b7480">Et0/2 trunk</text>
  <rect x="20" y="190" width="130" height="40" rx="6" fill="#fff" stroke="#2563eb" stroke-width="1.5"/>
  <text x="85" y="214" text-anchor="middle" font-size="11" fill="#2563eb">PC1</text>
  <rect x="170" y="190" width="130" height="40" rx="6" fill="#fff" stroke="#14161a" stroke-width="1.5"/>
  <text x="235" y="214" text-anchor="middle" font-size="11" fill="#14161a">R1 (console)</text>
  <rect x="330" y="190" width="130" height="40" rx="6" fill="#fff" stroke="#2563eb" stroke-width="1.5"/>
  <text x="395" y="214" text-anchor="middle" font-size="11" fill="#2563eb">PC2</text>
  <rect x="470" y="190" width="130" height="44" rx="6" fill="#fff" stroke="#e5484d" stroke-width="1.5"/>
  <text x="535" y="216" text-anchor="middle" font-size="11" fill="#e5484d">KALI (tapper)</text>
  <line x1="85" y1="190" x2="85" y2="58" stroke="#2563eb" stroke-width="2"/>
  <line x1="235" y1="190" x2="200" y2="58" stroke="#14161a" stroke-width="2"/>
  <line x1="395" y1="190" x2="420" y2="58" stroke="#2563eb" stroke-width="2"/>
  <line x1="535" y1="190" x2="500" y2="58" stroke="#e5484d" stroke-width="2"/>
</svg>$svg$,
  legend = '["Layer-2 switch", "Inter-switch trunk (Et0/2)", "Router (console-access port)", "End host", "Attacker (observation point)"]'::jsonb
WHERE lab_id = 16;

COMMIT;
