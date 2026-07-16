# shellcheck shell=bash disable=SC2034,SC1091
# TODO: switch this around if i ever get another mac
if [[ "$OSTYPE" = linux* ]]; then
  HOMEBREW_PREFIX="/home/linuxbrew/.linuxbrew"
else
  HOMEBREW_PREFIX="/opt/homebrew"
fi
export HOMEBREW_PREFIX
export HOMEBREW_CELLAR="${HOMEBREW_PREFIX}/Cellar"
export HOMEBREW_REPOSITORY="${HOMEBREW_PREFIX}/Homebrew"
export PNPM_HOME="${HOME}/.local/share/pnpm"
PATH="\
$HOME/bin:\
$HOME/.cabal/bin:\
$HOME/.ghcup/bin:\
$HOME/.cargo/bin:\
${HOMEBREW_PREFIX}/opt/rustup/bin:\
$HOME/.local/bin:\
$PNPM_HOME/bin:\
$HOME/.bun/bin:\
$HOME/.local/state/nix/profiles/profile/bin:\
/nix/var/nix/profiles/default/bin:\
$PATH:\
/usr/local/sbin:/usr/sbin:/sbin:\
${HOMEBREW_PREFIX}/bin:\
${HOMEBREW_PREFIX}/sbin:\
$HOME/.local/share/flatpak/exports/bin:\
/var/lib/flatpak/exports/bin:\
${HOME}/go/bin:\
${HOME}/flutter/bin"
export MANPATH="${HOMEBREW_PREFIX}/share/man:${MANPATH#:}"
export INFOPATH="${HOMEBREW_PREFIX}/share/info:${INFOPATH:-}"
if [ -z "$GEM_HOME" ] && command -v gem >/dev/null; then
  GEM_HOME="$(ruby -e 'puts Gem.user_dir')"
  export GEM_HOME
fi
[ ! -z "$GEM_HOME" ] && PATH="${PATH}:${GEM_HOME}/bin"
export XDG_DATA_DIRS="${HOMEBREW_PREFIX}/share:${XDG_DATA_DIRS:-/usr/local/share:/usr/share}"
texlive="$(files=(/usr/local/texlive/????/); printf '%s' "${files[-1]}")"
if [[ -d "$texlive" ]]; then
  PATH="${PATH}:${texlive}bin/${MACHTYPE}-${OSTYPE%%[-0-9]*}"
  export MANPATH="${texlive}texmf-dist/doc/man:${MANPATH#:}"
  export INFOPATH="${texlive}texmf-dist/doc/info:${INFOPATH}"
fi

cleanup_PATH() {
  # shellcheck disable=SC2016
  dedup() {
    awk -v RS=: -v ORS= '!a[$0]++ { if (NR>1) print ":"; print $0 }'
  }
  for env in PATH XDG_DATA_DIRS MANPATH INFOPATH; do
    eval "$env="'$(dedup <<< $'"$env"'); export '"$env"
  done
}
[[ -z "$BASH_VERSION" ]] || cleanup_PATH

if [[ -z "$EDITOR" ]]; then
  if command -v nvim >/dev/null; then
    export EDITOR=nvim
  else
    export EDITOR=vi
  fi
  export ALTERNATE_EDITOR="$EDITOR"
  if command -v emacsclient >/dev/null; then
    export EDITOR=emacsclient
  fi
fi

export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_ENV_HINTS=1
export HOMEBREW_NO_ASK=1
export NIX_SHELL_PRESERVE_PROMPT=1
export NIX_INSTALLER_DIAGNOSTIC_ENDPOINT=
export DOTNET_CLI_TELEMETRY_OPTOUT=1
export DIRENV_WARN_TIMEOUT='1h'
SSH_AUTH_SOCK="${HOME}/.var/app/com.bitwarden.desktop/data/.bitwarden-ssh-agent.sock"
if [ -f "$SSH_AUTH_SOCK" ]; then
  export SSH_AUTH_SOCK
else
  unset SSH_AUTH_SOCK
fi

# export ANTHROPIC_AUTH_TOKEN=dummy
# export ANTHROPIC_BASE_URL='http://127.0.0.1:11434/'
export GEMINI_SANDBOX=podman
export GEMINI_TELEMETRY_ENABLED=false
export OPENAI_API_KEY=dummy
export OPENAI_HOST='http://127.0.0.1:11434'
export SANDBOX_FLAGS="--security-opt=label=disable --log-driver=none --userns=keep-id"

export BAT_STYLE=changes

[[ $- == *i* ]] || return

HISTCONTROL=ignoreboth:erasedups
HISTFILESIZE=100000
HISTSIZE=10000
HISTFILE="${HOME}/.bash_history"

export QUOTING_STYLE=literal
unset MAILCHECK

steamapps="${HOME}/.local/share/Steam/steamapps"
tf_cfg="${steamapps}/common/Team Fortress 2/tf/cfg/"
csgo_cfg="${steamapps}/common/Counter-Strike Global Offensive/game/csgo/cfg/"
renderD128="/sys/class/drm/renderD128/device"

alias devcontainer='command devcontainer --docker-path=podman'
alias fly=flyctl
alias juserctl='journalctl --user'
alias k='kubectl'
alias kapply='kubectl apply'
alias kdel='kubectl delete'
alias kdes='kubectl describe'
alias kdiff='kubectl diff'
alias kex='kubectl explain'
alias kg='kubectl get -o=yaml'
alias kk='kubectl apply -k'
alias klog='kubectl logs'
alias ls='command ls -FHh --color=auto'
alias podlet='podman run --rm --security-opt=no-new-privileges --read-only --read-only-tmpfs=false --cgroups=disabled --userns=nomap --ipc=none --network=none --pull=newer ghcr.io/containers/podlet'
alias rsync='command rsync --archive --xattrs --acls --hard-links --copy-unsafe-links --sparse --progress --partial --human-readable --stats --size-only'
alias ts='tailscale status'
alias userctl='systemctl --user'
alias zstd='command zstd -T0 --adapt --exclude-compressed'
alias la='ls -laZ'
alias sl='ls'
alias taildrop='tailscale file get --conflict=rename --verbose "${HOME}/Downloads"'
command -v nvim >/dev/null && alias vim=nvim
command -v mpv >/dev/null || mpv() {
  flatpak run io.mpv.Mpv "$@"
  return $?
}

. "${HOMEBREW_REPOSITORY}/Library/Homebrew/command-not-found/handler.sh" 2>/dev/null
. "/etc/profile.d/bazzite-neofetch.sh" 2>/dev/null

[[ -z $BASH_VERSION ]] && return

shopt -s histappend
shopt -s checkwinsize
shopt -s extglob
shopt -s globstar
shopt -s checkjobs
shopt -s no_empty_cmd_completion
shopt -s direxpand
shopt -s cdable_vars
set -o noclobber

precmd() {
    local exit=$?
    ps1_status=
    [[ $exit -ne 0 ]] && ps1_status="$exit "
}
PROMPT_COMMAND="precmd; ${PROMPT_COMMAND}"

prompt_() {
  local host title hoststring
  host="$([[ -n $CONTAINER_ID ]] && echo -n "$CONTAINER_ID" || echo -n '\h')"
  title="$([[ $TERM != dumb ]] && printf '\[\e]0;\\u@%s:\w\a\]' "$host")"
  hoststring="$([[ -n $SSH_CLIENT || -n $container && $container != flatpak ]] && printf '\\u@%s ' "$host")"
  # shellcheck disable=SC2016
  printf '%s%s$ps1_status\w \$ ' "$title" "$hoststring"
}
PS1="$(prompt_)"

if [[ -r /usr/share/bash-completion/bash_completion ]]; then
  . /usr/share/bash-completion/bash_completion

  _completion_loader systemctl
  _userctl() {
    COMP_WORDS=(systemctl --user "${COMP_WORDS[@]:1}")
    (( COMP_CWORD += 1 ))
    _systemctl
  }
  complete -F _userctl userctl

  _completion_loader journalctl
  _juserctl() {
    COMP_WORDS=(journalctl --user "${COMP_WORDS[@]:1}")
    (( COMP_CWORD += 1 ))
    _journalctl
  }
  complete -F _juserctl juserctl
fi

command -v tailscale >/dev/null && eval "$(tailscale completion bash)"
command -v direnv >/dev/null && eval "$(direnv hook bash)"

[[ -f /usr/share/doc/pkgfile/command-not-found.bash ]] && \
  . /usr/share/doc/pkgfile/command-not-found.bash 2>&1

true
