MAKEFLAGS += --silent
.PHONY: deploy run build clean kill init check

deploy: | build clean
	docker-compose up -d

run: | build clean
	docker-compose up
	
clean: kill
	docker-compose rm -f

build:
	docker-compose build

kill:
	docker-compose down

check:
	docker exec reverse_proxy nginx -t

init:
	./init.sh
	sed -i 's/listen 443 ssl;/listen 443 ssl http2;/g' ./confs/*.conf
