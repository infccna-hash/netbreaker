-- ═══════════════════════════════════════════════════════════════════
-- Lab (id=45) — Ansible & Terraform : full content (Vol 2 · Ch 25)
-- ═══════════════════════════════════════════════════════════════════

UPDATE labs
SET short_desc = 'Manage a router with Ansible like a real team would — then plant one quiet manual change and watch how long "everything is automated" hides a device that has silently drifted from the truth.'
WHERE id = 45;

-- ─────────────────────────── BUILD ───────────────────────────
UPDATE lab_phases SET
  title = 'Automate It Properly',
  content = $md$
<div class="mission">
<span class="tag">◈ Mission Briefing — Phase 1 of 3</span>
<h3>Automate It Properly</h3>
<p>Ansible's whole pitch is: describe the desired state in a playbook, run it, and every device converges to match. That's genuinely powerful — right up until someone makes a manual change directly on a device and nobody re-runs the playbook to notice. Then "automated" quietly becomes "outdated documentation nobody trusts anymore."</p>
</div>

<div class="stats">
<span class="chip xp">✦ 500 XP</span>
<span class="chip diff">◆ Difficulty: ★★☆☆☆</span>
<span class="chip time">◷ ~15 min</span>
<span class="chip loot">⚿ Loot: Ansible playbooks · idempotent config management · declared vs. actual state</span>
</div>

## Your arsenal

| Component | Role |
|---|---|
| KALI | Runs as the Ansible control node |
| R1 | Managed device |

## Step 1 — Install Ansible and set up the inventory

```
sudo apt install -y ansible
mkdir ~/netbreaker-ansible && cd ~/netbreaker-ansible

cat > inventory.ini << 'EOF'
[routers]
R1 ansible_host=<R1-IP> ansible_user=admin ansible_password=AutomatedAdmin2026! ansible_connection=network_cli ansible_network_os=ios
EOF
```

## Step 2 — Write a playbook describing the desired state

```
cat > baseline.yml << 'EOF'
---
- name: Enforce baseline NTP and banner config
  hosts: routers
  gather_facts: no
  tasks:
    - name: Set NTP server
      ios_config:
        lines:
          - ntp server 10.0.0.1
    - name: Set login banner
      ios_config:
        lines:
          - banner motd ^C AUTHORIZED ACCESS ONLY ^C
EOF
```

## Step 3 — Run it and confirm convergence

```
ansible-playbook -i inventory.ini baseline.yml
```
```
! on R1, confirm it took effect
show run | include ntp server
show run | include banner
```

<div class="callout tip">
<p>This is the whole promise: run the same playbook again right now and Ansible reports zero changes, because the device already matches the declared state. That "zero changes" result is the thing an attacker — or just an unnoticed manual edit — can quietly break.</p>
</div>

<div class="achievement">
<span class="medal">🤖</span>
<span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">Declared and Delivered — the playbook and the device agree, for now</span></span>
</div>

**Next:** Phase 2 — make them disagree, quietly, and see how long it takes to notice.
$md$
WHERE lab_id = 45 AND phase = 'build';

-- ─────────────────────────── ATTACK ───────────────────────────
UPDATE lab_phases SET
  title = 'Drift Without a Trace',
  content = $md$
<div class="mission">
<span class="tag">◈ Mission Briefing — Phase 2 of 3</span>
<h3>Drift Without a Trace</h3>
<p>Config drift isn't usually dramatic. It's someone logging in directly, "just this once," to fix something quickly — and never running the playbook again to reconcile it. From the automation's point of view, everything still looks fine, because nobody asked it to check.</p>
</div>

<div class="callout danger">
<p><strong>Rules of engagement:</strong> run every command here against your own GNS3 lab only.</p>
</div>

<div class="stats">
<span class="chip xp">✦ 700 XP</span>
<span class="chip diff">◆ Difficulty: ★★☆☆☆</span>
<span class="chip time">◷ ~10 min</span>
<span class="chip loot">⚿ Loot: manual config drift · silent security-relevant changes · blind automation trust</span>
</div>

## Step 1 — Make a quiet, unauthorized change directly on the device

Playing the role of an attacker (or just an under-pressure admin skipping process) who has gained console/SSH access separately:

```
! directly on R1, bypassing Ansible entirely
enable
configure terminal
username backdoor privilege 15 secret Sh4dowAccess2026!
end
```

## Step 2 — Confirm Ansible has no idea anything changed

```
ansible-playbook -i inventory.ini baseline.yml
```

<div class="callout tip">
<p><strong>💥 That's the moment.</strong> Ansible reports success, zero changes needed — because the playbook was never told to check for unauthorized accounts. NTP and the banner still match, so as far as the automation is concerned, everything is exactly as declared. A full privilege-15 backdoor account is sitting on the device, completely invisible to the tool that's supposedly managing its configuration.</p>
</div>

## Step 3 — See how invisible it really is

```
! from Kali, as the "attacker"
ssh backdoor@<R1-IP>
! password: Sh4dowAccess2026!
enable
show running-config
```
Full privileged access, via an account the automation layer has zero awareness of.

<div class="achievement">
<span class="medal">👻</span>
<span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">Drift Ghost — a backdoor the automation swears doesn't exist</span></span>
</div>

**Next:** Phase 3 — make the playbook actually notice what it isn't looking for yet.
$md$
WHERE lab_id = 45 AND phase = 'attack';

-- ─────────────────────────── HARDEN ───────────────────────────
UPDATE lab_phases SET
  title = 'Declare the Whole State, Then Enforce It',
  content = $md$
<div class="mission">
<span class="tag">◈ Mission Briefing — Phase 3 of 3</span>
<h3>Declare the Whole State, Then Enforce It</h3>
<p>Config drift is invisible only because the playbook was never told what "wrong" looks like. Fix that two ways: make the declared state include exactly which accounts are allowed to exist, and run drift detection regularly instead of only when someone remembers to.</p>
</div>

<div class="stats">
<span class="chip xp">✦ 850 XP</span>
<span class="chip diff">◆ Difficulty: ★★★★☆</span>
<span class="chip time">◷ ~15 min</span>
<span class="chip loot">⚿ Loot: exhaustive state declaration · scheduled drift detection · check-mode auditing</span>
</div>

<ul class="objectives">
<li>Declare the exact, complete list of authorized local accounts</li>
<li>Have the playbook remove anything not on that list</li>
<li>Run drift detection on a schedule, not just on demand</li>
<li>Re-run the attack → the backdoor account gets removed automatically on the next run</li>
</ul>

## Fix 1 — Declare authorized accounts explicitly, and enforce exclusivity

```
cat > baseline.yml << 'EOF'
---
- name: Enforce full baseline including authorized accounts only
  hosts: routers
  gather_facts: no
  tasks:
    - name: Ensure only authorized accounts exist
      ios_config:
        lines:
          - username admin privilege 15 secret AutomatedAdmin2026!
        parents: []
    - name: Remove any account not explicitly authorized
      ios_config:
        lines:
          - no username backdoor
        # In practice: template this from a source-of-truth account list,
        # diffed against `show running-config | include username` each run.
    - name: Set NTP server
      ios_config:
        lines:
          - ntp server 10.0.0.1
    - name: Set login banner
      ios_config:
        lines:
          - banner motd ^C AUTHORIZED ACCESS ONLY ^C
EOF
```

## Fix 2 — Run it on a real schedule, not just when someone remembers

```
crontab -e
```
```
*/15 * * * * cd ~/netbreaker-ansible && ansible-playbook -i inventory.ini baseline.yml >> /var/log/ansible-drift.log 2>&1
```
Drift now gets caught within 15 minutes, automatically, instead of whenever a human happens to check.

## Fix 3 — Audit before you enforce (check mode)

```
ansible-playbook -i inventory.ini baseline.yml --check --diff
```
`--check` shows exactly what *would* change without applying it — genuinely useful for reviewing what drift has accumulated before blindly pushing a fix into a live network.

## Re-run the attack (the fun part)

Plant the backdoor account again:
```
! on R1
username backdoor privilege 15 secret Sh4dowAccess2026!
```
Wait for the next scheduled run, or trigger it manually:
```
ansible-playbook -i inventory.ini baseline.yml
```

<div class="callout tip">
<p>Ansible reports a change this time — <code>no username backdoor</code> applied — and the account is gone before anyone had to notice it by hand. Confirm from Kali: <code>ssh backdoor@&lt;R1-IP&gt;</code> now fails outright. The drift didn't get caught by luck; it got caught because the playbook finally knew what "correct" was actually supposed to mean.</p>
</div>

## Prove it to the grader

```
show running-config | include username    ! only authorized accounts present
cat /var/log/ansible-drift.log             ! scheduled runs, catching and reverting drift
```

<div class="achievement">
<span class="medal">🛡️</span>
<span class="txt"><span class="lbl">Achievement Unlocked</span><span class="name">True Source of Truth — the playbook finally knows the whole picture</span></span>
</div>

<div class="mission">
<span class="tag">✔ LAB COMPLETE</span>
<h3>Ansible &amp; Terraform — cleared</h3>
<p>A quiet, manual backdoor account sat invisibly on a fully "automated" device, because the automation was only checking the two things it had been told to check. Declaring the complete authorized state — accounts included — and running it on a real schedule turned "automation that missed it" into "automation that catches it in fifteen minutes."</p>
<p><strong>Total: 2050 XP</strong> · <strong>Curriculum complete: all 45 labs, every book chapter, build → attack → harden.</strong></p>
</div>
$md$
WHERE lab_id = 45 AND phase = 'harden';
