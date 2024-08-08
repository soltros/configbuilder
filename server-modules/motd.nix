{ config, pkgs, ... }:

{
  users.motd = ''
    *************************************************************
    *                    Welcome to ${config.networking.hostName}                    *
    *************************************************************
    *  This is a NixOS server, running on ${pkgs.linuxPackages.kernel.version}  *
    ''
  ;
}
