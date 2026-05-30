# Migration notes

## Chosen source of truth

- Shared config authority: this `dotfiles` repo
- Active Neovim config: `home/.config/nvim`
- Preferred interactive shell: Fish
- Preferred terminal direction: Ghostty
- Existing upstream repos are preserved under `archive/`

## Legacy sources preserved

These are intentionally legacy-only and should not receive new edits unless something still needs to be copied out:

- `archive/upstream-dotfiles`
- `archive/upstream-dotfiles-hidden`
- `archive/upstream-nvim`
- `archive/local-nvim-ali`

## What was migrated into the active tree

- Fish config
- Ghostty config
- Atuin config
- active Neovim config
- shared terminal/editor utilities under `home/`
- bootstrap scripts for Linux, macOS, WSL, and Windows
- package manifests under `packages/`

## Live-machine application

- Shared repo files are applied with `bootstrap/sync-home.sh`
- Top-level files like `~/.bashrc` and `~/.gitconfig` should be backed up before replacement
- Machine-local secrets should stay outside the repo

## Follow-up host tasks

- On macOS, run `./bootstrap/macos.sh`, then export any host-only defaults or app prefs you want documented under `hosts/personal-mac/`
- On WSL, run `./bootstrap/wsl.sh`, then document any interop/path quirks under `hosts/personal-wsl/`
- On Windows, run `bootstrap/windows.ps1`, then export `winget` packages from that machine

## Future cleanup ideas

- prune `archive/` once all useful pieces are merged into `home/`
- decide whether to keep both Alacritty and Kitty or standardize further around Ghostty
- export Windows `winget` packages from a Windows machine
- export macOS-specific defaults from the Mac host
- optionally migrate deployment to `chezmoi` or a Nix/Home Manager setup later
