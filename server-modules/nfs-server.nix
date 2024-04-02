{ config, lib, pkgs, ... }:

with lib;

{
  # Bind-mount directories to be shared via NFS
  fileSystems = {
    "/export/media-server-overflow-1" = {
      device = "/mnt/storage-3/media-server-overflow-1";
      fsType = "none";
      options = [ "bind" ];
    };
    "/export/media-server-overflow-2" = {
      device = "/mnt/storage/media-server-overflow-2";
      fsType = "none";
      options = [ "bind" ];
    };
  };

  # Configuration for the NFS server
  config = {
    services.nfs.server.enable = true;
    services.nfs.server.exports = ''
      /export/media-server-overflow-1  *(rw,fsid=0,no_subtree_check,sync)
      /export/media-server-overflow-2  *(rw,fsid=0,no_subtree_check,sync)
    '';

    # Opening NFS ports in the firewall
    networking.firewall.allowedTCPPorts = [ 2049 ]; # NFSv4
    networking.firewall.allowedUDPPorts = [ 2049 ]; # NFSv4
    # Add additional ports as necessary for NFSv3 compatibility
  };
}
