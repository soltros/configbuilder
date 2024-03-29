{ config, pkgs, lib, ... }:

{
  # Plasma 6
  services.xserver.enable = true;
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.displayManager.defaultSession = "plasma";
  services.xserver.displayManager.sddm.wayland.enable = true;
  services.xserver.desktopManager.plasma6.enable = true;

  environment.plasma6.excludePackages = with pkgs.kdePackages; [ ];

  # Resolve the `programs.gnupg.agent.pinentryPackage` duplication error by forcing the use of pinentry-qt
  programs.gnupg.agent.pinentryPackage = lib.mkForce pkgs.pinentry-qt;

  # Additional configurations...
}
