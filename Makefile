export EMACS ?= $(shell which emacs)
CASK_DIR := $(shell cask package-directory)
BUILD_DIR := ./dist

EL_FILES :=	guards.el

default: compile

$(CASK_DIR): Cask
	cask install
	@touch $(CASK_DIR)

.PHONY: cask clean compile test release

default: compile

cask: $(CASK_DIR)

clean:
	cask clean-elc
	git clean -f
	rm -rf $(BUILD_DIR)

compile: cask
	cask emacs --batch -L . --eval "(setq byte-compile-error-on-warn t)" -f batch-byte-compile $(EL_FILES); (ret=$$? ; exit $$ret)

test: compile
	cask emacs --batch -L . -l guards-test.el -f ert-run-tests-batch

release: compile test
	cask pkg-file
	cask package $(BUILD_DIR)
