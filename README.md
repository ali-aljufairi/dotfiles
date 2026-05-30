# nexos

Single personal **dotfiles git repo** for Ali across Linux, macOS, WSL, and Windows.

## Source of truth

This repo is now the **one place** meant to hold your maintained personal environment:
- shell setup, **Fish-first**
- Neovim config
- terminal/app configs
- bootstrap scripts
- package manifests
- host and OS overrides

Older scattered sources are preserved under `archive/` only as migration reference material. New changes should land in `nexos`, not in separate config repos.

It intentionally does **not** include notes, journaling, or CV material.

## Layout

- `home/`: files intended to land in `$HOME`
- `bootstrap/`: install and deployment helpers
- `packages/`: exported package manifests
- `hosts/`: host-specific overrides
- `os/`: OS notes and future overrides
- `archive/`: imported legacy sources kept for reference during migration
- `docs/`: migration notes and repo docs

## Current direction

- Primary shell: **Fish**
- Reverse history search: **Atuin on `Ctrl-R`**
- Preferred terminal: **Ghostty**
- Neovim source of truth: `home/.config/nvim`
- Legacy/old repos stay under `archive/` until intentionally pruned

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

## Day-to-day workflow

### Preview what would be synced into `$HOME`

```bash
cd ~/nexos
./bootstrap/sync-home.sh
```

### Apply the tracked dotfiles to `$HOME`

```bash
cd ~/nexos
./bootstrap/sync-home.sh --write
```

### Apply and delete files in `$HOME` that were removed from the repo

```bash
cd ~/nexos
./bootstrap/sync-home.sh --write --delete
```

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
- browser profiles/state
- chat/session caches
- large machine-local runtime state

## Deployment model

For now this repo is plain-file based and deploys with `rsync` via `bootstrap/sync-home.sh` and the OS bootstrap scripts.
A future refinement could move this to `chezmoi` once the merged structure settles down.
