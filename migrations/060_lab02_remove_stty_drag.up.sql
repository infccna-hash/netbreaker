-- Migration 060: Remove "drag window taller + stty rows" from Lab 2 (fixrows is now automatic)
-- fixrows (shipped in netbreaker-kali:2026-08-01-tmux-fixrows) sets a fixed 40×130 PTY
-- terminal to 40×130 via .bashrc TIOCSWINSZ ioctl — the student no longer needs
-- to drag the browser window or run stty manually. This migration cleans up the
-- outdated instructions.
--
-- Console-truth (session 2026-08-01):
--   - uBridge raw TCP↔PTY pipe does NOT forward NAWS (browser resize) to the PTY
--   - TIOCSWINSZ ioctl on fd 0 works inside the container
--   - fixrows python script in .bashrc auto-runs on every interactive bash shell
--   - Verified: yersinia -I works (bare + tmux), synchronized tcpdump capture works

-- ═══════════════════ ATTACK (Step 2) ═══════════════════
-- Remove the "drag window taller / stty rows" preamble — fixrows handles it
UPDATE lab_phases SET content = replace(
  content,
  $mig$Yersinia's interactive mode needs at least 25 rows × 80 columns. If your terminal is too small, drag the browser window taller, then:

```
stty rows 30 columns 100
```

Launch yersinia (no `sudo` — you're already root in KALI):$mig$,
  $mig$Launch yersinia (no `sudo` — you're already root in KALI):$mig$
)
WHERE lab_id = 2 AND phase = 'attack';

-- ═══════════════════ BOSS FIGHT ═══════════════════
-- Remove the "(skip the stty step…)" parenthetical — fixrows handles it
UPDATE lab_phases SET content = replace(
  content,
  $mig$Launch yersinia again (skip the `stty` step if your terminal is still 30×100):$mig$,
  $mig$Launch yersinia again:$mig$
)
WHERE lab_id = 2 AND phase = 'attack';
