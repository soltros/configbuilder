#!/bin/bash

# Function to upgrade NixOS to Unstable and add nix-snapd channel
upgrade_nixos_and_add_channel() {
    echo "Running this installer will upgrade NixOS to Unstable and update it. If you wish to use Plasma 6, this is required."
    echo "Upgrading and adding channel..."

    # Upgrade NixOS to Unstable
    sudo nix-channel --add https://nixos.org/channels/nixos-unstable nixos
    sudo nix-channel --update

    # Rebuild NixOS with the new configuration
    sudo nixos-rebuild switch --upgrade
    echo "NixOS upgraded."
}

# Menu
while true; do
    echo "Select an operation:"
    echo "1. Upgrade NixOS to Unstable"
    echo "2. Exit"
    read -p "Enter your choice [1-2]: " choice

    case $choice in
        1) upgrade_nixos_and_add_channel ;;
        2) break ;;
        *) echo "Invalid option. Please try again." ;;
    esac
done
