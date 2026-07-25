-- 026_interface_name_platform_fixes.up.sql
-- c3725 routers: Gi0/N -> Fa0/N.  IOU switches: Fa0//Gi0/ -> Et0/M (port from topology Links).
-- Mixed-device labs (8,14) use ordered phrase-then-token replacement so router lines -> Fa, switch lines -> Et.
-- DEFERRED (need GNS3-in-the-loop review): labs [13, 15, 17, 19, 20] — see audit notes.
BEGIN;

-- Lab 1
UPDATE lab_phases SET content = replace(content, 'PC1→SW1 Fa0/1', 'PC1→SW1 Et0/1') WHERE lab_id=1 AND phase='build';
UPDATE lab_phases SET content = replace(content, 'KALI→SW1 Fa0/3', 'KALI→SW1 Et0/3') WHERE lab_id=1 AND phase='build';
UPDATE lab_phases SET content = replace(content, '`SW1↔SW2` on `Fa0/2`', '`SW1↔SW2` on `Et0/2`') WHERE lab_id=1 AND phase='build';
UPDATE lab_phases SET content = replace(content, '`R1→SW1` on `Fa0/24`', '`R1→SW1` on `Et0/0`') WHERE lab_id=1 AND phase='build';
UPDATE lab_phases SET content = replace(content, 'SRV1→SW2 Fa0/1', 'SRV1→SW2 Et0/2') WHERE lab_id=1 AND phase='build';
UPDATE lab_phases SET content = replace(content, 'only Fa0/2 (real trunk) — NOT Fa0/3', 'only Et0/2 (real trunk) — NOT Et0/3') WHERE lab_id=1 AND phase='harden';
UPDATE lab_phases SET content = replace(content, 'show interfaces fa0/3 switchport', 'show interfaces Et0/3 switchport') WHERE lab_id=1 AND phase='harden';

-- Lab 2
UPDATE lab_phases SET content = replace(content, 'PC1→SW1 Fa0/1', 'PC1→SW1 Et0/1') WHERE lab_id=2 AND phase='build';
UPDATE lab_phases SET content = replace(content, 'KALI→SW3 Fa0/2', 'KALI→SW3 Et0/2') WHERE lab_id=2 AND phase='build';

-- Lab 4
UPDATE lab_phases SET content = replace(content, 'Gi0/0', 'Fa0/0') WHERE lab_id=4;
UPDATE lab_phases SET content = replace(content, 'gi0/0', 'Fa0/0') WHERE lab_id=4;
UPDATE lab_phases SET content = replace(content, 'Gi0/1', 'Fa0/1') WHERE lab_id=4;
UPDATE lab_phases SET content = replace(content, 'gi0/1', 'Fa0/1') WHERE lab_id=4;
UPDATE lab_phases SET content = replace(content, 'Gi0/2', 'Fa0/2') WHERE lab_id=4;
UPDATE lab_phases SET content = replace(content, 'gi0/2', 'Fa0/2') WHERE lab_id=4;

-- Lab 5
UPDATE lab_phases SET content = replace(content, 'Gi0/0', 'Fa0/0') WHERE lab_id=5;
UPDATE lab_phases SET content = replace(content, 'gi0/0', 'Fa0/0') WHERE lab_id=5;
UPDATE lab_phases SET content = replace(content, 'Gi0/1', 'Fa0/1') WHERE lab_id=5;
UPDATE lab_phases SET content = replace(content, 'gi0/1', 'Fa0/1') WHERE lab_id=5;
UPDATE lab_phases SET content = replace(content, 'Gi0/2', 'Fa0/2') WHERE lab_id=5;
UPDATE lab_phases SET content = replace(content, 'gi0/2', 'Fa0/2') WHERE lab_id=5;

-- Lab 6
UPDATE lab_phases SET content = replace(content, 'Gi0/0', 'Fa0/0') WHERE lab_id=6;
UPDATE lab_phases SET content = replace(content, 'gi0/0', 'Fa0/0') WHERE lab_id=6;
UPDATE lab_phases SET content = replace(content, 'Gi0/1', 'Fa0/1') WHERE lab_id=6;
UPDATE lab_phases SET content = replace(content, 'gi0/1', 'Fa0/1') WHERE lab_id=6;
UPDATE lab_phases SET content = replace(content, 'Gi0/2', 'Fa0/2') WHERE lab_id=6;
UPDATE lab_phases SET content = replace(content, 'gi0/2', 'Fa0/2') WHERE lab_id=6;

-- Lab 7
UPDATE lab_phases SET content = replace(content, 'gi0/1', 'Et0/2') WHERE lab_id=7;

-- Lab 8
UPDATE lab_phases SET content = regexp_replace(content, 'interface gi0/0(?=\s+ip address)', 'interface Fa0/0', 'g') WHERE lab_id=8 AND phase='build';
UPDATE lab_phases SET content = replace(content, 'KALI→SW1 Gi0/3', 'KALI→SW1 Et0/3') WHERE lab_id=8;
UPDATE lab_phases SET content = regexp_replace(content, 'interface gi0/0(?=\s+switchport)', 'interface Et0/0', 'g') WHERE lab_id=8;
UPDATE lab_phases SET content = replace(content, 'interface gi0/1', 'interface Et0/1') WHERE lab_id=8;
UPDATE lab_phases SET content = replace(content, 'interface gi0/3', 'interface Et0/3') WHERE lab_id=8;

-- Lab 9
UPDATE lab_phases SET content = replace(content, 'Gi0/0', 'Fa0/0') WHERE lab_id=9;
UPDATE lab_phases SET content = replace(content, 'gi0/0', 'Fa0/0') WHERE lab_id=9;
UPDATE lab_phases SET content = replace(content, 'Gi0/1', 'Fa0/1') WHERE lab_id=9;
UPDATE lab_phases SET content = replace(content, 'gi0/1', 'Fa0/1') WHERE lab_id=9;
UPDATE lab_phases SET content = replace(content, 'Gi0/2', 'Fa0/2') WHERE lab_id=9;
UPDATE lab_phases SET content = replace(content, 'gi0/2', 'Fa0/2') WHERE lab_id=9;

-- Lab 10
UPDATE lab_phases SET content = replace(content, 'Gi0/0', 'Fa0/0') WHERE lab_id=10;
UPDATE lab_phases SET content = replace(content, 'gi0/0', 'Fa0/0') WHERE lab_id=10;
UPDATE lab_phases SET content = replace(content, 'Gi0/1', 'Fa0/1') WHERE lab_id=10;
UPDATE lab_phases SET content = replace(content, 'gi0/1', 'Fa0/1') WHERE lab_id=10;
UPDATE lab_phases SET content = replace(content, 'Gi0/2', 'Fa0/2') WHERE lab_id=10;
UPDATE lab_phases SET content = replace(content, 'gi0/2', 'Fa0/2') WHERE lab_id=10;

-- Lab 11
UPDATE lab_phases SET content = replace(content, 'R1 Gi0/0 → SW1 Gi0/1', 'R1 Fa0/0 → SW1 Et0/1') WHERE lab_id=11 AND phase='build';
UPDATE lab_phases SET content = replace(content, 'KALI → SW1 Gi0/2', 'KALI → SW1 Et0/2') WHERE lab_id=11 AND phase='build';

-- Lab 12
UPDATE lab_phases SET content = replace(content, 'Gi0/1', 'Et0/1') WHERE lab_id=12;
UPDATE lab_phases SET content = replace(content, 'gi0/1', 'Et0/1') WHERE lab_id=12;

-- Lab 14
UPDATE lab_phases SET content = regexp_replace(content, 'interface gi0/0(?=\s+ipv6 address)', 'interface Fa0/0', 'g') WHERE lab_id=14 AND phase='build';
UPDATE lab_phases SET content = replace(content, 'Gi0/0 (connecting to R1)', 'Et0/0 (connecting to R1)') WHERE lab_id=14;
UPDATE lab_phases SET content = replace(content, 'interface gi0/0', 'interface Et0/0') WHERE lab_id=14;
UPDATE lab_phases SET content = replace(content, 'Gi0/1 is the port Kali', 'Et0/3 is the port Kali') WHERE lab_id=14;
UPDATE lab_phases SET content = replace(content, 'gi0/1', 'Et0/3') WHERE lab_id=14;

-- Lab 21
UPDATE lab_phases SET content = replace(content, 'Gi0/0', 'Fa0/0') WHERE lab_id=21;
UPDATE lab_phases SET content = replace(content, 'gi0/0', 'Fa0/0') WHERE lab_id=21;
UPDATE lab_phases SET content = replace(content, 'Gi0/1', 'Fa0/1') WHERE lab_id=21;
UPDATE lab_phases SET content = replace(content, 'gi0/1', 'Fa0/1') WHERE lab_id=21;
UPDATE lab_phases SET content = replace(content, 'Gi0/2', 'Fa0/2') WHERE lab_id=21;
UPDATE lab_phases SET content = replace(content, 'gi0/2', 'Fa0/2') WHERE lab_id=21;

-- Lab 22
UPDATE lab_phases SET content = replace(content, 'Gi0/0', 'Fa0/0') WHERE lab_id=22;
UPDATE lab_phases SET content = replace(content, 'gi0/0', 'Fa0/0') WHERE lab_id=22;
UPDATE lab_phases SET content = replace(content, 'Gi0/1', 'Fa0/1') WHERE lab_id=22;
UPDATE lab_phases SET content = replace(content, 'gi0/1', 'Fa0/1') WHERE lab_id=22;
UPDATE lab_phases SET content = replace(content, 'Gi0/2', 'Fa0/2') WHERE lab_id=22;
UPDATE lab_phases SET content = replace(content, 'gi0/2', 'Fa0/2') WHERE lab_id=22;

-- Lab 23
UPDATE lab_phases SET content = replace(content, 'Gi0/0', 'Fa0/0') WHERE lab_id=23;
UPDATE lab_phases SET content = replace(content, 'gi0/0', 'Fa0/0') WHERE lab_id=23;
UPDATE lab_phases SET content = replace(content, 'Gi0/1', 'Fa0/1') WHERE lab_id=23;
UPDATE lab_phases SET content = replace(content, 'gi0/1', 'Fa0/1') WHERE lab_id=23;
UPDATE lab_phases SET content = replace(content, 'Gi0/2', 'Fa0/2') WHERE lab_id=23;
UPDATE lab_phases SET content = replace(content, 'gi0/2', 'Fa0/2') WHERE lab_id=23;

-- Lab 27
UPDATE lab_phases SET content = replace(content, 'Gi0/0', 'Fa0/0') WHERE lab_id=27;
UPDATE lab_phases SET content = replace(content, 'gi0/0', 'Fa0/0') WHERE lab_id=27;
UPDATE lab_phases SET content = replace(content, 'Gi0/1', 'Fa0/1') WHERE lab_id=27;
UPDATE lab_phases SET content = replace(content, 'gi0/1', 'Fa0/1') WHERE lab_id=27;
UPDATE lab_phases SET content = replace(content, 'Gi0/2', 'Fa0/2') WHERE lab_id=27;
UPDATE lab_phases SET content = replace(content, 'gi0/2', 'Fa0/2') WHERE lab_id=27;

-- Lab 28
UPDATE lab_phases SET content = replace(content, 'Gi0/0', 'Fa0/0') WHERE lab_id=28;
UPDATE lab_phases SET content = replace(content, 'gi0/0', 'Fa0/0') WHERE lab_id=28;
UPDATE lab_phases SET content = replace(content, 'Gi0/1', 'Fa0/1') WHERE lab_id=28;
UPDATE lab_phases SET content = replace(content, 'gi0/1', 'Fa0/1') WHERE lab_id=28;
UPDATE lab_phases SET content = replace(content, 'Gi0/2', 'Fa0/2') WHERE lab_id=28;
UPDATE lab_phases SET content = replace(content, 'gi0/2', 'Fa0/2') WHERE lab_id=28;

-- Lab 29
UPDATE lab_phases SET content = replace(content, 'Gi0/0', 'Fa0/0') WHERE lab_id=29;
UPDATE lab_phases SET content = replace(content, 'gi0/0', 'Fa0/0') WHERE lab_id=29;
UPDATE lab_phases SET content = replace(content, 'Gi0/1', 'Fa0/1') WHERE lab_id=29;
UPDATE lab_phases SET content = replace(content, 'gi0/1', 'Fa0/1') WHERE lab_id=29;
UPDATE lab_phases SET content = replace(content, 'Gi0/2', 'Fa0/2') WHERE lab_id=29;
UPDATE lab_phases SET content = replace(content, 'gi0/2', 'Fa0/2') WHERE lab_id=29;

-- Lab 30
UPDATE lab_phases SET content = replace(content, 'Gi0/0', 'Fa0/0') WHERE lab_id=30;
UPDATE lab_phases SET content = replace(content, 'gi0/0', 'Fa0/0') WHERE lab_id=30;
UPDATE lab_phases SET content = replace(content, 'Gi0/1', 'Fa0/1') WHERE lab_id=30;
UPDATE lab_phases SET content = replace(content, 'gi0/1', 'Fa0/1') WHERE lab_id=30;
UPDATE lab_phases SET content = replace(content, 'Gi0/2', 'Fa0/2') WHERE lab_id=30;
UPDATE lab_phases SET content = replace(content, 'gi0/2', 'Fa0/2') WHERE lab_id=30;

-- Lab 36
UPDATE lab_phases SET content = replace(content, 'Fa0/1', 'Et0/0') WHERE lab_id=36;

COMMIT;