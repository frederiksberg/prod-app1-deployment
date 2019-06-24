# -------- Overall definitions --------
MAKEFLAGS += --silent
.PHONY: deploy run build clean kill

# -------- Project definitions --------
deploys := deploy-iot-pipeline
runs := run-iot-pipeline
builds := build-iot-pipeline
cleans := clean-iot-pipeline
kills := kill-iot-pipeline

# -------- The usefull options --------
deploy: $(deploys)

run: $(runs)

build: $(builds)

clean: $(cleans)

kill: $(kills)

restart: deploy

# -------- Projects --------
kill-iot-pipeline:
	@${MAKE} --no-print-directory -C iot-pipeline kill

clean-iot-pipeline:
	@${MAKE} --no-print-directory -C iot-pipeline clean

build-iot-pipeline:
	@${MAKE} --no-print-directory -C iot-pipeline build

run-iot-pipeline:
	@${MAKE} --no-print-directory -C iot-pipeline run

deploy-iot-pipeline:
	@${MAKE} --no-print-directory -C iot-pipeline deploy
