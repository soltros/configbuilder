{ config, pkgs, ... }:
{
  boot = {
    kernelPackages = pkgs.linuxPackages_zen;  # Zen kernel includes fsync patches

    # Optional: Additional kernel parameters for fsync
    kernelParams = [ 
      "fsync=1"
      "futex_combat=1"  # Can help with some games
    ];

    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 10;
        consoleMode = "max";
        editor = false;
      };
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };
      timeout = 5;
    };
  };

  # Optional but recommended: Enable gamemode
  programs.gamemode = {
    enable = true;
    settings = {
      custom = {
        start = "${pkgs.libnotify}/bin/notify-send 'GameMode started'";
        end = "${pkgs.libnotify}/bin/notify-send 'GameMode ended'";
      };
    };
  };
}
