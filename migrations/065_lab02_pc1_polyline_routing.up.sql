-- 065_lab02_pc1_polyline_routing.up.sql
-- Replace the straight PC1→SW1 line with a polyline that routes around SW2
-- Fixes visual routing bug: straight line passed diagonally through SW2 rectangle
-- Option D: right-angle routing — horizontal → vertical → diagonal into SW1

UPDATE lab_topologies
SET svg_large = replace(
    svg_large,
    '<line x1="120" y1="352" x2="330" y2="92" stroke="#2563eb" stroke-width="2"/>',
    '<polyline points="120,352 270,352 270,120 330,92" stroke="#2563eb" stroke-width="2" fill="none"/>'
)
WHERE lab_id = 2;
