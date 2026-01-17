#!/bin/sh
command -v flatpak >/dev/null && (
  set -xe;
  flatpak override --user --device=all io.gitlab.librewolf-community
  flatpak override --user --filesystem=xdg-config/mpv io.mpv.Mpv
)
