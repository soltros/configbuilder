{ config, pkgs, ... }:

let
  plasma6-overlay-url = "https://raw.githubusercontent.com/soltros/configbuilder/main/overlays/plasma6-overlay.nix";
  plasma6-overlay = import (builtins.fetchurl plasma6-overlay-url) { inherit (pkgs) fetchurl; };
in {
  nixpkgs.overlays = [ plasma6-overlay ];

  services.xserver.enable = true;
  services.xserver.displayManager.sddm.enable = true;

  # Assuming you want to enable KDE Plasma (adjust based on actual available options for Plasma 6)
  services.xserver.desktopManager.plasma5.enable = true;
  
  # Exclude KDE Plasma applications if desired
  environment.plasma6.excludePackages = with pkgs.kdePackages; [  ];
  
  # Additional configurations...
}



