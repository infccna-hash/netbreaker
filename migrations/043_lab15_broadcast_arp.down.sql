-- Rollback: restore the original Step 4 with ping 192.168.1.255.
-- Note: this restores the VPCS-incompatible instruction; this migration
-- exists for rollback completeness, not because the old content is correct.
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
