# NetBreaker

A CCNA offensive-security lab platform. Students build a network topology in GNS3,
attack it from Kali, then harden it — 14 labs × 3 phases (build / attack / harden) = 42 objectives.

- **Backend** — Go 1.22, chi, pgx, PostgreSQL 16, RS256 JWT, Stripe, MinIO (S3), Resend
- **Frontend** — React 18 + Vite (light-mode, no runtime CSS framework)
- **Edge** — Caddy serves the SPA, proxies `/api` to the backend, and auto-issues TLS

Everything runs behind **one origin**, so the browser's calls to `/api` are same-origin — no CORS to configure.

```
browser ──► Caddy (web) ──┬── /api/*  ──► api  (Go :8080)
                          └── /*      ──► React SPA (static)
                                  api ──► postgres, minio
```

---

## Deploy (production)

You need a host with Docker + Docker Compose and a domain pointed at it.

```bash
# 1. Generate the JWT signing keys (writes ./keys/private.pem + public.pem)
make keys

# 2. Create your environment file and fill it in (see notes below)
cp .env.example .env
nano .env

# 3. Build images and start the whole stack (the API runs DB migrations on boot)
make deploy

# watch it come up
make logs
```

### Filling in `.env`

| Variable | What to set |
|---|---|
| `SITE_ADDRESS` | Your domain, e.g. `netbreaker.io`. Caddy issues a Let's Encrypt cert automatically. Use `:80` for local HTTP. |
| `DB_PASSWORD` / `DATABASE_URL` | Pick a strong password; put the same one in both. |
| `STRIPE_SECRET_KEY` / `STRIPE_WEBHOOK_SECRET` | From your Stripe dashboard. |
| `STRIPE_PRO_PRICE_ID` / `STRIPE_BOOTCAMP_PRICE_ID` | Create two recurring prices in Stripe, paste their `price_…` IDs. The webhook maps a paid subscription back to the right plan using these. |
| `STORAGE_ACCESS_KEY` / `STORAGE_SECRET_KEY` | MinIO credentials (used for lab config downloads). |
| `RESEND_API_KEY` / `EMAIL_FROM` | For welcome + team-invite emails. Leave the key as-is to disable email. |

### Stripe webhook

Point a Stripe webhook at:

```
https://<your-domain>/api/v1/webhooks/stripe
```

Subscribe to `checkout.session.completed`, `customer.subscription.updated`,
and `customer.subscription.deleted`. Copy the signing secret into `STRIPE_WEBHOOK_SECRET`.

---

## Local development

```bash
make keys
cp .env.example .env      # SITE_ADDRESS=:80 is fine for local
make dev                  # runs Postgres + MinIO in Docker, API on the host

cd frontend && npm install && npm run dev   # Vite dev server, proxies /api → :8080
```

---

## Useful commands

```bash
make deploy         # build + start everything
make up / make down # start / stop
make logs           # tail the API logs
make ps             # container status
make migrate-down   # roll back the last DB migration (API applies UP automatically)
make backup-setup   # install a daily 2am Postgres backup cron on the host
make clean          # stop and wipe volumes
```

---

## Notes on scope

A few things are intentionally v1 and worth knowing before you sell seats:

- **Team invites** add someone who **already has a NetBreaker account** (looked up by email, with seat-limit enforcement). Inviting a brand-new email returns a clear "ask them to sign up first" message rather than sending a pending-invite email. A full pending-invite flow (email link → auto-join) is the natural next step.
- **Lab verification** for labs 4–14 uses a generic verifier that trusts the "mark complete" action — the certificate is effectively honor-system for those labs. Labs with a real verifier check running config; wiring the rest is where the platform's credibility lives.
- The **frontend renders lab topology SVGs** straight from the database (`svg_large` / `svg_small`). Keep that content trusted (authored by you), since it's injected as HTML.
