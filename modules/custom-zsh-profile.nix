{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    
    # NixOS native toggles for the custom plugins
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;

    ohMyZsh = {
      enable = true;
      theme = "terminalparty";
      plugins = [
        "git"
      ];
    };

    shellAliases = {
      # Adapted for NixOS
      update = "sudo nixos-rebuild switch --upgrade && flatpak update -y && sudo snap refresh";
      tolaria-update = "echo 'updating Tolaria...'; sudo tolaria-update";
    };

    promptInit = ''
      export LANG=en_US.UTF-8
      export EDITOR="nano"
      export VISUAL="nano"
      export PATH="$PATH:$HOME/.local/bin"

      # Initialize Starship
      if command -v starship &> /dev/null; then
          eval "$(starship init zsh)"
      fi
    '';
  };

  # Make Zsh the default shell for users
  users.defaultUserShell = pkgs.zsh;

  # Ensure Starship is installed system-wide
  environment.systemPackages = [ pkgs.starship ];
}
