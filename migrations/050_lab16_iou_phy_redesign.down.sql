-- 050_lab16_iou_phy_redesign.down.sql
-- Restores Lab 16 to pre-050 state (original content, pre-redesign).
BEGIN;

UPDATE labs SET short_desc = $$SD$$ 
Copper vs. fiber, straight-through vs. crossover — then diagnose a cabling fault under time pressure.
$$SD$$ WHERE id = 16;

UPDATE lab_phases SET content = $$DOWN_build$$
<div class="mission"><span class="tag">◈ MISSION</span><h3>Wire it right or it won't work at all</h3><p>Ethernet cables look identical but serve different purposes: straight-through connects unlike devices (PC→switch), crossover connects like devices (switch→switch), and rollover connects to a console port for management. Using the wrong cable type is the most common physical-layer mistake — and the easiest to fix once you know the difference.</p></div>

<div class="stats"><span class="chip xp">✦ 200 XP</span><span class="chip diff">◆ Beginner</span><span class="chip time">◷ ~20 min</span><span class="chip loot">⬡ Straight-through · Crossover · Rollover · MDIX · Pinout</span></div>

## The topology

| Device | Role | Connection |
|---|---|---|
| SW1–SW2 | Two switches | Initially cabled wrong |
| PC1–PC2 | End hosts | Straight-through to SW1 |
| R1 | Router | Console via rollover |
| KALI | Observer | Connected to SW2 |

## Objectives

<ul class="tool-objectives">
<li>Identify the three cable types and when to use each</li>
<li>Cable a switch-to-switch link with the wrong cable — observe failure</li>
<li>Fix the link with auto-MDIX or a crossover cable</li>
<li>Access the console port with a rollover cable</li>
</ul>

## Step 1 — Identify cable types

| Cable | Wiring | Use |
|---|---|---|
| Straight-through | Both ends identical (T568A/T568B) | PC ↔ Switch, Router ↔ Switch |
| Crossover | Transmit/receive swapped | Switch ↔ Switch, PC ↔ PC |
| Rollover | Fully reversed | Console port (RJ-45 to DB9 or USB) |

## Step 2 — Wrong cable test

Cable SW1↔SW2 with a **straight-through** cable (the wrong type). On SW1:
```
show interfaces et0/2
```

The interface status shows `up/down` — Layer 1 is active but no keepalives are received. The link doesn't establish because both switches are transmitting on the same pins.

## Step 3 — Fix with auto-MDIX

Modern switches detect and correct cable type automatically. Enable it:
```
configure terminal
interface et0/2
 mdix auto
end
```

The link comes up. Check:
```
show interfaces et0/2 | include Media
```

Auto-MDIX is now enabled. The switch internally crossed the transmit/receive pair.

## Step 4 — Console access

Connect a rollover cable from your host (KALI) to R1's console port:
```
sudo screen /dev/ttyUSB0 9600
```

Press Enter. You're at R1's CLI through the console — no IP configuration needed.

<div class="callout info"><p><strong>GNS3 note:</strong> In GNS3, console access is virtual (right-click → Console). The physical cable exercise helps you recognise the real-world equivalent.</p></div>

<div class="achievement"><span class="medal">🏗️</span><span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">Cable Master — you know the wire, the pinout, and the fix</span></span></div>
$$DOWN_build$$
WHERE lab_id = 16 AND phase = 'build';

UPDATE lab_phases SET content = $$DOWN_attack$$
<div class="mission"><span class="tag">◈ MISSION</span><h3>Physical access = full compromise</h3><p>If an attacker gains physical access to a wiring closet, the network is theirs. Three physical-layer attacks: (1) rogue device tap — plug a hub/Kali between two legitimate devices, (2) console access — if the console port is left in default config, the attacker configures the router without a password, (3) cable disconnection — simple DoS by pulling the right plug.</p></div>

<div class="stats"><span class="chip xp">✦ 400 XP</span><span class="chip diff">◆ Beginner</span><span class="chip time">◷ ~20 min</span><span class="chip loot">⬡ Physical tap · Console hijack · Cable DoS</span></div>

<div class="callout danger"><p><strong>Lab only.</strong> Physical attacks require PHYSICAL ACCESS. In the real world, lock your wiring closet and secure console ports. This lab demonstrates WHY those precautions exist.</p></div>

## Objectives

<ul class="tool-objectives">
<li>Tap a link by placing Kali as a MITM between SW1 and SW2</li>
<li>Access R1's console with default settings — full admin access without password</li>
<li>Pull the right cable to DoS a specific subnet</li>
</ul>

## Attack 1 — Physical tap

Place Kali between SW1 and SW2:
- Kali eth0 → SW1 (link to network)
- Kali eth1 → SW2
- Enable IP forwarding on Kali

From Kali:
```
sudo sysctl net.ipv4.ip_forward=1
sudo tcpdump -i eth0 -nn
```

All traffic between SW1 and SW2 passes through Kali. You can observe, modify, or drop it.

## Attack 2 — Console hijack

Connect to R1's console port (simulated in GNS3):
- In GNS3, right-click R1 → Console
- If no console password is set, you get **privileged EXEC mode immediately**

```
R1>enable
R1#show running-config
```

Full access to the running config — including passwords (encrypted or not).

## Attack 3 — Cable DoS

Identify the cable connecting the server (PC3) to SW1. Disconnect it. PC3 disappears from the network.
```
ping 192.168.1.30
```
No reply. A single unplugged cable takes down a server.

<div class="callout warn"><p><strong>Mitigation:</strong> Port-security detects disconnected/reconnected ports with different MACs. Console ports MUST have a password: <code>line con 0 → password NetBreakerLab → login</code>. Locked wiring closets with RFID access logs are the physical-layer gold standard.</p></div>

<div class="achievement"><span class="medal">🔌</span><span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">Wiring Closet Bandit — you owned the network through its weakest link: the cable</span></span></div>
$$DOWN_attack$$
WHERE lab_id = 16 AND phase = 'attack';

UPDATE lab_phases SET content = $$DOWN_harden$$
<div class="mission"><span class="tag">◈ MISSION</span><h3>Lock down the cables and ports</h3><p>Physical security: console passwords, port-security, shut down unused ports, enable logging for link flaps, document the physical topology. An attacker who can't touch the wire can't pull the attacks from Phase 2.</p></div>

<div class="stats"><span class="chip xp">✦ 200 XP</span><span class="chip diff">◆ Beginner</span><span class="chip time">◷ ~15 min</span><span class="chip loot">⬡ Console password · Port-security · Unused ports · Link flap logging</span></div>

## Objectives

<ul class="tool-objectives">
<li>Set console and enable passwords</li>
<li>Shut down unused switch ports</li>
<li>Enable port-security on all access ports</li>
<li>Log link up/down events</li>
</ul>

## Step 1 — Console password

On R1 and SW1:
```
configure terminal
line con 0
 password NetBreakerLab
 login
end
```

Now console access requires a password.

## Step 2 — Enable password

```
configure terminal
enable secret NetBreakerLab
end
```

The enable password is hashed (MD5) — not visible in the config as plain text.

## Step 3 — Shut down unused ports

```
configure terminal
interface et0/3
 shutdown
end
```

Only the ports you actually use are open. An attacker plugging into an unused port gets nothing — not even a link light.

## Step 4 — Port-security on active ports

```
configure terminal
interface range et0/0 - 2
 switchport port-security
 switchport port-security maximum 1
 switchport port-security violation shutdown
 switchport port-security mac-address sticky
end
```

## Step 5 — Link flap logging

SW1 logs when a link goes up or down. Check:
```
show logging | include LINK
```

You'll see each interface state change. In production, forward these logs to a SIEM (Syslog server) to detect physical-layer attacks in real time.

<div class="achievement"><span class="medal">🛡️</span><span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">Physical Guardian — the network is now as secure as the cable plant</span></span></div>
$$DOWN_harden$$
WHERE lab_id = 16 AND phase = 'harden';

COMMIT;
