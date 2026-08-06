# Yersinia STP probe — KALI injects BPDU, IOU 15.1a err-disables (2026-08-05)

## Verdict: ✅ option (a) COMPLETE end-to-end

Test: isolated GNS3 project — SW1 (15.1a) Et0/2 portfast+bpduguard, KALI
(netbreaker-kali:2026-08-01-tmux-fixrows-v2) linked on eth0. Project torn
down after test.

## Results

### Attempt 1 — one-shot `yersinia stp -attack 1 -interface eth0`
```
<*> Starting NONDOS attack sending tcn BPDU...
%SPANTREE-2-BLOCK_BPDUGUARD: Received BPDU on port Et0/2 with BPDU Guard
  enabled. Disabling port.
```
The one-shot DID fire (contrary to the prior session's expectation that
one-shot is probabilistic — here it worked; the -I mode remains the
reliable fallback).

### Attempt 2 — interactive `yersinia -I` (g → STP, 1 → attack)
Et0/2 went err-disabled.

### Confirmation
```
show interfaces status → Et0/2: err-disabled
show logging | include BPDUGUARD → %SPANTREE-2-BLOCK_BPDUGUARD ... Disabling port
```

## Decision: implement option (a)

Lab 15 Fault 3 replacement — BPDU guard trap, full chain verified:
- KALI runs yersinia STP (one-shot or -I) → injects TCN BPDU
- SW1 Et0/2 (portfast + bpduguard) receives it → REAL err-disable
- Student diagnoses with the SAME tools the lab already teaches
  (show interfaces status → err-disabled, show errdisable recovery)
- Lab15AttackVerifier unchanged (final-state checks only: Et0/2 up + KALI
  reachable after the student fixes the fault)

Implementation steps (separate migration, following 088/091 pattern):
1. Update Lab 15 attack Step 0 text: replace the port-security block on
   Et0/2 with `spanning-tree portfast` + `spanning-tree bpduguard enable`,
   and the KALI trigger with `yersinia stp -attack 1 -interface eth0`
   (or -I fallback instructions).
2. Update Lab15AttackScenario (lab15_scenario.go) to match — commands must
   stay in sync with the text (same rule as migration 048's Step 0).
3. Update the Fault 3 table row: symptom "Port is err-disabled (BPDU
   guard)", tool "show interfaces status, show errdisable recovery".
4. Migration 092: byte-exact text update (substring approach like 091 —
   dump normalization makes verify_replace on long literals unreliable).
5. Full walkthrough Lab 15 again to confirm the new fault is observable.
