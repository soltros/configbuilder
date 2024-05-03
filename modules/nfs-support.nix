{ config, pkgs, lib, ... }:

{
  # Enable the NFS client
  services.nfs.client.enable = true;

  # Enable the RPC bind service, which is required for NFS client operations
  services.rpcbind.enable = true;
}
