all: brew install

brew:
	brew bundle --no-lock

install: brew
	git init
	pre-commit uninstall
	pre-commit install -f
	tfenv install

test:
	cd test && go mod download
	cd test && go test -v -timeout 2h

.PHONY: brew install test
