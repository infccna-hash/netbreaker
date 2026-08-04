-- 086_lab24_vtp_dtp_fixes.up.sql
-- Lab 24 (DTP & VTP) — console-truth fixes from walkthrough 2026-08-04.
--
-- Build phase:
--  1. P0: Topology mismatch — content referenced SW3 + PC2/PC3 that do not
--     exist (topology = SW1, SW2, PC1, KALI). Rewritten to 2-switch layout.
--  2. P0: No `switchport`/`no shutdown` — on upk9-12.2 ports boot disabled
--     and non-switchport, so the SW1-SW2 trunk never forms and VTP never
--     propagates. Added trunk bring-up (bare switchport, trunk encapsulation
--     dot1q, mode trunk, no shutdown) + PC1 access port + Kali dynamic auto.
--
-- Attack phase:
--  3. P0: Attack 1 (VTP poison) as written told students to run it from
--     Kali — but yersinia's VTP attack emits ZERO frames on this build
--     (console-verified: tcpdump 0 packets). Rewritten to the verified
--     rogue-switch method: SW2 joins as server, syncs (rev 2), deletes
--     VLANs → revision bumps to 4 → SW1 follows and wipes its VLAN DB.
--  4. Attack 2 (DTP) switched from interactive yersinia -I (ncurses, not
--     driveable) to the verified one-shot CLI: `yersinia dtp -attack 1`.
--  5. Attack 3 (double-tag) rewritten to the verified CLI:
--     `yersinia dot1q -attack 1` (double-enc packet, console-verified).
--
-- Harden phase:
--  6. P1: `int range et0/1-3` (lowercase, no spaces) → % Invalid input on
--     12.2. Fixed to `interface range Et0/1 - 2` (uppercase Et, spaced
--     dash). SW3 reference removed; transparent mode kept as explanatory
--     text (Yassine decision B, 2026-08-04).
--
-- All commands console-verified on i86bi-linux-l2-upk9-12.2.

UPDATE lab_phases
SET content = $md$
<div class="mission"><span class="tag">◈ MISSION</span><h3>Propagate VLANs across the network</h3><p>VTP (VLAN Trunking Protocol) distributes VLAN information across switches. Create a VLAN on one switch and every switch in the domain learns it. DTP (Dynamic Trunking Protocol) negotiates trunk mode automatically. Both are convenience features — and both are security liabilities when left enabled.</p></div>

<div class="stats"><span class="chip xp">✦ 300 XP</span><span class="chip diff">◆ Beginner</span><span class="chip time">◷ ~20 min</span><span class="chip loot">⬡ VTP · VTP domain · VTP server/client · DTP · dynamic trunk</span></div>

<b>Topology:</b> SW1 (VTP server), SW2 (client). A trunk connects them. PC1 and Kali sit on SW1's access ports.
<br/><b>Step 1</b> — Bring the trunk up on SW1: <code>int Et0/0</code> → <code>switchport</code> → <code>switchport trunk encapsulation dot1q</code> → <code>switchport mode trunk</code> → <code>no shutdown</code>. Then VTP config: <code>vtp domain NETBREAKER</code>, <code>vtp mode server</code>, <code>vlan 10</code>, <code>name SALES</code>, <code>vlan 20</code>, <code>name ENG</code>.
<br/><b>Step 2</b> — SW2 client: bring the trunk up the same way (<code>int Et0/0</code> → <code>switchport</code> → <code>switchport trunk encapsulation dot1q</code> → <code>switchport mode trunk</code> → <code>no shutdown</code>), then <code>vtp domain NETBREAKER</code>, <code>vtp mode client</code>. SW2 learns VLANs 10 and 20 automatically.
<br/><b>Step 3</b> — User ports: on SW1, <code>int Et0/2</code> → <code>switchport</code> → <code>switchport mode access</code> → <code>no shutdown</code> (PC1). Kali's port Et0/1 is left in <code>dynamic auto</code> on purpose — you'll see why in the attacks.
<br/><b>Step 4</b> — Verify: <code>show vtp status</code>, <code>show vlan brief</code>, <code>show interfaces trunk</code>. SW2 shows VLANs 10 and 20 without manual config.
<div class="achievement"><span class="medal">🏗️</span><span class="txt">Achievement: VTP Apprentice</span></div>
$md$
WHERE lab_id = 24 AND phase = 'build';

UPDATE lab_phases
SET content = $md$
<div class="mission"><span class="tag">◈ MISSION</span><h3>Poison the VTP domain and trunk the attacker</h3><p>VTP has no authentication by default. An attacker who connects a switch with a higher revision number and a different VLAN database wipes or corrupts the entire domain. DTP lets any port become a trunk if the other side asks nicely.</p></div>
<div class="stats"><span class="chip xp">✦ 500 XP</span><span class="chip diff">◆ Intermediate</span><span class="chip time">◷ ~25 min</span><span class="chip loot">⬡ VTP poisoning · revision number · DTP spoof · VLAN hopping</span></div>
<b>Attack 1 — VTP poisoning:</b> Turn SW2 into the rogue switch. On SW2, join the domain as a server (<code>vtp domain NETBREAKER</code>, <code>vtp mode server</code>), wait for it to sync with SW1 (<code>show vtp status</code> shows revision 2 and VLANs 10/20), then delete the VLANs: <code>no vlan 10</code>, <code>no vlan 20</code>. Deleting VLANs bumps SW2's revision above SW1's. The entire VTP domain follows — every switch drops its VLAN database. <code>show vlan brief</code> on SW1 shows only VLAN 1.
<br/><b>Attack 2 — DTP trunk hijack:</b> From Kali: <code>yersinia dtp -attack 1 -interface eth0</code>. Kali negotiates trunk mode continuously; Et0/1 is dynamic auto, so it becomes a trunk. Kali now receives traffic from ALL VLANs. <code>tcpdump -i eth0 -nn</code> shows frames from VLANs 10, 20, etc.
<br/><b>Attack 3 — Double tagging (VLAN hopping):</b> From Kali: <code>yersinia dot1q -attack 1 -interface eth0</code>. Sends a frame with two 802.1Q tags: outer = native VLAN (1), inner = target VLAN (10). The first switch strips the outer tag and forwards the frame to VLAN 10. PC1 in VLAN 10 receives traffic from Kali even though Kali is not in VLAN 10.
<div class="achievement"><span class="medal">⚔️</span><span class="txt">Achievement: VTP Poisoner</span></div>
$md$
WHERE lab_id = 24 AND phase = 'attack';

UPDATE lab_phases
SET content = $md$
<div class="mission"><span class="tag">◈ MISSION</span><h3>Disable both protocols on user-facing ports</h3><p>VTP should be off or in transparent mode. DTP should be disabled with <code>switchport nonegotiate</code>. User-facing ports must be explicitly set to <code>switchport mode access</code>.</p></div>
<div class="stats"><span class="chip xp">✦ 200 XP</span><span class="chip diff">◆ Beginner</span><span class="chip time">◷ ~10 min</span><span class="chip loot">⬡ VTP off · nonegotiate · access mode</span></div>
<b>Step 1</b> — Disable VTP: <code>vtp mode transparent</code> on both switches. (On a third switch you would do the same — transparent mode forwards VTP updates but never learns or advertises its own VLAN database, so it can't be poisoned either.) VTP never alters the VLAN database again.
<br/><b>Step 2</b> — Disable DTP on access ports: <code>interface range Et0/1 - 2</code> → <code>switchport mode access</code> → <code>switchport nonegotiate</code>. No trunk negotiation, period. (Note the interface range syntax — uppercase <code>Et</code>, spaces around the dash.)
<br/><b>Step 3</b> — Set the native VLAN to an unused VLAN: <code>vlan 999</code> → <code>name DEAD</code>, then on the trunk: <code>interface Et0/0</code> → <code>switchport trunk native vlan 999</code>. Double-tagging attacks fail because the native VLAN (1) doesn't exist on the trunk.
<div class="achievement"><span class="medal">🛡️</span><span class="txt">Achievement: Trunk Guardian</span></div>
$md$
WHERE lab_id = 24 AND phase = 'harden';

