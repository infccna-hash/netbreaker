-- Revert migration 010: restore the placeholder/original state for the labs
-- this migration touched. Safe no-op if 007/008/009 already define baseline
-- content (their own down-migrations handle labs 1, 2, and the 15-45 shells).
-- This down-migration exists for symmetry; a full revert should also run
-- 007/008/009's down-migrations in reverse order if a complete rollback is needed.
SELECT 1; -- intentionally minimal — see comment above
