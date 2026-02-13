{
  config,
  pkgs,
  lib,
  ...
}:

let
  dotfilesPath = "${config.home.homeDirectory}/dotfiles";
in
{
  imports = [ ./common.nix ];

  # macOS-specific packages
  home.packages = with pkgs; [
    # macOS specific nix pkgs go here
  ];

  # macOS-specific symlinks
  home.file = {
    ".config/karabiner".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/karabiner";
    ".hammerspoon".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/hammerspoon";
    ".config/skhd".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/skhd";
    ".config/yabai".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/yabai";
    ".config/ghostty".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/ghostty";
    "Library/Application Support/Code/User".source =
      config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/Code/User";
    "Library/Application Support/Cursor/User".source =
      config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/Cursor/User";
    "Library/Application Support/Windsurf/User".source =
      config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/Windsurf/User";
  };
}
