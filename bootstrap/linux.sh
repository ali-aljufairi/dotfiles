#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
HOME_DIR="${HOME}"

install_pkg() {
  if command -v sudo >/dev/null 2>&1; then
    sudo pacman -S --needed --noconfirm "$@"
  else
    pacman -S --needed --noconfirm "$@"
  fi
}

install_pkg fish git neovim kitty alacritty tmux lazygit btop

mkdir -p "$HOME_DIR/.config" "$HOME_DIR/.local/bin"
rsync -a --delete "$REPO_DIR/home/.config/" "$HOME_DIR/.config/"
rsync -a "$REPO_DIR/home/.local/bin/" "$HOME_DIR/.local/bin/"

if command -v fish >/dev/null 2>&1; then
  grep -qx "$(command -v fish)" /etc/shells || echo "Add $(command -v fish) to /etc/shells manually if needed."
  echo "Fish installed. Set it as default with: chsh -s $(command -v fish)"
fi

echo "Linux bootstrap complete."
