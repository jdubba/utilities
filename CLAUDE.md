# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a collection of shell script utilities for system configuration, primarily focused on GitHub setup and font installation.

## Scripts and Their Purpose

### GitHub Configuration Scripts
- **src/configure-github**: Sets up global Git configuration with GPG signing for all repositories
- **src/configure-github-repo**: Configures Git settings for a specific repository (must be run inside a git repository)
- **src/register-github-gpgkey**: Generates and registers a GPG key for GitHub commit signing

### Font Installation
- **src/install-fonts**: Installs Nerd Fonts and Google Fonts to `~/.fonts/`

## Development Commands

### Installation
- Install all scripts to ~/.local/bin: `make install`
- Uninstall all scripts: `make uninstall`
- Check installation status: `make check`
- Show help: `make help`

### Linting
- Install shellcheck for bash script linting: `sudo apt-get install shellcheck` (Ubuntu/Debian) or `brew install shellcheck` (macOS)
- Run shellcheck on any script: `shellcheck src/<script-name>`

### Testing Scripts
Scripts can be tested directly by running them:
```bash
./src/<script-name>
```

## Script Dependencies

The scripts use the following external tools:
- `gpg` - For GPG key generation and management
- `git` - For repository configuration
- `xh` - HTTP client for downloading fonts (alternative to curl/wget)
- `curl` - For downloading font files
- `tar` - For extracting font archives

## Important Considerations

- The `configure-github-repo` script must be run inside a Git repository
- The `register-github-gpgkey` script will upload the GPG public key to GitHub using the GitHub CLI (`gh`)
- Font installation scripts download from external sources (GitHub releases and Google Fonts)
- All scripts use `set -euo pipefail` for error handling