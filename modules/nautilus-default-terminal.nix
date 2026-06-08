{ config, pkgs, lib, ... }:

{
  programs.nautilus-open-any-terminal = {
    enable = true;
    terminal = "alacritty";
  };

  environment = {
    # Use lib.mkForce to ensure this value takes precedence over other definitions
    sessionVariables.NAUTILUS_4_EXTENSION_DIR = lib.mkForce "${pkgs.nautilus-python}/lib/nautilus/extensions-4";
    pathsToLink = [
      "/share/nautilus-python/extensions"
    ];

    systemPackages = [
      pkgs.nautilus
      pkgs.nautilus-python
    ];
  };
}
