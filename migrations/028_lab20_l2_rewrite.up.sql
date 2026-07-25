-- 028_lab20_l2_rewrite.up.sql
-- Lab 20 rewritten to match its real (L2 IOU + single router) topology:
--  * SVI/ip-routing on the switch (invalid on IOU L2) -> router-on-a-stick on R1
--  * phantom R2/PC2/PC3 nodes removed; VLAN20 host is Kali (the attacker)
--  * interface names mapped to real ports: PC1=Et0/1, Kali=Et0/2, R1 trunk=Et0/3
-- NOTE: changes lab pedagogy (drops the L3-switch/SVI lesson). Re-run the attack
-- phase in GNS3 to confirm the DTP trunk negotiation still demonstrates on Et0/2.
BEGIN;
UPDATE lab_phases SET content = $nb20build$
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
 switchport mode access
 switchport access vlan 10
!
interface Et0/2
 description KALI-VLAN20
 switchport mode access
 switchport access vlan 20
!
interface Et0/3
 description TRUNK-TO-R1
 switchport mode trunk
 switchport trunk allowed vlan 10,20
end
```

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
$nb20build$ WHERE lab_id=20 AND phase='build';
UPDATE lab_phases SET content = $nb20attack$
<div class="mission"><span class="tag">◈ MISSION</span><h3>Break the interface through misconfiguration</h3><p>Interface attacks: (1) duplex mismatch — force half-duplex on one side while the other is full-duplex, causing collisions and packet loss, (2) DTP spoofing — negotiate the port into trunk mode from an attacker's device to receive all VLAN traffic, (3) port flapping — rapidly toggle the port to trigger STP reconvergence.</p></div>

<div class="stats"><span class="chip xp">✦ 500 XP</span><span class="chip diff">◆ Intermediate</span><span class="chip time">◷ ~25 min</span><span class="chip loot">⬡ Duplex mismatch · DTP spoof · Port flap · interface errors</span></div>

## Attack 1 — Duplex mismatch

From Kali, force half-duplex:
```
sudo ethtool -s eth0 duplex half
```

SW1 (on Kali's access port) is still full-duplex. The mismatch causes:
- Late collisions on the half-duplex side
- CRC errors on the full-duplex side
- Severe packet loss (50%+)

Check on SW1:
```
show interfaces Et0/2
```

The output shows `1000Mb/s, Half-duplex` and rising error counters:
- `runts`, `giants`, `CRC`, `frame` on the full side
- `late collisions`, `excessive collisions` on the half side

## Attack 2 — DTP spoof (VLAN hopping)

Kali sends a DTP frame requesting trunk mode:
```
sudo yersinia dtp -attack 1 -interface eth0
```

If the switch port is configured as `dynamic desirable` or `dynamic auto`, it converts to trunk mode. Kali now receives traffic from ALL VLANs.

Check on SW1:
```
show interfaces Et0/2 trunk
```

If successful, Et0/2 shows up as a trunk carrying all active VLANs.

<div class="callout warn"><p><strong>DTP is ON by default</strong> on Cisco switches. Every access port left in dynamic mode is a potential trunk negotiation target. Always set <code>switchport mode access</code> explicitly.</p></div>

## Attack 3 — Port flapping (DoS)

Toggle Kali's interface rapidly:
```
for i in $(seq 1 100); do
  sudo ip link set eth0 down && sleep 0.5 && sudo ip link set eth0 up && sleep 0.5
done
```

On SW1:
```
show logging | include Link
```

Each link state transition generates a log message and triggers STP recalculation. Too many flaps can spike the switch CPU.

<div class="achievement"><span class="medal">🔌</span><span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">Interface Saboteur — you broke the link three ways</span></span></div>
$nb20attack$ WHERE lab_id=20 AND phase='attack';
UPDATE lab_phases SET content = $nb20harden$
<div class="mission"><span class="tag">◈ MISSION</span><h3>Lock every port down</h3><p>Interface hardening: set all ports explicitly to access or trunk (disable DTP dynamically), hardcode duplex and speed on critical links, enable errdisable recovery, storm-control for broadcast storms.</p></div>

<div class="stats"><span class="chip xp">✦ 250 XP</span><span class="chip diff">◆ Beginner</span><span class="chip time">◷ ~15 min</span><span class="chip loot">⬡ Explicit mode · storm-control · errdisable · CDP/LLDP</span></div>

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

`switchport nonegotiate` stops DTP frames entirely — no trunk negotiation, period.

## Step 2 — Storm-control

```
configure terminal
interface Et0/3
 storm-control broadcast level 50
 storm-control multicast level 70
 storm-control action shutdown
end
```

If broadcast/multicast traffic exceeds these thresholds, the port shuts down instead of forwarding the storm.

## Step 3 — Hardcode speed/duplex on trunks

```
configure terminal
interface Et0/3
 speed 1000
 duplex full
end
```

No negotiation, no mismatch.

## Step 4 — Verify

```
show interfaces status
show interfaces trunk
show storm-control
show interfaces Et0/3 | include negotiations
```

The DTP attack no longer works (nonegotiate). The duplex mismatch is impossible (both sides hardcoded). Port flaps are logged but STP stabilises quickly.

<div class="achievement"><span class="medal">🛡️</span><span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">Interface Warden — every port is explicit, hardened, and monitored</span></span></div>
$nb20harden$ WHERE lab_id=20 AND phase='harden';
COMMIT;