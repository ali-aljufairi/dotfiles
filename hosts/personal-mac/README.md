# personal-mac

Mac-specific notes and overrides for the shared dotfiles repo.

## Recommended use

Keep portable config in `home/` first. Use this directory only for things that are genuinely macOS-host-specific, such as:

- `defaults write` notes
- app settings that only exist on macOS
- launch agents or scripts for this host
- host-specific bootstrap reminders

## Suggested next host-side exports

When on the Mac, consider capturing:

```bash
brew bundle dump --force --file packages/brew/Brewfile
```

And document any custom macOS defaults you care about here.
