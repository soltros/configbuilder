{ config, pkgs, lib, ... }:

{
  # Ensure rpcbind, which is required for NFS, is enabled
  services.rpcbind.enable = true;

  # Directly defining mounts and automounts
  systemd.mounts = [
    {
      what = "nixos-server:/export/Sync";
      where = "/mnt/Sync";
      wantedBy = [ "multi-user.target" ];
      type = "nfs";
      options = "noatime,nfsvers=4.2";
    }
    {
      what = "nixos-server:/export/Desktop-Backup";
      where = "/mnt/Desktop-Backup";
      wantedBy = [ "multi-user.target" ];
      type = "nfs";
      options = "noatime,nfsvers=4.2";
    }
    {
      what = "nixos-server:/export/Laptop-Backup";
      where = "/mnt/Laptop-Backup";
      wantedBy = [ "multi-user.target" ];
      type = "nfs";
      options = "noatime,nfsvers=4.2";
    }
  ];

  systemd.automounts = [
    {
      where = "/mnt/Sync";
      wantedBy = [ "multi-user.target" ];
      automountConfig.TimeoutIdleSec = "600";
    }
    {
      where = "/mnt/Desktop-Backup";
      wantedBy = [ "multi-user.target" ];
      automountConfig.TimeoutIdleSec = "600";
    }
    {
      where = "/mnt/Laptop-Backup";
      wantedBy = [ "multi-user.target" ];
      automountConfig.TimeoutIdleSec = "600";
    }
  ];
}
