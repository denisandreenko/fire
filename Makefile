DOCKER_CONTAINERS = $(shell docker ps -q)

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
	docker build -f deployments/production.dockerfile . -t denisandreenko/fire

.PHONY: docker-build-dev
docker-build-dev:
	docker build -f deployments/debug.dockerfile . -t denisandreenko/fire-dev

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

.DEFAULT_GOAL := build