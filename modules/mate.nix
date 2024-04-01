{ config, pkgs, ... }:

{
  services.xserver.desktopManager.mate.enable = true;
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.enable = true;
}

