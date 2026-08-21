#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if command -v sudo >/dev/null 2>&1; then
  sudo apt-get update
  sudo apt-get install -y software-properties-common fish atuin git neovim tmux curl unzip rsync
  if apt-cache show ghostty >/dev/null 2>&1; then
    sudo apt-get install -y ghostty
  else
    sudo add-apt-repository -y ppa:mkasberg/ghostty-ubuntu || true
    sudo apt-get update
    sudo apt-get install -y ghostty || true
  fi
else
  apt-get update
  apt-get install -y software-properties-common fish atuin git neovim tmux curl unzip rsync
  if apt-cache show ghostty >/dev/null 2>&1; then
    apt-get install -y ghostty
  fi
fi

"$REPO_DIR/bootstrap/sync-home.sh" --write

# Bootstrap nvim plugins (lazy.nvim) so first launch is ready to use
if command -v nvim >/dev/null 2>&1; then
  nvim --headless "+Lazy! restore" +qa >/dev/null 2>&1 || echo "WARN: lazy restore had warnings; run :Lazy inside nvim to inspect"
fi

if command -v fish >/dev/null 2>&1; then
  chsh -s "$(command -v fish)" "$USER" || true
fi

echo "WSL bootstrap complete."
