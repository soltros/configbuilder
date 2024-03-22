final: prev: {
  # Example to fetch Plasma 6 packages from unstable
  kdeFrameworks = prev.kdeFrameworks.override {
    overlays = [ (self: super: {
      plasma-desktop = super.plasma-desktop.overrideAttrs (old: {
        src = final.fetchFromGitHub {
          owner = "NixOS";
          repo = "nixpkgs";
          rev = "revision-of-unstable-where-plasma6-is";
          sha256 = "sha256-of-plasma6-src";
        };
      });
    }) ];
  };
}
