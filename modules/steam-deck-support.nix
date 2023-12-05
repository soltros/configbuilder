{ config, pkgs, lib, home-manager, ... }:

let
  # Fetch the "development" branch of the Jovian-NixOS repository
  jovian-nixos = builtins.fetchGit {
    url = "https://github.com/Jovian-Experiments/Jovian-NixOS";
    ref = "development";
  };

in {
  imports = [
    "${jovian-nixos}/modules"
    home-manager.nixosModule
  ];

  jovian = {
    steam.enable = true;
    devices.steamdeck = {
      enable = true;
    };
  };

  services.xserver.displayManager.gdm.wayland = lib.mkForce true;
  services.xserver.displayManager.defaultSession = "gamescope-wayland";
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "deck";

  # Enable GNOME
  sound.enable = true;
  services.xserver.desktopManager.gnome = {
    enable = true;
  };

  # Create user "deck"
  users.users.deck = {
    isNormalUser = true;
    description = "SteamOS";
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
    home-manager
  ];

  # GNOME settings through home-manager
  home-manager.users.deck = {
    dconf.settings = {
      "org/gnome/desktop/a11y/applications" = {
        screen-keyboard-enabled = true; # Enable on-screen keyboard
      };
      "org/gnome/shell" = {
        favorite-apps = ["steam.desktop"];
      };
    };
  };
}
