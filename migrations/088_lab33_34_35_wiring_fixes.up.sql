-- Migration 088: fix false 'Already wired' claims in Labs 33/34/35 (design-choice text audit)
-- Written-evidence verification (2026-08-05): text asserted direct links that don't exist in Go topology.
--   Lab 33: 'R1 → KALI directly' — real path R1↔SW1↔KALI (no direct link)
--   Lab 34: 'R1 → KALI directly' — real path R1↔SW1↔KALI (no direct link)
--   Lab 35: 'PC1 → R1', 'KALI → R1' — real path via SW1 (only R1↔R2 is direct)
-- Uses verify_replace() (created in 062): fails loudly if old_str doesn't match live DB.
-- Go topology surgery (drop R2 from 34, R3+PC2 from 35) is a code change, separate commit.

UPDATE lab_phases SET content = verify_replace(content, $md$Already wired: `R1 → KALI` directly, or through a switch — either works.$md$, $md$Already wired: `R1 → SW1 → KALI` — R1's logs reach Kali through the switch.$md$)
WHERE lab_id = 33 AND phase = 'build';

UPDATE lab_phases SET content = verify_replace(content, $md$Already wired: `R1 → KALI` directly.$md$, $md$Already wired: `R1 → SW1 → KALI` — R1 reaches Kali's TFTP/FTP server through the switch.$md$)
WHERE lab_id = 34 AND phase = 'build';

UPDATE lab_phases SET content = verify_replace(content, $md$Already wired: `PC1 → R1`, `KALI → R1`, `R1 ↔ R2` (this middle link is the one you'll starve).$md$, $md$Already wired: `PC1 → SW1 → R1`, `KALI → SW1 → R1`, and the direct `R1 ↔ R2` (this middle link is the one you'll starve).$md$)
WHERE lab_id = 35 AND phase = 'build';
