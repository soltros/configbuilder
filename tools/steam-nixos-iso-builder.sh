#!/bin/bash

# Custom NixOS ISO Creation Script
# Allow Broken
export NIXPKGS_ALLOW_BROKEN=1

# Path to the custom hardware configuration file
CUSTOM_HW_CONFIG="custom_hardware.nix"

# Create a custom Nix configuration for the ISO
CUSTOM_NIX_CONFIG="custom_iso.nix"
cat > $CUSTOM_NIX_CONFIG <<EOF
{ config, pkgs, lib, ... }:

{
  imports =
    [ # Include the custom hardware configuration
      ./$CUSTOM_HW_CONFIG
      <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix>
    ];

  # Use the unstable channel
  nixpkgs.config = {
    allowUnfree = true;
    packageOverrides = pkgs: {
      inherit (import (pkgs.fetchFromGitHub {
        owner = "NixOS";
        repo = "nixpkgs";
        rev = "nixos-unstable";
        sha256 = "0000000000000000000000000000000000000000000000000000"; # Replace with correct hash
      }) {});
    };
  };

  # Select the latest kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Other configurations can go here
  # ...
}
EOF

# Build the ISO
nix-build '<nixpkgs/nixos>' -A config.system.build.isoImage -I nixos-config=$CUSTOM_NIX_CONFIG

# Notify about the ISO creation
echo "ISO build complete. The ISO can be found in the /nix/store directory."
