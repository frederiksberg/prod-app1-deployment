# -------- Overall definitions --------
MAKEFLAGS += --silent
.PHONY: deploy run build clean kill

# -------- Project definitions --------
deploys := deploy-monitor deploy-landing
runs 	:= run-monitor run-landing
builds 	:= build-monitor build-landing
cleans 	:= clean-monitor clean-landing
kills 	:= kill-monitor kill-landing

# -------- The usefull options --------
deploy: $(deploys)

run: $(runs)

build: $(builds)

clean: $(cleans)

kill: $(kills)

restart: deploy

# -------- Projects --------
# Monitor
kill-monitor:
	@${MAKE} --no-print-directory -C monitor kill

clean-monitor:
	@${MAKE} --no-print-directory -C monitor clean

build-monitor:
	@${MAKE} --no-print-directory -C monitor build

run-monitor:
	@${MAKE} --no-print-directory -C monitor run

deploy-monitor:
	@${MAKE} --no-print-directory -C monitor deploy

# Landing
kill-landing:
	@${MAKE} --no-print-directory -C landing kill

clean-landing:
	@${MAKE} --no-print-directory -C landing clean

build-landing:
	@${MAKE} --no-print-directory -C landing build

run-landing:
	@${MAKE} --no-print-directory -C landing run

deploy-landing:
	@${MAKE} --no-print-directory -C landing deploy
