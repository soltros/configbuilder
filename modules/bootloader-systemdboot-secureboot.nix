{ config, pkgs, ... }:

{
  # Enable systemd-boot as the bootloader
  boot.loader.systemd-boot.enable = true;
  # This option needs to be set to false when using lanzaboote
  boot.loader.systemd-boot.manageScript = "manual";

  # Allow the bootloader to modify EFI variables
  boot.loader.efi.canTouchEfiVariables = true;

  # Additional configurations can be added here
  # boot.kernelPackages = pkgs.linuxPackages_latest;

  # Enable lanzaboote for Secure Boot
  boot.lanzaboote = {
    enable = true;
    # Ensure this path matches the location where sbctl will store the keys
    pkiBundle = "/etc/secureboot";
  };

  # Make sbctl available for managing keys
  environment.systemPackages = [ pkgs.sbctl ];

  # Optional but recommended: Enable gamemode
  programs.gamemode = {
    enable = true;
    settings = {
      custom = {
        start = "${pkgs.libnotify}/bin/notify-send 'GameMode started'";
        end = "${pkgs.libnotify}/bin/notify-send 'GameMode ended'";
      };
    };
  };
}
