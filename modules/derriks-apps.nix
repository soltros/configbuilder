{ config, pkgs, ... }: 

{
  # Add packages to the system environment
  environment.systemPackages = with pkgs; [
	bitwarden
        spot
        git
        keepassxc
        python312
        appimage-run
        papirus-icon-theme
        gnome.dconf-editor
        libreoffice-qt
        gnome.gnome-tweaks
	spotify
	tailscale
        pika-backup
	vlc
	gimp
	wget
	libsForQt5.ghostwriter
	winetricks
	wine-staging
	pavucontrol
	fluffychat
	distrobox
	geany
	thunderbird
	ntfs3g
	appimage-run
	firefox
	flatpak
	mullvad-vpn
	discord
  ];
}
