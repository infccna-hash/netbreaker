-- Rollback for 047_lab15_kali2_hub — restores exact prior (post-046) build content

UPDATE lab_phases SET
  content = $md$




<div class="callout info"><p><strong>Lab mindset:</strong> assume the implementation may be wrong. Prove otherwise. Observe packets, inspect tables, and trust evidence over assumptions — every claim in this lab is something you can check yourself with a command, not something to take on faith.</p></div>

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

Now compare this to what a hub does: the hub segment (H1) puts PC1 and PC2 in a single collision domain — any transmission from either one is repeated out every other port on the hub. Nothing escapes to the switch-side devices unless the switch itself decides to forward it onward.

> **Collision domain:** A hub places every connected device into ONE shared collision domain — any transmission is repeated to every other port. A switch creates a SEPARATE collision domain per port — traffic goes only where it's addressed.

---

## Step 3 — Observe switch behaviour via the MAC table

On SW1:
```
show mac address-table
```

Look at the port column. PC1 and PC2 each have their own MAC address, but both entries point to **Et0/0** — because the switch sees the hub as a single attachment point, so anything behind it is only ever "somewhere off Et0/0" as far as the switch's forwarding table is concerned. PC3 and KALI, by contrast, each have their **own dedicated port entry** (Et0/1, Et0/2) — proof the switch is tracking each of them individually, down to the exact port.

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
```

The **ARP Request** is a broadcast frame — it reached KALI even though KALI had nothing to do with the PC1↔PC2 conversation. Every device on the 192.168.1.0/24 LAN received this ARP broadcast: PC2, PC3, R1, and KALI.

The **ARP Reply**, on the other hand, is a **unicast** frame sent only toward the port where the switch already learned PC1's MAC (Et0/0). Unlike the broadcast Request, KALI's tcpdump normally will **not** show this reply — promiscuous mode only controls what KALI's NIC accepts off the wire, it does not make the switch deliver someone else's unicast traffic to KALI's port. If you don't see the Reply on KALI, that's the switch working correctly, not a capture failure.

> **Broadcast domain:** All devices that receive a Layer-2 broadcast frame from any other device. In this topology, PC1, PC2, PC3, KALI, SW1, and R1's Et0/0 are all in the same broadcast domain. ARP requests reach everyone — replies don't.

<div class="callout aha"><p><strong>Aha moment:</strong> You're on the same switch as everyone else, in promiscuous mode, actively capturing every frame that reaches your NIC. You saw the ARP Request. You did not see the Reply. Nothing was hidden from you — nothing reached you. A hub would have handed you both frames, no exceptions, because a hub doesn't decide anything. A switch decided, and that decision is invisible to you unless you're the one it was addressed to. "I'm plugged into the network" and "I can see the traffic" are not the same claim — the gap between them is what every VLAN, every ACL, and every segmentation strategy in this course is actually betting on.</p></div>

Now think about what happens if PC1 tries to reach a device on a DIFFERENT subnet — say, R1's Et0/1 configured as 10.0.0.1/24. PC1's ARP request for its default gateway (192.168.1.1) stays local — R1 answers because its Et0/0 is on the same LAN. But if PC1 tried to ARP for 10.0.0.2 directly, no device on this LAN would answer — the broadcast stops at the router boundary. **Routers do not forward broadcasts between subnets.**

---

## Step 5 — Why is FW1 here?

FW1 sits behind R1 in this topology but nothing you've done so far has touched it — that's deliberate for this lab: an edge firewall's whole job is to sit at a boundary and do nothing to traffic that isn't crossing it. A router forwards based on destination network; a firewall additionally decides whether that forwarding should be *allowed*, based on policy rather than just reachability.

This step is observational, not graded — there's no automated check on FW1 in this lab. If you want to explore further: from R1, confirm you can reach FW1's inside interface, then look at what a default-deny firewall policy would mean for the traffic you generated in Steps 2–4 above. (Configuring and testing that policy is Lab 30's territory, not this one — here, just knowing *why* a firewall belongs on this boundary is the point.)

---

## 🏗️ Achievement Unlocked
**Layer 2 Explorer** — you can read a MAC table, tell a broadcast domain from a collision domain, and explain what a switch does and doesn't forward




$md$
WHERE lab_id = 15 AND phase = 'build';
