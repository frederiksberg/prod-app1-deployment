MAKEFLAGS += --silent
.PHONY: deploy run build clean kill init

run: build
	docker-compose up

deploy: build
	docker-compose up -d

init: clean

clean: kill
	docker-compose rm -f

build: clean

kill:
	docker-compose down