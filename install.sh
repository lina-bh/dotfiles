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
hardlink() {
  local path=$1
  ln -fv "$toplevel/$path" "${HOME}/$path"
  return $?
}
hardlink ".config/containers/systemd/serve/mullvad.json"
hardlink ".config/mpv/mpv.conf"
hardlink ".config/containers/oci/hooks.d/tsonly.sh"
set -x
echo clear > "${HOME}/.bash_logout"
rm "${HOME}/.bash_profile" 2>/dev/null || :
