CREATE EXTENSION IF NOT EXISTS "pgcrypto";

CREATE TABLE users (
    id                UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    email             VARCHAR(255) UNIQUE NOT NULL,
    password_hash     VARCHAR(255) NOT NULL,
    name              VARCHAR(255) NOT NULL DEFAULT '',
    plan              VARCHAR(20)  NOT NULL DEFAULT 'free',
    plan_expires_at   TIMESTAMPTZ,
    stripe_customer_id VARCHAR(255),
    is_admin          BOOLEAN      NOT NULL DEFAULT false,
    created_at        TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at        TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_users_email ON users (lower(email));
CREATE INDEX idx_users_stripe ON users (stripe_customer_id) WHERE stripe_customer_id IS NOT NULL;

CREATE TABLE refresh_tokens (
    id          UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id     UUID        NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    token_hash  VARCHAR(255) UNIQUE NOT NULL,
    expires_at  TIMESTAMPTZ NOT NULL,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    revoked_at  TIMESTAMPTZ
);

CREATE INDEX idx_rt_user_id    ON refresh_tokens (user_id);
CREATE INDEX idx_rt_token_hash ON refresh_tokens (token_hash);

