# -------- Overall definitions --------
MAKEFLAGS += --silent
.PHONY: deploy run build clean kill

# -------- Project definitions --------
deploys := deploy-tilehut
runs := run-tilehut
builds := build-tilehut
cleans := clean-tilehut
kills := kill-tilehut

# -------- The usefull options --------
deploy: $(deploys)

run: $(runs)

build: $(builds)

clean: $(cleans)

kill: $(kills)

# -------- Projects --------

# -> tilehut
kill-tilehut:
	@${MAKE} --no-print-directory -C tilehut kill

clean-tilehut:
	@${MAKE} --no-print-directory -C tilehut clean

build-tilehut:
	@${MAKE} --no-print-directory -C tilehut build

run-tilehut:
	@${MAKE} --no-print-directory -C tilehut run

deploy-tilehut:
	@${MAKE} --no-print-directory -C tilehut deploy
