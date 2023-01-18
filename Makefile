.PHONY: build
build:
	go build -o build -v ./cmd/fire

.PHONY: test
test:
	go test -v -race -timeout 30s ./...

.PHONY: docker-build
docker-build:
	docker build -f deployments/Dockerfile . -t denisandreenko/fire

.DEFAULT_GOAL := build