# -------- Overall definitions --------
MAKEFLAGS += --silent
.PHONY: deploy run build clean kill

# -------- Project definitions --------
deploys 	:= deploy-tilehut deploy-posgrest
runs 		:= run-tilehut run-posgrest
builds 		:= build-tilehut build-posgrest
cleans 		:= clean-tilehut clean-posgrest
kills 		:= kill-tilehut kill-posgrest

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

# -> posgrest
kill-posgrest:
	@${MAKE} --no-print-directory -C PostgREST kill

clean-posgrest:
	@${MAKE} --no-print-directory -C PostgREST clean

build-posgrest:
	@${MAKE} --no-print-directory -C PostgREST build

run-posgrest:
	@${MAKE} --no-print-directory -C PostgREST run

deploy-posgrest:
	@${MAKE} --no-print-directory -C PostgREST deploy
