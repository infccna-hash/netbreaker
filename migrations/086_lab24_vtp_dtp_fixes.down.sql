-- 086_lab24_vtp_dtp_fixes.down.sql
-- Reverts Lab 24 build/attack/harden phases to the pre-086 content (byte-identical
-- to the live DB snapshot taken before the up migration was applied).
-- Generated programmatically from the live DB — never hand-typed.

UPDATE lab_phases
SET content = $md$
<div class="mission"><span class="tag">◈ MISSION</span><h3>Propagate VLANs across the network</h3><p>VTP (VLAN Trunking Protocol) distributes VLAN information across switches. Create a VLAN on one switch and every switch in the domain learns it. DTP (Dynamic Trunking Protocol) negotiates trunk mode automatically. Both are convenience features — and both are security liabilities when left enabled.</p></div>
<div class="stats"><span class="chip xp">✦ 300 XP</span><span class="chip diff">◆ Beginner</span><span class="chip time">◷ ~20 min</span><span class="chip loot">⬡ VTP · VTP domain · VTP server/client · DTP · dynamic trunk</span></div>
<b>Topology:</b> SW1 (VTP server), SW2 (client), SW3 (transparent). Trunks between them. PC1–3 on VLANs.
<br/><b>Step 1</b> — VTP config on SW1: <code>vtp domain NETBREAKER</code>, <code>vtp mode server</code>, <code>vlan 10</code>, <code>name SALES</code>, <code>vlan 20</code>, <code>name ENG</code>.
<br/><b>Step 2</b> — SW2 client: <code>vtp domain NETBREAKER</code>, <code>vtp mode client</code>. SW2 learns VLANs 10 and 20 automatically.
<br/><b>Step 3</b> — SW3 transparent: <code>vtp mode transparent</code>. It forwards VTP updates but doesn't learn or advertise.
<br/><b>Step 4</b> — Verify: <code>show vtp status</code>, <code>show vlan brief</code>. SW2 shows VLANs 10 and 20 without manual config.
<div class="achievement"><span class="medal">🏗️</span><span class="txt">Achievement: VTP Apprentice</span></div>
$md$
WHERE lab_id = 24 AND phase = 'build';

UPDATE lab_phases
SET content = $md$
<div class="mission"><span class="tag">◈ MISSION</span><h3>Poison the VTP domain and trunk the attacker</h3><p>VTP has no authentication by default. An attacker who connects a switch with a higher revision number and a different VLAN database wipes or corrupts the entire domain. DTP lets any port become a trunk if the other side asks nicely.</p></div>
<div class="stats"><span class="chip xp">✦ 500 XP</span><span class="chip diff">◆ Intermediate</span><span class="chip time">◷ ~25 min</span><span class="chip loot">⬡ VTP poisoning · revision number · DTP spoof · VLAN hopping</span></div>
<b>Attack 1 — VTP poisoning:</b> From Kali (or a GNS3 switch), set a VTP revision higher than the server: <code>vtp domain NETBREAKER</code>, <code>vtp password anything</code>, delete all VLANs, then send a VTP advertisement. The entire VTP domain loses all VLANs — every switch drops its VLAN database. <code>show vlan brief</code> shows only VLAN 1.
<br/><b>Attack 2 — DTP trunk hijack:</b> launch <code>yersinia -I</code>, press <b>g</b> → <b>DTP</b>, press <b>x</b> → select the trunk-enabling attack. Kali negotiates trunk mode continuously; if the port is dynamic desirable/auto, it becomes a trunk. Press <b>q</b> to quit.. If the port is in dynamic desirable/auto, it becomes a trunk. Kali now receives traffic from ALL VLANs. <code>tcpdump -i eth0 -nn</code> shows frames from VLANs 10, 20, etc.
<br/><b>Attack 3 — Double tagging (VLAN hopping):</b> Send a frame with two 802.1Q tags: outer = native VLAN (1), inner = target VLAN (10). The first switch strips the outer tag and forwards the frame to VLAN 10. PC1 in VLAN 10 receives traffic from Kali even though Kali is not in VLAN 10.
<div class="achievement"><span class="medal">⚔️</span><span class="txt">Achievement: VTP Poisoner</span></div>
$md$
WHERE lab_id = 24 AND phase = 'attack';

UPDATE lab_phases
SET content = $md$
<div class="mission"><span class="tag">◈ MISSION</span><h3>Disable both protocols on user-facing ports</h3><p>VTP should be off or in transparent mode. DTP should be disabled with <code>switchport nonegotiate</code>. User-facing ports must be explicitly set to <code>switchport mode access</code>.</p></div>
<div class="stats"><span class="chip xp">✦ 200 XP</span><span class="chip diff">◆ Beginner</span><span class="chip time">◷ ~10 min</span><span class="chip loot">⬡ VTP off · nonegotiate · access mode</span></div>
<b>Step 1</b> — Disable VTP: <code>vtp mode transparent</code> on all switches. VTP never alters the VLAN database again.
<br/><b>Step 2</b> — Disable DTP on access ports: <code>int range et0/1-3</code> → <code>switchport mode access</code> → <code>switchport nonegotiate</code>. No trunk negotiation, period.
<br/><b>Step 3</b> — Set the native VLAN to an unused VLAN: <code>vlan 999</code> → <code>name DEAD</code>, then on trunk: <code>switchport trunk native vlan 999</code>. Double-tagging attacks fail because the native VLAN (1) doesn't exist on the trunk.
<div class="achievement"><span class="medal">🛡️</span><span class="txt">Achievement: Trunk Guardian</span></div>
$md$
WHERE lab_id = 24 AND phase = 'harden';

