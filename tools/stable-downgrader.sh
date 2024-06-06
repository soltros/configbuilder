#!/bin/bash

# Function to upgrade NixOS to Unstable and add nix-snapd channel
upgrade_nixos_and_add_channel() {
    echo "Running this installer will downgrade your release from Unstable back to the latest release."
    echo "Downgrading and adding channel..."

    # Downgrade NixOS to Latest release
    sudo nix-channel --add https://nixos.org/channels/nixos-24.05 nixos
    sudo nix-channel --update

    # Rebuild NixOS with the new configuration
    sudo nixos-rebuild switch --upgrade
    echo "NixOS downgraded."
}

# Menu
while true; do
    echo "Select an operation:"
    echo "1. Downgrade to NixOS Stable"
    echo "2. Exit"
    read -p "Enter your choice [1-2]: " choice

    case $choice in
        1) upgrade_nixos_and_add_channel ;;
        2) break ;;
        *) echo "Invalid option. Please try again." ;;
    esac
done
