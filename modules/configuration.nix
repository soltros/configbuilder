{ config, pkgs, ... }:
{
  imports =
    [
      ./hardware-configuration.nix
      ./bootloader.nix
      ./derriks-apps.nix
      ./networking.nix
      ./nvidia-support.nix
      ./pantheon-packages.nix
      ./pantheon.nix
      ./pipewire-support.nix
      ./podman-support.nix
      ./tailscale-support.nix
      ./timezone-localization.nix
      ./unfree-packages.nix
      ./user-account.nix
      ./virtualization-support.nix

    ];

  # Add your custom configurations here

  # This value determines the NixOS release with which your system is to be compatible.
  # Update it according to your NixOS version.
  system.stateVersion = "23.05"; # Edit according to your NixOS version
}
