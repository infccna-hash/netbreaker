-- 041_fix_lab15_build_truncation.down.sql
-- Reverts to the previous (truncated) content. Only used if the
-- migration needs to be rolled back for reasons unrelated to the
-- fix itself (e.g. discovery of a different issue with the new
-- content that requires reverting both).
BEGIN;

UPDATE lab_phases
SET content = 'Content coming soon. Upload via admin panel.'
WHERE lab_id = 15 AND phase = 'build';

COMMIT;
