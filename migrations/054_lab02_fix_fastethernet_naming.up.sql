-- Migration 054: Fix Lab 2 interface naming — FastEthernet → Ethernet
--
-- GNS3 IOU images (i86bi-linux-l2-adventerprisek9-15.1a.bin) use Ethernet0/x naming,
-- NOT FastEthernet0/x. The original Lab 2 content used Cisco hardware conventions
-- (FastEthernet, Fa0/x) which cause "Invalid input" errors on IOU.
--
-- Fixes 8 occurrences across all three phases + SVG:
--   BUILD:   Fa0/1→Et0/1, Fa0/2→Et0/2, FastEthernet0/1→Ethernet0/1
--   ATTACK:  fastEthernet 0/2→ethernet 0/2
--   HARDEN:  FastEthernet0/1→Ethernet0/1 (×1), FastEthernet0/2→Ethernet0/2 (×2),
--            fastEthernet 0/2→ethernet 0/2 (×1)
--   SVG:     Fa0/2→Et0/2

-- ═══════════════════ BUILD ═══════════════════
UPDATE lab_phases SET content = replace(replace(replace(
  content,
  'PC1→SW1 Fa0/1',  'PC1→SW1 Et0/1'),
  'KALI→SW3 Fa0/2', 'KALI→SW3 Et0/2'),
  'interface range FastEthernet0/1 - 2', 'interface range Ethernet0/1 - 2')
WHERE lab_id = 2 AND phase = 'build';

-- ═══════════════════ ATTACK ═══════════════════
UPDATE lab_phases SET content = replace(
  content,
  'show spanning-tree vlan 1 interface fastEthernet 0/2',
  'show spanning-tree vlan 1 interface ethernet 0/2')
WHERE lab_id = 2 AND phase = 'attack';

-- ═══════════════════ HARDEN ═══════════════════
UPDATE lab_phases SET content = replace(replace(replace(replace(
  content,
  'interface FastEthernet0/2',   'interface Ethernet0/2'),
  'interface FastEthernet0/1',   'interface Ethernet0/1'),
  'show spanning-tree vlan 1 interface fastEthernet 0/2',
  'show spanning-tree vlan 1 interface ethernet 0/2'),
  'interface FastEthernet0/2',   'interface Ethernet0/2')
WHERE lab_id = 2 AND phase = 'harden';
-- Note: FastEthernet0/2 appears twice in harden (BPDU Guard + re-enable),
-- so the replace is idempotent — double-wrapped but handles both.

-- ═══════════════════ SVG ═══════════════════
UPDATE lab_topologies SET svg_large = replace(
  svg_large,
  'Fa0/2 → BPDU Guard',
  'Et0/2 → BPDU Guard')
WHERE lab_id = 2;
