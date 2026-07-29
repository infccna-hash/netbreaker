-- 049_lab1_content_fixes.down: Undo all interface name/number fixes.
BEGIN;

-- BUILD
UPDATE lab_phases SET content = replace(content, 'interface Et0/1'||E'\n'||' description PC1-USER', 'interface FastEthernet0/1'||E'\n'||' description PC1-USER') WHERE lab_id = 1 AND phase = 'build';
UPDATE lab_phases SET content = replace(content, 'interface Et0/2'||E'\n'||' description SRV1-CROWN-JEWELS', 'interface FastEthernet0/1'||E'\n'||' description SRV1-CROWN-JEWELS') WHERE lab_id = 1 AND phase = 'build';
UPDATE lab_phases SET content = replace(content, '! On SW1'||E'\n'||'interface Et0/2'||E'\n'||' description TRUNK-TO-SW2', '! On SW1'||E'\n'||'interface FastEthernet0/2'||E'\n'||' description TRUNK-TO-SW2') WHERE lab_id = 1 AND phase = 'build';
UPDATE lab_phases SET content = replace(content, 'interface Et0/0'||E'\n'||' description TRUNK-TO-R1', 'interface FastEthernet0/24'||E'\n'||' description TRUNK-TO-R1') WHERE lab_id = 1 AND phase = 'build';
UPDATE lab_phases SET content = replace(content, '! On SW2'||E'\n'||'interface Et0/1'||E'\n'||' description TRUNK-TO-SW1', '! On SW2'||E'\n'||'interface FastEthernet0/2'||E'\n'||' description TRUNK-TO-SW1') WHERE lab_id = 1 AND phase = 'build';
UPDATE lab_phases SET content = replace(content, 'interface FastEthernet0/0'||E'\n'||' no shutdown', 'interface GigabitEthernet0/0'||E'\n'||' no shutdown') WHERE lab_id = 1 AND phase = 'build';
UPDATE lab_phases SET content = replace(content, 'interface FastEthernet0/0.10'||E'\n'||' encapsulation dot1Q 10', 'interface GigabitEthernet0/0.10'||E'\n'||' encapsulation dot1Q 10') WHERE lab_id = 1 AND phase = 'build';
UPDATE lab_phases SET content = replace(content, 'interface FastEthernet0/0.20'||E'\n'||' encapsulation dot1Q 20', 'interface GigabitEthernet0/0.20'||E'\n'||' encapsulation dot1Q 20') WHERE lab_id = 1 AND phase = 'build';
UPDATE lab_phases SET content = replace(content, '! On SW1 — the deliberately weak port'||E'\n'||'configure terminal'||E'\n'||'interface Et0/3'||E'\n'||' description KALI-USER-PORT'||E'\n'||' switchport mode dynamic auto'||E'\n'||' switchport access vlan 10'||E'\n'||'end', '! On SW1 — the deliberately weak port'||E'\n'||'configure terminal'||E'\n'||'interface FastEthernet0/3'||E'\n'||' description KALI-USER-PORT'||E'\n'||' switchport mode dynamic auto'||E'\n'||'end') WHERE lab_id = 1 AND phase = 'build';

-- ATTACK
UPDATE lab_phases SET content = replace(content, 'show interfaces Et0/3 switchport', 'show interfaces fastEthernet 0/3 switchport') WHERE lab_id = 1 AND phase = 'attack';

-- HARDEN
UPDATE lab_phases SET content = replace(content, 'configure terminal'||E'\n'||'interface Et0/1'||E'\n'||' switchport mode access', 'configure terminal'||E'\n'||'interface FastEthernet0/1'||E'\n'||' switchport mode access') WHERE lab_id = 1 AND phase = 'harden';
UPDATE lab_phases SET content = replace(content, 'interface Et0/3'||E'\n'||' switchport mode access'||E'\n'||' switchport access vlan 10', 'interface FastEthernet0/3'||E'\n'||' switchport mode access'||E'\n'||' switchport access vlan 10') WHERE lab_id = 1 AND phase = 'harden';
UPDATE lab_phases SET content = replace(content, 'configure terminal'||E'\n'||'interface Et0/2'||E'\n'||' switchport trunk native vlan 99', 'configure terminal'||E'\n'||'interface FastEthernet0/2'||E'\n'||' switchport trunk native vlan 99') WHERE lab_id = 1 AND phase = 'harden';
UPDATE lab_phases SET content = replace(content, 'interface range Ethernet0/4 - 23', 'interface range FastEthernet0/4 - 23') WHERE lab_id = 1 AND phase = 'harden';
UPDATE lab_phases SET content = replace(content, E'Then check SW1:\n```\nshow interfaces Et0/3 switchport', E'Then check SW1:\n```\nshow interfaces fastEthernet 0/3 switchport') WHERE lab_id = 1 AND phase = 'harden';

COMMIT;
