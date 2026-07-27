-- ============================================================================
-- Forensic query: credential-issuance vulnerability impact assessment
-- Run against production PostgreSQL (docker exec -i netbreaker-postgres-1 psql -U netbreaker -d netbreaker < this_file)
-- Date: 2026-07-27
-- Context: GenericVerifier (labs 4-14) auto-passed every phase until today.
--          Lab1/2/3Verifiers accepted client-submitted JSON (no server-side truth).
--          Any account could earn a verifiable certificate with ~14 clicks.
-- ============================================================================

\echo '=== 1. Total user_progress rows (all labs, all phases) ==='
SELECT COUNT(*) AS total_progress_rows FROM user_progress;

\echo ''
\echo '=== 2. Auto-pass rows (labs 4-14) — definitively unverified ==='
SELECT COUNT(*) AS auto_pass_rows
FROM user_progress
WHERE lab_id BETWEEN 4 AND 14;

\echo ''
\echo '=== 3. Client-trust rows (labs 1-3) — unverifiable, may include legitimate work ==='
SELECT COUNT(*) AS client_trust_rows
FROM user_progress
WHERE lab_id BETWEEN 1 AND 3;

\echo ''
\echo '=== 4. Accounts with auto-pass progress (labs 4-14) — ordered by count ==='
SELECT u.email, u.name, COUNT(*) AS auto_pass_phases
FROM user_progress up
JOIN users u ON u.id = up.user_id
WHERE up.lab_id BETWEEN 4 AND 14
GROUP BY u.id, u.email, u.name
ORDER BY auto_pass_phases DESC;

\echo ''
\echo '=== 5. ALL certificates issued (with user info) ==='
SELECT c.id, c.issued_at, c.verify_code, u.email, u.name
FROM certificates c
JOIN users u ON u.id = c.user_id
ORDER BY c.issued_at DESC;

\echo ''
\echo '=== 6. Certificate holders × auto-pass progress (the intersection that matters) ==='
SELECT u.email, u.name, c.verify_code, c.issued_at,
       COUNT(up.id) AS auto_pass_phases
FROM certificates c
JOIN users u ON u.id = c.user_id
JOIN user_progress up ON up.user_id = u.id AND up.lab_id BETWEEN 4 AND 14
GROUP BY u.id, u.email, u.name, c.verify_code, c.issued_at
ORDER BY auto_pass_phases DESC;

\echo ''
\echo '=== 7. Total phases in catalog (eligibility threshold) ==='
SELECT COUNT(*) AS total_phases_required
FROM (
    SELECT lab_id, phase FROM user_progress GROUP BY lab_id, phase
) sub;

-- Alternative: actual count from labs × 3 phases each
\echo ''
\echo '=== 8. Lab catalog size (TotalPhases source) ==='
SELECT COUNT(*) * 3 AS computed_total_phases
FROM (SELECT DISTINCT lab_id FROM user_progress) sub;

\echo ''
\echo '=== END OF REPORT ==='
