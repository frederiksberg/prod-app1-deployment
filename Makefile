# -------- Overall definitions --------
MAKEFLAGS += --silent
.PHONY: deploy run build clean kill

# -------- Project definitions --------
deploys := deploy-gis deploy-iot deploy-meta
runs 	:= run-gis run-iot run-meta
builds 	:= build-proxy build-gis build-iot build-meta
cleans 	:= clean-gis clean-iot clean-meta
kills 	:= kill-gis kill-iot kill-meta

# -------- The usefull options --------
deploy: $(deploys)

run: $(runs)

build: $(builds)

clean: clean-proxy

kill: kill-proxy

restart: | kill deploy

# -------- Project specific targets
gis: deploy-gis

iot: deploy-iot

meta: deploy-meta

# -------- Projects --------

# -> Proxy
kill-proxy: $(kills)
	@${MAKE} --no-print-directory -C proxy kill

clean-proxy: $(cleans)
	@${MAKE} --no-print-directory -C proxy clean

build-proxy:
	@${MAKE} --no-print-directory -C proxy build

run-proxy:
	@${MAKE} --no-print-directory -C proxy run

deploy-proxy:
	@${MAKE} --no-print-directory -C proxy deploy

# -> GIS
kill-gis:
	@${MAKE} --no-print-directory -C gis kill

clean-gis:
	@${MAKE} --no-print-directory -C gis clean

build-gis:
	@${MAKE} --no-print-directory -C gis build

run-gis: run-proxy
	@${MAKE} --no-print-directory -C gis run

deploy-gis: deploy-proxy
	@${MAKE} --no-print-directory -C gis deploy

# -> IOT
kill-iot:
	@${MAKE} --no-print-directory -C iot kill

clean-iot:
	@${MAKE} --no-print-directory -C iot clean

build-iot:
	@${MAKE} --no-print-directory -C iot build

run-iot: run-proxy
	@${MAKE} --no-print-directory -C iot run

deploy-iot: deploy-proxy
	@${MAKE} --no-print-directory -C iot deploy

# -> meta
kill-meta:
	@${MAKE} --no-print-directory -C meta kill

clean-meta:
	@${MAKE} --no-print-directory -C meta clean

build-meta:
	@${MAKE} --no-print-directory -C meta build

run-meta: run-proxy
	@${MAKE} --no-print-directory -C meta run

deploy-meta: deploy-proxy
	@${MAKE} --no-print-directory -C meta deploy
