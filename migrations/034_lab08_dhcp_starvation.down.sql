-- Rollback: revert Lab 08 (DHCP Starvation) to empty state
-- Phases are cleared; topology is removed; lab metadata is reset.
DELETE FROM lab_topologies WHERE lab_id = 8;
DELETE FROM lab_phases WHERE lab_id = 8;
UPDATE labs SET short_desc = '', topic = NULL, difficulty = NULL, book_ref = NULL WHERE id = 8;
