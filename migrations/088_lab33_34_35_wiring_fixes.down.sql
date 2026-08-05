-- Migration 088 DOWN: restore original 'Already wired' lines (reverse of UP).
-- Round-trip safe: old strings pulled from live DB capture, not retyped.

UPDATE lab_phases SET content = verify_replace(content, $md$Already wired: `R1 → SW1 → KALI` — R1's logs reach Kali through the switch.$md$, $md$Already wired: `R1 → KALI` directly, or through a switch — either works.$md$)
WHERE lab_id = 33 AND phase = 'build';

UPDATE lab_phases SET content = verify_replace(content, $md$Already wired: `R1 → SW1 → KALI` — R1 reaches Kali's TFTP/FTP server through the switch.$md$, $md$Already wired: `R1 → KALI` directly.$md$)
WHERE lab_id = 34 AND phase = 'build';

UPDATE lab_phases SET content = verify_replace(content, $md$Already wired: `PC1 → SW1 → R1`, `KALI → SW1 → R1`, and the direct `R1 ↔ R2` (this middle link is the one you'll starve).$md$, $md$Already wired: `PC1 → R1`, `KALI → R1`, `R1 ↔ R2` (this middle link is the one you'll starve).$md$)
WHERE lab_id = 35 AND phase = 'build';
