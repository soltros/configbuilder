{ config, lib, pkgs, ... }:

{
  options = {
    # You could add custom options here if needed
  };

  config = {
    services.fstrim = {
      enable = true;
      interval = "weekly"; # Adjust as needed
    };
  };
}
