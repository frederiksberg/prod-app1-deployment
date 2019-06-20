MAKEFLAGS += --silent
.PHONY: deploy run build clean kill

run: build
	docker-compose up

deploy: build
	docker-compose up -d

clean: kill
	docker-compose rm -f

build: clean
	docker build -t frbsc/monitoring:influxdb -f ./influxdb/influxdb.Dockerfile ./influxdb
	docker build -t frbsc/monitoring:kapacitor -f ./kapacitor/kapacitor.Dockerfile ./kapacitor
	docker build -t frbsc/monitoring:chronograf -f ./chronograf/chronograf.Dockerfile ./chronograf
	docker build -t frbsc/monitoring:telegraf-master -f ./telegraf/telegraf.Dockerfile ./telegraf

kill:
	docker-compose down
