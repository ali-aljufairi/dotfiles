#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

install_pkg() {
  if command -v sudo >/dev/null 2>&1; then
    sudo pacman -S --needed --noconfirm "$@"
  else
    pacman -S --needed --noconfirm "$@"
  fi
}

install_pkg fish atuin ghostty git neovim kitty alacritty tmux lazygit btop rsync
"$REPO_DIR/bootstrap/sync-home.sh" --write

if command -v fish >/dev/null 2>&1; then
  FISH_PATH="$(command -v fish)"
  if [ -w /etc/shells ] || command -v sudo >/dev/null 2>&1; then
    grep -qx "$FISH_PATH" /etc/shells || echo "$FISH_PATH" | sudo tee -a /etc/shells >/dev/null
    chsh -s "$FISH_PATH" "$USER" || true
  fi
  echo "Fish installed. Default shell target: $FISH_PATH"
fi

echo "Linux bootstrap complete."
