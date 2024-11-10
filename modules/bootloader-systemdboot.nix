{ config, pkgs, ... }:
{
  boot = {
    # Enable systemd-boot
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 10;        # Limit the number of configurations kept
        consoleMode = "max";           # Use maximum available console resolution
        editor = false;                # Disable boot entry editing for security
      };
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";  # Specify EFI mount point explicitly
      };
      timeout = 5;                     # Boot menu timeout in seconds
    };
    
    # Use latest kernel - fixed syntax
    kernelPackages = pkgs.linuxPackages_zen;  # or try these alternatives:
    # kernelPackages = pkgs.linuxPackages_latest;
    # kernelPackages = pkgs.linuxPackages_stable;
  };
}
