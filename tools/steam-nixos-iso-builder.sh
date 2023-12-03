#!/bin/bash

# Define variables
JOVIAN_ZIP_URL="https://github.com/Jovian-Experiments/Jovian-NixOS/archive/refs/heads/development.zip"
JOVIAN_DIR="Jovian-NixOS-development"
FLAKE_PATH="${JOVIAN_DIR}#nixosConfigurations.example-module.config.system.build.isoImage"
# Replace 'example-module' with the actual name of the module you want to use for the Live CD

# Download and extract the Jovian-NixOS-development.zip file
wget $JOVIAN_ZIP_URL -O jovian-nixos.zip
unzip jovian-nixos.zip

# Use the correct name of the directory after extraction
JOVIAN_DIR="$(find . -maxdepth 1 -type d -name 'Jovian-NixOS-development*' -print -quit)"
FLAKE_PATH="${JOVIAN_DIR}#nixosConfigurations.example-module.config.system.build.isoImage"

# Generate the ISO using the flake
nix build --no-link "$FLAKE_PATH"

# Move the resulting ISO to the current directory
mv $(find /nix/store -name '*.iso' -print -quit) ./jovian-nixos-livecd.iso

# Output the location of the ISO
echo "Live CD ISO created at $(pwd)/jovian-nixos-livecd.iso"
