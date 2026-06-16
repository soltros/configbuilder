{ config, pkgs, ... }:

{
  # Enable bcachefs support in the initrd and system
  boot.supportedFilesystems = [ "bcachefs" ];


  boot.kernelPackages = pkgs.linuxPackages_latest;

  environment.systemPackages = with pkgs; [
    # Explicitly include the user-space tools for formatting and managing drives
    bcachefs-tools

    # Required for unlocking encrypted bcachefs partitions
    # (Addresses the bug mentioned in the wiki)
    keyutils
  ];
}
