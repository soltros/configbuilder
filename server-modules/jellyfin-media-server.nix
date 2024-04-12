{ config, pkgs, lib, ... }:
{
  # Basic setup to enable Jellyfin
  services.jellyfin.enable = true;
  services.jellyfin.openFirewall = true;

  # Packages necessary for Jellyfin
  environment.systemPackages = with pkgs; [
    jellyfin
    jellyfin-web
    jellyfin-ffmpeg
    xteve
  ];

  # Advanced hardware transcoding setup using VAAPI (Intel)
  nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override {
      enableHybridCodec = true;
    };
  };
  
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
      intel-compute-runtime # OpenCL filter support (hardware tonemapping and subtitle burn-in)
    ];
  };
  # Access Jellyfin via: http://localhost:8096
}
