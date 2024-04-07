{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Ensure sshfs is available globally
    sshfs
  ];

  systemd.services = {
    sshfs-laptop-backups = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
      requires = [ "network-online.target" ];
      serviceConfig = {
        Type = "forking";
        User = "derrik";
        ExecStart = "${pkgs.sshfs}/bin/sshfs derrik@nixos-server:/mnt/storage/backups/laptop /home/derrik/Backups/Laptop -o reconnect,ServerAliveInterval=15,ServerAliveCountMax=3,IdentityFile=/home/derrik/.ssh/id_rsa";
        ExecStop = "${pkgs.coreutils}/bin/umount /home/derrik/Backups/Laptop";
        RemainAfterExit = true;
        Restart = "on-failure";
        RestartSec = 5;
      };
    };
    sshfs-desktop-backups = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
      requires = [ "network-online.target" ];
      serviceConfig = {
        Type = "forking";
        User = "derrik";
        ExecStart = "${pkgs.sshfs}/bin/sshfs derrik@nixos-server:/mnt/storage-3/backups/desktop /home/derrik/Backups/Desktop -o reconnect,ServerAliveInterval=15,ServerAliveCountMax=3,IdentityFile=/home/derrik/.ssh/id_rsa";
        ExecStop = "${pkgs.coreutils}/bin/umount /home/derrik/Backups/Desktop";
        RemainAfterExit = true;
        Restart = "on-failure";
        RestartSec = 5;
      };
    };
    sshfs-syncthing-sync = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
      requires = [ "network-online.target" ];
      serviceConfig = {
        Type = "forking";
        User = "derrik";
        ExecStart = "${pkgs.sshfs}/bin/sshfs derrik@nixos-server:/mnt/storage-3/syncthing/sync /home/derrik/Sync -o reconnect,ServerAliveInterval=15,ServerAliveCountMax=3,IdentityFile=/home/derrik/.ssh/id_rsa";
        ExecStop = "${pkgs.coreutils}/bin/umount /home/derrik/Sync";
        RemainAfterExit = true;
        Restart = "on-failure";
        RestartSec = 5;
      };
    };
  };
}
