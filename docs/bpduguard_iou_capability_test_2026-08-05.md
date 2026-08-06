# IOU BPDU guard capability test — 15.1a (2026-08-05)

## Verdict: ✅ option (a) VIABLE — BPDU guard produces a REAL err-disabled state

Test method: isolated GNS3 project, two IOU 15.1a switches, direct console
probe. SW_A Et0/1 = access + portfast + bpduguard; SW_B (STP default) sends
BPDUs on the link. Project torn down after test.

## Result — the mechanism fires on IOU 15.1a

SW_A console log:
```
%SPANTREE-2-BLOCK_BPDUGUARD: Received BPDU on port Et0/1 with BPDU Guard
  enabled. Disabling port.
%PM-4-ERR_DISABLE: bpduguard error detected on Et0/1, putting Et0/1 in
  err-disable state
show interfaces status → Et0/1: err-disabled
```

This is the REAL observable drama Fault 3 was supposed to provide:
- port genuinely err-disabled
- system log messages (BLOCK_BPDUGUARD + PM-4-ERR_DISABLE)
- `show interfaces status` shows `err-disabled`
- `show errdisable recovery` lists the cause (bpduguard) — in the probe the
  "Interfaces that will be enabled" list was read too early (port already
  err-disabled, timer pending); the mechanism itself is confirmed by the
  syslog + status.

## Decision impact

Option (a) — replace Lab 15 Fault 3 with a BPDU-guard trap — is now VIABLE:
- The student Step 0 can configure `spanning-tree portfast` +
  `spanning-tree bpduguard enable` on Et0/2 (KALI's port), then... wait —
  NOTE: the trap must be TRIGGERED by something that sends a BPDU. In the
  lab, KALI (a Linux host) does not send BPDUs by default. The trigger
  needs to come from a real switch acting as rogue, or yersinia-style STP
  injection from KALI. Design detail for the lab text:
  - (i) KALI runs yersinia STP attack (yersinia -I stp -attack 1 or the
    like) to inject a fake BPDU → Et0/2 err-disables. This keeps the
    "KALI causes the fault" narrative of the current lab.
  - (ii) Or restructure: the rogue is another switch in the topology
    (Lab 15 has only one switch — SW1 — so (ii) needs a topology change,
    which (i) avoids).
- Verifier impact: Lab15AttackVerifier's `ExpectInterfaceUp("Et0/2")` +
  `ExpectReachable(KALI)` still work as final-state checks. No verifier
  change needed for the final-state assertions.

## Recommendation
Go with option (a): replace the port-security Step-0 block on Et0/2 with
the bpduguard trap, triggered by KALI via yersinia STP injection (no
topology change). Test yersinia's STP attack on the KALI image next —
it must actually send a BPDU the switch detects (the one remaining probe).
If yersinia STP works on KALI → full (a) implementation. If not → fall
back to (b) (soften text), still informed.
