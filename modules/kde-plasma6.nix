{ config, pkgs, lib, ... }:

{
  options = {
    environment.enablePlasma6 = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Plasma 6 desktop environment.";
    };
  };

  config = lib.mkIf config.environment.enablePlasma6 {
    # Plasma 6
    nixpkgs.overlays = [ overlay-unstable ];
                services.xserver.enable = true;
                services.xserver.displayManager.sddm.enable = true;
                services.xserver.displayManager.defaultSession = "plasma";
                services.xserver.displayManager.sddm.wayland.enable = true;
                services.xserver.desktopManager.plasma6.enable = true;
                environment.plasma6.excludePackages = with pkgs.kdePackages; [ ];
                programs.gnupg.agent.pinentryPackage = pkgs.lib.mkForce pkgs.pinentry-qt;

    environment.systemPackages = with pkgs; [
      # Assuming you have packages or customizations specific to Plasma 6
      # You can add them here
    ];

    programs.gnupg.agent.pinentryPackage = lib.mkForce pkgs.pinentry-qt;
    # Additional configurations...
  };
}
