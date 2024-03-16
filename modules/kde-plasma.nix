{ config, pkgs, ... }:

{
  #PLASMA 5
  #services.xserver.desktopManager.plasma5.enable = true;
  #services.xserver.displayManager.sddm.enable = true;
  
  #PLASMA 6
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.displayManager.defaultSession = "plasma";
  services.xserver.displayManager.sddm.wayland.enable = true;
  services.xserver.desktopManager.plasma6.enable = true;
  
  #General required services
  services.xserver.enable = true;

}
