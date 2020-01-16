# -------- Overall definitions --------
MAKEFLAGS += --silent
.PHONY: deploy run build clean kill

# -------- Project definitions --------
deploys := deploy-monitor deploy-landing deploy-nikto
runs 	:= run-monitor run-landing run-nikto
builds 	:= build-monitor build-landing build-nikto
cleans 	:= clean-monitor clean-landing clean-nikto
kills 	:= kill-monitor kill-landing kill-nikto

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

# Landing
kill-nikto:
	@${MAKE} --no-print-directory -C nikto kill

clean-nikto:
	@${MAKE} --no-print-directory -C nikto clean

build-nikto:
	@${MAKE} --no-print-directory -C nikto build

run-nikto:
	@${MAKE} --no-print-directory -C nikto run

deploy-nikto:
	@${MAKE} --no-print-directory -C nikto deploy
