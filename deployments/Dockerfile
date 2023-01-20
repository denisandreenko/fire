FROM golang:1.19.5-alpine

ENV GO111MODULE=on

RUN apk update
RUN apk add --update make

WORKDIR /app
COPY . /app

RUN cd /app
RUN go mod tidy
RUN make
RUN chmod a+rx ./build/fire

ENTRYPOINT APP_ROOT=/app FIRE_ENV=development ./build/fire

EXPOSE 8080