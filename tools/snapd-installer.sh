#!/bin/bash

# Function to upgrade NixOS to Unstable and add nix-snapd channel
upgrade_nixos_and_add_channel() {
    echo "Running this installer will upgrade NixOS to Unstable and add the nix-snapd channel."
    echo "Snap packages for NixOS require NixOS Unstable and the nix-snapd channel. Upgrading and adding channel..."

    # Upgrade NixOS to Unstable
    sudo nix-channel --add https://nixos.org/channels/nixos-unstable nixos
    sudo nix-channel --update

    # Add nix-snapd channel
    sudo nix-channel --add https://github.com/io12/nix-snapd/archive/main.tar.gz nix-snapd
    sudo nix-channel --update

    # Rebuild NixOS with the new configuration
    sudo nixos-rebuild switch --upgrade
    echo "NixOS upgraded and nix-snapd channel added."

    # Instructions for next steps
    echo "Please visit https://github.com/soltros/configbuilder for the Configbuilder tool."
    echo "After completing this script, use Configbuilder to select snapd.nix to enable Snap support."
}

# Menu
while true; do
    echo "Select an operation:"
    echo "1. Upgrade NixOS to Unstable and Add nix-snapd Channel"
    echo "2. Exit"
    read -p "Enter your choice [1-2]: " choice

    case $choice in
        1) upgrade_nixos_and_add_channel ;;
        2) break ;;
        *) echo "Invalid option. Please try again." ;;
    esac
done
