{ config, pkgs, ... }:

{
  options.services.nix-software-center = {
    enable = mkEnableOption "nix-software-center";

    package = mkOption {
      type = types.package;
      default = pkgs.nix-software-center;
      description = "The nix-software-center package to use.";
    };
  };

  config = mkIf config.services.nix-software-center.enable {
    environment.systemPackages = [ config.services.nix-software-center.package ];

    # Additional configuration can be added here
    # For example, setting up any required services or dependencies
  };
}
