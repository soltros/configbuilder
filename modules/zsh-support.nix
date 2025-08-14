{ config, pkgs, ... }:

{
  # Enable zsh system-wide
  programs.zsh = {
    enable = true;
    
    # Enable Oh My Zsh
    ohMyZsh = {
      enable = true;
      plugins = [ 
        "git" 
        "sudo" 
        "docker" 
        "kubectl" 
        "history-substring-search"
        # Remove zsh-autosuggestions from here since it's handled below
      ];
      theme = "terminalparty";
      custom = "$HOME/.oh-my-zsh/custom";
    };
    
    # Enable completion for system packages
    enableCompletion = true;
    
    # Enable auto-suggestions (NixOS will handle this properly)
    autosuggestions.enable = true;
    
    # Syntax highlighting
    syntaxHighlighting.enable = true;
    
    # Shell aliases that work across the system
    shellAliases = {
      ll = "ls -l";
      la = "ls -la";
      ".." = "cd ..";
      "..." = "cd ../..";
      grep = "grep --color=auto";
    };
    
    # Additional shell init for zsh-specific configurations
    shellInit = ''
      # Set up history
      export HISTSIZE=10000
      export SAVEHIST=10000
      setopt SHARE_HISTORY
      setopt HIST_IGNORE_DUPS
      setopt HIST_IGNORE_SPACE
      
      # Enable case-insensitive completion
      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
      
      # Better completion menu
      zstyle ':completion:*' menu select
      
      # Load colors for ls and completion
      autoload -U colors && colors
    '';
  };

  # Set zsh as the default shell for all users
  users.defaultUserShell = pkgs.zsh;
  
  # Make sure zsh is in /etc/shells
  environment.shells = with pkgs; [ zsh ];
  
  # Optional: Install additional zsh-related packages
  environment.systemPackages = with pkgs; [
    zsh-completions
    zsh-autosuggestions
    zsh-syntax-highlighting
    zsh-history-substring-search
  ];

  # Optional: Set environment variables that work well with zsh
  environment.variables = {
    # Make less more friendly for non-text input files
    LESSOPEN = "|${pkgs.lesspipe}/bin/lesspipe.sh %s";
    LESS = "-R";
  };
}