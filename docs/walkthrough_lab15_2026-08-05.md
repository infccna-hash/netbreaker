# Lab 15 Walkthrough — partial (session TTL expired mid-run) — 2026-08-05

## Result: ⚠️ BUG FOUND — port-security fault cannot occur on IOU 15.1a

Walkthrough session `336633f6-acea-4dd8-ad1d-8eaf348f66c8` (Lab 15, fresh
walk15_* account). Session aged out (TTL) before the build→attack sequence
was fully walked; the attack-phase setup and diagnostics below were captured
live before expiry.

## What was verified live

### Step 0 (4 faults) — applied successfully on SW1 console
- Et0/0 `shutdown` ✅ (LINK-5-CHANGED administratively down observed)
- Et0/1 `switchport access vlan 99` ✅ (VLAN 99 auto-created)
- Et0/2 port-security: max 1, violation shutdown, MAC 0000.0000.0001 ✅
  (confirmed in `show run interface Et0/2`)
- Et0/3 `shutdown` ✅

### THE BUG — port-security violation never fires on IOU 15.1a
After KALI (real MAC 02:42:ce:30:a7:00) pinged 192.168.1.1 through Et0/2
(whose only allowed MAC is the statically-configured 0000.0000.0001):

```
show port-security interface Et0/2
  Port Security              : Disabled     ← should be Enabled
  Port Status                : Secure-down
  Violation Mode             : Shutdown
  Maximum MAC Addresses      : 1
  Total MAC Addresses        : 1
  Security Violation Count   : 0            ← should be >= 1
  Last Source Address:Vlan   : 0000.0000.0000:0

show interfaces status → Et0/2 connected (NOT err-disabled)
show interfaces Et0/2   → up/up (connected)
show port-security      → empty table, Total Addresses: 0
```

The lab text (attack phase) claims: "Et0/2 is now actually err-disabled —
not simulated, not scripted, the switch really did detect and react to a
real violation." Reality: **the IOU L2 image does not trip the violation.**
Fault 3 in the attack table ("Port is err-disabled", tool: `show interfaces
status, show errdisable recovery`) therefore cannot be observed by a student.

### Impact assessment
- `Lab15AttackVerifier` does NOT check for a violation/err-disabled state —
  it checks `ExpectInterfaceUp("Et0/2")` + `ExpectReachable(KALI,...)`
  (final state). So a student CAN still pass the phase after fixing all 4
  faults.
- BUT the pedagogical Fault-3 experience is broken: the student follows
  Step 0 verbatim, never sees err-disabled, and `show errdisable recovery`
  shows an empty "Interfaces that will be enabled" list.
- Same failure shape as the documented speed/duplex IOU gap (see
  lab15_verify.go harden notes): IOU accepts the config but the trigger
  mechanism is inert.

### Fixes applied during walkthrough (all 4 ports back to connected/vlan 1)
Et0/0 no shutdown, Et0/1 access vlan 1, Et0/2 no port-security, Et0/3 no
shutdown — verified `show interfaces status` all connected vlan 1.

### Secondary observation
Fresh session has NO starter config on R1 (Et0/0 `shutdown`, `no ip
address`). The build phase text instructs the student to configure
192.168.1.1 — expected, not a bug. Walkthrough error on my side: I applied
attack Step 0 before the build phase, so the gateway never existed during
the violation test. The violation STILL should have fired regardless
(port-security is L2, independent of gateway IP), so the bug finding stands.

## Open question for Yassine
- Fix options for Fault 3:
  a) Replace the port-security trap with a different 4th fault that IOU
     CAN realize (e.g. a stray root-port / spanning-tree change, or an
     access-list blackhole, or duplex mismatch).
  b) Keep the config but soften the text ("configure port-security and
     verify it's armed" instead of "watch it err-disable").
  c) Test on a different IOU image (12.2 upk9 — already proven to accept
     DTP; unknown whether its port-security violation fires).
