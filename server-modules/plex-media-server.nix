{ config, pkgs, ... }:

{
  services.plex = {
    enable = true;
    openFirewall = true;
    
    # Uncomment and set the following options as needed
    # dataDir = "/path/to/plex/data"; # Directory for Plex data files
    # extraPlugins = [ "/path/to/plugin1" "/path/to/plugin2" ]; # Paths to extra Plex plugins
    # extraScanners = [ "/path/to/scanner1" "/path/to/scanner2" ]; # Paths to extra Plex scanners
    # group = "plexgroup"; # Group under which Plex runs
    # package = pkgs.plex; # Specific Plex package to use
    # user = "plexuser"; # User account under which Plex runs
  };
}
