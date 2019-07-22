# -------- Overall definitions --------
MAKEFLAGS += --silent
.PHONY: deploy run build clean kill

# -------- Project definitions --------
deploys := deploy-iot-pipeline deploy-forecast deploy-vejrapi
runs 	:= run-iot-pipeline run-forecast run-vejrapi
builds 	:= build-iot-pipeline build-forecast build-vejrapi
cleans 	:= clean-iot-pipeline clean-forecast clean-vejrapi
kills 	:= kill-iot-pipeline kill-forecast kill-vejrapi

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

# ~~> Forecast
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

# ~~> VejrAPI
kill-vejrapi:
	@${MAKE} --no-print-directory -C vejrapi kill

clean-vejrapi:
	@${MAKE} --no-print-directory -C vejrapi clean

build-vejrapi:
	@${MAKE} --no-print-directory -C vejrapi build

run-vejrapi:
	@${MAKE} --no-print-directory -C vejrapi run

deploy-vejrapi:
	@${MAKE} --no-print-directory -C vejrapi deploy
