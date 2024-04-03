{ config, pkgs, lib, ... }:

let
  mkSshfsMount = { name, host, remotePath, localPath, user, sshUser, options ? "" }: {
    systemd.tmpfiles.rules = [
      "d '${localPath}' 0755 ${user} users -"
    ];

    systemd.mounts = [
      {
        name = name;
        what = "${sshUser}@${host}:${remotePath}";
        where = localPath;
        wantedBy = [ "multi-user.target" ];
        fsType = "fuse.sshfs";
        options = [ "defaults" "noauto" "x-systemd.automount" "IdentityFile=/home/${user}/.ssh/id_rsa" options ];
      }
    ];
  };
in
{
  options = {
    sshfsMounts = lib.mkOption {
      type = lib.types.listOf (lib.types.submodule {
        options = {
          name = lib.mkOption {
            type = lib.types.str;
            description = "The name of the mount, used to generate the unit file name.";
          };
          host = lib.mkOption {
            type = lib.types.str;
            description = "SSH host to mount.";
          };
          remotePath = lib.mkOption {
            type = lib.types.str;
            description = "Remote path to mount.";
          };
          localPath = lib.mkOption {
            type = lib.types.path;
            description = "Local path where the remote path will be mounted.";
          };
          user = lib.mkOption {
            type = lib.types.str;
            description = "Local system user that will own the mount point.";
          };
          sshUser = lib.mkOption {
            type = lib.types.str;
            description = "SSH user for connecting to the SSH server.";
          };
          options = lib.mkOption {
            type = lib.types.str;
            default = "";
            description = "Additional SSHFS mount options.";
          };
        };
      });
      default = [];
      description = "List of SSHFS mounts.";
    };
  };

  config = {
    systemd.tmpfiles.rules = lib.mkBefore [ ];
    systemd.mounts = lib.mkBefore [ ];

    sshfsMounts = [
      {
        name = "laptop-backups";
        host = "your-ssh-host.com";
        remotePath = "/mnt/storage/backups/laptop";
        localPath = "/home/derrik/Backups/Laptop";
        user = "derrik"; # Local system user
        sshUser = "derrik"; # SSH user
        options = "reconnect,ServerAliveInterval=15,ServerAliveCountMax=3";
      }
      {
        name = "desktop-backups";
        host = "nixos-server";
        remotePath = "/mnt/storage-3/backups/desktop";
        localPath = "/home/derrik/Backups/Desktop";
        user = "derrik"; # Local system user
        sshUser = "derrik"; # SSH user
        options = "reconnect,ServerAliveInterval=15,ServerAliveCountMax=3";
      }
      {
        name = "syncthing-sync";
        host = "nixos-server";
        remotePath = "/mnt/storage-3/syncthing/sync";
        localPath = "/home/derrik/Sync";
        user = "derrik"; # Local system user
        sshUser = "derrik"; # SSH user
        options = "reconnect,ServerAliveInterval=15,ServerAliveCountMax=3";
      }
    ];
  };
}
