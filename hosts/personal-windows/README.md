# personal-windows

Windows-specific notes and overrides for the shared dotfiles repo.

## Recommended use

Use this directory for Windows-only items, such as:

- PowerShell profile notes
- Windows Terminal settings notes
- Scoop/winget reminders
- host-only scripts

## Suggested next host-side export

From the Windows machine:

```powershell
winget export -o packages/winget/packages.json --include-versions
```
