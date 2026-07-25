-- 026_interface_name_platform_fixes.down.sql
-- BEST-EFFORT rollback. Only the pure-router labs (uniform Gi<->Fa) are cleanly invertible and
-- are reversed below. The switch/mixed labs (1,2,7,8,11,12,14,36) are NOT auto-reversed: their
-- forward transform is many-to-one (multiple Gi/Fa tokens collapsed to Et per real topology port),
-- so a substring inverse would corrupt content. To fully roll those back, re-seed lab_phases from
-- the migration 001-025 baseline. This matches the 025 down-migration's stated limitation.
BEGIN;

-- Lab 4 (router, invertible)
UPDATE lab_phases SET content = replace(content, 'Fa0/0', 'Gi0/0') WHERE lab_id=4;
UPDATE lab_phases SET content = replace(content, 'Fa0/1', 'Gi0/1') WHERE lab_id=4;
UPDATE lab_phases SET content = replace(content, 'Fa0/2', 'Gi0/2') WHERE lab_id=4;

-- Lab 5 (router, invertible)
UPDATE lab_phases SET content = replace(content, 'Fa0/0', 'Gi0/0') WHERE lab_id=5;
UPDATE lab_phases SET content = replace(content, 'Fa0/1', 'Gi0/1') WHERE lab_id=5;
UPDATE lab_phases SET content = replace(content, 'Fa0/2', 'Gi0/2') WHERE lab_id=5;

-- Lab 6 (router, invertible)
UPDATE lab_phases SET content = replace(content, 'Fa0/0', 'Gi0/0') WHERE lab_id=6;
UPDATE lab_phases SET content = replace(content, 'Fa0/1', 'Gi0/1') WHERE lab_id=6;
UPDATE lab_phases SET content = replace(content, 'Fa0/2', 'Gi0/2') WHERE lab_id=6;

-- Lab 9 (router, invertible)
UPDATE lab_phases SET content = replace(content, 'Fa0/0', 'Gi0/0') WHERE lab_id=9;
UPDATE lab_phases SET content = replace(content, 'Fa0/1', 'Gi0/1') WHERE lab_id=9;
UPDATE lab_phases SET content = replace(content, 'Fa0/2', 'Gi0/2') WHERE lab_id=9;

-- Lab 10 (router, invertible)
UPDATE lab_phases SET content = replace(content, 'Fa0/0', 'Gi0/0') WHERE lab_id=10;
UPDATE lab_phases SET content = replace(content, 'Fa0/1', 'Gi0/1') WHERE lab_id=10;
UPDATE lab_phases SET content = replace(content, 'Fa0/2', 'Gi0/2') WHERE lab_id=10;

-- Lab 21 (router, invertible)
UPDATE lab_phases SET content = replace(content, 'Fa0/0', 'Gi0/0') WHERE lab_id=21;
UPDATE lab_phases SET content = replace(content, 'Fa0/1', 'Gi0/1') WHERE lab_id=21;
UPDATE lab_phases SET content = replace(content, 'Fa0/2', 'Gi0/2') WHERE lab_id=21;

-- Lab 22 (router, invertible)
UPDATE lab_phases SET content = replace(content, 'Fa0/0', 'Gi0/0') WHERE lab_id=22;
UPDATE lab_phases SET content = replace(content, 'Fa0/1', 'Gi0/1') WHERE lab_id=22;
UPDATE lab_phases SET content = replace(content, 'Fa0/2', 'Gi0/2') WHERE lab_id=22;

-- Lab 23 (router, invertible)
UPDATE lab_phases SET content = replace(content, 'Fa0/0', 'Gi0/0') WHERE lab_id=23;
UPDATE lab_phases SET content = replace(content, 'Fa0/1', 'Gi0/1') WHERE lab_id=23;
UPDATE lab_phases SET content = replace(content, 'Fa0/2', 'Gi0/2') WHERE lab_id=23;

-- Lab 27 (router, invertible)
UPDATE lab_phases SET content = replace(content, 'Fa0/0', 'Gi0/0') WHERE lab_id=27;
UPDATE lab_phases SET content = replace(content, 'Fa0/1', 'Gi0/1') WHERE lab_id=27;
UPDATE lab_phases SET content = replace(content, 'Fa0/2', 'Gi0/2') WHERE lab_id=27;

-- Lab 28 (router, invertible)
UPDATE lab_phases SET content = replace(content, 'Fa0/0', 'Gi0/0') WHERE lab_id=28;
UPDATE lab_phases SET content = replace(content, 'Fa0/1', 'Gi0/1') WHERE lab_id=28;
UPDATE lab_phases SET content = replace(content, 'Fa0/2', 'Gi0/2') WHERE lab_id=28;

-- Lab 29 (router, invertible)
UPDATE lab_phases SET content = replace(content, 'Fa0/0', 'Gi0/0') WHERE lab_id=29;
UPDATE lab_phases SET content = replace(content, 'Fa0/1', 'Gi0/1') WHERE lab_id=29;
UPDATE lab_phases SET content = replace(content, 'Fa0/2', 'Gi0/2') WHERE lab_id=29;

-- Lab 30 (router, invertible)
UPDATE lab_phases SET content = replace(content, 'Fa0/0', 'Gi0/0') WHERE lab_id=30;
UPDATE lab_phases SET content = replace(content, 'Fa0/1', 'Gi0/1') WHERE lab_id=30;
UPDATE lab_phases SET content = replace(content, 'Fa0/2', 'Gi0/2') WHERE lab_id=30;

COMMIT;