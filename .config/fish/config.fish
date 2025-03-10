status is-interactive; and begin
    source ~/.config/aliases

    set -g fish_color_command normal
    set -g fish_color_param normal
    command -q tailscale; and tailscale completion fish | source
end
