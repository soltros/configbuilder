{ config, pkgs, ... }:

{
  # Enable systemd-boot as the bootloader
  boot.loader.systemd-boot.enable = true;

  # Allow the bootloader to modify EFI variables
  boot.loader.efi.canTouchEfiVariables = true;

  # Additional configurations can be added here
  boot.kernelPackages = pkgs.linuxPackages_latest;
}
