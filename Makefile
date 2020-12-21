.PHONY: clean test check build.local build.linux build.osx build.docker build.push

NAMESPACE	?= vkumbhar94
REPOSITORY	?= logicmonitor-adapter-plugin
BINARY        ?= logicmonitor.so
VERSION       ?= $(shell git describe --tags --always --dirty)
TAG           ?= $(VERSION)
SOURCES       = $(shell find . -name '*.go')
DOCKERFILE    ?= Dockerfile
GOPKGS        = $(shell go list ./...)
BUILD_FLAGS   ?= -v
LDFLAGS       ?= -X main.version=$(VERSION) -w -s
# LDFLAGS       ?= -linkmode external -w -extldflags "-static"



default: build.local

clean:
	rm -rf build

test:
	go test -v $(GOPKGS)

check:
	go mod download
	golangci-lint run --timeout=2m ./...


build.local: build/$(BINARY)
build.linux: build/linux/$(BINARY)
build.osx: build/osx/$(BINARY)

build/$(BINARY): go.mod $(SOURCES) 
	CGO_ENABLED=1 go build -o build/$(BINARY) --buildmode=plugin $(BUILD_FLAGS) -ldflags "$(LDFLAGS)" .

build/linux/$(BINARY): # go.mod $(SOURCES) 
	# GOOS=linux GOARCH=amd64 CGO_ENABLED=1 go build --buildmode=plugin $(BUILD_FLAGS) -o build/linux/$(BINARY) -ldflags "$(LDFLAGS)" .
	docker build --build-arg VERSION=$(VERSION) -t $(NAMESPACE)/$(REPOSITORY):$(VERSION) .
	docker run --rm -v "$(shell pwd)":/out --entrypoint=cp $(NAMESPACE)/$(REPOSITORY):$(VERSION) /bin/logicmonitor.so /out/

build/osx/$(BINARY): go.mod $(SOURCES) 
	GOOS=darwin GOARCH=amd64 CGO_ENABLED=1 go build --buildmode=plugin $(BUILD_FLAGS) -o build/osx/$(BINARY) -ldflags "$(LDFLAGS)" .
