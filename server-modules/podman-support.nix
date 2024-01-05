{ config, pkgs, ... }:

{
  # Podman support
  virtualisation.podman = {
    enable = true;

    # Create a `docker` alias for podman
    dockerCompat = true;

    # Enable DNS for container communication under podman-compose
    defaultNetwork.settings.dns_enabled = true;
    # Uncomment the following for NixOS versions > 22.11
    #defaultNetwork.settings = {
    #  dns_enabled = true;
    #};
  };
}

