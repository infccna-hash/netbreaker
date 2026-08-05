# Design-Choice Audit — Session Handoff (2026-08-05)

## What happened this session
Verified all 12 Phase-2 "design-choice" labs (18, 27-29, 31-35, 43-45) against
written evidence (lab_phases text vs Go topology vs SVG).

Result: **7 clean, 5 with real text bugs.** The design-choice label only covered
the SVG simplification — the text was never checked until now.

## Closed this session
- **Migration 088** written + round-trip verified (up → idempotent → down →
  byte-identical). Fixes false "Already wired" claims:
  - Lab 33: `R1 → KALI directly, or through a switch — either works` → `R1 → SW1 → KALI`
  - Lab 34: `R1 → KALI directly` → `R1 → SW1 → KALI`
  - Lab 35: `PC1 → R1, KALI → R1` → `PC1 → SW1 → R1, KALI → SW1 → R1`
  (R1↔R2 stays — it IS direct in Go.)
- **Go topology surgery** committed (43f94e2): dropped ghost R2 (Lab 34),
  R3+PC2 (Lab 35). Verify-DSL gate passed — no verifier registered for 33/34/35.
  Port-conflict guard + full labsession suite pass.
- 088 NOT yet applied to VPS (round-trip left DB in original state). Applies on
  next API container rebuild. The Go topology changes also deploy with that rebuild.

## OPEN ITEM #5 — Labs 28/29: R2 is a missing step, NOT a ghost
- Lab 28 (IPv6): text says "R1 (gateway) + PC1 + PC2 + KALI" but Go has
  R1↔R2↔PC2. PC2's gateway is R2. Text never configures R2 → possibly unplayable.
- Lab 29 (TCP/UDP): same topology shape; KALI floods 192.168.1.200 but PC2 is
  behind unconfigured R2.
- Decision needed (pedagogical, not cleanup):
  - (a) In-scope: add R2 config step to text (teaches second hop) — richer lab
  - (b) Out-of-scope: flatten Go (PC2↔R1 directly) — topology surgery, changes
    what the lab teaches
- Do NOT bundle with a cleanup migration. This is a design decision for Yassine.

## Reference
Full methodology + psql CSV-fetch technique + findings:
`~/.hermes/skills/software-development/netbreaker-lab-builder/references/design-choice-written-evidence-verification.md`
