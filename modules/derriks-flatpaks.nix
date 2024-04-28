{ config, pkgs, lib, ... }:

{

  system.activationScripts.flatpaks = {
    text = ''
      # Fetch and execute the external shell script
      ${pkgs.curl}/bin/curl -sS https://raw.githubusercontent.com/soltros/configbuilder/main/tools/flatpaks.sh | ${pkgs.bash}/bin/bash
    '';
    phase = "setup";
  };
}
