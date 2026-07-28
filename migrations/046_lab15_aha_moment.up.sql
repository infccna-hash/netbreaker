-- ═══════════════════════════════════════════════════════════════════
-- Lab 15 — first "aha moment" callout, 2026-07-28
--
-- New pattern: one explicit, named "aha moment" per lab — a single
-- sharp, counter-intuitive fact the student just proved to
-- themselves, called out distinctly (new .callout.aha CSS variant,
-- violet/✨, added in frontend/src/styles.css) rather than left as
-- another paragraph of explanation. Starting with Lab 15; the plan
-- is one per lab going forward.
--
-- Lab 15's candidate: of everything in this lab (hub flooding,
-- selective switch forwarding, MAC table, broadcast domain), the
-- single most counter-intuitive moment is the ARP Reply gap — the
-- student is promiscuously capturing on the SAME switch as
-- everyone else and still doesn't see half the conversation. That's
-- the moment placed here, right after they've just watched it happen
-- in their own capture (build phase, end of Step 4).
--
-- NOTE: this callout will render unstyled (falls back to base
-- .callout box, no icon/color) until the frontend is rebuilt and
-- redeployed with the new CSS from this same change. Content and
-- style ship in the same commit but frontend deploy is a separate
-- step on the VPS.
-- ═══════════════════════════════════════════════════════════════════

UPDATE lab_phases SET
  content = replace(
    content,
    '> **Broadcast domain:** All devices that receive a Layer-2 broadcast frame from any other device. In this topology, PC1, PC2, PC3, KALI, SW1, and R1''s Et0/0 are all in the same broadcast domain. ARP requests reach everyone — replies don''t.

Now think about what happens if PC1 tries to reach a device on a DIFFERENT subnet',
    '> **Broadcast domain:** All devices that receive a Layer-2 broadcast frame from any other device. In this topology, PC1, PC2, PC3, KALI, SW1, and R1''s Et0/0 are all in the same broadcast domain. ARP requests reach everyone — replies don''t.

<div class="callout aha"><p><strong>Aha moment:</strong> You''re on the same switch as everyone else, in promiscuous mode, actively capturing every frame that reaches your NIC. You saw the ARP Request. You did not see the Reply. Nothing was hidden from you — nothing reached you. A hub would have handed you both frames, no exceptions, because a hub doesn''t decide anything. A switch decided, and that decision is invisible to you unless you''re the one it was addressed to. "I''m plugged into the network" and "I can see the traffic" are not the same claim — the gap between them is what every VLAN, every ACL, and every segmentation strategy in this course is actually betting on.</p></div>

Now think about what happens if PC1 tries to reach a device on a DIFFERENT subnet'
  )
WHERE lab_id = 15 AND phase = 'build';
