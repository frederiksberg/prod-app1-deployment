# -------- Overall definitions --------
MAKEFLAGS += --silent
.PHONY: deploy run build clean kill

# -------- Project definitions --------
deploys := deploy-gis deploy-iot deploy-meta
runs 	:= run-gis run-iot run-meta
builds 	:= build-gis build-iot build-meta build-networking
cleans 	:= clean-gis clean-iot clean-meta
kills 	:= kill-gis kill-iot kill-meta

# -------- The usefull options --------
deploy: $(deploys) deploy-proxy

run: $(runs) run-proxy

build: $(builds) build-proxy

clean: clean-networking

kill: kill-networking

restart-all: | build kill deploy

restart: restart-proxy

# -------- Using the dev proxy --------
dev: deploy-dev

deploy-dev: $(deploys) deploy-proxy-dev

run-dev: $(runs) run-proxy-dev

build-dev: $(builds) build-proxy-dev

clean-dev: clean-networking

kill-dev: kill-networking

restart-all-dev: | build-dev kill-dev deploy-dev

restart-dev: restart-proxy-dev

# -------- Project specific targets
gis: deploy-gis

iot: deploy-iot

meta: deploy-meta

# -------- Projects --------

# -> Network
kill-networking: $(kills) kill-proxy kill-proxy-dev
	@${MAKE} --no-print-directory -C networking kill

clean-networking: $(cleans) clean-proxy clean-proxy-dev
	@${MAKE} --no-print-directory -C networking clean

build-networking:
	@${MAKE} --no-print-directory -C networking build

run-networking:
	@${MAKE} --no-print-directory -C networking run

deploy-networking:
	@${MAKE} --no-print-directory -C networking deploy

# -> proxy
kill-proxy:
	@${MAKE} --no-print-directory -C proxy kill

clean-proxy:
	@${MAKE} --no-print-directory -C proxy clean

build-proxy:
	@${MAKE} --no-print-directory -C proxy build

run-proxy: deploy-networking
	@${MAKE} --no-print-directory -C proxy run

deploy-proxy: deploy-networking
	@${MAKE} --no-print-directory -C proxy deploy
	
restart-proxy:
	@${MAKE} --no-print-directory -C proxy deploy

init-proxy:
	@${MAKE} --no-print-directory -C proxy init

# -> proxy-dev
kill-proxy-dev:
	@${MAKE} --no-print-directory -C proxy-dev kill

clean-proxy-dev:
	@${MAKE} --no-print-directory -C proxy-dev clean

build-proxy-dev:
	@${MAKE} --no-print-directory -C proxy-dev build

run-proxy-dev: deploy-networking
	@${MAKE} --no-print-directory -C proxy-dev run

deploy-proxy-dev: deploy-networking
	@${MAKE} --no-print-directory -C proxy-dev deploy
	
restart-proxy-dev:
	@${MAKE} --no-print-directory -C proxy-dev deploy

# -> GIS
kill-gis:
	@${MAKE} --no-print-directory -C gis kill

clean-gis:
	@${MAKE} --no-print-directory -C gis clean

build-gis:
	@${MAKE} --no-print-directory -C gis build

run-gis: deploy-networking
	@${MAKE} --no-print-directory -C gis run

deploy-gis: deploy-networking
	@${MAKE} --no-print-directory -C gis deploy

# -> IOT
kill-iot:
	@${MAKE} --no-print-directory -C iot kill

clean-iot:
	@${MAKE} --no-print-directory -C iot clean

build-iot:
	@${MAKE} --no-print-directory -C iot build

run-iot: deploy-networking
	@${MAKE} --no-print-directory -C iot run

deploy-iot: deploy-networking
	@${MAKE} --no-print-directory -C iot deploy

# -> meta
kill-meta:
	@${MAKE} --no-print-directory -C meta kill

clean-meta:
	@${MAKE} --no-print-directory -C meta clean

build-meta:
	@${MAKE} --no-print-directory -C meta build

run-meta: deploy-networking
	@${MAKE} --no-print-directory -C meta run

deploy-meta: deploy-networking
	@${MAKE} --no-print-directory -C meta deploy
