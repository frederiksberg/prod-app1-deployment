MAKEFLAGS += --silent
.PHONY: deploy run build clean kill init

deploy: | build clean
	docker-compose up -d

run: | build clean
	docker-compose up
	
init: clean

clean: kill
	docker-compose rm -f

build:
	docker-compose build

kill:
	docker-compose down

check:
	docker exec reverse_proxy nginx -t
