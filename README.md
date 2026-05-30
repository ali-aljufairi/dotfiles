# nexos

Unified personal dotfiles and app config repo for Ali across Linux, macOS, WSL, and Windows.

## Scope

This repo consolidates:
- shell setup, now **Fish-first**
- Neovim config
- terminal/app configs
- bootstrap scripts
- package manifests

It intentionally does **not** include notes, journaling, or CV material.

## Layout

- `home/`: files intended to land in `$HOME`
- `bootstrap/`: OS bootstrap/install scripts
- `packages/`: exported package manifests
- `hosts/`: host-specific overrides
- `os/`: OS notes and future overrides
- `archive/`: imported legacy sources kept for reference during migration
- `docs/`: migration notes

## Current direction

- Primary shell: **Fish**
- Reverse history search: **Atuin on `Ctrl-R`**
- Preferred terminal: **Ghostty** (with Kitty/Alacritty configs still preserved)
- Neovim source of truth: `home/.config/nvim`
- Legacy/old upstream repos are preserved under `archive/` so nothing gets lost during cleanup.

## Quick start

### Linux

```bash
cd ~/nexos
./bootstrap/linux.sh
```

### macOS

```bash
cd ~/nexos
./bootstrap/macos.sh
```

### WSL

```bash
cd ~/nexos
./bootstrap/wsl.sh
```

### Windows

Run `bootstrap/windows.ps1` in PowerShell.

## Deployment model

For now this repo is plain-file based and can be deployed with `rsync` or symlinks.
A future refinement could move this to `chezmoi` once the merged structure settles down.
