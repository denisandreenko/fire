FROM golang:1.19.5-alpine

ENV GO111MODULE=on

RUN apk update
RUN apk add --update make
#RUN apk add build-essential

COPY . /app
WORKDIR /app

RUN cd /app
RUN go mod tidy
RUN make

CMD ["go run", "cmd/fire"]

EXPOSE 8010