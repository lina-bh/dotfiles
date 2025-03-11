source ~/.config/env
cleanup_PATH() {
  export PATH="$(awk -v RS=: -v ORS= '!a[$0]++ { if (NR>1) print ":"; print $0 }' <<< "$PATH")"
}
trap cleanup_PATH RETURN

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

source ~/.config/aliases

precmd() {
    local exit=$?
    ps1_status=
    [[ $exit -ne 0 ]] && ps1_status="$exit "
}
PROMPT_COMMAND="precmd; ${PROMPT_COMMAND}"

ps1_host='\h'
[[ -n $CONTAINER_ID ]] && ps1_host="$CONTAINER_ID"
PS1='\[\e]0;\u@'"$ps1_host"':\w\a\]'
[[ -n $SSH_CLIENT || -n $container && $container != 'flatpak' ]] && PS1="$PS1"'\u@'"$ps1_host"' '
PS1="$PS1"'$([[ -n "$(jobs -p)" ]] && echo -n "%\j ")$ps1_status\w \$ '
