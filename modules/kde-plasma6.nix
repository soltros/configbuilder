{ config, pkgs, lib, ... }:

let
  # Overlay to enable Plasma 6 unstable
  overlay-plasma6-unstable = self: super: {
    # Replace with the actual package names you want to use from plasma-unstable
    # This is a placeholder - adjust these based on your needs
    plasmaPackages = pkgs.kdePackages_unstable.overrideAttrs (oldAttrs: { });
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

  # Don't exclude any Plasma 6 packages (assuming you want unstable versions)
  environment.plasma6.excludePackages = with pkgs.kdePackages; [];
  
  # Configure GnuPG's pinentry to use pinentry-qt.
  programs.gnupg.agent.pinentryPackage = lib.mkForce pkgs.pinentry-qt;
}
