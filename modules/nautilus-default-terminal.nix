{ config, pkgs, lib, ... }:

{
  programs.nautilus-open-any-terminal = {
    enable = true;
    terminal = "kitty";
  };

  environment = {
    # Use lib.mkForce to ensure this value takes precedence over other definitions
    sessionVariables.NAUTILUS_4_EXTENSION_DIR = lib.mkForce "${pkgs.gnome.nautilus-python}/lib/nautilus/extensions-4";
    pathsToLink = [
      "/share/nautilus-python/extensions"
    ];

    systemPackages = [
      pkgs.gnome.nautilus
      pkgs.gnome.nautilus-python
    ];
  };
}
