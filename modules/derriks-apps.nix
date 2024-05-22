{ config, pkgs, ... }: 

{
  # Add packages to the system environment
  environment.systemPackages = with pkgs; [
    bitwarden
    spot
    git
    keepassxc
    python312
    appimage-run
    papirus-icon-theme
    gnome.dconf-editor
    libreoffice-qt
    gnome.gnome-tweaks
    spotify
    tailscale
    vlc
    gimp
    wget
    libsForQt5.ghostwriter
    winetricks
    wine-staging
    pavucontrol
    fluffychat
    distrobox
    geany
    thunderbird
    ntfs3g
    appimage-run
    firefox
    flatpak
    mullvad-vpn
    discord
    kopia
    tdesktop
    flameshot
    microsoft-edge
    ollama
    screen
    nodejs
    pipx
    ncdu
    nvtop
    python311Packages.pip
    caffeine-ng
    php
    adapta-gtk-theme
    mlocate
    yt-dlp
    waybar
    wofi
    networkmanagerapplet
    kitty
    mako
    swaybg
    swaylock
    grim
    slurp
    jq
    wl-clipboard
    notify-desktop
    libnotify
    playerctl
    pamixer
    swayidle
    emojione
    xclip
    sway-contrib.grimshot
    gthumb
    xfce.thunar-archive-plugin
    xfce.thunar-volman
    unzip
    gnome.file-roller
    lxrandr
    pinta
    okular
    cinnamon.nemo-with-extensions
    plex-media-player
    virt-manager
  ];
}
