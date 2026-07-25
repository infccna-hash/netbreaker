-- 027_interface_names_deferred_labs.up.sql
-- Resolves 4 of the 5 labs deferred by 026 (13,15,17,19), all Link-driven.
-- Lab 19 gi0/2 -> Fa2/0 (c3725 module port, per topology link R1 Fa2/0<->R2), NOT Fa0/2.
-- Lab 19/harden reuses gi0/1 for R1 (prose, ->Fa0/1) and SW1 (ip source guard cmd, ->Et0/1);
--   the switch command is disambiguated by a lookahead and rewritten first.
-- Lab 20 remains deferred: it references phantom R2/PC2 nodes absent from its topology.
BEGIN;

-- Lab 13
UPDATE lab_phases SET content = replace(content, 'interface gi0/0', 'interface Fa0/0') WHERE lab_id=13 AND phase='build';
UPDATE lab_phases SET content = replace(content, 'interface gi0/1', 'interface Et0/3') WHERE lab_id=13 AND phase='harden';

-- Lab 15
UPDATE lab_phases SET content = replace(content, 'gi0/24', 'Et0/3') WHERE lab_id=15;
UPDATE lab_phases SET content = replace(content, 'gi0/2', 'Et0/2') WHERE lab_id=15;
UPDATE lab_phases SET content = replace(content, 'gi0/1', 'Et0/0') WHERE lab_id=15;
UPDATE lab_phases SET content = replace(content, 'gi0/X', 'Et0/X') WHERE lab_id=15;

-- Lab 17
UPDATE lab_phases SET content = replace(content, 'interface gi0/0', 'interface Fa0/0') WHERE lab_id=17 AND phase='harden';

-- Lab 19
UPDATE lab_phases SET content = regexp_replace(content, 'interface gi0/2(?=\s+ip address 10\.0\.0\.1)', 'interface Fa2/0', 'g') WHERE lab_id=19 AND phase='build';
UPDATE lab_phases SET content = regexp_replace(content, 'interface gi0/1(?=\s+ip address 172)', 'interface Fa0/1', 'g') WHERE lab_id=19 AND phase='build';
UPDATE lab_phases SET content = replace(content, 'interface gi0/0', 'interface Fa0/0') WHERE lab_id=19 AND phase='build';
UPDATE lab_phases SET content = regexp_replace(content, 'interface gi0/1(?=\s+ip verify source)', 'interface Et0/1', 'g') WHERE lab_id=19 AND phase='harden';
UPDATE lab_phases SET content = replace(content, 'gi0/0', 'Fa0/0') WHERE lab_id=19 AND phase='harden';
UPDATE lab_phases SET content = replace(content, 'gi0/1', 'Fa0/1') WHERE lab_id=19 AND phase='harden';

COMMIT;