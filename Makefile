DOCKER_CONTAINERS = $(shell docker ps -q)

# TODO: use env variables
DB_USER ?= usr
DB_PASSWORD ?= pass
DB_HOST ?= 127.0.0.1
MYSQL_PORT ?= 3306
POSTGRES_PORT ?= 5432
DB_DATABASE ?= fire
DB_TEST_DATABASE ?= fire_test

MYSQL_DSN ?= $(DB_USER):$(DB_PASSWORD)@tcp($(DB_HOST):$(MYSQL_PORT))/$(DB_DATABASE)
POSTGRES_DSN ?= $(DB_USER):$(DB_PASSWORD)@$(DB_HOST:$(POSTGRES_PORT)/$(DB_DATABASE)

.PHONY: build
build:
	@CGO_ENABLED=0 go build -o build/fire -ldflags="-w -s" ./cmd/fire

.PHONY: build-dev
build-dev:
	@go build -o build/fire -gcflags "all=-N -l" ./cmd/fire

.PHONY: test
test:
	@go test -v -race -timeout 30s ./...

.PHONY: docker-build
docker-build:
	@docker build -f deployments/dockerfiles/production.dockerfile . -t denisandreenko/fire

.PHONY: docker-build-dev
docker-build-dev:
	@docker build -f deployments/dockerfiles/debug.dockerfile . -t denisandreenko/fire-dev

.PHONY: docker-scan
docker-scan:
	@docker scan denisandreenko/fire

.PHONY: docker-compose-up
docker-compose-up: docker-build
	@docker compose -f deployments/docker-compose.yaml up

.PHONY: docker-compose-dev-up
docker-compose-dev-up: docker-build-dev
	@docker compose -f deployments/docker-compose.yaml -f deployments/docker-compose.debug.yaml up

.PHONY: docker-stop
docker-stop:
	@docker stop $(DOCKER_CONTAINERS)

.PHONY: migrate-setup
migrate-setup:
	@if [ -z "$$(which migrate)" ]; then echo "Installing migrate command..."; go install -tags 'mysql','postgres' github.com/golang-migrate/migrate/v4/cmd/migrate@latest; fi

.PHONY: migrate-up
migrate-up: migrate-setup
	@migrate -database 'mysql://$(MYSQL_DSN)?multiStatements=true' -path migrations/mysql up
	@migrate -database 'postgres://$(POSTGRES_DSN)?sslmode=disable' -path migrations/postgres up

.PHONY: migrate-down
migrate-down: migrate-setup
	@migrate -database 'mysql://$(MYSQL_DSN)?multiStatements=true' -path migrations/mysql down
	@migrate -database 'postgres://$(POSTGRES_DSN)?sslmode=disable' -path migrations/postgres down

.DEFAULT_GOAL := build