MAKEFLAGS += --silent
.PHONY: deploy run build clean kill re-ftp init

deploy: | build clean
	docker-compose up -d

run: | build clean
	docker-compose up

clean: kill
	docker-compose rm -f

build:
	docker-compose build

kill:
	docker-compose down --remove-orphans
