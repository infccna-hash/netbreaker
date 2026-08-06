-- Revert 054: restore FastEthernet naming in Lab 2
-- This is the down migration — it undoes the Ethernet→FastEthernet rename.

-- ═══════════════════ BUILD ═══════════════════
UPDATE lab_phases SET content = replace(replace(replace(
  content,
  'PC1→SW1 Et0/1',  'PC1→SW1 Fa0/1'),
  'KALI→SW3 Et0/2', 'KALI→SW3 Fa0/2'),
  'interface range Ethernet0/1 - 2', 'interface range FastEthernet0/1 - 2')
WHERE lab_id = 2 AND phase = 'build';

-- ═══════════════════ ATTACK ═══════════════════
UPDATE lab_phases SET content = replace(
  content,
  'show spanning-tree vlan 1 interface ethernet 0/2',
  'show spanning-tree vlan 1 interface fastEthernet 0/2')
WHERE lab_id = 2 AND phase = 'attack';

-- ═══════════════════ HARDEN ═══════════════════
UPDATE lab_phases SET content = replace(replace(replace(replace(
  content,
  'interface Ethernet0/2',   'interface FastEthernet0/2'),
  'interface Ethernet0/1',   'interface FastEthernet0/1'),
  'show spanning-tree vlan 1 interface ethernet 0/2',
  'show spanning-tree vlan 1 interface fastEthernet 0/2'),
  'interface Ethernet0/2',   'interface FastEthernet0/2')
WHERE lab_id = 2 AND phase = 'harden';

-- ═══════════════════ SVG ═══════════════════
UPDATE lab_topologies SET svg_large = replace(
  svg_large,
  'Et0/2 → BPDU Guard',
  'Fa0/2 → BPDU Guard')
WHERE lab_id = 2;
