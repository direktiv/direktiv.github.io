# clones direktiv and builds api docs
.PHONY: update-api
update-api:
	echo "clean-up old repo if present"
	rm -rf build/api/direktiv
	mkdir -p build/api
	cd build/api; git clone https://github.com/vorteil/direktiv.git;
	cd build/api/direktiv; make api-docs
	cat build/api/header.yml build/api/direktiv/scripts/api/api.md > docs/api/api.md

.PHONY: install-deps:
install-deps:
	apt install gnupg ca-certificates
	apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 379CE192D401AB61
	echo "deb https://dl.bintray.com/go-swagger/goswagger-debian ubuntu main" | tee /etc/apt/sources.list.d/goswagger.list
	apt update 
	apt install swagger
