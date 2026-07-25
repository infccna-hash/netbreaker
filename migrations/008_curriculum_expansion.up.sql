-- ═══════════════════════════════════════════════════════════════════
-- Curriculum expansion: from 14 labs to the full 45-lab chapter map
-- covering every technical chapter in "Acing the CCNA Exam" Vol 1 & 2.
--
-- Existing 14 lab IDs are NEVER renumbered (Lab 01's real content, and any
-- future user progress, stays keyed correctly). We only:
--   1. add a book_ref column,
--   2. re-sequence sort_order for all 45 labs into curriculum order,
--   3. tag existing labs with their book_ref,
--   4. insert the 31 new lab shells + placeholder phases.
-- ═══════════════════════════════════════════════════════════════════

ALTER TABLE labs ADD COLUMN IF NOT EXISTS book_ref VARCHAR(60);

-- ── Re-sequence + tag the 14 EXISTING labs (content untouched) ──
UPDATE labs SET sort_order = 5,  book_ref = 'Vol 1 · Ch 6'  WHERE id = 3;  -- MAC flood chaos
UPDATE labs SET sort_order = 11, book_ref = 'Vol 1 · Ch 12' WHERE id = 1;  -- VLAN warfare
UPDATE labs SET sort_order = 13, book_ref = 'Vol 1 · Ch 14' WHERE id = 2;  -- STP sabotage
UPDATE labs SET sort_order = 17, book_ref = 'Vol 1 · Ch 18' WHERE id = 4;  -- OSPF infiltration
UPDATE labs SET sort_order = 18, book_ref = 'Vol 1 · Ch 19' WHERE id = 5;  -- HSRP takeover
UPDATE labs SET sort_order = 20, book_ref = 'Vol 1 · Ch 21' WHERE id = 14; -- IPv6 NDP spoof
UPDATE labs SET sort_order = 23, book_ref = 'Vol 1 · Ch 24' WHERE id = 6;  -- ACL bypass (extended ACLs)
UPDATE labs SET sort_order = 24, book_ref = 'Vol 2 · Ch 1'  WHERE id = 7;  -- CDP/LLDP espionage
UPDATE labs SET sort_order = 26, book_ref = 'Vol 2 · Ch 3'  WHERE id = 10; -- DNS poisoning
UPDATE labs SET sort_order = 27, book_ref = 'Vol 2 · Ch 4'  WHERE id = 8;  -- DHCP starvation
UPDATE labs SET sort_order = 28, book_ref = 'Vol 2 · Ch 5'  WHERE id = 11; -- SSH vs Telnet autopsy
UPDATE labs SET sort_order = 32, book_ref = 'Vol 2 · Ch 9'  WHERE id = 9;  -- NAT unmasked
UPDATE labs SET sort_order = 34, book_ref = 'Vol 2 · Ch 11' WHERE id = 12; -- 802.1X port lockdown
UPDATE labs SET sort_order = 41, book_ref = 'Vol 2 · Ch 20' WHERE id = 13; -- Wireless evil twin

-- ── Insert the 31 NEW lab shells (ids 15-45), in curriculum order ──
INSERT INTO labs (id, slug, title, topic, difficulty, is_free, sort_order, short_desc, book_ref) VALUES
(15, 'network-devices',           'Network Devices & Anatomy',       'fundamentals', 'easy',   false, 1,  'Identify every device on the wire and what breaks when you get its role wrong.', 'Vol 1 · Ch 2'),
(16, 'cabling-connectors',        'Cabling & Connectors',            'fundamentals', 'easy',   false, 2,  'Copper vs. fiber, straight-through vs. crossover — then diagnose a cabling fault under time pressure.', 'Vol 1 · Ch 3'),
(17, 'tcpip-model',               'The TCP/IP Model',                'fundamentals', 'easy',   false, 3,  'Encapsulate a packet layer by layer, then race the clock tracing it back apart.', 'Vol 1 · Ch 4'),
(18, 'ios-cli-bootcamp',          'Cisco IOS CLI Bootcamp',          'fundamentals', 'easy',   false, 4,  'EXEC modes, keyboard shortcuts, and password hygiene — speed-run the CLI like you have done this a hundred times.', 'Vol 1 · Ch 5'),
(19, 'ipv4-addressing',           'IPv4 Addressing',                 'fundamentals', 'easy',   false, 6,  'Dissect the IPv4 header field by field, then reconstruct one from a hex dump against the clock.', 'Vol 1 · Ch 7'),
(20, 'interfaces-autonegotiation','Interfaces & Autonegotiation',    'fundamentals', 'medium', false, 7,  'Configure speed and duplex, then hunt down a mismatch that is silently wrecking throughput.', 'Vol 1 · Ch 8'),
(21, 'routing-fundamentals',      'Routing Fundamentals',            'fundamentals', 'easy',   false, 8,  'Follow one packet on its entire trip from source to destination and back, hop by hop.', 'Vol 1 · Ch 9-10'),
(22, 'subnetting-flsm',           'Subnetting I — FLSM',             'fundamentals', 'medium', false, 9,  'Carve /24s, /16s, and /8s into usable subnets — then do it again with a stopwatch running.', 'Vol 1 · Ch 11.1-11.2'),
(23, 'subnetting-vlsm',           'Subnetting II — VLSM',            'fundamentals', 'hard',   false, 10, 'Design a real multi-site VLSM addressing scheme with zero wasted address space.', 'Vol 1 · Ch 11.3-11.4'),
(24, 'dtp-vtp-hijack',            'DTP & VTP',                       'switching',    'medium', false, 12, 'Trust the wrong switch with VTP and watch it delete every VLAN on the network for you.', 'Vol 1 · Ch 13'),
(25, 'rstp-topology',             'RSTP',                            'switching',    'medium', false, 14, 'Force a rapid topology change and watch how much faster RSTP recovers than its ancestor.', 'Vol 1 · Ch 15'),
(26, 'etherchannel-mismatch',     'EtherChannel',                    'switching',    'medium', false, 15, 'Bundle links for redundancy — then break the bundle with one silent LACP mismatch.', 'Vol 1 · Ch 16'),
(27, 'dynamic-routing-concepts',  'Dynamic Routing Concepts',        'routing',      'easy',   false, 16, 'Metric vs. administrative distance — resolve a route-selection puzzle with two protocols disagreeing.', 'Vol 1 · Ch 17'),
(28, 'ipv6-addressing',           'IPv6 Addressing',                 'fundamentals', 'medium', false, 19, 'Hexadecimal, EUI-64, and every IPv6 address type — abbreviate, expand, classify.', 'Vol 1 · Ch 20'),
(29, 'tcp-udp-internals',         'TCP & UDP',                       'fundamentals', 'medium', false, 21, 'Three-way handshake, sequence numbers, and session disruption with a well-timed RST.', 'Vol 1 · Ch 22'),
(30, 'standard-acl-logic',        'Standard ACLs',                   'security',     'easy',   false, 22, 'Write the implicit-deny rule wrong once and lock yourself out of your own router.', 'Vol 1 · Ch 23'),
(31, 'ntp-time-spoof',            'NTP',                             'services',     'medium', false, 25, 'Shift a device clock with spoofed NTP and watch certificate validation and logs fall apart.', 'Vol 2 · Ch 2'),
(32, 'snmp-community-abuse',      'SNMP',                            'services',     'medium', false, 29, 'Walk an entire device configuration out the door with a default SNMPv2c community string.', 'Vol 2 · Ch 6'),
(33, 'syslog-triage',             'Syslog',                          'services',     'easy',   false, 30, 'Sort real incidents from noise across severity levels while the log stream does not stop.', 'Vol 2 · Ch 7'),
(34, 'tftp-ftp-exfil',            'TFTP/FTP & IOS Upgrades',         'services',     'medium', false, 31, 'Pull a full running-config off a router over a protocol that was never built to keep a secret.', 'Vol 2 · Ch 8'),
(35, 'qos-under-contention',      'Quality of Service',              'services',     'medium', false, 33, 'Design a QoS policy that keeps voice alive while the link is being crushed by everything else.', 'Vol 2 · Ch 10'),
(36, 'port-security-bypass',      'Port Security',                   'switching',    'medium', false, 35, 'Lock a port to one MAC address — then flood past the limit before it shuts itself down.', 'Vol 2 · Ch 12'),
(37, 'dhcp-snooping-defense',     'DHCP Snooping',                   'services',     'medium', false, 36, 'Deploy a rogue DHCP server, then watch DHCP Snooping trust-boundary it into oblivion.', 'Vol 2 · Ch 13'),
(38, 'dynamic-arp-inspection',    'Dynamic ARP Inspection',          'security',     'hard',   false, 37, 'Spoof ARP to man-in-the-middle a host — then get DAI to drop every forged reply on the floor.', 'Vol 2 · Ch 14'),
(39, 'lan-wan-architectures',     'LAN/WAN Architectures',           'fundamentals', 'easy',   false, 38, 'Redesign a flat, collapsed network as a proper three-tier architecture under real constraints.', 'Vol 2 · Ch 15-16'),
(40, 'virtualization-cloud',      'Virtualization & Cloud',          'fundamentals', 'easy',   false, 39, 'Break container isolation between two tenants who were never supposed to see each other.', 'Vol 2 · Ch 17'),
(41, 'wireless-fundamentals',     'Wireless LAN Fundamentals',       'wireless',     'easy',   false, 40, 'Read 802.11 frame types straight out of a live capture and identify the client association handshake.', 'Vol 2 · Ch 18-19'),
(42, 'wlan-configuration',        'WLAN Configuration',              'wireless',     'medium', false, 42, 'Stand up a WLC, dynamic interfaces, and a WLAN profile a real client can actually associate to.', 'Vol 2 · Ch 21'),
(43, 'sdn-automation-concepts',   'Network Automation & SDN',        'automation',   'easy',   false, 43, 'Map the control, data, and management planes — then spot which one SDN actually centralizes.', 'Vol 2 · Ch 22'),
(44, 'rest-api-abuse',            'REST APIs & Data Formats',        'automation',   'medium', false, 44, 'Call an unauthenticated REST API endpoint and pull configuration data it should never have exposed.', 'Vol 2 · Ch 23-24'),
(45, 'config-drift-hunt',         'Ansible & Terraform',             'automation',   'medium', false, 45, 'Spot the configuration drift between what Ansible thinks is deployed and what is actually running.', 'Vol 2 · Ch 25');

-- ── Placeholder phases for the 31 new labs (same pattern as the original seed) ──
INSERT INTO lab_phases (lab_id, phase, title, content, is_pro_only)
SELECT id, 'build', title || ' — Build',
       'Full content coming soon. Maps to ' || book_ref || '.', false
FROM labs WHERE id BETWEEN 15 AND 45;

INSERT INTO lab_phases (lab_id, phase, title, content, is_pro_only)
SELECT id, 'attack', title || ' — Attack',
       'Full content coming soon. Maps to ' || book_ref || '.', true
FROM labs WHERE id BETWEEN 15 AND 45;

INSERT INTO lab_phases (lab_id, phase, title, content, is_pro_only)
SELECT id, 'harden', title || ' — Harden',
       'Full content coming soon. Maps to ' || book_ref || '.', true
FROM labs WHERE id BETWEEN 15 AND 45;
