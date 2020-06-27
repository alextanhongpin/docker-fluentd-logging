IMG := alextanhongpin/go-fluent

up:
	@docker-compose up -d

down:
	@docker-compose down

build:
	@docker build -t ${IMG} .

server: build
	@docker run -d -p 8080:8080 ${IMG}
