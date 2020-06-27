FROM golang:1.14.4-stretch

WORKDIR /app

COPY main.go main.go

RUN GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -o app .

CMD ["./app"]
