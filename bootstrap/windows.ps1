$ErrorActionPreference = 'Stop'

$RepoRoot = Split-Path -Parent $PSScriptRoot
$HomeDir = $HOME

winget install --id Git.Git -e --accept-package-agreements --accept-source-agreements
winget install --id Neovim.Neovim -e --accept-package-agreements --accept-source-agreements
winget install --id Microsoft.PowerShell -e --accept-package-agreements --accept-source-agreements
winget install --id ajeetdsouza.zoxide -e --accept-package-agreements --accept-source-agreements
winget install --id JanDeDobbeleer.OhMyPosh -e --accept-package-agreements --accept-source-agreements

Write-Host 'Copy the repo files you want into your Windows profile as needed.'
Write-Host 'Recommended next step: winget export -o packages/winget/packages.json --include-versions'
