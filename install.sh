#!/bin/bash
set -euo pipefail
worktree="$(dirname "$0")"
toplevel="$(git --git-dir="${worktree}/.git" --work-tree="${worktree}" rev-parse --show-toplevel)"
symlink() {
  # strip leading ${toplevel}/ from $1
  local path="${HOME}/${1#"$toplevel"/}"
  mkdir -pv "$(dirname "$path")"
  ln -sfv "$target" "$path"
}
hardlink() {
  ln -fv "$toplevel/${1}" "${HOME}/${1}"
}
find "$toplevel" -regextype sed -type f -regex "$toplevel"'/\..*' ! -regex "$toplevel"'/.git.*' | while read -r target; do symlink "$target"; done
find "$toplevel"/bin -maxdepth 1 -type f | while read -r target; do symlink "$target"; done
set -x
echo clear > "${HOME}/.bash_logout"
rm "${HOME}/.bash_profile" 2>/dev/null || :
set +xe
hardlink ".config/mpv/mpv.conf"
hardlink ".config/containers/oci/hooks.d/tsonly.sh"
