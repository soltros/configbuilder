{ config, pkgs, ... }:

{
  services.displayManager.lightdm = {
    enable = true;
    greeters.gtk = {
      enable = true;
    };
  };
  services.xserver = {
    enable = true;
  };
}
