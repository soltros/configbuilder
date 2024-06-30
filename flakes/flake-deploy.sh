#!/bin/bash

# Function to display the menu
show_menu() {
    echo "Select an Option:"
    echo "1) Option 1: Download Flake files and setup directory"
    echo "2) Option 2: Setup Nixpkg.py"
    echo "3) Option 3: Update NixOS"
    echo "4) Option 4: Deploy flake"
    echo "5) Exit"
}

# Function to execute the selected command
execute_command() {
    case $choice in
        1)
            cd /etc/nixos/ || { echo "Failed to change directory to /etc/nixos/"; return; }
            git init
            git add .
            git commit -m "Initial commit"
            git config --global user.email "soltros@proton.me"
            git config --global user.name "Derrik Diener"
            wget https://raw.githubusercontent.com/soltros/configbuilder/main/flakes/flake.nix.desktop -O flake.nix
            wget https://raw.githubusercontent.com/soltros/nixconfigs/main/misc/nix-cleanup.sh
            wget https://raw.githubusercontent.com/soltros/configbuilder/main/flakes/configuration.nix
            chmod +x nix-cleanup.sh
            echo "Setting up flake..."
            ;;
        2)
            curl https://raw.githubusercontent.com/soltros/nixpkg.py/main/tools/install.sh | bash
            curl https://raw.githubusercontent.com/soltros/nixpkg.py/main/update.sh | bash
            echo "Setting up Nixpkg.py package manager..."
            ;;
        3)
            python /home/derrik/scripts/nixpkg.py update
            echo "Updating NixOS..."
            ;;
        4)
            sudo nixos-rebuild switch --flake /etc/nixos#b450m-d3sh
            echo "Deploying flake..."
            ;;
        5)
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "Invalid selection. Please try again."
            ;;
    esac
}

# Main loop to display the menu and execute commands
while true; do
    show_menu
    read -rp "Enter your choice: " choice
    execute_command
done
