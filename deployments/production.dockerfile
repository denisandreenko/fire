FROM golang:1.19.5-alpine AS builder

ENV GO111MODULE=on

# Git is required for fetching the dependencies.
# Ca-certificates is required to call HTTPS endpoints.
# Make is required to run Makefile instructions
RUN apk update && apk add --no-cache git ca-certificates make && update-ca-certificates

ENV USER=appuser
ENV UID=10001
# See https://stackoverflow.com/a/55757473/12429735RUN
RUN addgroup $USER
RUN adduser --disabled-password --gecos "" --home "$(pwd)" --ingroup "$USER" --no-create-home --uid "$UID" "$USER"

WORKDIR /app
COPY . .

RUN go mod download
RUN go mod verify

RUN make build



FROM alpine:latest

WORKDIR /app

COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /etc/passwd /etc/passwd
COPY --from=builder /etc/group /etc/group
COPY --from=builder /app/build ./build
COPY --from=builder /app/configs ./configs

EXPOSE 8080

# Use an unprivileged user.
USER appuser:appuser

ENTRYPOINT ["./build/fire"]