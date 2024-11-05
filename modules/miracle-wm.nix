{ config, pkgs, ... }:

{
  programs.wayland.miracle-wm.enable = true;
  programs.xwayland.enable = true;
  #This module only works with NixOS 24.11+
}

