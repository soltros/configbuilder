{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    (writeShellScriptBin "motd" ''
      #! /usr/bin/env bash
      echo "
      *Welcome to ${config.networking.hostName}
      *  This is a NixOS server, running on ${config.boot.kernelPackages.kernel.version}  
      *  Uptime: $(uptime -p)
      *  Load average: $(cat /proc/loadavg | awk '{print $1" "$2" "$3}')
      *  Memory usage: $(free -h | awk 'NR==2 {print $3" "$4}')
      "
    '')
  ];

  system.extraSystemBuilderCmds = ''
    echo "Ignoring errors for motd derivations"
    for file in /nix/store/*-motd.drv /nix/store/*-man-paths.drv /nix/store/*-motd_fish-completions.drv /nix/store/*-system-path.drv /nix/store/*-nixos-system-nixos-*.drv; do
      touch "$file"
    done
  '';
}
