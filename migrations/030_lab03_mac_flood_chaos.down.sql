-- Rollback: revert Lab 03 (MAC Flood Chaos) to empty state
-- Phases are cleared; topology is removed; lab metadata is reset.
DELETE FROM lab_topologies WHERE lab_id = 3;
DELETE FROM lab_phases WHERE lab_id = 3;
UPDATE labs SET short_desc = '', topic = NULL, difficulty = NULL, book_ref = NULL WHERE id = 3;
