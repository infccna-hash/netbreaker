-- 081_prebuilt_session_batch.up.sql
-- Batch fix for Labs 2,3,33,34,35,36,39: replace imperative "Your arsenal
-- (GNS3)" / "Wire it" / "Cable it" with pre-built session language.
-- Device tables and wiring info kept as useful topology reference.

-- ═══ Lab 2 ═══
UPDATE lab_phases SET content = replace(content,
  '## Your arsenal (GNS3)',
  '## Your topology')
WHERE lab_id = 2 AND phase = 'build';

UPDATE lab_phases SET content = replace(content,
  'Wire it: `SW1↔SW2`, `SW2↔SW3`, `SW3↔SW1` — a full triangle — plus `PC1→SW1 Et0/1` and `KALI→SW3 Et0/2`.',
  'Already wired: `SW1↔SW2`, `SW2↔SW3`, `SW3↔SW1` — a full triangle — plus `PC1→SW1 Et0/1` and `KALI→SW3 Et0/2`.')
WHERE lab_id = 2 AND phase = 'build';

-- ═══ Lab 3 ═══
UPDATE lab_phases SET content = replace(content,
  'Cable it: PC1→Et0/1, PC2→Et0/2, KALI→Et0/3.',
  'Already wired: PC1→Et0/1, PC2→Et0/2, KALI→Et0/3.')
WHERE lab_id = 3 AND phase = 'build';

-- ═══ Lab 33 ═══
UPDATE lab_phases SET content = replace(content,
  '## Your arsenal (GNS3)',
  '## Your topology')
WHERE lab_id = 33 AND phase = 'build';

UPDATE lab_phases SET content = replace(content,
  'Wire `R1 → KALI` directly, or through a switch — either works.',
  'Already wired: `R1 → KALI` directly, or through a switch — either works.')
WHERE lab_id = 33 AND phase = 'build';

-- ═══ Lab 34 ═══
UPDATE lab_phases SET content = replace(content,
  '## Your arsenal (GNS3)',
  '## Your topology')
WHERE lab_id = 34 AND phase = 'build';

UPDATE lab_phases SET content = replace(content,
  'Wire `R1 → KALI` directly.',
  'Already wired: `R1 → KALI` directly.')
WHERE lab_id = 34 AND phase = 'build';

-- ═══ Lab 35 ═══
UPDATE lab_phases SET content = replace(content,
  '## Your arsenal (GNS3)',
  '## Your topology')
WHERE lab_id = 35 AND phase = 'build';

UPDATE lab_phases SET content = replace(content,
  'Wire `PC1 → R1`, `KALI → R1`, `R1 ↔ R2` (this middle link is the one you''ll starve).',
  'Already wired: `PC1 → R1`, `KALI → R1`, `R1 ↔ R2` (this middle link is the one you''ll starve).')
WHERE lab_id = 35 AND phase = 'build';

-- ═══ Lab 36 ═══
UPDATE lab_phases SET content = replace(content,
  '## Your arsenal (GNS3)',
  '## Your topology')
WHERE lab_id = 36 AND phase = 'build';

UPDATE lab_phases SET content = replace(content,
  'Wire `PC1 → SW1 Et0/0`. Leave `KALI` unplugged for now — you''ll connect it during Phase 2.',
  'Already wired: `PC1 → SW1 Et0/0`. Leave `KALI` unplugged for now — you''ll connect it during Phase 2.')
WHERE lab_id = 36 AND phase = 'build';

-- ═══ Lab 39 ═══
UPDATE lab_phases SET content = replace(content,
  '## Your arsenal (GNS3)',
  '## Your topology')
WHERE lab_id = 39 AND phase = 'build';

UPDATE lab_phases SET content = replace(content,
  'Wire `PC1 → SW1`, `PC2 → SW1`, `R1 → SW1` — one flat star, SW1 in the middle of everything.',
  'Already wired: `PC1 → SW1`, `PC2 → SW1`, `R1 → SW1` — one flat star, SW1 in the middle of everything.')
WHERE lab_id = 39 AND phase = 'build';

UPDATE lab_phases SET content = replace(content,
  '## Step 1 — Wire the flat topology',
  '## Step 1 — The flat topology')
WHERE lab_id = 39 AND phase = 'build';

-- Lab 39 second Wire (harden phase wiring reference)
UPDATE lab_phases SET content = replace(content,
  'Wire `PC1 → SW1`, `PC2 → SW1`, `SW1 → SW2` (two links, for redundancy), `SW2 → R1`.',
  'Already wired: `PC1 → SW1`, `PC2 → SW1`, `SW1 → SW2` (two links, for redundancy), `SW2 → R1`.')
WHERE lab_id = 39 AND phase = 'harden';
