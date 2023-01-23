.PHONY: build
build:
	CGO_ENABLED=0 go build -o build -ldflags="-w -s" ./cmd/fire

.PHONY: test
test:
	go test -v -race -timeout 30s ./...

.PHONY: docker-build
docker-build:
	docker build -f deployments/Dockerfile . -t denisandreenko/fire

.PHONY: docker-run
docker-run:
	docker run -p 8080:8080 denisandreenko/fire

.PHONY: docker-compose-up
docker-compose-up:
	docker compose -f deployments/docker-compose.yaml up

.DEFAULT_GOAL := build