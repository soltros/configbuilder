#!/bin/bash

# Define variables
JOVIAN_ZIP_URL="https://github.com/Jovian-Experiments/Jovian-NixOS/archive/refs/heads/development.zip"
JOVIAN_DIR="Jovian-NixOS"
CONFIGURATION_FILE="configuration.nix"
LIVECD_CONFIG_FILE="livecd.nix"

# Download and extract the Jovian-NixOS-development.zip file
wget $JOVIAN_ZIP_URL -O jovian-nixos.zip
unzip jovian-nixos.zip -d .
JOVIAN_DIR="$(pwd)/Jovian-NixOS-development" # Adjust based on the actual directory structure in the ZIP

# Create the custom configuration.nix file
cat > $CONFIGURATION_FILE << EOF
{ config, pkgs, lib, ... }:

let
  myUsername = "deck";
  myUserdescription = "SteamOS";
  jovian-nixos = import "${JOVIAN_DIR}"; # Use the absolute path
in {
  imports = [ "\${jovian-nixos}/modules" ]; 

  jovian = {
    steam.enable = true;
    devices.steamdeck = {
      enable = true;
    };
  };

  services.xserver.displayManager.gdm.wayland = lib.mkForce true;
  services.xserver.displayManager.defaultSession = "gamescope-wayland";
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = myUsername;

  sound.enable = true;
  services.xserver.desktopManager.gnome = {
    enable = true;
  };

  users.users.\${myUsername} = {
    isNormalUser = true;
    description = myUserdescription;
  };

  systemd.services.gamescope-switcher = {
    wantedBy = [ "graphical.target" ];
    serviceConfig = {
      User = 1000;
      PAMName = "login";
      WorkingDirectory = "~";

      TTYPath = "/dev/tty7";
      TTYReset = "yes";
      TTYVHangup = "yes";
      TTYVTDisallocate = "yes";

      StandardInput = "tty-fail";
      StandardOutput = "journal";
      StandardError = "journal";

      UtmpIdentifier = "tty7";
      UtmpMode = "user";

      Restart = "always";
    };

    script = ''
      set-session () {
        mkdir -p ~/.local/state
        >~/.local/state/steamos-session-select echo "$1"
      }
      consume-session () {
        if [[ -e ~/.local/state/steamos-session-select ]]; then
          cat ~/.local/state/steamos-session-select
          rm ~/.local/state/steamos-session-select
        else
          echo "gamescope"
        fi
      }
      while :; do
        session=$(consume-session)
        case "$session" in
          plasma)
            dbus-run-session -- gnome-shell --display-server --wayland
            ;;
          gamescope)
            steam-session
            ;;
        esac
      done
    '';
  };

  environment.systemPackages = with pkgs; [
    gnome.gnome-terminal
    jupiter-dock-updater-bin
    steamdeck-firmware
  ];
}
EOF

# Create the livecd.nix file
cat > $LIVECD_CONFIG_FILE << EOF
{ config, pkgs, ... }:

{
  imports = [
    ./$CONFIGURATION_FILE
  ];

  boot.supportedFilesystems = [ "ext4" ];
  services.xserver.enable = true;
  networking.networkmanager.enable = true;

  environment.systemPackages = with pkgs; [
    # Additional packages
  ];
}
EOF

# Build the Live CD
nix-shell -p nixos-generators --run "nixos-generate -f iso -c $LIVECD_CONFIG_FILE"
