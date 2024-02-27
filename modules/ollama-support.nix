{ config, pkgs, lib, ... }:

let
  cfg = config.services.ollama;
in
{
  options.services.ollama = {
    enable = lib.mkEnableOption "Ollama service";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.ollama;
      description = "The package that provides the ollama binary.";
    };
  };

  config = lib.mkIf cfg.enable {
    users.users.ollama = {
      isNormalUser = true;
      uid = if config.users.mutableUsers then "ollama" else null;
      group = "ollama";
    };

    users.groups.ollama = {};

    systemd.services.ollama = {
      description = "Ollama Service";
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];

      serviceConfig = {
        ExecStart = "${cfg.package}/bin/ollama serve";
        User = "ollama";
        Group = "ollama";
        Restart = "always";
        RestartSec = 3;
      };

      wantedBy = [ "multi-user.target" ]; # Typically, services should be wanted by multi-user.target unless it's a graphical service, which then `default.target` is used.
    };
  };
}
