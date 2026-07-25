CREATE TABLE lab_sessions (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id         UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    lab_id          INTEGER NOT NULL REFERENCES labs(id) ON DELETE CASCADE,
    compute_id      TEXT NOT NULL,
    gns3_project_id TEXT,
    status          TEXT NOT NULL DEFAULT 'provisioning'
                    CHECK (status IN ('provisioning','running','idle_stopped','ended','failed')),
    node_map        JSONB NOT NULL DEFAULT '{}',
    started_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
    last_active_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
    ended_at        TIMESTAMPTZ,

    CONSTRAINT one_active_session_per_user_lab
        EXCLUDE (user_id WITH =, lab_id WITH =)
        WHERE (status IN ('provisioning','running','idle_stopped'))
);

CREATE INDEX idx_lab_sessions_status ON lab_sessions(status);
CREATE INDEX idx_lab_sessions_last_active ON lab_sessions(last_active_at) WHERE status = 'running';
