# Walkthrough Log — 34/35 post-surgery (2026-08-05)

## Result: ✅ CLOSED — both surgeries verified on real GNS3

Script: `scripts/walkthrough_34_35_post_surgery.sh` (committed 7cfe590)
Run by: Hermes agent (Warda) from Falcon, 2026-08-05 ~19:50 UTC

### Lab 34 — surgery verified
- Expected: KALI R1 SW1 (NO R2)
- Got: `KALI R1 SW1` ✅
- Consoles: R1:5000, SW1:5001, KALI:5002
- Session ended cleanly (DELETE 204)

### Lab 35 — surgery verified
- Expected: KALI PC1 R1 R2 SW1 (NO R3, NO PC2)
- Got: `KALI PC1 R1 R2 SW1` ✅
- Consoles: R1:5000, R2:5001, SW1:5002, PC1:5003, KALI:5005
- Session ended cleanly (DELETE 204)

### Notes
- Migration 088 (text fixes) + Go surgery (drop R2 from 34, R3+PC2 from 35)
  are now both verified end-to-end. The unit suite mocks GNS3 and cannot
  catch provisioning-layer bugs (the Lab 2 class); the fresh-session walk
  closes that gap.
- Both sessions were launched under fresh walkthrough accounts
  (walk34_<ts>@test.local), upgraded to pro via direct DB update (the
  standard walkthrough pattern), then torn down immediately.
- Pre-walkthrough gate respected: the foreign Lab 15 session 77082f29 had
  already been force-ended by the reaper (see reaper log 19:38:05), so no
  cross-session interference.

## Reaper escalation observed live (bonus)
77082f29 teardown: 3 attempts failed with "context deadline exceeded"
(19:37:04 → 19:38:04), then force-ended at 19:38:05 — the Tier-2 escalation
added this session worked exactly as designed (61s to free the slot vs the
79aa8f2b 24h+ silent leak).
