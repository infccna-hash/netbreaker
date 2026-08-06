-- 077_lab1_replace_yersinia_g_with_i.up.sql
-- Fix Lab 1 DTP attack: replace yersinia -G (GUI dead-end) with -I (interactive)
-- The GUI mode (-G) doesn't launch in headless containers.
-- Interactive mode (-I) works: g → DTP, x → select trunk-enabling attack.
-- See references/yersinia-attack-numbers.md for the console-truth protocol guide.
-- DTP attack numbers are not yet console-verified — instruct via menu navigation.

-- Phase: ATTACK
UPDATE lab_phases
SET content = replace(content,
  'sudo yersinia -G',
  'sudo yersinia -I    # press g → DTP, press x → select 1) enabling trunking'
)
WHERE lab_id = 1 AND phase = 'attack';

-- Phase: HARDEN  
UPDATE lab_phases
SET content = replace(content,
  'sudo yersinia -G      # Launch attack → DTP → enabling trunking',
  'sudo yersinia -I      # press g → DTP, press x → select 1) enabling trunking'
)
WHERE lab_id = 1 AND phase = 'harden';
