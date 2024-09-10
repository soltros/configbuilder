{ config, pkgs, ... }:

{
  # Enable X server and LightDM
  services.xserver.enable = true;
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.pantheon.enable = true;

  # Enable Pantheon Tweaks and Flatpak
  programs.pantheon-tweaks.enable = true;
  services.flatpak.enable = true;

  # Exclude the elementary apps I don't use
  environment = {
    pantheon.excludePackages = with pkgs.pantheon; [
      elementary-music
      elementary-photos
      elementary-videos
      epiphany
    ];

  # System packages
  environment.systemPackages = with pkgs; [
    appeditor                   # elementary OS menu editor
    celluloid                   # Video Player
    formatter                   # elementary OS filesystem formatter
    gthumb                      # Image Viewer
    gnome.simple-scan           # Scanning
    indicator-application-gtk3  # App Indicator
    pantheon.sideload           # elementary OS Flatpak installer
    torrential                  # elementary OS torrent client
    yaru-theme
  ];

  # GNOME Disks, Pantheon Tweaks and Seahorse
  programs.gnome-disks.enable = true;
  programs.seahorse.enable = true;

  # X server configuration for Pantheon
  services.xserver.desktopManager.pantheon.extraWingpanelIndicators = with pkgs; [
    monitor
    wingpanel-indicator-ayatana
  ];

  # App indicator service
  systemd.user.services.indicatorapp = {
    description = "indicator-application-gtk3";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.indicator-application-gtk3}/libexec/indicator-application/indicator-application-service";
    };
  };
}
