-- Revert 055: restore original yersinia -G/-I content (migration 009)
-- Restores the exact Attack Step 2 section.

-- ═══════════════════ ATTACK ═══════════════════
UPDATE lab_phases SET content = replace(
  content,
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

Yersinia starts flooding a spoofed BPDU every 2 seconds. The BPDU carries a Bridge ID whose MAC address (`aabb.cc00.0b00`) is lower than any real switch on the network — so it wins the root election by tiebreaker, since every switch defaults to the same priority (32768). The attack keeps refreshing until you quit. Press **q** to exit when you're done.$mig$,
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
```$mig$
)
WHERE lab_id = 2 AND phase = 'attack';
