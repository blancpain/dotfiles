{
  config,
  pkgs,
  lib,
  ...
}:

let
  # path to dotfiles
  dotfilesPath = "/Users/blancpain/dotfiles";
in
{
  home.username = "blancpain";
  home.homeDirectory = "/Users/blancpain";
  home.stateVersion = "23.05";

  home.packages = [ ];

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
    ".config/karabiner".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/karabiner";
    ".config/skhd".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/skhd";
    ".config/yabai".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/yabai";
    ".config/ghostty".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/ghostty";
    ".config/helix".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/helix";
    "Library/Application Support/Code/User".source =
      config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/Code/User";
    "Library/Application Support/Cursor/User".source =
      config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/Cursor/User";
    ".cursor".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/Cursor/.cursor";
    "Library/Application Support/Windsurf/User".source =
      config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/Windsurf/User";
    ".aider.conf.yml".source =
      config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/aider/.aider.conf.yml";
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
