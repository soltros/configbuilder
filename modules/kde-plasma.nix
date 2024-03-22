{ config, pkgs, lib, ... }:

{
  imports = [
    <kde2nix/nixos.nix> # Add this line to import the kde2nix module
  ];

  # Plasma 6
  services.xserver.enable = true;
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.displayManager.defaultSession = "plasma";
  services.xserver.displayManager.sddm.wayland.enable = true;
  
  environment.plasma6.excludePackages = with pkgs.kdePackages; [ ];

  # Additional configurations...
}
