-- Migration 087: Lab 2 content fixes from console-truth walkthrough (2026-08-04)
-- P1-1: build per-switch trunk ranges (old range trunked PC1/KALI ports, missed SW2 links)
-- P1-2: harden Fix 3 names SW2 Et0/2 (old unnamed Et0/1 broke the tree via Root Guard on the real root uplink)
-- P2-1: attack Boss Fight observable softened to match verified IOU behavior

UPDATE lab_phases SET content = $md$
<div class="mission">
<span class="tag">◈ Mission Briefing — Phase 1 of 3</span>
<h3>Build the Loop</h3>
<p>Redundant links stop a single cable failure from taking down the building. But redundant links between switches also create a <strong>loop</strong> — and an Ethernet frame with nowhere to expire will circle a loop forever, doubling every time it hits a branch, until the network drowns in its own traffic. Spanning Tree Protocol's whole job is to find that loop and surgically block one link before it happens.</p>
<p>You're wiring three switches in a triangle — SW1, SW2, SW3 — with SW1 elected root bridge. Then, same trick as always: you'll leave the election process trusting anyone who shows up with a better offer.</p>
</div>

<div class="stats">
<span class="chip xp">✦ 550 XP</span>
<span class="chip diff">◆ Difficulty: ★★☆☆☆</span>
<span class="chip time">◷ ~20 min</span>
<span class="chip loot">⚿ Loot: STP root election · BPDUs · port roles &amp; states</span>
</div>

## Your topology

| Device | Role |
|---|---|
| SW1, SW2, SW3 | Triangle topology — the loop STP has to tame |
| PC1 | Ordinary host on SW1 |
| KALI | Plugged into SW3 |

Already wired: `SW1↔SW2`, `SW2↔SW3`, `SW3↔SW1` — a full triangle — plus `PC1→SW1 Et0/1` and `KALI→SW3 Et0/2`.

<ul class="objectives">
<li>Trunk all three inter-switch links</li>
<li>Leave every switch at the default STP priority (this is the trap)</li>
<li>Confirm STP blocks exactly one port to break the loop</li>
<li>Confirm PC1 can reach the network with no broadcast storm</li>
</ul>

## Step 1 — Wire the triangle

Trunk the inter-switch links — the exact ports differ per switch, so do them one at a time:

On **SW1** (its inter-switch links are **Et0/0** → SW2 and **Et0/2** → SW3; leave **Et0/1** alone, PC1 lives there):

```
enable
configure terminal
interface range Ethernet0/0 , Ethernet0/2
 switchport trunk encapsulation dot1q
 switchport mode trunk
end
```

On **SW2** (inter-switch links are **Et0/1** → SW1 and **Et0/2** → SW3):

```
configure terminal
interface range Ethernet0/1 - 2
 switchport trunk encapsulation dot1q
 switchport mode trunk
end
```

On **SW3** (inter-switch links are **Et0/1** → SW1 and **Et0/3** → SW2; leave **Et0/2** alone, KALI lives there):

```
configure terminal
interface range Ethernet0/1 , Ethernet0/3
 switchport trunk encapsulation dot1q
 switchport mode trunk
end
```
<div class="callout info">
<p>Yes — a real loop, on purpose. This is the whole point of STP: without it, this triangle would broadcast-storm itself into a coma within seconds.</p>
</div>

## Step 2 — Do absolutely nothing else

This is the trap. Cisco's default STP priority is <code>32768</code> on every switch, and root bridge election goes to whoever has the **lowest** Bridge ID (priority + MAC address) — lowest MAC wins any tie. Nobody configured a preferred root. The election is a coin flip decided by whichever switch happens to have the lowest MAC address:

```
show spanning-tree vlan 1
```
Note whichever switch won — call it your **current root**. Nobody chose it. It just happened to have the smallest MAC address in the room. That's a network running on luck, not design — exactly the setup you'll find in a lot of real small-business networks.

## Step 3 — Confirm the loop is actually being tamed

```
show spanning-tree vlan 1
```
On the non-root switches, exactly **one** of the two uplink ports should show <code>BLK</code> (blocking) — that's STP breaking the loop by refusing to forward on the redundant path. The other stays <code>FWD</code>.

<div class="callout tip">
<p>Find that blocked port on the switch that ISN'T root. If both your inter-switch ports say <code>FWD</code>, you have a real loop and things are about to get loud — go back and check the trunk configs.</p>
</div>

## Step 4 — Sanity check

```
ping <PC1-address-from-SW1-side>   ! from anywhere on the topology — should work fine, one path only
```

<div class="achievement">
<span class="medal">🔺</span>
<span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">Triangle Tamer — three switches, one loop, zero broadcast storms</span></span>
</div>

**Next:** the current root bridge got that title by accident. Phase 2 is where you take it by force.
$md$
WHERE lab_id = 2 AND phase = 'build';
UPDATE lab_phases SET content = $md$
<div class="mission">
<span class="tag">◈ Mission Briefing — Phase 2 of 3</span>
<h3>Steal the Crown</h3>
<p>STP elects a root bridge by asking every switch to broadcast a BPDU (Bridge Protocol Data Unit) announcing its Bridge ID. Lowest ID wins. Nothing checks whether the sender is actually a switch. Your Kali box can send BPDUs too — and if it claims a lower priority than anyone else in the room, every switch will believe it, recompute the entire spanning tree around your laptop, and start routing traffic through a link that ends at your NIC.</p>
</div>

<div class="callout danger">
<p><strong>Rules of engagement:</strong> every command here runs against <strong>your own GNS3 lab</strong>. This attack can black-hole a real production network in seconds — never point it anywhere you don't own.</p>
</div>

<div class="stats">
<span class="chip xp">✦ 750 XP</span>
<span class="chip diff">◆ Difficulty: ★★★☆☆</span>
<span class="chip time">◷ ~15 min</span>
<span class="chip loot">⚿ Loot: BPDU spoofing · root-bridge hijack · STP topology-change abuse</span>
</div>

## Step 1 — Watch the current election

Before you touch anything, capture what a legitimate BPDU looks like:

```
sudo tcpdump -i eth0 -e stp -c 5
```
You'll see BPDUs arriving every 2 seconds (the default Hello timer) advertising the current root's Bridge ID. That cadence, and the fact that anyone can join it, is the whole vulnerability.

## Step 2 — Claim the crown (Yersinia)

Launch yersinia (no `sudo` — you're already root in KALI):

```
yersinia -I
```

Inside the ncurses interface:
- press **g** → choose **STP**
- press **x** → choose **4) claiming root role**

Yersinia starts flooding a spoofed BPDU every 2 seconds. The BPDU carries a Bridge ID whose MAC address (`aabb.cc00.0b00`) is lower than any real switch on the network — so it wins the root election by tiebreaker, since every switch defaults to the same priority (32768). The attack keeps refreshing until you quit. Press **q** to exit when you're done.

## Step 3 — Watch the network bow to you

Give it a few seconds, then check any switch:

```
show spanning-tree vlan 1
```

<div class="callout tip">
<p><strong>💥 That's the moment.</strong> <code>Root ID</code> now shows YOUR Kali box's fake Bridge ID. Every switch just recalculated its port roles around a laptop that isn't even a switch. Depending on the topology, a previously-blocked port may now be forwarding, or vice versa — the traffic pattern across your triangle has physically changed because you asked nicely.</p>
</div>

Confirm from the other side — SW3's port toward Kali should now show as a **designated** or **root** port instead of whatever it was before:
```
show spanning-tree vlan 1 interface ethernet 0/2
```

<div class="achievement">
<span class="medal">👑</span>
<span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">Crown Thief — you out-elected every real switch on the network</span></span>
</div>

<div class="boss">
<span class="tag">☠ BOSS FIGHT — optional, +300 XP</span>
<h3>Topology Change flood: force constant recalculation</h3>
<p>Winning the election once is loud but stable. The sneakier move is repeatedly triggering <strong>Topology Change Notifications (TCNs)</strong> — every recalculation flushes every switch's MAC address table early, forcing a flood-and-relearn cycle on every port in the network. Do this continuously and you get a low-grade, hard-to-diagnose slowdown across the whole LAN, not an obvious outage.</p>
</div>

Launch yersinia again:

```
yersinia -I
```

Inside the ncurses interface:
- press **g** → choose **STP**
- press **x** → choose **3) sending tcn BPDUs** (the DoS version — floods TCNs continuously)

Every TCN forces every switch to shorten its MAC address table aging timer from 300 seconds to 15 seconds. Flood them continuously and the switches never stop relearning — MAC tables stay near-empty, traffic gets flooded to all ports, and the whole LAN degrades without a single link going down.

Watch a switch's MAC table get wiped and relearn on a timer that shouldn't exist:

```
show mac address-table count
! run it a few times while the flood runs — the count drops as the table flushes
```

The visible tell: the aging timer collapses from 300 seconds to 15, and the learned-MAC count drops toward the bare minimum (only actively-trafficing neighbors stay). The flush-and-relearn cycle keeps the table thin while the flood runs — that's the whole point of a topology-change flood, a low-grade slowdown instead of a clean outage.

<div class="achievement">
<span class="medal">🌪️</span>
<span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">Chaos Agent — nothing crashed, everything just quietly got worse</span></span>
</div>

**Next:** Phase 3 — nail down who's actually allowed to be root, and make sure a laptop can never win that argument again.
$md$
WHERE lab_id = 2 AND phase = 'attack';
UPDATE lab_phases SET content = $md$
<div class="mission">
<span class="tag">◈ Mission Briefing — Phase 3 of 3</span>
<h3>Crown the Right King</h3>
<p>The root election had no rules, so anyone could win it — including your laptop. Fix that two ways: <strong>choose your root on purpose</strong> instead of leaving it to chance, and <strong>refuse to listen</strong> to BPDUs from ports that have no business sending them in the first place.</p>
</div>

<div class="stats">
<span class="chip xp">✦ 800 XP</span>
<span class="chip diff">◆ Difficulty: ★★★☆☆</span>
<span class="chip time">◷ ~15 min</span>
<span class="chip loot">⚿ Loot: root primary/secondary · BPDU Guard · Root Guard</span>
</div>

<ul class="objectives">
<li>Explicitly set SW1 as root, SW2 as secondary root</li>
<li>Enable BPDU Guard on every access port (kills Kali's ability to speak STP at all)</li>
<li>Enable Root Guard on switch-facing ports where a rogue root claim shouldn't be trusted</li>
<li>Re-run both attacks → both fail</li>
</ul>

## Fix 1 — Pick your root on purpose

Stop leaving the crown to whichever MAC address happens to be lowest. On **SW1** (your intended permanent root):

```
configure terminal
spanning-tree vlan 1 root primary
end
```

On **SW2** (your backup, in case SW1 ever goes down):

```
configure terminal
spanning-tree vlan 1 root secondary
end
```

`root primary` sets SW1's priority to 24576 (or lower still if needed to beat every other bridge) — comfortably below the default 32768, but crucially, still something Yersinia's priority-0 claim would have beaten. Priority alone doesn't stop a determined attacker. That's what Fix 2 is for.

## Fix 2 — BPDU Guard: silence access ports completely

Real end hosts have **no reason** to ever send a BPDU. BPDU Guard shuts a port down the instant it hears one — no negotiation, no "let's see who wins":

```
configure terminal
interface Ethernet0/2
 description KALI-ACCESS-PORT
 spanning-tree bpduguard enable
end
```
<div class="callout tip">
<p>Even better at scale: <code>spanning-tree portfast bpduguard default</code> in global config enables BPDU Guard automatically on every PortFast-enabled access port, so you never have to remember it per-interface.</p>
</div>

## Fix 3 — Root Guard: protect the switch-facing links too

BPDU Guard is for host ports. But what about a link to another switch that should NEVER become root — say, a link to a branch office switch you don't fully trust? Root Guard blocks the port (not the whole switch) if it ever hears a superior BPDU from that direction.

In this triangle, the port to protect is **SW2's Et0/2** — the link toward SW3, where an attacker's root claim could enter the network. On **SW2**:

```
configure terminal
interface Ethernet0/2
 spanning-tree guard root
end
```

<div class="callout warning">
<p><strong>Where NOT to put it:</strong> don't enable Root Guard on SW3's Et0/1 (the link toward SW1) — SW1 is the legitimate root, and Root Guard would block that port the moment it hears the real root's BPDU, breaking the tree. Root Guard protects a link to a switch you don't trust to become root; it does not belong on a link toward the root you chose.</p>
</div>

## Re-run the attack (the fun part)

```
yersinia -I            # g→STP, x→4) Claiming Root Role
```

Check the port you protected:
```
show spanning-tree vlan 1 interface ethernet 0/2
```

<div class="callout tip">
<p><code>Status: err-disabled</code>. BPDU Guard didn't argue about priorities — it just shut the port the instant a BPDU showed up where one should never exist. Your fake root claim never even reaches the election.</p>
</div>

To bring the port back after testing (in production, this should require a human to look first):
```
configure terminal
interface Ethernet0/2
 shutdown
 no shutdown
end
```

## Prove it to the grader

```
show spanning-tree vlan 1                      ! Root ID is SW1, exactly as intended
show spanning-tree summary                       ! BPDU Guard + Root Guard both active
show interfaces status err-disabled              ! Kali's port, shut by BPDU Guard
```

<div class="achievement">
<span class="medal">🛡️</span>
<span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">Rightful King — the crown stays exactly where you put it</span></span>
</div>

<div class="mission">
<span class="tag">✔ LAB COMPLETE</span>
<h3>STP Sabotage — cleared</h3>
<p>You built a loop, let STP tame it, then walked in and crowned yourself root bridge with a laptop that isn't even a switch. Then you took the crown back on purpose — explicit root election, BPDU Guard on every host port, Root Guard on the links that matter.</p>
<p><strong>Total: 2900 XP</strong> · Next target: <code>DTP &amp; VTP</code>, where trusting the wrong switch can delete every VLAN on the network in one message.</p>
</div>
$md$
WHERE lab_id = 2 AND phase = 'harden';
