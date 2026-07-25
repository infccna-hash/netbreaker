.PHONY: keys dev build deploy up down logs ps migrate-down backup-setup clean

APP     = netbreaker
BINARY  = ./bin/$(APP)
COMPOSE = docker compose

## keys: generate the JWT RS256 keypair (one-time, before first run)
keys:
	@mkdir -p keys
	@openssl genrsa -out keys/private.pem 2048
	@openssl rsa -in keys/private.pem -pubout -out keys/public.pem
	@echo "JWT keypair generated in ./keys/"

## build: compile the API binary locally
build:
	go build -o $(BINARY) ./cmd/server/

## dev: run Postgres + MinIO in Docker and the API on the host (hot iteration)
dev:
	$(COMPOSE) up -d postgres minio
	@sleep 2
	go run ./cmd/server/

## deploy: build images and start the whole stack (API self-migrates on boot)
deploy:
	$(COMPOSE) build
	$(COMPOSE) up -d
	@echo "Deployed. Run 'make logs' to watch the API."

up:
	$(COMPOSE) up -d

down:
	$(COMPOSE) down

logs:
	$(COMPOSE) logs -f api

ps:
	$(COMPOSE) ps

## migrate-down: roll back the last migration (API applies UP automatically on boot)
migrate-down:
	docker run --rm --network host -v $(PWD)/migrations:/migrations:ro migrate/migrate \
		-path /migrations -database "$$DATABASE_URL" down 1

## backup-setup: install a daily 2am Postgres backup cron
backup-setup:
	@mkdir -p /opt/backups
	@echo '0 2 * * * root docker exec netbreaker-postgres pg_dump -U netbreaker netbreaker | gzip > /opt/backups/netbreaker-$$(date +\%Y\%m\%d).sql.gz' > /etc/cron.d/netbreaker
	@chmod 0644 /etc/cron.d/netbreaker
	@echo "Daily backup cron installed → /opt/backups/"

clean:
	$(COMPOSE) down -v
	rm -rf bin/
