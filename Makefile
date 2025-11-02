# Makefile for managing multiple mdbook projects

# Find all directories containing book.toml
BOOKS := $(shell find . -name book.toml -type f -exec dirname {} \; | sed 's|^\./||' | sort)

# Default target
# .PHONY: all
# all: build

# Build all books
# .PHONY: build
# build: $(addprefix build-,$(BOOKS))

# Clean all books
# .PHONY: clean
# clean: $(addprefix clean-,$(BOOKS))

# Serve all books (note: this will run in parallel, might not be ideal)
# .PHONY: serve
# serve: $(addprefix serve-,$(BOOKS))

# Test all books
.PHONY: test
test: $(addprefix test-,$(BOOKS))

# Init a new book
.PHONY: init-%
init-%:
	mkdir -p $*
	cd $* && mdbook init --ignore git

# Build a specific book
.PHONY: $(addprefix build-,$(BOOKS))
$(addprefix build-,$(BOOKS)): build-%:
	cd $* && mdbook build

# Clean a specific book
.PHONY: $(addprefix clean-,$(BOOKS))
$(addprefix clean-,$(BOOKS)): clean-%:
	cd $* && mdbook clean

# Serve a specific book
.PHONY: $(addprefix serve-,$(BOOKS))
$(addprefix serve-,$(BOOKS)): serve-%:
	cd $* && mdbook serve

# Test a specific book
.PHONY: $(addprefix test-,$(BOOKS))
$(addprefix test-,$(BOOKS)): test-%:
	cd $* && mdbook test

# Help target
.PHONY: help
help:
	@echo "Available targets:"
	@echo "  build      - Build all mdbook projects"
	@echo "  clean      - Clean all mdbook projects"
	@echo "  serve      - Serve all mdbook projects (use with caution)"
	@echo "  test       - Test all mdbook projects"
	@echo "  init-<dir> - Initialize a new mdbook project in <dir>"
	@echo "  build-<dir> - Build specific mdbook in <dir>"
	@echo "  clean-<dir> - Clean specific mdbook in <dir>"
	@echo "  serve-<dir> - Serve specific mdbook in <dir>"
	@echo "  test-<dir>  - Test specific mdbook in <dir>"
	@echo "  help       - Show this help"
	@echo ""
	@echo "Detected mdbook projects: $(BOOKS)"
