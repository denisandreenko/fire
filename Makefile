DOCKER_CONTAINERS = $(shell docker ps -q)

# Number of migrations - this is optionally used on up and down commands
N?=

MYSQL_DSN ?= $(MYSQL_USER):$(MYSQL_PASSWORD)@tcp($(MYSQL_HOST):$(MYSQL_PORT))/$(MYSQL_DATABASE)

.PHONY: build
build:
	CGO_ENABLED=0 go build -o build/fire -ldflags="-w -s" ./cmd/fire

.PHONY: build-dev
build-dev:
	go build -o build/fire -gcflags "all=-N -l" ./cmd/fire

.PHONY: test
test:
	go test -v -race -timeout 30s ./...

.PHONY: docker-build
docker-build:
	docker build -f deployments/dockerfiles/production.dockerfile . -t denisandreenko/fire

.PHONY: docker-build-dev
docker-build-dev:
	docker build -f deployments/dockerfiles/debug.dockerfile . -t denisandreenko/fire-dev

.PHONY: docker-scan
docker-scan:
	docker scan denisandreenko/fire

.PHONY: docker-compose-up
docker-compose-up: docker-build
	docker compose -f deployments/docker-compose.yaml up

.PHONY: docker-compose-dev-up
docker-compose-dev-up: docker-build-dev
	docker compose -f deployments/docker-compose.yaml -f deployments/docker-compose.debug.yaml up

.PHONY: docker-stop
docker-stop:
	docker stop $(DOCKER_CONTAINERS)

.PHONY: migrate-setup
migrate-setup:
	@if [ -z "$$(which migrate)" ]; then echo "Installing migrate command..."; go install -tags 'mysql' -tags 'postgres' github.com/golang-migrate/migrate/v4/cmd/migrate@latest; fi

.PHONY: migrate-setup
migrate-up: migrate-setup
	@ migrate -database 'mysql://$(MYSQL_DSN)?multiStatements=true' -path migrations up $(N)

.PHONY: migrate-down
migrate-down: migrate-setup
	@ migrate -database 'mysql://$(MYSQL_DSN)?multiStatements=true' -path migrations down $(N)


.DEFAULT_GOAL := build