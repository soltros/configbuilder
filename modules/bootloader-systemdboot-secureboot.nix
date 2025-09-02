{ config, pkgs, lib, ... }:

{
  # Lanzaboote handles this, so we disable the standard systemd-boot module.
  # You must also follow this guide here: https://github.com/nix-community/lanzaboote/blob/master/docs/QUICK_START.md
  boot.loader.systemd-boot.enable = lib.mkForce false;
  # The 'manageScript' option is not supported and has been commented out.
  # boot.loader.systemd-boot.manageScript = "manual";

  # Allow the bootloader to modify EFI variables.
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
