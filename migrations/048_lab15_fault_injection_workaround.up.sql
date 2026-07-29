-- ═══════════════════════════════════════════════════════════════════
-- Lab 15 — fault-injection gap, interim workaround (Option C), 2026-07-28
--
-- REAL FINDING: SW1 boots into a clean, fully-working state every
-- time — no lab in the entire platform has a mechanism to pre-inject
-- faults before a student arrives. Build -> Attack -> Harden all run
-- in ONE continuous GNS3 session; StartupConfig (the only config-at-
-- boot mechanism that exists) applies once at node creation, before
-- Build even starts, and there is no phase-transition hook anywhere
-- in the codebase to reconfigure a live device when a student enters
-- Attack. Confirmed platform-wide: grep across all ~38 topology files
-- shows only Lab 2 uses StartupConfig at all (for unrelated VLAN1
-- management IPs, not faults). This means every "find the faults"
-- Attack phase across all 46 labs has never had real faults to find.
--
-- DECISION (documented, not silently chosen): this is a product
-- architecture gap, not a Lab-15-specific bug. The real fix is a
-- platform capability — phase-transition scenario injection, sharing
-- the same telnet/console transport the verifier already uses — and
-- is being scoped separately as its own feature (see
-- internal/verify/scenario.go, added alongside this migration as a
-- first scaffold, NOT yet wired to anything).
--
-- Until that ships, Option C: the student creates the four faults
-- themselves as an explicit Step 0, clearly marked as a workaround,
-- then treats Steps 1-4 (unchanged from before — they already matched
-- what the verifier checks) as a real diagnostic exercise. This
-- changes what's being taught slightly (you know what you just broke,
-- so the "diagnose a mystery failure" muscle is weaker than it would
-- be with real pre-injection) but keeps the lab usable today.
-- ═══════════════════════════════════════════════════════════════════

UPDATE lab_phases SET
  content = replace(
    content,
    '## The four faults

Each fault disconnects or misroutes a path between two devices. Your task: find them all.',
    '<div class="callout warn"><p><strong>Workaround note:</strong> NetBreaker doesn''t yet have an automated way to pre-break a device before you arrive — that''s a real platform gap (a proper "scenario injection" feature is being designed separately). Until it ships, Step 0 below has you create the four faults yourself. Once you''ve run those commands, treat Steps 1-4 like a real incident report, not a memory test: diagnose using the tools, not what you just typed.</p></div>

## Step 0 — Set up today''s failure scenario

On SW1:
```
configure terminal
interface Et0/0
 shutdown
!
interface Et0/1
 switchport access vlan 99
!
interface Et0/2
 switchport port-security
 switchport port-security maximum 1
 switchport port-security violation shutdown
 switchport port-security mac-address 0000.0000.0001
!
interface Et0/3
 shutdown
end
```

That port-security command on Et0/2 doesn''t fake an err-disabled state — it sets a real trap. You''ve told the switch the only MAC allowed on that port is `0000.0000.0001`, which isn''t KALI''s real MAC. The next real frame KALI sends trips a genuine security violation. Go make that happen:

On **KALI**:
```
ping 192.168.1.1 -c 1
```

Et0/2 is now actually err-disabled — not simulated, not scripted, the switch really did detect and react to a real (if artificially set up) violation. From here on, forget you just did this and diagnose it cold.

## The four faults

Each fault disconnects or misroutes a path between two devices. Your task: find them all.'
  )
WHERE lab_id = 15 AND phase = 'attack';
