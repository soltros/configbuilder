{ config, pkgs, ... }:

{
  # Enable OpenSSH daemon
  services.openssh.enable = true;

  # Configure GnuPG
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # Additional configurations can be added here

  # Example: Enable SUID wrappers for specific programs
  # programs.mtr.enable = true; 
}
