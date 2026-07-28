-- ═══════════════════════════════════════════════════════════════════
-- Lab 15 — follow-up content refinements, 2026-07-28 (after 044)
--
-- Three small improvements from a second content review pass:
-- 1. Build phase: add an explicit "Lab mindset" callout near the top
--    (observe / verify / conclude — evidence over assumption). Makes
--    NetBreaker's implicit teaching philosophy explicit instead of
--    leaving it to be inferred lab-by-lab.
-- 2. Attack phase: add a `show port-security interface Et0/2` /
--    `show port-security` diagnostic step BEFORE the shutdown/no
--    shutdown recovery, so students inspect violation count and
--    learned MACs before clearing it — same pattern already used in
--    Lab 3 (migration 030) and confirmed working on this IOU L2
--    image. Previously the fix was correct but skipped the "prove
--    it" step the rest of the lab teaches.
-- 3. Harden phase: soften "don't trust autonegotiation on critical
--    links" — that's dated guidance; modern practice generally
--    prefers autonegotiation on both ends (especially Gig+) and
--    forcing settings incorrectly is a common cause of duplex
--    mismatches. Reworded to teach the underlying judgment call
--    instead of a blanket rule.
--
-- NOT changed: the "Attack" phase name. That's a system-wide label
-- (phase check constraint + UI across all 46 labs), and several
-- other labs under that name are real attacks (VLAN hopping, OSPF
-- hijack, DHCP starvation) — renaming it lab-by-lab would be
-- inconsistent. Flagged for the person to decide product-wide, not
-- changed here.
-- ═══════════════════════════════════════════════════════════════════

-- ─────────────────────────── BUILD ───────────────────────────
UPDATE lab_phases SET
  content = replace(
    content,
    '## Step 1 — Assign IP addresses',
    '<div class="callout info"><p><strong>Lab mindset:</strong> assume the implementation may be wrong. Prove otherwise. Observe packets, inspect tables, and trust evidence over assumptions — every claim in this lab is something you can check yourself with a command, not something to take on faith.</p></div>

## Step 1 — Assign IP addresses'
  )
WHERE lab_id = 15 AND phase = 'build';

-- ─────────────────────────── ATTACK ───────────────────────────
-- Insert a port-security inspection step before the Fault 3 fix.
UPDATE lab_phases SET
  content = replace(
    content,
    'Fault 3 (Et0/2 err-disabled from port-security):
```
configure terminal
interface Et0/2
 shutdown
 no shutdown
end
```',
    'Fault 3 (Et0/2 err-disabled from port-security):

First, look at *why* before you clear it — don''t just bounce the port blind:
```
show port-security interface Et0/2
show port-security
```
This shows you the violation count, the secure MAC(s) already learned, and the configured action (Shutdown). That''s the evidence a real troubleshooter would check before touching anything — clearing an err-disabled port without reading this first means you never actually confirmed what tripped it.

Now clear it:
```
configure terminal
interface Et0/2
 shutdown
 no shutdown
end
```'
  )
WHERE lab_id = 15 AND phase = 'attack';

-- ─────────────────────────── HARDEN ───────────────────────────
-- Soften the autonegotiation guidance in the mission brief.
UPDATE lab_phases SET
  content = replace(
    content,
    'Harden the network against device-level issues: enable CDP/LLDP for inventory, configure interface descriptions, set duplex/speed explicitly (don''t trust autonegotiation on critical links), enable errdisable auto-recovery, and document everything.',
    'Harden the network against device-level issues: enable CDP/LLDP for inventory, configure interface descriptions, know when to set duplex/speed explicitly versus when autonegotiation is the right call, enable errdisable auto-recovery, and document everything.'
  )
WHERE lab_id = 15 AND phase = 'harden';

UPDATE lab_phases SET
  content = replace(
    content,
    '## Step 2 — Explicit duplex/speed on trunks

```
configure terminal
interface Et0/3
 speed 1000
 duplex full
end
```',
    '## Step 2 — Explicit duplex/speed on trunks

Configure critical infrastructure links according to your organization''s standards — know when explicit settings are appropriate and when autonegotiation is the recommended practice. On modern Gigabit+ links, autonegotiation on both ends is usually the safer default; forcing a mismatched setting on one side is a common real-world cause of duplex mismatches, not a fix for them. This lab still has you set it explicitly so you can see the command and its effect:
```
configure terminal
interface Et0/3
 speed 1000
 duplex full
end
```'
  )
WHERE lab_id = 15 AND phase = 'harden';
