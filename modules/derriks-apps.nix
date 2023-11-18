{ config, pkgs, ... }: 

{
  # Add Pantheon packages to the system environment
  environment.systemPackages = with pkgs; [
	bitwarden
        python312
        papirus-icon-theme
        gnome.dconf-editor
        gnome.gnome-tweaks
	tdesktop
	spotify
	tailscale
	vlc
	gimp
	wget
	libsForQt5.ghostwriter
	winetricks
	wine-staging
	pavucontrol
	element-desktop
	distrobox
	nextcloud-client
	geany
	screenfetch
	kate
	thunderbird
	ntfs3g
	kdenlive
	firefox
	flatpak
	mullvad
	discord
        trayscale
  ];
}
