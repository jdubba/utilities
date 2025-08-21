# Utilities

A collection of bash script utilities for Linux system configuration, focusing on developer environment setup and customization.

## Features

- **GitHub Configuration**: Automated Git and GPG setup for secure commits
- **Font Management**: Easy installation of Nerd Fonts and Google Fonts
- **Wallpaper Generation**: AI-powered desktop wallpaper creation using AWS Bedrock

## Quick Start

```bash
# Clone the repository
git clone https://github.com/yourusername/utilities.git
cd utilities

# Install scripts to ~/.local/bin
make install

# Verify installation
make check
```

## Available Scripts

### GitHub Tools

#### `configure-github`
Sets up global Git configuration with GPG signing for all repositories.

```bash
configure-github
```

#### `configure-github-repo`
Configures Git settings for a specific repository. Must be run inside a git repository.

```bash
cd /path/to/your/repo
configure-github-repo
```

#### `register-github-gpgkey`
Generates and registers a GPG key for GitHub commit signing using the GitHub CLI.

```bash
register-github-gpgkey
```

### System Customization

#### `install-fonts`
Downloads and installs Nerd Fonts and Google Fonts to `~/.fonts/`.

```bash
install-fonts
```

#### `new-wallpaper`
Generates AI-powered wallpapers using Amazon Bedrock's Nova Canvas model and sets them as your desktop background.

```bash
new-wallpaper "a serene mountain landscape at sunset"
```

**Features**:
- Interactive first-run setup with directory selection
- Tab completion for directory paths
- Uses system XDG Pictures directory as default base
- Configuration saved to `~/.local/etc/new-wallpaper.conf`
- Automatic directory creation if needed
- Custom wallpaper storage locations
- Scaled preview (50% size) when ImageMagick is available

**Configuration**: On first run, the script will prompt you to select a directory for storing wallpapers (defaults to your XDG Pictures directory + `/wallpapers`). The configuration is saved for future runs.

**Note**: This script requires:
- AWS CLI configured with a "sandbox" profile
- Access to Amazon Bedrock in us-east-1 region
- GNOME desktop environment (uses gsettings) - optional
- Kitty terminal (for image preview) - optional
- ImageMagick (for 50% scaled preview) - optional

## Installation

The Makefile provides automated installation for all scripts:

```bash
# Install all scripts
make install

# Uninstall scripts
make uninstall

# Check installation status
make check
```

After installation, ensure `~/.local/bin` is in your PATH:

```bash
export PATH="$HOME/.local/bin:$PATH"
```

Add this line to your shell configuration file (`~/.bashrc`, `~/.zshrc`, etc.) for persistence.

## Dependencies

### Core Dependencies
- `bash` - Shell interpreter
- `git` - Version control system
- `gpg` - GNU Privacy Guard for key management

### Script-Specific Dependencies

#### Font Installation
- `xh` or `curl` - HTTP client for downloading
- `tar` - Archive extraction

#### Wallpaper Generation
- `aws` - AWS CLI for Bedrock API
- `jq` - JSON processor
- `uuidgen` - UUID generator
- `xdg-user-dir` - XDG directory detection (usually pre-installed)
- `magick` - ImageMagick for scaled preview (optional)
- `kitten` - Kitty terminal image viewer (optional)
- `gsettings` - GNOME settings manager (optional)

#### GitHub Tools
- `gh` - GitHub CLI (for register-github-gpgkey)

## Development

### Testing Scripts

Run scripts directly from the source directory:

```bash
./src/configure-github
```

### Linting

Use ShellCheck for bash script validation:

```bash
# Install ShellCheck
sudo apt-get install shellcheck  # Debian/Ubuntu
brew install shellcheck           # macOS

# Check a script
shellcheck src/configure-github
```

## Configuration

### new-wallpaper Configuration

The `new-wallpaper` script uses a configuration file at `~/.local/etc/new-wallpaper.conf`:

```bash
# Directory for wallpaper storage
WALLPAPER_DIR="/home/username/Pictures/wallpapers"
```

The default directory is determined using the XDG Pictures directory (typically `~/Pictures`) with `/wallpapers` appended. The script automatically detects your system's Pictures directory using `xdg-user-dir`.

To reconfigure, simply delete the config file and run the script again:
```bash
rm ~/.local/etc/new-wallpaper.conf
new-wallpaper "test prompt"  # Will prompt for new directory
```

### AWS Setup (for new-wallpaper)

Configure AWS CLI with a "sandbox" profile:

```bash
aws configure --profile sandbox
```

Ensure you have access to Amazon Bedrock in the us-east-1 region.

### GPG Configuration

The GitHub configuration scripts will help set up GPG keys for commit signing. Ensure you have a valid email address configured in Git:

```bash
git config --global user.email "your-email@example.com"
git config --global user.name "Your Name"
```

## Project Structure

```
utilities/
├── CLAUDE.md           # AI assistant context file
├── Makefile           # Installation automation
├── README.md          # This file
└── src/               # Script sources
    ├── configure-github
    ├── configure-github-repo
    ├── install-fonts
    ├── new-wallpaper
    └── register-github-gpgkey
```

## Error Handling

All scripts use strict error handling with:
```bash
set -euo pipefail
```

This ensures:
- Scripts exit on any command failure (`-e`)
- Undefined variables cause errors (`-u`)
- Pipe failures are detected (`-o pipefail`)

## Contributing

1. Fork the repository
2. Create a feature branch
3. Test your changes with ShellCheck
4. Submit a pull request

## License

This project is open source. See the LICENSE file for details (if applicable).

## Support

For issues, questions, or suggestions:
- Open an issue on GitHub
- Check existing scripts for usage examples
- Refer to CLAUDE.md for development context