-- Rollback: revert Lab 05 (HSRP Takeover) to empty state
-- Phases are cleared; topology is removed; lab metadata is reset.
DELETE FROM lab_topologies WHERE lab_id = 5;
DELETE FROM lab_phases WHERE lab_id = 5;
UPDATE labs SET short_desc = '', topic = NULL, difficulty = NULL, book_ref = NULL WHERE id = 5;
