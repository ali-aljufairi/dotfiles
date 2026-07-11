# dotfiles

Single personal **dotfiles** repo for Ali across Linux, macOS, WSL, and Windows.

## Source of truth

This repo is the one maintained place for personal environment setup:
- shell setup, **Fish-first**
- Neovim config
- terminal/app configs
- bootstrap scripts
- package manifests
- host and OS overrides

Older scattered sources are preserved under `archive/` only as migration reference material. New config changes should land in this dotfiles repo, not in separate config repos.

It intentionally does **not** include notes, journaling, or CV material.

## Layout

- `home/`: files intended to land in `$HOME`
- `bootstrap/`: install and deployment helpers
- `packages/`: exported package manifests
- `hosts/`: host-specific overrides and notes
- `os/`: OS notes and future overrides
- `archive/`: imported legacy sources kept for reference during migration
- `docs/`: migration notes and repo docs
- `tailscale/`: tailnet policy source, applied through GitHub Actions GitOps

## Current direction

- Primary shell: **Fish**
- Reverse history search: **Atuin on `Ctrl-R`**
- Preferred terminal: **Ghostty**
- Neovim source of truth: `home/.config/nvim`
- Legacy/old repos stay under `archive/` until intentionally pruned

## Quick start

### Linux

```bash
cd ~/dotfiles
./bootstrap/linux.sh
```

### macOS

```bash
cd ~/dotfiles
./bootstrap/macos.sh
```

### WSL

```bash
cd ~/dotfiles
./bootstrap/wsl.sh
```

### Windows

Run `bootstrap/windows.ps1` in PowerShell.

## Day-to-day workflow

### Preview what would be synced into `$HOME`

```bash
cd ~/dotfiles
./bootstrap/sync-home.sh
```

### Apply the tracked dotfiles to `$HOME`

```bash
cd ~/dotfiles
./bootstrap/sync-home.sh --write
```

### Apply and delete files in `$HOME` that were removed from the repo

```bash
cd ~/dotfiles
./bootstrap/sync-home.sh --write --delete
```

## Host-specific use

- Put machine-specific notes or one-off overrides under `hosts/`.
- Keep portable shared config under `home/` whenever possible.
- Use `hosts/personal-mac`, `hosts/personal-wsl`, etc. to document anything that should only be applied on that host.

## What belongs here

Good fits:
- editor configs
- shell configs
- terminal configs
- bootstrap/install scripts
- package manifests
- portable host overrides

Should stay out:
- secrets and tokens
- Tailscale API keys, OAuth credentials, and auth keys (use GitHub Actions secrets)
- browser profiles/state
- chat/session caches
- large machine-local runtime state

## Deployment model

For now this repo is plain-file based and deploys with `bootstrap/sync-home.sh` plus the OS bootstrap scripts.
A future refinement could move this to `chezmoi` or a Nix/Home Manager setup once the merged structure settles down.
