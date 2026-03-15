#!/usr/bin/env bash
set -euo pipefail

# PinePhone A64 Terminal Desktop Environment - Package Installer
# Installs all required packages for the Sway-based mobile desktop

if [ "$(id -u)" -ne 0 ]; then
    echo "Error: This script must be run as root (or with sudo)."
    exit 1
fi

echo "==> Updating package lists..."
apt update

echo "==> Upgrading existing packages..."
apt upgrade -y

echo "==> Installing core desktop components..."
apt install -y \
    sway \
    foot \
    wvkbd \
    tmux \
    waybar \
    wlopm \
    brightnessctl

echo "==> Installing hardware drivers and performance tools..."
apt install -y \
    mesa-va-drivers \
    zram-tools

echo "==> Installing wvkbd build dependencies..."
apt install -y \
    git \
    build-essential \
    libwayland-dev \
    libxkbcommon-dev \
    wayland-protocols \
    pkg-config

echo "==> Installing utilities..."
apt install -y nnn

echo ""
echo "==> All packages installed successfully."
echo "    Run ./install.sh to deploy configurations."
