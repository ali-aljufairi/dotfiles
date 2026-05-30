#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if command -v brew >/dev/null 2>&1; then
  brew install fish atuin neovim kitty alacritty tmux lazygit btop mise rsync || true
  brew install --cask ghostty || true
  if [ -f "$REPO_DIR/packages/brew/Brewfile" ]; then
    brew bundle --file "$REPO_DIR/packages/brew/Brewfile" || true
  fi
  if command -v fish >/dev/null 2>&1; then
    FISH_PATH="$(command -v fish)"
    grep -qx "$FISH_PATH" /etc/shells 2>/dev/null || true
    chsh -s "$FISH_PATH" "$USER" || true
  fi
else
  echo "Homebrew not installed; install it first: https://brew.sh"
fi

"$REPO_DIR/bootstrap/sync-home.sh" --write

echo "macOS bootstrap complete."
