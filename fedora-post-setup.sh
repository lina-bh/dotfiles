#!/bin/bash
set -e
sudo bash <<EOF
set -e
! rpm -q --quiet rpmfusion-free-release && sudo dnf5 install -y \
	"https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm" \
	"https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"
dnf5 -y copr enable bieszczaders/kernel-cachyos-addons
dnf5 -y copr enable peterwu/iosevka
dnf5 install -y --allowerasing \
	rsms-inter-fonts \
	jetbrains-mono-nl-fonts \
	fd-find \
	ripgrep \
	mesa-va-drivers-freeworld \
	git \
	ldns-utils \
        ShellCheck \
        tailscale \
        scx-scheds \
        sqlite \
        iosevka-fixed-fonts \
        powertop \
        direnv \
        bsdtar \
	;
dnf5 install -y --setopt=install_weak_deps=False neovim
dnf5 -y mark user plasma-browser-integration google-noto-emoji-fonts liberation-\*-fonts langpacks-en java-21-openjdk-headless startup-notification skopeo podman openssl zenity
dnf5 -y remove \
	NetworkManager-{adsl,vpnc,libreswan,openvpn,l2tp,ppp} \
	aajohan-comfortaa-fonts \
	akonadi-server \
	akregator \
	anaconda{,-live} \
	ark \
	audiocd-kio \
	b43-{fwcutter,openfwwf} \
	brltty \
	compsize \
	cups-browsed \
	deltarpm \
	dracut-live \
	dragon \
	elisa-player \
	exiv2 \
	firefox \
	gawk-all-langpacks \
	gtk{2,3}-immodule-xim \
	gwenview \
        hfsplus-tools \
	hplip \
	hyperv-daemons \
	ibus-{typing-booster,gtk4,anthy,anthy-python,chewing,hangul,libpinyin,m17n,table-chinese-cangjie} \
        im-chooser \
	intel-mediasdk \
	intel-vpl-gpu-rt \
	iptstate \
	iscsi-initiator-utils \
	isomd5sum \
	jemalloc \
	kaccounts-providers \
	kaddressbook \
	kamera \
	kamoso \
	kcalc \
	kcharselect \
	kdebugsettings \
	kfind \
	kgpg \
	kio-gdrive \
	kjournald \
	kmahjongg \
	kmail \
	kmines \
	kmouth \
	kolourpaint \
	kontact \
	korganizer \
	kpat \
	krdc \
	krdp \
	krfb \
	ktnef \
	libreoffice-\* \
	libva-intel-media-driver \
	livesys-scripts \
	lrzsz \
	mactel-boot \
	mariadb \
	mediawriter \
	minicom \
	mpage \
	mtr \
	neochat \
	okular \
	open-vm-tools \
	opensc \
	openssh-server \
	orca \
	paps \
	plocate \
	psacct \
	qemu-guest-agent \
	qrca \
	realmd \
	rsyslog \
	skanpage \
	sos \
	spice-{vdagent,webdavd} \
	sssd{,-kcm,-proxy,-common} \
        teamd \
	toolbox \
	virtualbox-guest-additions \
	{libertas,tiwilink,nxpwireless,cirrus-audio,nvidia-gpu,atheros,mt7xxx,brcmfmac,intel-gpu,intel-vsc,intel-audio,iwlegacy,iwlwifi-dvm}-firmware \
	;
flatpak remote-add --system --if-not-exists flathub 'https://dl.flathub.org/repo/flathub.flatpakrepo'
flatpak remote-delete --system fedora 2>/dev/null ||:
printf 'default_sched = "scx_lavd"\ndefault_mode = "PowerSave"\n' >/etc/scx_loader.toml
systemctl enable --now scx_loader.service tailscaled.service
echo 'add_dracutmodules+=" fido2 "' >/etc/dracut.conf.d/fido2.conf
EOF
flatpak install -y --or-update flathub \
	org.mozilla.firefox \
	org.kde.{gwenview,ark,okular} \
        com.github.wwmm.easyeffects
flatpak --user override --filesystem=~/.mozilla org.mozilla.firefox
