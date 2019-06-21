MAKEFLAGS += --silent
.PHONY: deploy run build clean kill

run: build
	docker-compose up

deploy: build
	docker-compose up -d

clean: kill
	docker-compose rm -f

build: clean
	docker build -f ./Dockerfile .

kill:
	docker-compose down
