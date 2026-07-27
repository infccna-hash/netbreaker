-- 040_lab_verification.up.sql
-- Automated lab verification: machine-checkable assertions replace
-- manual "mark complete" for labs that register verifiers.

-- lab_verify_attempts: every verify call, pass or fail.
CREATE TABLE lab_verify_attempts (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES users(id),
  lab_id int NOT NULL,
  phase text NOT NULL CHECK (phase IN ('build','attack','harden')),
  passed boolean NOT NULL,
  evidence jsonb,                    -- raw typed Evidence snapshot
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX idx_verify_attempts_user_lab ON lab_verify_attempts(user_id, lab_id, phase);
CREATE INDEX idx_verify_attempts_lab_phase ON lab_verify_attempts(lab_id, phase);

-- lab_verify_checks: one row per individual assertion within an attempt.
CREATE TABLE lab_verify_checks (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  attempt_id uuid NOT NULL REFERENCES lab_verify_attempts(id) ON DELETE CASCADE,
  check_name text NOT NULL,
  passed boolean NOT NULL,
  detail text
);

CREATE INDEX idx_verify_checks_attempt ON lab_verify_checks(attempt_id);
CREATE INDEX idx_verify_checks_name ON lab_verify_checks(check_name, passed);

-- lab_completions: exactly one row per (user, lab, phase) — written only
-- when an attempt passes. Unique constraint makes awarding idempotent.
CREATE TABLE lab_completions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES users(id),
  lab_id int NOT NULL,
  phase text NOT NULL CHECK (phase IN ('build','attack','harden')),
  xp_awarded int NOT NULL,
  attempt_id uuid NOT NULL REFERENCES lab_verify_attempts(id),
  verified_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE(user_id, lab_id, phase)
);
