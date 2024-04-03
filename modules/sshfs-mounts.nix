{ config, pkgs, lib, ... }:

{
  systemd.services = {
    sshfs-laptop-backups = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
      script = ''
        ${pkgs.openssh}/bin/sshfs derrik@nixos-server:/mnt/storage/backups/laptop /home/derrik/Backups/Laptop -o reconnect,ServerAliveInterval=15,ServerAliveCountMax=3,IdentityFile=/home/derrik/.ssh/id_rsa
      '';
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStop = "${pkgs.fusermount}/bin/fusermount -u /home/derrik/Backups/Laptop";
        User = "derrik";
      };
    };
    sshfs-desktop-backups = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
      script = ''
        ${pkgs.openssh}/bin/sshfs derrik@nixos-server:/mnt/storage-3/backups/desktop /home/derrik/Backups/Desktop -o reconnect,ServerAliveInterval=15,ServerAliveCountMax=3,IdentityFile=/home/derrik/.ssh/id_rsa
      '';
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStop = "${pkgs.fusermount}/bin/fusermount -u /home/derrik/Backups/Desktop";
        User = "derrik";
      };
    };
    sshfs-syncthing-sync = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
      script = ''
        ${pkgs.openssh}/bin/sshfs derrik@nixos-server:/mnt/storage-3/synthing/sync /home/derrik/Sync -o reconnect,ServerAliveInterval=15,ServerAliveCountMax=3,IdentityFile=/home/derrik/.ssh/id_rsa
      '';
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStop = "${pkgs.fusermount}/bin/fusermount -u /home/derrik/Sync";
        User = "derrik";
      };
    };
  };
}
