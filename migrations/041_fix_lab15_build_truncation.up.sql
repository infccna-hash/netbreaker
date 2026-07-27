-- 041_fix_lab15_build_truncation.up.sql
-- Fixes a content truncation bug caused by an inline <svg> in the
-- Build phase markdown. An older CMS ingestion left a raw <svg>
-- element inside the content column; the frontend markdown renderer
-- treated </svg> as a premature close tag and dropped everything
-- after it — including Steps 1–4 (addressing, hub behavior, MAC
-- table, broadcast boundary). The fixed version uses an external
-- topology reference (Lab15Topology.tsx / lab-15-topology.svg)
-- and includes the complete Step 1–4 instructions.
--
-- Root cause: CMS had a stale copy. The source-of-truth markdown
-- file (lab-15-network-devices-anatomy.md) already has this fix.
-- This migration replaces the DB content with the corrected version.
--
-- To verify post-migration: visit /labs/15/build and confirm
-- Step 1 through Step 4 headings appear in the rendered HTML.
BEGIN;

UPDATE lab_phases
SET content = $lab15build$
# LAB 15 · fundamentals · easy

## Network Devices & Anatomy
📖 Maps to Vol 1 · Ch 2

Identify every device on the wire and what breaks when you get its role wrong.

---

## Topology

See `Lab15Topology.tsx` / `lab-15-topology.svg` for the rendered diagram.

**Cabling (fixed for the entire session — no rewiring required):**
- PC1 + PC2 + KALI2 → H1 (hub) → SW1 (Et0/0)
- PC3 → SW1 (Et0/1)
- KALI → SW1 (Et0/2)
- SW1 (Et0/3) → R1
- R1 → FW1
- Et0/4 — spare, unused

**Why two Kali nodes:** KALI sits on a switch port (Et0/2) and KALI2 sits on the hub segment alongside PC1/PC2. Both are the same pinned Kali image — no new image to build or approve. Comparing what each one sees, at the same moment, on the same ping, is the entire lesson: no cable ever needs to move mid-session, which matters because NetBreaker's live-lab console only gives students terminal access to nodes, not a GNS3 canvas to rewire.

**SW1 port map:**

| Port | Connects to | Notes |
|---|---|---|
| Et0/0 | H1 (hub uplink) | Carries PC1, PC2, and KALI2 traffic |
| Et0/1 | PC3 | Dedicated switch port |
| Et0/2 | KALI | Dedicated switch port — limited visibility, by design |
| Et0/3 | R1 | Uplink to router |
| Et0/4 | *(spare)* | Unused — documented for realism in Harden |

> **Note on interface naming:** commands below use the `Et0/x` shorthand for readability. If your SW1 node is actually running the IOSvL2 image, its real interfaces are named `GigabitEthernet0/0`–`Gi3/3` — substitute `Gi0/0`, `Gi0/1`, etc. accordingly, or use a generic switch image that natively exposes `Et0/x`.

---

## The topology — device table

| Device | Role | Image |
|---|---|---|
| H1 | Legacy hub | Generic hub or L2 switch in hub mode |
| SW1 | Layer-2 switch | IOSvL2 |
| R1 | Router | IOSv |
| FW1 | Firewall | IOSv (or simulated via ACLs) |
| PC1, PC2 | End hosts | VPCS |
| PC3 | End host | VPCS |
| KALI | Switch-side observer | Kali Linux |
| KALI2 | Hub-side observer | Kali Linux (same pinned image as KALI) |

### Objectives
- Understand the role of each device in a network
- Observe collision domains (hub) vs separate collision domains (switch) — as a live side-by-side, not a before/after
- Observe the router as a broadcast boundary

---

## Step 1 — Build & set up addressing

Topology is pre-wired at session start — nothing to cable.

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

On KALI2:
```
sudo ip addr add 192.168.1.101/24 dev eth0
sudo ip route add default via 192.168.1.1
```

---

## Step 2 — Observe hub behaviour (side-by-side, no rewiring)

From PC1, ping PC2 continuously:
```
ping 192.168.1.20 -t
```

In a second terminal, on **KALI2** (hub segment):
```
sudo tcpdump -i eth0 -nn
```

KALI2 sees PC1's traffic even though it's not the destination — the hub broadcasts everything to every port on its segment, including KALI2, which was never plugged into the conversation.

In a third terminal, on **KALI** (switch segment):
```
sudo tcpdump -i eth0 -nn
```

KALI sees nothing from the PC1↔PC2 exchange. Same ping, same instant — the only variable is which physical segment each sniffer sits on.

> **Collision domain:** A hub creates a SINGLE collision domain — every port repeats every frame to every other port. A switch creates a SEPARATE collision domain per port — traffic goes only where it's addressed. KALI2 and KALI just proved this to you without either of you touching a cable.

---

## Step 3 — Observe switch behaviour via the MAC table

On SW1:
```
show mac address-table
```

Look at the port column. PC1, PC2, and KALI2 all resolve to the **same port — Et0/0** — because they all sit behind the hub; the switch has no way to tell them apart at Layer 2 below that single uplink. PC3 and KALI, by contrast, each have their **own dedicated port entry** (Et0/1, Et0/2) — proof the switch is tracking each of them individually.

This is the same conclusion "move PC1 to the switch and watch PC3 lose visibility" would have taught — the MAC table already shows you the boundary of each collision domain without needing to relocate anything.

---

## Step 4 — Observe router as broadcast boundary

From PC1, ping the broadcast address:
```
ping 192.168.1.255
```

The broadcast reaches all devices on the 192.168.1.0/24 LAN — including KALI2, KALI, PC2, and PC3. Now configure a second subnet behind R1 and verify the broadcast does NOT cross the router — routers stop broadcasts at the interface boundary.

---

## 🏗️ Achievement Unlocked
**Network Architect** — you understand the four pillars of every network
$lab15build$
WHERE lab_id = 15 AND phase = 'build';

COMMIT;
