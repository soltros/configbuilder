{ config, pkgs, ... }:

{
  services.xserver.desktopManager.mate.enable = true;
  services.displayManager.lightdm.enable = true;
  services.xserver.enable = true;
}

