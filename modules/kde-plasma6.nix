{ config, pkgs, lib, ... }:

let
  # Overlay to enable Plasma 6 unstable with custom selections
  overlay-plasma6-unstable = self: super: {
    plasmaPackages = pkgs.kdePackages_unstable.overrideAttrs (oldAttrs: {
      # Replace with specific attributes to modify packages as needed
      # This is a placeholder - adjust these based on your needs
    });
  };

in

{
  # Include the custom overlay.
  nixpkgs.overlays = [ overlay-plasma6-unstable ];

  # Enable the X server and configure the display manager and desktop environment.
  services.xserver.enable = true;
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.displayManager.defaultSession = "plasma";
  services.xserver.displayManager.sddm.wayland.enable = true;

  # Enable Plasma 6 (might not be necessary)
  # services.xserver.desktopManager.plasma6.enable = true;

  # Exclude all Plasma 6 packages (assuming you want to use custom selections only)
  environment.plasma6.excludePackages = with pkgs.kdePackages; pkgs.kdePackages;
  
  # Configure GnuPG's pinentry to use pinentry-qt.
  programs.gnupg.agent.pinentryPackage = lib.mkForce pkgs.pinentry-qt;
}
