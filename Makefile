## Makefile -*- mode: makefile; -*-

export EMACS ?= $(shell which emacs)
CASK_DIR := $(shell cask package-directory)
BUILD_DIR := ./dist

SRCS :=	stops.el
OBJS := $(SRCS:.el=.elc)

default: all

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

all: $(OBJS)

$(OBJS): $(SRCS)
	cask emacs --batch -L . --eval "(setq byte-compile-error-on-warn t)" -f batch-byte-compile $^

test: all $(OBJS)
	cask emacs --batch -L . -l stops-test.el -f ert-run-tests-batch-and-exit

release: all test
	cask pkg-file
	cask package $(BUILD_DIR)
