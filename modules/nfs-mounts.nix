{ config, pkgs, lib, ... }:

{
  fileSystems."/mnt/Sync" = {
    device = "nixos-server:/export/Sync";
    fsType = lib.mkForce "nfs";
    options = [ "defaults" ];
  };

  fileSystems."/mnt/Desktop-Backup" = {
    device = "nixos-server:/export/Desktop-Backup";
    fsType = lib.mkForce "nfs";
    options = [ "defaults" ];
  };

  fileSystems."/mnt/Laptop-Backup" = {
    device = "nixos-server:/export/Laptop-Backup";
    fsType = lib.mkForce "nfs";
    options = [ "defaults" ];
  };

  # Assuming NFS client services are needed
  services.rpcbind.enable = true;

  # Optional: Configure networking firewall to allow NFS, if necessary
  # networking.firewall.allowedTCPPorts = [ 2049 ]; # Adjust based on your NFS setup
  # networking.firewall.allowedUDPPorts = [ 2049 ]; # Adjust based on your NFS setup
}
