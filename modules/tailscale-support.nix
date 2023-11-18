{ config, pkgs, ... }:

{
  # Tailscale support
  services.tailscale.enable = true;
  networking.firewall.checkReversePath = "loose";

}

