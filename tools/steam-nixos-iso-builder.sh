#!/bin/bash

# Define variables
JOVIAN_DIR="Jovian-NixOS"
JOVIAN_ZIP="/path/to/Jovian-NixOS-development.zip" # Replace with the actual path to the zip file
CONFIGURATION_FILE="configuration.nix"
LIVECD_CONFIG_FILE="livecd.nix"

# Extract the Jovian-NixOS-development.zip file
unzip $JOVIAN_ZIP -d $JOVIAN_DIR

# Create the custom configuration.nix file
cat > $CONFIGURATION_FILE << EOF
{ config, pkgs, lib, ... }:

let
  myUsername = "deck";
  myUserdescription = "SteamOS";
  jovian-nixos = import "${JOVIAN_DIR}"; # Import the local Jovian-NixOS directory
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
