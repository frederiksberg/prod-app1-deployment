# -------- Overall definitions --------
MAKEFLAGS += --silent
.PHONY: deploy run build clean kill

# -------- Project definitions --------
deploys 	:= deploy-tilehut deploy-posgrest deploy-vectortile deploy-shiny-cvr deploy-terria
runs 		:= run-tilehut run-posgrest run-vectortile run-shiny-cvr run-terria
builds 		:= build-tilehut build-posgrest build-vectortile build-shiny-cvr build-terria
cleans 		:= clean-tilehut clean-posgrest clean-vectortile clean-shiny-cvr clean-terria
kills 		:= kill-tilehut kill-posgrest kill-vectortile kill-shiny-cvr kill-terria

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

# -> terria
kill-terria:
	@${MAKE} --no-print-directory -C terria kill

clean-terria:
	@${MAKE} --no-print-directory -C terria clean

build-terria:
	@${MAKE} --no-print-directory -C terria build

run-terria:
	@${MAKE} --no-print-directory -C terria run

deploy-terria:
	@${MAKE} --no-print-directory -C terria deploy

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

# -> shiny-cvr
kill-shiny-cvr:
	@${MAKE} --no-print-directory -C shiny-cvr kill

clean-shiny-cvr:
	@${MAKE} --no-print-directory -C shiny-cvr clean

build-shiny-cvr:
	@${MAKE} --no-print-directory -C shiny-cvr build

run-shiny-cvr:
	@${MAKE} --no-print-directory -C shiny-cvr run

deploy-shiny-cvr:
	@${MAKE} --no-print-directory -C shiny-cvr deploy
