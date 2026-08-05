# IOU port-security capability test — 12.2 upk9 vs 15.1a (2026-08-05)

## Verdict: option (c) ELIMINATED — no IOU image can realize Lab 15 Fault 3

Test method: isolated GNS3 project, IOU switch + KALI docker, direct console
probe (not through NetBreaker). Project torn down after test.

## Results

### Image: i86bi-linux-l2-upk9-12.2 (template 26f0cc8d)
```
switchport                              → OK (accepted)
switchport port-security                → % Invalid input   ❌
switchport port-security maximum 1      → % Invalid input   ❌
switchport port-security violation...   → % Invalid input   ❌
switchport port-security mac-address..  → % Invalid input   ❌
show port-security                      → % Invalid input   ❌
```
The 12.2 image does NOT implement port-security at all — the command is
rejected outright. (It also boots with interfaces in "routed" mode; the
bare `switchport` command is accepted but the security subcommands are not
part of this image's feature set.)

### Image: i86bi-linux-l2-adventerprisek9-15.1a (current Lab 15 image)
- `switchport port-security ...` ALL accepted (config persists in running-config)
- BUT `Security Violation Count` stays 0 after a foreign-MAC frame
- `show port-security interface Et0/2` reports "Port Security: Disabled"
- Port never err-disables (confirmed twice in full walkthroughs)

## Conclusion
- 12.2: cannot even configure port-security.
- 15.1a: accepts the config but the violation trigger is inert.
- **No IOU image can produce an err-disabled port via port-security.**
  Fault 3 as written ("watch Et0/2 err-disable after KALI's frame") is
  unachievable on the platform.

## Decision path (for Yassine)
- (a) Replace Fault 3 with an IOU-realizable fault — e.g.:
  * BPDU guard / root-guard misconfig (IOU does implement spanning-tree
    guard features), or
  * a loopback/ACL blackhole, or
  * channel-group misconfig that the platform reports visibly.
  Requires testing which of these actually fires on 15.1a.
- (b) Soften the Lab 15 text: keep port-security config as "configure and
  verify it's armed" (show port-security interface shows max 1 + mode),
  drop the "watch it err-disable" claim, and re-key Fault 3 to a different
  observable symptom (or fold it into Fault 1/2/4 and add a 4th real fault).
- RECOMMENDATION: (b) is the cheapest and safest — the port-security
  config IS still a valuable teaching moment (it shows the policy armed),
  but the err-disabled drama is not achievable. (a) is higher value if a
  replaceable fault is found, but needs its own IOU capability probe.
