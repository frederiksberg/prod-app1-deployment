MAKEFLAGS += --silent
.PHONY: deploy run build clean kill

deploy: | build clean
	docker-compose up -d

run: | build clean
	docker-compose up

clean: kill
	docker-compose rm -f

build:

kill:
	docker-compose down
