-- 064_lab02_fix_pc1_svg_line.up.sql
-- Fix: PC1's SVG line was connecting to SW2 (x=176,y=286) instead of SW1.
-- The topology code (lab02_topology.go:68) and build phase text both have
-- PC1 on SW1:Et0/1. The SVG was drawn before the topology was finalized
-- and was never updated when the code was fixed.
--
-- This migration fixes ONLY the PC1 line endpoint in svg_large.
-- svg_small does not include PC1 — no change needed there.
-- All other 4 links (SW1↔SW2, SW1↔SW3, SW2↔SW3, KALI↔SW3) were verified
-- correct in the 2026-08-03 coordinate audit.

BEGIN;

-- Verify pre-condition: old PC1 line exists exactly as expected
DO $$
DECLARE
    svg_text text;
BEGIN
    SELECT svg_large INTO svg_text FROM lab_topologies WHERE lab_id = 2;
    IF svg_text NOT LIKE '%x1="120" y1="352" x2="176" y2="286"%' THEN
        RAISE EXCEPTION 'pre-condition failed: PC1 line not found at expected coordinates';
    END IF;
END $$;

-- Fix: PC1 line → SW1 bottom-left (x=330,y=92) instead of SW2 area (x=176,y=286)
UPDATE lab_topologies
SET svg_large = replace(svg_large,
    '<line x1="120" y1="352" x2="176" y2="286" stroke="#2563eb" stroke-width="2"/>',
    '<line x1="120" y1="352" x2="330" y2="92" stroke="#2563eb" stroke-width="2"/>'
)
WHERE lab_id = 2;

-- Verify post-condition: new PC1 line exists
DO $$
DECLARE
    svg_text text;
BEGIN
    SELECT svg_large INTO svg_text FROM lab_topologies WHERE lab_id = 2;
    IF svg_text NOT LIKE '%x1="120" y1="352" x2="330" y2="92"%' THEN
        RAISE EXCEPTION 'post-condition failed: PC1 line was not updated';
    END IF;
    IF svg_text LIKE '%x2="176" y2="286"%' THEN
        RAISE EXCEPTION 'post-condition failed: old PC1 line still present';
    END IF;
END $$;

COMMIT;
