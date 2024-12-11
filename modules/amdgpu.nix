{ config, pkgs, lib, ... }:
with lib;
{
  options.hardware.amd = {
    enable = mkEnableOption "AMD GPU support via the open-source amdgpu or radeon drivers";
  };

  config = mkIf config.hardware.amd.enable {
    # Early kernel module loading
    boot.initrd.kernelModules = [ "amdgpu" ];
    boot.kernelModules = [ "amdgpu" ];
    boot.blacklistedKernelModules = [ "fglrx" ];

    # Enable SI and CIK support
    boot.kernelParams = [ 
      "radeon.si_support=0" 
      "radeon.cik_support=0" 
      "amdgpu.si_support=1" 
      "amdgpu.cik_support=1"
    ];

    # X server configuration
    services.xserver = {
      videoDrivers = [ "amdgpu" ];
    };

    # OpenGL and Vulkan configuration
    hardware.opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;  # For 32-bit applications
      extraPackages = with pkgs; [
        amdvlk  # AMDVLK drivers alongside Mesa RADV
        rocmPackages.clr.icd  # OpenCL support
      ];
      # 32-bit support for AMDVLK
      extraPackages32 = with pkgs; [
        driversi686Linux.amdvlk
      ];
    };

    # Optional: For Polaris cards (Radeon 500 series) OpenCL support
    environment.variables = {
      ROC_ENABLE_PRE_VEGA = "1";
    };

    # Optional: For testing OpenCL setup
    environment.systemPackages = with pkgs; [
      clinfo
    ];
  };
}
