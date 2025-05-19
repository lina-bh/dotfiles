source ~/.config/env
command -q fnm; and fnm env | .

status is-interactive; and begin
    source ~/.config/aliases

    set -g fish_color_command normal
    set -g fish_color_param normal

    set -x QUOTING_STYLE literal
    command -q tailscale; and tailscale completion fish | source
end
