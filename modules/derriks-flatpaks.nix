{ config, pkgs, lib, ... }:

{
  system.activationScripts.customScript = lib.mkAfter [ "network-online.target" ] ''
    # Fetch and execute the external shell script
    ${pkgs.curl}/bin/curl -sS https://raw.githubusercontent.com/soltros/configbuilder/main/tools/flatpaks.sh | ${pkgs.bash}/bin/bash
  '';
}
