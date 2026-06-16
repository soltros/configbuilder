{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Core Utilities
    fish
    rsync
    jq
    just
    btop
    ripgrep
    fd
    delta
    alien
    lm_sensors
    udiskie
    powertop
    smartmontools
    usbutils
    pciutils
    playerctl

    # Networking
    nebula
    nmap
    iperf3
    wireguard-tools

    # Gaming & Performance
    mangohud
    goverlay
    corectrl

    # Filesystems
    exfatprogs
    ntfs3g
    btrfs-progs

    # Apps
    gimp
    deja-dup
    papirus-icon-theme
    kdenlive
    kcalc
    filelight
    ark
    okular
    materia-theme

    # General CLI Tools
    git-lfs
    gnumake
    python3
    curl
    wget
    file
  ];
}
