FROM golang:1.19.5 AS builder

ENV GO111MODULE=on

# Git is required for fetching the dependencies.
# Ca-certificates is required to call HTTPS endpoints.
# Make is required to run Makefile instructions
RUN apt-get update && apt-get install -y --no-install-recommends git ca-certificates make \
    && update-ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN go install github.com/go-delve/delve/cmd/dlv@latest

ENV USER=appuser
ENV UID=10001
# See https://stackoverflow.com/a/55757473/12429735RUN
RUN addgroup $USER
RUN adduser --disabled-password --gecos "" --home "$(pwd)" --ingroup "$USER" --no-create-home --uid "$UID" "$USER"

WORKDIR /app
COPY . .

RUN make build-dev


FROM debian:buster

WORKDIR /app

COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /etc/passwd /etc/passwd
COPY --from=builder /etc/group /etc/group
COPY --from=builder /app/build ./build
COPY --from=builder /app/configs ./configs
COPY --from=builder /go/bin/dlv /bin

EXPOSE 8080 40000

# Use an unprivileged user.
USER appuser:appuser

ENTRYPOINT ["dlv", "--headless=true", "--listen=:40000", "--api-version=2", "--accept-multiclient", "exec", "./build/fire"]