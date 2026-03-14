# mobian-build-0x00

Terminal-centric mobile desktop environment for the PinePhone A64 (Beta) running Debian/Mobian.

## Overview

A lightweight Sway (Wayland) desktop optimized for the PinePhone's hardware, featuring:

- **Sway** window manager with touch-optimized configuration
- **foot** terminal emulator as the primary interface
- **wvkbd** on-screen keyboard with Cyberdeck theme (green-on-black)
- **tmux** auto-session management
- **ZRAM** swap for the 2GB RAM constraint
- **schedutil** CPU governor for battery/performance balance

## Quick Start

```bash
sudo ./install.sh
```

This runs all setup steps: package installation, config deployment, wvkbd build, system tuning, and shell integration.

## Manual Setup

### Step 1: Install Packages
```bash
sudo ./setup_environment.sh
```

### Step 2: Deploy Sway Config
```bash
mkdir -p ~/.config/sway
cp config/sway/config ~/.config/sway/config
```

### Step 3: Build wvkbd (optional, for latest version)
```bash
sudo ./wvkbd/build_wvkbd.sh
```

### Step 4: System Tuning
```bash
sudo cp system/zramswap.conf /etc/default/zramswap
sudo systemctl restart zramswap

sudo cp system/cpu-governor.service /etc/systemd/system/
sudo systemctl enable --now cpu-governor.service
```

### Step 5: Shell Integration
```bash
echo "source $(pwd)/shell/shell_integration.sh" >> ~/.bashrc
```

## Usage

| Action | Method |
|---|---|
| Start desktop | `sway` |
| Toggle keyboard | Volume Up button |
| Brightness | `bright 50%` or `bright +10%` |
| File picker | `nnn` |
| Terminal sessions | Auto-managed by tmux |

## Project Structure

```
setup_environment.sh     - Package installer
install.sh               - Master deploy script
config/sway/config       - Sway window manager configuration
wvkbd/build_wvkbd.sh    - wvkbd build-from-source script
wvkbd/cyberdeck-theme.conf - Keyboard color theme values
system/zramswap.conf     - ZRAM swap configuration
system/cpu-governor.service - CPU governor systemd unit
shell/shell_integration.sh  - Bash/Zsh session setup
```

## License

GPL-3.0
