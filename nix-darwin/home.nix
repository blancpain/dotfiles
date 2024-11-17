{
  config,
  pkgs,
  lib,
  ...
}:

let
  # Define the path to your dotfiles directory
  dotfilesPath = "/Users/blancpain/dotfiles";
in
{
  home.username = "blancpain";
  home.homeDirectory = "/Users/blancpain";
  home.stateVersion = "23.05";

  home.packages = [ ];

  # NOTE: old

  #   # Home Manager is pretty good at managing dotfiles. The primary way to manage
  #   # plain files is through 'home.file'.
  #   home.file = {
  #     ".config/wezterm".source = ../wezterm;
  #     ".config/starship".source = ../starship;
  #     ".config/nvim".source = ../nvim;
  #     ".config/nix".source = ../nix;
  #     ".config/nix-darwin".source = ../nix-darwin;
  #     ".config/tmux".source = ../tmux;
  #     ".config/lazygit".source = ../lazygit;
  #     ".config/aerospace".source = ../aerospace;
  #     ".config/nushell".source = ../nushell;
  #   };

  home.file = {
    ".config/wezterm".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/wezterm";
    ".config/starship".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/starship";
    ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/nvim";
    ".config/nix".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/nix";
    ".config/nix-darwin".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/nix-darwin";
    ".config/tmux".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/tmux";
    ".config/lazygit".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/lazygit";
    ".config/aerospace".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/aerospace";
    ".config/nushell".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/nushell";
    ".config/fish".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/fish";
  };

  home.sessionVariables = { };

  home.sessionPath = [
    "/run/current-system/sw/bin"
    "$HOME/.nix-profile/bin"
  ];

  programs = {
    # NOTE: nushell buggy on macOS still...

    # nushell = {
    #   enable = true;
    #   # configFile.source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/nushell/config.nu";
    #   # envFile.source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/nushell/env.nu";
    # };
  };
}
