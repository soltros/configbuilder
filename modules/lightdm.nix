{ config, pkgs, ... }:

{
  services.xserver = {
    enable = true;
    displayManager.lightdm = {
      enable = true;
      greeters.gtk = {
        enable = true;
      };
    };
  };
}
