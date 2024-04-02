{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.nfs;
in
{
  options.services.nfs = {
    enable = mkEnableOption "NFS server";

    shares = mkOption {
      type = types.listOf (types.submodule {
        options = {
          path = mkOption {
            type = types.path;
            description = "The file system path to share.";
          };
          hostOptions = mkOption {
            type = types.str;
            default = "rw,async,no_root_squash";
            description = "Export options for the host.";
          };
        };
      });
      default = [];
      example = literalExample ''
        [
          { path = "/mnt/storage-3/media-server-overflow-1/"; hostOptions = "ro,async"; }
          { path = "/mnt/storage/media-server-overflow-2/"; hostOptions = "ro,async"; }
        ]
      '';
      description = "List of file system paths to share via NFS.";
    };
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [ 111 2049 ];
    networking.firewall.allowedUDPPorts = [ 111 2049 ];
    services.nfs.server.enable = true;
    services.nfs.exports = map (share: ''
      ${share.path} ${share.hostOptions}
    '') cfg.shares;
  };
}
