CREATE TABLE labs (
    id          INTEGER     PRIMARY KEY,
    slug        VARCHAR(100) UNIQUE NOT NULL,
    title       VARCHAR(255) NOT NULL,
    topic       VARCHAR(50)  NOT NULL,
    difficulty  VARCHAR(20)  NOT NULL,
    is_free     BOOLEAN      NOT NULL DEFAULT false,
    sort_order  INTEGER      NOT NULL,
    short_desc  TEXT,
    created_at  TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);

CREATE TABLE lab_phases (
    id          UUID    PRIMARY KEY DEFAULT gen_random_uuid(),
    lab_id      INTEGER NOT NULL REFERENCES labs(id) ON DELETE CASCADE,
    phase       VARCHAR(20) NOT NULL CHECK (phase IN ('build', 'attack', 'harden')),
    title       VARCHAR(255) NOT NULL,
    content     TEXT    NOT NULL DEFAULT '',
    is_pro_only BOOLEAN NOT NULL DEFAULT false,
    UNIQUE (lab_id, phase)
);

CREATE TABLE lab_topologies (
    lab_id      INTEGER PRIMARY KEY REFERENCES labs(id) ON DELETE CASCADE,
    svg_small   TEXT    NOT NULL DEFAULT '',
    svg_large   TEXT    NOT NULL DEFAULT '',
    legend      JSONB   DEFAULT '[]'
);

CREATE TABLE lab_configs (
    lab_id      INTEGER PRIMARY KEY REFERENCES labs(id) ON DELETE CASCADE,
    filename    VARCHAR(255) NOT NULL,
    storage_key TEXT    NOT NULL,
    file_size   INTEGER,
    updated_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

