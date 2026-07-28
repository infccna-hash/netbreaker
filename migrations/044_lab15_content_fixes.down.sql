-- Rollback for 044_lab15_content_fixes — restores exact prior content

UPDATE lab_phases SET
  content = $md$

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

UPDATE lab_phases SET
  content = $md$

<div class="mission"><span class="tag">◈ MISSION</span><h3>Diagnose misconfigurations and device-level failures</h3><p>Networks fail at the device level in predictable ways: wrong cable type, disabled port, duplex mismatch, speed mismatch. Your mission: identify four deliberate faults placed in the topology and fix them using CLI tools and physical inspection.</p></div>

<div class="stats"><span class="chip xp">✦ 400 XP</span><span class="chip diff">◆ Beginner</span><span class="chip time">◷ ~25 min</span><span class="chip loot">⬡ Troubleshooting · duplex · speed · shutdown</span></div>

## The four faults

Each fault disconnects a path between two devices. Your task: find them all.

| Fault | Symptom | Tool |
|---|---|---|
| **Fault 1** — Shutdown port | A port is administratively down | `show interfaces status` |
| **Fault 2** — Duplex mismatch | One side full, other half | `show interfaces` |
| **Fault 3** — Speed mismatch | 100 on one side, 10 on the other | `show interfaces` |
| **Fault 4** — Wrong cable | Straight-through instead of crossover | Visual or `show interfaces` |

## Step 1 — Isolate the faults

From KALI, run a sweep:
```
for ip in 192.168.1.{10,20,30,1}; do echo -n "$ip: "; fping -c 3 $ip 2>&1 | tail -1; done
```

Note which IPs are unreachable.

## Step 2 — Diagnose each fault

On SW1:
```
show interfaces status
show interfaces Et0/0
show interfaces Et0/2
```

Look for: `err-disabled`, `shutdown`, `half-duplex`, `10M` where you expect `100M` or `1G`.

<div class="callout tip"><p>Duplex mismatch is the most common real-world fault. One side shouts (full-duplex talking anytime) while the other listens half the time (half-duplex). Result: massive frame errors on the full-duplex side and late collisions on the half-duplex side.</p></div>

## Step 3 — Fix each fault

Fault 1 (shutdown port):
```
configure terminal
interface Et0/X
 no shutdown
end
```

Fault 2 (duplex):
```
configure terminal
interface Et0/X
 duplex full
end
```

Fault 3 (speed):
```
configure terminal
interface Et0/X
 speed 100
end
```

Fault 4 (cable): Swap the cable or use a crossover cable / MDIX.

## Step 4 — Verify

Re-run the ping sweep. All IPs should respond.

Check for errors:
```
show interfaces Et0/X | include errors
```

All error counters should be 0.

<div class="achievement"><span class="medal">🔧</span><span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">Device Doctor — you diagnosed and fixed four hardware-layer faults</span></span></div>

$md$
WHERE lab_id = 15 AND phase = 'attack';

UPDATE lab_phases SET
  content = $md$

<div class="mission"><span class="tag">◈ MISSION</span><h3>Prevent device-layer failures before they happen</h3><p>Harden the network against device-level issues: enable CDP/LLDP for inventory, configure interface descriptions, set duplex/speed explicitly (don't trust autonegotiation on critical links), enable errdisable auto-recovery, and document everything.</p></div>

<div class="stats"><span class="chip xp">✦ 200 XP</span><span class="chip diff">◆ Beginner</span><span class="chip time">◷ ~15 min</span><span class="chip loot">⬡ Interface docs · errdisable recovery · autonegotiation</span></div>

## Objectives

<ul class="tool-objectives">
<li>Document every interface with descriptions</li>
<li>Set duplex/speed explicitly on trunk links</li>
<li>Enable errdisable auto-recovery</li>
<li>Create a network diagram baseline</li>
</ul>

## Step 1 — Document interfaces

On SW1:
```
configure terminal
interface Et0/0
 description LINK-TO-HUB-PC1-PC2
interface Et0/2
 description LINK-TO-KALI
interface Et0/3
 description UPLINK-TO-R1
end
```

## Step 2 — Explicit duplex/speed on trunks

```
configure terminal
interface Et0/3
 speed 1000
 duplex full
end
```

## Step 3 — Errdisable auto-recovery

```
configure terminal
errdisable recovery cause all
errdisable recovery interval 300
end
```

When a port err-disables (from port-security, BPDU guard, etc.), it automatically recovers after 5 minutes.

## Step 4 — Baseline verification

```
show running-config | include description
show interfaces description
show errdisable recovery
```

Save the output as your network baseline. Compare it against future outputs to detect unauthorised changes.

<div class="achievement"><span class="medal">🛡️</span><span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">Foundation Guardian — your devices are documented, hardened, and monitored</span></span></div>

$md$
WHERE lab_id = 15 AND phase = 'harden';
