{ config, pkgs, ... }:
{
  services.syncthing = {
    enable = true;
    user = "derrik"; # Replace with your preferred user
    dataDir = "/mnt/merged/containers/syncthing/data1"; # Adjust as per your setup
    configDir = "/mnt/merged/containers/syncthing/config"; # Adjust as per your setup

    extraOptions = {
      environment.PUID = "1000";
      environment.PGID = "1000";
      environment.TZ = "America/Detroit";

      gui = {
        address = "0.0.0.0:8384";
        user = "username"; # Set your GUI username
        password = "password"; # Set your GUI password
      };
    };

    settings = {
      overrideFolders = true;
      folders = {
        "data1" = { path = "/mnt/merged/containers/syncthing/data1"; };
        "data2" = { path = "/mnt/merged/containers/syncthing/data2"; };
        "backups" = { path = "/mnt/merged/containers/syncthing/backups"; };
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ 8384 22000 ];
  networking.firewall.allowedUDPPorts = [ 21027 22000 ];
}

