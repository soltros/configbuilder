{ config, lib, pkgs, ... }:

{
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--max-age 3d";
  };
}

