-- ═══════════════════════════════════════════════════════════════════
-- Lab (id=38) — Dynamic ARP Inspection : full content (Vol 2 · Ch 14)
-- Third and final lab of the arc: Port Security -> DHCP Snooping -> DAI.
-- ═══════════════════════════════════════════════════════════════════

UPDATE labs
SET short_desc = 'Poison two ARP caches at once to sit invisibly between a host and its gateway — then watch DAI drop every forged reply using nothing but the binding table the last lab built.'
WHERE id = 38;

-- ─────────────────────────── BUILD ───────────────────────────
UPDATE lab_phases SET
  title = 'Trust Whoever Answers',
  content = $md$
<div class="mission">
<span class="tag">◈ Mission Briefing — Phase 1 of 3 · Arc 3 of 3</span>
<h3>Trust Whoever Answers</h3>
<p>Last lab in this arc. ARP answers one question — "who has this IP address?" — and it does so with <strong>zero authentication whatsoever</strong>. Any host can announce "I have this IP" at any time, unprompted, and every device on the segment will simply believe it and update their cache. That single design flaw from the 1980s is still the basis of one of the most common LAN attacks that exists today.</p>
</div>

<div class="stats">
<span class="chip xp">✦ 550 XP</span>
<span class="chip diff">◆ Difficulty: ★★☆☆☆</span>
<span class="chip time">◷ ~15 min</span>
<span class="chip loot">⚿ Loot: ARP cache behavior · gratuitous ARP · zero-authentication protocols</span>
</div>

## Your arsenal (GNS3)

| Device | Role |
|---|---|
| R1 | The real gateway |
| SW1 | The switch — no ARP protections yet |
| PC1 | Victim, talking to R1 normally |
| KALI | Sits on the same segment, about to sit between them |

Wire `R1 → SW1`, `PC1 → SW1`, `KALI → SW1` — one flat segment.

<ul class="objectives">
<li>Confirm PC1 and R1 talk directly, with correct ARP entries</li>
<li>Confirm SW1 has no ARP-specific protection configured (the trap)</li>
</ul>

## Step 1 — Confirm the honest baseline

```
! on PC1
arp -a
```
PC1's ARP table should show R1's real MAC address against R1's real IP — a clean, correct mapping, for now.

## Step 2 — Confirm the trap

```
show ip arp inspection
```
Should show DAI not configured — ARP packets flow completely unchecked across every port. Nothing stops any host from claiming to be any IP address on this segment.

<div class="callout warn">
<p>This isn't a misconfiguration — it's how ARP has worked, unauthenticated, since it was designed. Every flat LAN without DAI has this exact exposure by default.</p>
</div>

<div class="achievement">
<span class="medal">🕸️</span>
<span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">Honest Cache — for now, everyone's ARP table tells the truth</span></span>
</div>

**Next:** Phase 2 — lie to both sides at once, and sit invisibly in the middle.
$md$
WHERE lab_id = 38 AND phase = 'build';

-- ─────────────────────────── ATTACK ───────────────────────────
UPDATE lab_phases SET
  title = 'Become the Man in the Middle',
  content = $md$
<div class="mission">
<span class="tag">◈ Mission Briefing — Phase 2 of 3 · Arc 3 of 3</span>
<h3>Become the Man in the Middle</h3>
<p>A full ARP spoof attacks both directions at once: tell PC1 that <em>you</em> are the router, and tell the router that <em>you</em> are PC1. Both sides update their ARP caches to point at your MAC address instead of each other's — and every packet either side sends now physically transits your machine first, silently, before continuing on to its real destination.</p>
</div>

<div class="callout danger">
<p><strong>Rules of engagement:</strong> run every command here against your own GNS3 lab only. ARP spoofing on a network you don't own is a textbook example of unauthorized interception.</p>
</div>

<div class="stats">
<span class="chip xp">✦ 800 XP</span>
<span class="chip diff">◆ Difficulty: ★★★☆☆</span>
<span class="chip time">◷ ~15 min</span>
<span class="chip loot">⚿ Loot: bidirectional ARP poisoning · transparent MITM · live traffic interception</span>
</div>

## Step 1 — Turn Kali into a forwarding bridge first

Just like the DHCP lab, the victims should notice nothing — traffic needs to keep flowing, just through you:

```
sudo sysctl -w net.ipv4.ip_forward=1
```

## Step 2 — Poison both directions with arpspoof

Two terminals, running continuously:

```
! terminal 1 — tell PC1 that Kali is the router
sudo arpspoof -i eth0 -t <PC1-IP> <R1-IP>
```
```
! terminal 2 — tell R1 that Kali is PC1
sudo arpspoof -i eth0 -t <R1-IP> <PC1-IP>
```

## Step 3 — Confirm both caches now lie

```
! on PC1
arp -a
```

<div class="callout tip">
<p><strong>💥 That's the moment.</strong> R1's real IP address now resolves to <em>Kali's</em> MAC address in PC1's ARP cache. Check R1's ARP table too — it now shows PC1's IP resolving to Kali's MAC as well. Neither side has any idea anything changed; their connectivity looks completely normal because you're forwarding everything through.</p>
</div>

## Step 4 — Watch the traffic that's now yours

```
sudo tcpdump -i eth0 -n host <PC1-IP>
```
Anything PC1 sends toward R1 — and R1's replies back — now physically pass through your NIC first. Open Wireshark for a cleaner view and watch an ordinary HTTP request or DNS lookup transit your machine in real time.

<div class="achievement">
<span class="medal">🥷</span>
<span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">The Invisible Middle — both sides think they're talking directly to each other</span></span>
</div>

**Next:** Phase 3 — the switch starts checking every ARP packet against a table it can actually trust.
$md$
WHERE lab_id = 38 AND phase = 'attack';

-- ─────────────────────────── HARDEN ───────────────────────────
UPDATE lab_phases SET
  title = 'Check Every Claim Against the Truth',
  content = $md$
<div class="mission">
<span class="tag">◈ Mission Briefing — Phase 3 of 3 · Arc 3 of 3</span>
<h3>Check Every Claim Against the Truth</h3>
<p>Dynamic ARP Inspection does exactly what ARP itself never did: it checks every ARP packet's claimed IP-to-MAC mapping against a table the switch actually trusts — the same DHCP Snooping binding table you built in the last lab. A claim that doesn't match gets dropped and logged, full stop, regardless of how convincing the forged packet looks.</p>
</div>

<div class="stats">
<span class="chip xp">✦ 900 XP</span>
<span class="chip diff">◆ Difficulty: ★★★★☆</span>
<span class="chip time">◷ ~15 min</span>
<span class="chip loot">⚿ Loot: Dynamic ARP Inspection · DHCP-snooping-backed validation · full three-lab defense stack</span>
</div>

<ul class="objectives">
<li>Confirm DHCP Snooping is active (DAI depends on its binding table)</li>
<li>Enable DAI on the VLAN</li>
<li>Trust the uplink toward the router</li>
<li>Re-run the ARP spoof → every forged packet gets dropped at the switch</li>
</ul>

## Fix 1 — DAI needs DHCP Snooping's binding table

If you're continuing straight from the last lab, this is already in place. If not:

```
configure terminal
ip dhcp snooping
ip dhcp snooping vlan 1
interface FastEthernet0/24
 ip dhcp snooping trust
end
```
DAI validates ARP packets against exactly this table — the same trusted record of which MAC is really supposed to hold which IP, on which port.

## Fix 2 — Turn on Dynamic ARP Inspection

```
configure terminal
ip arp inspection vlan 1
interface FastEthernet0/24
 ip arp inspection trust
end
```
Every access port stays untrusted by default — including Kali's. Untrusted ports have every ARP packet checked against the binding table; anything that doesn't match is dropped before it reaches its target.

## Fix 3 (bonus) — Rate-limit ARP on untrusted ports

Blunts an attacker simply trying to overwhelm the CPU with ARP inspection work instead of forging a valid-looking packet:

```
configure terminal
interface FastEthernet0/1
 ip arp inspection limit rate 15
end
```

## Re-run the attack (the fun part)

Restart both spoofing terminals from Phase 2:
```
sudo arpspoof -i eth0 -t <PC1-IP> <R1-IP>
sudo arpspoof -i eth0 -t <R1-IP> <PC1-IP>
```

Check PC1's cache:
```
! on PC1
arp -a
```

<div class="callout tip">
<p>Still correct — R1's IP still resolves to R1's real MAC. The forged ARP replies never made it off Kali's port. Confirm it directly on the switch: <code>show ip arp inspection statistics</code> shows a climbing count of dropped packets on Kali's interface, every single spoofed reply logged and discarded.</p>
</div>

## Prove it to the grader

```
show ip arp inspection vlan 1                    ! DAI enabled, port trust states shown
show ip arp inspection statistics                 ! forged packets dropped, count rising
show ip dhcp snooping binding                     ! the table DAI is validating against
```

<div class="achievement">
<span class="medal">🛡️</span>
<span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">Trust, Verified — every ARP claim now has to prove itself</span></span>
</div>

<div class="mission">
<span class="tag">✔ LAB COMPLETE — ARC 3 OF 3</span>
<h3>Dynamic ARP Inspection — cleared</h3>
<p>Look back at what this three-lab arc actually built. <strong>Port Security</strong> locked a port to a known device — and you learned exactly where that trust breaks down. <strong>DHCP Snooping</strong> built a verified record of who's really supposed to have which address. <strong>Dynamic ARP Inspection</strong> just used that same record to shut down one of the most common LAN attacks in existence, cold. None of these three tools alone is complete. Together, they're a real defense-in-depth stack — which is the entire point.</p>
<p><strong>Total: 2250 XP · Arc total: 6,400 XP across all three labs</strong> · Next target: <code>LAN/WAN Architectures</code>, where you'll redesign a flat network as something that scales.</p>
</div>
$md$
WHERE lab_id = 38 AND phase = 'harden';

-- ─────────────────────────── TOPOLOGY ───────────────────────────
INSERT INTO lab_topologies (lab_id, svg_small, svg_large, legend)
VALUES (
  38,
  $svg$<svg viewBox="0 0 340 150" xmlns="http://www.w3.org/2000/svg" font-family="ui-monospace, monospace">
  <rect x="130" y="55" width="90" height="34" rx="7" fill="#fff" stroke="#14161a" stroke-width="1.4"/>
  <text x="175" y="77" text-anchor="middle" font-size="10" fill="#14161a" font-weight="600">SW1 · DAI</text>
  <rect x="10" y="10" width="90" height="30" rx="6" fill="#fff" stroke="#0d7050" stroke-width="1.5"/>
  <text x="55" y="30" text-anchor="middle" font-size="9" fill="#0d7050" font-weight="600">R1 (gateway)</text>
  <rect x="10" y="100" width="90" height="30" rx="6" fill="#fff" stroke="#1d4fc7" stroke-width="1.5"/>
  <text x="55" y="120" text-anchor="middle" font-size="9" fill="#1d4fc7" font-weight="600">PC1 (victim)</text>
  <rect x="240" y="55" width="90" height="34" rx="6" fill="#fff" stroke="#c02a30" stroke-width="1.6"/>
  <text x="285" y="77" text-anchor="middle" font-size="9" fill="#c02a30" font-weight="600">KALI</text>
  <line x1="55" y1="40" x2="150" y2="65" stroke="#0d7050" stroke-width="2"/>
  <line x1="55" y1="100" x2="150" y2="80" stroke="#1d4fc7" stroke-width="2"/>
  <line x1="240" y1="72" x2="220" y2="72" stroke="#c02a30" stroke-width="2" stroke-dasharray="4 4"/>
</svg>$svg$,
  $svg$<svg viewBox="0 0 700 260" xmlns="http://www.w3.org/2000/svg" font-family="ui-monospace, monospace">
  <rect x="270" y="90" width="170" height="56" rx="9" fill="#fff" stroke="#14161a" stroke-width="1.8"/>
  <text x="355" y="113" text-anchor="middle" font-size="13" fill="#14161a" font-weight="700">SW1</text>
  <text x="355" y="130" text-anchor="middle" font-size="9" fill="#6b7480">Dynamic ARP Inspection</text>
  <rect x="40" y="20" width="170" height="50" rx="9" fill="#fff" stroke="#0d7050" stroke-width="1.8"/>
  <text x="125" y="42" text-anchor="middle" font-size="12" fill="#0d7050" font-weight="600">R1 · gateway</text>
  <text x="125" y="58" text-anchor="middle" font-size="8" fill="#6b7480">Fa0/24 · TRUSTED</text>
  <rect x="40" y="190" width="150" height="50" rx="9" fill="#fff" stroke="#1d4fc7" stroke-width="1.8"/>
  <text x="115" y="212" text-anchor="middle" font-size="12" fill="#1d4fc7" font-weight="600">PC1 · victim</text>
  <text x="115" y="228" text-anchor="middle" font-size="8" fill="#6b7480">real ARP entry survives</text>
  <rect x="490" y="90" width="190" height="56" rx="9" fill="#fff" stroke="#c02a30" stroke-width="1.8"/>
  <text x="585" y="113" text-anchor="middle" font-size="12" fill="#c02a30" font-weight="600">KALI · arpspoof</text>
  <text x="585" y="129" text-anchor="middle" font-size="8" fill="#6b7480">forged replies dropped</text>
  <line x1="125" y1="70" x2="290" y2="108" stroke="#0d7050" stroke-width="2.5"/>
  <line x1="115" y1="190" x2="290" y2="130" stroke="#1d4fc7" stroke-width="2.5"/>
  <line x1="490" y1="118" x2="440" y2="118" stroke="#c02a30" stroke-width="2.5" stroke-dasharray="6 5"/>
  <text x="500" y="200" font-size="10" fill="#6b7480">Arc complete: Port Security → Snooping → DAI</text>
</svg>$svg$,
  $json$["Gateway (trusted port)", "Victim (protected ARP entry)", "Attacker (forged ARP, dropped by DAI)"]$json$::jsonb
)
ON CONFLICT (lab_id) DO UPDATE SET
  svg_small = EXCLUDED.svg_small,
  svg_large = EXCLUDED.svg_large,
  legend    = EXCLUDED.legend;
