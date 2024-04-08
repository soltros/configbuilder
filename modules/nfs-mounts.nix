{ config, pkgs, lib, ... }:

let
  serverHostNameOrIP = "nixos-server"; # Replace with your NFS server's hostname or IP address
in
{
  fileSystems."/mnt/Sync" = {
    device = "${serverHostNameOrIP}:/export/Sync";
    fsType = "nfs";
    options = [ "defaults" ];
  };

  fileSystems."/mnt/Desktop-Backup" = {
    device = "${serverHostNameOrIP}:/export/Desktop-Backup";
    fsType = "nfs";
    options = [ "defaults" ];
  };

  fileSystems."/mnt/Laptop-Backup" = {
    device = "${serverHostNameOrIP}:/export/Laptop-Backup";
    fsType = "nfs";
    options = [ "defaults" ];
  };

  # Assuming NFS client services are needed
  services.nfs.client.enable = true;

  # Optional: Configure networking firewall to allow NFS, if necessary
  # networking.firewall.allowedTCPPorts = [ 2049 ]; # Adjust based on your NFS setup
  # networking.firewall.allowedUDPPorts = [ 2049 ]; # Adjust based on your NFS setup
}
