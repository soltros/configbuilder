#!/usr/bin/env bash

# Exit on error
set -e

# Ensure the script is run as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

# Updating the channel
echo "Setting NixOS channel..."
nix-channel --add https://nixos.org/channels/nixos-24.11 nixos
nix-channel --update

# Upgrading the system
echo "Upgrading to NixOS 24.05..."
nixos-rebuild switch --upgrade

# Optional: Perform a garbage collection
echo "Performing garbage collection..."
nix-collect-garbage -d

# Optional: Remove old generations of the system profile
echo "Removing old system profile generations..."
nix-env -p /nix/var/nix/profiles/system --delete-generations old

echo "Upgrade complete. Rebooting system."
reboot
