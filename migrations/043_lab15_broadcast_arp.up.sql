-- Migration 043: Fix Lab 15 Step 4 — VPCS broadcast limitation
--
-- VPCS 0.8.3 (the version running in this GNS3 environment) does not
-- support broadcast ICMP echo — both `ping 255.255.255.255` and
-- `ping 192.168.1.255` fail silently. Since Step 4's entire
-- educational objective (understanding broadcast domain vs router
-- boundary) depends on observing broadcast traffic, the instruction
-- is rewritten to use ARP requests — real broadcast frames
-- (ff:ff:ff:ff:ff:ff) that VPCS does generate and that tcpdump can
-- capture reliably.
--
-- The new Step 4:
--  1. KALI runs `tcpdump -i eth0 -nn arp`
--  2. PC1 clears its ARP cache and pings PC2
--  3. KALI captures the ARP request — proof that Layer-2 broadcasts
--     reach every device on the LAN, including non-targets
--  4. The router-as-broadcast-boundary concept is illustrated by
--     explaining that ARP requests never cross R1
--
-- Pedagogical advantage over the original ping-broadcast approach:
--  ARP requests ARE genuine broadcast frames — they use destination
--  MAC ff:ff:ff:ff:ff:ff by definition — so the student observes
--  real broadcast behaviour rather than an ICMP echo-to-broadcast
--  (which many platforms filter). Combined with Step 2's tcpdump
--  (which shows unicast traffic NOT reaching KALI), the student now
--  has direct evidence of both selective forwarding (Step 2) and
--  broadcast flooding (Step 4), all from the same observer position.
UPDATE lab_phases SET content = $md$
## Step 1 — Assign IP addresses

On **every host**, assign IPs from the 192.168.1.0/24 block:

| Host | IP | Default Gateway |
|---|---|---|
| PC1 | 192.168.1.10 | 192.168.1.1 |
| PC2 | 192.168.1.20 | 192.168.1.1 |
| PC3 | 192.168.1.30 | 192.168.1.1 |
| KALI | 192.168.1.100 | 192.168.1.1 |

**VPCS nodes** (PC1, PC2, PC3):
```
ip 192.168.1.X 255.255.255.0 192.168.1.1
save
```

**KALI:**
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

## Step 4 — Observe broadcast domain via ARP

Every IP communication starts with an ARP request — and ARP requests are **broadcast frames** (destination MAC: `ff:ff:ff:ff:ff:ff`). They reach every device on the LAN, not just the target. You can watch this live.

On **KALI**, start capturing only ARP traffic:
```
sudo tcpdump -i eth0 -nn arp
```

On **PC1**, clear the ARP cache so PC1 is forced to send a fresh ARP request, then ping PC2 once:
```
clear arp
ping 192.168.1.20 -c 1
```

Look at KALI's tcpdump output. You'll see something like:

```
ARP, Request who-has 192.168.1.20 tell 192.168.1.10, length 46
ARP, Reply 192.168.1.20 is-at 00:50:79:66:68:01, length 46
```

The **ARP Request** is a broadcast frame — it reached KALI even though KALI had nothing to do with the PC1↔PC2 conversation. Every device on the 192.168.1.0/24 LAN received this ARP broadcast: PC2, PC3, R1, and KALI.

The **ARP Reply** is a unicast — PC2 responds directly to PC1. KALI captured it too (promiscuous tcpdump), but the switch forwards it ONLY to the port PC1 is on (Et0/0, through the hub).

> **Broadcast domain:** All devices that receive a Layer-2 broadcast frame from any other device. In this topology, PC1, PC2, PC3, KALI, SW1, and R1's Et0/0 are all in the same broadcast domain. ARP requests reach everyone.

Now think about what happens if PC1 tries to reach a device on a DIFFERENT subnet — say, R1's Et0/1 configured as 10.0.0.1/24. PC1's ARP request for its default gateway (192.168.1.1) stays local — R1 answers because its Et0/0 is on the same LAN. But if PC1 tried to ARP for 10.0.0.2 directly, no device on this LAN would answer — the broadcast stops at the router boundary. **Routers do not forward broadcasts between subnets.**

---

## 🏗️ Achievement Unlocked
**Network Architect** — you understand the four pillars of every network

$md$
WHERE lab_id = 15 AND phase = 'build';
