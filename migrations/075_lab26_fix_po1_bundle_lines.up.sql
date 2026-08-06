-- 075_lab26_fix_po1_bundle_lines.up.sql
-- Fix Po1 EtherChannel bundle: extend lines to actually touch SW1 and SW2 edges
-- SW1 rect ends at x=210, SW2 rect starts at x=310
-- Old: lines end mid-gap at x=260/280. New: span full gap (210→310)

UPDATE lab_topologies
SET svg_large = replace(replace(replace(svg_large,
  '<line x1="210" y1="45" x2="260" y2="45" stroke="#2563eb" stroke-width="2.5"/>',
  '<line x1="210" y1="45" x2="310" y2="45" stroke="#2563eb" stroke-width="2.5"/>'),
  '<line x1="260" y1="35" x2="280" y2="35" stroke="#2563eb" stroke-width="2.5"/>',
  '<line x1="210" y1="35" x2="310" y2="35" stroke="#2563eb" stroke-width="2.5"/>'),
  '<line x1="260" y1="55" x2="280" y2="55" stroke="#2563eb" stroke-width="2.5"/>',
  '<line x1="210" y1="55" x2="310" y2="55" stroke="#2563eb" stroke-width="2.5"/>')
WHERE lab_id = 26;
