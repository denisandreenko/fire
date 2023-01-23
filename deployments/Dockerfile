FROM golang:1.19.5-alpine AS builder

ENV GO111MODULE=on

RUN apk update
RUN apk add --update make

WORKDIR /app

COPY go.mod .
RUN go mod download

COPY . .
RUN go mod tidy

RUN make



FROM alpine:latest

WORKDIR /app

RUN addgroup fire
RUN adduser --disabled-password --ingroup fire fire

COPY --from=builder /app/build ./build
COPY --from=builder /app/configs ./configs

EXPOSE 8080

USER fire

ENTRYPOINT APP_ROOT=/app FIRE_ENV=development ./build/fire
