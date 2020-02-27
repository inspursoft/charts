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
			chartName=$$(awk '/^name:/ {print $$2}' $$dir/Chart.yaml); \
			chartVersion=$$(awk '/^version:/ {print $$2}' $$dir/Chart.yaml); \
			target=$$chartName-$$chartVersion; \
			cp -r $$dir $(PackageDir)/$$dir; \
			find $(PackageDir)/$$dir -type f -exec sed -i "s|__REGISTRY_PREFIX__|$(REGISTRY)|g" {} +; \
			tar -zcf $(PackageDir)/$$target.tgz -C $(PackageDir)  $$dir; \
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
