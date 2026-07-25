# NetBreaker — Build TODO List

Track progress here. Mark tasks `[x]` as you complete them.

---

## Phase 1 — Environment & Scaffolding
- [ ] **1.1** Install Go 1.22, Docker, Docker Compose on VPS (see CLAUDE.md Prerequisites)
- [ ] **1.2** Copy repo to `/opt/netbreaker`, run `make keys` to generate JWT RSA keypair
- [ ] **1.3** Copy `.env.example` to `.env`, fill in every value (DB password, Stripe keys, Resend key)
- [ ] **1.4** Run `go mod tidy` — verify all dependencies download cleanly
- [ ] **1.5** Run `docker compose up postgres -d` — verify PostgreSQL starts healthy
- [ ] **1.6** Run `make migrate-up` — verify all 4 migration files apply without error
- [ ] **1.7** Run `go build ./cmd/server/` — verify the binary compiles without errors

---

## Phase 2 — Core Packages
- [ ] **2.1** `pkg/config/config.go` — verify Config struct loads correctly from `.env`
- [ ] **2.2** `pkg/db/postgres.go` — verify pool connects to PostgreSQL and ping succeeds
- [ ] **2.3** `pkg/jwt/jwt.go` — verify `GenerateAccessToken` and `ParseAccessToken` work with RS256 keys
- [ ] **2.4** `pkg/response/response.go` — verify JSON and Error helpers write correct Content-Type
- [ ] **2.5** `pkg/types/types.go` — no changes needed, just read it to understand data models
- [ ] **2.6** `pkg/ratelimit/ratelimit.go` — verify middleware runs without panic on first request
- [ ] **2.7** `pkg/storage/s3.go` — verify MinIO bucket is created on startup
- [ ] **2.8** `pkg/email/resend.go` — send a test email to yourself

---

## Phase 3 — Auth (Most Critical — Do First)
- [ ] **3.1** Run server: `go run ./cmd/server/` — verify it starts on PORT without panic
- [ ] **3.2** Test `POST /api/v1/auth/register` — should create user and return access token + set cookie
- [ ] **3.3** Test `POST /api/v1/auth/login` — should return access token
- [ ] **3.4** Test `POST /api/v1/auth/refresh` — should rotate refresh token and return new access token
- [ ] **3.5** Test `POST /api/v1/auth/logout` — should revoke refresh token and clear cookie
- [ ] **3.6** Test `POST /api/v1/auth/register` with same email twice — should return 409
- [ ] **3.7** Test accessing `GET /api/v1/me` without token — should return 401
- [ ] **3.8** Test accessing `GET /api/v1/me` with expired token — should return 401
- [ ] **3.9** Verify bcrypt is used (not plaintext) by checking DB `password_hash` column

---

## Phase 4 — Users
- [ ] **4.1** `GET /api/v1/me` — returns current user (no password hash in response)
- [ ] **4.2** `PATCH /api/v1/me` — update name, verify DB updated
- [ ] **4.3** `DELETE /api/v1/me` — delete user, verify all progress rows cascade-deleted

---

## Phase 5 — Labs
- [ ] **5.1** Verify seed data applied: `SELECT count(*) FROM labs;` should return 14
- [ ] **5.2** `GET /api/v1/labs` — returns all 14 labs with metadata (no phase content)
- [ ] **5.3** `GET /api/v1/labs?topic=switching` — filters correctly
- [ ] **5.4** `GET /api/v1/labs/1` — free user: gets all 3 phases of lab 1 (it's free)
- [ ] **5.5** `GET /api/v1/labs/4` — free user: gets only `build` phase (lab 4 is pro only)
- [ ] **5.6** `GET /api/v1/labs/4` — pro user: gets all 3 phases
- [ ] **5.7** `GET /api/v1/labs/1/topology` — returns svg_small, svg_large, legend
- [ ] **5.8** `GET /api/v1/labs/1/config` — free user: 403; pro user: presigned URL
- [ ] **5.9** Upload a test GNS3 file via admin endpoint and verify download URL works

---

## Phase 6 — Progress
- [ ] **6.1** `PUT /api/v1/progress/1/build` — marks lab 1 build phase complete
- [ ] **6.2** `GET /api/v1/progress` — shows completion, per-topic %, readiness score
- [ ] **6.3** `PUT /api/v1/progress/1/attack` then `PUT /api/v1/progress/1/harden`
- [ ] **6.4** `DELETE /api/v1/progress/1/build` — unmarks it
- [ ] **6.5** Try marking progress on a pro lab as free user — should return 403

---

## Phase 7 — Subscriptions & Stripe
- [ ] **7.1** `GET /api/v1/subscription` — returns current plan info
- [ ] **7.2** `POST /api/v1/subscription/checkout` with `{"plan":"pro"}` — returns Stripe checkout URL
- [ ] **7.3** Complete a Stripe test checkout (use card `4242 4242 4242 4242`) — verify user plan updated to `pro` in DB
- [ ] **7.4** Test webhook: simulate `customer.subscription.deleted` — verify user plan reverts to `free`
- [ ] **7.5** `POST /api/v1/subscription/portal` as pro user — returns billing portal URL
- [ ] **7.6** Verify Stripe webhook signature check: send a request with wrong signature — must return 400

---

## Phase 8 — Certificate
- [ ] **8.1** Mark all 14 labs (all 3 phases each = 42 total phases) complete as test user
- [ ] **8.2** `GET /api/v1/certificate` as that user — should issue certificate with verify_code
- [ ] **8.3** `GET /api/v1/certificate` as user with incomplete labs — should return 409 with completion %
- [ ] **8.4** `GET /api/v1/certificate/verify/NB-XXXXX` (public) — should confirm cert is valid
- [ ] **8.5** `GET /api/v1/certificate/verify/INVALID` — should return 404

---

## Phase 9 — Team (Bootcamp)
- [ ] **9.1** Create a bootcamp user (update plan manually in DB for testing)
- [ ] **9.2** `GET /api/v1/team` — returns team info and member list
- [ ] **9.3** `POST /api/v1/team/invite` with a new email — sends invite email, creates team_members row
- [ ] **9.4** `GET /api/v1/team/progress` — returns all members' progress
- [ ] **9.5** Test seat limit enforcement: invite more users than seat_count — should return 409

---

## Phase 10 — Admin
- [ ] **10.1** Set `is_admin = true` on your user in DB
- [ ] **10.2** `GET /api/v1/admin/stats` — returns user counts, MRR, lab completion rates
- [ ] **10.3** `GET /api/v1/admin/users` — paginated user list
- [ ] **10.4** `PATCH /api/v1/admin/users/:id/plan` — override a user's plan
- [ ] **10.5** Try accessing admin routes without is_admin — must return 403

---

## Phase 11 — Docker & Caddy
- [ ] **11.1** `make deploy` — all 4 containers start cleanly (`docker compose ps`)
- [ ] **11.2** Point a domain at the VPS IP, update `Caddyfile` with the domain
- [ ] **11.3** Verify Caddy auto-issues TLS cert (check `https://yourdomain.io` in browser)
- [ ] **11.4** Verify `/api/v1/labs` is reachable over HTTPS from outside
- [ ] **11.5** Configure Stripe webhook URL: `https://yourdomain.io/api/v1/webhooks/stripe`

---

## Phase 12 — Final Checks
- [ ] **12.1** Run `make test` — all tests pass
- [ ] **12.2** Check logs for any error or warning you haven't addressed: `make logs`
- [ ] **12.3** Verify rate limiting: run 110 requests/min to a public endpoint — 101st should get 429
- [ ] **12.4** Confirm no plaintext passwords/tokens in logs: `make logs | grep -i "password\|token\|secret"`
- [ ] **12.5** Set up daily PostgreSQL backup: `make backup-setup`
- [ ] **12.6** Verify MinIO is NOT publicly accessible (firewall rule: port 9000 closed externally)

---

## Notes / Issues
(add notes here as you work)
