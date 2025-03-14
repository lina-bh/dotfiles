#!/bin/bash
set -euo pipefail
toplevel="$(git rev-parse --show-toplevel)"
dotfiles="$(find "$toplevel" -regextype sed -type f -regex "$toplevel"'/\..*' ! -regex "$toplevel"'/.git.*')"
for target in $dotfiles; do
	dotpath="${target#"$toplevel"/}"
	link="${HOME}/$dotpath"
	linkdir="$(dirname "$link")"
	[[ "$linkdir" != ".." ]] && mkdir -pv "$linkdir"
	ln -sfv "$target" "$link"
done

tee "${HOME}/.bash_logout" <<<'clear' >/dev/null
rm "${HOME}/.bash_profile" 2>/dev/null || :
