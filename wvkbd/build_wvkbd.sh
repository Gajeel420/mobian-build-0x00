#!/usr/bin/env bash
set -euo pipefail

# Build wvkbd from source with mobintl layout
# This enables the latest features and custom compilation options

WVKBD_REPO="https://github.com/jjsullivan5196/wvkbd.git"
BUILD_DIR="/tmp/wvkbd-build"

echo "==> Building wvkbd from source..."

# Clean previous build
rm -rf "$BUILD_DIR"

echo "==> Cloning wvkbd repository..."
git clone --depth 1 "$WVKBD_REPO" "$BUILD_DIR"

cd "$BUILD_DIR"

echo "==> Compiling wvkbd..."
make clean 2>/dev/null || true
make

echo "==> Installing wvkbd..."
if [ "$(id -u)" -eq 0 ]; then
    make install PREFIX=/usr
else
    sudo make install PREFIX=/usr
fi

echo ""
echo "==> wvkbd built and installed successfully."
echo "    Launch with Cyberdeck theme:"
echo "    wvkbd-mobintl -H 400 --bg 000000C0 --fg 00FF00 --fg-sp 008800 --press 004400 --text FFFFFF"

# Clean up
rm -rf "$BUILD_DIR"
