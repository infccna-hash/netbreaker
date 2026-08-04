-- 085_lab20_build_harden_fixes.up.sql
-- Lab 20 (Interfaces & Autonegotiation) — console-truth fixes from walkthrough 2026-08-04.
--
-- Build phase:
--  1. Add bare `switchport` before every `switchport mode` (12.2 rejects with
--     "Command rejected: not a switching port" without it)
--  2. Add `no shutdown` to every interface (12.2 boots ports admin-down)
--  3. Et0/2 must be `switchport mode dynamic auto` (NOT static access) so the
--     DTP spoof attack in Attack 2 actually works — a static access port has
--     "Negotiation of Trunking: Off" and refuses yersinia's DTP frames
--  4. Et0/3 trunk needs `switchport trunk encapsulation dot1q` BEFORE
--     `switchport mode trunk` (12.2 rejects trunk while encap is "Auto")
--
-- Harden phase:
--  - Replace storm-control + speed/duplex (dead on 12.2, "Invalid input" /
--    "Autoneg enabled. Duplex cannot be set") with errdisable recovery
--    (verified working) + a callout explaining port-security/storm-control/
--    speed/duplex exist on real Cisco but not this IOU image.

UPDATE lab_phases
SET content = $md$
<div class="mission"><span class="tag">◈ MISSION</span><h3>Master interface configuration modes</h3><p>Cisco interfaces come in many flavours: access ports (one VLAN), trunk ports (many VLANs), routed ports (Layer 3), loopback (virtual), SVI (switch virtual interface), and management interfaces. Each has a specific configuration syntax and purpose. Getting it wrong means no connectivity — and troubleshooting interface issues is 50% of a network engineer's job.</p></div>

<div class="stats"><span class="chip xp">✦ 300 XP</span><span class="chip diff">◆ Beginner</span><span class="chip time">◷ ~30 min</span><span class="chip loot">⬡ Access · Trunk · Routed · Loopback · SVI · Management</span></div>

## The topology

| Device | Interfaces | Role |
|---|---|---|
| SW1 | Et0/1–2 (access), Et0/3 (trunk) | L2 switch |
| R1 | Fa0/0 (802.1Q trunk), Lo0 (loopback) | Router |
| PC1 · Kali | VLAN 10 access · VLAN 20 access (attacker) | End host · attacker |

## Objectives

<ul class="tool-objectives">
<li>Configure access ports, trunk ports, and routed ports</li>
<li>Create a loopback interface and inter-VLAN routing (router-on-a-stick)</li>
<li>Troubleshoot common interface issues (shutdown, no negotiation, wrong mode)</li>
</ul>

## Step 1 — Access and trunk ports

On SW1:
```
configure terminal
interface Et0/1
 description PC1-VLAN10
 switchport
 switchport mode access
 switchport access vlan 10
 no shutdown
!
interface Et0/2
 description KALI-VLAN20
 switchport
 switchport mode dynamic auto
 switchport access vlan 20
 no shutdown
!
interface Et0/3
 description TRUNK-TO-R1
 switchport
 switchport trunk encapsulation dot1q
 switchport mode trunk
 switchport trunk allowed vlan 10,20
 no shutdown
end
```

Notes:
- The bare `switchport` command enables Layer 2 switching on the port first — without it, the switch refuses `switchport mode` with `Command rejected: not a switching port`.
- `no shutdown` brings the port up — the image boots all ports administratively down.
- `switchport trunk encapsulation dot1q` must come before `switchport mode trunk` — this image refuses trunk mode while the encapsulation is still "Auto".
- Et0/2 is left in `dynamic auto` (not static access) on purpose — you'll see why in Attack 2.

## Step 2 — Inter-VLAN routing (router-on-a-stick)

SW1 is a Layer 2 switch — it can't route between VLANs on its own. R1 does the routing over the 802.1Q trunk, one sub-interface per VLAN:

On R1:
```
configure terminal
interface Fa0/0
 no shutdown
interface Fa0/0.10
 encapsulation dot1Q 10
 ip address 192.168.10.1 255.255.255.0
interface Fa0/0.20
 encapsulation dot1Q 20
 ip address 192.168.20.1 255.255.255.0
end
```

Each sub-interface is the default gateway for its VLAN. Traffic between VLAN 10 and VLAN 20 now hairpins through R1 across the trunk.

## Step 3 — Loopback interface

On R1:
```
configure terminal
interface loopback 0
 ip address 1.1.1.1 255.255.255.255
end
```

A loopback is virtual — it never goes down. Used for router ID, management, and testing.

## Step 4 — Verify

```
show interfaces description
show interfaces status
show vlan brief
show interfaces trunk
ping 1.1.1.1
```

<div class="achievement"><span class="medal">🏗️</span><span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">Interface Guru — access, trunk, SVI, loopback — all configured</span></span></div>
$md$
WHERE lab_id = 20 AND phase = 'build';

UPDATE lab_phases
SET content = $md$
<div class="mission"><span class="tag">◈ MISSION</span><h3>Lock every port down</h3><p>Interface hardening: set all ports explicitly to access or trunk (disable DTP dynamically), enable errdisable recovery so a security-shutdown port comes back by itself, and know which port-protection features exist on real Cisco hardware.</p></div>

<div class="stats"><span class="chip xp">✦ 250 XP</span><span class="chip diff">◆ Beginner</span><span class="chip time">◷ ~15 min</span><span class="chip loot">⬡ Explicit mode · nonegotiate · errdisable recovery · port-security</span></div>

## Step 1 — Hardcode interface mode

On SW1, every port must be explicitly configured:
```
configure terminal
interface range Et0/1 - 2
 switchport mode access
 switchport nonegotiate          ! Don't send DTP frames
!
interface Et0/3
 switchport mode trunk
 switchport nonegotiate
end
```

`switchport nonegotiate` stops DTP frames entirely — no trunk negotiation, period. This kills Attack 2: even if yersinia keeps blasting DTP, the port never negotiates.

## Step 2 — Errdisable recovery

Security features (port-security violations, BPDU guard, storm-control on real hardware) put a port into **errdisable** state — administratively shut down until an admin brings it back. Errdisable recovery automates that:

```
configure terminal
errdisable recovery cause all
errdisable recovery interval 300
end
```

Every errdisable cause now recovers automatically after 300 seconds (5 minutes). On a real network you would enable only the causes you care about — `cause all` is the blunt version for this lab.

## Step 3 — Port-protection features on real hardware

The IOU image in this lab implements a **subset** of Cisco's interface-hardening toolkit. On real switches you would also use:

- **`switchport port-security`** — limit how many MAC addresses a port will learn (sticky MAC). A rogue device plugging in with a different MAC gets the port shut down or the frame dropped. This image does not implement it.
- **`storm-control broadcast level 50`** — cap broadcast/multicast traffic as a percentage of interface bandwidth; exceeding the threshold shuts the port down instead of forwarding the storm. Also not in this image.
- **`speed 1000` / `duplex full`** — hardcode speed and duplex on critical links to prevent autonegotiation mismatches. This image forces autoneg and refuses both.

The concepts are CCNA-relevant and you'll configure all of them on real gear — they just can't be demonstrated here.

## Step 4 — Verify

```
show interfaces status
show interfaces trunk
show errdisable recovery
show interfaces Et0/2 switchport
```

Check that:
- Et0/2 is back to `static access` (the DTP attack no longer works)
- `show errdisable recovery` lists the causes with `Enabled`
- The trunk on Et0/3 still works (`show interfaces trunk` shows it as trunking)

<div class="achievement"><span class="medal">🛡️</span><span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">Interface Warden — every port is explicit, hardened, and monitored</span></span></div>
$md$
WHERE lab_id = 20 AND phase = 'harden';
