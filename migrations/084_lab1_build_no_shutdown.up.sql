-- 084_lab1_build_no_shutdown.up.sql
-- Lab 1 build phase: add `no shutdown` to every switch interface block.
--
-- Why: the upk9-12.2 image boots all ports administratively down, and
-- (unlike 15.1a) it ignores interface `no shutdown` lines in startup config
-- content. The lab config blocks configure switchport mode but never bring
-- the ports up, so trunks never form and PC1/SRV1 never link. Every interface
-- block needs `no shutdown` after the switchport mode line.

UPDATE lab_phases
SET content = replace(content,
  E'interface Ethernet0/1\n description PC1-USER\n switchport\n switchport mode access\n switchport access vlan 10\nend',
  E'interface Ethernet0/1\n description PC1-USER\n switchport\n switchport mode access\n switchport access vlan 10\n no shutdown\nend'
)
WHERE lab_id = 1 AND phase = 'build';

UPDATE lab_phases
SET content = replace(content,
  E'interface Ethernet0/2\n description SRV1-CROWN-JEWELS\n switchport\n switchport mode access\n switchport access vlan 20\nend',
  E'interface Ethernet0/2\n description SRV1-CROWN-JEWELS\n switchport\n switchport mode access\n switchport access vlan 20\n no shutdown\nend'
)
WHERE lab_id = 1 AND phase = 'build';

UPDATE lab_phases
SET content = replace(content,
  E'interface Ethernet0/2\n description TRUNK-TO-SW2\n switchport\n switchport trunk encapsulation dot1q\n switchport mode trunk\n!',
  E'interface Ethernet0/2\n description TRUNK-TO-SW2\n switchport\n switchport trunk encapsulation dot1q\n switchport mode trunk\n no shutdown\n!'
)
WHERE lab_id = 1 AND phase = 'build';

UPDATE lab_phases
SET content = replace(content,
  E'interface Ethernet0/0\n description TRUNK-TO-R1\n switchport\n switchport trunk encapsulation dot1q\n switchport mode trunk\nend',
  E'interface Ethernet0/0\n description TRUNK-TO-R1\n switchport\n switchport trunk encapsulation dot1q\n switchport mode trunk\n no shutdown\nend'
)
WHERE lab_id = 1 AND phase = 'build';

UPDATE lab_phases
SET content = replace(content,
  E'interface Ethernet0/1\n description TRUNK-TO-SW1\n switchport\n switchport trunk encapsulation dot1q\n switchport mode trunk\nend',
  E'interface Ethernet0/1\n description TRUNK-TO-SW1\n switchport\n switchport trunk encapsulation dot1q\n switchport mode trunk\n no shutdown\nend'
)
WHERE lab_id = 1 AND phase = 'build';

UPDATE lab_phases
SET content = replace(content,
  E'interface Ethernet0/3\n description KALI-USER-PORT\n switchport\n switchport mode dynamic auto\nend',
  E'interface Ethernet0/3\n description KALI-USER-PORT\n switchport\n switchport mode dynamic auto\n no shutdown\nend'
)
WHERE lab_id = 1 AND phase = 'build';
