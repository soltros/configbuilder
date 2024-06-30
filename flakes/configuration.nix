{ config, pkgs, ... }:
{
  imports =
    [
      ./hardware-configuration.nix
      ./flake.nix
     
    ];

  # Add your custom configurations here

  # System packages
  environment.systemPackages = with pkgs; [
    efibootmgr refind
  ];

  # This value determines the NixOS release with which your system is to be compatible.
  # Update it according to your NixOS version.
  system.stateVersion = "24.05"; # Edit according to your NixOS version
}
