{ config, pkgs, ... }:

{
  # Power management settings
  services = {
    tlp = {
      enable = true; # TLP service for battery optimization
      extraConfig = ''
        # Add custom TLP configurations here
      '';
    };
  };

  # CPU frequency scaling settings
  powerManagement.cpuFreqGovernor = "powersave";
}
