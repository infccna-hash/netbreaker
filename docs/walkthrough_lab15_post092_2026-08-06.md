# Lab 15 Walkthrough — post-092 BPDU-guard Fault 3 — 2026-08-06

## Result: ✅ FULLY VERIFIED — new Fault 3 (BPDU guard) observable end-to-end

Session `12361ccc` (fresh walk15_* account, correct order: build → attack →
diagnose → fix → verify). This closes the walkthrough loop for the
port-security → BPDU-guard migration.

## What was verified live

### Phase Build — complete ✅
- R1 Et0/0 = 192.168.1.1/24; KALI + KALI2 ping gateway 0% loss before Step 0

### NEW Step 0 (bpduguard fault) — applied ✅
```
interface Et0/0  shutdown
interface Et0/1  switchport access vlan 99
interface Et0/2  spanning-tree portfast
                 spanning-tree bpduguard enable
interface Et0/3  shutdown
```
Confirmed in `show run interface Et0/2`: portfast + bpduguard present.

### KALI trigger — yersinia one-shot ✅
```
timeout 15 yersinia stp -attack 1 -interface eth0
→ <*> Starting NONDOS attack sending tcn BPDU...
```

### THE DRAMA — REAL err-disable ✅ (the point of option (a))
```
show interfaces status → Et0/2: err-disabled
show logging | include BPDUGUARD →
  *Aug 6 08:25:34.122: %SPANTREE-2-BLOCK_BPDUGUARD: Received BPDU on
  port Et0/2 with BPDU Guard enabled. Disabling port.
```
The student SEES the port err-disable with the syslog — the exact
observable the old port-security Fault 3 promised but could never deliver
on IOU.

### Diagnosis tools (new text) — verified present
- `show errdisable recovery` → bpduguard cause listed (timer 300s)
- `show logging | include BPDUGUARD` → syslog evidence

### Fix phase — complete ✅
All 4 ports back to connected/vlan 1. KALI → gateway restored (3/3,
0% loss — note: first ping right after `no shutdown` may fail briefly
while the recovered link stabilizes; not a bug).

## Verdict
Migration 092 is fully validated in a real session. Fault 3 now teaches
a REAL err-disable (BPDU guard + yersinia), matching the text promise:
"not simulated, not scripted, the switch really did detect and react."
