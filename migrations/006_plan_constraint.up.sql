-- Guard against invalid plan values (e.g. an admin typo) that would silently
-- break every plan comparison in the app.
ALTER TABLE users
    ADD CONSTRAINT users_plan_check CHECK (plan IN ('free', 'pro', 'bootcamp'));
