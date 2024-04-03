{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Ensure sshfs is available globally
    #sshfs
  ];

  systemd.services = {
    sshfs-laptop-backups = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
      script = "/nix/store/j29pq9clj3rlakc5w4wh7x3mpix6fs5p-system-path/bin/sshfs derrik@nixos-server:/mnt/storage/backups/laptop /home/derrik/Backups/Laptop -o reconnect,ServerAliveInterval=15,ServerAliveCountMax=3,IdentityFile=/home/derrik/.ssh/id_rsa";
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStop = "/run/current-system/sw/bin/umount /home/derrik/Backups/Laptop";
        User = "derrik";
      };
    };
    sshfs-desktop-backups = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
      script = "/nix/store/j29pq9clj3rlakc5w4wh7x3mpix6fs5p-system-path/bin/sshfs derrik@nixos-server:/mnt/storage-3/backups/desktop /home/derrik/Backups/Desktop -o reconnect,ServerAliveInterval=15,ServerAliveCountMax=3,IdentityFile=/home/derrik/.ssh/id_rsa";
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStop = "/run/current-system/sw/bin/umount /home/derrik/Backups/Desktop";
        User = "derrik";
      };
    };
    sshfs-syncthing-sync = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
      script = "/nix/store/j29pq9clj3rlakc5w4wh7x3mpix6fs5p-system-path/bin/sshfs derrik@nixos-server:/mnt/storage-3/syncthing/sync /home/derrik/Sync -o reconnect,ServerAliveInterval=15,ServerAliveCountMax=3,IdentityFile=/home/derrik/.ssh/id_rsa";
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStop = "/run/current-system/sw/bin/umount /home/derrik/Sync";
        User = "derrik";
      };
    };
  };
}
