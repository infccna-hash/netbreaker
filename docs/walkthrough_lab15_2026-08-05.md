# Lab 15 Walkthrough — 2026-08-05

## Result: ⚠️ BUG CONFIRMED (2 runs) — port-security fault cannot occur on IOU 15.1a

Run 1: session `336633f6` (partial — session TTL expired mid-run; attack Step
0 applied before build, a walkthrough sequencing error on the agent side).
Run 2: session `a44174bd` (COMPLETE — build → attack → diagnose → fix, correct
order). **The port-security bug reproduced identically in both runs, including
the clean second run where the build phase was fully complete (R1 gateway up,
KALI reaching 192.168.1.1 with 0% loss before Step 0).**

## What was verified live (Run 2, correct order)

### Phase Build — COMPLETE ✅
- R1 Et0/0 = 192.168.1.1/24 (verified: KALI + KALI2 ping gateway 0% loss)
- PC1 .10, PC2 .20, PC3 .30 (VPCS, gateway 192.168.1.1)
- KALI .100, KALI2 .101 + default routes
- Hub traffic generated (PC1→PC2 3/3) — verifier build MAC learning satisfied

### Attack Step 0 — 4 faults applied ✅
- Et0/0 disabled, Et0/1 → vlan 99, Et0/2 port-security (max 1, violation
  shutdown, static MAC 0000.0000.0001), Et0/3 disabled
- Cold diagnosis: Fault 1/4 visible (disabled), Fault 2 visible (vlan 99),
  Fault 3 NOT observable — see bug below

### THE BUG (reproduced twice, clean conditions)
After KALI (real MAC 02:42:ce:30:a7:00) pinged 192.168.1.1 through Et0/2
(only allowed MAC: static 0000.0000.0001):
```
show port-security interface Et0/2
  Port Security              : Disabled     ← should be Enabled
  Security Violation Count   : 0            ← should be >= 1
  Last Source Address:Vlan   : 0000.0000.0000:0
show interfaces status → Et0/2 connected (NOT err-disabled)
show errdisable recovery  → empty "Interfaces that will be enabled" list
```
The lab text claims "Et0/2 is now actually err-disabled — the switch really
did detect and react." Reality: IOU L2 accepts the port-security config but
never increments the violation counter when a foreign MAC sends a frame.
Fault 3 is unobservable by students.

### Fix phase — complete ✅
All 4 ports back to connected/vlan 1; post-fix connectivity verified
(KALI2→gw 2/2, PC1→PC2 2/2).

## Impact & options (from Run 1, still open)
- Lab15AttackVerifier checks final state only (Et0/2 up + KALI reachable),
  so the phase is passable — but the pedagogical Fault-3 experience is broken.
- Options: (a) replace Fault 3 with an IOU-realizable fault, (b) soften the
  text, (c) test 12.2 upk9 port-security behavior. RECOMMEND (c) first — cheap
  and decisive; if 12.2 fires the violation, the fix is a one-line image swap.
