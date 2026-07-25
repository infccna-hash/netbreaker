-- Insert all 14 NetBreaker labs
INSERT INTO labs (id, slug, title, topic, difficulty, is_free, sort_order, short_desc) VALUES
(1,  'vlan-warfare',       'VLAN warfare',          'switching', 'easy',   true,  1,  'Configure 3 VLANs, trunk ports, and router-on-a-stick. Then perform a VLAN hopping attack.'),
(2,  'stp-sabotage',       'STP sabotage',           'switching', 'medium', true,  2,  'Deploy STP across 4 switches and perform a root bridge hijack with Yersinia.'),
(3,  'mac-flood-chaos',    'MAC flood chaos',         'switching', 'easy',   true,  3,  'Study CAM table behavior then flood it with macof to force hub mode.'),
(4,  'ospf-infiltration',  'OSPF infiltration',       'routing',   'medium', false, 4,  'Build a 5-router OSPF network then inject rogue LSAs to poison the routing table.'),
(5,  'hsrp-takeover',      'HSRP takeover',           'routing',   'medium', false, 5,  'Configure HSRP for first-hop redundancy then hijack the active router.'),
(6,  'acl-bypass',         'ACL bypass mission',      'security',  'medium', false, 6,  'Configure standard and extended ACLs then bypass them with IP fragmentation.'),
(7,  'cdp-lldp-espionage', 'CDP/LLDP espionage',      'security',  'easy',   false, 7,  'Enable CDP and LLDP then harvest the full topology passively from a switch port.'),
(8,  'dhcp-starvation',    'DHCP starvation',         'services',  'easy',   false, 8,  'Configure a DHCP server then starve the pool and deploy a rogue DHCP server.'),
(9,  'nat-unmasked',       'NAT unmasked',            'services',  'easy',   false, 9,  'Configure static NAT, dynamic NAT, and PAT then perform NAT traversal.'),
(10, 'dns-poisoning',      'DNS poisoning',           'services',  'hard',   false, 10, 'Configure a DNS server then race the real response to inject a poisoned A record.'),
(11, 'ssh-vs-telnet',      'SSH vs Telnet autopsy',   'security',  'easy',   false, 11, 'Enable Telnet and SSH on a router then capture cleartext credentials in Wireshark.'),
(12, 'dot1x-lockdown',     '802.1X port lockdown',    'security',  'hard',   false, 12, 'Configure 802.1X with FreeRADIUS then crack EAP-MD5 and force EAP-TLS.'),
(13, 'wireless-evil-twin', 'Wireless evil twin',      'wireless',  'hard',   false, 13, 'Study 802.11 then clone an SSID, deauth clients, and crack the WPA2 handshake.'),
(14, 'ipv6-ndp-spoof',     'IPv6 neighbor spoof',     'routing',   'hard',   false, 14, 'Configure OSPFv3 and IPv6 then spoof Neighbor Advertisements for a MiTM attack.');

-- Insert placeholder phase content (populate via admin panel or direct SQL in production)
INSERT INTO lab_phases (lab_id, phase, title, content, is_pro_only)
SELECT id, 'build', title || ' — Build', 'Content coming soon. Upload via admin panel.', false FROM labs;

INSERT INTO lab_phases (lab_id, phase, title, content, is_pro_only)
SELECT id, 'attack', title || ' — Attack', 'Content coming soon. Upload via admin panel.', true FROM labs;

INSERT INTO lab_phases (lab_id, phase, title, content, is_pro_only)
SELECT id, 'harden', title || ' — Harden', 'Content coming soon. Upload via admin panel.', true FROM labs;

-- Free labs have non-pro phases
UPDATE lab_phases SET is_pro_only = false WHERE lab_id IN (1, 2, 3);

