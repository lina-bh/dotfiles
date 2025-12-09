typeset -U path
fix_path() {
  path=(
    ~/bin
    ~/.cargo/bin
    /home/linuxbrew/.linuxbrew/opt/rustup/bin
    ~/.local/bin
    ~/.bun/bin
    $path
    ~/.local/share/flatpak/exports/bin
    /var/lib/flatpak/exports/bin
  )
}

fix_path

if (( $+commands[nvim] )); then
  EDITOR=nvim
else
  EDITOR=vi
fi
export EDITOR
export DOTNET_CLI_TELEMETRY_OPTOUT=1
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_EMOJI=1
export HOMEBREW_NO_ENV_HINTS=1
export NIX_SHELL_PRESERVE_PROMPT=1
export NIX_INSTALLER_DIAGNOSTIC_ENDPOINT=''
export NO_AT_BRIDGE=1
export DIRENV_WARN_TIMEOUT='1h'
# export SUDO_EDITOR=vi
