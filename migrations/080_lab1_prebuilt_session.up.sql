-- 080_lab1_prebuilt_session.up.sql
-- Fix Lab 1: replace "Drag these into a fresh GNS3 project" (manual GNS3
-- workflow) with pre-built session description. Keep the device table as
-- useful topology reference; change only the command-implying verbs.

-- Replace 1: header + drag instruction
UPDATE lab_phases
SET content = replace(content,
  E'## Your arsenal (GNS3)\n\nDrag these into a fresh GNS3 project:',
  E'## Your topology\n\nYour session opens pre-built with this topology:')
WHERE lab_id = 1 AND phase = 'build';

-- Replace 2: "Suggested image" column → "Platform" (student doesn't pick images)
UPDATE lab_phases
SET content = replace(content,
  '| Device | Role | Suggested image |',
  '| Device | Role | Platform |')
WHERE lab_id = 1 AND phase = 'build';

-- Replace 3: "Wire it like the topology above" (second imperative, after the table)
UPDATE lab_phases
SET content = replace(content,
  'Wire it like the topology above:',
  'Already wired as shown above:')
WHERE lab_id = 1 AND phase = 'build';
