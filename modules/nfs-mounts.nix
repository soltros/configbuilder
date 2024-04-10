{ config, pkgs, lib, ... }:

let
  createNfsMountService = name: device: {
    systemd.services.${"mount-nfs-" + name} = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
      requires = [ "network-online.target" ];
      script = ''
        # Ensure the mount point exists
        mkdir -p /mnt/${name}
        # Mount the NFS share
        mount -t nfs ${device} /mnt/${name}
      '';
      preStop = ''
        # Cleanly unmount the NFS share when the service stops
        umount /mnt/${name}
      '';
    };
  };
in
{
  # Enable necessary services for NFS
  services.rpcbind.enable = true;

  # Configure the NFS mount services for your specific shares
  systemd.services = {
    inherit (createNfsMountService "Sync" "nixos-server:/export/Sync");
    inherit (createNfsMountService "Desktop-Backup" "nixos-server:/export/Desktop-Backup");
    inherit (createNfsMountService "Laptop-Backup" "nixos-server:/export/Laptop-Backup");
  };
}
