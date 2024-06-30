{ config, pkgs, ... }:
{
  imports =
    [
      ./hardware-configuration.nix
      ./flake.nix
      ./flake-support.nix
     
    ];

  # Add your custom configurations here

  # System packages
  environment.systemPackages = with pkgs; [
    efibootmgr refind git keepassxc bitwarden python3 appimage-run papirus-icon-theme gnome.dconf-editor libreoffice-qt gnome.gnome-tweaks spotify tailscale vlc gimp wget libsForQt5.ghostwriter wine-staging pavucontrol fluffychat distrobox geany thunderbird ntfs3g firefox flatpak mullvad-vpn discord kopia tdesktop flameshot microsoft-edge ollama screen nodejs pipx ncdu nvtop php adapta-gtk-theme mlocate yt-dlp waybar wofi networkmanagerapplet kitty mako swaybg swaylock grim slurp jq wl-clipboard notify-desktop libnotify playerctl pinta okular plex-media-player virt-manager fish nfs-utils nvidiaPackages.stable podman cups openssh python311Packages.pip python312
  ];

  # This value determines the NixOS release with which your system is to be compatible.
  # Update it according to your NixOS version.
  system.stateVersion = "24.05"; # Edit according to your NixOS version
}
