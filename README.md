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
- Cloud/DevOps: `awscli`, `kubectl`, `k9s`, `terraform`, `docker`, `docker compose`, `lazygit`, `lazydocker`
- AI/agent tools: `opencode`, `gemini-cli`
- Media/docs utilities: `ffmpeg`, `imagemagick`, `poppler`, `tesseract`, `mpv`, `pandoc`, `yt-dlp`, archive tools

macOS-only apps/casks from the old Brew list are intentionally skipped because this setup targets WSL.

## After setup

Restart WSL or log out/in so these changes apply:

```powershell
wsl --shutdown
```

Then reopen the distro. Your default shell should be `fish`.
