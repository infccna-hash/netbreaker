-- Migration 091: remove duplicated Step 0 block in Lab 15 attack phase
--
-- The attack content contained the full Step 0 section (callout warn +
-- Workaround note + SW1 config + KALI ping + "diagnose it cold") TWICE,
-- back-to-back, before '## The four faults'. Students saw the setup twice.
--
-- APPROACH: pure-Postgres position/substring — NO verify_replace with a
-- long literal. Reason: the old_str literal would have to match the live
-- content byte-for-byte, but every dump path (psql -t -A, \copy) normalizes
-- this content (we measured: DB length 6153 vs copy 6314 vs psql 6373 —
-- three different byte counts for the same row). verify_replace would
-- fail loudly (good) but cannot be made to work reliably here.
--
-- Instead we rebuild the content entirely inside Postgres:
--   keep everything up to the END of the FIRST copy
--   ("...diagnose it cold."), then append from "## The four faults".
-- This deletes exactly the duplicated second copy, whatever its exact
-- bytes. Verified on live prod (read-only): Step 0 count goes 2 -> 1.
--
-- DOWN: not supported. The removed duplicate is not reconstructible
-- byte-exactly (see above); a rollback would risk corrupting content.
-- This is a content-dedup fix, not a reversible schema change.

UPDATE lab_phases SET content =
  substring(content, 1, position('diagnose it cold' in content) + length('diagnose it cold.'))
  || substring(content, position('## The four faults' in content))
WHERE lab_id = 15 AND phase = 'attack'
  AND (length(content) - length(replace(content, '## Step 0', ''))) / length('## Step 0') > 1;
