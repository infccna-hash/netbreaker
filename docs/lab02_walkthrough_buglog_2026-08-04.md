# Lab 2 Walkthrough — Bug Log (console-truth, 2026-08-04)

Session: `22642251-f96c-44a1-88a6-03047737c05b` (walk2_1785875659@test.local, pro)
Topology: SW1/SW2/SW3 triangle + PC1 (SW1 Et0/1) + KALI (SW3 Et0/2)
Image: 15.1a (Lab 2 has no DTP dependency — 12.2 swap NOT needed here)

## Walkthrough verdict

| Phase | Conditions | Verdict |
|---|---|---|
| Build | 4/4 | ✅ PASS (but see P1-1: instructions wrong for SW1/SW3, saved by DTP luck) |
| Attack | all | ✅ PASS (root claim verified both sides; Boss Fight TCN verified) |
| Harden | objectives | ⚠️ PARTIAL — BPDU Guard perfect; Root Guard as written breaks the network (P1-2) |

## Bugs found

### P0-1 — Grader collectors are stubs; Lab 2 CANNOT pass for any student
- **Location**: `internal/verify/ios_collector.go` lines 104-110
- `CollectSTP()` and `CollectPortSecurity()` still `return nil, ErrNotImplemented`
- The real parsers (`ParseSTP`, `ParsePortSecurity` in `stp_parser.go`) were committed (36945ce, a4b6565) but **never wired into the collectors** — commit message "removes last stub" is wrong
- Live verify response: `hints: ['collect stp: parser not implemented — pending real capture of ']` → `passed: false`
- Even with a perfect lab, every Lab 2 phase verify fails. **Fix: wire CollectSTP → ParseSTP, CollectPortSecurity → ParsePortSecurity in ios_collector.go**

### P0-2 — Harden verifier asserts the wrong port
- **Location**: `internal/labsession/lab02_verify.go` — `ExpectPortRole("SW2", "Et0/2", "Altn")`
- Console truth: healthy hardened state = SW2 Et0/2 is **Desg FWD**; the loop-blocked port is **SW3 Et0/3 = Altn BLK**
- Verifier target is wrong; would fail even after P0-1 is fixed. **Fix: ExpectPortRole("SW3", "Et0/3", "Altn")**

### P1-1 — Build content: `interface range Ethernet0/1 - 2` wrong for SW1 and SW3
- **Location**: Lab 2 build phase, "Step 1 — Wire the triangle"
- Content says run the same range on all three switches. Real topology:
  - SW1: inter-switch = **Et0/0** (SW2) + Et0/2 (SW3); **Et0/1 = PC1 (host!)**
  - SW2: Et0/1 + Et0/2 = both inter-switch ✓ (only switch where content is right)
  - SW3: Et0/1 (SW1) + **Et0/3** (SW2); **Et0/2 = KALI (host!)**
- Result: SW1 trunked PC1's port and MISSED the SW2 link; SW3 trunked KALI's port and MISSED the SW2 link. Both missing links only came up as trunks via DTP auto-negotiation (`mode desirable`, not `on`)
- Fix candidate: per-switch port lists, e.g. SW1 `interface range Ethernet0/0 , Ethernet0/2`, SW3 `interface range Ethernet0/1 , Ethernet0/3` — console-verified pattern needed before writing migration

### P1-2 — Harden Fix 3 (Root Guard): unspecified switch + breaks the network as written
- **Location**: Lab 2 harden phase, "Fix 3 — Root Guard"
- Content: `interface Ethernet0/1` + `spanning-tree guard root` — no switch named. Natural reading (continuing from Fix 2 on SW3) = SW3 Et0/1, which faces **SW1 the real root**
- Live result: `%SPANTREE-2-ROOTGUARD_BLOCK: Root guard blocking port Ethernet0/1 on VLAN0001` → port `BKN* ROOT_Inc` — SW3's uplink to the legitimate root dies, network re-routes through SW2
- On a 3-switch triangle where all switches are trusted, the content's own narrative ("link to a branch office switch you don't fully trust") doesn't match the topology
- Fix candidate: either specify the meaningful port (e.g., demonstrate on a link where an untrusted root claim could arrive) or reframe the step for this topology

### P2-1 — Boss Fight observable subtler than described (mechanism works)
- Content: "run `show mac address-table count` twice — count resets periodically"
- Console truth: MAC count dropped 8 → 2 (aging timer 300 → 15s confirmed, `Aging Time 15 sec`) but the count **settles at 2, doesn't visibly oscillate**; "Number of topology changes" stays at 3 (IOU counts real transitions, not TCN receipts)
- The TCN flood DOES work (aging drops, MACs flush) — wording just oversells the observable

## Already-correct things (verified, no change)
- ✅ Build verifier `ExpectRootBridge("SW1")` — SW1 is root in build state (24577 after root primary)
- ✅ Attack verifier `ExpectPortRole("SW3","Et0/2","Root")` — Kali's port becomes Root port during attack
- ✅ BPDU Guard works perfectly: `%SPANTREE-2-BLOCK_BPDUGUARD` → Et0/2 err-disabled (bpduguard) → attack defeated, SW1 stays root
- ✅ `yersinia stp -attack 4` (claim root) and `stp -attack 3` (TCN flood) both work via CLI one-shot
- ✅ Content's "Prove it to the grader" evidence all verifiable (err-disabled shows `KALI-ACCESS-PORT bpduguard`)
- ✅ `yersinia -I` interactive renders on the 40x130 fixrows PTY (menu navigation partially driveable; CLI one-shots are the reliable path)

## Cleanup
- Session ended (HTTP 204), heartbeat killed, project deleted, zero IOU processes left
- Only foreign dynamips (nb-u0-l15-1785852662) remains — untouched per policy

## Resolution (2026-08-04, post-code-fix)

- **P0-1 (collector stubs)**: FIXED + PROVEN — wired CollectSTP/CollectPortSecurity to real parsers (commit a10edc1). Deployed binary no longer contains the ErrNotImplemented string; build verify = 100/100 on a live session.
- **P0-2 (verifier wrong port)**: FIXED + PROVEN — assertion corrected to SW3 Et0/3 (commit a10edc1) AND registry target device corrected SW2→SW3 (commit c7001ba). The registry target was the deeper bug: the assertion said SW3 but the collector drove SW2's console (debug showed bridge aa:bb:cc:00:04:00), so the check failed "found Desg" forever despite a correct lab. Debug field (temporary) exposed it; stripped in the same pass.
- **Hidden landmine (IOU console handshake)**: FIXED — GNS3 IOU consoles replay pending output to new connections; the collector's first prompt-match could land inside the replay and corrupt every command's output attribution. RunCommand now drains 3× to a settled prompt (commits 16824a5, b826fcb). Negative-control tests model the replay regression.
- **Migration 087**: APPLIED + ROUND-TRIP VERIFIED (up→up→down byte-identical vs live DB) + RE-WALKTHROUGH PASSED. Fresh session following the fixed content literally: build 100, attack 100, harden 100.
- **Cleanup incident (2026-08-04)**: two GNS3 projects (59e7be3e, da84c928) belonging to inf.ccna@gmail.com (Yassine's OWN test account, confirmed by user) were deleted during walkthrough cleanup — matched by name prefix instead of session ownership. No real students affected. Lesson recorded: verify user_id before any project/session teardown.

## Outcome
Lab 2 grader fully green on a fresh session end-to-end (3/3 phases, score 100 each). P0-1/P0-2 dead, content corrected, hidden console-handshake bug fixed with regression tests.

