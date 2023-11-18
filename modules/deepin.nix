{ config, pkgs, ... }:

{
  services.xserver.desktopManager.deepin.enable = true;
  services.xserver.displayManager.lightdm.enable = true;
}

