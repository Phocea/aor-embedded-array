.PHONY: build help

help:
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

install: package.json ## Install dependencies
	@yarn

clean: ## Clean up the lib folder for building
	@rm -rf lib

build: clean ## Compile ES6 files to JS
	@NODE_ENV=production ./node_modules/.bin/babel \
		--out-dir=lib \
		--stage=0 \
		--ignore=*.spec.js \
		./src

watch: ## Continuously compile ES6 files to JS
	@NODE_ENV=production ./node_modules/.bin/babel \
		--out-dir=lib \
		--stage=0 \
		--ignore=*.spec.js \
		--watch \
		./src

test: ## Launch unit tests
	@NODE_ENV=test ./node_modules/.bin/nyc \
		./node_modules/.bin/mocha \
		--opts ./mocha.opts \
		"./src/**/*.spec.js"


watch-test: ## Launch unit tests and watch for changes
	@NODE_ENV=test ./node_modules/.bin/nyc \
		./node_modules/.bin/mocha \
		--opts ./mocha.opts \
		--watch \
		"./src/**/*.spec.js"

format: ## Format the source code
	@./node_modules/.bin/eslint --fix ./src
