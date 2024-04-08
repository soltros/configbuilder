{ config, lib, pkgs, ... }:

let
  cfg = config.services.nfs.server;
in
{
  # Assuming the declaration of `options` and their types occurs elsewhere, typically in a module definition.
  # Here we directly configure the NFS server without redefining options.

  # Bind-mount directories to be shared via NFS
  config.fileSystems."/export/media-server-overflow-1" = {
    device = "/mnt/storage-3/media-server-overflow-1";
    fsType = "none";
    options = [ "bind" ];
  };
  config.fileSystems."/export/media-server-overflow-2" = {
    device = "/mnt/storage/media-server-overflow-2";
    fsType = "none";
    options = [ "bind" ];
  };
  config.fileSystems."/export/Sync" = {
    device = "/mnt/storage-3/syncthing/sync";
    fsType = "none";
    options = [ "bind" ];
  };
  config.fileSystems."/export/Desktop-Backup" = {
    device = "/mnt/storage-3/backups/desktop";
    fsType = "none";
    options = [ "bind" ];
  };
  config.fileSystems."/export/Laptop-Backup" = {
    device = "/mnt/storage/backups/laptop";
    fsType = "none";
    options = [ "bind" ];
  };

  # Enable NFS server and apply exports configuration
  config.services.nfs.server.enable = true;
  config.services.nfs.server.exports = ''
    /export/media-server-overflow-1  *(rw,no_subtree_check,sync)
    /export/media-server-overflow-2  *(rw,no_subtree_check,sync)
    /export/Sync *(rw,no_subtree_check,sync)
    /export/Desktop-Backup *(rw,no_subtree_check,sync)
    /export/Laptop-Backup *(rw,no_subtree_check,sync)
  '';

  # Opening NFS ports in the firewall
  config.networking.firewall.allowedTCPPorts = [ 2049 ]; # For NFSv4
  config.networking.firewall.allowedUDPPorts = [ 2049 ]; # For NFSv4
  # Ensure to open additional ports if necessary for NFSv3 compatibility
}
