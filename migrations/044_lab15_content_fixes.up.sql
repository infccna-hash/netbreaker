-- ═══════════════════════════════════════════════════════════════════
-- Lab 15 (Network Devices & Anatomy) — content fixes, 2026-07-28
--
-- Two independent problems found during a full lab-by-lab content
-- review, fixed together:
--
-- 1. STRUCTURAL (content <-> verifier mismatch): the Attack phase's
--    "four faults" narrative (shutdown / duplex / speed / wrong
--    cable) predates the console-truth verifier rewrite. The
--    verifier (lab15_verify.go) checks four DIFFERENT things —
--    ExpectInterfaceUp on Et0/0-3 and ExpectPortVLAN(Et0/1, 1) — with
--    a code comment explaining duplex/speed checks were dropped
--    because IOU L2 genuinely can't surface them (confirmed via real
--    captures, not a preference). The Attack phase content was never
--    updated to match, so following it exactly does not fix what's
--    actually being graded. Harden phase content was already correct
--    on the two points where the verifier was stale (Et0/0
--    description, errdisable interval) — see the Go-side fix in the
--    same commit — but was missing instructions for Et0/1 and Et0/4,
--    which the verifier has always checked.
--
-- 2. ACCURACY (content is wrong regardless of verifier): Build
--    phase Step 4 contradicted itself — it claimed KALI's
--    promiscuous tcpdump captures the ARP reply (a unicast) while
--    also correctly stating the switch forwards that same unicast
--    "ONLY to the port PC1 is on." Both can't be true; a switch's
--    unicast forwarding is not affected by promiscuous mode on the
--    receiving NIC. Also: Attack phase's "wrong cable" fault has no
--    real analogue on a GNS3 virtual link (no cable-type simulation
--    exists), and FW1 sits in the topology fully unused across all
--    three phases.
-- ═══════════════════════════════════════════════════════════════════

-- ─────────────────────────── BUILD ───────────────────────────
-- Fixes: (a) self-contradicting ARP-reply explanation in Step 4,
-- (b) adds a short, non-verified FW1 note so it's not purely
-- decorative, (c) renames the achievement (was "Network Architect" —
-- overclaims what an intro anatomy lab teaches).
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

-- ─────────────────────────── ATTACK ───────────────────────────
-- Full rewrite. Old narrative (shutdown/duplex/speed/cable) replaced
-- with the four faults the verifier actually checks: Et0/0 shutdown,
-- Et0/1 wrong VLAN, Et0/2 port-security err-disable, Et0/3 shutdown.
-- Zero new DSL primitives needed — ExpectInterfaceUp x4 and
-- ExpectPortVLAN(Et0/1, 1) already existed; this only fixes what the
-- content teaches to match what was already being graded.
UPDATE lab_phases SET
  content = $md$

<div class="mission"><span class="tag">◈ MISSION</span><h3>Diagnose misconfigurations and device-level failures</h3><p>Networks fail at the device level in predictable ways: a port left shut down, a host dropped in the wrong VLAN, a port-security violation nobody noticed. Your mission: find and fix four deliberate faults using CLI tools only.</p></div>

<div class="stats"><span class="chip xp">✦ 400 XP</span><span class="chip diff">◆ Beginner</span><span class="chip time">◷ ~25 min</span><span class="chip loot">⬡ Troubleshooting · VLANs · port-security · shutdown</span></div>

## The four faults

Each fault disconnects or misroutes a path between two devices. Your task: find them all.

| Fault | Symptom | Tool |
|---|---|---|
| **Fault 1** — Shutdown port (Et0/0, hub segment) | PC1/PC2 unreachable | `show interfaces status` |
| **Fault 2** — Wrong VLAN (Et0/1, PC3) | PC3 unreachable even though the port is up | `show vlan brief` |
| **Fault 3** — Port-security violation (Et0/2, KALI) | Port is err-disabled | `show interfaces status`, `show errdisable recovery` |
| **Fault 4** — Shutdown port (Et0/3, uplink to R1) | Everything behind SW1 loses its gateway | `show interfaces status` |

## Step 1 — Isolate the faults

From KALI, run a sweep:
```
for ip in 192.168.1.{10,20,30,1}; do echo -n "$ip: "; fping -c 3 $ip 2>&1 | tail -1; done
```

Note which IPs are unreachable — that tells you which side of the topology to check first.

## Step 2 — Diagnose each fault

On SW1:
```
show interfaces status
show vlan brief
show errdisable recovery
```

Look for: an interface listed `disabled` (administratively shut) or `err-disabled`, and PC3's port sitting in the wrong VLAN in the `show vlan brief` output.

<div class="callout tip"><p>Port-security violations are one of the most common real triggers for err-disable in production — a port learns more MACs than its configured maximum (or the "wrong" MAC on a sticky port) and shuts itself down rather than fail open. That's not a hardware fault, it's the switch doing exactly what it was told.</p></div>

## Step 3 — Fix each fault

Fault 1 (Et0/0 shut down):
```
configure terminal
interface Et0/0
 no shutdown
end
```

Fault 2 (PC3 in the wrong VLAN):
```
configure terminal
interface Et0/1
 switchport access vlan 1
end
```

Fault 3 (Et0/2 err-disabled from port-security):
```
configure terminal
interface Et0/2
 shutdown
 no shutdown
end
```

Fault 4 (Et0/3 shut down):
```
configure terminal
interface Et0/3
 no shutdown
end
```

## Step 4 — Verify

Re-run the ping sweep. All IPs should respond.
```
show interfaces status
show vlan brief
```

Confirm every port is `connected`, PC3 is back in VLAN 1, and nothing is `err-disabled`.

<div class="achievement"><span class="medal">🔧</span><span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">Device Doctor — you diagnosed and fixed four device-level faults</span></span></div>

$md$
WHERE lab_id = 15 AND phase = 'attack';

-- ─────────────────────────── HARDEN ───────────────────────────
-- Adds the two missing description commands (Et0/1, Et0/4) the
-- verifier has always checked but the content never instructed.
-- Et0/0 description and the errdisable interval were already correct
-- here — that mismatch was on the Go verifier side, fixed separately
-- in lab15_verify.go (this migration doesn't touch those two).
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

On SW1, describe every port — including the spare one. An undocumented spare port is exactly the kind of thing that gets quietly repurposed by mistake months later:
```
configure terminal
interface Et0/0
 description LINK-TO-HUB-PC1-PC2
interface Et0/1
 description LINK-TO-PC3
interface Et0/2
 description LINK-TO-KALI
interface Et0/3
 description UPLINK-TO-R1
interface Et0/4
 description SPARE-UNUSED
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
