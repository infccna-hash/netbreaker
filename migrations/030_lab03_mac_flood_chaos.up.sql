-- ═══════════════════════════════════════════════════════
-- Lab 03 (id=3) — MAC Flood Chaos : full content (Vol 1 · Ch 5)
-- ═══════════════════════════════════════════════════════

UPDATE labs
SET short_desc = 'Study CAM table behavior then flood it with macof to force hub mode.',
    topic = 'switching',
    difficulty = 'easy',
    book_ref = 'Vol 1 · Ch 5'
WHERE id = 3;

-- ─────────────────────────── BUILD ───────────────────────────
UPDATE lab_phases SET
  title = 'Build the Switching Foundation',
  is_pro_only = false,
  content = $md$

<div class="mission"><span class="tag">◈ MISSION</span><h3>Watch a switch learn</h3><p>A switch builds its CAM (Content-Addressable Memory) table by inspecting source MAC addresses on every received frame. When it knows where every MAC lives, it forwards frames only to the right port — that's what makes switching efficient. But that table has a finite size, and when it fills up, the switch degrades to a hub. This lab is the story of that degradation.</p></div>

<div class="stats"><span class="chip xp">✦ 300 XP</span><span class="chip diff">◆ Beginner</span><span class="chip time">◷ ~20 min</span><span class="chip loot">⬡ CAM table · macof</span></div>

## The topology

One switch + two hosts + Kali. Simple enough to see the flood in action.

| Device | Role | Suggested image |
|---|---|---|
| SW1 | The switch you'll overflow | Cisco IOSvL2 / vIOS-L2 |
| PC1 | Normal host, VLAN 1 | VPCS |
| PC2 | Second host, VLAN 1 | VPCS |
| KALI | Your flood cannon | Kali Linux |

Cable it: PC1→Et0/1, PC2→Et0/2, KALI→Et0/3.

## Objectives

<ul class="objectives">
<li>Let SW1 learn MACs under normal traffic</li>
<li>Observe the CAM table with show commands</li>
<li>Confirm unicast frames arrive only where they belong</li>
</ul>

## Step 1 — Bring up the switch

```
enable
configure terminal
interface range et0/1-3
 switchport mode access
 switchport access vlan 1
 no shutdown
end
```

No trunks, no VLANs — pure Layer-2 on VLAN 1. Simple.

## Step 2 — Address the hosts

On PC1 (VPCS):
```
ip 10.0.0.10 255.255.255.0 10.0.0.1
```

On PC2 (VPCS):
```
ip 10.0.0.20 255.255.255.0 10.0.0.1
```

## Step 3 — Let the switch learn

Ping between PC1 and PC2:
```
ping 10.0.0.20       ! from PC1
```

Then check what SW1 learned:
```
show mac address-table
```

You'll see PC1 on Et0/1 and PC2 on Et0/2. The switch mapped two MACs to two ports. Efficient.

<div class="callout info"><p>This is the <strong>before</strong> picture. In the attack phase you'll fill every slot until the switch forgets its own map and starts shouting frames at every port.</p></div>

```
show mac address-table count
```

Note the current count and the max entries. That maximum is the ceiling you're about to hit.

<div class="achievement"><span class="medal">🏗️</span><span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">Map Reader — you understand how a switch builds its forwarding table</span></span></div>
$md$
WHERE lab_id = 3 AND phase = 'build';

-- ─────────────────────────── ATTACK ───────────────────────────
UPDATE lab_phases SET
  title = 'Flood the CAM',
  is_pro_only = false,
  content = $md$

<div class="mission"><span class="tag">◈ MISSION</span><h3>Force hub mode</h3><p><code>macof</code> ships with Kali's dsniff suite. It generates random source MAC addresses as fast as your NIC can transmit — 10,000 unique MACs per second on a good day. The switch's CAM table fills to capacity, and once it's full, newer entries are silently dropped. Every frame for an unknown destination is then <strong>flooded to every port</strong>. You've turned a switch into a hub. Sniff away.</p></div>

<div class="stats"><span class="chip xp">✦ 500 XP</span><span class="chip diff">◆ Beginner</span><span class="chip time">◷ ~15 min</span><span class="chip loot">⬡ macof · CAM overflow · hub mode</span></div>

<div class="callout danger"><p><strong>Sandbox only.</strong> This attack is noisy, detectable, and illegal outside your own lab. Keep it in GNS3.</p></div>

## Objectives

<ul class="objectives">
<li>Launch macof from Kali against SW1</li>
<li>Sniff traffic between PC1 and PC2 from Kali's port</li>
<li>Confirm you see inter-host traffic that shouldn't reach you</li>
</ul>

## Step 1 — Confirm you can't see PC1→PC2 traffic yet

On Kali, start a quick tcpdump:
```
sudo tcpdump -i eth0 -nn not arp
```

While that runs, ping PC2 from PC1:
```
! on PC1
ping 10.0.0.20
```

Check Kali's terminal. You saw nothing (or only broadcast/ARP). Right now, the switch delivers frames directly — you're not the destination, so you don't see them. Note this as "Before."

## Step 2 — Launch the flood

```
sudo macof -i eth0
```

By default, macof blasts 100 MACs per second on the wire. Each frame has a random source MAC and a random destination. The switch's CAM table fills in seconds.

Check the damage:
```
! on SW1
show mac address-table count
```
The count is maxed out, and `show mac address-table` might show nothing of value — just the flood of garbage.

<div class="callout tip"><p>Run <code>sudo macof -i eth0 -s 1000</code> to go faster (1000 MACs/sec). You'll fill most switches in under 10 seconds.</p></div>

## Step 3 — Sniff the aftermath

Leave macof running in one terminal. In a second Kali terminal:
```
sudo tcpdump -i eth0 -nn
```

Now ping PC2 from PC1 again:
```
ping 10.0.0.20       ! from PC1
```

Check Kali's tcpdump output. You should see ICMP echo requests and replies between 10.0.0.10 and 10.0.0.20 — traffic between two hosts that has <strong>nothing to do with Kali</strong>. The switch has no room in its CAM table, so it broadcasts everything. Kali just became a silent observer on every conversation.

<div class="callout warn"><p><strong>The flood is loud.</strong> Security monitoring tools will flag 10,000+ new MACs in 10 seconds. This attack is detectable — which makes it great for learning, but poor for stealth. Modern switches have protections.</p></div>

<div class="achievement"><span class="medal">👻</span><span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">Ghost on the Wire — you're seeing traffic the switch promised nobody else would see</span></span></div>

<div class="boss"><span class="tag">☠ BOSS FIGHT — optional, +200 XP</span><h3>Targeted flood</h3><p>Instead of flooding random MACs, craft a flood that targets a <strong>specific VLAN</strong> or a <strong>specific CAM bucket</strong>. Use Scapy to generate MACs with a controlled suffix that lands in one CAM bucket (the switch hashes MAC → bucket). Watch only that bucket overflow while the rest of the table stays clean. Requires understanding your switch's CAM hash — check the datasheet.</p></div>
$md$
WHERE lab_id = 3 AND phase = 'attack';

-- ─────────────────────────── HARDEN ───────────────────────────
UPDATE lab_phases SET
  title = 'Lock the Ports',
  is_pro_only = false,
  content = $md$

<div class="mission"><span class="tag">◈ MISSION</span><h3>Make the switch stop trusting</h3><p>Cisco's port-security feature lets you tell the switch exactly how many MACs a port is allowed to learn — and what happens when the limit is exceeded. Set it to 1 (one device per port), and macof's flood becomes a port shutdown instead of a CAM overflow.</p></div>

<div class="stats"><span class="chip xp">✦ 400 XP</span><span class="chip diff">◆ Beginner</span><span class="chip time">◷ ~15 min</span><span class="chip loot">⬡ port-security · errdisable</span></div>

## Objectives

<ul class="objectives">
<li>Enable port-security on Kali's access port with a MAC limit of 1</li>
<li>Set the violation mode to shutdown</li>
<li>Re-run macof — the port err-disables instantly</li>
</ul>

## Step 1 — Enable port security

On SW1, enable port security on the port Kali uses:
```
configure terminal
interface et0/3
 switchport port-security
 switchport port-security maximum 1
 switchport port-security violation shutdown
 switchport port-security mac-address sticky
end
```

What this does:
- **maximum 1**: only 1 MAC address may be learned on this port
- **violation shutdown**: if exceeded, the port goes err-disable
- **mac-address sticky**: the first MAC seen becomes the "allowed" one

## Step 2 — Re-run the attack

Back on Kali:
```
sudo macof -i eth0
```

Within one second, macof transmits a frame with a different source MAC than the one SW1 just learned. The port slams into err-disable instantly.

Check on SW1:
```
show interfaces status err-disabled
show interfaces et0/3
```

`Et0/3` shows `err-disabled`. The flood stopped at the port — the CAM table never filled.

<div class="callout info"><p><strong>Recovery:</strong> <code>shutdown</code> then <code>no shutdown</code> on the interface. Enable auto-recovery with <code>errdisable recovery cause psecure-violation</code> and the port comes back after 300 seconds.</p></div>

## Step 3 — Verify

```
show port-security interface et0/3
show port-security
```

You'll see the violation count incremented and the action set to Shutdown.

<div class="callout tip"><p>Use <code>switchport port-security violation restrict</code> instead of <code>shutdown</code> if you want the port to stay up but drop offending traffic — useful for monitoring without breaking connectivity.</p></div>

<div class="achievement"><span class="medal">🛡️</span><span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">Port Warden — one MAC per port, no exceptions</span></span></div>
$md$
WHERE lab_id = 3 AND phase = 'harden';

-- ─────────────────────────── TOPOLOGY ───────────────────────────
INSERT INTO lab_topologies (lab_id, svg_small, svg_large, legend)
VALUES (
  3,
  $svg$<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 380 220" font-family="ui-monospace,monospace">
  <rect x="130" y="30" width="120" height="44" rx="9" fill="#fff" stroke="#14161a" stroke-width="1.5"/>
  <text x="190" y="54" text-anchor="middle" font-size="14" fill="#14161a" font-weight="600">SW1</text>
  <text x="190" y="68" text-anchor="middle" font-size="9" fill="#6b7480">CAM: running</text>
  <line x1="70" y1="130" x2="150" y2="74" stroke="#6b7480" stroke-width="2"/>
  <line x1="190" y1="74" x2="310" y2="130" stroke="#6b7480" stroke-width="2"/>
  <line x1="190" y1="74" x2="190" y2="160" stroke="#e5484d" stroke-width="2" stroke-dasharray="5 4"/>
  <rect x="12" y="130" width="116" height="40" rx="8" fill="#fff" stroke="#2563eb" stroke-width="1.5"/>
  <text x="70" y="152" text-anchor="middle" font-size="12" fill="#2563eb" font-weight="600">PC1</text>
  <text x="70" y="164" text-anchor="middle" font-size="8" fill="#6b7480">10.0.0.10</text>
  <rect x="252" y="130" width="116" height="40" rx="8" fill="#fff" stroke="#2563eb" stroke-width="1.5"/>
  <text x="310" y="152" text-anchor="middle" font-size="12" fill="#2563eb" font-weight="600">PC2</text>
  <text x="310" y="164" text-anchor="middle" font-size="8" fill="#6b7480">10.0.0.20</text>
  <rect x="128" y="168" width="124" height="40" rx="8" fill="#fff" stroke="#e5484d" stroke-width="1.5"/>
  <text x="190" y="190" text-anchor="middle" font-size="12" fill="#e5484d" font-weight="600">KALI</text>
  <text x="190" y="202" text-anchor="middle" font-size="8" fill="#6b7480">macof ⚡</text>
</svg>$svg$,
  $svg$<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 380 220" font-family="ui-monospace,monospace">
  <rect x="130" y="30" width="120" height="44" rx="9" fill="#fff" stroke="#14161a" stroke-width="1.5"/>
  <text x="190" y="54" text-anchor="middle" font-size="14" fill="#14161a" font-weight="600">SW1</text>
  <text x="190" y="68" text-anchor="middle" font-size="9" fill="#6b7480">CAM: running</text>
  <line x1="70" y1="130" x2="150" y2="74" stroke="#6b7480" stroke-width="2"/>
  <line x1="190" y1="74" x2="310" y2="130" stroke="#6b7480" stroke-width="2"/>
  <line x1="190" y1="74" x2="190" y2="160" stroke="#e5484d" stroke-width="2" stroke-dasharray="5 4"/>
  <rect x="12" y="130" width="116" height="40" rx="8" fill="#fff" stroke="#2563eb" stroke-width="1.5"/>
  <text x="70" y="152" text-anchor="middle" font-size="12" fill="#2563eb" font-weight="600">PC1</text>
  <text x="70" y="164" text-anchor="middle" font-size="8" fill="#6b7480">10.0.0.10</text>
  <rect x="252" y="130" width="116" height="40" rx="8" fill="#fff" stroke="#2563eb" stroke-width="1.5"/>
  <text x="310" y="152" text-anchor="middle" font-size="12" fill="#2563eb" font-weight="600">PC2</text>
  <text x="310" y="164" text-anchor="middle" font-size="8" fill="#6b7480">10.0.0.20</text>
  <rect x="128" y="168" width="124" height="40" rx="8" fill="#fff" stroke="#e5484d" stroke-width="1.5"/>
  <text x="190" y="190" text-anchor="middle" font-size="12" fill="#e5484d" font-weight="600">KALI</text>
  <text x="190" y="202" text-anchor="middle" font-size="8" fill="#6b7480">macof ⚡</text>
</svg>$svg$,
  '[]'::jsonb
)
ON CONFLICT (lab_id) DO UPDATE SET
  svg_small = EXCLUDED.svg_small,
  svg_large = EXCLUDED.svg_large,
  legend    = EXCLUDED.legend;
