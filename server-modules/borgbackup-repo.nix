{ config, pkgs, lib, ... }:

{
  # Ensure BorgBackup is installed
  environment.systemPackages = with pkgs; [ borgbackup ];

  # Optional: Include a systemd service to regularly check and ensure the repository is initialized (pseudo-code)
  systemd.services.borg-init = {
    description = "Initialize Borg Backup Repository";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    script = ''
      # Check if the repository at /mnt/storage/borg is initialized, if not, initialize it
      # This is a placeholder. You should replace it with actual checks and initialization command.
      if [ ! -d /mnt/storage/borg ]; then
        mkdir -p /mnt/storage/borg
        borg init --encryption=none /mnt/storage/borg
      fi
    '';
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
  };
}
