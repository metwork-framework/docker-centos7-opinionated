NAME=metwork/centos7-opinionated
VERSION=$(shell ./version.sh)

build:
	docker build -t $(NAME):$(VERSION) .

debug: build
	docker run -i -t $(NAME):$(VERSION) bash
