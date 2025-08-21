# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a collection of shell script utilities for system configuration, including GitHub setup, font installation, and wallpaper generation.

## Scripts and Their Purpose

### GitHub Configuration Scripts
- **src/configure-github**: Sets up global Git configuration with GPG signing for all repositories
- **src/configure-github-repo**: Configures Git settings for a specific repository (must be run inside a git repository)
- **src/register-github-gpgkey**: Generates and registers a GPG key for GitHub commit signing

### Font Installation
- **src/install-fonts**: Installs Nerd Fonts and Google Fonts to `~/.fonts/`

### Wallpaper Generation
- **src/new-wallpaper**: Generates AI-powered wallpapers using AWS Bedrock (Amazon Nova Canvas) and sets them as desktop background
  - On first run, prompts for wallpaper storage directory with tab completion
  - Uses XDG Pictures directory as default (typically ~/Pictures/wallpapers)
  - Saves configuration to `~/.local/etc/new-wallpaper.conf`
  - Supports custom wallpaper directories

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
- `aws` - AWS CLI for Bedrock API access (new-wallpaper)
- `jq` - JSON processor for parsing AWS response (new-wallpaper)
- `uuidgen` - Generate unique IDs for wallpaper files (new-wallpaper)
- `xdg-user-dir` - XDG directory detection for default Pictures folder (new-wallpaper)
- `magick` - ImageMagick for scaling preview images to 50% (new-wallpaper, optional)
- `kitten` - Kitty terminal image viewer (new-wallpaper, optional)
- `gsettings` - GNOME settings tool for setting wallpaper (new-wallpaper, optional)

## Important Considerations

- The `configure-github-repo` script must be run inside a Git repository
- The `register-github-gpgkey` script will upload the GPG public key to GitHub using the GitHub CLI (`gh`)
- Font installation scripts download from external sources (GitHub releases and Google Fonts)
- The `new-wallpaper` script requires AWS credentials configured with a profile named "sandbox" and access to Amazon Bedrock in us-east-1
- The `new-wallpaper` script prompts for wallpaper directory on first run (defaults to XDG Pictures directory + /wallpapers)
- Configuration is stored in `~/.local/etc/new-wallpaper.conf` with a single WALLPAPER_DIR setting
- All scripts use `set -euo pipefail` for error handling