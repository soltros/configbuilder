{ config, pkgs, lib, ... }:
{
  services.syncthing = {
    enable = true;
    user = "derrik";
    dataDir = "/mnt/merged/syncthing/data1";
    configDir = "/mnt/merged/syncthing/config";

    settings = {
      environment.PUID = "1000";
      environment.PGID = "1000";
      environment.TZ = "America/Detroit";

      gui = {
        address = "0.0.0.0:8384";
        user = "admin";
        password = "YOUR_SECURE_PASSWORD";
      };

      # Include your folder configurations here
      overrideFolders = true;
      folders = {
        "data1" = { path = "/mnt/merged/syncthing/data1"; };
        "data2" = { path = "/mnt/merged/syncthing/data2"; };
        "backups" = { path = "/mnt/merged/syncthing/backups"; };
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ 8384 22000 ];
  networking.firewall.allowedUDPPorts = [ 21027 22000 ];

  systemd.services.syncthing.serviceConfig.ExecStart = lib.mkForce [
    ""
    "${pkgs.syncthing}/bin/syncthing -no-browser -gui-address=0.0.0.0:8384 -config=/mnt/merged/syncthing/config -data=/mnt/merged/syncthing/data1"
  ];
}
