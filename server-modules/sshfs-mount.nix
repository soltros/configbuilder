{ config, pkgs, lib, ... }:

let
  user = "derrik";
  localMountPoint = "/mnt/borg";
  remoteStoragePath = "/mnt/storage/borg";
  remoteHost = "nixos-server";
in
{
  # Ensure the sshfs package is available
  environment.systemPackages = with pkgs; [ sshfs ];

  # Automount the remote folder
  systemd.services.sshfsMount = {
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    script = ''
      # Ensure the mount point directory exists
      mkdir -p ${localMountPoint}

      # Fix permissions to allow 'derrik' to access the mount point
      chown ${user}:${user} ${localMountPoint}

      # Mount the remote folder
      sshfs ${user}@${remoteHost}:${remoteStoragePath} ${localMountPoint} -o reconnect,ServerAliveInterval=15,ServerAliveCountMax=3,follow_symlinks,IdentityFile=/home/${user}/.ssh/id_rsa
    '';
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      User = user;
      ExecStop = "${pkgs.coreutils}/bin/umount -f ${localMountPoint}";
    };
  };

  # Ensure the mount directory is created and owned by 'derrik'
  systemd.tmpfiles.rules = [
    "d ${localMountPoint} 0755 ${user} ${user} -"
  ];

  # Optional: Configure SSH options for user 'derrik' for key-based authentication
  users.users.${user} = {
    openssh.authorizedKeys.keys = [ "your_public_ssh_key_here" ];
    # Ensure the user has an SSH key at ~/.ssh/id_rsa or specify another key with the sshfs command
  };
}
