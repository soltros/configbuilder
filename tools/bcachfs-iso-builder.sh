#!/bin/bash

## Create workspace
mkdir -p ~/bcachefs-iso-builder/
cd ~/bcachefs-iso-builder/

## Create myimage.nix
echo "{ pkgs, lib, ... }:

{
  imports = [
    \"\${<nixpkgs>}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix\"
  ];

  # Use the latest Linux kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Explicitly setting supported filesystems, excluding ZFS and including bcachefs
  boot.supportedFilesystems = lib.mkForce [ \"btrfs\" \"cifs\" \"f2fs\" \"jfs\" \"ntfs\" \"reiserfs\" \"vfat\" \"xfs\" \"bcachefs\" ];

  # Include bcachefs-tools package
  environment.systemPackages = with pkgs; [ bcachefs-tools ];

  # Other custom configurations can be added here
}" > myimage.nix

## Begin build
nix-build '<nixpkgs/nixos>' -A config.system.build.isoImage -I nixos-config=myimage.nix

# After build, move the ISO to the current directory
cp $(readlink -f result/iso/*.iso) .
