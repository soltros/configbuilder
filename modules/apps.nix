{ config, pkgs, ... }: 

{
  # Add packages to the system environment
  environment.systemPackages = with pkgs; [
];
}
