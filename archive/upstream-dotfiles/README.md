# dotfiles

WSL/Linux bootstrap for Ali's development environment.

## One-line install

```bash
sudo apt-get update && sudo apt-get install -y git && git clone https://github.com/ali-aljufairi/dotfiles ~/dotfiles && cd ~/dotfiles && ./setup.sh
```

For a fresh WSL Ubuntu/Debian distro, this installs a curated Linux version of the Mac Homebrew setup, including:

- Shells: `fish` as default shell, `nushell`, `zsh`
- Terminal UX: `starship`, `zoxide`, `fzf`, `bat`, `eza`, `lsd`, `ripgrep`, `fd`, `tmux`, `btop`, `yazi`
- Dev tools: `git`, `gh`, `neovim`, `stow`, `jq`, `python`, `pipx`, `node`, `pnpm`, `deno`, `go`, `rust`, `uv`, `ruff`, `zig`
- Cloud/DevOps: `awscli`, `kubectl`, `k9s`, `terraform`, `docker`, `docker compose`, `cargo-lambda`, `lazygit`, `lazydocker`
- AI/agent tools: `opencode`, `gemini-cli`
- Media/docs utilities: `ffmpeg`, `imagemagick`, `poppler`, `tesseract`, `mpv`, `pandoc`, `yt-dlp`, archive tools

macOS-only apps/casks from the old Brew list are intentionally skipped because this setup targets WSL.

## After setup

Restart WSL or log out/in so these changes apply:

```powershell
wsl --shutdown
```

Then reopen the distro. Your default shell should be `fish`.


## Homebrew install behavior

The setup script installs Homebrew packages one-by-one instead of using `brew bundle`. This is intentional: if one formula is renamed, removed, or temporarily unavailable, the bootstrap continues and prints a list of failed packages near the end.

Terraform is installed from HashiCorp's official tap because it is no longer available as a plain Homebrew core formula:

```bash
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
```

## Docker Compose troubleshooting

Docker Compose v2 should be available as:

```bash
docker compose version
```

If setup or manual installation fails with:

```bash
E: Unable to locate package docker-compose-plugin
```

it usually means Docker's official APT repository is not enabled yet. Enable it, then install Docker Engine and the Compose plugin.

### Ubuntu

```bash
sudo apt update
sudo apt install ca-certificates curl

sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF

sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

### Debian

Use the same commands, but change the repository URI to Debian:

```bash
URIs: https://download.docker.com/linux/debian
```

Then verify:

```bash
docker compose version
```

Use `docker compose` with a space, not the older `docker-compose` command.

## Cargo Lambda troubleshooting

`cargo-lambda` is installed from its official Homebrew tap:

```bash
brew tap cargo-lambda/tap
brew install cargo-lambda/tap/cargo-lambda
```

It is intentionally not listed as `brew "cargo-lambda"` in the inline Brewfile because it is not available in Homebrew core and will fail with:

```bash
Error: No available formula with the name "cargo-lambda"
```

If the tap install fails, install it after Rust is available with:

```bash
cargo binstall cargo-lambda --no-confirm
```
