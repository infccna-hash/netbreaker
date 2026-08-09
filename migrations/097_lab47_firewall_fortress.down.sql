-- ═══════════════════════════════════════════════════════
-- Lab 47 (id=47) — Firewall Fortress : rollback
-- Removes the lab and its phases (cascades to progress).
-- ═══════════════════════════════════════════════════════

DELETE FROM lab_phases WHERE lab_id = 47;
DELETE FROM labs WHERE id = 47;
