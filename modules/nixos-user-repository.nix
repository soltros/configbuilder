{ config, pkgs, ... }:

 # Search for packages: https://nur.nix-community.org/repos/
 # https://nur.nix-community.org/documentation/
 # https://github.com/nix-community/NUR
 
{
  nixpkgs.config.packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball {
      url = "https://github.com/nix-community/NUR/archive/master.tar.gz";
      sha256 = "0m99ny73dxw2x2bwb6xsc3vp20f8r34c0xxwk22jlp17l1i452lf";
    }) {
      inherit pkgs;
    };
  };
}
