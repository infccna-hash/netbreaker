-- 083_lab1_build_ethernet_ports_and_switchport.up.sql
-- Lab 1 build phase: fix interface naming + port mapping + 12.2 switchport quirk.
--
-- Problems found (2026-08-04, from student walkthrough on the upk9-12.2 image):
-- 1. Content says FastEthernet0/N — real topology uses Ethernet0/N (IOU 12.2).
-- 2. Wrong port numbers: SRV1 is SW2 Et0/2 (content said Fa0/1);
--    SW1→R1 trunk is Et0/0 (content said Fa0/24); SW2→SW1 trunk is Et0/1
--    (content said Fa0/2).
-- 3. The 12.2 image requires a bare `switchport` command before
--    `switchport mode` — without it: "Command rejected: Et0/N not a
--    switching port." (15.1a enables switchport by default; 12.2 does not.)

-- SW1 Step 2: PC1 access port
UPDATE lab_phases
SET content = replace(content,
  E'interface FastEthernet0/1\n description PC1-USER\n switchport mode access\n switchport access vlan 10',
  E'interface Ethernet0/1\n description PC1-USER\n switchport\n switchport mode access\n switchport access vlan 10'
)
WHERE lab_id = 1 AND phase = 'build';

-- SW2 Step 2: SRV1 access port (real port = Et0/2, not Et0/1)
UPDATE lab_phases
SET content = replace(content,
  E'interface FastEthernet0/1\n description SRV1-CROWN-JEWELS\n switchport mode access\n switchport access vlan 20',
  E'interface Ethernet0/2\n description SRV1-CROWN-JEWELS\n switchport\n switchport mode access\n switchport access vlan 20'
)
WHERE lab_id = 1 AND phase = 'build';

-- SW1 Step 3: SW1↔SW2 trunk (Et0/2)
UPDATE lab_phases
SET content = replace(content,
  E'interface FastEthernet0/2\n description TRUNK-TO-SW2\n switchport trunk encapsulation dot1q\n switchport mode trunk',
  E'interface Ethernet0/2\n description TRUNK-TO-SW2\n switchport\n switchport trunk encapsulation dot1q\n switchport mode trunk'
)
WHERE lab_id = 1 AND phase = 'build';

-- SW1 Step 3: SW1↔R1 trunk (real port = Et0/0, not Fa0/24)
UPDATE lab_phases
SET content = replace(content,
  E'interface FastEthernet0/24\n description TRUNK-TO-R1\n switchport trunk encapsulation dot1q\n switchport mode trunk',
  E'interface Ethernet0/0\n description TRUNK-TO-R1\n switchport\n switchport trunk encapsulation dot1q\n switchport mode trunk'
)
WHERE lab_id = 1 AND phase = 'build';

-- SW2 Step 3: SW2↔SW1 trunk (real port = Et0/1, not Fa0/2)
UPDATE lab_phases
SET content = replace(content,
  E'interface FastEthernet0/2\n description TRUNK-TO-SW1\n switchport trunk encapsulation dot1q\n switchport mode trunk',
  E'interface Ethernet0/1\n description TRUNK-TO-SW1\n switchport\n switchport trunk encapsulation dot1q\n switchport mode trunk'
)
WHERE lab_id = 1 AND phase = 'build';

-- SW1 Step 6: KALI trap port (Et0/3, dynamic auto)
UPDATE lab_phases
SET content = replace(content,
  E'interface FastEthernet0/3\n description KALI-USER-PORT\n switchport mode dynamic auto',
  E'interface Ethernet0/3\n description KALI-USER-PORT\n switchport\n switchport mode dynamic auto'
)
WHERE lab_id = 1 AND phase = 'build';
