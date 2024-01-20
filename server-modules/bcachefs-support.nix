{ config, pkgs, ... }:
{
  # Enable filesystem support for Bcachefs
  boot.supportedFilesystems = [ "bcachefs" ];

  # Specify the file system configuration
  fileSystems."/" = {
    device = "/dev/sda1"; # Replace with your device identifier
    fsType = "bcachefs";
    options = [ "compression=zstd" ]; # Example option, adjust as needed
  };

  # Use the latest Linux kernel supporting Bcachefs
  #boot.kernelPackages = pkgs.linuxPackages_latest;

  # Additional configurations can be added here
}
