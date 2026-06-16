{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  # These packages will only be available inside the nix-shell
  packages = with pkgs; [
    cmake
    gcc
    pkg-config
    curlpp
    vulkan-headers
    vulkan-loader
    shaderc
    glslang
    spirv-headers
    spirv-tools
    openssl.dev
    webkitgtk_4_1
    libappindicator-gtk3
    librsvg.dev
  ];

  shellHook = ''
    echo "Development environment loaded."
  '';
}
