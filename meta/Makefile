# -------- Overall definitions --------
MAKEFLAGS += --silent
.PHONY: deploy run build clean kill

# -------- Project definitions --------
deploys := deploy-monitor
runs := run-monitor
builds := build-monitor
cleans := clean-monitor
kills := kill-monitor

# -------- The usefull options --------
deploy: $(deploys)

run: $(runs)

build: $(builds)

clean: $(cleans)

kill: $(kills)

# -------- Projects --------
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
