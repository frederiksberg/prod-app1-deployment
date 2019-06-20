# -------- Overall definitions --------
MAKEFLAGS += --silent
.PHONY: deploy run build clean kill

# -------- Project definitions --------
deploys := deploy-proxy deploy-gis deploy-iot
runs 	:= run-proxy run-gis run-iot
builds 	:= build-proxy build-gis build-iot
cleans 	:= clean-proxy clean-gis clean-iot
kills 	:= kill-proxy kill-gis kill-iot

# -------- The usefull options --------
deploy: $(deploys)

run: $(runs)

build: $(builds)

clean: $(cleans)

kill: $(kills)

# -------- Project specific targets
gis: deploy-proxy deploy-gis

iot: deploy-proxy deploy-iot

meta:

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

# -> IOT
kill-iot:
	@${MAKE} --no-print-directory -C iot kill

clean-iot:
	@${MAKE} --no-print-directory -C iot clean

build-iot:
	@${MAKE} --no-print-directory -C iot build

run-iot:
	@${MAKE} --no-print-directory -C iot run

deploy-iot:
	@${MAKE} --no-print-directory -C iot deploy
