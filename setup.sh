#!/usr/bin/env bash
set -Eeuo pipefail

# Ali's WSL/Linux dotfiles bootstrap.
# Run after cloning the repo, or use the one-liner in README.md.

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NONINTERACTIVE="${NONINTERACTIVE:-1}"
BREW_PREFIX="${BREW_PREFIX:-/home/linuxbrew/.linuxbrew}"
BREW_BIN="$BREW_PREFIX/bin/brew"

log() { printf '\n\033[1;34m==> %s\033[0m\n' "$*"; }
warn() { printf '\n\033[1;33mWARN: %s\033[0m\n' "$*"; }
has() { command -v "$1" >/dev/null 2>&1; }

if [[ "${EUID}" -eq 0 ]]; then
  echo "Please run setup.sh as your normal user, not root. It will ask for sudo when needed."
  exit 1
fi

if ! has sudo; then
  echo "sudo is required. Install sudo or run from a user with sudo access."
  exit 1
fi

log "Detecting Linux distro"
if [[ -r /etc/os-release ]]; then
  # shellcheck disable=SC1091
  source /etc/os-release
else
  echo "Unsupported Linux distro: missing /etc/os-release"
  exit 1
fi

case "${ID_LIKE:-$ID}" in
  *debian*|*ubuntu*|debian|ubuntu)
    PKG_MANAGER="apt"
    ;;
  *)
    echo "This setup currently targets WSL on Ubuntu/Debian. Detected: ${PRETTY_NAME:-unknown}"
    exit 1
    ;;
esac

log "Installing base Ubuntu/WSL packages"
sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y \
  build-essential procps file git curl wget ca-certificates gnupg lsb-release \
  unzip zip p7zip-full unar tar gzip xz-utils zstd \
  software-properties-common apt-transport-https \
  jq ripgrep fd-find fzf bat tree tmux htop btop \
  gcc g++ make cmake pkg-config clang lld \
  python3 python3-pip python3-venv pipx \
  ruby-full \
  fish zsh \
  neovim stow sshpass telnet iperf3 \
  docker.io docker-compose-plugin \
  shellcheck

# Ubuntu names bat/fd as batcat/fdfind. Add local aliases if needed.
mkdir -p "$HOME/.local/bin"
if has batcat && ! has bat; then ln -sf "$(command -v batcat)" "$HOME/.local/bin/bat"; fi
if has fdfind && ! has fd; then ln -sf "$(command -v fdfind)" "$HOME/.local/bin/fd"; fi

log "Installing Homebrew for Linux if missing"
if [[ ! -x "$BREW_BIN" ]]; then
  NONINTERACTIVE="$NONINTERACTIVE" /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
# shellcheck disable=SC1090
if [[ -r "$BREW_PREFIX/bin/brew" ]]; then
  eval "$("$BREW_BIN" shellenv)"
else
  warn "Homebrew was not found at $BREW_PREFIX; skipping brew packages."
fi

if has brew; then
  log "Installing curated Homebrew CLI tools"
  brew update
  brew bundle --file=- <<'BREWFILE'
brew "awscli"
brew "bat"
brew "bitwarden-cli"
brew "btop"
brew "cargo-binstall"
brew "cargo-lambda"
brew "croc"
brew "deno"
brew "docker-completion"
brew "eza"
brew "fd"
brew "ffmpeg"
brew "fzf"
brew "gh"
brew "git"
brew "go"
brew "hstr"
brew "imagemagick"
brew "jq"
brew "k9s"
brew "kubernetes-cli"
brew "lazydocker"
brew "lazygit"
brew "lsd"
brew "mpv"
brew "neovim"
brew "node"
brew "nvm"
brew "nushell"
brew "opencode"
brew "pandoc"
brew "poppler"
brew "pipx"
brew "pnpm"
brew "python@3.13"
brew "qemu"
brew "ruff"
brew "sevenzip"
brew "starship"
brew "stow"
brew "terraform"
brew "tesseract"
brew "tmux"
brew "tree-sitter"
brew "uv"
brew "vite"
brew "yazi"
brew "yt-dlp"
brew "zoxide"
brew "zig"
BREWFILE
fi

log "Installing global developer CLIs"
export PIPX_HOME="${PIPX_HOME:-$HOME/.local/pipx}"
export PIPX_BIN_DIR="${PIPX_BIN_DIR:-$HOME/.local/bin}"
python3 -m pipx ensurepath || true

if has npm; then
  npm install -g @google/gemini-cli || warn "Could not install gemini-cli with npm"
fi

log "Installing Rust toolchain"
if ! has rustup; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
fi
# shellcheck disable=SC1091
[[ -r "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"
if has cargo; then
  cargo install starship zoxide --locked || true
fi

log "Creating fish shell configuration"
mkdir -p "$HOME/.config/fish/conf.d"
cat > "$HOME/.config/fish/config.fish" <<'FISH'
# Ali's WSL shell defaults
set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx PATH $HOME/.local/bin $HOME/.cargo/bin /home/linuxbrew/.linuxbrew/bin /home/linuxbrew/.linuxbrew/sbin $PATH

if status is-interactive
    fish_vi_key_bindings
    command -q starship; and starship init fish | source
    command -q zoxide; and zoxide init fish | source
    command -q fzf; and fzf --fish | source 2>/dev/null
end

alias ll='eza -la --icons=auto --git 2>/dev/null; or ls -la'
alias la='eza -a --icons=auto 2>/dev/null; or ls -a'
alias lt='eza --tree --level=2 --icons=auto 2>/dev/null; or tree -L 2'
alias cat='bat 2>/dev/null; or command cat'
alias vim='nvim'
alias k='kubectl'
FISH

log "Linking dotfiles where available"
if [[ -f "$DOTFILES_DIR/config/.p10k.zsh" ]]; then
  ln -sf "$DOTFILES_DIR/config/.p10k.zsh" "$HOME/.p10k.zsh"
fi
if [[ -f "$DOTFILES_DIR/ideavimrc" ]]; then
  ln -sf "$DOTFILES_DIR/ideavimrc" "$HOME/.ideavimrc"
fi

log "Setting fish as the default shell"
FISH_PATH="$(command -v fish || true)"
if [[ -n "$FISH_PATH" ]]; then
  if ! grep -qxF "$FISH_PATH" /etc/shells; then
    echo "$FISH_PATH" | sudo tee -a /etc/shells >/dev/null
  fi
  if [[ "$SHELL" != "$FISH_PATH" ]]; then
    chsh -s "$FISH_PATH" "$USER" || warn "Could not change shell automatically. Run: chsh -s $FISH_PATH"
  fi
fi

log "Optional: enable Docker for current user"
if getent group docker >/dev/null; then
  sudo usermod -aG docker "$USER" || true
  warn "Log out/in or restart WSL for Docker group and fish shell changes to apply."
fi

log "Done"
printf 'Installed WSL essentials, fish, nushell, yazi, opencode, AWS/K8s/dev CLIs, and linked available dotfiles.\n'
