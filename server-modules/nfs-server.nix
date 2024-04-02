{ config, lib, pkgs, ... }:

with lib;

{
  # Configuration for NFS server
  options = {

    services.nfs.server.exports = mkOption {
      type = types.lines;
      default = "";
      example = literalExample ''
        /export/media-server-overflow-1  *(rw,fsid=0,no_subtree_check,sync)
        /export/media-server-overflow-2  *(rw,fsid=0,no_subtree_check,sync)
      '';
      description = "NFS exports, specifying directories and permissions.";
    };
  };

  config = {
    # Bind-mount directories to be shared via NFS
    fileSystems."/export/media-server-overflow-1" = {
      device = "/mnt/storage-3/media-server-overflow-1";
      fsType = "none";
      options = [ "bind" ];
    };
    fileSystems."/export/media-server-overflow-2" = {
      device = "/mnt/storage/media-server-overflow-2";
      fsType = "none";
      options = [ "bind" ];
    };

    # Enable NFS server and apply exports configuration
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
