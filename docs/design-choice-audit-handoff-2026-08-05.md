# Design-Choice Audit — Session Handoff (2026-08-05)

## What happened this session
Verified all 12 Phase-2 "design-choice" labs (18, 27-29, 31-35, 43-45) against
written evidence (lab_phases text vs Go topology vs SVG).

Result: **7 clean, 5 with real text bugs.** The design-choice label only covered
the SVG simplification — the text was never checked until now.

## Deployed this session — 088 + Go surgery LIVE on VPS
- **Migration 088 DEPLOYED** (schema_migrations=88). Fixes false "Already wired"
  claims:
  - Lab 33: `R1 → KALI directly, or through a switch — either works` → `R1 → SW1 → KALI`
  - Lab 34: `R1 → KALI directly` → `R1 → SW1 → KALI`
  - Lab 35: `PC1 → R1, KALI → R1` → `PC1 → SW1 → R1, KALI → SW1 → R1`
  (R1↔R2 stays — it IS direct in Go.)
- **Go topology surgery deployed** (commit 43f94e2): dropped ghost R2 (Lab 34),
  R3+PC2 (Lab 35). Verify-DSL gate passed — no verifier registered for 33/34/35.
  Port-conflict guard + full labsession suite pass.
- API container rebuilt + recreated; `/api/v1/labs/33` serves corrected content.
- Round-trip verified pre-deploy (up → idempotent → down → byte-identical).

## ⚠ OPEN — surgery NOT verified on real GNS3 yet
The Go unit suite mocks GNS3; it cannot catch provisioning bugs. The surgery is
NOT closed until someone runs a fresh session and watches node_map come up:
- Lab 34 expected node_map: {KALI, R1, SW1} — no R2
- Lab 35 expected node_map: {KALI, PC1, R1, R2, SW1} — no R3/PC2

Kit: `scripts/walkthrough_34_35_post_surgery.sh` (human-run, option 1 — Yassine
runs it on Falcon; registers walk34_*@test.local, upgrades to pro, launches both
labs, prints node_map, ends sessions). Approved paths: register → login →
POST /api/v1/labs/{id}/session → GET /api/v1/labsessions/{id} (node_map) →
DELETE. Do NOT mark closed on unit-suite evidence alone.

## OPEN ITEM #5 — Labs 28/29: R2 is a missing step, NOT a ghost
- Lab 28 (IPv6): text says "R1 (gateway) + PC1 + PC2 + KALI" but Go has
  R1↔R2↔PC2. PC2's gateway is R2. Text never configures R2 → possibly unplayable.
- Lab 29 (TCP/UDP): same topology shape; KALI floods 192.168.1.200 but PC2 is
  behind unconfigured R2.
- Decision needed (pedagogical, not cleanup):
  - (a) In-scope: add R2 config step to text (teaches second hop) — richer lab
  - (b) Out-of-scope: flatten Go (PC2↔R1 directly) — topology surgery, changes
    what the lab teaches
- Do NOT bundle with a cleanup migration. Separate ticket, separate number.

## Reference
Full methodology + psql CSV-fetch technique + findings:
`~/.hermes/skills/software-development/netbreaker-lab-builder/references/design-choice-written-evidence-verification.md`
