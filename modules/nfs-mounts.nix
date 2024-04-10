{ config, pkgs, lib, ... }:

{
  # Ensure rpcbind, which is required for NFS, is enabled
  services.rpcbind.enable = true;

  # Define the NFS mounts using systemd.mounts for more granular control
  # and to leverage systemd's native mechanisms for handling network dependencies
  systemd.mounts = let
    # Define common options for NFS mounts to avoid repetition
    commonMountOptions = {
      type = "nfs";
      mountConfig.Options = "noatime,nfsvers=4.2"; # Example options, adjust as needed
    };
  in
  [
    # Mount configuration for each NFS share
    (commonMountOptions // {
      what = "nixos-server:/export/Sync";
      where = "/mnt/Sync";
    })
    (commonMountOptions // {
      what = "nixos-server:/export/Desktop-Backup";
      where = "/mnt/Desktop-Backup";
    })
    (commonMountOptions // {
      what = "nixos-server:/export/Laptop-Backup";
      where = "/mnt/Laptop-Backup";
    })
  ];

  # Use systemd.automounts for lazy-mounting if desired
  # This is useful if you want to ensure the mounts are only attempted when accessed,
  # which can be beneficial in environments with potentially unstable network connections at boot
  systemd.automounts = [
    {
      where = "/mnt/Sync";
      automountConfig.TimeoutIdleSec = "600"; # Example, adjust as needed
    }
    {
      where = "/mnt/Desktop-Backup";
      automountConfig.TimeoutIdleSec = "600"; # Example, adjust as needed
    }
    {
      where = "/mnt/Laptop-Backup";
      automountConfig.TimeoutIdleSec = "600"; # Example, adjust as needed
    }
  ].map (opts: opts // { wantedBy = [ "multi-user.target" ]; }); # Ensure they are started at boot
}
