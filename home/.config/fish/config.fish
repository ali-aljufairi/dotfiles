# Fish-first shell bootstrap for nexos

# Local bin paths
fish_add_path -g $HOME/.local/bin
fish_add_path -g $HOME/.npm-global/bin
fish_add_path -g $HOME/.bun/bin

# Prefer system Python before Linuxbrew Python for tool/build compatibility on Arch
if test -d /usr/bin
    fish_add_path -g /usr/bin
end

# Homebrew on Linux/macOS
if test -x /home/linuxbrew/.linuxbrew/bin/brew
    eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv fish)
else if test -x /opt/homebrew/bin/brew
    eval (/opt/homebrew/bin/brew shellenv fish)
else if test -x /usr/local/bin/brew
    eval (/usr/local/bin/brew shellenv fish)
end

# mise runtime activation
if command -q mise
    mise activate fish | source
end

# nvm support (optional; activate only if bass is installed)
set -gx NVM_DIR $HOME/.config/nvm
if command -q bass; and test -s "$NVM_DIR/nvm.sh"
    bass source "$NVM_DIR/nvm.sh" ';' nvm use default '>/dev/null' '^/dev/null'
end

# Editors / defaults
set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx MANPAGER 'nvim +Man!'

# Common aliases carried over from older shell configs
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias v='nvim'
alias g='git'
alias lg='lazygit'
alias k='kubectl'
alias dc='docker compose'
alias cls='clear'
alias nvim-ali='env NVIM_APPNAME=nvim-ali nvim'

# Optional user-local env file for secrets
set local_env "$HOME/.config/fish/local.fish"
if test -f $local_env
    source $local_env
end
