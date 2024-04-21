{ config, pkgs, ... }:

{

nixpkgs.config.permittedInsecurePackages = [
                "electron-24.8.6"
                "electron-25.9.0"
              ];
}
