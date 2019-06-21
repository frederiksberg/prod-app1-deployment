MAKEFLAGS += --silent
.PHONY: deploy run build clean kill

run: build
	docker-compose up

deploy: build
	docker-compose up -d

clean: kill
	docker-compose rm -f

build: clean
	docker build -t frbsc/monitoring:influxdb -f ./src/influxdb/influxdb.Dockerfile ./src/influxdb
	docker build -t frbsc/monitoring:kapacitor -f ./src/kapacitor/kapacitor.Dockerfile ./src/kapacitor
	docker build -t frbsc/monitoring:chronograf -f ./src/chronograf/chronograf.Dockerfile ./src/chronograf
	docker build -t frbsc/monitoring:telegraf-master -f ./src/telegraf/telegraf.Dockerfile ./src/telegraf

kill:
	docker-compose down
