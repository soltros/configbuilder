{ config, pkgs, lib, ... }:
{
  nixpkgs.config = {
    allowUnfree = true;  # This is the simplest approach if you want to allow all unfree packages
    
    # Or if you specifically want to allow only Steam-related packages:
    allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
      "steam"
      "steam-original"
      "steam-runtime"
      "steam-run"
    ];
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };
}
