{ config, pkgs, ... }:

let
  overlayPath = "/etc/nixos/plasma6-overlay.nix";
  plasma6-overlay = import overlayPath { inherit pkgs; };
in {
  nixpkgs.overlays = [ plasma6-overlay ];

  #Plasma 6
  services.xserver.enable = true;
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.displayManager.defaultSession = "plasma";
  services.xserver.displayManager.sddm.wayland.enable = true;
  
  environment.plasma6.excludePackages = with pkgs.kdePackages; [ ];

  # Additional configurations...
}
