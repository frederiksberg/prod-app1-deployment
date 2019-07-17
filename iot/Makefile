# -------- Overall definitions --------
MAKEFLAGS += --silent
.PHONY: deploy run build clean kill

# -------- Project definitions --------
deploys := deploy-iot-pipeline deploy-forecast
runs 	:= run-iot-pipeline run-forecast
builds 	:= build-iot-pipeline build-forecast
cleans 	:= clean-iot-pipeline clean-forecast
kills 	:= kill-iot-pipeline kill-forecast

# -------- The usefull options --------
deploy: $(deploys)

run: $(runs)

build: $(builds)

clean: $(cleans)

kill: $(kills)

restart: deploy

# -------- Projects --------
# ~~> iot-pipeline
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

# ~~> iot-pipeline
kill-forecast:
	@${MAKE} --no-print-directory -C forecast kill

clean-forecast:
	@${MAKE} --no-print-directory -C forecast clean

build-forecast:
	@${MAKE} --no-print-directory -C forecast build

run-forecast:
	@${MAKE} --no-print-directory -C forecast run

deploy-forecast:
	@${MAKE} --no-print-directory -C forecast deploy
