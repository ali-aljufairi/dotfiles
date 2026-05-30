# personal-wsl

WSL-specific notes and overrides for the shared dotfiles repo.

## Recommended use

Keep portable config in `home/` first. Use this directory for WSL-only concerns, such as:

- Windows/WSL path interop notes
- clipboard helpers
- browser/GUI launch shims
- mount or networking quirks
- host-specific bootstrap reminders

## Suggested next host-side exports

When on the WSL machine, run:

```bash
./bootstrap/wsl.sh
```

Then document any local quirks or helper scripts here instead of mixing them into shared config unnecessarily.
