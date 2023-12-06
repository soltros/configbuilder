{ config, pkgs, ... }:

{
  # Enable ZRAM support
  boot.kernelModules = [ "zram" ];
  boot.initrd.availableKernelModules = [ "zram" ];
  boot.initrd.kernelModules = [ "zram" ];
  boot.kernelParams = [ "zram.num_devices=1" ];

  # Configure ZRAM device
  systemd.services = {
    zram-setup = {
      description = "Set up zram swap device";
      script = ''
        # Create a zram device
        echo ${toString (4 * 1024 * 1024 * 1024)} > /sys/block/zram0/disksize # 4GB

        # Set up the zram device as swap
        mkswap /dev/zram0
        swapon /dev/zram0
      '';
      wantedBy = [ "multi-user.target" ];
      after = [ "sysinit.target" ];
      requires = [ "sysinit.target" ];
    };
  };
}
