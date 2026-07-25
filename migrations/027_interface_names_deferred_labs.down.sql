-- 027_interface_names_deferred_labs.down.sql
-- BEST-EFFORT rollback (see 026 down for rationale). Only cleanly-invertible
-- router-interface swaps are reversed. Switch mappings (labs 13 harden, 15, and
-- lab 19 harden Et0/1) are many-to-one and are NOT auto-reversed; re-seed from
-- the 001-025 baseline for a full rollback.
BEGIN;
-- Lab 17 (pure router)
UPDATE lab_phases SET content = replace(content, 'interface Fa0/0', 'interface gi0/0') WHERE lab_id=17 AND phase='harden';
-- Lab 19 build (router)
UPDATE lab_phases SET content = replace(content, 'interface Fa2/0', 'interface gi0/2') WHERE lab_id=19 AND phase='build';
UPDATE lab_phases SET content = replace(content, 'interface Fa0/1', 'interface gi0/1') WHERE lab_id=19 AND phase='build';
UPDATE lab_phases SET content = replace(content, 'interface Fa0/0', 'interface gi0/0') WHERE lab_id=19 AND phase='build';
-- Lab 13 build (router)
UPDATE lab_phases SET content = replace(content, 'interface Fa0/0', 'interface gi0/0') WHERE lab_id=13 AND phase='build';
COMMIT;
