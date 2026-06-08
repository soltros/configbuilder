{ config, pkgs, ... }:

{
  services.xserver.desktopManager.deepin.enable = true;
  services.displayManager.lightdm.enable = true;
}

