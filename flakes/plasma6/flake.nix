{
  description = "Plasma 6 beta";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    kde2nix.url = "github:nix-community/kde2nix";
  };

  outputs = { self, nixpkgs, kde2nix, ... }: {
    nixosConfigurations.b450m-d3sh = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ({ pkgs, ... }: {
          imports = [
            kde2nix.nixosModules.plasma6
          ];
           })
        ./configuration.nix
        ./networking.nix
      ];
    };
  };
}
