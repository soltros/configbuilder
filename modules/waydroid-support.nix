{ config, pkgs, ... }:

{
  # Enable WayDroid
  virtualisation.waydroid.enable = true;

  # Additional configurations and notes:
  # 1. You may need to adjust settings if you have an NVIDIA card or an RX 6800 series:
  #    - Edit /var/lib/waydroid/waydroid_base.prop and set:
  #      ro.hardware.gralloc=default
  #      ro.hardware.egl=swiftshader
  # 2. For Linux kernel 5.18 and later, set sys.use_memfd=true in waydroid_base.prop
  # 3. Add wl-clipboard to system packages for clipboard support:
  #    environment.systemPackages = with pkgs; [ wl-clipboard ];

  # Post-installation steps:
  # - Run 'sudo waydroid init' to fetch WayDroid images.
  # - You can add "-s GAPPS -f" to the init command for GApps support.
  # - Start the WayDroid container with 'sudo systemctl start waydroid-container'.
  # - Begin a WayDroid session with 'waydroid session start'.
}
