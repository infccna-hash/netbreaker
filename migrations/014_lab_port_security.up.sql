-- ═══════════════════════════════════════════════════════════════════
-- Lab (id=36) — Port Security : full content (Vol 2 · Ch 12)
-- First of a three-lab arc: Port Security -> DHCP Snooping -> Dynamic ARP
-- Inspection. Each lab is honest about what the previous one can't fix.
-- ═══════════════════════════════════════════════════════════════════

UPDATE labs
SET short_desc = 'Lock a port to one MAC address, watch a clumsy intruder get caught instantly — then defeat the same lock cleanly with nothing more than a MAC address changer.'
WHERE id = 36;

-- ─────────────────────────── BUILD ───────────────────────────
UPDATE lab_phases SET
  title = 'Lock the Port',
  content = $md$
<div class="mission">
<span class="tag">◈ Mission Briefing — Phase 1 of 3 · Arc 1 of 3</span>
<h3>Lock the Port</h3>
<p>This is the first of a three-lab arc. Port Security answers one question: "is exactly one known device plugged into this port?" It's excellent against the dumb, naive case — someone plugging in an extra laptop, or a MAC-flooding tool trying to overwhelm the CAM table. It has a real limit too, and this lab is honest about it: a MAC address is just a number, and any OS will let you set it to whatever you want.</p>
</div>

<div class="stats">
<span class="chip xp">✦ 550 XP</span>
<span class="chip diff">◆ Difficulty: ★★☆☆☆</span>
<span class="chip time">◷ ~15 min</span>
<span class="chip loot">⚿ Loot: port security · sticky MAC learning · violation modes</span>
</div>

## Your arsenal (GNS3)

| Device | Role |
|---|---|
| SW1 | The switch enforcing the lock |
| PC1 | The one authorized device on Fa0/1 |
| KALI | Plugged in later — same port, after PC1 is briefly removed |

Wire `PC1 → SW1 Fa0/1`. Leave `KALI` unplugged for now — you'll connect it during Phase 2.

<ul class="objectives">
<li>Limit Fa0/1 to exactly one MAC address</li>
<li>Let the switch learn PC1's MAC automatically (sticky) rather than typing it in</li>
<li>Set the violation action to shut the port down hard</li>
<li>Confirm the learned MAC shows up in the port-security table</li>
</ul>

## Step 1 — Lock the port down

```
enable
configure terminal
interface FastEthernet0/1
 description PC1-LOCKED-PORT
 switchport mode access
 switchport port-security
 switchport port-security maximum 1
 switchport port-security mac-address sticky
 switchport port-security violation shutdown
end
```
`sticky` means the switch learns whatever MAC shows up first and treats it as the permanently authorized one — no need to type it in by hand, but also no verification of *who* that first device actually was.

## Step 2 — Generate traffic so the switch learns PC1

```
! from PC1
ping <SW1-gateway-or-any-reachable-IP>
```

## Step 3 — Confirm the lock took

```
show port-security interface FastEthernet0/1
show port-security address
```
You should see exactly one secure MAC address, learned as `SecureSticky`, with the violation mode set to `Shutdown`.

<div class="callout tip">
<p>Notice the switch has zero opinion about <em>which</em> MAC is correct — it just remembers whichever one arrived first. That's the entire vulnerability this lab is built around.</p>
</div>

<div class="achievement">
<span class="medal">🔒</span>
<span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">One Device, One Port — locked, learned, and about to be tested</span></span>
</div>

**Next:** Phase 2 has two attempts. The clumsy one gets caught immediately. The clever one doesn't.
$md$
WHERE lab_id = 36 AND phase = 'build';

-- ─────────────────────────── ATTACK ───────────────────────────
UPDATE lab_phases SET
  title = 'The Clumsy Way, Then the Clean Way',
  content = $md$
<div class="mission">
<span class="tag">◈ Mission Briefing — Phase 2 of 3 · Arc 1 of 3</span>
<h3>The Clumsy Way, Then the Clean Way</h3>
<p>Two attempts, back to back. The first proves port security does its job against an obvious intrusion. The second proves it has no way to tell an obvious intrusion from a well-prepared one.</p>
</div>

<div class="callout danger">
<p><strong>Rules of engagement:</strong> run every command here against your own GNS3 lab only.</p>
</div>

<div class="stats">
<span class="chip xp">✦ 700 XP</span>
<span class="chip diff">◆ Difficulty: ★★★☆☆</span>
<span class="chip time">◷ ~15 min</span>
<span class="chip loot">⚿ Loot: port-security violations · MAC spoofing · sticky-learning trust gap</span>
</div>

## Attempt 1 — Just plug in (the clumsy way)

With PC1 still connected, add KALI onto the same port — in GNS3, connect Kali's interface to the same `Fa0/1` link, or wire it through a hub node so both are visible to the switch at once:

```
! from Kali, once connected
ping <any-reachable-IP>
```

Check the switch:
```
show port-security interface FastEthernet0/1
```

<div class="callout tip">
<p>Instantly caught. <code>Secure-shutdown</code> — the port is now err-disabled, a second unrecognized MAC showed up where only one is allowed, exactly as designed. Nothing subtle about this attempt, and the switch didn't need anything subtle to stop it.</p>
</div>

Bring the port back before continuing:
```
configure terminal
interface FastEthernet0/1
 shutdown
 no shutdown
end
```

## Attempt 2 — Spoof the trusted MAC (the clean way)

Disconnect PC1 (in GNS3, simply remove or shut down that link). The switch's sticky-learned entry for Fa0/1 does **not** clear just because the cable dropped — it's a static configuration entry now, sitting there waiting for that MAC to come back:

```
show port-security address
! the entry for PC1's MAC is still listed
```

Note the MAC address shown — that's your target. On Kali, become it:

```
sudo apt install -y macchanger
sudo ip link set eth0 down
sudo macchanger -m <PC1s-MAC-address> eth0
sudo ip link set eth0 up
```

Now connect Kali to the exact same port PC1 was on:

```
dhclient eth0   # or configure PC1's known static address manually
ping <any-reachable-IP>
```

<div class="callout tip">
<p><strong>💥 That's the moment.</strong> No violation. No shutdown. No log entry demanding attention. As far as SW1 is concerned, PC1 simply reconnected — because a MAC address is the <em>only</em> thing port security ever checked, and you just copied it.</p>
</div>

<div class="achievement">
<span class="medal">🎭</span>
<span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">Perfect Impersonation — same port, same "device," zero alarms</span></span>
</div>

**Next:** Phase 3 is honest about what this lab can and can't fix on its own — and points at exactly what closes the gap.
$md$
WHERE lab_id = 36 AND phase = 'attack';

-- ─────────────────────────── HARDEN ───────────────────────────
UPDATE lab_phases SET
  title = 'Know the Limit of This Lock',
  content = $md$
<div class="mission">
<span class="tag">◈ Mission Briefing — Phase 3 of 3 · Arc 1 of 3</span>
<h3>Know the Limit of This Lock</h3>
<p>Here's the honest part: nothing you configure on port security alone stops a correctly spoofed MAC address, because port security's entire trust model <em>is</em> the MAC address. Static or sticky doesn't matter — both just check the same field, and both are equally easy to fake. What port security <em>is</em> genuinely good at is catching the clumsy case, and giving you visibility into when something changes. Do both properly, then this arc continues into the labs that close the real gap.</p>
</div>

<div class="stats">
<span class="chip xp">✦ 750 XP</span>
<span class="chip diff">◆ Difficulty: ★★★☆☆</span>
<span class="chip time">◷ ~15 min</span>
<span class="chip loot">⚿ Loot: MAC move notification · aging · defense-in-depth thinking</span>
</div>

<ul class="objectives">
<li>Turn on MAC-move notification so a device reappearing on a <em>different</em> port is flagged</li>
<li>Age out stale sticky entries instead of trusting them forever</li>
<li>Confirm attempt 1 (the clumsy plug-in) is still caught cleanly</li>
<li>Understand — honestly — why attempt 2 needs the next two labs, not more port-security config</li>
</ul>

## Fix 1 — Get notified when a MAC moves

If the same MAC appears on a *different* port than it was last seen on, that's a real anomaly worth an alert — a device can't physically be in two wiring closets at once:

```
configure terminal
mac address-table notification mac-move
snmp-server enable traps mac-notification move
end
```

## Fix 2 — Don't trust a sticky entry forever

```
configure terminal
interface FastEthernet0/1
 switchport port-security aging time 10
 switchport port-security aging type inactivity
end
```
An entry with no traffic for 10 minutes ages out, forcing re-learning rather than sitting as a permanently trusted static fact.

## Confirm the clumsy attack still fails

```
! Attempt 1 again — plug an unspoofed device onto the port alongside PC1
show port-security interface FastEthernet0/1
```
Still `Secure-shutdown` on the first unrecognized MAC. That part was never the problem.

<div class="callout warn">
<p><strong>Be honest about attempt 2.</strong> Re-running the MAC-spoofing bypass from Phase 2 will still succeed here — aging and move-notification make it more visible over time and on a different port, but a spoofed MAC on the <em>same</em> port, presented cleanly, still isn't something port security alone can cryptographically rule out. That's not a bug in this lab's harden phase; it's the actual, honest limit of MAC-based access control.</p>
</div>

## What actually closes this gap

Two real fixes exist, and the next two labs in this arc build exactly one of them:

- **802.1X** (covered in full in its own lab) replaces "trust this MAC" with cryptographic proof of identity — a spoofed MAC alone can't produce a valid EAP credential.
- **DHCP Snooping + Dynamic ARP Inspection** — the next two labs — build a verified table of exactly which IP address is supposed to go with which MAC address on which port, and use that table to catch exactly the kind of impersonation you just pulled off, from a different angle: the moment the attacker's traffic tries to claim an IP address that doesn't match what the network actually issued it.

<div class="achievement">
<span class="medal">🧭</span>
<span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">Know Your Boundary — the mark of someone who understands the tool, not just the command</span></span>
</div>

<div class="mission">
<span class="tag">✔ LAB COMPLETE — ARC 1 OF 3</span>
<h3>Port Security — cleared</h3>
<p>You locked a port to one MAC, watched a clumsy intrusion get caught instantly, then defeated the exact same lock cleanly with nothing but <code>macchanger</code>. You added real visibility — but you're leaving this lab knowing precisely where the wall ends, not pretending it doesn't.</p>
<p><strong>Total: 2000 XP</strong> · Next target: <code>DHCP Snooping</code> — where the network starts keeping a real record of who's actually supposed to have which address.</p>
</div>
$md$
WHERE lab_id = 36 AND phase = 'harden';

-- ─────────────────────────── TOPOLOGY ───────────────────────────
INSERT INTO lab_topologies (lab_id, svg_small, svg_large, legend)
VALUES (
  36,
  $svg$<svg viewBox="0 0 320 140" xmlns="http://www.w3.org/2000/svg" font-family="ui-monospace, monospace">
  <rect x="120" y="50" width="100" height="34" rx="7" fill="#fff" stroke="#14161a" stroke-width="1.4"/>
  <text x="170" y="72" text-anchor="middle" font-size="11" fill="#14161a" font-weight="600">SW1</text>
  <rect x="10" y="10" width="90" height="30" rx="6" fill="#fff" stroke="#1d4fc7" stroke-width="1.5"/>
  <text x="55" y="30" text-anchor="middle" font-size="9" fill="#1d4fc7" font-weight="600">PC1 (locked)</text>
  <rect x="10" y="100" width="120" height="32" rx="6" fill="#fff" stroke="#c02a30" stroke-width="1.6"/>
  <text x="70" y="120" text-anchor="middle" font-size="9" fill="#c02a30" font-weight="600">KALI (spoofed MAC)</text>
  <line x1="55" y1="40" x2="150" y2="60" stroke="#1d4fc7" stroke-width="2"/>
  <line x1="70" y1="100" x2="150" y2="72" stroke="#c02a30" stroke-width="2" stroke-dasharray="5 4"/>
</svg>$svg$,
  $svg$<svg viewBox="0 0 700 260" xmlns="http://www.w3.org/2000/svg" font-family="ui-monospace, monospace">
  <rect x="270" y="90" width="160" height="56" rx="9" fill="#fff" stroke="#14161a" stroke-width="1.8"/>
  <text x="350" y="113" text-anchor="middle" font-size="13" fill="#14161a" font-weight="700">SW1</text>
  <text x="350" y="130" text-anchor="middle" font-size="9" fill="#6b7480">Fa0/1 · port-security max 1</text>
  <rect x="40" y="30" width="160" height="52" rx="9" fill="#fff" stroke="#1d4fc7" stroke-width="1.8"/>
  <text x="120" y="53" text-anchor="middle" font-size="12" fill="#1d4fc7" font-weight="600">PC1 · authorized</text>
  <text x="120" y="69" text-anchor="middle" font-size="8" fill="#6b7480">sticky-learned MAC</text>
  <rect x="40" y="170" width="200" height="56" rx="9" fill="#fff" stroke="#c02a30" stroke-width="1.8"/>
  <text x="140" y="193" text-anchor="middle" font-size="12" fill="#c02a30" font-weight="600">KALI · macchanger</text>
  <text x="140" y="209" text-anchor="middle" font-size="8" fill="#6b7480">clones PC1's MAC exactly</text>
  <line x1="120" y1="82" x2="290" y2="118" stroke="#1d4fc7" stroke-width="2.5"/>
  <line x1="140" y1="170" x2="290" y2="130" stroke="#c02a30" stroke-width="2.5" stroke-dasharray="6 5"/>
  <text x="500" y="118" font-size="10" fill="#6b7480">→ Arc continues: DHCP Snooping</text>
</svg>$svg$,
  $json$["Authorized device (sticky-learned)", "Attacker (MAC-spoofed impersonation)", "Locked port"]$json$::jsonb
)
ON CONFLICT (lab_id) DO UPDATE SET
  svg_small = EXCLUDED.svg_small,
  svg_large = EXCLUDED.svg_large,
  legend    = EXCLUDED.legend;
