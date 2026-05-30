#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
HOME_DIR="${HOME}"

if command -v brew >/dev/null 2>&1; then
  brew install fish neovim kitty alacritty tmux lazygit btop mise || true
  if [ -f "$REPO_DIR/packages/brew/Brewfile" ]; then
    brew bundle --file "$REPO_DIR/packages/brew/Brewfile" || true
  fi
else
  echo "Homebrew not installed; install it first: https://brew.sh"
fi

mkdir -p "$HOME_DIR/.config" "$HOME_DIR/.local/bin"
rsync -a --delete "$REPO_DIR/home/.config/" "$HOME_DIR/.config/"
rsync -a "$REPO_DIR/home/.local/bin/" "$HOME_DIR/.local/bin/"

echo "macOS bootstrap complete."
