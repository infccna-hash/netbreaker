-- Rollback: revert Lab 37 (DHCP Snooping) to empty state
-- Phases are cleared; topology is removed; lab metadata is reset.
DELETE FROM lab_topologies WHERE lab_id = 37;
DELETE FROM lab_phases WHERE lab_id = 37;
UPDATE labs SET short_desc = '', topic = NULL, difficulty = NULL, book_ref = NULL WHERE id = 37;
