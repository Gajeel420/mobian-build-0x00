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

## Flashing Mobian to PinePhone A64

### Prerequisites

- PinePhone A64 (Beta edition)
- microSD card (16GB+ recommended, Class 10 / UHS-I or faster)
- A computer with a microSD card reader
- Internet connection for downloading the image

### Step 1: Download the Mobian Image

Grab the latest Mobian image for PinePhone from the official site:

```bash
wget https://images.mobian.org/pinephone/weekly/mobian-pinephone-phosh-latest.img.gz
```

> **Note**: The default Mobian image ships with Phosh. This project replaces it with a
> terminal-centric Sway environment after flashing.

### Step 2: Identify Your microSD Card

Insert your microSD card and find its device path:

```bash
lsblk
```

Look for your card (e.g., `/dev/sdX` or `/dev/mmcblkX`). **Double-check the device** — writing to the wrong device will destroy data.

### Step 3: Flash the Image

```bash
# Decompress and write in one step
zcat mobian-pinephone-phosh-latest.img.gz | sudo dd of=/dev/sdX bs=4M status=progress conv=fsync
```

Replace `/dev/sdX` with your actual microSD device. Wait for the write to complete and sync.

Alternatively, use [balenaEtcher](https://etcher.balena.io/) for a graphical flashing tool (supports `.img.gz` directly).

### Step 4: First Boot

1. Insert the microSD card into the PinePhone (slot is on the back, under the cover)
2. Hold **Power** for 3 seconds to boot
3. Mobian will resize the partition on first boot — this takes a minute
4. Default login: user `mobian`, password `1234`
5. **Change your password immediately**: `passwd`

### Step 5: Connect to WiFi

```bash
nmcli device wifi list
nmcli device wifi connect "YourSSID" password "YourPassword"
```

### Step 6: Install This Desktop Environment

```bash
sudo apt install -y git
git clone https://github.com/Gajeel420/mobian-build-0x00.git
cd mobian-build-0x00
sudo ./install.sh
```

After installation, log out of Phosh and start Sway:

```bash
# Disable Phosh (the default DE)
sudo systemctl disable phosh
# Start Sway
sway
```

To make Sway start automatically on login, add to `~/.profile`:

```bash
if [ -z "$WAYLAND_DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
    exec sway
fi
```

### Flashing to eMMC (Optional)

To flash directly to the PinePhone's internal eMMC storage instead of running from microSD:

1. Boot from the microSD card first (as above)
2. The eMMC appears as `/dev/mmcblk2`
3. Flash the image to eMMC:

```bash
zcat mobian-pinephone-phosh-latest.img.gz | sudo dd of=/dev/mmcblk2 bs=4M status=progress conv=fsync
```

4. Power off, remove the microSD card, and boot — the PinePhone will now boot from eMMC
5. Repeat Steps 5-6 to connect WiFi and install this desktop environment

> **Tip**: The PinePhone boot order is: microSD first, then eMMC. Remove the microSD to boot
> from eMMC, or use the hardware dip switches (under the back cover) to disable microSD boot.

### Troubleshooting

| Issue | Solution |
|---|---|
| PinePhone won't boot | Hold Power for 15 seconds to force off, try again. Check microSD is seated properly |
| No display output | Try `transform 270` instead of `transform 90` in sway config |
| Touchscreen not working | Run `swaymsg -t get_inputs` and update the input identifier in sway config |
| Very slow performance | Ensure ZRAM is active: `swapon --show`. Check governor: `cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor` |
| WiFi not found | PinePhone WiFi can be toggled via hardware dip switch #1 under the back cover |

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
