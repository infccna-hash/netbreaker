-- 084_lab1_build_no_shutdown.down.sql
-- Revert: remove `no shutdown` from Lab 1 build interface blocks.

UPDATE lab_phases
SET content = replace(content,
  E'interface Ethernet0/1\n description PC1-USER\n switchport\n switchport mode access\n switchport access vlan 10\n no shutdown\nend',
  E'interface Ethernet0/1\n description PC1-USER\n switchport\n switchport mode access\n switchport access vlan 10\nend'
)
WHERE lab_id = 1 AND phase = 'build';

UPDATE lab_phases
SET content = replace(content,
  E'interface Ethernet0/2\n description SRV1-CROWN-JEWELS\n switchport\n switchport mode access\n switchport access vlan 20\n no shutdown\nend',
  E'interface Ethernet0/2\n description SRV1-CROWN-JEWELS\n switchport\n switchport mode access\n switchport access vlan 20\nend'
)
WHERE lab_id = 1 AND phase = 'build';

UPDATE lab_phases
SET content = replace(content,
  E'interface Ethernet0/2\n description TRUNK-TO-SW2\n switchport\n switchport trunk encapsulation dot1q\n switchport mode trunk\n no shutdown\n!',
  E'interface Ethernet0/2\n description TRUNK-TO-SW2\n switchport\n switchport trunk encapsulation dot1q\n switchport mode trunk\n!'
)
WHERE lab_id = 1 AND phase = 'build';

UPDATE lab_phases
SET content = replace(content,
  E'interface Ethernet0/0\n description TRUNK-TO-R1\n switchport\n switchport trunk encapsulation dot1q\n switchport mode trunk\n no shutdown\nend',
  E'interface Ethernet0/0\n description TRUNK-TO-R1\n switchport\n switchport trunk encapsulation dot1q\n switchport mode trunk\nend'
)
WHERE lab_id = 1 AND phase = 'build';

UPDATE lab_phases
SET content = replace(content,
  E'interface Ethernet0/1\n description TRUNK-TO-SW1\n switchport\n switchport trunk encapsulation dot1q\n switchport mode trunk\n no shutdown\nend',
  E'interface Ethernet0/1\n description TRUNK-TO-SW1\n switchport\n switchport trunk encapsulation dot1q\n switchport mode trunk\nend'
)
WHERE lab_id = 1 AND phase = 'build';

UPDATE lab_phases
SET content = replace(content,
  E'interface Ethernet0/3\n description KALI-USER-PORT\n switchport\n switchport mode dynamic auto\n no shutdown\nend',
  E'interface Ethernet0/3\n description KALI-USER-PORT\n switchport\n switchport mode dynamic auto\nend'
)
WHERE lab_id = 1 AND phase = 'build';
