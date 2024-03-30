{ config, pkgs, ... }:

{
  services.xserver.desktopManager.pantheon.enable = true;
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.enable = true;
}

