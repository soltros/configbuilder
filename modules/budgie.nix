{ config, pkgs, ... }:

{
  services.xserver.desktopManager.budgie.enable = true;
  services.displayManager.lightdm.enable = true;
}

