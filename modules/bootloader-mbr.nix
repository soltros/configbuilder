{ config, pkgs, ... }:

{
  # Enables the GRUB bootloader.
  boot.loader.grub.enable = true;

  # Specifies the device for the GRUB bootloader installation.
  # Replace '/dev/sdX' with the appropriate device identifier, e.g., '/dev/sda'.
  boot.loader.grub.devices = [ "/dev/sda" ]; 

  # Specifies that the system is not EFI-based.
  boot.loader.grub.efiSupport = false;

  # Optional: Set a custom GRUB menu background image.
  # boot.loader.grub.background = "/path/to/your/background.jpg";

  # Optional: Configure GRUB menu timeout (in seconds).
  boot.loader.grub.timeout = 5;

  # Optional: Set a custom GRUB theme.
  # boot.loader.grub.theme = pkgs.fetchurl {
  #   url = "https://example.com/theme.tar.gz";
  #   sha256 = "your-theme-sha256-hash";
  # };

  # Optional: Enable or disable generation of the GRUB 2 menu entries.
  # boot.loader.grub.generateGrubMenuEntries = true;
}
