-- 064_lab02_fix_pc1_svg_line.down.sql
-- Restore the original PC1 line (pointing to SW2 area).
-- The old line is accurately preserved from the DB snapshot taken before migration 064.

BEGIN;

UPDATE lab_topologies
SET svg_large = replace(svg_large,
    '<line x1="120" y1="352" x2="330" y2="92" stroke="#2563eb" stroke-width="2"/>',
    '<line x1="120" y1="352" x2="176" y2="286" stroke="#2563eb" stroke-width="2"/>'
)
WHERE lab_id = 2;

COMMIT;
