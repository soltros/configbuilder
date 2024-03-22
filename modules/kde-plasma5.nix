{ config, pkgs, ... }:

{

#Plasma 5
services.xserver.enable = true;
services.xserver.displayManager.sddm.enable = true;
services.xserver.desktopManager.plasma5.enable = true;

}
