## Makefile -*- mode: makefile; -*-

EMACS ?= emacs
CASK ?= cask
BUILD_DIR := dist
DOCS_BUILD_DIR := public
PACKAGE := stops
VERSION := 1.0.1
RC_TAG :=
ARCHIVE := $(BUILD_DIR)/$(PACKAGE)-$(VERSION)$(RC_TAG).tar.gz

.PHONY: all check clean clean-docs compile cask docs lint package test

all: check

compile:
	$(EMACS) --batch -Q -L . \
	  --eval "(setq byte-compile-error-on-warn t)" \
	  -f batch-byte-compile stops.el

test: compile
	$(EMACS) --batch -Q -L . \
	  -l stops-test.el \
	  -f ert-run-tests-batch-and-exit

lint:
	$(EMACS) --batch -Q \
	  --eval "(require 'package)" \
	  --eval "(add-to-list 'package-archives '(\"melpa\" . \"https://melpa.org/packages/\") t)" \
	  --eval "(package-initialize)" \
	  --eval "(unless (package-installed-p 'package-lint) \
	             (package-refresh-contents) \
	             (package-install 'package-lint))" \
	  -f package-lint-batch-and-exit stops.el

check: compile test lint

docs: clean-docs
	mkdir -p $(DOCS_BUILD_DIR)
	$(EMACS) --batch -Q -L . \
	  --script docs/build-docs.el
	cp docs/stops.css $(DOCS_BUILD_DIR)/stops.css
	if [ -f docs/stops-el-badge.svg ]; then cp docs/stops-el-badge.svg $(DOCS_BUILD_DIR)/stops-el-badge.svg; fi
	cp $(DOCS_BUILD_DIR)/index.html docs/index.html
	touch $(DOCS_BUILD_DIR)/.nojekyll

clean-docs:
	rm -rf $(DOCS_BUILD_DIR)
	rm -f docs/index.html

cask:
	$(CASK) install
	$(CASK) exec $(EMACS) --batch -L . \
	  --eval "(setq byte-compile-error-on-warn t)" \
	  -f batch-byte-compile stops.el
	$(CASK) exec $(EMACS) --batch -L . \
	  -l stops-test.el \
	  -f ert-run-tests-batch-and-exit

package: clean docs
	mkdir -p $(BUILD_DIR)/$(PACKAGE)-$(VERSION)
	cp stops.el stops-test.el README.org Makefile Cask CHANGELOG.org LICENSE $(BUILD_DIR)/$(PACKAGE)-$(VERSION)/
	mkdir -p $(BUILD_DIR)/$(PACKAGE)-$(VERSION)/docs
	cp docs/index.org docs/build-docs.el docs/stops.css $(BUILD_DIR)/$(PACKAGE)-$(VERSION)/docs/
	if [ -f docs/index.html ]; then cp docs/index.html $(BUILD_DIR)/$(PACKAGE)-$(VERSION)/docs/index.html; fi
	if [ -f docs/stops-el-badge.svg ]; then cp docs/stops-el-badge.svg $(BUILD_DIR)/$(PACKAGE)-$(VERSION)/docs/stops-el-badge.svg; fi
	tar -C $(BUILD_DIR) -czf $(ARCHIVE) $(PACKAGE)-$(VERSION)

clean: clean-docs
	rm -f *.elc
	rm -rf $(BUILD_DIR)
