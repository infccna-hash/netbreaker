-- Migration 041: Fix Lab 15 build phase — restore truncated content
-- The CMS ingestion pipeline truncated Build at first </svg> (inline SVG in topology section).
-- This migration replaces the truncated content with the full markdown.

UPDATE lab_phases
SET content = $md$
# LAB 15 · fundamentals · easy

## Network Devices & Anatomy
📖 Maps to Vol 1 · Ch 2

Identify every device on the wire and what breaks when you get its role wrong.

---

**Cabling (fixed for the entire session — no rewiring required):**
- PC1 + PC2 + KALI2 → H1 (hub) → SW1 (Et0/0)
- PC3 → SW1 (Et0/1)
- KALI → SW1 (Et0/2)
- SW1 (Et0/3) → R1
- R1 → FW1
- Et0/4 — spare, unused

**Why two Kali nodes:** KALI sits on a switch port (Et0/2); KALI2 sits on the hub segment (Et0/0) alongside PC1 and PC2. Same ping, same instant, two different vantage points — that contrast *is* the lesson. Run `tcpdump` on both at once in Step 2 and watch them disagree about what they can see.

**SW1 port map:**

| Port | Connects to | Notes |
|---|---|---|
| Et0/0 | H1 (hub uplink) | Carries PC1, PC2, and KALI2 traffic |
| Et0/1 | PC3 | Dedicated switch port |
| Et0/2 | KALI | Dedicated switch port — limited visibility, by design |
| Et0/3 | R1 | Uplink to router |
| Et0/4 | *(spare)* | Unused |

> **Note on interface naming:** commands below use the `Et0/x` shorthand. If your switch shows `GigabitEthernet0/x` instead, use `Gi0/x` in place of `Et0/x` throughout.

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

The MAC table shows you the exact boundary of each collision domain, just by reading it.

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
$md$
WHERE lab_id = 15 AND phase = 'build';
