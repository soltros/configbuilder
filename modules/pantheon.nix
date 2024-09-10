{ inputs, lib, pkgs, ... }:

{

  # Exclude the elementary apps you don't use
  environment.pantheon.excludePackages = with pkgs.pantheon; [
    elementary-music
    elementary-photos
    elementary-videos
    epiphany
  ];

  # Add additional apps and include Yaru for syntax highlighting
  environment.systemPackages = with pkgs; [
    appeditor                   # elementary OS menu editor
    celluloid                   # Video Player
    formatter                   # elementary OS filesystem formatter
    gthumb                      # Image Viewer
    gnome.simple-scan           # Scanning
    indicator-application-gtk3  # App Indicator
    pantheon.sideload           # elementary OS Flatpak installer
    torrential                  # elementary OS torrent client
    yaru-theme                  # Yaru theme
  ];

  # Enable GNOME Disks, Pantheon Tweaks, and Seahorse
  programs = {
    gnome-disks.enable = true;
    pantheon-tweaks.enable = true;
    seahorse.enable = true;
  };

  # Services configuration
  services = {
    pantheon.apps.enable = true;

    xserver = {
      enable = true;
      displayManager = {
        lightdm.enable = true;
        lightdm.greeters.pantheon.enable = true;
      };

      desktopManager.pantheon = {
        enable = true;
        extraWingpanelIndicators = with pkgs; [
          monitor
          wingpanel-indicator-ayatana
        ];
      };
    };
  };

  # App indicator systemd service
  systemd.user.services.indicatorapp = {
    description = "indicator-application-gtk3";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.indicator-application-gtk3}/libexec/indicator-application/indicator-application-service";
    };
  };

  # Link paths for app indicators
  environment.pathsToLink = [ "/libexec" ];
}
