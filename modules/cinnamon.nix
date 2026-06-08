{ config, pkgs, ... }:

{
  services.xserver.desktopManager.cinnamon.enable = true;
  services.displayManager.lightdm.enable = true;
}

