SHELL := /bin/bash
PackageDir=packages
DIRS := $(shell ls -l . |awk '/^d/ {print $$NF}')
IgnoreDirs=$(PackageDir)
REGISTRY?=

all: package

package:
	@echo "Using registry $(REGISTRY)"
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
	@echo "Package the helm charts into $(PackageDir) successfully!"

package_source: REGISTRY=__REGISTRY_PREFIX__
package_source: package

clean:
	@rm -rf $(PackageDir)
	@echo "Remove $(PackageDir) successfully!"

.PHONY: package package_source clean 
