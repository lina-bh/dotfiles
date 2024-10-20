# -*- truncate-lines: nil; -*-
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
HISTSIZE=4000
SAVEHIST=$HISTSIZE
REPORTTIME=4
HISTFILE="${HOME}/.zsh_history"
WORDCHARS="${WORDCHARS//.}"
WORDCHARS="${WORDCHARS//\/}"
export QUOTING_STYLE=literal
alias ls='ls -FHh --color'
alias ".git"="git --git-dir=${HOME}/.dotfiles --work-tree=${HOME}"
alias emacsclient='emacsclient -nq'
alias userctl='systemctl --user'
alias juserctl='journalctl --user -b'
alias journalctl='journalctl -b'
(( $+commands[nvim] )) && alias vim=nvim
(( $+commands[grm] )) && alias rm=grm
in_nix_shell() {
  (( ${+IN_NIX_SHELL} )) || (( SHLVL > 1 )) && [[ "$PATH" =~ "/nix/store" ]]
  return $?
}
PROMPT="$( (( ${+SSH_CLIENT} )) && echo '%n@%m:')%~ $(in_nix_shell && echo 'nix-shell:')%F{green}%#%f "
RPROMPT='%F{red}%(?..%? )%f%(1j.%j%% .)'
autoload -Uz compinit && compinit
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

window_title() {
  builtin echo -ne "\033]0;$PWD\007"
}
autoload -Uz add-zsh-hook
[[ "$TERM" =~ "xterm" || "$TERM" =~ "alacritty" ]] && add-zsh-hook precmd window_title
