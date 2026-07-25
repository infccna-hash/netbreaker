-- 025_ios_interface_text_fixes.down.sql
--
-- Best-effort reversal. NOTE: these are substring replacements, so if
-- any of the target strings (e.g. 'et0/1') legitimately appear
-- elsewhere in the same phase's content for an unrelated interface
-- reference, this will incorrectly revert those too. Spot-check the
-- affected phases before running this in anger.

BEGIN;

UPDATE lab_phases
SET content = replace(content, 'int et0/2', 'int gi0/3')
WHERE lab_id = 28 AND phase = 'harden';

UPDATE lab_phases
SET content = replace(content, 'interface et0/1', 'interface gi0/1')
WHERE lab_id = 17 AND phase = 'harden';

UPDATE lab_phases
SET content = replace(replace(content,
      'interface range et0/0 - 2', 'interface range gi0/1 - 4'),
      'interface et0/3', 'interface range gi0/5 - 24')
WHERE lab_id = 16 AND phase = 'harden';

UPDATE lab_phases
SET content = replace(content, 'interface et0/2', 'interface gi0/24')
WHERE lab_id = 16 AND phase = 'build';

UPDATE lab_phases
SET content = replace(content, 'et0/1', 'gi0/24')
WHERE lab_id = 26 AND phase = 'attack';

UPDATE lab_phases
SET content = replace(content, 'et0/0-1', 'gi0/23-24')
WHERE lab_id = 26 AND phase = 'build';

UPDATE lab_phases
SET content = replace(content, 'et0/1', 'gi0/1')
WHERE lab_id = 25 AND phase IN ('build', 'harden');

UPDATE lab_phases
SET content = replace(content, 'et0/1-3', 'gi0/1-3')
WHERE lab_id = 24;

UPDATE lab_phases
SET content = replace(replace(content,
      'Et0/0', 'fa0/24'),
      'Et0/0', 'Fa0/24')
WHERE lab_id = 8 AND phase IN ('build', 'harden');

UPDATE lab_phases
SET content = replace(replace(replace(content,
      'Et0/1', 'Gi0/1'),
      'Et0/2', 'Gi0/2'),
      'Et0/3', 'Gi0/3')
WHERE lab_id = 3;

COMMIT;
