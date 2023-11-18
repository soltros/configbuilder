{ config, pkgs, ... }:

{
  # Flatpak support
  services.flatpak.enable = true;
  xdg.portal.enable = true;

}
