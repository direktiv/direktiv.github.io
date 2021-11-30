# clones direktiv and builds api docs
.PHONY: update-api
update-api:
	echo "clean-up old repo if present"
	rm -rf build/api/direktiv
	mkdir -p build/api
	cd build/api; git clone https://github.com/direktiv/direktiv.git;
	cd build/api/direktiv; make api-docs
	cat build/api/header.yml build/api/direktiv/scripts/api/api.md > docs/api/api.md

.PHONY: install-deps
install-deps:
	./install-swagger.sh

# Validate jekyll files
.PHONY: validate-api
validate-api:
	bundle exec jekyll build --drafts
	bundle exec htmlproofer ./_site --url-ignore "/#/"