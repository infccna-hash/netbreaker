-- Migration 041 down: Revert Lab 15 build phase to truncated version

UPDATE lab_phases
SET content = $md$
# LAB 15 · fundamentals · easy

## Network Devices & Anatomy
📖 Maps to Vol 1 · Ch 2

Identify every device on the wire and what breaks when you get its role wrong.

---

## Topology

See `Lab15Topology.tsx` / `lab-15-topology.svg` for the rendered diagram.

**Cabling (fixed for the entire session — no rewiring required):**
- PC1 + PC2 + KALI2 → H1 (hub) → SW1 (Et0/0)
- PC3 → SW1 (Et0/1)
- KALI → SW1 (Et0/2)
- SW1 (Et0/3) → R1
- R1 → FW1
- Et0/4 — spare, unused

**Why two Kali nodes:** KALI sits on a switch port (Et0/2); KALI2 sits on the hub segment (Et0/0) alongside PC1 and PC2. Same ping, same instant, two different vantage points — that contrast *is* the lesson. Run `tcpdump` on both at once in Step 2 and watch them disagree about what they can see.
$md$
WHERE lab_id = 15 AND phase = 'build';
