{ config, pkgs, ... }:

{
	
  # Configuring XDG portal with specific backend settings
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];  # Use the appropriate portal for your environment
    config = {
      common = {
        default = "*";  # Use the first portal implementation found, mimicking behavior < 1.17
      };
    };
  };

}
