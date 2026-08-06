-- 065_lab02_pc1_polyline_routing.down.sql
-- Revert polyline back to straight line (restores migration 064 state)

UPDATE lab_topologies
SET svg_large = replace(
    svg_large,
    '<polyline points="120,352 270,352 270,120 330,92" stroke="#2563eb" stroke-width="2" fill="none"/>',
    '<line x1="120" y1="352" x2="330" y2="92" stroke="#2563eb" stroke-width="2"/>'
)
WHERE lab_id = 2;
