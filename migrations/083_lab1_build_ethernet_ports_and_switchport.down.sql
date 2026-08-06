-- 083_lab1_build_ethernet_ports_and_switchport.down.sql
-- Revert Lab 1 build port naming back to FastEthernet (pre-083 state).

UPDATE lab_phases
SET content = replace(content,
  E'interface Ethernet0/1\n description PC1-USER\n switchport\n switchport mode access\n switchport access vlan 10',
  E'interface FastEthernet0/1\n description PC1-USER\n switchport mode access\n switchport access vlan 10'
)
WHERE lab_id = 1 AND phase = 'build';

UPDATE lab_phases
SET content = replace(content,
  E'interface Ethernet0/2\n description SRV1-CROWN-JEWELS\n switchport\n switchport mode access\n switchport access vlan 20',
  E'interface FastEthernet0/1\n description SRV1-CROWN-JEWELS\n switchport mode access\n switchport access vlan 20'
)
WHERE lab_id = 1 AND phase = 'build';

UPDATE lab_phases
SET content = replace(content,
  E'interface Ethernet0/2\n description TRUNK-TO-SW2\n switchport\n switchport trunk encapsulation dot1q\n switchport mode trunk',
  E'interface FastEthernet0/2\n description TRUNK-TO-SW2\n switchport trunk encapsulation dot1q\n switchport mode trunk'
)
WHERE lab_id = 1 AND phase = 'build';

UPDATE lab_phases
SET content = replace(content,
  E'interface Ethernet0/0\n description TRUNK-TO-R1\n switchport\n switchport trunk encapsulation dot1q\n switchport mode trunk',
  E'interface FastEthernet0/24\n description TRUNK-TO-R1\n switchport trunk encapsulation dot1q\n switchport mode trunk'
)
WHERE lab_id = 1 AND phase = 'build';

UPDATE lab_phases
SET content = replace(content,
  E'interface Ethernet0/1\n description TRUNK-TO-SW1\n switchport\n switchport trunk encapsulation dot1q\n switchport mode trunk',
  E'interface FastEthernet0/2\n description TRUNK-TO-SW1\n switchport trunk encapsulation dot1q\n switchport mode trunk'
)
WHERE lab_id = 1 AND phase = 'build';

UPDATE lab_phases
SET content = replace(content,
  E'interface Ethernet0/3\n description KALI-USER-PORT\n switchport\n switchport mode dynamic auto',
  E'interface FastEthernet0/3\n description KALI-USER-PORT\n switchport mode dynamic auto'
)
WHERE lab_id = 1 AND phase = 'build';
