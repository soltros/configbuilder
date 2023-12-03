{ config, pkgs, ... }:

{
  # Enable Nix command support for Flakes
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  # Additional configuration can be placed here
}
