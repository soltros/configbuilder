{
  # this is not a complete flake.nix
  description = "Plasma 6";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    kde2nix.url = "github:nix-community/kde2nix";
  };

  outputs = { self, nixpkgs, kde2nix, ... }: {
    nixosConfigurations.yourHostnameHere = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        kde2nix.nixosModules.plasma6
        ./configuration.nix
        ./networking.nix
        ({ services.xserver.desktopManager.plasma6.enable = true; })
      ];
    };
  };
}
