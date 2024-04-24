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
