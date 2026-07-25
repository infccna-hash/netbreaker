CREATE TABLE user_progress (
    id           UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id      UUID        NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    lab_id       INTEGER     NOT NULL REFERENCES labs(id) ON DELETE CASCADE,
    phase        VARCHAR(20) NOT NULL CHECK (phase IN ('build', 'attack', 'harden')),
    completed_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE (user_id, lab_id, phase)
);

CREATE INDEX idx_progress_user ON user_progress (user_id);

CREATE TABLE certificates (
    id          UUID    PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id     UUID    UNIQUE NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    issued_at   TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    verify_code VARCHAR(16) UNIQUE NOT NULL
);

CREATE TABLE teams (
    id                 UUID    PRIMARY KEY DEFAULT gen_random_uuid(),
    name               VARCHAR(255) NOT NULL,
    owner_id           UUID    NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    stripe_customer_id VARCHAR(255),
    seat_count         INTEGER NOT NULL DEFAULT 5,
    created_at         TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE team_members (
    team_id   UUID NOT NULL REFERENCES teams(id) ON DELETE CASCADE,
    user_id   UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    role      VARCHAR(20) NOT NULL DEFAULT 'member' CHECK (role IN ('owner', 'instructor', 'member')),
    joined_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    PRIMARY KEY (team_id, user_id)
);

