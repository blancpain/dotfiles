{
  config,
  pkgs,
  lib,
  ...
}:

{
  home.username = "blancpain";
  home.homeDirectory = "/Users/blancpain";
  home.stateVersion = "23.05";

  home.packages = [ ];

  home.file = {
    ".config/wezterm".source = config.lib.file.mkOutOfStoreSymlink ../wezterm;
    ".config/starship".source = config.lib.file.mkOutOfStoreSymlink ../starship;
    ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink ../nvim;
    ".config/nix".source = config.lib.file.mkOutOfStoreSymlink ../nix;
    ".config/nix-darwin".source = config.lib.file.mkOutOfStoreSymlink ../nix-darwin;
    ".config/tmux".source = config.lib.file.mkOutOfStoreSymlink ../tmux;
    ".config/lazygit".source = config.lib.file.mkOutOfStoreSymlink ../lazygit;
    ".config/aerospace".source = config.lib.file.mkOutOfStoreSymlink ../aerospace;
    ".config/nushell".source = config.lib.file.mkOutOfStoreSymlink ../nushell;
    ".config/fish".source = config.lib.file.mkOutOfStoreSymlink ../fish;
  };

  home.sessionVariables = { };

  home.sessionPath = [
    "/run/current-system/sw/bin"
    "$HOME/.nix-profile/bin"
  ];

  programs = {
    # NOTE: nushell buggy on macOS still - can't set as default shell

    # nushell = {
    #   enable = true;
    #   # configFile.source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/nushell/config.nu";
    #   # envFile.source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/nushell/env.nu";
    # };
  };
}
