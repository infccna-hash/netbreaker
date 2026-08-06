-- Revert 060: Restore "drag window taller / stty rows" text (pre-fixrows era)
-- Only needed if fixrows is NOT present in the KALI image

-- ═══════════════════ ATTACK ═══════════════════
UPDATE lab_phases SET content = replace(
  content,
  $mig$Launch yersinia (no `sudo` — you're already root in KALI):$mig$,
  $mig$Yersinia's interactive mode needs at least 25 rows × 80 columns. If your terminal is too small, drag the browser window taller, then:

```
stty rows 30 columns 100
```

Launch yersinia (no `sudo` — you're already root in KALI):$mig$
)
WHERE lab_id = 2 AND phase = 'attack';

-- ═══════════════════ BOSS FIGHT ═══════════════════
UPDATE lab_phases SET content = replace(
  content,
  $mig$Launch yersinia again:$mig$,
  $mig$Launch yersinia again (skip the `stty` step if your terminal is still 30×100):$mig$
)
WHERE lab_id = 2 AND phase = 'attack';
