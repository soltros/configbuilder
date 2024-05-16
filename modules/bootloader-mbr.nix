{ config, pkgs, ... }:

{
  boot.loader.grub = {
    enable = true;
    devices = [ "/dev/sda" ];
    efiSupport = false;
    timeout = 5;
  };
}
