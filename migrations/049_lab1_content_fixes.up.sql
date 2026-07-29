-- 049_lab1_content_fixes: Fix interface naming (IOU Et0/x not Fa0/x),
-- SW2 port correction, R1 GigabitEthernet→FastEthernet, KALI VLAN 10.
-- Round-trip safe: every replace() has a unique anchor string.
BEGIN;

-- ── BUILD PHASE ──────────────────────────────────────────────────

-- Fix 1: SW1 PC1 port — Fa0/1 → Et0/1 (Build Step 2)
UPDATE lab_phases
SET content = replace(
  content,
  'On **SW1**, hand PC1 its VLAN:' || E'\n' || E'\n' || '```' || E'\n' || 'configure terminal' || E'\n' || 'interface FastEthernet0/1' || E'\n' || ' description PC1-USER',
  'On **SW1**, hand PC1 its VLAN:' || E'\n' || E'\n' || '```' || E'\n' || 'configure terminal' || E'\n' || 'interface Et0/1' || E'\n' || ' description PC1-USER'
)
WHERE lab_id = 1 AND phase = 'build';

-- Fix 2: SW2 SRV1 port — Fa0/1 → Et0/2 (build step 2)
UPDATE lab_phases
SET content = replace(
  content,
  'On **SW2**, do the same for the server:' || E'\n' || E'\n' || '```' || E'\n' || 'configure terminal' || E'\n' || 'interface FastEthernet0/1' || E'\n' || ' description SRV1-CROWN-JEWELS',
  'On **SW2**, do the same for the server:' || E'\n' || E'\n' || '```' || E'\n' || 'configure terminal' || E'\n' || 'interface Et0/2' || E'\n' || ' description SRV1-CROWN-JEWELS'
)
WHERE lab_id = 1 AND phase = 'build';

-- Fix 3: SW1 trunk to SW2 — Fa0/2 → Et0/2 (Build Step 3)
UPDATE lab_phases
SET content = replace(
  content,
  '! On SW1' || E'\n' || 'interface FastEthernet0/2' || E'\n' || ' description TRUNK-TO-SW2',
  '! On SW1' || E'\n' || 'interface Et0/2' || E'\n' || ' description TRUNK-TO-SW2'
)
WHERE lab_id = 1 AND phase = 'build';

-- Fix 4: SW1 trunk to R1 — Fa0/24 → Et0/0 (Build Step 3)
UPDATE lab_phases
SET content = replace(
  content,
  'interface FastEthernet0/24' || E'\n' || ' description TRUNK-TO-R1',
  'interface Et0/0' || E'\n' || ' description TRUNK-TO-R1'
)
WHERE lab_id = 1 AND phase = 'build';

-- Fix 5: SW2 trunk to SW1 — Fa0/2 → Et0/1 (Build Step 3)
UPDATE lab_phases
SET content = replace(
  content,
  '! On SW2' || E'\n' || 'interface FastEthernet0/2' || E'\n' || ' description TRUNK-TO-SW1',
  '! On SW2' || E'\n' || 'interface Et0/1' || E'\n' || ' description TRUNK-TO-SW1'
)
WHERE lab_id = 1 AND phase = 'build';

-- Fix 6: R1 GigabitEthernet → FastEthernet (Build Step 4, three occurrences)
-- The parent interface GigabitEthernet0/0
UPDATE lab_phases
SET content = replace(
  content,
  'interface GigabitEthernet0/0' || E'\n' || ' no shutdown',
  'interface FastEthernet0/0' || E'\n' || ' no shutdown'
)
WHERE lab_id = 1 AND phase = 'build';

-- Sub-interface GigabitEthernet0/0.10
UPDATE lab_phases
SET content = replace(
  content,
  'interface GigabitEthernet0/0.10' || E'\n' || ' encapsulation dot1Q 10',
  'interface FastEthernet0/0.10' || E'\n' || ' encapsulation dot1Q 10'
)
WHERE lab_id = 1 AND phase = 'build';

-- Sub-interface GigabitEthernet0/0.20
UPDATE lab_phases
SET content = replace(
  content,
  'interface GigabitEthernet0/0.20' || E'\n' || ' encapsulation dot1Q 20',
  'interface FastEthernet0/0.20' || E'\n' || ' encapsulation dot1Q 20'
)
WHERE lab_id = 1 AND phase = 'build';

-- Fix 7: SW1 KALI port + add VLAN 10 (Build Step 6)
-- Replace the entire code block to fix interface name AND add VLAN 10 assignment
UPDATE lab_phases
SET content = replace(
  content,
  '! On SW1 — the deliberately weak port' || E'\n' || 'configure terminal' || E'\n' || 'interface FastEthernet0/3' || E'\n' || ' description KALI-USER-PORT' || E'\n' || ' switchport mode dynamic auto' || E'\n' || 'end',
  '! On SW1 — the deliberately weak port' || E'\n' || 'configure terminal' || E'\n' || 'interface Et0/3' || E'\n' || ' description KALI-USER-PORT' || E'\n' || ' switchport mode dynamic auto' || E'\n' || ' switchport access vlan 10' || E'\n' || 'end'
)
WHERE lab_id = 1 AND phase = 'build';

-- ── ATTACK PHASE ─────────────────────────────────────────────────

-- Fix 8: show interfaces Fa0/3 → Et0/3 (Attack Step 2 peek)
UPDATE lab_phases
SET content = replace(
  content,
  'show interfaces fastEthernet 0/3 switchport',
  'show interfaces Et0/3 switchport'
)
WHERE lab_id = 1 AND phase = 'attack';

-- ── HARDEN PHASE ─────────────────────────────────────────────────

-- Fix 9: SW1 PC1 port Fa0/1 → Et0/1 (Harden Fix 1)
UPDATE lab_phases
SET content = replace(
  content,
  '`switchport nonegotiate` disables DTP entirely — the port will never form a trunk by negotiation again. On **SW1**:' || E'\n' || E'\n' || '```' || E'\n' || 'configure terminal' || E'\n' || 'interface FastEthernet0/1',
  '`switchport nonegotiate` disables DTP entirely — the port will never form a trunk by negotiation again. On **SW1**:' || E'\n' || E'\n' || '```' || E'\n' || 'configure terminal' || E'\n' || 'interface Et0/1'
)
WHERE lab_id = 1 AND phase = 'harden';

-- Fix 10: SW1 KALI port Fa0/3 → Et0/3 (Harden Fix 1)
UPDATE lab_phases
SET content = replace(
  content,
  'interface FastEthernet0/3' || E'\n' || ' switchport mode access' || E'\n' || ' switchport access vlan 10',
  'interface Et0/3' || E'\n' || ' switchport mode access' || E'\n' || ' switchport access vlan 10'
)
WHERE lab_id = 1 AND phase = 'harden';

-- Fix 11: SW1 trunk Fa0/2 → Et0/2 (Harden Fix 2)
UPDATE lab_phases
SET content = replace(
  content,
  'Set the trunk''s native VLAN to an unused parking VLAN, and allow only what belongs. On **both** switches'' trunk ports:' || E'\n' || E'\n' || '```' || E'\n' || 'configure terminal' || E'\n' || 'interface FastEthernet0/2',
  'Set the trunk''s native VLAN to an unused parking VLAN, and allow only what belongs. On **both** switches'' trunk ports:' || E'\n' || E'\n' || '```' || E'\n' || 'configure terminal' || E'\n' || 'interface Et0/2'
)
WHERE lab_id = 1 AND phase = 'harden';

-- Fix 12: black-hole range Fa0/4-23 → Et0/4-23 (Harden Fix 3)
UPDATE lab_phases
SET content = replace(
  content,
  'interface range FastEthernet0/4 - 23',
  'interface range Ethernet0/4 - 23'
)
WHERE lab_id = 1 AND phase = 'harden';

-- Fix 13: re-run check show Fa0/3 → Et0/3 (Harden re-run)
UPDATE lab_phases
SET content = replace(
  content,
  E'Then check SW1:\n```\nshow interfaces fastEthernet 0/3 switchport',
  E'Then check SW1:\n```\nshow interfaces Et0/3 switchport'
)
WHERE lab_id = 1 AND phase = 'harden';

COMMIT;
