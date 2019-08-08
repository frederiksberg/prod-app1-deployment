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

clean-grafana:
    docker-compose down grafana

grafana: clean-grafana
    docker-compose up -d grafana