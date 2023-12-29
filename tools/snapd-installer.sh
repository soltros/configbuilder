#!/bin/bash

# Download the Nix-Snapd files
git clone https://github.com/io12/nix-snapd.git

# Upgrade NixOS to Unstable.
echo "Running this installer assumes you do not have snapd.nix from Configbuilder enabled."
echo "Ensure you have flake-support.nix enabled to build."
echo "Snap packages for NixOS require NixOS Unstable. Upgrading..."
sudo nix-channel --add https://nixos.org/channels/nixos-unstable nixos
sudo nix-channel --update
sudo nixos-rebuild switch --upgrade

# Ask the user for their hostname
read -p "Enter the new hostname: " new_hostname

# The flake content
flake_content='{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-snapd.url = "github:io12/nix-snapd";
    nix-snapd.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, nix-snapd }: {
    nixosConfigurations.my-hostname = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        nix-snapd.nixosModules.default
        {
          services.snap.enable = true;
        }
      ];
    };
  };
}'

# Writing to a file
echo "$script_content" > $HOME/nix-snapd/flake.nix

# Path to flake.nix file
FLAKE_FILE="$HOME/nix-snapd/flake.nix"

# Replace 'my-hostname' with the user-provided hostname in flake.nix
sed -i "s/my-hostname/$new_hostname/g" "$FLAKE_FILE"

echo "flake.nix has been updated with the new hostname: $new_hostname"

# Enter the Nix-Snapd directory
cd nix-snapd/

# Build the module

nix build
