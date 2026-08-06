-- Migration 062: verify_replace() — structural safeguard against silent replace() failures
-- Two incidents across two sessions (055/056 on 2026-07-31, 060 on 2026-08-02) where
-- hand-typed old_string didn't match DB content byte-for-byte. PostgreSQL
-- replace() returns the unchanged string on no-match, indistinguishable from
-- a successful replace to a rows_affected-blind caller.
--
-- This function asserts three invariants:
--   1. Target substring EXISTS before replace (catches hand-typed mismatch)
--   2. Target substring is GONE after replace (catches no-op)
--   3. Replacement substring IS present (catches unexpected output)
-- PLUS: idempotency — if new_str already present and old_str absent,
--   silently returns content (safe to re-run already-applied migrations).
-- Fails loudly (RAISE EXCEPTION) on genuine mismatch.
--
-- Usage:
--   UPDATE lab_phases SET content = verify_replace(
--     content,
--     'old text exactly from DB',  -- pull this from LIVE DB, never hand-type
--     'replacement text'
--   )
--   WHERE lab_id = X AND phase = 'Y';

CREATE OR REPLACE FUNCTION verify_replace(
    content text,
    old_str text,
    new_str text
) RETURNS text AS $$
BEGIN
    -- Idempotency: if new_str already present and old_str absent,
    -- this migration was already applied. Silent no-op.
    IF position(new_str in content) > 0 AND position(old_str in content) = 0 THEN
        RETURN content;
    END IF;

    -- Genuine mismatch: old_str not found AND new_str also absent.
    -- This catches the 055/056/060 class of bug — hand-typed old_string
    -- doesn't match DB content byte-for-byte (wrong quotes, wrong markup).
    IF position(old_str in content) = 0 THEN
        RAISE EXCEPTION 'verify_replace: old_str not found and new_str not present — '
            'genuine mismatch, not idempotent re-run. '
            'Check that old_str matches DB content byte-for-byte. '
            'Hint: always pull old_str from a live DB read. '
            'Old (first 80 chars): %',
            left(old_str, 80);
    END IF;

    -- Apply replace
    content := replace(content, old_str, new_str);

    -- Post-condition: target is gone
    IF position(old_str in content) > 0 THEN
        RAISE EXCEPTION 'verify_replace: old_str still present after replace(). '
            'Check for overlapping matches or multiple occurrences.';
    END IF;

    -- Post-condition: replacement is present (unless deletion)
    IF new_str <> '' AND position(new_str in content) = 0 THEN
        RAISE EXCEPTION 'verify_replace: new_str missing after replace — '
            'replace() was a no-op or produced unexpected output.';
    END IF;

    RETURN content;
END;
$$ LANGUAGE plpgsql IMMUTABLE;
