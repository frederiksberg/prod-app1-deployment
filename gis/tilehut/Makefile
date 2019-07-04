MAKEFLAGS += --silent
.PHONY: deploy run build clean kill

deploy: build
	docker-compose up -d

run: build
	docker-compose up

clean: kill
	docker-compose rm -f

build: clean
	docker build -t frbsc/tilestream:latest -f ./Dockerfile .

kill:
	docker-compose down

re-ftp:
	docker-compose down ftp
	docker-compose rm -f ftp
	docker-compose up ftp
