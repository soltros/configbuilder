{ config, pkgs, lib, ... }:

let
  overlay-unstable = self: super: {
    # Define your overlay here.
    # Example:
    # myPackage = super.myPackage.overrideAttrs (oldAttrs: { ... });
  };
in

{
  # Include the custom overlay.
  nixpkgs.overlays = [ overlay-unstable ];

  # Enable the X server and configure the display manager and desktop environment.
  services.xserver.enable = true;
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.displayManager.defaultSession = "plasma";
  services.xserver.displayManager.sddm.wayland.enable = true;
  services.xserver.desktopManager.plasma6.enable = true;

  # Configure the environment for Plasma6.
  environment.plasma6.excludePackages = with pkgs.kdePackages; [ ];
  
  # Configure GnuPG's pinentry to use pinentry-qt.
  programs.gnupg.agent.pinentryPackage = lib.mkForce pkgs.pinentry-qt;
}
