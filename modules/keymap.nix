{ config, pkgs, ... }:

{
  # Configure keymap in X11
  services.xserver = {
    xkb = {
      layout = "us";
      variant = ""; # Leave empty if you don't require a specific variant
    };
  };
}
