-- ═══════════════════════════════════════════════════════════════════
-- Lab (id=33) — Syslog : full content (Vol 2 · Ch 7)
-- ═══════════════════════════════════════════════════════════════════

UPDATE labs
SET short_desc = 'Ship your router''s logs to a real syslog server — then bury a genuine intrusion alert under a flood of spoofed messages an attacker faked from thin air.'
WHERE id = 33;

-- ─────────────────────────── BUILD ───────────────────────────
UPDATE lab_phases SET
  title = 'Wire Up the Log Collector',
  content = $md$
<div class="mission">
<span class="tag">◈ Mission Briefing — Phase 1 of 3</span>
<h3>Wire Up the Log Collector</h3>
<p>A router's console buffer is tiny and vanishes on reboot. Real operations send every log line somewhere permanent — a syslog server — tagged with a <strong>severity</strong> (0 Emergency down to 7 Debugging) and a <strong>facility</strong> (which subsystem generated it). Get this right and an intrusion shows up as a clean, timestamped line on a server you control. Get it wrong — which is the Cisco default — and anyone on the wire can write into your log stream right next to it.</p>
</div>

<div class="stats">
<span class="chip xp">✦ 500 XP</span>
<span class="chip diff">◆ Difficulty: ★★☆☆☆</span>
<span class="chip time">◷ ~15 min</span>
<span class="chip loot">⚿ Loot: syslog severity levels · facility codes · remote logging</span>
</div>

## Your arsenal (GNS3)

| Device | Role |
|---|---|
| R1 | Generates the logs |
| KALI | Doubles as your syslog server AND your attacker later |

Wire `R1 → KALI` directly, or through a switch — either works.

<ul class="objectives">
<li>Stand up a syslog listener on Kali</li>
<li>Point R1's logging at it with a sane severity level</li>
<li>Confirm a real log line arrives cleanly</li>
</ul>

## Step 1 — Stand up the collector (Kali)

Kali ships `rsyslog`. Open it to listen on UDP 514, the standard (unencrypted, unauthenticated) syslog port:

```
sudo tee -a /etc/rsyslog.conf << 'EOF'
module(load="imudp")
input(type="imudp" port="514")
EOF
sudo systemctl restart rsyslog
sudo tail -f /var/log/syslog
```
Leave that `tail -f` running in its own terminal — you'll watch it fill live.

## Step 2 — Point R1 at it

```
enable
configure terminal
logging host <KALI-IP>
logging trap informational
logging facility local0
service timestamps log datetime msec
end
```
`logging trap informational` means severity 6 (informational) and everything more urgent (0-6) gets shipped — debugging-level chatter (7) stays local.

## Step 3 — Generate a real log line and watch it land

```
configure terminal
interface loopback 99
 shutdown
 no shutdown
end
```
Flapping a loopback triggers a genuine `%LINK-3-UPDOWN` message. Check Kali's terminal — it should appear within a second or two, tagged with R1's hostname and a real timestamp.

<div class="callout tip">
<p>Severity 3 (Error) is exactly the kind of line a real NOC dashboard alerts on. Note how clean it looks — one line, one source, one timestamp. That cleanliness is what you're about to destroy.</p>
</div>

<div class="achievement">
<span class="medal">📡</span>
<span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">Signal Sent — first real device logging to a real collector</span></span>
</div>

**Next:** UDP syslog has no idea who actually sent a message. Phase 2 exploits exactly that.
$md$
WHERE lab_id = 33 AND phase = 'build';

-- ─────────────────────────── ATTACK ───────────────────────────
UPDATE lab_phases SET
  title = 'Drown the Alarm',
  content = $md$
<div class="mission">
<span class="tag">◈ Mission Briefing — Phase 2 of 3</span>
<h3>Drown the Alarm</h3>
<p>Syslog over UDP 514 has no authentication whatsoever. Any host that can reach port 514 can send a message claiming to be <em>any hostname it wants</em>, at <em>any severity it wants</em>. A real attacker's favorite move isn't deleting logs — it's <strong>flooding the stream with plausible-looking noise</strong> so the one line that matters (their actual intrusion) scrolls past a tired analyst at 3 AM.</p>
</div>

<div class="callout danger">
<p><strong>Rules of engagement:</strong> run this only against your own GNS3 lab. Flooding a real company's log pipeline is straightforwardly an attack on their incident response — never point this anywhere you don't own.</p>
</div>

<div class="stats">
<span class="chip xp">✦ 650 XP</span>
<span class="chip diff">◆ Difficulty: ★★☆☆☆</span>
<span class="chip time">◷ ~10 min</span>
<span class="chip loot">⚿ Loot: syslog spoofing · log injection · UDP source forgery</span>
</div>

## Step 1 — Forge one message by hand

Kali's `logger` command can fire a raw syslog message at any host over UDP, claiming any facility/severity you like:

```
logger -n <KALI-IP> -P 514 -d -p local0.info "R1: interface GigabitEthernet0/1, changed state to up"
```
`-d` forces UDP. `-p local0.info` sets facility.severity. Watch your own `tail -f /var/log/syslog` — that line just appeared, and nothing about it proves it didn't come from a real router.

## Step 2 — Bury a real alert under fifty fake ones

```
for i in $(seq 1 50); do
  logger -n <KALI-IP> -P 514 -d -p local0.info "R1: BGP-5-ADJCHANGE neighbor 10.0.$((RANDOM%254)).1 Up"
  sleep 0.1
done
```
This fires 50 plausible-looking routing messages in five seconds. Now flap that loopback again from R1's console mid-flood:
```
! back on R1
interface loopback 99
 shutdown
 no shutdown
```

<div class="callout tip">
<p><strong>💥 That's the moment.</strong> Your real <code>%LINK-3-UPDOWN</code> event — the thing you'd actually want a human to see — is now buried in a wall of fabricated BGP noise you generated from a laptop that isn't even running BGP. An analyst scrolling this log has to manually pick the real line out of fifty fakes, and nothing in the raw stream tells them which is which.</p>
</div>

<div class="achievement">
<span class="medal">🌊</span>
<span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">Signal Lost — the real alarm is in there somewhere</span></span>
</div>

**Next:** Phase 3 — make forged messages detectable, and make sure the flood can't drown a real device out in the first place.
$md$
WHERE lab_id = 33 AND phase = 'attack';

-- ─────────────────────────── HARDEN ───────────────────────────
UPDATE lab_phases SET
  title = 'Sign Every Line',
  content = $md$
<div class="mission">
<span class="tag">◈ Mission Briefing — Phase 3 of 3</span>
<h3>Sign Every Line</h3>
<p>The flood worked because UDP syslog trusts every packet that shows up. Fix it two ways: <strong>stop untrusted hosts from reaching the collector at all</strong>, and <strong>make forged messages provably fake</strong> instead of merely improbable.</p>
</div>

<div class="stats">
<span class="chip xp">✦ 750 XP</span>
<span class="chip diff">◆ Difficulty: ★★★☆☆</span>
<span class="chip time">◷ ~15 min</span>
<span class="chip loot">⚿ Loot: syslog ACLs · TCP+TLS syslog · sequence-number detection</span>
</div>

<ul class="objectives">
<li>Restrict the collector to accept UDP 514 only from known device IPs</li>
<li>Add sequence numbers so gaps and out-of-order bursts are visible</li>
<li>(Bonus) move to TCP syslog so at least the transport can't be blindly spoofed</li>
<li>Re-run the flood → attacker traffic is dropped before it reaches the log</li>
</ul>

## Fix 1 — Firewall the collector

The single biggest fix: Kali (playing your syslog server) should only accept UDP 514 from R1's real address. On a genuine server this is `iptables`; for this lab, simulate it directly:

```
sudo iptables -A INPUT -p udp --dport 514 -s <R1-IP> -j ACCEPT
sudo iptables -A INPUT -p udp --dport 514 -j DROP
```
Now the attacker's forged packets (sourced from Kali's own IP, not R1's) never even reach rsyslog — dropped at the firewall, before they're a single line in the log.

## Fix 2 — Sequence numbers close the "which line is real" gap

Even on a trusted link, a gap or reorder in sequence numbers is a tell that something's off. On R1:

```
configure terminal
service sequence-numbers
end
```
Every log line now carries an incrementing number. A burst of fifty messages with no sequence gap, arriving faster than R1's CPU could plausibly generate them, is now a visible anomaly instead of just "a lot of BGP messages."

## Fix 3 (bonus) — TCP syslog is at least not blindly spoofable

UDP lets an attacker fire-and-forget with a forged source address. TCP requires a completed handshake — much harder to spoof blind. On R1:

```
configure terminal
logging host <KALI-IP> transport tcp port 6514
end
```
And on Kali, enable the TCP input module:
```
sudo tee -a /etc/rsyslog.conf << 'EOF'
module(load="imtcp")
input(type="imtcp" port="6514")
EOF
sudo systemctl restart rsyslog
```
<div class="callout info">
<p>Full protection is syslog over TLS (port 6514 with a certificate) so the stream is both authenticated and encrypted — worth knowing exists, even if wiring up a CA is outside this lab's scope.</p>
</div>

## Re-run the attack (the fun part)

From Kali, try the same flood again:
```
for i in $(seq 1 50); do logger -n <R1-firewalled-IP> -P 514 -d -p local0.info "fake"; done
```

<div class="callout tip">
<p>Nothing arrives. <code>iptables</code> dropped every packet before rsyslog ever saw it — check with <code>sudo iptables -L -v -n</code> and watch the DROP counter climb. The forged messages die at the firewall, not in a human's judgment call at 3 AM.</p>
</div>

## Prove it to the grader

```
sudo iptables -L INPUT -v -n           ! DROP rule present, packet counter increasing
show logging | include Sequence         ! sequence numbering enabled on R1
show run | include logging host         ! transport tcp, not default UDP
```

<div class="achievement">
<span class="medal">🛡️</span>
<span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">Chain of Custody — every log line is provably who it says it is</span></span>
</div>

<div class="mission">
<span class="tag">✔ LAB COMPLETE</span>
<h3>Syslog — cleared</h3>
<p>You shipped real logs to a real collector, then buried a genuine alert under fifty fabricated ones using nothing but a spoofed source and a for-loop. Then you firewalled the collector, added sequence numbers, and moved to TCP — the flood now dies before it's even a line in the log.</p>
<p><strong>Total: 1900 XP</strong> · Next target: <code>TFTP/FTP &amp; IOS Upgrades</code>, where pulling a config off a router is as easy as asking nicely.</p>
</div>
$md$
WHERE lab_id = 33 AND phase = 'harden';

-- ─────────────────────────── TOPOLOGY ───────────────────────────
INSERT INTO lab_topologies (lab_id, svg_small, svg_large, legend)
VALUES (
  33,
  $svg$<svg viewBox="0 0 320 140" xmlns="http://www.w3.org/2000/svg" font-family="ui-monospace, monospace">
  <rect x="30" y="50" width="100" height="34" rx="7" fill="#fff" stroke="#14161a" stroke-width="1.4"/>
  <text x="80" y="72" text-anchor="middle" font-size="11" fill="#14161a" font-weight="600">R1</text>
  <rect x="190" y="50" width="100" height="34" rx="7" fill="#fff" stroke="#c02a30" stroke-width="1.6"/>
  <text x="240" y="68" text-anchor="middle" font-size="10" fill="#c02a30" font-weight="600">KALI</text>
  <text x="240" y="79" text-anchor="middle" font-size="8" fill="#6b7480">collector + attacker</text>
  <line x1="130" y1="67" x2="190" y2="67" stroke="#6b7480" stroke-width="2"/>
  <text x="160" y="100" text-anchor="middle" font-size="8" fill="#6b7480">UDP 514</text>
</svg>$svg$,
  $svg$<svg viewBox="0 0 600 220" xmlns="http://www.w3.org/2000/svg" font-family="ui-monospace, monospace">
  <rect x="60" y="80" width="160" height="52" rx="9" fill="#fff" stroke="#14161a" stroke-width="1.5"/>
  <text x="140" y="103" text-anchor="middle" font-size="13" fill="#14161a" font-weight="600">R1</text>
  <text x="140" y="120" text-anchor="middle" font-size="9" fill="#6b7480">logging host + seq-numbers</text>
  <rect x="380" y="80" width="170" height="56" rx="9" fill="#fff" stroke="#c02a30" stroke-width="1.8"/>
  <text x="465" y="103" text-anchor="middle" font-size="13" fill="#c02a30" font-weight="700">KALI</text>
  <text x="465" y="120" text-anchor="middle" font-size="9" fill="#6b7480">rsyslog collector</text>
  <text x="465" y="132" text-anchor="middle" font-size="8" fill="#6b7480">+ forged UDP source</text>
  <line x1="220" y1="106" x2="380" y2="106" stroke="#6b7480" stroke-width="2.5"/>
  <text x="300" y="96" text-anchor="middle" font-size="9" fill="#6b7480">UDP 514 → TCP 6514</text>
</svg>$svg$,
  $json$["Log source (R1)", "Syslog collector (Kali)", "Forged UDP packets"]$json$::jsonb
)
ON CONFLICT (lab_id) DO UPDATE SET
  svg_small = EXCLUDED.svg_small,
  svg_large = EXCLUDED.svg_large,
  legend    = EXCLUDED.legend;
