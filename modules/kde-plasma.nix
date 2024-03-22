{ config, pkgs, ... }:

let
  plasma6-overlay-url = "https://raw.githubusercontent.com/soltros/configbuilder/main/overlays/plasma6-overlay.nix";
  plasma6-overlay = import (builtins.fetchurl plasma6-overlay-url) { inherit (pkgs) fetchurl; };
in {
  nixpkgs.overlays = [ plasma6-overlay ];
  
  # Plasma 6
  services.xserver.enable = true;
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma6.enable = true;
  services.xserver.displayManager.defaultSession = "plasma";
  services.xserver.displayManager.sddm.wayland.enable = true;
  
  # Exclude KDE Plasma applications if desired
  environment.plasma6.excludePackages = with pkgs.kdePackages; [  ];
  
  # Additional configurations...
}



