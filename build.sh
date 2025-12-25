#!/usr/bin/env bash
set -e

echo "=== GBA build setup for Ubuntu ==="

# 1) System deps
echo "[1/5] Installing system dependencies..."
sudo apt update
sudo apt install -y build-essential git curl ca-certificates xz-utils

# 2) Install devkitPro using official installer
if [ ! -d "/opt/devkitpro" ]; then
  echo "[2/5] Installing devkitPro..."
  curl -L https://apt.devkitpro.org/install-devkitpro-pacman | sudo bash
else
  echo "[2/5] devkitPro already installed"
fi

# 3) Install GBA toolchain + libgba
echo "[3/5] Installing devkitARM and libgba..."
sudo dkp-pacman -S --needed --noconfirm gba-dev

# 4) Export environment variables (session + persistent)
echo "[4/5] Setting environment variables..."
export DEVKITPRO=/opt/devkitpro
export DEVKITARM=/opt/devkitpro/devkitARM

if ! grep -q DEVKITPRO ~/.bashrc; then
  echo 'export DEVKITPRO=/opt/devkitpro' >> ~/.bashrc
  echo 'export DEVKITARM=/opt/devkitpro/devkitARM' >> ~/.bashrc
fi

echo "DEVKITPRO=$DEVKITPRO"
echo "DEVKITARM=$DEVKITARM"

# 5) Build project
echo "[5/5] Building GBA ROM..."
make clean || true
make

echo
echo "=== DONE ==="
echo "Output ROM:"
ls -lh *.gba
echo
echo "Run it with: mgba minicraft_3D_by_GameOfTobi.gba"
