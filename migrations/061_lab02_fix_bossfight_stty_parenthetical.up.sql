-- Migration 061: Fix BOSS FIGHT stale stty parenthetical (HTML <code> tags, not backticks)
-- Migration 060 attempted this fix but used markdown backtick `stty` while the
-- DB content uses HTML <code>stty</code> — replace() failed silently.
-- Console-truth: position('skip the <code>stty<' || '/code>' in content) = 3537 (still present).

UPDATE lab_phases SET content = replace(
  content,
  $mig$Launch yersinia again (skip the <code>stty</code> step if your terminal is still 30×100):$mig$,
  $mig$Launch yersinia again:$mig$
)
WHERE lab_id = 2 AND phase = 'attack';
