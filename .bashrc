PATH="\
$HOME/bin:\
$HOME/.cargo/bin:\
$HOME/.local/bin:\
$HOME/.bun/bin:\
$HOME/.local/state/nix/profiles/profile/bin:\
/nix/var/nix/profiles/default/bin:\
/home/linuxbrew/.linuxbrew/bin:\
/home/linuxbrew/.linuxbrew/sbin:\
$PATH:\
/usr/local/sbin:/usr/sbin:/sbin:\
$HOME/.local/share/flatpak/exports/bin:\
/var/lib/flatpak/exports/bin"
export XDG_DATA_DIRS="$HOME/.local/state/nix/profiles/profile/share:$XDG_DATA_DIRS:/home/linuxbrew/.linuxbrew/share"
export EDITOR=nvim
export SUDO_EDITOR=vi
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_ENV_HINTS=1
export HOMEBREW_NO_EMOJI=1
export NIX_SHELL_PRESERVE_PROMPT=1
export NO_AT_BRIDGE=1
export DOTNET_CLI_TELEMETRY_OPTOUT=1

cleanup_PATH() {
  PATH="$(awk -v RS=: -v ORS= '!a[$0]++ { if (NR>1) print ":"; print $0 }' <<< "$PATH")"
  export PATH
}
trap cleanup_PATH RETURN

command -v fnm >/dev/null && eval "$(fnm env --shell bash)"

[[ $- == *i* ]] || return

HISTCONTROL=ignoreboth:erasedups
HISTFILESIZE=100000
HISTSIZE=10000

shopt -s histappend
shopt -s checkwinsize
shopt -s extglob
shopt -s globstar
shopt -s checkjobs
shopt -s no_empty_cmd_completion
shopt -s direxpand
set -o noclobber

export QUOTING_STYLE=literal
unset MAILCHECK

alias juserctl='journalctl --user'
alias ls='command ls -FHh --color=auto'
alias rsync='command rsync --archive --xattrs --acls --hard-links --copy-unsafe-links --sparse --progress --partial --human-readable --stats'
alias userctl='systemctl --user'
alias vim=nvim
alias mpv='flatpak run io.mpv.Mpv'
alias fly=flyctl
alias nmap='podman run --rm --interactive --tty --cap-add=CAP_NET_RAW nmap'
alias journalctl='command journalctl -e'
alias bjournalctl='command journalctl -e -b0'
alias devcontainer='command devcontainer --workspace-folder=. --docker-path=podman'

precmd() {
    local exit=$?
    ps1_status=
    [[ $exit -ne 0 ]] && ps1_status="$exit "
}
PROMPT_COMMAND="precmd; ${PROMPT_COMMAND}"

ps1_host='\h'
[[ -n $CONTAINER_ID ]] && ps1_host="$CONTAINER_ID"
[[ $TERM != dumb ]] && PS1='\[\e]0;\u@'"$ps1_host"':\w\a\]'
[[ -n $SSH_CLIENT || -n $container && $container != 'flatpak' ]] && PS1="$PS1"'\u@'"$ps1_host"' '
PS1="$PS1"'$([[ -n "$(jobs -p)" ]] && echo -n "%\j ")$ps1_status\w \$ '

command -v direnv >/dev/null && eval "$(direnv hook bash)"
