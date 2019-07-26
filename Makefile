# -------- Overall definitions --------
MAKEFLAGS += --silent
.PHONY: deploy run build clean kill

# -------- Project definitions --------
deploys := deploy-gis deploy-iot deploy-meta deploy-proxy
runs 	:= run-gis run-iot run-meta run-proxy
builds 	:= build-proxy build-gis build-iot build-meta build-networking
cleans 	:= clean-gis clean-iot clean-meta clean-proxy
kills 	:= kill-gis kill-iot kill-meta kill-proxy

# -------- The usefull options --------
deploy: $(deploys)

run: $(runs)

build: $(builds)

clean: clean-networking

kill: kill-networking

restart-all: | build kill deploy

restart: restart-proxy

# -------- Project specific targets
gis: deploy-gis

iot: deploy-iot

meta: deploy-meta

# -------- Projects --------

# -> Network
kill-networking: $(kills)
	@${MAKE} --no-print-directory -C networking kill

clean-networking: $(cleans)
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
