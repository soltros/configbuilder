{ config, lib, pkgs, ... }:

let
  cfg = config.services.ollama;
in
{
  options.services.ollama = {
    enable = lib.mkEnableOption "Ollama Service";

    # You can add additional options here if needed
    # For example, to customize the path to the ollama binary or other settings
  };

  config = lib.mkIf cfg.enable {
    systemd.services.ollama = {
      description = "Ollama Service";
      after = [ "network-online.target" ];
      wantedBy = [ "default.target" ];

      serviceConfig = {
        ExecStart = "${pkgs.ollama}/bin/ollama serve";
        User = "ollama";
        Group = "ollama";
        Restart = "always";
        RestartSec = 3;
      };
    };

    # Ensure the ollama user and group exist
    users.users.ollama = {
      isSystemUser = true;
      group = "ollama";
    };
    users.groups.ollama = {};
  };
}
