{ config, pkgs, lib, ... }:

with lib;

{
  options.hardware.amd = {
    enable = mkEnableOption "AMD GPU support via the open-source amdgpu or radeon drivers";
  };

  config = mkIf config.hardware.amd.enable {
    boot.kernelModules = [ "amdgpu" "radeon" ];
    boot.blacklistedKernelModules = [ "fglrx" ];
    boot.kernelParams = [ "radeon.si_support=0 radeon.cik_support=0" "amdgpu.si_support=1 amdgpu.cik_support=1" ];
    hardware.opengl = {
      enable = true;
      extraPackages = with pkgs; [
        # Add any additional packages needed for specific AMD features or utilities
      ];
    };
  };
}
