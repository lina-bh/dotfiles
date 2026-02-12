typeset -U fpath
fpath+="${HOMEBREW_PREFIX}/share/zsh/site-functions"
fpath+="/usr/share/zsh/site-functions"
setopt hist_ignore_dups
setopt hist_ignore_space
setopt inc_append_history
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
SAVEHIST="$HISTSIZE"
REPORTTIME=4
WORDCHARS="${WORDCHARS//.}"
WORDCHARS="${WORDCHARS//\/}"

PROMPT="$( (( ${+SSH_CLIENT} )) && echo '%n@%m:')$( (( ${+CONTAINER_ID} )) && echo "[${CONTAINER_ID}] ")%~ %F{green}%#%f "
RPROMPT='%F{red}%(?..%? )%f%(1j.%j%% .)'

window_title() {
  builtin echo -ne "\033]0;$PWD\007"
}
autoload -Uz add-zsh-hook
[[ "$TERM" =~ "xterm" || "$TERM" =~ "alacritty" ]] && add-zsh-hook precmd window_title

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

autoload -Uz compinit
compinit
zstyle ':completion:*' rehash true

(( $+commands[tailscale] )) && eval "$(tailscale completion zsh)"
(( $+commands[uv] )) && eval "$(uv generate-shell-completion zsh)"
(( $+commands[podman] )) && eval "$(podman completion zsh)"
(( $+commands[just] )) && eval "$(just --completions zsh)"
(( $+commands[direnv] )) && eval "$(direnv hook zsh)"
(( $+commands[rustup] )) && eval "$(rustup completions zsh)"
(( $+commands[gh] )) && eval "$(gh completion --shell zsh)"

true
