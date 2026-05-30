# Migration notes

## Chosen source of truth

- Active Neovim config: `home/.config/nvim`
- Fish is now the preferred interactive shell
- Existing upstream repos are preserved under `archive/`

## Legacy sources preserved

- `archive/upstream-dotfiles`
- `archive/upstream-dotfiles-hidden`
- `archive/upstream-nvim`
- `archive/local-nvim-ali`

## Follow-up cleanup ideas

- prune `archive/` once all useful pieces are merged into `home/`
- decide whether to keep both Alacritty and Kitty or standardize on one
- export Windows `winget` packages from a Windows machine
- export macOS-specific defaults from the Mac host
- optionally migrate deployment to `chezmoi`
