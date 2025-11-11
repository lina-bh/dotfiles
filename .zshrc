fix_path
setopt hist_ignore_dups
setopt hist_ignore_space
setopt append_history
setopt no_bg_nice
setopt no_clobber
setopt interactive_comments
setopt no_auto_menu
setopt auto_continue
setopt no_hup
setopt auto_pushd
setopt promptsubst
setopt cdablevars
setopt no_auto_remove_slash
setopt no_nomatch
HISTSIZE=100000
SAVEHIST=$HISTSIZE
REPORTTIME=4
HISTFILE="${HOME}/.bash_history"
WORDCHARS="${WORDCHARS//.}"
WORDCHARS="${WORDCHARS//\/}"
export QUOTING_STYLE=literal
alias ls='ls -FHh --color'
alias userctl='systemctl --user'
alias juserctl='command journalctl --user'
alias journalctl='command journalctl -e'
alias k='kubectl'
alias kdel='kubectl delete'
alias kex='kubectl explain'
alias kg='kubectl get -o=yaml'
alias kdes='kubectl describe'
alias klog='kubectl logs'
alias rsync='command rsync --archive --xattrs --acls --hard-links --copy-unsafe-links --sparse --progress --partial --human-readable --stats --size-only'
alias vim=nvim
#alias mpv='flatpak run io.mpv.Mpv'
#alias nmap='podman run --rm --interactive --tty --cap-add=CAP_NET_RAW localhost/nmap'
alias zstd='command zstd -T0 --adapt --exclude-compressed'
alias devcontainer='command devcontainer --docker-path=podman'
alias ujust='just --justfile /usr/share/ublue-os/justfile'
alias kustomize='kubectl kustomize'
#alias vi='nvi'
alias kk='kubectl apply -k'
alias ts='tailscale status'
alias kapply='kubectl apply'
alias kdiff='kubectl diff'

kn() {
  1="${1:-default}"
  kubectl config set-context --current --namespace="$1" >/dev/null || return $?
  echo "$1"
}

steamapps="${HOME}/.local/share/Steam/steamapps/"
tf="${steamapps}/common/Team Fortress 2/tf"

vterm_printf() {
  if [ -n "$TMUX" ] && ([ "${TERM%%-*}" = "tmux" ] || [ "${TERM%%-*}" = "screen" ]); then
    # Tell tmux to pass the escape sequences through
    printf "\ePtmux;\e\e]%s\007\e\\" "$1"
  elif [ "${TERM%%-*}" = "screen" ]; then
    # GNU screen (screen, screen-256color, screen-256color-bce)
    printf "\eP\e]%s\007\e\\" "$1"
  else
    printf "\e]%s\e\\" "$1"
  fi
}
PROMPT="$( (( ${+SSH_CLIENT} || ${+CONTAINER_ID} )) && echo '%n@%m:')%~ %F{green}%#%f %{$(vterm_printf "51;A${USER}@${HOST}:${PWD}")%}"
RPROMPT='%F{red}%(?..%? )%f%(1j.%j%% .)'

window_title() {
  builtin echo -ne "\033]0;$PWD\007"
}
autoload -Uz add-zsh-hook
[[ "$TERM" =~ "xterm" || "$TERM" =~ "alacritty" ]] && add-zsh-hook precmd window_title

autoload -Uz compinit && compinit
(( $+commands[tailscale] )) && eval "$(tailscale completion zsh)"
(( $+commands[uv] )) && eval "$(uv generate-shell-completion zsh)"
(( $+commands[podman] )) && eval "$(podman completion zsh)"
(( $+commands[just] )) && eval "$(just --completions zsh)"

autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkeys() {
 bindkey -e
 bindkey $terminfo[kdch1] delete-char
 bindkey "^[[A" up-line-or-beginning-search
 bindkey "^[[B" down-line-or-beginning-search
 bindkey $terminfo[kLFT3] backward-word
 bindkey $terminfo[kRIT3] forward-word
}
bindkeys &> /dev/null

(( $+commands[direnv] )) && eval "$(direnv hook zsh)"
