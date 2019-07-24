MAKEFLAGS += --silent
.PHONY: deploy run build clean kill init

deploy: build
	docker-compose up -d

run: build
	docker-compose up
	
init: clean

clean: kill
	docker-compose rm -f

build: clean
	docker-compose build

kill:
	docker-compose down