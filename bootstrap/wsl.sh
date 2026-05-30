#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
HOME_DIR="${HOME}"

if command -v sudo >/dev/null 2>&1; then
  sudo apt-get update
  sudo apt-get install -y fish git neovim tmux curl unzip
else
  apt-get update
  apt-get install -y fish git neovim tmux curl unzip
fi

mkdir -p "$HOME_DIR/.config" "$HOME_DIR/.local/bin"
rsync -a --delete "$REPO_DIR/home/.config/" "$HOME_DIR/.config/"
rsync -a "$REPO_DIR/home/.local/bin/" "$HOME_DIR/.local/bin/"

echo "WSL bootstrap complete."
