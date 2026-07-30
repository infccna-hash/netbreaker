-- 052_lab16_harden_dedupe_recovery.down.sql
--
-- Restores harden content to its pre-050 state (no recovery block
-- at all) -- same restore point as 050's own down migration.
-- Content extracted byte-for-byte from migration 010 source.

BEGIN;

UPDATE lab_phases SET
  content = $md$
<div class="mission"><span class="tag">◈ MISSION</span><h3>Lock down the cables and ports</h3><p>Physical security: console passwords, port-security, shut down unused ports, enable logging for link flaps, document the physical topology. An attacker who can't touch the wire can't pull the attacks from Phase 2.</p></div>

<div class="stats"><span class="chip xp">✦ 200 XP</span><span class="chip diff">◆ Beginner</span><span class="chip time">◷ ~15 min</span><span class="chip loot">⬡ Console password · Port-security · Unused ports · Link flap logging</span></div>

## Objectives

<ul class="tool-objectives">
<li>Set console and enable passwords</li>
<li>Shut down unused switch ports</li>
<li>Enable port-security on all access ports</li>
<li>Log link up/down events</li>
</ul>

## Step 1 — Console password

On R1 and SW1:
configure terminal line con 0 password NetBreakerLab login end

Now console access requires a password.

## Step 2 — Enable password

configure terminal enable secret NetBreakerLab end

The enable password is hashed (MD5) — not visible in the config as plain text.

## Step 3 — Shut down unused ports

configure terminal interface et0/3 shutdown end

Only the ports you actually use are open. An attacker plugging into an unused port gets nothing — not even a link light.

## Step 4 — Port-security on active ports

configure terminal interface range et0/0 - 2 switchport port-security switchport port-security maximum 1 switchport port-security violation shutdown switchport port-security mac-address sticky end

## Step 5 — Link flap logging

SW1 logs when a link goes up or down. Check:
show logging | include LINK

You'll see each interface state change. In production, forward these logs to a SIEM (Syslog server) to detect physical-layer attacks in real time.

<div class="achievement"><span class="medal">🛡</span><span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">Physical Guardian — the network is now as secure as the cable plant</span></span></div>
$md$
WHERE lab_id = 16 AND phase = 'harden';

COMMIT;
