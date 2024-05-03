{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    cosmic-bg
    cosmic-osd
    cosmic-term
    cosmic-edit
    cosmic-comp
    cosmic-store
    cosmic-randr
    cosmic-panel
    cosmic-icons
    cosmic-files
    cosmic-session
    cosmic-greeter
    cosmic-applets
    cosmic-settings
    cosmic-launcher
    cosmic-protocols
    cosmic-screenshot
    cosmic-applibrary
    cosmic-design-demo
    cosmic-notifications
    cosmic-settings-daemon
    cosmic-workspaces-epoch
    xdg-desktop-portal-cosmic
    rPackages.cosmicsig
    rPackages.COSMIC_67
  ];

 # Cosmic services Note: you must enable the Cosmic Cache flake.nix and flake.lock located here: https://github.com/lilyinstarlight/nixos-cosmic
 services.desktopManager.cosmic.enable = true;
 services.displayManager.cosmic-greeter.enable = true;
}
