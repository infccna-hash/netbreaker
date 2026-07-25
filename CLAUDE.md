# NetBreaker API — Build Instructions for Warda

## What This Project Is
NetBreaker is a CCNA learning platform where students build network topologies in GNS3 then attack them with Kali Linux. This repo is the **Go REST API backend**. You are building it from scratch on a Linux VPS using the files in this repo.

## Your Job
Read every file before touching it. Follow TODO.md **in order**, one task at a time. Mark each task done as you complete it. Do not skip ahead.

---

## Tech Stack
| Layer | Tool | Notes |
|---|---|---|
| Language | Go 1.22+ | |
| Router | chi v5 | |
| Database | PostgreSQL 16 | pgx/v5 driver |
| Auth | RS256 JWT + refresh tokens | golang-jwt/jwt v5 |
| Payments | Stripe | checkout + webhooks |
| File storage | MinIO (S3-compatible) | for GNS3 .gns3project files |
| Email | Resend | welcome, receipts, certificates |
| Reverse proxy | Caddy | auto TLS |
| Containers | Docker Compose | api + postgres + minio + caddy |

---

## VPS Prerequisites (run as root or with sudo)
```bash
# 1. Install Go 1.22
wget https://go.dev/dl/go1.22.4.linux-amd64.tar.gz
rm -rf /usr/local/go && tar -C /usr/local -xzf go1.22.4.linux-amd64.tar.gz
echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc && source ~/.bashrc
go version  # should print go1.22.4

# 2. Install Docker + Compose
curl -fsSL https://get.docker.com | sh
apt-get install -y docker-compose-plugin
systemctl enable --now docker
docker --version

# 3. Create working directory
mkdir -p /opt/netbreaker && cp -r . /opt/netbreaker && cd /opt/netbreaker
```

---

## Key Code Patterns — Follow These Exactly

### 1. Handler Pattern (ALL handlers follow this)
```go
func (h *Handler) DoThing(w http.ResponseWriter, r *http.Request) {
    ctx := r.Context()

    // Parse and validate input
    var req DoThingRequest
    if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
        response.Error(w, http.StatusBadRequest, "invalid request body")
        return
    }

    // Call service/repo
    result, err := h.service.DoThing(ctx, req)
    if err != nil {
        switch {
        case errors.Is(err, ErrNotFound):
            response.Error(w, http.StatusNotFound, "not found")
        case errors.Is(err, ErrConflict):
            response.Error(w, http.StatusConflict, "already exists")
        default:
            response.Error(w, http.StatusInternalServerError, "internal error")
        }
        return
    }

    response.JSON(w, http.StatusOK, result)
}
```

### 2. Repository Pattern (ALL DB access follows this)
```go
func (r *Repository) GetByID(ctx context.Context, id uuid.UUID) (*types.Thing, error) {
    var t types.Thing
    err := r.pool.QueryRow(ctx,
        `SELECT id, field1, field2, created_at FROM things WHERE id = $1`, id,
    ).Scan(&t.ID, &t.Field1, &t.Field2, &t.CreatedAt)
    if err != nil {
        if errors.Is(err, pgx.ErrNoRows) {
            return nil, ErrNotFound
        }
        return nil, fmt.Errorf("GetByID: %w", err)
    }
    return &t, nil
}
```

### 3. Sentinel Errors (each package defines its own)
```go
var (
    ErrNotFound  = errors.New("not found")
    ErrConflict  = errors.New("already exists")
    ErrForbidden = errors.New("forbidden")
)
```

### 4. Getting authenticated user in a handler
```go
claims := auth.ClaimsFromCtx(r.Context()) // always returns *auth.Claims after JWTMiddleware
userID, _ := uuid.Parse(claims.Subject)
plan := claims.Plan  // "free", "pro", "bootcamp"
```

### 5. Chi URL params
```go
labID := chi.URLParam(r, "id")
// or
userID := chi.URLParam(r, "userID")
```

---

## Running Locally (dev mode)
```bash
make keys          # generate JWT RSA keys (one-time)
cp .env.example .env  # then fill in .env
make dev           # starts docker compose + runs migrations
```

## Running on VPS (production)
```bash
make keys
cp .env.example .env   # fill ALL values
make deploy            # build + migrate + start
make logs              # tail api logs
```

## Migrations
```bash
make migrate-up    # apply all pending
make migrate-down  # roll back one step
```

---

## Security Rules — Never Break These
1. **Never log passwords, tokens, or API keys** — not even partially
2. **Always verify Stripe webhook signature** before processing any webhook event
3. **Always rotate refresh tokens** — when a refresh token is used, immediately revoke it and issue a new one. If the old token is reused after rotation → revoke ALL tokens for that user (token theft detected)
4. **Plan checks MUST use RequirePlan middleware** — never do manual plan checks inside handlers
5. **Refresh token cookie MUST be** `HttpOnly; Secure; SameSite=Strict; Path=/api/v1/auth/refresh`
6. **bcrypt cost = 12** — do not lower this
7. **Never reveal if an email exists** in forgot-password or login error messages
8. **Admin routes MUST use RequireAdmin middleware** — double-check this on every admin handler

---

## Response Formats
Success: `{"data": ..., "message": "..."}` or just the object directly
Error: `{"error": "human readable message", "code": "MACHINE_CODE"}`

## HTTP Status Codes
- 200 OK — success
- 201 Created — resource created
- 204 No Content — success, no body (logout, delete)
- 400 Bad Request — invalid input
- 401 Unauthorized — missing or invalid token
- 403 Forbidden — valid token but wrong plan/role
- 404 Not Found — resource doesn't exist
- 409 Conflict — duplicate (email already exists, etc.)
- 429 Too Many Requests — rate limited
- 500 Internal Server Error — unexpected error (log it, don't expose details)

---

## Project Structure Quick Reference
```
cmd/server/main.go          ← entry point, router setup
pkg/config/config.go        ← load env vars into Config struct
pkg/db/postgres.go          ← pgxpool connection
pkg/jwt/jwt.go              ← generate + parse RS256 tokens
pkg/response/response.go    ← JSON + Error response helpers
pkg/types/types.go          ← shared types (User, Lab, etc.)
pkg/storage/s3.go           ← MinIO file upload/download
pkg/email/resend.go         ← send emails via Resend API
pkg/ratelimit/ratelimit.go  ← token bucket rate limiter
internal/auth/              ← register, login, refresh, logout + middleware
internal/users/             ← GET/PATCH/DELETE /me
internal/labs/              ← lab listing, detail, topology, config download
internal/progress/          ← mark/unmark lab phases complete
internal/subscription/      ← Stripe checkout, portal, webhook
internal/certificate/       ← generate + verify certificates
internal/team/              ← bootcamp team management
internal/admin/             ← admin dashboard
migrations/                 ← SQL migration files (run in order)
```

---

## If Something Is Unclear
1. Re-read the relevant source file — the code has comments
2. Check pkg/types/types.go for the data model
3. Check the migration SQL to understand the DB schema
4. Follow the existing patterns from internal/auth/ — it's the most complete example
