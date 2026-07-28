-- ============================================================================
-- Forensic query: eligibility "by coincidence" bug — certificate impact
-- Run against production PostgreSQL:
--   docker exec -i netbreaker-postgres-1 psql -U netbreaker -d netbreaker \
--     < scripts/forensic_eligibility_bug_impact.sql
-- Date: 2026-07-28
--
-- Context: this is a SEPARATE incident from the 2026-07-27 GenericVerifier
-- auto-pass bug covered in forensic_verifier_impact.sql. That script asks
-- "did any phase get marked complete without real verification?" This one
-- asks a narrower, later question: "even among LEGITIMATELY-marked phases,
-- did the old COUNT(*)-vs-COUNT(*) eligibility check issue a certificate to
-- someone whose completed (lab_id, phase) SET was not actually a superset
-- of the catalog?" (e.g. N build-only rows across many labs, where N
-- happened to equal the catalog's total phase count, while attack/harden
-- were never touched anywhere).
--
-- This re-runs the CORRECTED eligibility logic (see
-- internal/progress/repository.go: AllPhasesCompleted) against every
-- existing certificate, using each user's CURRENT progress rows and the
-- CURRENT lab_phases catalog. A cert that fails this check today is
-- evidence the coincidence bug is a plausible explanation for how it was
-- issued — not certain proof, since the catalog may have grown since
-- issuance (see caveat below).
-- ============================================================================

\echo '=== 1. Total certificates issued (baseline) =='
SELECT COUNT(*) AS total_certificates FROM certificates;

\echo ''
\echo '=== 2. Current catalog size (the threshold the OLD check used as COUNT) =='
SELECT COUNT(*) AS total_phases_required FROM lab_phases;

\echo ''
\echo '=== 3. Certificates that FAIL the corrected set-membership check today =='
\echo '    (their completed phase SET is not a superset of the current catalog --'
\echo '     i.e. the old COUNT check should never have issued these, or the'
\echo '     catalog grew after issuance; see caveat in section 5)'
SELECT
    c.id AS certificate_id,
    c.verify_code,
    c.issued_at,
    u.email,
    u.name,
    (SELECT COUNT(*) FROM user_progress up WHERE up.user_id = u.id) AS user_progress_row_count,
    (SELECT COUNT(*) FROM lab_phases) AS catalog_total_at_query_time,
    (SELECT COUNT(DISTINCT (up.lab_id, up.phase))
       FROM user_progress up WHERE up.user_id = u.id) AS distinct_completed_phases,
    (SELECT COUNT(*)
       FROM lab_phases lp
       WHERE NOT EXISTS (
           SELECT 1 FROM user_progress up
           WHERE up.lab_id = lp.lab_id AND up.phase = lp.phase AND up.user_id = u.id
       )) AS missing_required_phases
FROM certificates c
JOIN users u ON u.id = c.user_id
WHERE EXISTS (
    SELECT 1 FROM lab_phases lp
    WHERE NOT EXISTS (
        SELECT 1 FROM user_progress up
        WHERE up.lab_id = lp.lab_id AND up.phase = lp.phase AND up.user_id = u.id
    )
)
ORDER BY c.issued_at ASC;

\echo ''
\echo '=== 4. For each flagged certificate, which specific phases are missing =='
SELECT
    c.verify_code,
    u.email,
    lp.lab_id,
    lp.phase AS missing_phase
FROM certificates c
JOIN users u ON u.id = c.user_id
JOIN lab_phases lp ON NOT EXISTS (
    SELECT 1 FROM user_progress up
    WHERE up.lab_id = lp.lab_id AND up.phase = lp.phase AND up.user_id = u.id
)
ORDER BY c.verify_code, lp.lab_id, lp.phase;

\echo ''
\echo '=== 5. CAVEAT: catalog-growth false positives =='
\echo '    A cert can fail section 3 for two different reasons that this'
\echo '    query cannot distinguish on its own:'
\echo '      (a) the coincidence bug issued it wrongly at the time, or'
\echo '      (b) the catalog legitimately grew (new lab/phase added) AFTER'
\echo '          a correctly-issued certificate, which is expected behavior'
\echo '          per AllPhasesCompleted''s documented semantics (certs are'
\echo '          point-in-time assertions and are not retroactively revoked).'
\echo '    Cross-reference c.issued_at against migration file dates below to'
\echo '    tell these apart -- a cert issued BEFORE a lab/phase''s migration'
\echo '    landed cannot possibly have completed that phase, so its presence'
\echo '    in section 3 is case (b), not the bug. A cert issued AFTER all'
\echo '    currently-missing phases already existed in the catalog is case (a).'
SELECT COUNT(*) AS total_labs, COUNT(*) FILTER (WHERE is_pro_only) AS pro_only_phases
FROM lab_phases;

\echo ''
\echo '=== END OF REPORT ==='
