-- 051_lab16_topology_diagram_fix.down.sql
--
-- Restores Lab 16's topology diagram to its pre-051 state (migration
-- 010's original SVGs/legend -- these were never touched by
-- migration 050, so there's no interim patch to account for).
-- Content extracted programmatically from migration 010's source to
-- avoid transcription drift.

BEGIN;

UPDATE lab_topologies
SET
  svg_small = $svg$<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 380 180" font-family="ui-monospace,monospace">
  <rect x="10" y="10" width="100" height="36" rx="6" fill="#fff" stroke="#6b7480" stroke-width="1.5"/>
  <text x="60" y="33" text-anchor="middle" font-size="11" fill="#14161a" font-weight="600">SW1</text>
  <rect x="270" y="10" width="100" height="36" rx="6" fill="#fff" stroke="#6b7480" stroke-width="1.5"/>
  <text x="320" y="33" text-anchor="middle" font-size="11" fill="#14161a" font-weight="600">SW2</text>
  <line x1="110" y1="28" x2="270" y2="28" stroke="#6b7480" stroke-width="2" stroke-dasharray="5 3"/>
  <text x="190" y="24" text-anchor="middle" font-size="7" fill="#6b7480">??? cable</text>
  <rect x="140" y="80" width="100" height="30" rx="6" fill="#fff" stroke="#14161a" stroke-width="1.5"/>
  <text x="190" y="99" text-anchor="middle" font-size="10" fill="#14161a">R1 (console)</text>
  <rect x="10" y="132" width="100" height="30" rx="6" fill="#fff" stroke="#2563eb" stroke-width="1.5"/>
  <text x="60" y="152" text-anchor="middle" font-size="10" fill="#2563eb">PC1</text>
  <rect x="140" y="132" width="100" height="30" rx="6" fill="#fff" stroke="#e5484d" stroke-width="1.5"/>
  <text x="190" y="152" text-anchor="middle" font-size="10" fill="#e5484d">KALI</text>
  <line x1="60" y1="132" x2="60" y2="46" stroke="#2563eb" stroke-width="2"/>
  <line x1="190" y1="132" x2="190" y2="110" stroke="#e5484d" stroke-width="2"/>
</svg>$svg$,
  svg_large = $svg$<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 600 280" font-family="ui-monospace,monospace">
  <rect x="40" y="14" width="160" height="44" rx="8" fill="#fff" stroke="#6b7480" stroke-width="1.5"/>
  <text x="120" y="36" text-anchor="middle" font-size="13" fill="#14161a" font-weight="600">SW1</text>
  <text x="120" y="52" text-anchor="middle" font-size="8" fill="#6b7480">ports: Gi0/1–24</text>
  <rect x="400" y="14" width="160" height="44" rx="8" fill="#fff" stroke="#6b7480" stroke-width="1.5"/>
  <text x="480" y="36" text-anchor="middle" font-size="13" fill="#14161a" font-weight="600">SW2</text>
  <text x="480" y="52" text-anchor="middle" font-size="8" fill="#6b7480">ports: Gi0/1–24</text>
  <line x1="200" y1="36" x2="400" y2="36" stroke="#2563eb" stroke-width="2"/>
<text x="300" y="32" text-anchor="middle" font-size="9" fill="#2563eb">crossover or auto-MDIX</text>
  <rect x="390" y="100" width="100" height="32" rx="6" fill="#fff" stroke="#14161a" stroke-width="1.5"/>
  <text x="440" y="121" text-anchor="middle" font-size="10" fill="#14161a">R1 (console)</text>
  <rect x="40" y="180" width="120" height="34" rx="6" fill="#fff" stroke="#2563eb" stroke-width="1.5"/>
  <text x="100" y="202" text-anchor="middle" font-size="11" fill="#2563eb">PC1</text>
  <rect x="190" y="180" width="120" height="34" rx="6" fill="#fff" stroke="#2563eb" stroke-width="1.5"/>
  <text x="250" y="202" text-anchor="middle" font-size="11" fill="#2563eb">PC2</text>
  <rect x="420" y="180" width="140" height="40" rx="6" fill="#fff" stroke="#e5484d" stroke-width="1.5"/>
  <text x="490" y="204" text-anchor="middle" font-size="11" fill="#e5484d">KALI (tapper)</text>
  <line x1="100" y1="180" x2="110" y2="58" stroke="#2563eb" stroke-width="2"/>
  <line x1="250" y1="180" x2="280" y2="58" stroke="#6b7480" stroke-width="2"/>
  <line x1="490" y1="180" x2="460" y2="132" stroke="#e5484d" stroke-width="2"/>
</svg>$svg$,
  legend = '["Layer-2 switch", "Inter-switch link (cable type critical)", "Router (console-access port)", "End host", "Attacker (physical tap)"]'::jsonb
WHERE lab_id = 16;

COMMIT;
