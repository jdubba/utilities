# Makefile for utilities installation

# Configuration
PREFIX := $(HOME)/.local
BINDIR := $(PREFIX)/bin
SRCDIR := src

# List of scripts to install
SCRIPTS := configure-github \
           configure-github-repo \
           install-fonts \
           new-wallpaper \
           register-github-gpgkey \
		   hpa

# Full paths for source and destination
SRC_SCRIPTS := $(addprefix $(SRCDIR)/,$(SCRIPTS))
DEST_SCRIPTS := $(addprefix $(BINDIR)/,$(SCRIPTS))

# Default target
.PHONY: help
help:
	@echo "Utilities Installation Makefile"
	@echo ""
	@echo "Usage:"
	@echo "  make install    - Install all scripts to ~/.local/bin"
	@echo "  make uninstall  - Remove all scripts from ~/.local/bin"
	@echo "  make check      - Check if scripts are installed"
	@echo "  make help       - Show this help message"

# Install target
.PHONY: install
install: $(BINDIR)
	@echo "Installing utilities to $(BINDIR)..."
	@for script in $(SCRIPTS); do \
		echo "  Installing $$script..."; \
		install -m 755 $(SRCDIR)/$$script $(BINDIR)/$$script; \
	done
	@echo "Installation complete!"
	@echo ""
	@echo "Make sure $(BINDIR) is in your PATH:"
	@echo '  export PATH="$$HOME/.local/bin:$$PATH"'

# Uninstall target
.PHONY: uninstall
uninstall:
	@echo "Removing utilities from $(BINDIR)..."
	@for script in $(SCRIPTS); do \
		if [ -f $(BINDIR)/$$script ]; then \
			echo "  Removing $$script..."; \
			rm -f $(BINDIR)/$$script; \
		fi; \
	done
	@echo "Uninstall complete!"

# Check installation status
.PHONY: check
check:
	@echo "Checking installation status..."
	@for script in $(SCRIPTS); do \
		if [ -f $(BINDIR)/$$script ]; then \
			echo "  ✓ $$script is installed"; \
		else \
			echo "  ✗ $$script is not installed"; \
		fi; \
	done

# Create bin directory if it doesn't exist
$(BINDIR):
	@echo "Creating directory $(BINDIR)..."
	@mkdir -p $(BINDIR)

# Clean target (alias for uninstall)
.PHONY: clean
clean: uninstall

.DEFAULT_GOAL := help
