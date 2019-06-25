# -------- Overall definitions --------
MAKEFLAGS += --silent
.PHONY: deploy run build clean kill

# -------- Project definitions --------
deploys 	:= deploy-tilehut deploy-posgrest deploy-vectortile
runs 		:= run-tilehut run-posgrest run-vectortile
builds 		:= build-tilehut build-posgrest build-vectortile
cleans 		:= clean-tilehut clean-posgrest clean-vectortile
kills 		:= kill-tilehut kill-posgrest kill-vectortile

# -------- The usefull options --------
deploy: $(deploys)

run: $(runs)

build: $(builds)

clean: $(cleans)

kill: $(kills)

restart: deploy

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

# -> Vector Tiles
kill-vectortile:
	@${MAKE} --no-print-directory -C vector-tiles kill

clean-vectortile:
	@${MAKE} --no-print-directory -C vector-tiles clean

build-vectortile:
	@${MAKE} --no-print-directory -C vector-tiles build

run-vectortile:
	@${MAKE} --no-print-directory -C vector-tiles run

deploy-vectortile:
	@${MAKE} --no-print-directory -C vector-tiles deploy
