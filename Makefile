# -------- Overall definitions --------
MAKEFLAGS += --silent
.PHONY: deploy run build clean kill

# -------- Project definitions --------
deploys := deploy-proxy deploy-gis
runs 	:= run-proxy run-gis
builds 	:= build-proxy build-gis
cleans 	:= clean-proxy clean-gis
kills 	:= kill-proxy kill-gis

# -------- The usefull options --------
deploy: $(deploys)

run: $(runs)

build: $(builds)

clean: $(cleans)

kill: $(kills)

# -------- Projects --------

# -> Proxy
kill-proxy:
	@${MAKE} --no-print-directory -C proxy kill

clean-proxy:
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

run-gis:
	@${MAKE} --no-print-directory -C gis run

deploy-gis:
	@${MAKE} --no-print-directory -C gis deploy
