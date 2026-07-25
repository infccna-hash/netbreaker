-- ═══════════════════════════════════════════════════════════════════
-- Lab (id=43) — Network Automation & SDN : full content (Vol 2 · Ch 22)
-- ═══════════════════════════════════════════════════════════════════

UPDATE labs
SET short_desc = 'Talk to a device''s RESTCONF API with zero credentials — then realize that centralizing control also means centralizing exactly how much one open door can cost you.'
WHERE id = 43;

-- ─────────────────────────── BUILD ───────────────────────────
UPDATE lab_phases SET
  title = 'Map the Planes',
  content = $md$
<div class="mission">
<span class="tag">◈ Mission Briefing — Phase 1 of 3</span>
<h3>Map the Planes</h3>
<p>Every network device runs three logically separate jobs at once: the <strong>data plane</strong> (actually forwarding packets), the <strong>control plane</strong> (deciding how — routing protocols, STP, ARP), and the <strong>management plane</strong> (letting a human or a script configure the thing — SSH, RESTCONF, NETCONF). SDN's whole pitch is centralizing the control plane into software, away from individual boxes. That's a real operational win. It also means whoever can reach that centralized control point can reach a lot more than they used to be able to from any single device.</p>
</div>

<div class="stats">
<span class="chip xp">✦ 500 XP</span>
<span class="chip diff">◆ Difficulty: ★★☆☆☆</span>
<span class="chip time">◷ ~15 min</span>
<span class="chip loot">⚿ Loot: control/data/management plane separation · RESTCONF basics · API-driven config</span>
</div>

## Your arsenal

| Component | Role |
|---|---|
| R1 | Network device, RESTCONF enabled |
| KALI | Speaks to R1's API directly |

## Step 1 — Classify what you already know

Before touching anything, sort these into the right plane (do this in your head or on paper — it's the actual exam-relevant skill):

<ul class="objectives">
<li>OSPF exchanging routes — <em>which plane?</em></li>
<li>A switch forwarding a frame it already has a MAC entry for — <em>which plane?</em></li>
<li>An admin running <code>show running-config</code> over SSH — <em>which plane?</em></li>
<li>A RESTCONF client pushing a new interface config — <em>which plane?</em></li>
</ul>
<p class="muted" style="font-size:0.85rem">(Answers: control, data, management, management — RESTCONF is a management-plane protocol, even though what it configures affects the other two.)</p>

## Step 2 — Enable RESTCONF on R1

```
enable
configure terminal
restconf
ip http secure-server
end
```

## Step 3 — Confirm it's listening

```
! from Kali
curl -k https://<R1-IP>/restconf/data/ietf-interfaces:interfaces
```
Right now this should prompt for credentials or return an auth error — confirm RESTCONF is reachable at all before moving on.

<div class="callout tip">
<p>Notice what you just did: reached into the device's management plane over HTTPS, the same way an SDN controller's northbound API would. This is the exact mechanism a centralized controller uses to reprogram many devices at once — which is exactly what makes Phase 2 worth paying attention to.</p>
</div>

<div class="achievement">
<span class="medal">🗺️</span>
<span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">Plane Spotter — you can now tell the three jobs apart on sight</span></span>
</div>

**Next:** Phase 2 — find out what happens when that API door isn't actually locked.
$md$
WHERE lab_id = 43 AND phase = 'build';

-- ─────────────────────────── ATTACK ───────────────────────────
UPDATE lab_phases SET
  title = 'Walk Through the Unlocked API',
  content = $md$
<div class="mission">
<span class="tag">◈ Mission Briefing — Phase 2 of 3</span>
<h3>Walk Through the Unlocked API</h3>
<p>RESTCONF was enabled in Phase 1 without any additional AAA scoping specific to it — it inherited whatever credentials happen to already work, or worse, is left reachable with defaults nobody rotated. Either way, the moment someone can reach this API without a real barrier, they have management-plane access to the device — read and write both.</p>
</div>

<div class="callout danger">
<p><strong>Rules of engagement:</strong> run every command here against your own GNS3 lab only.</p>
</div>

<div class="stats">
<span class="chip xp">✦ 700 XP</span>
<span class="chip diff">◆ Difficulty: ★★★☆☆</span>
<span class="chip time">◷ ~10 min</span>
<span class="chip loot">⚿ Loot: RESTCONF read/write access · unauthenticated management API risk</span>
</div>

## Step 1 — Pull the full running config via the API

```
curl -k -u <weak-or-default-creds> https://<R1-IP>/restconf/data/Cisco-IOS-XE-native:native \
  -H "Accept: application/yang-data+json"
```

<div class="callout tip">
<p><strong>💥 That's the moment.</strong> The entire device configuration comes back as structured JSON — interfaces, routing, ACLs, everything — over an API that most network defenders aren't watching nearly as closely as they watch SSH.</p>
</div>

## Step 2 — Push a change, not just read one

```
curl -k -u <weak-or-default-creds> -X PATCH \
  https://<R1-IP>/restconf/data/ietf-interfaces:interfaces/interface=GigabitEthernet1 \
  -H "Content-Type: application/yang-data+json" \
  -d '{"ietf-interfaces:interface":{"enabled":false}}'
```

<div class="callout tip">
<p>You just disabled a live interface using nothing but an HTTP request. In a real SDN-managed environment, this exact class of access — an under-protected northbound API — is how one compromised credential or one forgotten default becomes a multi-device, multi-site incident, because the whole point of centralization is that many devices trust the same control point.</p>
</div>

<div class="achievement">
<span class="medal">🕹️</span>
<span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">Remote Control — one API call reprogrammed a live device</span></span>
</div>

**Next:** Phase 3 — treat the management plane's API with exactly the seriousness the control plane deserves.
$md$
WHERE lab_id = 43 AND phase = 'attack';

-- ─────────────────────────── HARDEN ───────────────────────────
UPDATE lab_phases SET
  title = 'Guard the Centralized Door',
  content = $md$
<div class="mission">
<span class="tag">◈ Mission Briefing — Phase 3 of 3</span>
<h3>Guard the Centralized Door</h3>
<p>Centralization isn't the mistake — leaving the centralized door unlocked is. The fix is layered: real authentication and authorization scoped specifically to the API, and restricting exactly where that API can even be reached from.</p>
</div>

<div class="stats">
<span class="chip xp">✦ 800 XP</span>
<span class="chip diff">◆ Difficulty: ★★★★☆</span>
<span class="chip time">◷ ~15 min</span>
<span class="chip loot">⚿ Loot: AAA-scoped API access · management-plane ACLs · defense-in-depth for automation</span>
</div>

<ul class="objectives">
<li>Require strong, unique credentials for the RESTCONF session (never reused elsewhere)</li>
<li>Restrict RESTCONF access to a management-only source subnet</li>
<li>Scope AAA authorization to explicitly cover API sessions, not just SSH</li>
<li>Re-run the attack → blocked by source restriction before credentials even matter</li>
</ul>

## Fix 1 — Real AAA, scoped to cover the API too

```
configure terminal
aaa new-model
aaa authentication login default local
aaa authorization exec default local
username api-admin privilege 15 secret Str0ngUniqueAPIcred!2026
end
```

## Fix 2 — Restrict the API to a management subnet only

```
configure terminal
ip access-list standard MGMT-ONLY
 permit 10.99.0.0 0.0.0.255
 deny any log
!
control-plane
 service-policy input MGMT-ACL-POLICY
end
```
(Exact syntax varies by platform — the principle is the one that matters: RESTCONF/NETCONF should never be reachable from the same broad network as ordinary end hosts.)

## Re-run the attack (the fun part)

From Kali, still on the regular client subnet:
```
curl -k -u api-admin:Str0ngUniqueAPIcred!2026 https://<R1-IP>/restconf/data/ietf-interfaces:interfaces
```

<div class="callout tip">
<p>Connection refused or timed out — Kali isn't on the management subnet, so it never even gets far enough to present credentials, correct or not. The API is exactly as centralized and powerful as before; it's just no longer reachable from anywhere an attacker is likely to actually be sitting.</p>
</div>

## Prove it to the grader

```
show running-config | include restconf|aaa   ! AAA scoping present
show ip access-lists MGMT-ONLY                ! source restriction active
```

<div class="achievement">
<span class="medal">🛡️</span>
<span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">Locked Control Point — centralized power, finally centralized protection to match</span></span>
</div>

<div class="mission">
<span class="tag">✔ LAB COMPLETE</span>
<h3>Network Automation &amp; SDN — cleared</h3>
<p>You mapped the three planes, then used an unauthenticated management-plane API to read a full device config and remotely disable a live interface with one HTTP request — exactly the risk that comes with centralizing control. Real AAA scoped to the API, plus restricting it to a management-only subnet, closed the gap without giving up any of the automation.</p>
<p><strong>Total: 2000 XP</strong> · Next target: <code>REST APIs &amp; Data Formats</code>, where the same idea shows up again wearing NETCONF instead of RESTCONF.</p>
</div>
$md$
WHERE lab_id = 43 AND phase = 'harden';
