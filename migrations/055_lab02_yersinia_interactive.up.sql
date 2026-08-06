-- Migration 055: Replace yersinia -G/-I with verified -I interactive mode (Lab 2 Attack)
--
-- Console-truth (verified on live IOU + KALI container, 2026-07-31):
--   - yersinia -G (GTK GUI)    : impossible in KALI Docker container (no X11)
--   - yersinia -I (interactive): works, needs 25x80 terminal minimum
--   - yersinia stp -attack 4   : ONE-SHOT — sends 1 BPDU, exits. Network recovers in 20s.
--   - -I interactive mode      : continuously refreshes BPDUs every 2s — reliable hijack
--   - attack #4                : Claiming Root Role (verified in yersinia menu)
--   - no sudo needed           : KALI container runs as root (prompt shows root@KALI)
--   - resize command           : NOT installed in any KALI container; use stty only
--   - Root ID observed         : Priority 32769, Address aabb.cc00.0b00 (MAC-based win, not priority 0)
--
-- Fixes:
--   ATTACK Step 2: replace -G GUI + -I (wrong attack #1) → -I interactive (attack #4)
--   HARDEN: already fixed in prior session (shows yersinia -I, x→4) — skipped

-- ═══════════════════ ATTACK ═══════════════════
UPDATE lab_phases SET content = replace(
  content,
  $mig$## Step 2 — Claim the crown (Yersinia)

```
sudo yersinia -G
```
In the window: **Launch attack → STP → "Claiming Root Role."** Yersinia now announces a BPDU with priority <code>0</code> — lower than any default-priority switch could ever offer — and keeps refreshing it every 2 seconds so it never ages out.

Prefer the terminal?
```
sudo yersinia -I
# press  g  → choose STP
# press  x  → choose  1) Claiming Root Role
```$mig$,
  $mig$## Step 2 — Claim the crown (Yersinia)

Yersinia's interactive mode needs at least 25 rows × 80 columns. If your terminal is too small, drag the browser window taller, then:

```
stty rows 30 columns 100
```

Launch yersinia (no `sudo` — you're already root in KALI):

```
yersinia -I
```

Inside the ncurses interface:
- press **g** → choose **STP**
- press **x** → choose **4) claiming root role**

Yersinia starts flooding a spoofed BPDU every 2 seconds. The BPDU carries a Bridge ID whose MAC address (`aabb.cc00.0b00`) is lower than any real switch on the network — so it wins the root election by tiebreaker, since every switch defaults to the same priority (32768). The attack keeps refreshing until you quit. Press **q** to exit when you're done.$mig$
)
WHERE lab_id = 2 AND phase = 'attack';
