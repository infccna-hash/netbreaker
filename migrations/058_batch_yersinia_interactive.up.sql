-- Migration 058: Fix Labs 7, 19, 20, 24 — yersinia CLI-direct → -I interactive
--
-- All four labs use one-shot yersinia CLI-direct attacks that age out in ~20s.
-- Same bug class as Lab 2 (fixed in 055) and Lab 25 (fixed in 057).
-- Each protocol (CDP, DHCP, DTP) has its own attack panel in yersinia -I.
--
-- Lab  7: CDP flood   — yersinia cdp -attack 1    → yersinia -I → g→CDP  → x→flood
-- Lab 19: DHCP starve — yersinia dhcp -attack 1   → yersinia -I → g→DHCP → x→DISCOVER
-- Lab 20: DTP spoof   — yersinia dtp -attack 1    → yersinia -I → g→DTP  → x→trunk
-- Lab 24: DTP hijack  — yersinia dtp -attack 1    → yersinia -I → g→DTP  → x→trunk
--
-- Note: attack numbers in CDP/DHCP/DTP menus not yet console-verified.
-- Instructions guide to the menu without hardcoding unverified numbers.

-- ═══════════════════ Lab 7 — CDP flooding ═══════════════════
UPDATE lab_phases SET content = replace(
  content,
  $mig$## Step 3 — CDP flooding (DoS)

Yersinia can flood fake CDP advertisements:

```
sudo yersinia cdp -attack 1 -interface eth0
```

This sends thousands of CDP packets with forged device IDs. The switch CPU handles each CDP frame in process-switching mode — the flood causes high CPU.

Check on SW1:
```
show process cpu sorted | ex 0.00
```

You'll see the CPU spike from CDP processing.

<div class="callout warn"><p>Stop the flood after 30 seconds to avoid crashing the GNS3 switch. <code>Ctrl+C</code> stops Yersinia.</p></div>$mig$,
  $mig$## Step 3 — CDP flooding (DoS)

Launch yersinia in interactive mode:

```
yersinia -I
```

Inside the ncurses interface:
- press **g** → choose **CDP**
- press **x** → select the CDP flood attack (sends forged CDP advertisements continuously)

Unlike the one-shot CLI command, interactive mode keeps refreshing — the switch CPU stays pegged until you quit. Press **q** to exit when done.

Check on SW1 while the flood runs:
```
show process cpu sorted | ex 0.00
```

You'll see the CPU spike from CDP processing.

<div class="callout warn"><p>Stop the flood after 30 seconds to avoid crashing the GNS3 switch. Press <b>q</b> in yersinia to exit.</p></div>$mig$
)
WHERE lab_id = 7 AND phase = 'attack';

-- ═══════════════════ Lab 19 — DHCP starvation ═══════════════════
UPDATE lab_phases SET content = replace(
  content,
  $mig$## Attack 3 — Address exhaustion

Send massive DHCP requests to fill the pool on R1:
```
sudo yersinia dhcp -attack 1 -interface eth0
```

On R1:
```
show ip dhcp pool
show ip dhcp binding | count
```

The pool fills up. A new PC that boots and requests DHCP gets nothing.$mig$,
  $mig$## Attack 3 — Address exhaustion

Launch yersinia in interactive mode:

```
yersinia -I
```

Inside the ncurses interface:
- press **g** → choose **DHCP**
- press **x** → select the DISCOVER flood attack

Interactive mode sends DHCP DISCOVER packets continuously — the pool drains in seconds and stays exhausted until you quit. Press **q** to exit when done.

On R1 while the flood runs:
```
show ip dhcp pool
show ip dhcp binding | count
```

The pool fills up. A new PC that boots and requests DHCP gets nothing.$mig$
)
WHERE lab_id = 19 AND phase = 'attack';

-- ═══════════════════ Lab 20 — DTP spoof ═══════════════════
UPDATE lab_phases SET content = replace(
  content,
  $mig$## Attack 2 — DTP spoof (VLAN hopping)

Kali sends a DTP frame requesting trunk mode:
```
sudo yersinia dtp -attack 1 -interface eth0
```

If the switch port is configured as `dynamic desirable` or `dynamic auto`, it converts to trunk mode. Kali now receives traffic from ALL VLANs.

Check on SW1:
```
show interfaces Et0/2 trunk
```

If successful, Et0/2 shows up as a trunk carrying all active VLANs.$mig$,
  $mig$## Attack 2 — DTP spoof (VLAN hopping)

Launch yersinia in interactive mode:

```
yersinia -I
```

Inside the ncurses interface:
- press **g** → choose **DTP**
- press **x** → select the trunk-enabling attack

Interactive mode keeps negotiating — if the port is set to `dynamic desirable` or `dynamic auto`, it will convert to trunk mode and stay there until you quit. Press **q** to exit when done.

Check on SW1 while the attack runs:
```
show interfaces Et0/2 trunk
```

If successful, Et0/2 shows up as a trunk carrying all active VLANs. Kali now receives traffic from ALL VLANs.$mig$
)
WHERE lab_id = 20 AND phase = 'attack';

-- ═══════════════════ Lab 24 — DTP trunk hijack ═══════════════════
UPDATE lab_phases SET content = replace(
  content,
  $mig$<b>Attack 2 — DTP trunk hijack:</b> Kali sends DTP frames to negotiate trunk mode: <code>yersinia dtp -attack 1</code>$mig$,
  $mig$<b>Attack 2 — DTP trunk hijack:</b> launch <code>yersinia -I</code>, press <b>g</b> → <b>DTP</b>, press <b>x</b> → select the trunk-enabling attack. Kali negotiates trunk mode continuously; if the port is dynamic desirable/auto, it becomes a trunk. Press <b>q</b> to quit.$mig$
)
WHERE lab_id = 24 AND phase = 'attack';
