{ config, pkgs, lib, ... }:

with lib;

{
  options.hardware.intel = {
    enable = mkEnableOption "Intel GPU support via the i915 driver for optimal performance and feature set";
  };

  config = mkIf config.hardware.intel.enable {
    boot.kernelModules = [ "i915" ];
    boot.kernelParams = [ "i915.enable_fbc=1" "i915.enable_guc=3" ];
    hardware.opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [
        # Add any additional packages needed for specific Intel features or utilities
      ];
    };

    # Optional: Enable VA-API (Video Acceleration API) for better video playback performance
    services.xserver.videoDrivers = [ "modesetting" ];
    hardware.video.accelerated = true;
  };
}
