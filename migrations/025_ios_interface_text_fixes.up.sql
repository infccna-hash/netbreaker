-- 025_ios_interface_text_fixes.up.sql

BEGIN;

-- Lab 03: SW1 IOU (PC1/PC2/KALI)
UPDATE lab_phases
SET content = replace(replace(replace(replace(content,
      'interface range gi0/1 - 3', 'interface range et0/1-3'),
      'Gi0/1', 'Et0/1'),
      'Gi0/2', 'Et0/2'),
      'Gi0/3', 'Et0/3')
WHERE lab_id = 3;
UPDATE lab_phases
SET content = replace(content, 'show interfaces gi0/3', 'show interfaces et0/3')
WHERE lab_id = 3 AND phase = 'harden';
UPDATE lab_phases
SET content = replace(content, 'interface gi0/3', 'interface et0/3')
WHERE lab_id = 3 AND phase = 'harden';

-- Lab 08: SW1 IOU (trunk Et0/0, PC1 Et0/1, KALI Et0/3)
UPDATE lab_phases SET content = replace(content, 'Fa0/24', 'Et0/0')
WHERE lab_id = 8 AND phase IN ('build', 'harden');
UPDATE lab_phases SET content = replace(content, 'fa0/24', 'Et0/0')
WHERE lab_id = 8 AND phase IN ('build', 'harden');
UPDATE lab_phases SET content = replace(content, 'Gi0/24', 'Et0/0')
WHERE lab_id = 8 AND phase IN ('build', 'harden');
UPDATE lab_phases SET content = replace(content, 'gi0/24', 'Et0/0')
WHERE lab_id = 8 AND phase IN ('build', 'harden');
UPDATE lab_phases SET content = replace(content, 'Gi0/1', 'Et0/1')
WHERE lab_id = 8 AND phase IN ('build', 'harden');
UPDATE lab_phases SET content = replace(content, 'gi0/1', 'et0/1')
WHERE lab_id = 8 AND phase = 'harden';
UPDATE lab_phases SET content = replace(content, 'Gi0/3', 'Et0/3')
WHERE lab_id = 8 AND phase = 'harden';
UPDATE lab_phases SET content = replace(content, 'gi0/3', 'et0/3')
WHERE lab_id = 8 AND phase = 'harden';

-- Lab 16 build
UPDATE lab_phases SET content = replace(content, 'show interfaces gi0/24', 'show interfaces et0/2')
WHERE lab_id = 16 AND phase = 'build';
UPDATE lab_phases SET content = replace(content, 'interface gi0/24', 'interface et0/2')
WHERE lab_id = 16 AND phase = 'build';

-- Lab 16 harden
UPDATE lab_phases SET content = replace(content, 'interface range gi0/5 - 24', 'interface et0/3')
WHERE lab_id = 16 AND phase = 'harden';
UPDATE lab_phases SET content = replace(content, 'interface range gi0/1 - 4', 'interface range et0/0 - 2')
WHERE lab_id = 16 AND phase = 'harden';

-- Lab 17 harden
UPDATE lab_phases SET content = replace(content, 'interface gi0/1', 'interface et0/1')
WHERE lab_id = 17 AND phase = 'harden';

-- Lab 24
UPDATE lab_phases SET content = replace(content, 'gi0/1-3', 'et0/1-3')
WHERE lab_id = 24;

-- Lab 25
UPDATE lab_phases SET content = replace(content, 'gi0/1', 'et0/1')
WHERE lab_id = 25 AND phase IN ('build', 'harden');

-- Lab 26 build
UPDATE lab_phases SET content = replace(content, 'gi0/23-24', 'et0/0-1')
WHERE lab_id = 26 AND phase = 'build';
UPDATE lab_phases SET content = replace(content, E'Gi0/23\u201324', 'et0/0-1')
WHERE lab_id = 26 AND phase = 'build';

-- Lab 26 attack
UPDATE lab_phases SET content = replace(content, 'Gi0/24', 'et0/1')
WHERE lab_id = 26 AND phase = 'attack';
UPDATE lab_phases SET content = replace(content, 'Gi0/23', 'et0/0')
WHERE lab_id = 26 AND phase = 'attack';
UPDATE lab_phases SET content = replace(content, 'gi0/24', 'et0/1')
WHERE lab_id = 26 AND phase = 'attack';

-- Lab 28 harden
UPDATE lab_phases SET content = replace(content, 'int gi0/3', 'int et0/2')
WHERE lab_id = 28 AND phase = 'harden';

COMMIT;
