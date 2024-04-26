{ config, lib, pkgs, ... }:

let
  cfg = config.services.myFlatpaks;
in
{
  options.services.myFlatpaks = {
    enable = lib.mkEnableOption "Custom Flatpak management";
    flatpakList = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ "io.kopia.KopiaUI" "com.slack.Slack" "com.valvesoftware.Steam" ];  # Default list of Flatpaks
      example = [ "io.kopia.KopiaUI" "com.slack.Slack" "com.valvesoftware.Steam" ];
      description = "List of Flatpak applications to install from Flathub.";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.flatpak.enable = true;

    environment.systemPackages = with pkgs; [
      (writeScriptBin "install-flatpaks" ''
        #!/bin/sh
        # Add Flathub if it's not already registered
        flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
        # Install applications
        for app in ${lib.concatStringsSep " " cfg.flatpakList}; do
          flatpak install flathub $app -y
        done
      '')
    ];

    systemd.services.install-flatpaks = {
      description = "Install Flatpak applications";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = "${pkgs.writeScriptBin "install-flatpaks" ''...''}/bin/install-flatpaks";
      };
    };
  };
}
