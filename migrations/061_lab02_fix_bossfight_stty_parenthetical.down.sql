-- Migration 061 DOWN: Restore the stty parenthetical in BOSS FIGHT

UPDATE lab_phases SET content = replace(
  content,
  $mig$Launch yersinia again:$mig$,
  $mig$Launch yersinia again (skip the <code>stty</code> step if your terminal is still 30×100):$mig$
)
WHERE lab_id = 2 AND phase = 'attack';
