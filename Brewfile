# vim:ft=ruby
tap "oven-sh/bun"
brew "zsh"
brew "neovim"
brew "fd"
brew "ripgrep"
brew "aria2"
brew "libarchive"
brew "oven-sh/bun/bun"
brew "htop"
brew "gh"
brew "uv"
brew "direnv"
if OS.linux?
  tap "wezterm/wezterm-linuxbrew"
  brew("wezterm/wezterm-linuxbrew/wezterm", args: ["HEAD"])
end
flatpak("io.gitlab.librewolf-community", postinstall: "flatpak override --user --device=all io.gitlab.librewolf-community")
flatpak("io.mpv.Mpv", postinstall: "flatpak override --user --filesystem=xdg-config/mpv io.mpv.Mpv")
flatpak "com.fastmail.Fastmail"
flatpak("com.discordapp.Discord")
flatpak("com.github.wwmm.easyeffects")
flatpak("org.signal.Signal")
