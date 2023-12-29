#!/bin/bash


## Upgrade NixOS to Unstable.
echo "Running this installer assumes you have do not have snapd.nix from Configbuilder enabled. Your system will not build with th>
echo "Ensure you have flake-support.nix enabled to build."
echo "Snap packages for NixOS requires NixOS Unstable. Upgrading...."
sudo nix-channel --add https://nixos.org/channels/nixos-unstable nixos
sudo nix-channel --update
sudo nixos-rebuild switch --upgrade

## Download the Nix-Snapd files
git clone https://github.com/io12/nix-snapd.git

# Ask the user for their hostname
read -p "Enter the new hostname: " new_hostname

# Optional: Validate the hostname here

# Path to your flake.nix file
FLAKE_FILE="$HOME/nix-snapd/flake.nix"

# Check if flake.nix file exists
if [ ! -f "$FLAKE_FILE" ]; then
    echo "flake.nix file not found at $FLAKE_FILE"
    exit 1
fi

# Replace 'my-hostname' with the user-provided hostname in flake.nix
sed -i "s/my-hostname/$new_hostname/g" "$FLAKE_FILE"

echo "flake.nix has been updated with the new hostname: $new_hostname"


## Enter the Nix-Snapd dir
cd nix-snapd/

## Build the module
sudo nix build

