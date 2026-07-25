-- ═══════════════════════════════════════════════════════════════════
-- Lab (id=39) — LAN/WAN Architectures : full content (Vol 2 · Ch 15-16)
-- ═══════════════════════════════════════════════════════════════════

UPDATE labs
SET short_desc = 'Run a whole company off one overworked switch — then watch it take the entire building down the moment it hiccups.'
WHERE id = 39;

-- ─────────────────────────── BUILD ───────────────────────────
UPDATE lab_phases SET
  title = 'One Switch to Run It All',
  content = $md$
<div class="mission">
<span class="tag">◈ Mission Briefing — Phase 1 of 3</span>
<h3>One Switch to Run It All</h3>
<p>Plenty of real networks start exactly this way: a company grows, someone plugs everything into whatever switch is closest, and eventually one device is quietly doing the job of access, distribution, <em>and</em> core layers at once. It works fine — right up until it doesn't. You're about to build that network on purpose, then find out exactly how much is riding on one box.</p>
</div>

<div class="stats">
<span class="chip xp">✦ 500 XP</span>
<span class="chip diff">◆ Difficulty: ★★☆☆☆</span>
<span class="chip time">◷ ~15 min</span>
<span class="chip loot">⚿ Loot: collapsed-core design · single points of failure · why tiers exist</span>
</div>

## Your arsenal (GNS3)

| Device | Role |
|---|---|
| SW1 | Everything. Access, distribution, core — all on one box |
| PC1, PC2 | Two different "departments" sharing the one switch |
| R1 | Internet-facing router, hanging off the same switch |

Wire `PC1 → SW1`, `PC2 → SW1`, `R1 → SW1` — one flat star, SW1 in the middle of everything.

<ul class="objectives">
<li>Confirm PC1 and PC2 both reach R1 and each other through SW1</li>
<li>Notice there is exactly one path for every conversation on this network</li>
</ul>

## Step 1 — Wire the flat topology

Nothing fancy — every device plugs into SW1 as a plain access port:

```
enable
configure terminal
interface range FastEthernet0/1 - 3
 switchport mode access
end
```

## Step 2 — Confirm everything depends on this one box

```
! from PC1
ping <PC2-IP>
ping <R1-IP>
```
Both work. Good. Now look at the topology honestly:

```
show cdp neighbors
```
Every single device in this network is one hop from SW1, and SW1 is the *only* hop. There is no second path for anything.

<div class="callout warn">
<p>This isn't a misconfiguration — it's just what "we'll add redundancy later" looks like in year one. Most small networks look exactly like this, often for years.</p>
</div>

<div class="achievement">
<span class="medal">🏢</span>
<span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">One Box, One Company — everything runs, for now</span></span>
</div>

**Next:** Phase 2 finds out what "for now" actually means.
$md$
WHERE lab_id = 39 AND phase = 'build';

-- ─────────────────────────── ATTACK ───────────────────────────
UPDATE lab_phases SET
  title = 'Break It (No Exploit Required)',
  content = $md$
<div class="mission">
<span class="tag">◈ Mission Briefing — Phase 2 of 3</span>
<h3>Break It (No Exploit Required)</h3>
<p>This phase has no attacker in it. That's deliberate. A flat, single-tier network doesn't need to be hacked to fail catastrophically — it just needs the one box in the middle to have a bad day. You're going to give it one, on purpose, and watch the blast radius.</p>
</div>

<div class="stats">
<span class="chip xp">✦ 600 XP</span>
<span class="chip diff">◆ Difficulty: ★★☆☆☆</span>
<span class="chip time">◷ ~10 min</span>
<span class="chip loot">⚿ Loot: single-point-of-failure blast radius · why "just add a switch" isn't enough</span>
</div>

## Step 1 — Take down the one thing everything depends on

```
! on SW1
enable
configure terminal
interface range FastEthernet0/1 - 3
 shutdown
end
```

## Step 2 — Watch the total blast radius

```
! from PC1
ping <PC2-IP>
ping <R1-IP>
```

<div class="callout tip">
<p><strong>💥 That's the moment.</strong> PC1 can't reach PC2. PC1 can't reach the internet. PC2 can't reach anything either. One switch having a bad five minutes just took down every department and the internet connection simultaneously — because there was never a second path for any of it to fail over to.</p>
</div>

## Step 3 — Bring it back and think about the real question

```
configure terminal
interface range FastEthernet0/1 - 3
 no shutdown
end
```
The question this phase is really asking: what would it have taken for PC1 to still reach the internet while SW1 was down? The honest answer, in this topology, is "nothing could have" — there's no second switch, no second path, no separation between "the department LAN breaking" and "the whole building losing internet."

<div class="achievement">
<span class="medal">🕳️</span>
<span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">Single Point of Failure — the entire company, one shutdown command away</span></span>
</div>

**Next:** Phase 3 — build the tiers that turn "everything is down" into "one link is down."
$md$
WHERE lab_id = 39 AND phase = 'attack';

-- ─────────────────────────── HARDEN ───────────────────────────
UPDATE lab_phases SET
  title = 'Separate the Tiers',
  content = $md$
<div class="mission">
<span class="tag">◈ Mission Briefing — Phase 3 of 3</span>
<h3>Separate the Tiers</h3>
<p>The classic three-tier model — access, distribution, core — exists for exactly one reason: so that a failure in one layer doesn't automatically become a failure of every layer. Access switches connect end devices. Distribution switches aggregate access switches and enforce policy. The core exists purely to move traffic between distribution blocks, fast, with redundant paths everywhere it matters.</p>
</div>

<div class="stats">
<span class="chip xp">✦ 750 XP</span>
<span class="chip diff">◆ Difficulty: ★★★☆☆</span>
<span class="chip time">◷ ~15 min</span>
<span class="chip loot">⚿ Loot: three-tier design · redundant uplinks · failure domain isolation</span>
</div>

<ul class="objectives">
<li>Split the single switch into an access tier and a distribution/core tier</li>
<li>Give the access tier two uplinks to the tier above, not one</li>
<li>Re-run the failure test → only part of the network feels it, not all of it</li>
</ul>

## Step 1 — Add a second switch and split the roles

```
! SW1 becomes the access switch for PC1/PC2
! SW2 becomes distribution/core, connecting to R1
```
Wire `PC1 → SW1`, `PC2 → SW1`, `SW1 → SW2` (two links, for redundancy), `SW2 → R1`.

```
! on SW1 (access)
configure terminal
interface range FastEthernet0/3 - 4
 switchport trunk encapsulation dot1q
 switchport mode trunk
end
```

## Step 2 — Let STP (from an earlier lab) manage the redundant uplinks safely

```
! on SW1 and SW2
spanning-tree vlan 1 root primary    ! set this appropriately on SW2 as the intended root
```
Two uplinks between access and distribution means a real loop — exactly the scenario the STP lab covered, now doing useful work instead of being a vulnerability.

## Step 3 — Re-run the failure test

Take down **one** of the two uplinks between SW1 and SW2 this time — not the whole switch:

```
! on SW1
interface FastEthernet0/3
 shutdown
```

```
! from PC1
ping <R1-IP>
```

<div class="callout tip">
<p>Still works. STP fails over to the surviving uplink, traffic reroutes, and nobody outside this specific link even notices. Compare this to Phase 2, where one shutdown command took down literally everything — now the same category of failure only costs you the redundant path you were paying for exactly this reason.</p>
</div>

## Prove it to the grader

```
show spanning-tree vlan 1                    ! one uplink forwarding, one blocking (until needed)
show ip interface brief                       ! access, distribution, core roles are distinct devices
```

<div class="achievement">
<span class="medal">🛡️</span>
<span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">Contained Failure — a bad day for one link, not a bad day for the company</span></span>
</div>

<div class="mission">
<span class="tag">✔ LAB COMPLETE</span>
<h3>LAN/WAN Architectures — cleared</h3>
<p>You ran a whole company off one switch, then watched a single shutdown command take down every department and the internet at once. Then you split it into proper tiers with redundant uplinks, and the exact same category of failure shrank down to "one link, briefly, nobody outside it noticed."</p>
<p><strong>Total: 1850 XP</strong> · Next target: <code>Virtualization &amp; Cloud</code>, where the tenants sharing a host were never supposed to see each other.</p>
</div>
$md$
WHERE lab_id = 39 AND phase = 'harden';

-- ─────────────────────────── TOPOLOGY ───────────────────────────
INSERT INTO lab_topologies (lab_id, svg_small, svg_large, legend)
VALUES (
  39,
  $svg$<svg viewBox="0 0 320 150" xmlns="http://www.w3.org/2000/svg" font-family="ui-monospace, monospace">
  <rect x="120" y="55" width="90" height="34" rx="7" fill="#fff" stroke="#c02a30" stroke-width="1.6"/>
  <text x="165" y="77" text-anchor="middle" font-size="10" fill="#c02a30" font-weight="600">SW1 (everything)</text>
  <rect x="10" y="10" width="80" height="28" rx="6" fill="#fff" stroke="#1d4fc7" stroke-width="1.4"/>
  <text x="50" y="28" text-anchor="middle" font-size="9" fill="#1d4fc7">PC1</text>
  <rect x="10" y="100" width="80" height="28" rx="6" fill="#fff" stroke="#1d4fc7" stroke-width="1.4"/>
  <text x="50" y="118" text-anchor="middle" font-size="9" fill="#1d4fc7">PC2</text>
  <rect x="230" y="55" width="80" height="30" rx="6" fill="#fff" stroke="#0d7050" stroke-width="1.4"/>
  <text x="270" y="74" text-anchor="middle" font-size="9" fill="#0d7050">R1</text>
  <line x1="50" y1="38" x2="130" y2="65" stroke="#1d4fc7" stroke-width="2"/>
  <line x1="50" y1="100" x2="130" y2="80" stroke="#1d4fc7" stroke-width="2"/>
  <line x1="210" y1="72" x2="230" y2="72" stroke="#0d7050" stroke-width="2"/>
</svg>$svg$,
  $svg$<svg viewBox="0 0 700 260" xmlns="http://www.w3.org/2000/svg" font-family="ui-monospace, monospace">
  <rect x="30" y="110" width="150" height="46" rx="8" fill="#fff" stroke="#1d4fc7" stroke-width="1.6"/>
  <text x="105" y="132" text-anchor="middle" font-size="12" fill="#1d4fc7" font-weight="600">PC1 / PC2</text>
  <text x="105" y="147" text-anchor="middle" font-size="8" fill="#6b7480">access tier</text>
  <rect x="230" y="30" width="150" height="46" rx="8" fill="#fff" stroke="#14161a" stroke-width="1.6"/>
  <text x="305" y="52" text-anchor="middle" font-size="12" fill="#14161a" font-weight="600">SW1 · access</text>
  <rect x="230" y="190" width="150" height="46" rx="8" fill="#fff" stroke="#14161a" stroke-width="1.6"/>
  <text x="305" y="212" text-anchor="middle" font-size="12" fill="#14161a" font-weight="600">SW1 · access</text>
  <rect x="470" y="110" width="170" height="50" rx="9" fill="#fff" stroke="#0d7050" stroke-width="1.8"/>
  <text x="555" y="132" text-anchor="middle" font-size="12" fill="#0d7050" font-weight="600">SW2 · dist/core</text>
  <text x="555" y="147" text-anchor="middle" font-size="8" fill="#6b7480">redundant uplinks + STP</text>
  <line x1="180" y1="130" x2="240" y2="70" stroke="#6b7480" stroke-width="2"/>
  <line x1="380" y1="53" x2="475" y2="120" stroke="#0d7050" stroke-width="2.5"/>
  <line x1="380" y1="213" x2="475" y2="145" stroke="#0d7050" stroke-width="2.5" stroke-dasharray="5 4"/>
  <text x="430" y="180" text-anchor="middle" font-size="8" fill="#6b7480">two uplinks — one can fail safely</text>
</svg>$svg$,
  $json$["Access tier", "Distribution/core tier", "Redundant uplinks"]$json$::jsonb
)
ON CONFLICT (lab_id) DO UPDATE SET
  svg_small = EXCLUDED.svg_small,
  svg_large = EXCLUDED.svg_large,
  legend    = EXCLUDED.legend;
