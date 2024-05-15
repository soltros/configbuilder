{ config, pkgs, lib, ... }:

{
  # Install the nfs-utils package
  environment.systemPackages = with pkgs; [ nfs-utils ];

  # Enable the RPC bind service, which is required for NFS client operations
  services.rpcbind.enable = true;
}
