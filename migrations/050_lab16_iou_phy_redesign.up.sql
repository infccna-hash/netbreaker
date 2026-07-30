-- 050_lab16_iou_phy_redesign.up.sql
--
-- Lab 16 (Cabling & Connectors) was written around three PHY-layer
-- mechanics that IOU does not simulate, confirmed experimentally
-- (2026-07-30) on both IOU L2 and IOU L3 images:
--
--   * `mdix auto`            -> "Invalid input detected" on both images
--   * `duplex full/half`     -> accepted but never reflected in
--                              `show interfaces` (always "Auto-duplex")
--   * `speed 10/100/1000`    -> same: accepted, never reflected
--   * cable-type (straight-through vs crossover) -> no such concept
--     exists on a virtual GNS3 link; there is no copper to miswire
--
-- None of these can back a console-truth verifier. `shutdown`/`no shutdown`
-- is the one interface-state primitive that IS real and observable on
-- IOU, so it replaces cable-type as the Build-phase fault, and replaces
-- "disconnect the cable" as the Attack-3 fault.
--
-- Also fixes: Attack-3 referenced "PC3" / 192.168.1.30, neither of
-- which exist in lab16_topology.go (PC1, PC2, SW1, SW2, R1, KALI only).
--
-- Harden phase adds a recovery step (no shutdown Et0/0) so the verifier's
-- ExpectInterfaceUp("Et0/0") won't structurally fail for every student.

BEGIN;

UPDATE labs
SET short_desc = 'Straight-through vs. crossover vs. rollover — then diagnose and fix a physical-layer fault using nothing but interface state.'
WHERE id = 16;

-- BUILD
UPDATE lab_phases SET
  title = 'Cable the Physical Layer',
  content = $md$
<div class="mission">
<span class="tag">◈ MISSION</span>
<h3>Wire it right or it won't work at all</h3>
<p>Ethernet cables look identical but serve different purposes: straight-through connects unlike devices (PC→switch), crossover connects like devices (switch→switch), and rollover connects to a console port for management. Using the wrong cable type is the most common physical-layer mistake — and the easiest to fix once you know the difference.</p>
</div>

<div class="stats">
<span class="chip xp">✦ 200 XP</span>
<span class="chip diff">◆ Beginner</span>
<span class="chip time">◷ ~20 min</span>
<span class="chip loot">⬡ Straight-through · Crossover · Rollover · MDIX · Pinout</span>
</div>

## The topology

| Device | Role | Connection |
|---|---|---|
| SW1–SW2 | Two switches | Direct inter-switch link |
| PC1–PC2 | End hosts | Straight-through to their switch |
| R1 | Router | Console access (see Step 4) |
| KALI | Observer | Connected to SW2 |

## Objectives

<ul class="tool-objectives">
<li>Identify the three cable types and when to use each</li>
<li>Bring the SW1↔SW2 link down and confirm it from the interface state</li>
<li>Restore the link and confirm it's back up</li>
</ul>

## Step 1 — Identify cable types

| Cable | Wiring | Use |
|---|---|---|
| Straight-through | Both ends identical (T568A/T568B) | PC ↔ Switch, Router ↔ Switch |
| Crossover | Transmit/receive swapped | Switch ↔ Switch, PC ↔ PC |
| Rollover | Fully reversed | Console port (RJ-45 to DB9 or USB) |

<div class="callout info">
<p><strong>Historically</strong>, a switch-to-switch link needed a crossover cable — a straight-through cable leaves both ends transmitting on the same pins, and the link never comes up. Modern switches ship with <strong>auto-MDIX</strong>, which detects this and corrects it in hardware, so a straight-through cable works everywhere today. This is explained here rather than demonstrated: GNS3/IOU links are virtual and don't model copper pinout, so there's no "wrong cable" state to reproduce, and IOU's CLI itself doesn't accept <code>mdix auto</code> — that reasoning has to stay conceptual on this platform.</p>
</div>

## Step 2 — Break the link and read the fault from the interface

The fault this lab actually puts in front of you is simpler and just as real: an interface that's down. On SW1:

```
configure terminal
interface et0/2
 shutdown
end
```

Check it:

```
show interfaces et0/2
```

The interface reads <code>administratively down, line protocol is down</code> — the switch was told to disable this port, and it's the very first thing any real troubleshooting session checks, cable type included.

## Step 3 — Bring it back up

```
configure terminal
interface et0/2
 no shutdown
end
```

```
show interfaces et0/2
```

The interface returns to <code>up, line protocol is up</code>. In a real network, a link that unexpectedly reads "administratively down" almost always means someone (or some script) shut it down — checking `shutdown` state costs nothing and rules out a whole category of "is it the cable?" guesswork before you ever touch a patch panel.

## Step 4 — Console access (concept)

<div class="callout info">
<p>A <strong>rollover cable</strong> connects to a device's console port for out-of-band management — the one connection that works even when the network itself is down. In the physical world this is a serial (RJ-45-to-DB9 or RJ-45-to-USB) connection at 9600 baud. <strong>In GNS3, console access is virtual</strong> (right-click a device → Console) — there's no serial adapter to plug in, so this step is explained rather than exercised. Recognizing the real-world equivalent is the objective here, not reproducing the cable.</p>
</div>

<div class="achievement">
<span class="medal">🏗️</span>
<span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">Cable Master — you know the wire, the pinout, and the fix</span></span>
</div>
$md$
WHERE lab_id = 16 AND phase = 'build';

-- ATTACK
UPDATE lab_phases SET
  title = 'Tamper with the Physical Layer',
  content = $md$
<div class="mission">
<span class="tag">◈ MISSION</span>
<h3>Physical access = full compromise</h3>
<p>If an attacker gains physical access to a wiring closet, the network is theirs. Three physical-layer attacks: (1) rogue device tap — plug a hub/Kali between two legitimate devices, (2) console access — if the console port is left in default config, the attacker configures the router without a password, (3) cable disconnection — simple DoS by pulling the right plug.</p>
</div>

<div class="stats">
<span class="chip xp">✦ 400 XP</span>
<span class="chip diff">◆ Beginner</span>
<span class="chip time">◷ ~20 min</span>
<span class="chip loot">⬡ Physical tap · Console hijack · Cable DoS</span>
</div>

<div class="callout danger">
<p><strong>Lab only.</strong> Physical attacks require PHYSICAL ACCESS. In the real world, lock your wiring closet and secure console ports. This lab demonstrates WHY those precautions exist.</p>
</div>

## Objectives

<ul class="tool-objectives">
<li>Understand how a physical tap intercepts traffic between two legitimate devices</li>
<li>Access R1's console with default settings — full admin access without password</li>
<li>Take down a host's link with nothing but physical (interface) access</li>
</ul>

## Attack 1 — Physical tap (concept)

<div class="callout info">
<p>An attacker with physical access to a wiring closet can splice in a hub or a device like Kali between two legitimate devices — <strong>Kali eth0 → SW1, Kali eth1 → SW2</strong> — enable IP forwarding, and every packet between SW1 and SW2 now transits Kali first, invisibly, before continuing on. This is explained conceptually rather than exercised here: reproducing it needs the attacker's device wired inline between SW1 and SW2, which means re-cabling the topology itself — not something a browser-only console session can do. (A switch feature like SPAN could show similar traffic, but it requires admin credentials on the switch already, which is a different threat model than "physical access with none" — this lab stays honest about that distinction rather than blur it.)</p>
</div>

## Attack 2 — Console hijack

Connect to R1's console port (simulated in GNS3):
- In GNS3, right-click R1 → Console
- If no console password is set, you get privileged EXEC mode immediately

```
R1>enable
R1#show running-config
```

Full access to the running config — including passwords (encrypted or not).

## Attack 3 — Interface DoS

Identify the interface connecting PC1 to SW1. Shut it down:

```
configure terminal
interface et0/0
 shutdown
end
```

PC1 disappears from the network — a single disabled port takes down a host exactly the way a pulled cable would; from the network's point of view, the two are indistinguishable.

<div class="callout warn">
<p><strong>Mitigation:</strong> Port-security detects disconnected/reconnected ports with different MACs. Console ports MUST have a password: <code>line con 0 → password NetBreakerLab → login</code>. Locked wiring closets with RFID access logs are the physical-layer gold standard.</p>
</div>

<div class="achievement">
<span class="medal">🔌</span>
<span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">Wiring Closet Bandit — you owned the network through its weakest link: the cable</span></span>
</div>
$md$
WHERE lab_id = 16 AND phase = 'attack';

-- HARDEN — prepend recovery step (Attack-3 leaves Et0/0 down)
UPDATE lab_phases SET
  content = $prepend$
<div class="mission">
<span class="tag">🔧 RECOVERY</span>
<h3>Restore the link first</h3>
<p>Before you lock anything down, undo the damage — bring PC1's port back up:</p>

```
configure terminal
interface et0/0
 no shutdown
end
```

```
show interfaces et0/0 | include line protocol
```

<p>The interface returns to <code>up, line protocol is up</code>. You can't secure a port that's still down from the last attack.</p>
</div>

$prepend$ || content
WHERE lab_id = 16 AND phase = 'harden';

COMMIT;
