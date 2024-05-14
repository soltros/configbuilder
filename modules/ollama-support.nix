{ config, lib, pkgs, ... }:

let
  cfg = config.services.ollama;
in
{
  options.services.ollama = {
    enable = lib.mkEnableOption "Ollama Service";

    # Additional options can be added here as needed.
    # For instance, customization for the ollama binary path or other settings.
  };

  config = lib.mkIf cfg.enable {
    systemd.services.ollama = {
      description = "Ollama Service";
      after = [ "network-online.target" ]; # Ensures service starts after network is up
      wantedBy = [ "multi-user.target" ]; # Ensures service is started at the appropriate runlevel

      serviceConfig = {
        ExecStart = "${pkgs.ollama}/bin/ollama serve"; # Starts ollama service
        User = "ollama"; # Runs under ollama user
        Group = "ollama"; # Runs under ollama group
        Restart = "always"; # Service is restarted on failure
        RestartSec = 3; # Delay before service restart
      };
    };

    # Ensures the ollama user and group exist
    users.users.ollama = {
      isSystemUser = true;
      extraGroups = [ "ollama" ]; # Ensure user is part of the ollama group
    };
    users.groups.ollama = {};
  };
}
