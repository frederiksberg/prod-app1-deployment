MAKEFLAGS += --silent
.PHONY: deploy run build clean kill

deploy: build
	docker-compose up -d

run: build
	docker-compose up

clean: kill
	docker-compose rm -f

build: clean
	docker-compose build

kill:
	docker-compose down