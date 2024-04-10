{ config, pkgs, lib, ... }:

{
  # Required for NFS operations
  services.rpcbind.enable = true;

  # Systemd mounts configuration
  systemd.mounts = [
    # Mount configuration for "/mnt/Sync"
    {
      where = "/mnt/Sync";
      what = "nixos-server:/export/Sync";
      type = "nfs";
      options = "nofail,nfsvers=4.2,noatime";
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
    }
    # Mount configuration for "/mnt/Desktop-Backup"
    {
      where = "/mnt/Desktop-Backup";
      what = "nixos-server:/export/Desktop-Backup";
      type = "nfs";
      options = "nofail,nfsvers=4.2,noatime";
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
    }
    # Mount configuration for "/mnt/Laptop-Backup"
    {
      where = "/mnt/Laptop-Backup";
      what = "nixos-server:/export/Laptop-Backup";
      type = "nfs";
      options = "nofail,nfsvers=4.2,noatime";
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
    }
  ];

  # Systemd automounts configuration
  systemd.automounts = [
    # Automount configuration for "/mnt/Sync"
    {
      where = "/mnt/Sync";
      wantedBy = [ "multi-user.target" ];
      automountConfig.TimeoutIdleSec = "600";
    }
    # Automount configuration for "/mnt/Desktop-Backup"
    {
      where = "/mnt/Desktop-Backup";
      wantedBy = [ "multi-user.target" ];
      automountConfig.TimeoutIdleSec = "600";
    }
    # Automount configuration for "/mnt/Laptop-Backup"
    {
      where = "/mnt/Laptop-Backup";
      wantedBy = [ "multi-user.target" ];
      automountConfig.TimeoutIdleSec = "600";
    }
  ];
}
