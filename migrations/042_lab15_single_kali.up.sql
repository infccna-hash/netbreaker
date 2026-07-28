-- ═══════════════════════════════════════════════════════
-- Lab 15 — Remove KALI2, single-Kali topology (8 nodes)
-- ═══════════════════════════════════════════════════════

UPDATE lab_phases SET
  content = $md$
# LAB 15 · fundamentals · easy

## Network Devices & Anatomy
📖 Maps to Vol 1 · Ch 2

Identify every device on the wire and what breaks when you get its role wrong.

---

## Topology

See `Lab15Topology.tsx` / `lab-15-topology.svg` for the rendered diagram.

**Cabling (fixed for the entire session — no rewiring required):**
- PC1 + PC2 → H1 (hub) → SW1 (Et0/0)
- PC3 → SW1 (Et0/1)
- KALI → SW1 (Et0/2) — observer / sniffer
- SW1 (Et0/3) → R1
- R1 → FW1
- Et0/4 — spare, unused

**SW1 port map:**

| Port | Connects to | Notes |
|---|---|---|
| Et0/0 | H1 (hub uplink) | Carries PC1 and PC2 traffic |
| Et0/1 | PC3 | Dedicated switch port |
| Et0/2 | KALI | Observer — limited visibility by design |
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
| KALI | Observer / sniffer | Kali Linux |

### Objectives
- Understand the role of each device in a network
- Observe collision domains (hub) vs separate collision domains (switch)
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

On R1:
```
enable
configure terminal
interface Et0/0
 ip address 192.168.1.1 255.255.255.0
 no shutdown
end
```

---

## Step 2 — Observe hub behaviour

From PC1, ping PC2 continuously:
```
ping 192.168.1.20 -t
```

On **KALI** (switch-side observer):
```
sudo tcpdump -i eth0 -nn
```

KALI is on a switch port — it sees only its own traffic and broadcasts. The PC1↔PC2 exchange stays on the hub segment and never reaches KALI because the switch learned exactly which port each MAC lives on and forwards selectively.

Now compare this to what a hub does: the hub segment (H1) shares PC1 and PC2 in a single collision domain — every frame from PC1 reaches PC2 and vice versa, but nothing escapes to the switch-side devices unless the switch decides to forward it.

> **Collision domain:** A hub creates a SINGLE collision domain — every port repeats every frame to every other port. A switch creates a SEPARATE collision domain per port — traffic goes only where it's addressed.

---

## Step 3 — Observe switch behaviour via the MAC table

On SW1:
```
show mac address-table
```

Look at the port column. PC1 and PC2 both resolve to the **same port — Et0/0** — because they both sit behind the hub; the switch has no way to tell them apart at Layer 2 below that single uplink. PC3 and KALI, by contrast, each have their **own dedicated port entry** (Et0/1, Et0/2) — proof the switch is tracking each of them individually.

---

## Step 4 — Observe router as broadcast boundary

From PC1, ping the broadcast address:
```
ping 192.168.1.255
```

The broadcast reaches all devices on the 192.168.1.0/24 LAN — including KALI, PC2, and PC3. Now configure a second subnet behind R1 and verify the broadcast does NOT cross the router — routers stop broadcasts at the interface boundary.

---

## 🏗️ Achievement Unlocked
**Network Architect** — you understand the four pillars of every network

$md$
WHERE lab_id = 15 AND phase = 'build';
