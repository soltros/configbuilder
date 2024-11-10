{ config, pkgs, ... }:

{
  # Enable systemd-boot as the bootloader
  boot.loader.systemd-boot.enable = true;

  # Allow the bootloader to modify EFI variables
  boot.loader.efi.canTouchEfiVariables = true;

  # Additional configurations can be added here
  # boot.kernelPackages = pkgs.linuxPackages_latest;

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
