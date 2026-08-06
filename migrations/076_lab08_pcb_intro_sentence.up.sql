-- 076_lab08_pcb_intro_sentence.up.sql
-- Add one sentence introducing PC-B as a second DHCP client that boots mid-attack.
-- PC-B exists in SVG and as a console prompt but lacks pedagogical introduction.

UPDATE lab_phases
SET content = regexp_replace(
  content,
  '(Stage two puts Kali''s own DHCP server on the wire with a poisoned gateway\.)',
  '\1 PC-B is a second client that boots fresh mid-attack — it has no lease yet, so it''s the perfect test subject for your rogue DHCP.'
)
WHERE lab_id = 8 AND phase = 'attack';
