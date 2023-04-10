MKDIR:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

# clones direktiv and builds api docs
.PHONY: update-api
update-api:
	echo "clean-up old repo if present"
	rm -rf build/api/direktiv
	mkdir -p build/api
	cd build/api; git clone https://github.com/direktiv/direktiv.git;
	cd build/api/direktiv; make api-docs
	cat build/api/direktiv/scripts/api/api.md > docs/api.md


.PHONY: update-spec
update-spec:
	./get-spec.sh

.PHONY: install-deps
install-deps:
	./install-swagger.sh

.PHONY: create-examples
create-examples:
	rm -Rf direktiv-examples
	git clone https://github.com/direktiv/direktiv-examples.git
	docker build -f Dockerfile.examples -t exbuilder  .
	docker run -v $(shell pwd)/direktiv-examples:/examples exbuilder
	$(shell pwd)/add-example-nav.sh
	rm -Rf docs/examples
	cp -Rf direktiv-examples/out docs/examples
	rm -f docs/examples/nav.out


.PHONY: update-all
update-all: update-spec create-examples update-api


.PHONY: test-links
test-links:
	docker build -t linkcheck ${MKDIR}/test/linkcheck
	docker run --rm -v ${MKDIR}:/testsite linkcheck
