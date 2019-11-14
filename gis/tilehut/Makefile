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

re-ftp:
	docker-compose rm -f -s ftp
	docker-compose up -d ftp

init:
	./init.sh
