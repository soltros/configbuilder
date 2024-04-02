{ config, pkgs, lib, ... }:
{
  services.syncthing = {
    enable = true;
    user = "derrik";
    dataDir = "/mnt/storage-3/syncthing";
    configDir = "/mnt/storage-3/syncthing";

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
        "computers" = { path = "/mnt/storage-3/syncthing/computers"; };
        "phone" = { path = "/mnt/storage-3/syncthing/phone"; };
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ 8384 22000 ];
  networking.firewall.allowedUDPPorts = [ 21027 22000 ];

  systemd.services.syncthing.serviceConfig.ExecStart = lib.mkForce [
    ""
    "${pkgs.syncthing}/bin/syncthing -no-browser -gui-address=0.0.0.0:8384 -config=/mnt/storage-3/syncthing/config -data=/mnt/storage-3/syncthing"
  ];
}
