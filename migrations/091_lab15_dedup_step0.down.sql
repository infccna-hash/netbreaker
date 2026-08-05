-- Migration 091 DOWN: not supported (content dedup, not reversible).
-- The duplicated Step 0 block cannot be reconstructed byte-exactly from
-- the remaining single copy (dump paths normalize content; we measured
-- three different byte counts for the same row). Rolling back would risk
-- corrupting the phase content. See the UP migration for details.
-- This is a deliberate no-op; the UP fix is idempotent and final.
SELECT 1;
