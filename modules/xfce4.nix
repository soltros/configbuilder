{ config, pkgs, ... }:

{
  # Enable the X11 windowing system
  services.xserver.enable = true;

  # Configure the display manager
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.displayManager.lightdm.greeters.gtk.enable = true;

  # Enable the XFCE desktop environment
  services.xserver.desktopManager.xfce.enable = true;

  # Set LightDM as the default display manager
  services.xserver.displayManager.defaultSession = "xfce";

  # Install XFCE Whisker Menu Plugin and other plugins
  environment.systemPackages = with pkgs; [
    xfce.xfce4-whiskermenu-plugin xfce.xfce4-docklike-plugin xfce.xfce4-panel-profiles xfce.xfce4-pulseaudio-plugin alacarte pantheon.sideload pantheon.appcenter
  ];

  # Configuring XDG portal with specific backend settings
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];  # Use the appropriate portal for your environment
    config = {
      common = {
        default = "*";  # Use the first portal implementation found, mimicking behavior < 1.17
      };
    };
  };
}
