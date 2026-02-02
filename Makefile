IMAGE ?= your-registry/apache
TAG ?= v1.0.0
DOCKERFILE ?= Dockerfile.debian

.PHONY: build build-alpine run push clean

build:
	\tdocker build -f $(DOCKERFILE) -t $(IMAGE):$(TAG) .

build-alpine:
	\tdocker build -f Dockerfile.alpine -t $(IMAGE):$(TAG)-alpine .

run:
	\tdocker run --rm -p 8080:80 -e ENABLE_SSL=false $(IMAGE):$(TAG)

push:
	\tdocker push $(IMAGE):$(TAG)

clean:
	\tdocker rmi $(IMAGE):$(TAG) || true
