#!/bin/bash

# Define variables
CONFIGURATION_FILE="configuration.nix"
LIVECD_CONFIG_FILE="livecd.nix"
LIVECD_OUTPUT="nixos-livecd.iso"

# Check for Nix installation
if ! command -v nix-shell &> /dev/null
then
    echo "Nix is not installed. Please install Nix and try again."
    exit 1
fi

# Check for nixos-generators installation
if ! nix-shell -p nixos-generators --run "echo 'nixos-generators installed'" &> /dev/null
then
    echo "nixos-generators is not installed. Installing..."
    nix-shell -p nixos-generators
fi

# Create the custom configuration.nix file
cat > $CONFIGURATION_FILE << EOF
{ config, pkgs, lib, ... }:

let
  myUsername = "deck";
  myUserdescription = "SteamOS";
  jovian-nixos = builtins.fetchGit {
    url = "https://github.com/Jovian-Experiments/Jovian-NixOS";
    ref = "development";
  };
in {
  imports = [ "\${jovian-nixos}/modules" ];
  # ... (Rest of your module code here)
}
EOF

# Create the livecd.nix file
cat > $LIVECD_CONFIG_FILE << EOF
{ config, pkgs, ... }:

{
  imports = [
    ./$CONFIGURATION_FILE
  ];

  boot.supportedFilesystems = [ "ext4" ];
  services.xserver.enable = true;
  networking.networkmanager.enable = true;

  environment.systemPackages = with pkgs; [
    # Additional packages
  ];
}
EOF

# Build the Live CD
echo "Building NixOS Live CD..."
nix-shell -p nixos-generators --run "nixos-generate -f iso -c $LIVECD_CONFIG_FILE -o $LIVECD_OUTPUT"

# Check if ISO was created successfully
if [ -f "$LIVECD_OUTPUT" ]; then
    echo "NixOS Live CD created successfully: $LIVECD_OUTPUT"
else
    echo "Failed to create NixOS Live CD."
    exit 1
fi
