# ─── Build stage ──────────────────────────────────────────────
FROM golang:1.22-alpine AS builder
WORKDIR /app
RUN apk add --no-cache git gcc musl-dev
ENV GOFLAGS=-mod=mod
# Copy everything and let the build resolve modules. go.sum is generated here
# if absent, so a fresh checkout builds without a pre-committed go.sum.
COPY . .
RUN go mod download && \
    go vet ./... && \
    CGO_ENABLED=1 go test -race ./... && \
    CGO_ENABLED=0 GOOS=linux go build -ldflags="-s -w" -o /netbreaker ./cmd/server/

# ─── Runtime stage ────────────────────────────────────────────
FROM alpine:3.19
RUN apk add --no-cache ca-certificates tzdata
WORKDIR /app
COPY --from=builder /netbreaker .
COPY migrations/ ./migrations/
# JWT keys are NOT baked in — mounted read-only via docker-compose:
#   volumes: [ ./keys:/app/keys:ro ]
EXPOSE 8080
CMD ["./netbreaker"]
