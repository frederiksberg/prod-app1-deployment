MAKEFLAGS += --silent
.PHONY: deploy run build clean kill init

deploy: run

run:
	docker network create proxy
	
init: clean

clean: kill

build:

kill:
	docker network rm proxy