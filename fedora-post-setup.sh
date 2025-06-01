#!/bin/sh
set -e
flatpak remote-add --if-not-exists flathub 'https://dl.flathub.org/repo/flathub.flatpakrepo'
! rpm -q --quiet rpmfusion-free-release && sudo dnf5 install -y \
	https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
	https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
sudo dnf5 install -y \
	rsms-inter-fonts \
	jetbrains-mono-nl-fonts \
	power-profiles-daemon \
	fd-find \
	ripgrep \
	mesa-va-drivers-freeworld \
	git \
	ldns-utils \
	;
sudo dnf5 -y mark user plasma-browser-integration google-noto-emoji-fonts liberation-\*-fonts langpacks-en java-21-openjdk-headless startup-notification skopeo podman openssl zenity
sudo dnf5 remove \
	libreoffice-\* \
	kmahjongg \
	kmines \
	kpat \
	gwenview \
	kolourpaint \
	okular \
	skanpage \
	akregator \
	firefox \
	kmail \
	krdc \
	krfb \
	ktnef \
	neochat \
	dragon \
	elisa-player \
	kamoso \
	qrca \
	korganizer \
	kontact \
	mediawriter \
	kjournald \
	kcalc \
	kcharselect \
	kfind \
	kgpg \
	kmouth \
	ark \
	kaddressbook \
	mariadb \
	{libertas,tiwilink,nxpwireless,cirrus-audio,nvidia-gpu,atheros,mt7xxx,brcmfmac,intel-gpu,intel-vsc,intel-audio,iwlegacy,iwlwifi-dvm}-firmware \
	hplip \
	intel-mediasdk \
	exiv2 \
	toolbox \
	orca \
	libva-intel-media-driver \
	intel-vpl-gpu-rt \
	akonadi-server \
	NetworkManager-{adsl,vpnc,libreswan,openvpn,l2tp,ppp} \
	audiocd-kio \
	cups-browsed \
	iscsi-initiator-utils \
	kio-gdrive \
	open-vm-tools \
	openssh-server \
	qemu-guest-agent \
	b43-{fwcutter,openfwwf} \
	brltty \
	compsize \
	ibus-{typing-booster,gtk4,anthy,anthy-python,chewing,hangul,libpinyin,m17n,table-chinese-cangjie} \
	kamera \
	iptstate \
	kaccounts-providers \
	kdebugsettings \
	krdp \
	mactel-boot \
	minicom \
	mpage \
	mtr \
	opensc \
	paps \
	rsyslog \
	sos \
	spice-{vdagent,webdavd} \
	virtualbox-guest-additions \
	tuned \
	anaconda{,-live} \
	gawk-all-langpacks \
	gtk{2,3}-immodule-xim \
	jemalloc \
	livesys-scripts \
	lrzsz \
	mailcap \
	psacct \
	realmd \
	sssd{,-kcm,-proxy,-common} \
	isomd5sum \
	hyperv-daemons \
	aajohan-comfortaa-fonts \
	deltarpm \
	dracut-live \
	plocate \
	;
flatpak install flathub \
	org.mozilla.firefox \
	org.kde.{gwenview,ark,okular}
flatpak --user override --filesystem=~/.mozilla org.mozilla.firefox
