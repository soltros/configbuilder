{ config, lib, pkgs, ... }:

let
  zramSizeMB = 4096; # Size in MB for a 4GB ZRAM device
in
{
  # Load the zram kernel module
  boot.kernelModules = [ "zram" ];
  boot.extraModprobeConfig = ''
    options zram num_devices=1
  '';

  # Set up the zram device
  systemd.services.zram = {
    description = "Setup ZRAM Swap Device";
    after = [ "sysinit.target" ];
    before = [ "swap.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = ''
        echo ${toString (zramSizeMB * 1024 * 1024)} > /sys/block/zram0/disksize
        mkswap /dev/zram0
        swapon /dev/zram0
      '';
      Type = "oneshot";
      RemainAfterExit = true;
    };
  };

  # Ensure swap is on
  swapDevices = [
    { device = "/dev/zram0"; }
  ];
}
