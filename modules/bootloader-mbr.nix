{ config, lib, pkgs, ... }:

with lib;

{
  options = {
    boot.loader.grub.devices = mkOption {
      type = types.listOf types.str;
      description = "The devices on which the boot loader, GRUB, will be installed.";
    };

    boot.loader.grub.timeout = mkOption {
      type = types.int;
      description = "The timeout for the GRUB boot menu in seconds.";
      default = 5;
    };
  };

  config = {
    # Enables the GRUB bootloader.
    boot.loader.grub.enable = true;

    # Install GRUB to the specified devices
    boot.loader.grub.devices = [ "/dev/sda" ];

    # Disable EFI support for MBR systems
    boot.loader.grub.efiSupport = false;

    # Set the GRUB menu timeout
    boot.loader.grub.timeout = config.boot.loader.grub.timeout;
  };

  assertions = [
    {
      assertion = config.boot.loader.grub.devices != [ ];
      message = "You must set the option boot.loader.grub.devices to make the system bootable.";
    }
  ];
}
