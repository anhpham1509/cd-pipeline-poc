GO_PACKAGES = `go list ./... | egrep -v "/vendor/"`
GO_FILES=`find . -name "*.go" -not -path "./vendor/*" -not -path ".git/*"`
GO_FILES_NO_TEST = `find . -name "*.go" -not -path "./vendor/*" -not -path ".git/*" -not -name "*_test.go"`
GO_TOOLS = golang.org/x/tools/cmd/goimports \
						honnef.co/go/tools/cmd/staticcheck \
						golang.org/x/lint/golint \
						github.com/fzipp/gocyclo \
						honnef.co/go/tools/cmd/unused \
            honnef.co/go/tools/cmd/gosimple \
            github.com/mdempsky/unconvert \
            github.com/alexkohler/nakedret \
            mvdan.cc/unparam

.PHONY: setup
setup:
	go get -u -v ${GO_TOOLS}

.PHONY: install
install:
	dep ensure -v

.PHONY: format
format:
	gofmt -s -w -e $(GO_FILES)
	goimports -w -l -e $(GO_FILES)
	npm run format

.PHONY: lint
lint:
	parallel -k \
		go vet ./... \
		staticcheck $(GO_PACKAGES) \
		golint -set_exit_status $(GO_PACKAGES) \
		gocyclo -over 12 $(GO_FILES_NO_TEST) \
		unused $(GO_PACKAGES) \
		gosimple $(GO_PACKAGES) \
		unconvert $(GO_PACKAGES) \
		nakedret $(GO_PACKAGES) \
		unparam $(GO_PACKAGES)

.PHONY: test
test:
	go test -race -cover `go list ./...`
	npm run test

.PHONY: integration-test
test-integration-api:
	go test -race -cover `go list ./... | egrep "**_integration_test.go"`

.PHONY: build
build:
	scripts/build.sh

.PHONY: npm
npm:
	NVM_DIR="$HOME/.nvm"
	NVM_VERSION=0.33.11
	git clone --branch v$NVM_VERSION https://github.com/creationix/nvm.git "$NVM_DIR"
	source "$NVM_DIR/nvm.sh"
	nvm install
