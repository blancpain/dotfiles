# home.nix
# home-manager switch 

{ config, pkgs, ... }:

{
  home.username = "blancpain";
  home.homeDirectory = "/Users/blancpain";
  home.stateVersion = "23.05";

  # Makes sense for user specific applications that shouldn't be available system-wide
  home.packages =
    [
    ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  # home.file = {
  #   ".config/wezterm".source = ~/dotfiles/wezterm;
  #   ".config/starship".source = ~/dotfiles/starship;
  #   ".config/nvim".source = ~/dotfiles/nvim;
  #   ".config/nix".source = ~/dotfiles/nix;
  #   ".config/nix-darwin".source = ~/dotfiles/nix-darwin;
  #   ".config/tmux".source = ~/dotfiles/tmux;
  #   ".config/lazygit".source = ~/dotfiles/lazygit;
  #   ".config/aerospace".source = ~/dotfiles/aerospace;
  #   ".config/nushell".source = ~/dotfiles/nushell;
  # };
  home.file = {
    ".config/wezterm".source = ../wezterm;
    ".config/starship".source = ../starship;
    ".config/nvim".source = ../nvim;
    ".config/nix".source = ../nix;
    ".config/nix-darwin".source = ../nix-darwin;
    ".config/tmux".source = ../tmux;
    ".config/lazygit".source = ../lazygit;
    ".config/aerospace".source = ../aerospace;
    ".config/nushell".source = ../nushell;
  };

  home.sessionVariables =
    {
    };

  home.sessionPath = [
    "/run/current-system/sw/bin"
    "$HOME/.nix-profile/bin"
  ];
  programs = {
    # home-manager.enable = true;
    nushell = {
      enable = true;
      configFile.source = ../nushell/config.nu;
      envFile.source = ../nushell/env.nu;
      # configFile.source = ../nushell/config.nu;
      # envFile.source = builtins.path {
      #   name = "env.nu";
      #   path = ../nushell/env.nu;
      # };
    };
  };
}
