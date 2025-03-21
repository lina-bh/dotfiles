function fish_prompt
    set -f user (test -n "$SSH_CLIENT"; or test -n "$container"; and prompt_login)
    set -f container (test -n "$CONTAINER_ID"; and printf "[%s]" "$CONTAINER_ID")
    set -f lhs (test -n "$user"; or test -n "$container"; and printf '%s%s ' "$user" "$container")
    set -f lastpwd (prompt_pwd (string replace --regex '^/var/home/' '/home/' $PWD))
    printf '%s%s> ' $lhs $lastpwd
end
