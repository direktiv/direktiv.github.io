.PHONY: clone
clone:
	git clone --depth 1 https://github.com/direktiv/direktiv.git || (cd direktiv ; git pull)
.PHONY: update-spec
update-spec: clone
	rm -Rf page/docs/spec
	cp -Rf direktiv/specification page/docs/spec

.PHONY: update-examples
update-examples: clone
	rm -Rf direktiv-examples
	git clone https://github.com/direktiv/direktiv-examples.git  || (cd direktiv-examples ; git pull)
	docker build -f Dockerfile.examples -t exbuilder  .
	docker run -v $(shell pwd)/direktiv-examples:/examples exbuilder
	rm -Rf page/docs/examples
	cp -Rf direktiv-examples/out page/docs/examples

.PHONY: update-api
update-api: clone
	speccy resolve direktiv/openapi/src/openapi.yaml -o page/docs/openapi.yaml

.PHONY: serve
serve:
	mkdocs serve -f page/mkdocs.yml