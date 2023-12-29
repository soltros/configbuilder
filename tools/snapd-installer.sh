#!/bin/bash

# Function to download the Nix-Snapd files
download_nix_snapd() {
    git clone https://github.com/io12/nix-snapd.git
}

# Function to upgrade NixOS to Unstable
upgrade_nixos() {
    echo "Running this installer assumes you do not have snapd.nix from Configbuilder enabled."
    echo "Ensure you have flake-support.nix enabled to build."
    echo "Snap packages for NixOS require NixOS Unstable. Upgrading..."
    sudo nix-channel --add https://nixos.org/channels/nixos-unstable nixos
    sudo nix-channel --update
    sudo nixos-rebuild switch --upgrade
}

# Function to set up the flake
setup_flake() {
    read -p "Enter the new hostname: " new_hostname

    flake_content='{
      description = "NixOS configuration";
      ... # (rest of the flake content)
    }'

    echo "$flake_content" > $HOME/nix-snapd/flake.nix

    FLAKE_FILE="$HOME/nix-snapd/flake.nix"
    sed -i "s/my-hostname/$new_hostname/g" "$FLAKE_FILE"
    echo "flake.nix has been updated with the new hostname: $new_hostname"
}

# Function to build the module
build_module() {
    cd nix-snapd/
    nix build
}

# Menu
while true; do
    echo "Select an operation:"
    echo "1. Download Nix-Snapd"
    echo "2. Upgrade NixOS to Unstable"
    echo "3. Setup flake"
    echo "4. Build module"
    echo "5. Exit"
    read -p "Enter your choice [1-5]: " choice

    case $choice in
        1) download_nix_snapd ;;
        2) upgrade_nixos ;;
        3) setup_flake ;;
        4) build_module ;;
        5) break ;;
        *) echo "Invalid option. Please try again." ;;
    esac
done
