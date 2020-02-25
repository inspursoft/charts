PackageDir=packages
DIRS := $(shell find . -maxdepth 1 -type d)
IgnoreDirs=. ./.git ./$(PackageDir)
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
			find $$dir -type f -exec sed -i "s|__REGISTRY_PREFIX__|$(REGISTRY)|g" {} +; \
			helm package -d $(PackageDir) $$dir; \
                fi; \
	done

.PHONY: transform
