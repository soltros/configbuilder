{ config, pkgs, ... }:

  #Plasma 6
  services.xserver.enable = true;
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.displayManager.defaultSession = "plasma";
  services.xserver.displayManager.sddm.wayland.enable = true;
  
  environment.plasma6.excludePackages = with pkgs.kdePackages; [ ];

  # Additional configurations...
}
