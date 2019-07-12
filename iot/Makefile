# -------- Overall definitions --------
MAKEFLAGS += --silent
.PHONY: deploy run build clean kill

# -------- Project definitions --------
deploys := deploy-iot-pipeline deploy-forecasting
runs 	:= run-iot-pipeline run-forecasting
builds 	:= build-iot-pipeline build-forecasting
cleans 	:= clean-iot-pipeline clean-forecasting
kills 	:= kill-iot-pipeline kill-forecasting

# -------- The usefull options --------
deploy: $(deploys)

run: $(runs)

build: $(builds)

clean: $(cleans)

kill: $(kills)

restart: deploy

# -------- Projects --------
# -> IOT Pipeline
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

# -> forecasting
kill-forecasting:
	@${MAKE} --no-print-directory -C forecasting kill

clean-forecasting:
	@${MAKE} --no-print-directory -C forecasting clean

build-forecasting:
	@${MAKE} --no-print-directory -C forecasting build

run-forecasting:
	@${MAKE} --no-print-directory -C forecasting run

deploy-forecasting:
	@${MAKE} --no-print-directory -C forecasting deploy
