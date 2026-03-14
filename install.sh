#!/usr/bin/env bash
set -euo pipefail

# PinePhone A64 Terminal Desktop - Master Deploy Script
# Installs packages, deploys configs, and enables services

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_USER="${SUDO_USER:-$USER}"
TARGET_HOME=$(eval echo "~$TARGET_USER")

if [ "$(id -u)" -ne 0 ]; then
    echo "Error: This script must be run as root (or with sudo)."
    exit 1
fi

echo "==========================================="
echo " PinePhone Terminal Desktop Environment"
echo " Installing for user: $TARGET_USER"
echo "==========================================="
echo ""

# Step 1: Install packages
echo "[1/6] Installing packages..."
bash "$SCRIPT_DIR/setup_environment.sh"
echo ""

# Step 2: Deploy Sway config
echo "[2/6] Deploying Sway configuration..."
SWAY_DIR="$TARGET_HOME/.config/sway"
mkdir -p "$SWAY_DIR"
cp "$SCRIPT_DIR/config/sway/config" "$SWAY_DIR/config"
chown -R "$TARGET_USER:$TARGET_USER" "$TARGET_HOME/.config/sway"
echo "    Installed: $SWAY_DIR/config"
echo ""

# Step 3: Build wvkbd from source (optional, skip if already installed)
echo "[3/6] Building wvkbd from source..."
bash "$SCRIPT_DIR/wvkbd/build_wvkbd.sh"
echo ""

# Step 4: Deploy ZRAM configuration
echo "[4/6] Configuring ZRAM swap..."
cp "$SCRIPT_DIR/system/zramswap.conf" /etc/default/zramswap
systemctl restart zramswap.service || echo "    Warning: Could not restart zramswap service"
echo "    Installed: /etc/default/zramswap"
echo ""

# Step 5: Deploy CPU governor service
echo "[5/6] Installing CPU governor service..."
cp "$SCRIPT_DIR/system/cpu-governor.service" /etc/systemd/system/cpu-governor.service
systemctl daemon-reload
systemctl enable cpu-governor.service
systemctl start cpu-governor.service || echo "    Warning: Could not start cpu-governor service"
echo "    Installed and enabled: cpu-governor.service"
echo ""

# Step 6: Shell integration
echo "[6/6] Setting up shell integration..."
BASHRC="$TARGET_HOME/.bashrc"
MARKER="# PinePhone Terminal Desktop - Shell Integration"
if ! grep -q "$MARKER" "$BASHRC" 2>/dev/null; then
    {
        echo ""
        echo "$MARKER"
        echo "source $SCRIPT_DIR/shell/shell_integration.sh"
    } >> "$BASHRC"
    chown "$TARGET_USER:$TARGET_USER" "$BASHRC"
    echo "    Added shell integration to $BASHRC"
else
    echo "    Shell integration already present in $BASHRC"
fi
echo ""

echo "==========================================="
echo " Installation complete!"
echo ""
echo " To start the desktop, run:"
echo "   sway"
echo ""
echo " Toggle virtual keyboard: Volume Up button"
echo " Brightness: bright 50% / bright +10%"
echo "==========================================="
