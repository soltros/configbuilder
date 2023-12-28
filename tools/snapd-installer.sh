#!/bin/bash


## Upgrade NixOS to Unstable.
echo "Running this installer assumes you have do not have snapd.nix from Configbuilder enabled. Your system will not build with this enabled. Please enable snapd.nix once everything is done. "
xdg-open https://raw.githubusercontent.com/soltros/configbuilder/main/modules/snapd.nix
xdg-open https://github.com/soltros/configbuilder
echo " "
echo "Snap packages for NixOS requires NixOS Unstable. Upgrading...."
sudo nix-channel --add https://nixos.org/channels/nixos-unstable nixos
sudo nix-channel --update
sudo nixos-rebuild switch --upgrade

## Download the Nix-Snapd files
git clone https://github.com/io12/nix-snapd.git

## Enter the Nix-Snapd dir
cd nix-snapd/

## Build the module
sudo nix build
