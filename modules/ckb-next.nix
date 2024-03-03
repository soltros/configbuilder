{ config, pkgs, ... }:

{
  # Enable the ckb-next driver for Corsair devices
  hardware.ckb-next.enable = true;
  hardware.ckb-next.package = true;
  
  # Define the package to use for ckb-next, typically it is not necessary to change this
  # as it will use the default package from nixpkgs.
  # However, if you need a custom or specific version, you can override it like so:
  # hardware.ckb-next.package = pkgs.ckb-next.override { ... };

  # Set the GID for the ckb-next daemon, if needed.
  # This is typically only necessary if you have a specific requirement for group id.
  # hardware.ckb-next.gid = <desired-group-id>;

  # You can add additional configuration here as needed.
}
