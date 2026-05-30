# Fallback bash rc for systems where fish is not the login shell yet.

export PATH="$HOME/.local/bin:$HOME/.npm-global/bin:$HOME/.bun/bin:$PATH"
export EDITOR=nvim
export VISUAL=nvim

if command -v fish >/dev/null 2>&1 && [ -z "${BASH_EXECUTION_STRING:-}" ] && [ "$SHELL" != "$(command -v fish)" ]; then
  exec fish
fi
