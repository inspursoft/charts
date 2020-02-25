SHELL := /bin/bash
PackageDir=packages
DIRS := $(shell ls -l . |awk '/^d/ {print $$NF}')
IgnoreDirs=$(PackageDir)
REGISTRY?=

all: package

package:
	@if [ ! -d "$(PackageDir)" ]; then mkdir $(PackageDir); fi
	@for dir in $(DIRS); \
	do \
		ischart=true; \
		for ignore in $(IgnoreDirs); \
		do \
			if [ "$$dir" = "$$ignore" ]; then \
				ischart=false; \
				break; \
			fi; \
		done; \
		if [ "$$ischart" == "true" ]; then \
			cp -r $$dir $(PackageDir); \
			find $(PackageDir)/$$dir -type f -exec sed -i "s|__REGISTRY_PREFIX__|$(REGISTRY)|g" {} +; \
			helm package -d $(PackageDir) $(PackageDir)/$$dir; \
			rm -rf $(PackageDir)/$$dir; \
                fi; \
	done
	@echo "package the helm charts into $(PackageDir) successfully!"

clean:
	@rm -rf $(PackageDir)
	@echo "remove $(PackageDir) successfully!"

.PHONY: transform clean
