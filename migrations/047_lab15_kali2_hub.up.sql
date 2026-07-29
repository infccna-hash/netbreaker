-- ═══════════════════════════════════════════════════════════════════
-- Lab 15 — add KALI2 (hub-side observer), 2026-07-28
--
-- Reintroduces a second Kali, but NOT the same way as before (the
-- pre-cleanup-cycle KALI2 sat on the switch, redundant with KALI —
-- removed in commit 351618a / migration 042 for exactly that reason).
-- This KALI2 sits ON THE HUB, alongside PC1/PC2. That's a genuinely
-- different vantage point: a hub floods every frame to every port
-- with no learning and no forwarding decision at all, so KALI2 sees
-- the ENTIRE PC1<->PC2 conversation — both the broadcast ARP Request
-- AND the unicast Reply that switch-side KALI structurally cannot
-- see (the exact gap the Aha moment callout, added in migration 046,
-- is about). Same traffic, two observers, two different outcomes —
-- proven side by side instead of asserted in prose.
--
-- Topology + verifier changes are in the same commit
-- (lab15_topology.go, lab15_verify.go): KALI2 on H1 port e3, and the
-- Build verifier's MACsShareOnePort check now includes KALI2 —
-- stronger version of the same lesson (three hosts behind one port,
-- not two).
-- ═══════════════════════════════════════════════════════════════════

-- Step 1: add KALI2 to the host table + its own config block.
UPDATE lab_phases SET
  content = replace(
    content,
    '| KALI | 192.168.1.100 | 192.168.1.1 |

**VPCS nodes** (PC1, PC2, PC3):',
    '| KALI | 192.168.1.100 | 192.168.1.1 |
| KALI2 | 192.168.1.101 | 192.168.1.1 |

**VPCS nodes** (PC1, PC2, PC3):'
  )
WHERE lab_id = 15 AND phase = 'build';

UPDATE lab_phases SET
  content = replace(
    content,
    'sudo ip addr add 192.168.1.100/24 dev eth0
sudo ip route add default via 192.168.1.1
```

On R1:',
    'sudo ip addr add 192.168.1.100/24 dev eth0
sudo ip route add default via 192.168.1.1
```

**KALI2:**
```
sudo ip addr add 192.168.1.101/24 dev eth0
sudo ip route add default via 192.168.1.1
```

On R1:'
  )
WHERE lab_id = 15 AND phase = 'build';

-- Step 2: insert the hub-side capture right after the switch-side
-- one, as a direct A/B — same ping, two observers.
UPDATE lab_phases SET
  content = replace(
    content,
    'KALI is on a switch port — it sees only its own traffic and broadcasts. The PC1↔PC2 exchange stays on the hub segment and never reaches KALI because the switch learned exactly which port each MAC lives on and forwards selectively.

Now compare this to what a hub does: the hub segment (H1) puts PC1 and PC2 in a single collision domain — any transmission from either one is repeated out every other port on the hub. Nothing escapes to the switch-side devices unless the switch itself decides to forward it onward.',
    'KALI is on a switch port — it sees only its own traffic and broadcasts. The PC1↔PC2 exchange stays on the hub segment and never reaches KALI because the switch learned exactly which port each MAC lives on and forwards selectively.

Now run the identical capture from the other side. On **KALI2** (hub-side observer — plugged into H1 alongside PC1 and PC2):
```
sudo tcpdump -i eth0 -nn
```

Same ping, same moment in time — but KALI2''s capture looks completely different. It shows **every single packet** of the PC1↔PC2 exchange, in both directions, in full. Nothing was filtered, because H1 is a hub: it has no MAC table, makes no forwarding decisions, and repeats every frame that arrives on any port out to every other port. KALI2 isn''t special or better-positioned in any technical sense — it just happens to sit on a segment where "decide what to forward" was never implemented in the first place.

That''s the whole lesson in one side-by-side comparison: KALI (switch-side) saw a filtered, selective view. KALI2 (hub-side) saw everything. Same wire, same two hosts talking, two completely different amounts of visibility — determined entirely by which kind of device sits between the observer and the traffic.'
  )
WHERE lab_id = 15 AND phase = 'build';

-- Step 3: KALI2 needs to transmit at least one frame for the switch
-- to actually learn its MAC (passive tcpdump alone doesn't do that) —
-- add a one-line ping, and update the MAC-table explanation to cover
-- three hosts behind Et0/0 instead of two.
UPDATE lab_phases SET
  content = replace(
    content,
    '## Step 3 — Observe switch behaviour via the MAC table

On SW1:
```
show mac address-table
```

Look at the port column. PC1 and PC2 each have their own MAC address, but both entries point to **Et0/0** — because the switch sees the hub as a single attachment point, so anything behind it is only ever "somewhere off Et0/0" as far as the switch''s forwarding table is concerned. PC3 and KALI, by contrast, each have their **own dedicated port entry** (Et0/1, Et0/2) — proof the switch is tracking each of them individually, down to the exact port.',
    '## Step 3 — Observe switch behaviour via the MAC table

From **KALI2**, send one frame so the switch has something of KALI2''s to learn (a passive capture alone doesn''t put KALI2''s own MAC on the wire):
```
ping 192.168.1.10 -c 1
```

On SW1:
```
show mac address-table
```

Look at the port column. PC1, PC2, and KALI2 each have their own MAC address, but all three entries point to **Et0/0** — because the switch sees the hub as a single attachment point, so anything behind it is only ever "somewhere off Et0/0" as far as the switch''s forwarding table is concerned; it has no way to know there are three separate devices back there, let alone which one sent what. PC3 and KALI, by contrast, each have their **own dedicated port entry** (Et0/1, Et0/2) — proof the switch is tracking each of them individually, down to the exact port.'
  )
WHERE lab_id = 15 AND phase = 'build';
