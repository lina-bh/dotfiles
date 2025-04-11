#!/bin/bash
set -euo pipefail
worktree="$(dirname "$0")"
toplevel="$(git --git-dir="${worktree}/.git" --work-tree="${worktree}" rev-parse --show-toplevel)"
dotfiles="$(find "$toplevel" -regextype sed -type f -regex "$toplevel"'/\..*' ! -regex "$toplevel"'/.git.*')"
for target in $dotfiles; do
	dotpath="${target#"$toplevel"/}"
	link="${HOME}/$dotpath"
	linkdir="$(dirname "$link")"
	[[ "$linkdir" != ".." ]] && mkdir -pv "$linkdir"
	ln -sfv "$target" "$link"
done
set -x
ln -f "$toplevel/.config/MangoHud/MangoHud.conf" "$HOME/.config/MangoHud/MangoHud.conf"
tee "${HOME}/.bash_logout" <<<'clear' >/dev/null
rm "${HOME}/.bash_profile" 2>/dev/null || :
ln -f "$toplevel/.config/mpv/mpv.conf" "$HOME/.config/mpv/mpv.conf"
set +x
