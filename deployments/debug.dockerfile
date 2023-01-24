FROM golang:1.19.5 AS builder

ENV GO111MODULE=on

RUN go install github.com/go-delve/delve/cmd/dlv@latest

WORKDIR /app

COPY go.mod .
RUN go mod download

COPY . .
RUN go mod tidy

RUN make build-dev


FROM debian:buster

WORKDIR /app

RUN addgroup fire
RUN adduser --disabled-password --ingroup fire fire

COPY --from=builder /app/build ./build
COPY --from=builder /app/configs ./configs
COPY --from=builder /go/bin/dlv /bin

EXPOSE 8080 40000

USER fire

ENTRYPOINT dlv --headless=true --listen=:40000 --api-version=2 --accept-multiclient exec ./build/fire