{ config, pkgs, ... }:

{
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.enlightenment.enable = true;
  services.acpid.enable = true;
  services.xserver.libinput.enable = true;

  # Enabling XDG portal and adding a portal implementation
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];  # Adjust based on your desktop environment needs
  };

}
